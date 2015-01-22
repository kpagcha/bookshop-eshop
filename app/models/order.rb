class Order < ActiveRecord::Base
  has_many :order_items
  has_many :books, :through => :order_items

  attr_accessor :card_type, :card_number, :card_expiration_month, :card_expiration_year, :card_verification_value
	
  accepts_nested_attributes_for :order_items
  validates_presence_of :order_items, :message => 'Your shopping cart is empty!'
  validates_format_of :email, :with =>  /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates_length_of :phone_number, :in => 7..20

  validates_length_of :first_name, :in => 2..255
  validates_length_of :last_name, :in => 2..255
  validates_length_of :address, :in => 2..255
  validates_length_of :city, :in => 2..255
  validates_length_of :postal_code, :in => 2..255
  validates_length_of :country_code, :in => 2..255

  validates_length_of :customer_ip, :in => 7..15
  validates_inclusion_of :status, :in => %w(open processed closed failed)

  validates_inclusion_of :card_type, :in => ['Visa', 'MasterCard', 'American Express', 'Discover'], :on => :create
  validates_length_of :card_number, :in => 13..19, :on => :create
  validates_inclusion_of :card_expiration_month, :in => %w(1 2 3 4 5 6 7 8 9 10 11 12), :on => :create
  validates_inclusion_of :card_expiration_year, :in => %w(2014 2015 2016 2017 2018 2019 2020 2021), :on => :create
  validates_length_of :card_verification_value, :in => 3..4, :on => :create

  def total
  	order_items.inject(0) { |sum, n| n.price * n.amount + sum }
  end

  def process
    begin
      raise 'The order is closed, it cannot be processed again' if self.closed?
      active_merchant_payment
    rescue => e
      logger.error("Order #{id} has failed due to an exception: #{e}.")
      self.error_message = "Exception: #{e}"
      self.status = 'failed'
    end
    save!
    self.processed?
  end

  def active_merchant_payment
    ActiveMerchant::Billing::Base.mode = :test
    ActiveMerchant::Billing::AuthorizeNetGateway.default_currency = 'USD'
    ActiveMerchant::Billing::AuthorizeNetGateway.wiredump_device = STDERR   
    ActiveMerchant::Billing::AuthorizeNetGateway.wiredump_device.sync = true
    self.status = 'failed'

    creditcard = ActiveMerchant::Billing::CreditCard.new(
      :brand              => card_type,
      :number             => card_number,
      :month              => card_expiration_month,
      :year               => card_expiration_year,
      :verification_value => card_verification_value,
      :first_name         => first_name,
      :last_name          => last_name
    )

    if creditcard.valid?
      gateway = ActiveMerchant::Billing::AuthorizeNetGateway.new(
        :login     => '8jHK88bQ',
        :password  => '98yw4Rk4T7nZ2K7B'
      )

      shipping_address = {
        :first_name => first_name,
        :last_name  => last_name,
        :address1   => address,
        :city       => city,
        :zip        => postal_code,
        :country    => country_code,
        :phone      => phone_number
      }

      details = {
        :description      => 'Bookshop order',
        :order_id         => self.id,
        :email            => email,
        :ip               => customer_ip,
        :billing_address  => shipping_address,
        :shipping_address => shipping_address
      }

      eucentralbank = EuCentralBank.new
      eucentralbank.update_rates

      amount = eucentralbank.exchange((self.total * 100).to_i, 'EUR', 'USD').cents
      response = gateway.purchase(amount, creditcard, details)

      if response.success?
        self.status = 'processed'
      else
        self.error_message = response.message
      end
    else
      self.error_message = 'Invalid credit card'
    end
  end

  def processed?
    self.status == 'processed'
  end

  def failed?
    self.status == 'failed'
  end

  def closed?
    self.status == 'closed'
  end

  def close
    self.status = 'closed'
    save!
  end
  
end

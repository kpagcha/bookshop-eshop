class AdminController < ApplicationController
	before_action :authentication_required

	private
	def authentication_required
		if !admin_signed_in?
			flash[:notice] = 'This page is restricted for admins.'
		end
		authenticate_admin!
	end
end
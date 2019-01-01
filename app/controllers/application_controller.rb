class ApplicationController < ActionController::Base
	before_action :configure_permitted_parameters, :if => :devise_controller?
	layout :layout_by_resource

	protected

	def layout_by_resource
		if devise_controller?
		"devise_layout"
		else
		"application"
		end
	end

	def configure_permitted_parameters
		devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :nickname, :role, :phone, :skype])
	end

end

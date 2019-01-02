class ApplicationController < ActionController::Base
	before_action :configure_permitted_parameters, :if => :devise_controller?
	layout :layout_by_resource
	around_action :set_time_zone, if: :user_time_zone_present?

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

	private
    def set_time_zone(&block)
      Time.use_zone(current_user.time_zone, &block)
    end
 
    def user_time_zone_present?
      current_user.try(:time_zone).present?
    end

end

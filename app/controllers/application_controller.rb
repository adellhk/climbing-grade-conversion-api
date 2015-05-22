class ApplicationController < ActionController::API
	skip_before_filter :verify_authenticity_token
	
	before_filter :cors_preflight_check
	after_filter :cors_set_access_control_headers
	
	def cors_set_access_control_headers
		puts 'in cors_set_access_control_headers'
		headers['Access-Control-Allow-Origin'] = '*'
		headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
		headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Accept, Authorization, Token'
		headers['Access-Control-Max-Age'] = "1728000"
	end
	
	def cors_preflight_check
		# puts 'In cors_preflight_check!' * 20
		puts request.method
		if request.method == 'OPTIONS'
			headers['Access-Control-Allow-Origin'] = '*'
			headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
			headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-Prototype-Version, Token'
			headers['Access-Control-Max-Age'] = '1728000'
			render :text => 'cors_preflight_check', :content_type => 'text/plain'
		end
	end
	
end

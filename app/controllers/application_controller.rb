# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.


require 'functions'
require 'wylieConverter'


class ApplicationController < ActionController::Base	
	helper :all # include all helpers, all the time

	# See ActionController::RequestForgeryProtection for details
	# Uncomment the :secret if you're not using the cookie session store
	protect_from_forgery # :secret => '309c9a1ccf13f0a31d5d387ba119bc03'
  
	def authenticate
		if not user?
			authenticate_or_request_with_http_basic do |user,password|	  
				@user = User.find(:first, :conditions => "name = '#{user}' and pw = '#{password}'")	 
				user==@user.name && password==@user.pw
			end
		end  
	end #end authenticate 
  
  
	def back
	  redirect_to(:back)
	end
	
	
	# Cookies im Browser zugelassen ?	
	def cookies_enabled?		
		cookie?("_dict_session")
	end #end cookies_enabled?
  	
  		
	# Setzt Cookie mit einem Jahr Lebenszeit
	def set_cookie(name, data_str)		
		cookies[:"#{name}"] = {            		
				:value => data_str,
				:expires => 1.year.from_now
		}						
	end #end set_cookie
		
			
	# Existiert Cookie mit Name name
	def cookie?(name)
		cookies[:"#{name}"] != nil
	end #end cookie?
	
  
end #end ApplicationController

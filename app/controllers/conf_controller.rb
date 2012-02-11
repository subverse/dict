class ConfController < ApplicationController
		
		
	layout 'application'
	
		
	def index 				
		if cookies_enabled?	
			@cookie = cookie?("conf")
			if @cookie  
				@ind_cat = config("cat")
				@ind_grm = config("grm")
				@ind_font = config("font")    
				@ind_tib = config("tib")
			else	
				set_cookie("conf", "0,0,1,0")				 
				@cookie = cookie?("conf")				
			end
		else
			@cookie = false
		end			
	end #end index


	def store 		
		@show_cat = 1
		@show_cat = 0 if params[:show_cat] == nil 
		@show_grm = 1    
		@show_grm = 0 if params[:show_grm] == nil 
		@font = 1    
		@font = 0 if params[:font] == nil 
		@show_tib = 1
		@show_tib = 0 if params[:show_tib] == nil 
		val_arr = [@show_cat,@show_grm,@font,@show_tib].join(",")	
		set_cookie("conf", val_arr)		 			
		redirect_to :action => "show"		  						
	end #end store
  
  
	def show
		@cat = config("cat")
		@grm = config("grm")
		@font = config("font")    
		@tib = config("tib")  
	end #end show
  
  
	private 
			
  	################# config verschieben in app_contr !e> app_helper
  	
  	# config abrufen
	def config(arg)
		config = cookies[:"conf"] 
		if config != nil 
			config = config.split(",")
			result = case arg
				when "cat" : 0
				when "grm" : 1
				when "font": 2
				when "tib" : 3
				else nil
			end   
			erg = config.at(result) == "1"	
		else
			erg = false				
		end  	
		return erg
	end #end config
  
    
end #end conf_controller


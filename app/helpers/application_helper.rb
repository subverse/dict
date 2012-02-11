# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
    
  require 'wylieConverter'


  #---auth--------------------------------------------------------------

	
  def admin?
    session[:admin] == true
  end
  
  def user?
    admin? or not session[:user_id] == nil
  end  
  
  
	#---mobile_devices--------------------------------------------------
	
	# device sniffer (Mobile Safari user agent)
	def iphone?
		request.env["HTTP_USER_AGENT"] && request.env["HTTP_USER_AGENT"][/(Mobile\/.+Safari)/]
	end
	
	
	#---tibetan_unicode-------------------------------------------------
	
	def get_tibetan_hex(param)    	  
		WylieConverter.tuc(param)    	
	end # get_tibetan_hex
	
	def get_tib_num_hex(num) # Gibt eine übergebene Zahl, als tibetische Zahl zurück. 
	  args = num.to_s.split("")
		num_arr = Array.new
		args.each do |arg|
		  num_arr.push(WylieConverter.tuc(arg))
		end
		num_arr.join("")
	end # get_tib_num_hex
   
  
  #-------------------------_WYILE_CONVERTER----------------------------

  def convert(arg)
    WylieConverter.convert(arg)
  end
	
  #---functional----------------------------------------------------------------------------
    
  def my_submit_tag(text)
    submit_tag text, :style => "border:none; width:48pt"	
  end
  
	#--------used_for_internal_linking--------------------------------------------------------
	
  def my_link_to(title,controller,action,id)
    link_to title, {:controller => controller, :action => action, :id => id}, {:class => "link_to"}
  end 
   
  def my_link_to_path(title, path)
    link_to title, path, {:class => "link_to" }
  end
   
	#------extern_weblinks--------------------------------------------------------------------
    
	def my_link_to_ext(txt,url)	
	  link_to txt, url, {:target => "_blank", :class=>"link_ext"} 
	end
		
  #---Operational---------------------------------------------------------------------------
  
  #Operationen auf Datensatz  

  def my_link_to_show(data)
    link_to image_tag("info.png", :border=>0), data, :title => "Details anzeigen"
  end
  
  def my_link_to_edit(path)
    link_to image_tag("edit.png", :border=>0), path,{:class => "link_to" } 
  end
  	
  def my_link_to_drop(data,typ)
    s = "Drop? "
		prompt = case typ
			when "voc" then s = s + ": #{data.german} - #{data.wylie}"
			when "temp" then s = s + ": #{data.german}"
			when "grm" then s = s + ": #{data.grm}"
			when "cat" then s = s + ":#{data.cat}"
			else s = "Drop?"
    end	
    link_to image_tag("drop.png", :border=>0), data, :confirm => s, :method => :delete
  end # my_link_to_drop     
   
  #Einfügen von voc in Temp  
  def my_link_to_temp(voc)
	  link_to image_tag("temp.png", :border=>0), {:controller => "temps", :action => "new",  
															:params => {  :german => voc.german,
                                                            :wylie => voc.wylie,
															:grm => voc.grm,
															:cat => voc.cat,
															:note => voc.note }}	 
  end # to_temp   
	
  #Einfügen von voc in eList  
  def my_link_to_eList(voc)
	  link_to image_tag("temp.png", :border=>0), {:controller => :lists,
                                                :action => :new, 
                                                :params => { :item=> voc.id }},
                                                :title => "Zu eList hinzuf&uuml;gen"
  end # to_temp
  
  
  #---------CONFIG_aus_CONF-COOKIE_AUSLESEN----------------------------
  
  
	def config(arg)
		if cookies[:"conf"] == nil          # dann existiert kein cookie  
			cookies[:"conf"] = {            # setze cookie 'conf' 
				:value => '0,0,1,0',        # cat, grm, font, tib_lists
				:expires => 1.year.from_now # Verfallsdatum jetzt+1Jahr
			}  
		end		
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
		else							   # dann sind coockies geblockt	
			erg = false
		end  				
		return erg
	end # end config
	
  
end # application_helper

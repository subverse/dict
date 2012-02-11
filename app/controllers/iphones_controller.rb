class IphonesController < ApplicationController
	
	
	def index
		
	end #end index
		
	
	def isearch		
		render :layout => false
	end
	
	
	# GET /vocs/1
	# GET /vocs/1.xml
	# Eintrag anzeigen
	def show_data
		@val = params[:val]
		@lang = params[:lang]
		result = Voc.find_details(params[:id])
		@voc = result.at(0)     
		@vocs_syn_de = result.at(1)			    
		@vocs_syn_tib = result.at(2)
		@t = "" #WylieConverter.convert(@voc.wylie)   	
		render :layout => false
	end #end show
	
	
	# GET /vocs/1
	# GET /vocs/1.xml
	# Eintrag anzeigen
	def show_voc  
		result = Voc.find_details(params[:id])
		@voc = result.at(0)     
		@vocs_syn_de = result.at(1)			    
		@vocs_syn_tib = result.at(2)
		@t = "" #WylieConverter.convert(@voc.wylie)   	
		render :layout => false
	end #end show
  
  
	# Suchbegriff deutsch
	def search
		@search = params[:german].strip
		if @search.count("'") != 0 || @search.length == 0
			@vocs  = Array.new
			@vocs_rest = Array.new
		else  	  
			result = Voc.find_german(@search)  		        
			@vocs = result.at(0)
			@vocs_rest = result.at(1)
		end      
		@num_rest_rows = @vocs_rest.length				
	end #end search german
  
	
	# Suchbegriff wylie
	def search1
		@search = params[:search1].strip	  
		if @search.length == 0
			@vocs  = Array.new
			@vocs_rest = Array.new
		else      
			result = Voc.find_wylie(@search)
			@vocs = result.at(0)
			@vocs_rest = result.at(1)             
		end  
		@num_rest_rows = @vocs_rest.length			
	end #end search1 wylie
	
		
	# Zuletzt hinzugefügte Ausdrücke anzeigen
	def last	
		@vocs = Voc.find(:all, :conditions => "timestamp >= CURRENT_DATE AND timestamp < CURRENT_DATE + INTERVAL 1 DAY",
							:order=>'german ASC, wylie ASC')	 	  			
		@vocs = Functions.disparse_all_a(@vocs)
		render :layout => false 
	end	#end last
	
	
	def	cats
		@categories = Category.find(:all, :order=>'cat ASC')		    
		@num_rows = @categories.length		
	
		@h_cats_n = Array.new	
		@categories.each do |category|			
		vocs = Voc.find_cat(category.cat)
			@h_cats_n.push(vocs.length)
		end
		tmp = @h_cats_n.join(";")
		tmp = tmp.reverse
		@h_cats_n = tmp.split(";")
		n = @h_cats_n.length-1
		for i in 0..n
			@h_cats_n[i] = @h_cats_n.at(i).reverse
		end
	
		render :layout => false  
	end
	
	
	def show_cats
		@category = Category.find(params[:id])		    		 
		@vocs = Voc.find_cat(@category.cat)
		@vocs = Functions.disparse_all_a(@vocs)
		@num_rows = @vocs.length	
		render :layout => false 
	end
	
	
	def grms
		@grammars = Grammar.find(:all, :order=>'grm ASC')
		@num_rows = @grammars.length	
		@h_grms_n = Array.new	
		@grammars.each do |grammar|      
			vocs = Voc.find_grm(grammar.grm)
			@h_grms_n.push(vocs.length)
		end
		tmp = @h_grms_n.join(";")
		tmp = tmp.reverse
		@h_grms_n = tmp.split(";")
		n = @h_grms_n.length-1
		for i in 0..n
		@h_grms_n[i] = @h_grms_n.at(i).reverse
		end	
		render :layout => false
	end
	
	
	def show_grms
		@grammar = Grammar.find(params[:id])    
		@vocs = Voc.find_grm(@grammar.grm)
		@vocs = Functions.disparse_all_a(@vocs)
		@num_rows = @vocs.length	
		render :layout => false
	end
	
	
#!end-----class ListsController < ApplicationController

	
	# Gesamte Liste ausgeben
	def show_eList  
		if cookies_enabled?					# Cookies im Browser aktiv 
			@cookie = true					
			if cookie?("eList") == false	# Dann existiert kein eList-Cookie
				set_cookie("eList", "")		# Leeres eList-Cookie setzen 					
			end			
		else      							# Cookies im Browser gesperrt
			@cookie = false				
		end					
		@list = get_list_data       		# @list erzeugen (wenn kein Cookie => @list.length = 0
		render :partial => false
	end #end index

	
	# Neuen Eintrag hinzufuegen
	def new    								
		add_to_list(params[:item])			# Eintrag in Cookie schreiben
		#redirect_to :action => 'index'		# zurueck zur Listen-Ansicht
		render :nothing => true
	end #end new

	
	# Eintrag loeschen  !!!!! => show wird statt del ausgefuehrt 
	def del
		#methode ruft show auf ==> !?! ==> err aber funktioniert
	end #end del

	
	# löscht Eintrag aus Liste <=> :action :del !=> route-Err
	def show  
		list = get_list							# Liste auslesen
		list.delete_at(params[:item].to_i-1)    # Eintrag loeschen
		cookies[:"eList"] = { :value => list.join(" ") }        
		redirect_to :action => 'index'
	end #end show
		

	private
   
  
	# Eintrag in cookie speichern
	def add_to_list(item)
	# Datenstruktur : voc.id   
		list = get_list    
		list.push(item)
		new_list = list.join(" ")
		cookies[:"eList"] = { :value => new_list }          
	end #end add_to_list
   
	
	# returns array of voc.ids
	def get_list                  
		list = cookies[:"eList"]     # liest Rohdaten (string) aus cookie
		if list == nil              # Liste ist leer  
			list = Array.new          # erzeuge neue Liste 
		else                        # Liste enthält Eintrag 
			if list.length > 0         
				list = list.split(" ")  #erzeuge lesbare Liste (Array) aus Rohdatensatz
			else
				list = Array.new      
			end   
		end  
		return list    
	end #end get_list
  
  
	# Lesbare Liste erzeugen
	def get_list_data
		list_data = Array.new
		list = get_list
		list.each do |item|
			voc = Voc.find(item)
			voc.wylie = Functions.disparse_a(voc.wylie)	
			list_data.push( voc )
		end
		return list_data
	end #end get_list_data
  
  
#!end-----#end ListsController

end

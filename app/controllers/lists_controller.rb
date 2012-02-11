class ListsController < ApplicationController


	require 'functions'	

	
	# Gesamte Liste ausgeben
	def index    
		if cookies_enabled?					# Cookies im Browser aktiv 
			@cookie = true					
			if cookie?("eList") == false	# Dann existiert kein eList-Cookie
				set_cookie("eList", "")		# Leeres eList-Cookie setzen 					
			end			
		else      							# Cookies im Browser gesperrt
			@cookie = false				
		end					
		@list = get_list_data       		# @list erzeugen (wenn kein Cookie => @list.length = 0
	end #end index

	
	# Neuen Eintrag hinzufuegen
	def new    								
		add_to_list(params[:item])			# Eintrag in Cookie schreiben
		redirect_to :action => 'index'		# zurueck zur Listen-Ansicht
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
  
  
end #end ListsController

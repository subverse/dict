class ListquestController < ApplicationController
      
  
	require 'questModule'
	layout 'application'
 
 
	# Setup nur wenn Eintraege in eList
	def index  
		cookie = cookies[:"eList"]
		if cookie == nil 
			@info = "Cookies durch Browser geblockt !"	
		elsif cookie == ""
		   @info = "Deine eList enth&auml;lt keine Eintr&auml;ge."
		elsif
			respond_to do |format|
				format.html # index.html.erb
			end            
		end	
	end #end index
	
    
    # Liste initialisieren und Quest starten
	def start	
		dir_h = Hash.[]("td"=>"tibetisch-deutsch","dt"=>"deutsch-tibetisch")
		dir = params[:dir]							# Richtung 
		@dir = dir_h[dir]
		order_h = Hash.[]("random"=>"zuf&auml;llig", "straight"=>"absteigend",
				"reverse"=>"aufsteigend")
		order = params[:order] 						# Listenordnung
		@order = order_h[order]
		QuestModule.questList(dir, order, vocs)   	# Liste erstellen
		render :layout => false  					
	end #end start
		
		
	# Naechsten Eintrag uebergeben
	def question
	    @dir = QuestModule.dir 	   					
		@item = QuestModule.get_next				
		render :layout => false          
	end #end question

	
	# Ergebnis pruefen
	def check    
		@dir = QuestModule.dir 	 
		@request = params[:request]
		@answer = params[:answer]
		@answer = "no entry" if @answer == ""
		@correct = QuestModule.answer
		@check = QuestModule.eval(params[:answer])
		render :layout => false			
	end #end check
  
	
	private
  
  
	# entfernt doppelte Eintraege aus Liste
	def del_doubles(arr)
		tmp = arr.uniq
		if tmp != nil
			erg = tmp
		else
			erg = arr    
		end
		return erg
	end #end del_doubles
  
  
	# vocs zum Initialisieren der questList
	def vocs			               	
		raw = cookies[:"eList"]      	# liest Rohdaten (string) aus cookie    
		voc_arr = Array.new    
		voc_ids = raw.split(" ")  		# id-Liste erstellen	    
		voc_ids = del_doubles(voc_ids)  # doppelte Eintraege entfernen
		voc_ids.each do |id|  			# Durchlaufe gesamte Liste
			voc_arr.push(Voc.find(id))	# in voc_arr einfuegen 
		end
		return voc_arr					# hier evtl. noch nil-werte loeschen    
	end #end vocs
    
	
end #end listquest_controller

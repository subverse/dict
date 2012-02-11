# questClass definiert Liste und ihre Eintraege (lib)

# Modelliert einen Eintrag der quest-Liste
class Item
  
    # after initialize
	# reader : attr_reader :var1,.. , :varN
	# writer : attr_writer :var1,.. , :varN
	# reader and writer : attr_accessor :var1,.. , :varN	
    
    
    # Eintrag wird angelegt
	def initialize(arg1,arg2)
		@content1 = arg1				# arg1 als string (Aufgabe)
		@content2 = arg2				# arg2 als string (Loesung)
		@ok = false						# ok = falsch => rep = wahr
		@rep = true          			# Indikator zur Wiederholung	
    end #end initialize
  
  
	attr_accessor :content1, :content2, :ok, :rep 	# getter/setter
  
  
	# Wertet einen Eintrag aus
	def eval(arg)						# Rueckgabe auf content2
		@ok = @content2 == arg			# content2 : Loesung
		@rep = !@ok						# ok = falsch => rep = wahr
		return @ok	
	end #end eval
  
  
end #end class item



# Liste (mit next) zur Abfrage von Cookie-Eintraegen
class QuestList
	
	
	# Items aus cookie-Inhalt erzeugen      
	def initialize(dir, order, vocs)	# Richtung, Ordnung, Vocs
		@vocs = vocs					# vocs_array
	    @dir = dir						# Abfragerichtung (td, dt)
		@order = order					# Listenordnung (vw, rw, rand)		
	    @list = Array.new				# Leere Liste definieren.	
	   	   
	    @vocs.each do |v|    
			if @dir == "dt"    	    			# Richtung d =>> t
				@list.push(Item.new(v.german, v.wylie))# Neuer Eintrag in Liste		 			
			elsif @dir == "td"					# Richtung t =>> d	
				@list.push(Item.new(v.wylie, v.german))# Neuer Eintrag in Liste		 			
			end	
	    end   
	    
		@list.reverse 			
	end #end initialize
		
	
	# Naechster Eintrag
	def get_next		
	    blancs = Array.new			# blanc-Liste initialisieren
	    @list.each do |li|			# Durchlaufe alle Listeneintraege
	        if li.rep				# Dann wird Eintrag repetiert   	
				blancs.push(li)		# Erzeuge Eintrag in blanc-Liste
			end			
	    end		
	    if blancs.length > 0	    # Dann ist ein Eintrag repetierbar
	        if @order == "random"			  	   # Zufall
				blancs = blancs.sort_by { rand }   # zufaellig sortieren		  	
				item = blancs.shift				   # erster Eintrag 	
			end 								       
			item = blancs.shift	if @order == "straight"  # Vorwaerts				
			item = blancs.pop if @order == "reverse"  	 # Rueckwaerts			
	    end
	    return item					
	end #end get_next
  
	
end #end QuestList

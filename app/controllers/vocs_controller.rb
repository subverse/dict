class VocsController < ApplicationController
    
  
	layout 'application'
 
 
	verify :except => ["index", "show", "search", "search1", "search2", "search3", "search4","last","alpha"],
			:session => :admin,
			:add_flash => {:error => "Sie sind nicht angemeldet!"},
			:redirect_to => {:controller => "authentication", :action => "login"}
	  
	  
	# GET /vocs
	# GET /vocs.xml
	def index	
		@vocs = Voc.find(:all)		  	  		
		respond_to do |format|
			format.html # index.html.erb
			format.xml  { render :xml => @vocs }
		end
	end #end index
  
  
	# Alphabetische Listen anzeigen
	def alpha
		@search = params[:a]		  						
		@vocs = Voc.find_german_like(@search)						
		render :layout => false    
	end #end alpha
  
  
	# Zuletzt hinzugefügte Ausdrücke anzeigen
	def last	
		@vocs = Voc.find(:all, :conditions => "timestamp >= CURRENT_DATE AND timestamp < CURRENT_DATE + INTERVAL 1 DAY",
							:order=>'german ASC, wylie ASC')	 	  			
		@vocs = Functions.disparse_all_a(@vocs)
		respond_to do |format|
			format.html # last.html.erb
			format.xml  { render :xml => @vocs }
		end    
	end	#end last
	
  
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
		render :layout => false          
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
		render :layout => false
	end #end search1 wylie
  
      
    # Ausgabe nach Silbenanzahl  
	def search4
		@search = params[:search4].strip
		@vocs = Voc.find(:all, :conditions => "length='#{@search}'", :order=>'german ASC')	  
		@vocs_rest = nil #Array.new #@vocs - @vocs	 
		@vocs = Functions.disparse_all_a(@vocs)	  	  
		@num_rest_rows = 0
		render :layout => false
	end #end search4 length
	
  	
	# GET /vocs/1
	# GET /vocs/1.xml
	# Eintrag anzeigen
	def show  
		result = Voc.find_details(params[:id])
		@voc = result.at(0)     
		@vocs_syn_de = result.at(1)			    
		@vocs_syn_tib = result.at(2)
		@t = WylieConverter.convert(@voc.wylie)   	
		respond_to do |format|
			format.html # show.html.erb
			format.xml  { render :xml => @voc }
		end	
	end #end show
  
		
	# GET /vocs/new
	# GET /vocs/new.xml
	# Neuen Eintrag anlegen
	def new   
		@voc = Voc.new    
		data = get_select_data
		@grms = data.at(0)
		@cats = data.at(1)
		respond_to do |format|
			format.html # new.html.erb
			format.xml  { render :xml => @voc }
		end
	end #end new
	
  	
	# POST /vocs
	# POST /vocs.xml
	# Neu angelegten Eintrag in Datenbank speichern
	def create        
		@voc = Voc.new(params[:voc])
		@voc.german = @voc.german.strip
		@voc.wylie = Functions.parse_a(@voc.wylie.strip)   #==>> in model before_save 
		@voc.length = Functions.voc_length(@voc)     #==>> in model before_save
		@voc.timestamp = DateTime.now                #==>> in model before_create 
    
		@voc.grm = Grammar.check_and_set(@voc.grm.strip)        
		@voc.cat = Category.check_and_set(@voc.cat.strip)    
    
		respond_to do |format|
			if Voc.test(@voc)
				if @voc.save
					flash[:notice] = 'Voc was successfully created.'
					format.html { redirect_to(@voc) }
					format.xml  { render :xml => @voc, :status => :created, :location => @voc }
				else
					flash[:notice] = 'Err : data creation failed.'          
					format.html { render :action => "index" }
					format.xml  { render :xml => @voc.errors, :status => :unprocessable_entity }
				end
			else
				flash[:notice] = 'Voc already exists!'  
				data = get_select_data
				@grms = data.at(0)
				@cats = data.at(1)
				format.html { render :action => "new" }
				format.xml  { render :xml => @voc.errors, :status => :unprocessable_entity }      
			end		
		end	 	
	end #end create
	
	
	# GET /vocs/1/edit
	# Eintrag bearbeiten
	def edit
		@voc = Voc.find(params[:id])
		@voc.wylie = Functions.disparse_a(@voc.wylie)
		arr = get_select_data
		@grms = arr.at(0)
		@cats = arr.at(1)
	end #end edit
  	
  
	# PUT /vocs/1
	# PUT /vocs/1.xml
	# Bearbeiteten Eintrag Speichern (Daten in Datenbank updaten)
	def update
		@voc = Voc.find(params[:id])			
		h = params[:voc]
		@voc.german = h[:german].strip    
		@voc.wylie = Functions.parse_a(h[:wylie].strip)
    
		@voc.grm = h[:grm].strip
		@voc.grm = Grammar.check_and_set(@voc.grm)    
		@voc.cat = h[:cat].strip
		@voc.cat = Category.check_and_set(@voc.cat) 
    
		@voc.src = h[:src].strip
		@voc.note = h[:note].strip
		@voc.length = Functions.voc_length(@voc)
    
		respond_to do |format|  
		
		##### HIER TEST_DOUBLES-Methode 
		    	   
			if @voc.save
				flash[:notice] = 'Data was successfully updated.'
				format.html { redirect_to(@voc) }
				format.xml  { head :ok }
			else
				flash[:notice] = 'Err - data update failed.'
				format.html { render :action => "edit" }
				format.xml  { render :xml => @voc.errors, :status => :unprocessable_entity }
			end		    
		end 
	end #end update
  
  
	# DELETE /vocs/1
	# DELETE /vocs/1.xml  
	# Eintrag loeschen
	def destroy
		@voc = Voc.find(params[:id])
		@voc.destroy

		respond_to do |format|
			format.html { redirect_to(vocs_url) }
			format.xml  { head :ok }
		end
	end #end destroy  

  
	private 
  
  
	# Daten fuer select_tags erzeugen
	def get_select_data
		grms = Grammar.find(:all, :order=>'grm ASC')
		grms = grms.map {|g| [g.grm,g.grm]}
		cats = Category.find(:all, :order=>'cat ASC')
		cats = cats.map {|c| [c.cat,c.cat]}
		return [grms, cats]
	end # get_select_data
    
 
	# Test ob Eintrag vorhanden =>> in create =>> verschieben in model !
	def test(voc)    
		b = false  
		result = Voc.find(:first, 
                          :conditions=>"german='#{voc.german}' and wylie='#{voc.wylie}' and grm='#{voc.grm}'")                        
		if result == nil 
			b = true    
		end
		return b
	end # test
  
  
end #end VocsController

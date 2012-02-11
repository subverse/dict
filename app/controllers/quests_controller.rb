class QuestsController < ApplicationController  


  #layout 'application'
  include ApplicationHelper
  before_filter :authenticate  
  
  
  verify :session => :user_id,
		  		 :add_flash => {:error => "access denied!"},
				 :redirect_to => {:controller => "authentication", :action => "login"}  
	
  
  # GET /quests
  # GET /quests.xml 
  def index    
    #quests_rep = Quest.find_rep( uid )   
    #quests_blanc = Quest.find_blanc( uid )
    #@quests = quests_rep + quests_blanc
    @quests = Quest.find_no1Shots(uid)
		@vocs = get_data(@quests)	     
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @quests }
    end
  end #end index
 
 
  #--------Eintrage_anlegen------------------------------------------------------------------------------
   
 
  def new  # Neue Einträge anlegen        
    @grms = Grammar.find(:all, :order => "grm ASC").map {|g| [g.grm,g.grm]}
    @cats = Category.find(:all, :order => "cat ASC").map {|c| [c.cat,c.cat]} 
		render :partial => "new"
  end #end new
   
  
  def set #  Neue Einträge spezifizieren und anlegen     
    @grm = params[:grm][:grms]  
	  @cat = params[:cat][:cats]
		@num = params[:num].at(0).to_i	
    length = params[:length].at(0).to_i		  
    Quest.set(uid, @num, @grm, @cat, length)              
    @quests = Quest.find_no1Shots(uid)   
		@vocs = get_data(@quests)	
		render :partial => "list"
  end #end set


#----------list_display_modes-------------------------------------------------------------------------
	
 
  def all # Alle Einträge
    @quests = Quest.find_all(	uid )
		@vocs = get_data(@quests) 
		render :partial => "list"
  end #end all
  
	
  def ok # Einträge die mindestens einmal korrekt beantwortet wurden
    @quests = Quest.find_ok(	uid )
		@vocs = get_data(@quests)		 		
		render :partial => "list"
  end #end ok
 
 
  def rep # Einträge die wiederholt werden
    @quests = Quest.find_rep(	uid )
		@vocs = get_data(@quests)				
		render :partial => "list"
  end #end rep
 
 
  def blanc # Einträge die noch nie bearbeitet wurden
    @quests = Quest.find_blanc(	uid )
		@vocs = get_data(@quests)			
		render :partial => "list"
  end #end blanc
  
   
#------------Abfrage--------------------------------------------------------------------------------------
 
	
	def question # Frage stellen 
    rndr = true  	  
    @quest = Quest.find_first_blanc( uid )
		if @quest == nil                       
			@quest = Quest.find_first_repeat( uid )			
			if @quest == nil  			
        rndr = false
			  repeat				       
			end
		end
		if @quest != nil	  
			@voc = Voc.find(@quest.voc) 	     	  
			@voc.wylie = Functions.disparse_a(@voc.wylie)		
		end	
    if rndr
      render :layout => false		
    end    
  end #end question
	
	
  def check # Antwort prüfen	  
	  @german = params[:german]
    @wylie = params[:wylie]	
    result = Quest.check(@german, params[:qid])  	
    quest = Quest.find(params[:qid])
		@indicator = result.at(0) 		
		@voc = result.at(1)	    
    if @indicator     						     
      quest.ok!		      
		else						 
      quest.rep!		      
		end	  
		render :layout => false
  end #end check
    
  
	#-------------Operationen_auf_Liste-------------------------------------------------------

	
	def reset # Reset aller Einträge bis auf solche die beim ersten Abfragen korrekt beantwortet wurden
    Quest.reset( uid )    
  end #end reset
	
	
  def reset_list
	  reset
	  render :partial => "list"
	end
	
  
  def clear # Löschen aller Einträge für die nicht { ok = 1 and rep = 0 } gilt
    Quest.clear( uid )
		render :partial => "list"
  end #end clear
 
 
  def delete # Löschen alle Einträge
		Quest.delete( uid )
		render :partial => "list"
  end #end clear  
 
 
 #--------------Abfrage_der_Konsonanten--------------------------------------------------------
 
 
 	def consonant      	  
    if params[:consonant] == nil
			@consonant = 1 
		else
			@consonant = @consonant.to_i + params[:consonant].to_i+1
			if @consonant == 31
        @consonant = 1
      end
    end	  		
		@hex = get_tibetan_hex(get_consonant(@consonant)) + get_tibetan_hex("_")
	  render :layout => false
  end #end consonant
	
  
  def check_consonant    
		@consonant = params[:consonant]
    @wylie = params[:wylie]	
		consonant = get_consonant(@consonant.to_i)
		@hex = get_tibetan_hex(consonant) + get_tibetan_hex("_")		
		if @wylie == consonant
      flash[:notice] = 'true'
			@wylie = "true"      
    else	
		  @wylie = consonant
			flash[:notice] = consonant
		end	 		
		render :layout => false
  end #end check_consonant
  
  
  #-------------------------private-----------------------------------------------------
  
  
  private 
  
  
  def uid 
    session[:user_id]
  end
  
	
	def repeat
    @quests = Quest.find_all(uid)
		if @quests.length > 0
			@quests.each do |quest| 
				if not (quest.ok == 1 && quest.rep == 0) 
					quest.ok = 0	          
					quest.save		  
				end  
			end						
	    redirect_to :action => "question" 	    
		end  	
  end #end repeat
	
	
	def get_data(quests)
    vocs = Array.new
		quests.each do |quest|
			voc = Voc.find(quest.voc)	 
			vocs.push(voc)      
    end    
    vocs = Functions.disparse_all_a(vocs)	
		return vocs.reverse
  end # get_data
	
	
	def get_consonant(n)
    consonant_arr = ["ka","kha","ga","nga",
                     "ca", "cha", "ja", "nya",
										 "ta", "tha", "da", "na",
										 "pa", "pha", "ba", "ma",
										 "tsa", "tsha", "dza", "wa",
										 "zha", "za", "'a", "ya",
										 "ra", "la", "sha", "sa",
										 "ha", "a"]					 
		consonant_arr.at(n-1)
  end #end consonant

       
end # end quests_controller.rb

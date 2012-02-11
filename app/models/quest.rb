class Quest < ActiveRecord::Base
  
  
  require 'functions'
    
  
  def self.set(uid, num, grm, cat, length) #  Neue Eintr�ge spezifizieren und anlegen     
  
    ### doppelte Eintr�ge in db
  
    vocs = Voc.find(:all, :conditions => "grm = '#{grm}' AND cat = '#{cat}' AND length = '#{length}'")	
    if vocs.length < num
      vocs_alt = Voc.find(:all, :conditions => "grm = '#{grm}' AND cat = '#{cat}'")      
      vocs = vocs_alt - vocs
    end
		elems = Array.new
		vocs.each do |voc|
			elems.push(voc.id)
    end   
    elems = random_arr(elems, num)
		elems.each do |elem|
			quest = Quest.new
			quest.user = uid
			quest.voc = elem
			quest.ok = 0
			quest.rep = 0
			quest.save    			
		end						    
  end #end set
  
  
  def self.set_bak(uid, num, grm, cat) #  Neue Eintr�ge spezifizieren und anlegen     
		##### text_field :length in Bedingung aufnehmen !!!!!		
    vocs = Voc.find(:all, :conditions => "grm = '#{grm}' AND cat = '#{cat}'", :order => "id ASC")	
		elems = Array.new
		vocs.each do |voc|
			elems.push(voc.id)
    end   
    elems = random_arr(elems, num)
		elems.each do |elem|
			quest = Quest.new
			quest.user = uid
			quest.voc = elem
			quest.ok = 0
			quest.rep = 0
			quest.save    			
		end						    
  end #end set
  
  
  #----------list_display_modes-------------------------------------------------------------------------
  
  
  def self.find_all(uid) # Alle Eintr�ge
    find(:all, :conditions => "user = #{ uid }")			
  end #end all
  
	
  def self.find_ok(uid) # Eintr�ge die mindestens einmal korrekt beantwortet wurden
    find(:all, :conditions => "user = #{ uid } AND ok != 0")	
  end #end ok
 
 
  def self.find_rep(uid) # Eintr�ge die wiederholt werden
    find(:all, :conditions => "user = #{ uid } AND rep != 0")	    
  end #end rep
 
 
  def self.find_blanc(uid) # Eintr�ge die noch nie bearbeitet wurden
    find(:all, :conditions => "user = #{ uid } AND ok = 0 and rep = 0")	
  end #end blanc
  
  
  def self.find_no1Shots(uid)
    find(:all, :conditions => "user = #{ uid } AND not (ok=1 AND rep=0)")
  end
  
  
  #----------find_question_by_indicators-----------------------------------------------------------------
  
  
  def self.find_first_blanc(uid)
    find(:first, :conditions => "user = #{ uid } AND ok = 0 AND rep = 0")	
  end
  
  
  def self.find_first_repeat(uid)		
		Quest.find(:first, :conditions => "user = #{ uid } AND ok = 0 AND rep != 0")		
  end #end question
   
  
  #---------set_indicators--------------------------------------------------------------------------------
  
  
  def ok!        
    self[:ok] = 1        
    self.save    
  end #end ok!
  
  
  def rep!        
    self[:ok] = -1
    self[:rep] = self[:rep] + 1
    self.save    
  end #end rep! 
  
  
  def reset!   
    self[:ok] = 0
    self[:rep] = 0
    self.save  
  end #end reset!
   
  
  #---------list_items-------------------------------------------------------------------------------------
  
  
  def self.reset(uid) # Reset aller Eintr�ge bis auf solche die beim ersten Abfragen korrekt beantwortet wurden
		quests = find_no1Shots( uid )
		if quests != nil
			quests.each{ |quest| quest.reset! }					 		
		end  		
  end #end reset
  
  
  def self.clear(uid) # L�schen aller Eintr�ge f�r die nicht { ok = 1 and rep = 0 } gilt	
    quests = find_no1Shots( uid )
		if quests != nil
			quests.each{ |quest| quest.destroy }	  	  			
		end  
  end #end clear
  
  
  def self.delete(uid)
    quests = find_all( uid )
		if quests != nil
			quests.each{ |quest| quest.destroy }	  	  			
		end  
  end #end delete
   
  
  def self.check(german, qid) # Antwort pr�fen	    
    quest = find(qid)
    voc = Voc.find(quest.voc)
    hit = voc.german == german
    if hit         					      
      voc.wylie	= Functions.disparse_a(voc.wylie)				      
      quest.ok!			
		else						 
      quest.rep!			      
		end	  
		return [hit, voc]
  end #end check
   
  
  private
  
  
  def self.random_arr(arr,n)
    rnd = arr.length
    rarr = Array.new
    n = n.to_i
    if n > rnd
      n = rnd
    end	
    while rarr.length < n 
      elem = arr.rand
      while rarr.find{ |e| e == elem } != nil #elem?(rarr,elem)
        elem = arr.rand
      end
      rarr.push(elem)	  
    end
    return rarr
  end #end random_arr 
  
  
end #end Quest

module Functions

  #---Algorithmic----------------------------------------------------------------------------

  def self.num_syllables(w)
    w.wylie.split(" ").length
  end


  def self.parse_a(s)  # parse ' to '' 
    #s = self.disparse_a(s)  
    s = disparse_a(s)
    if s.count("'") > 0
      s = s.gsub(/'/, "''")        	
    end  
    return s
  end  


  def self.disparse_a(s)  # parse '' to '    
    c = s.count("''")  
    if c > 0 
      s = s.gsub(/''/, "'")        		
    end  
    return s
  end  
  
  def self.disparse_all_a(elem)  # parse '' to '
    elem.each do |e|
      if e.wylie.count("''") > 0
        e.wylie = e.wylie.gsub(/''/, "'")        
      end  
	end  
    return elem
  end  
  
  def self.parse_all_a(elem)  # parse ' to ''
    elem.each do |e|
      if e.wylie.count("'") > 0
        e.wylie = e.wylie.gsub(/'/, "''")        
      end  
	end  
    return elem
  end  
  
  def self.voc_length(voc)
    voc.wylie.split(" ").length
  end
  
end # module Functions
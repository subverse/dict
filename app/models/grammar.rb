class Grammar < ActiveRecord::Base  

  validates_presence_of :grm
	validates_uniqueness_of :grm
 
  
  def self.check_and_set(grm)
    result = find(:first, :conditions=>"grm='#{grm}'")
    if result == nil	    
      result = "sonstige"
    else
      result = result.grm      
    end	 
    return result
  end # check_and_set
 

end # Grammar

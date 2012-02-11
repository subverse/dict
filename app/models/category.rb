class Category < ActiveRecord::Base

    validates_presence_of :cat	
	validates_uniqueness_of :cat
  
  
  def self.check_and_set(cat)
    result = find(:first, :conditions=>"cat='#{cat}'")
    if result == nil	    
      result = "sonstige"
    else
      result = result.cat
    end	 
    return result
  end # check_and_set
   
  
end # Category

class Voc < ActiveRecord::Base  

  require 'functions'

  validates_presence_of :german
  validates_presence_of :wylie	  
  validates_presence_of :src	  
  
  
  def self.find_all_german(search)
    result = find(:all, :conditions => "german='#{search}'", :order=>order("german"))
    Functions.disparse_all_a(result)
  end # find_all_german
  
  def self.find_german_like(search)
    result = find(:all, :conditions => ["german LIKE ?", search+'%'], :order=>order("german"))
    Functions.disparse_all_a(result)
  end # find_german_like
  
  
  def self.find_wylie_like(search_parsed)
    result = find(:all, :conditions => ["wylie LIKE ?", search_parsed+'%'], :order=>order("german"))  
    Functions.disparse_all_a(result)
  end # find_wylie_like
  
  
  def self.find_german(search)    
    german = find_all_german(search)
    german_rest = find_german_like(search)    
    german_rest = german_rest - german                    
    return [german, german_rest]
  end #self.find_german
  
  
  def self.find_wylie(search)
    search_parsed = Functions.parse_a(search)
    wylie = proc_search_wylie(search_parsed)	                      
    wylie_rest = find_wylie_like(search_parsed)   
	  wylie_rest = wylie_rest - wylie           
    return [wylie, wylie_rest] 
  end #self.find_wylie
  

  def self.find_details(voc_id)  
    voc = find(voc_id)
    temp = Array.new
    temp.push(voc)    		
    vocs_syn_de = find_all_german(voc.german)
		vocs_syn_de = vocs_syn_de - temp	   
    vocs_syn_tib = proc_search_wylie(voc.wylie)
		vocs_syn_tib = vocs_syn_tib - temp      
    voc.wylie = Functions.disparse_a(voc.wylie)    
    return [voc, vocs_syn_de, vocs_syn_tib]
  end # self.find_details
  
  
  def self.find_cat(cat)
    find(:all, :conditions => "cat='#{cat}'", :order=>order("german"))
  end # find_cat 
  
  
  def self.find_grm(grm)
    find(:all, :conditions => "grm='#{grm}'", :order=>order("german"))
  end # find_grm 


  def self.test(voc)    
    result = find(:first, 
                  :conditions=>"german='#{voc.german}' and wylie='#{voc.wylie}' and grm='#{voc.grm}'")  
    return result == nil    
  end # test
  

  def before_save()             
  end # before_save

      
  private 
  
  
  def self.order(direction)
    if direction == "german"
      'german ASC, wylie ASC'
    else
      if direction == "wylie"
        'wylie ASC, german ASC'
      end
    end    
  end # order
  
  
  def self.proc_search_wylie(search_parsed)    
    arr = find(:all, :conditions => ["wylie LIKE ?", search_parsed+'%'], :order=>'wylie ASC')
    result = Array.new
    arr.each do |v|
      if v.wylie == search_parsed
        result.push(v)
      end     
    end  
    Functions.disparse_all_a(result)
  end # proc_search_wylie
  
  
end # class Voc

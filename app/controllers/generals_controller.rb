class GeneralsController < ApplicationController
  
  
	layout 'application', :except => :fkt
  	
  	
	def impressum
	  
	end  
	
	
	def links
	   
	end
	
	
	def show	  
		render :partial => "links", :locals => { :link_category => params[:link_cat] }		
	end

  def fkt
    
  end

  def fkt_info
    render :partial => 'fkt_info'
  end
  
  
  def fkt_L1
    render :partial => 'fkt_L1'
  end

  
  def fkt_L2
    render :partial => 'fkt_L2'
  end

  
  def fkt_L3
    render :partial => 'fkt_L3'
  end

  
  def fkt_L4
    render :partial => 'fkt_L4'
  end

  
  def fkt_L5
    render :partial => 'fkt_L5'
  end

  
  def fkt_L6
    render :partial => 'fkt_L6'
  end
  
end

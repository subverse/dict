module IphonesHelper  	

	def my_link_to_eList_48(voc)
		link_to image_tag("temp48.png", :border=>0), {:controller => :iphones,
                                                :action => :new, 
                                                :params => { :item=> voc.id }},
                                                :title => "Zu eList hinzuf&uuml;gen"		
	end # to_eList_48
  
  
	def my_link_to_view_eList_48
		link_to image_tag("temp48_view.png", :border=>0), {:controller => :iphones,
                                                :action => :show_eList},                                    
                                                :title => "eList anzeigen"
	end #end to_view_eList_48
	
end	#end IphonesHelper  	



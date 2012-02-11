module QuestsHelper

  def text_field_tags(tag_id, value, color)
    style = "background-color : #FFFFFF ; border : none"
		value = value.to_s
		if color == "gray"
			text_field_tag tag_id, value, :class => "text_field"
		else
			if color == "white" 
			  text_field_tag tag_id, value, :style => "#{style}", :class => "text_field"
			else
				if color == "invis"
          text_field_tag tag_id, value, :style => "#{style}; display : none", :class => "text_field"
				else 
					if color == "short"
					  text_field_tag tag_id, value, :size => 3, :class => "text_field"
					end
				end
			end	
		end	
	end
  
end # end Questshelper

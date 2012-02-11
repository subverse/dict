module LinkHelper

#  def link_param

  def linkTo(text, url, title="", new_tab=false)
    if new_tab
      link_to text, url, {:target => "_blank", :title => title}     
    else
      link_to text, url, {:title => title}
    end
  end

  def imageLinkTo(image, url, title="", new_tab=false)
    if new_tab
      link_to image_tag(image, :border => 0), url, {:target => "_blank", :title => title}
    else
      link_to image_tag(image, :border => 0), url, :title => title
    end
  end
  
  
  def linkToRemote(title, url, div)
    link_to_remote title, :url => url, :method => 'get',
    :update => { :success => "#{div}", :failure => "#{div}"} #,
#                                       :before => "$('#{div}').update('Laden...')"
  end

  
  def imageLinkToRemote(image, url, div)
    link_to_remote image_tag(image, :border=>0), :url => url, :method => 'get',
                                        :update => { :success => "#{div}", :failure => "#{div}"},
                                        :before => "$('#{div}').update('Laden...')"
  end
  
  def imageLinkToRemoteCancel
    link_to_remote image_tag("Cancel_16x16.png", :border => 0), 
      :url => { :controller => "Application", :action => "cancel", :id => 1 },
      :method => :get
  end
  
  def imageLinkTo_new_tab(image, url, title="")
    link_to image_tag(image, :border => 0), url, {:target => "_blank", :title => title}
  end

  def link_to_new_tab(text,url, title="")
    link_to text, url, {:target => "_blank", :title => title}
  end

  def link_to_show(url)
    link_to image_tag("Preview_16x16.png", :border => 0), url, :title => "Show"
  end

  def link_to_edit(url)
    link_to image_tag("Edit_16x16.png", :border => 0), url, :title => "Edit"
  end

  def link_to_destroy(url)
    link_to image_tag("Delete_16x16.png", :border => 0), url, :confirm => 'Are you sure?', :method => :delete, :title => "Destroy"
  end

  def link_to_new(url)
    link_to image_tag("Add_16x16.png", :border => 0), url, :title => "New"
  end

  def link_to_cancel(url)
    link_to image_tag("cancel_16x16.png", :border => 0), url, :title => "cancel"
  end


end #end module LinkHelper

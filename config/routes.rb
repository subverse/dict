ActionController::Routing::Routes.draw do |map|
  
  map.resources :users
  map.resources :quests
  map.resources :challenges
  map.resources :temps
  map.resources :grammars
  map.resources :categories
  map.resources :vocs  
  map.resources :generals
  map.resources :lists
  map.resources :listquest
  map.resources :conf
  map.resources :iphones

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"
	
  # See how all your routes lay out with "rake routes"
  
  map.login 'login', :controller => "authentication", :action => "login"
  map.logout 'logout', :controller => "authentication", :action => "logout"
  map.check 'check', :controller => "authentication", :action => "check"
  
  map.conf 'conf', :controller => "conf", :action => "index"

  map.connect 'dict', :controller => "vocs", :action => "index"  

  # Install the default routes as the lowest priority.    
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end

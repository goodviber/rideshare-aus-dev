Cocoride::Application.routes.draw do

  devise_for :users

  ActionController::Routing::SEPARATORS <<  "-" unless ActionController::Routing::SEPARATORS.include?("-")

  resources :demos

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  scope "(:locale)", :locale => /en|lt/ do

    #match '/trips/search(/:fl(-to-:tl(/:tripdate)))' => 'trips#load_search_results'
    match '/trips/search(/:fl(-:tl))' => 'trips#load_search_results', :as => :load_results
    match '/trips/mytrips' => 'trips#my_trips', :as => :my_trips

    resources :trips

    match '/trips/load_search_results' => 'trips#load_search_results'
    match '/trips/load_valid_dates' => 'trips#load_valid_dates'

  end



  # Sample of named route:
  #match 'trip/search' => 'trip#search', :as => :trip_search
  #match 'trip/post' => 'trip#post', :as => :trip_post
  match 'login/user_login' => 'login#user_login'

  match ':controller(/:action(.:format))'

  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  #match ':controller(/:action(/:id(.:format)))'
end


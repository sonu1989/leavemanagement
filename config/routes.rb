Rails.application.routes.draw do
  
  devise_for :users, :controllers => {:registrations => "users/registrations"}
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'
  resources :leaves do
    patch :cancel, on: :member
  end
  
  resources :reviews

  namespace :admin do
    resources :circulars do
      patch :update_published, on: :member
    end
    resources :dashboard, only: [:index]
    resources :holidays
    resources :employees do 
      get "generate_csv", on: :collection
    end  
    resources :leaves do
      patch :cancel, on: :member
    end
    
    get 'reviews/employees' => 'reviews#employees_list', as: :employee_list
    get 'employees/:employee_id/reviews' => 'reviews#index', as: :employee_review_list
    get 'employees/:employee_id/reviews/:id' => 'reviews#show', as: :review

  end 
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end

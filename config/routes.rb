Rails.application.routes.draw do

  # This defines a route so that when a GET request for "/home" is received,
  # Rails will invoke the WelcomeController with 'index' action
  # Ruby syntax - get({"/home" => "welcome#index"})

  # If no specific helper method name is provided,
  # it will default to 'home_path' and 'home_url'
  get "/home" => "welcome#index"

  # For this route, we will have helper methods: about_us_path / about_us_url
  get "/about" => "welcome#about", as: :about_us


  get "/contact_us" => "contact_us#new"
  # This will have the same helper method as the above because they have the same URL
  post "/contact_us" => "contact_us#create"


  resources :questions do
    # A URL that is not specific to one record:
    # A nested resource - Not directly related to a question record, but you are referencing one
    # /questions/search (search_questions_path)
    # get :search, on: :collection

    # Searching within a given question:
    # /questions/:id/search (search_question_path)
    # get :search, on: :member
    # get :search

    # The answers routes will be the standard routes prefixed with /questions/:question_id, so that if we want to create an answer, we know the question it references
    # All helpers will be prefixed with 'question_'
    # /questions/:question_id/answers/:id (question_answer_path)
    resources :answers, only: [:create, :destroy]
  end

  resources :users, only: [:new, :create]

  resources :sessions, only: [:new, :create] do
      delete :destroy, on: :collection
      # delete :destroy, on: :member
      # delete :destroy
  end

  # Route helper, i.e. as: :new_question
  # get "/questions/new"      => "questions#new"    ,  as: :new_question
  # post "/questions"         => "questions#create" ,  as: :questions
  # get "/questions/:id"      => "questions#show"   ,  as: :question
  # get "/questions"          => "questions#index"
  # get "/questions/:id/edit" => "questions#edit"   ,  as: :edit_question
  # patch "/questions/:id"    => "questions#update"
  # delete "/questions/:id"   => "questions#destroy",  as: :delete_question


  post '/questions/:id/comments' => 'comments#create'

  get '/faq' => 'home#faq'

  # This defines the 'root' or home page and allows access to: root_path and root_url
  root "welcome#index"

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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

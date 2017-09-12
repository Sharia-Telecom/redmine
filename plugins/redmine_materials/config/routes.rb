# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
resources :projects do
  resources :materials
end

resources :projects do
  resources :materials do
    resources :material_cycles do
      collection do
        get "entry"
        get "middle"
        get "exit"
      end
    end
  end
  resources :material_imports, :only => [:new, :create, :show] do
    member do
      get :settings
      post :settings
      get :mapping
      post :mapping
      get :run
      post :run
    end
  end
end

resources :material_categories

resources :warehouses

resources :materials, :only => [:index, :show]

resources :material_comments, :only => [:create, :destroy]

match 'auto_completes/materials' => 'auto_completes#materials', :via => :get, :as => 'auto_complete_materials'
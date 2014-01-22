XdMailCompiler::Application.routes.draw do

  root 'campaigns#index'

  resources :campaigns do
    collection do
       get :collect_resources # for campaign
      post :select_resource   # ajax load in
    end
    member do
      get :preview
    end
  end

  resources :resources

  resources :exports do
    collection do
      get :preflight_for_email_on_acid
    end
  end

end

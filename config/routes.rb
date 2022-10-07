Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :documents do
    get "printed/:document_name", to: "documents#printed"
  end
end

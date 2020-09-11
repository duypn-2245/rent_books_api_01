Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/, defaults: {format: :json} do
    devise_for :user

    namespace :api do
      namespace :v1 do
        post "sign_in", to: "sessions#create"
        delete "sign_out", to: "sessions#destroy"
        post "sign_up", to: "registrations#create"
        namespace :admin do
          resources :books
        end
      end
    end
  end
end

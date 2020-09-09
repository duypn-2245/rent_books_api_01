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
          get "books/:id/book_renter", to: "books#book_renter"
          resources :register_books, only: %i(index update)
          resources :register_book_details, only: %i(index)
          get "statisticals", to: "books#statisticals", as: :statisticals
        end
        resources :books, only: %i(index show) do
          resources :comments, except: %i(new edit show)
        end
        get "hot_rentals", to: "books#hot_rentals", as: :hot_rentals
        resources :register_books, only: %i(create index update)
      end
    end
  end
end

Rails.application.routes.draw do
  resources :blogs do
    patch :cropper, on: :member
  end
end

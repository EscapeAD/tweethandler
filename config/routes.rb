Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  root    'home#index'
  post    '/import',            to: 'home#import'
  delete  '/',                  to: 'home#destroy'
  get     '/filters',           to: 'home#filters'
  # resource :home
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

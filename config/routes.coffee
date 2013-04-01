exports.routes = (map) ->
  map.namespace 'admin', (admin) ->
      admin.resources 'users', only: ['index', 'destroy']


  map.root 'public#index'
  map.get  'home', 'home#index'

  map.get 'signin',  'sessions#new'
  map.get 'signout', 'sessions#destroy'

  map.get  'signup',  'registrations#new'
  map.post 'signup',  'registrations#create'
  map.get  'welcome', 'registrations#welcome'

  map.get  'reset/password/email', 'registrations#reset_password_email_show'
  map.post 'reset/password/email', 'registrations#reset_password_email'
  map.get  'reset/password', 'registrations#reset_password_show'
  map.post 'reset/password', 'registrations#reset_password'

  map.get  'users/confirmation', 'confirmations#show'

  map.get  'users/confirmation/resend', 'confirmations#resend_show'
  map.post 'users/confirmation/resend', 'confirmations#resend'

  map.get  'profile', 'profile#show'
  map.get  'profile/new/password', 'profile#new_password'
  map.post 'profile/new/password', 'profile#update_password'


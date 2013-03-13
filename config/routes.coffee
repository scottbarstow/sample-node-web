exports.routes = (map) ->

    map.root 'public#index'
    map.get  'home', 'home#index'

    map.resources 'phone_scripts'

    map.get 'signin',  'sessions#new'
    map.get 'signout', 'sessions#destroy'

    map.get  'signup',  'registrations#new'
    map.post 'signup',  'registrations#create'
    map.get  'welcome', 'registrations#welcome'

    map.get  'users/confirmation', 'confirmations#show'

    map.get  'profile', 'profile#show'
    map.get  'profile/new/password', 'profile#new_password'
    map.post 'profile/new/password', 'profile#update_password'

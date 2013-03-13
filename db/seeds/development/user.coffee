bcrypt = require 'bcrypt'
pepper = "d2372efb19bc4001daad9033159cf4c84049a9dd509e8c12cb7c16a81e8bfe281f36a9994008c8b2229c052b23f52e0db2d52e226f6c3202767fd918a82b3564"
salt = bcrypt.genSaltSync( 10 )
encrypted_password = bcrypt.hashSync('111111' + pepper, salt)

User.seed ->
    email: 'admin@yourcompany.com'
    is_admin: true
    encrypted_password: encrypted_password
    confirmed_at: Date.now()
    id: 1

User.seed ->
    email: 'customer1@yourcompany.com'
    is_admin: false
    encrypted_password: encrypted_password
    confirmed_at: Date.now()
    id: 1
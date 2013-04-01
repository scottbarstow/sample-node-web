###
 db/schema.js contains database schema description for application models
 by default (when using jugglingdb as ORM) this file uses database connection
 described in config/database.json. But it's possible to use another database
 connections and multiple different schemas, docs available at

 http://railwayjs.com/orm.html

 Example of model definition:

 define('User', function () {
     property('email', String, { index: true });
     property('password', String);
     property('activated', Boolean, {default: false});
 });

 Example of schema configured without config/database.json (heroku redistogo addon):
 schema('redis', {url: process.env.REDISTOGO_URL}, function () {
     // model definitions here
 });

###

User = describe 'User', ->
    property 'email'               , String, index: true
    property 'is_admin'            , Boolean
    property 'stripe_id'           , String
    property 'encrypted_password'  , String
    property 'confirmation_token'  , String
    property 'confirmed_at'        , Date
    property 'confirmation_sent_at', Date
    property 'google_id'           , String, index: true
    property 'facebook_id'         , String, index: true
    property 'last_sign_in_at'     , Date
    property 'reset_password_token', String, index: true
    property 'reset_password_sent_at', Date
    property 'created_at'          , Date,     default: Date.now
    property 'updated_at'          , Date,     default: Date.now
    # billing
    property 'name_on_card'        , String
    property 'company'             , String
    property 'address'             , String
    property 'address2'            , String
    property 'city'                , String
    property 'state'               , String
    property 'zip'                 , String
    property 'contact_phone'       , String


    setTableName 'users'
    set 'restPath', pathTo.users




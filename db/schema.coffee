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

PhoneScript = describe 'PhoneScript', ->
    property 'name',        String
    property 'description', Text
    property 'script',      Text
    property 'user_id',     Number
    property 'created_at',  Date,     default: Date.now
    property 'updated_at',  Date,     default: Date.now
    setTableName 'phone_scripts'
    set 'restPath', pathTo.PhoneScripts

User = describe 'User', ->
    property 'email'               , String, index: true
    property 'is_admin'            , Boolean
    property 'encrypted_password'  , String
    property 'confirmation_token'  , String
    property 'confirmed_at'        , Date
    property 'confirmation_sent_at', Date
    property 'google_id'           , String, index: true
    property 'facebook_id'         , String, index: true
    property 'last_sign_in_at'     , Date

    property 'created_at'          , Date,     default: Date.now
    property 'updated_at'          , Date,     default: Date.now
    setTableName 'users'
    set 'restPath', pathTo.Users



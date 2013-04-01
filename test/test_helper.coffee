isCompoundReady = false;
compound = require('..')().compound
compound.on 'ready', ->
    isCompoundReady = true

global.onready = (callback) ->
  if isCompoundReady
    callback(compound)
  else
    compound.on 'ready', ->
      isCompoundReady = true
      callback(compound)

global.onready_and_connected = (callback) ->
  onready (compound) ->
    if compound.models.User.schema.connected
      callback(compound)
    else
      compound.models.User.schema.on 'connected', ->
        callback(compound)

global.clearDb = (callback) ->
  onready_and_connected (compound) ->
    db = compound.models.User.schema.adapter.client
    db.collectionNames (err, collectionNames) ->
      throw err if err

      i = 0
      count = collectionNames.length

      if count is 0
        callback(db)
      else
        delNextCollection = ->
          data = collectionNames[i]
          [prefix..., name] = data.name.split '.'

          db.collection name, (err, collection) ->
            collection.drop (err) ->
              
              if err
                console.log("Error during drop #{name}:",err)
              else
                console.log "Collection '#{name}' was deleted"

              if (i+1) >= count
                callback(db)
              else
                i++
                delNextCollection()

        delNextCollection()


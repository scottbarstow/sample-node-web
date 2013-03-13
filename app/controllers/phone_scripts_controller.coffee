load 'application'

before use 'authorize'

before 'load phone script', ->
    @current_user.phoneScripts.find params.id, (err, phonescript) =>
        if err || !phonescript
            if !err && !phonescript && params.format is 'json'
                return send code: 404, error: 'Not found'

            redirect path_to.phone_scripts
        else
            @phonescript = phonescript
            next()
,only: ['show', 'edit', 'update', 'destroy']

action 'new', ->
    @title = 'New Phone Script'
    @phonescript = new PhoneScript
    render()

action 'create', ->
    phoneScripts = @current_user.phoneScripts

    phoneScripts.create req.body.PhoneScript, (err, phonescript) ->
        respondTo (format) ->
            format.json ->
                if err
                    send code: 500, error: phonescript && phonescript.errors || err
                else
                    send code: 200, data: phonescript.toObject()

            format.html ->
                if err
                    flash 'error', 'Phone Script can not be created'
                    render 'new',  phonescript: phonescript, title: 'New Phone Script'
                else
                    flash 'info', 'PhoneScript created'
                    redirect path_to.phone_scripts


action 'index', ->
    @title = 'Phone Scripts'
    @current_user.phoneScripts (err, phonescripts) ->
        switch params.format
            when "json"
                send code: 200, data: phonescripts
            else
                render phonescripts: phonescripts


action 'show', ->
    @title = 'Phone Script'

    switch params.format
        when "json"
            send code: 200, data: @phonescript
        else
            render()


action 'edit', ->
    @title = 'PhoneScript edit'
    switch params.format
        when "json"
            send @phonescript
        else
            render()


action 'update', ->
    phonescript = @phonescript
    @title = 'Edit phonescript details'
    @phonescript.updateAttributes body.PhoneScript, (err) ->
        respondTo (format) ->
            format.json ->
                if err
                    send code: 500, error: phonescript && phonescript.errors || err
                else
                    send code: 200, data: phonescript

            format.html ->
                if !err
                    flash 'info', 'PhoneScript updated'
                    redirect path_to.phone_script(phonescript)
                else
                    flash 'error', 'PhoneScript can not be updated'
                    render 'edit'


action 'destroy', ->
    @phonescript.destroy (error) ->
        respondTo (format) ->
            format.json ->
                if error
                    send code: 500, error: error
                else
                    send code: 200

            format.html ->
                if error
                    flash 'error', 'Can not destroy phonescript'
                else
                    flash 'info', 'PhoneScript successfully removed'

                send "'#{path_to.phone_scripts}'"


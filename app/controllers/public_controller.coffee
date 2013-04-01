load 'application'

action 'index', ->
    @title = 'Sample App'
    @crit = {}
    render()
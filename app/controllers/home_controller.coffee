load 'application'

before use 'authorize'

action 'index', ->
    @title = 'Home'
    render()
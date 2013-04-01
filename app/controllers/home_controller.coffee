load 'application'

layout 'internal'

before use 'authorize'

action 'index', ->
    @title = 'Home'
    render()
GlobalBackgroundView = require './global-background-view'
{CompositeDisposable} = require 'atom'
configSchema = require './config-schema.coffee'

module.exports = GlobalBackground =
  globalBackgroundView: null
  subscriptions: null
  config: configSchema 

  activate: (state) ->
    @globalBackgroundView = new GlobalBackgroundView(state.globalBackgroundViewState)
    document.body.appendChild @globalBackgroundView.getElement()
    
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace', 'global-background:start-refresh': @globalBackgroundView.startRefresh
    @subscriptions.add atom.commands.add 'atom-workspace', 'global-background:stop-refresh': @globalBackgroundView.stopRefresh

  deactivate: ->
    @subscriptions.dispose()
    @globalBackgroundView.destroy()

  serialize: ->
    globalBackgroundViewState: @globalBackgroundView.serialize()

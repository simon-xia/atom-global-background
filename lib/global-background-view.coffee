{CompositeDisposable} = require 'atom'
request = require 'request'
fs = require 'fs'

class GlobalBackgroundView

  constructor: (serializedState) ->
    # Create the background element
    @background = document.createElement('div')
    @background.classList.add('global-background')

    @current = 0 
    @indexInURLs = true
    @imageURLsSource = [] 
    @imagePathsSource = []
    
    source =  @getConfig "imageSource.source"
    @isCustom = if source  is "Custom Image Source" then true else false 
    
    if @isCustom
        @imageURLsEnabled = @getConfig "imageSource.custom.urls.enabled"    
        if @imageURLsEnabled    
          @imageURLsSource = @getConfig "imageSource.custom.urls.source"    
         
        @imagePathsEnabled = @getConfig "imageSource.custom.paths.enabled"    
        if @imagePathsEnabled    
          @imagePathsSource = @getConfig "imageSource.custom.paths.source"    
        
        @randomEnable = @getConfig "imageSource.custom.randomEnable"
     
        #only one image, cache in memory, don't refresh
        if @imageURLsSource.length + @imagePathsSource.length == 1
          if @imageURLsEnabled and @imageURLsSource.length != 0
            @fetchImageFromURL @imageURLsSource[0]
          if @imagePathsEnabled and @imagePathsSource.length != 0
            @fetchImageFromFile @imagePathsSource[0]
        else
          @startRefresh()
    else
      @startRefresh()
        
  getConfig: (config) ->
    atom.config.get "global-background.#{config}"

  stopRefresh: =>
    console.log "refresh stop"
    if @refreshInterval
      clearInterval @refreshInterval

  startRefresh: =>
    console.log "refresh start"
    @stopRefresh()
    @refreshRate = @getConfig "refreshRate"
    @refreshInterval = setInterval @refresh, @refreshRate*1000    

  fetchImageFromURL: (url) ->
     request {url: url, encoding: null}, (err, res, body) =>
       if res && res.statusCode == 200
           contentType = res.headers["content-type"]
           base64 = new Buffer(body).toString('base64')
           data = "url(\"data:#{contentType};base64,#{base64}\")"
           @background.style.backgroundImage = data 
       else
           console.log "request (#{url}) failed"

  fetchImageFromFile: (filepath) ->
      index = filepath.lastIndexOf('.')
      extension = filepath.substr(index).replace('.', '')
      switch extension
          when "png" then contentType = "image/png"
          when "gif" then contentType = "image/gif"
          else contentType = "image/jpeg"
      
      base64 = fs.readFileSync filepath,'base64' 
      data = "url(\"data:#{contentType};base64,#{base64}\")"
      @background.style.backgroundImage = data

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @background.remove()

  getElement: ->
     @background 
     
  refresh: =>
    if @isCustom
        if !@randomEnable
          if @imageURLsEnabled and @imagePathsEnabled
              if @indexInURLs and @current >= @imageURLsSource.length
                  @current = 0
                  @indexInURLs = false
              if !@indexInURLs and @current >= @imagePathsSource.length
                  @current = 0
                  @indexInURLs = true
              if @indexInURLs
                  @fetchImageFromURL @imageURLsSource[@current]
              else
                  @fetchImageFromFile @imagePathsSource[@current]
          else
              if @imageURLsEnabled
                  if @current >= @imageURLsSource.length
                      @current = 0
                  @fetchImageFromURL @imageURLsSource[@current]
              else 
                  if @current >= @imagePathsSource.length
                      @current = 0
                  @fetchImageFromFile @imagePathsSource[@current]
          @current += 1
        else
          if @imageURLsEnabled and @imagePathsEnabled
              if Math.floor(Math.random() * (100)) > 50
                  @fetchImageFromURL @imageURLsSource[Math.floor(Math.random() * (@imageURLsSource.length))]
              else
                  @fetchImageFromFile @imagePathsSource[Math.floor(Math.random() * (@imagePathsSource.length))]
          else
              if @imageURLsEnabled
                  @fetchImageFromURL @imageURLsSource[Math.floor(Math.random() * (@imageURLsSource.length))]
              else
                  @fetchImageFromFile @imagePathsSource[Math.floor(Math.random() * (@imagePathsSource.length))]
    else
        width = atom.config.get "global-background.imageSource.Internet.width"
        height = atom.config.get "global-background.imageSource.Internet.height"
        category = atom.config.get "global-background.imageSource.Internet.category"
        type = atom.config.get "global-background.imageSource.Internet.type"
        iscolor = if type is "color image" then true else false 
        
        if iscolor
            url = "http://lorempixel.com/#{width}/#{height}/#{category}"
        else
            url = "http://lorempixel.com/g/#{width}/#{height}/#{category}"
            
        @fetchImageFromURL url

module.exports = GlobalBackgroundView

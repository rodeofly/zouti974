SCALE = 1
ROTATION = 0
UNIQUE_ID  = 1
MAX = 0
ZOUTI = ["equerre","regle","cercle","rapporteur-180","rapporteur-360","grille","couleurs","pied-a-coulisse","trigo"]
videoElement = ""
audioSelect = ""
videoSelect = ""
  
gotSources = (sourceInfos) ->
  i = 0
  while i != sourceInfos.length
    sourceInfo = sourceInfos[i]
    option = document.createElement('option')
    option.value = sourceInfo.id
    if sourceInfo.kind == 'audio'
      option.text = sourceInfo.label or 'microphone ' + audioSelect.length + 1
      audioSelect.appendChild option
    else if sourceInfo.kind == 'video'
      option.text = sourceInfo.label or 'camera ' + videoSelect.length + 1
      videoSelect.appendChild option
    else
      console.log 'Some other kind of source: ', sourceInfo
    ++i

successCallback = (stream) ->
  window.stream = stream
  # make stream available to console
  videoElement.src = window.URL.createObjectURL(stream)

errorCallback = (error) -> console.log 'navigator.getUserMedia error: ', error

start = ->
  if window.stream
    videoElement.src = null
    window.stream.stop()
  audioSource = audioSelect.value
  videoSource = videoSelect.value
  constraints = 
    audio: optional: [ { sourceId: audioSource } ]
    video: optional: [ { sourceId: videoSource } ]
  navigator.getUserMedia constraints, successCallback, errorCallback
  
up = ($element) ->
  id = $element.attr "id"
  $( "#delete" ).attr "data-id", "#{id}"
  $("#delete").show()
  $( ".zouti" ).removeClass( "selected" ).css zIndex: 0
  $element.addClass( "selected" ).css zIndex: 1
  setTimeout (-> $("#delete").hide()),5000
    
  $( "#slider-s" ).slider "value", $element.attr "data-scale"
  $( "#scale-info" ).html "x#{$element.attr 'data-scale'}"
  $( "#slider-r" ).slider "value", $element.attr "data-rotation"
  $( "#rotation-info" ).html "#{$element.attr 'data-rotation'}°"
     
class Zouti

  constructor : (@zouti) ->
    $( "#delete" ).attr "data-id", "#{@id}"
    $( "#web-iframe" ).after "<div id='Zouti'></div>" if not $( "#Zouti" ).length
    
    creation = (id, zouti, $parent,s,r) ->
      html = "<div id='#{id}' class='zouti' data-zouti='#{zouti}' data-scale='#{s}' data-rotation='#{r}'></div>"     
      $parent.append html

      img = new Image
      img.onload = ->
        $( "##{id}" ).css
          width: "#{img.width}px"
          height: "#{img.height}px"
          background: "100% 100% url('./css/img/#{zouti}.svg')"
          transform: "rotate(#{r}deg) scale(#{s})"    
      img.src = "./css/img/#{zouti}.svg" 
    
    @id = UNIQUE_ID++
    creation(@id, @zouti, $( "#Zouti" ),SCALE,ROTATION)
             
    switch @zouti 
      when "pied-a-coulisse"
        id = UNIQUE_ID++ 
        creation(id, "coulisse", $( "##{@id}" ),1,0)
        $( "##{id}" ).draggable
          axis: "x"
          containment: "parent"   
     
    offset = $( "##{@id}" ).offset()
    $( "##{@id}" )
      .css 
        top: -offset.top
        left: -offset.left
      .draggable start: ( event, ui ) -> up($(this))
    up( $( "##{@id}" ) )

$ ->  
  videoElement = $('video')[0]
  audioSelect = $('select#audioSource')[0]
  videoSelect = $('select#videoSource')[0]
  navigator.getUserMedia = navigator.getUserMedia or navigator.webkitGetUserMedia or navigator.mozGetUserMedia
  if (!navigator.mediaDevices || !navigator.mediaDevices.enumerateDevices)
    alert 'This browser does not support MediaStreamTrack.\n\nTry Chrome.'
  else
    MediaStreamTrack.getSources gotSources
  
  $( audioSelect ).on "change", -> start()
  $( videoSelect ).on "change", -> start()
  #start()
  
  $( "#cam, .local, #menu-div, #delete" ).hide()
  $( "#menu-div, #menu" ).draggable()
  $( "#menu, #menu-close" )
    .on "click", -> $( "#menu-div" ).toggle()
  $( "#zouti-close" )
    .on "click", -> $( "#Zouti" ).toggle()
  $( "#source-toggle" )
    .on "click", -> $( ".web, .local, #cam, #web-iframe" ).toggle()
  $( "#web-go" )
    .on "click", -> $( "#web-iframe" ).attr "src", $( "#web-url" ).val()
  $( "body" )
    .on "click", ".zouti", -> up($(this))
  $( "body" )
    .on "click", "#delete", ->
      id = $(this).attr( 'data-id' )
      $( "##{id}" ).css visibility: "hidden"
      $( this ).hide() 
    
  for zouti in ZOUTI
    $( "#menu-div" ).append "<button id='create-#{zouti}' data-zouti='#{zouti}'>#{zouti}</button>"
    $( "#create-#{zouti}" ).on "click", -> new Zouti( $( this ).attr "data-zouti" )
   
  $("#slider-s").slider       
    value: SCALE
    min  : 0.1
    max  : 4
    step : 0.01
    slide: (event, ui) ->
      SCALE = ui.value
      $( "#scale-info" ).html("x#{SCALE}")
      $('.selected')
        .css 'transform', "rotate(#{$('.selected').attr 'data-rotation'}deg) scale(#{SCALE})"
        .attr "data-scale", "#{SCALE}"
         
  $("#slider-r").slider    
    value: ROTATION
    orientation: "vertical"
    min  : -180
    max  : 180
    step : 1
    slide: (event, ui) ->
      ROTATION = ui.value
      $( "#rotation-info" ).html("#{ROTATION}°")
      $('.selected')
        .css 'transform', "rotate(#{ROTATION}deg) scale(#{$('.selected').attr 'data-scale'})"
        .attr "data-rotation", "#{ROTATION}"        


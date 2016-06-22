SCALE = 1
ROTATION = 0
UNIQUE_ID  = 1
MAX = 0
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
  $( ".zouti" )
    .removeClass "selected"
    .css "z-index: 0;"
  $element
    .addClass "selected"
    .css "z-index: 1;"
  setTimeout (-> $("#delete").hide()),5000
    
  $( "#slider-s" ).slider "value", $element.attr "data-scale"
  $( "#scale-info" ).html "x#{$element.attr 'data-scale'}"
  
  $( "#slider-r" ).slider "value", $element.attr "data-rotation"
  $( "#rotation-info" ).html "#{$element.attr 'data-rotation'}°"
     
class Zouti
  constructor : (@zouti) ->
    if not $( "#Zouti" ).length
      $( "#cam" ).after "<div id='Zouti'></div>"
    @id = UNIQUE_ID++
    @layer = MAX++
    
    html = "<div id='#{@id}' class='zouti #{@zouti}' data-zouti='#{@zouti}' data-scale='1' data-rotation='0'></div>"     
    $( ".zouti"  ).removeClass "selected"
    $( "#Zouti"    ).append "<div id='#{@id}' class='zouti #{@zouti}' data-zouti='#{@zouti}' data-scale='1' data-rotation='0'></div>" 
    
    if @zouti is "pied-a-coulisse" 
      $( "##{@id}" ).append "<div class='zouti coulisse' data-zouti='coulisse' data-scale='1' data-rotation='0'></div>" 
      $( "##{@id} .coulisse" ).draggable
        axis: "x"
        containment: "parent"
        
    x = $( "##{@id}" ).offset()
    $( "##{@id}" )
      .draggable
        start: ( event, ui ) -> up($(this))
      .addClass "selected"
      .css top: -x.top, left: -x.left
    $( "#delete" ).attr "data-id", "#{@id}"

$ ->
  $( "#cam, .local" ).toggle()
  $( "#menu-div, #delete" ).hide()
  $( "#menu-div, #menu" ).draggable()
  $( "#menu, #menu-close" ).on "click", -> $( "#menu-div" ).toggle()
  $( "#source-toggle" ).on "click", -> $( ".web, .local, #cam, #web-iframe" ).toggle()
  $( "#web-go" ).on "click", ->
    $( "#web-iframe" ).attr "src", $( "#web-url" ).val()
  
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

  for zouti in ["equerre","regle","rapporteur-180","rapporteur-360","grille","couleurs","pied-a-coulisse"]
    $( "#menu-div" ).append "<button id='create-#{zouti}' data-zouti='#{zouti}'>#{zouti}</button>"
    $( "#create-#{zouti}" ).on "click", -> new Zouti( $( this ).attr "data-zouti" )
      
  $( "body" ).on "click", ".zouti", -> up($(this))
  
   
  $( "body" ).on "click", "#delete", ->
    $( "##{$(this).attr 'data-id'}" ).remove()
    $( this ).hide()   
    
  $("#slider-s").slider       
    value: SCALE
    min  : 0
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


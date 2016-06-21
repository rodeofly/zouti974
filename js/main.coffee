SCALE = 1
ROTATION = 0
UNIQUE_ID  = 1
MAX = 0

class Zouti
  constructor : (@type) ->
    if not $( "#Zouti" ).length
      $( "#cam" ).after "<div id='Zouti'></div>"
    @id = UNIQUE_ID++
    
    html = "<div id='#{@id}' class='zouti #{@type}' data-scale='1' data-rotation='0'></div>"
    
    $( ".zouti"  ).removeClass "selected"
    $( "#Zouti"    ).append html 
    x = $( "##{@id}" ).offset()
    $( "##{@id}" )
      .draggable()
      .addClass "selected"
      .css top: -x.top, left: -x.left
    $( "#delete" ).attr "data-id", "#{@id}"

$ ->
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

  videoElement = document.querySelector('video')
  audioSelect = document.querySelector('select#audioSource')
  videoSelect = document.querySelector('select#videoSource')
  navigator.getUserMedia = navigator.getUserMedia or navigator.webkitGetUserMedia or navigator.mozGetUserMedia
  if (!navigator.mediaDevices || !navigator.mediaDevices.enumerateDevices)
    alert 'This browser does not support MediaStreamTrack.\n\nTry Chrome.'
  else
    MediaStreamTrack.getSources gotSources
  
  $( audioSelect ).on "change", -> start()
  $( videoSelect ).on "change", -> start()
  #start()
  
  screen = $('body')[0]
  $( "#menu-div" ).toggle()
  $( "#menu" ).on "click", -> $( "#menu-div" ).toggle()
  
  $( "#create-equerre" ).on "click", -> 
    new Zouti("equerre")
  
  $( "#create-regle" ).on "click", -> 
    new Zouti("regle")
  
  $( "#create-rapporteur-180" ).on "click", -> 
    new Zouti("rapporteur-180")
  
  $( "#create-rapporteur-360" ).on "click", -> 
    new Zouti("rapporteur-360")
  
  $( "#create-grille" ).on "click", -> 
    new Zouti("grille")
  
  $( "#create-couleurs" ).on "click", -> 
    new Zouti("couleurs")
  
  $( "#create-pied-a-coulisse" ).on "click", -> 
    new Zouti("pied-a-coulisse")
    $( "#glissiere2" ).draggable()
  
 
    
    
  $( "body" ).on "click", ".zouti", ->
    $("#delete").show()
    id = $(this).attr "id"
    $( ".zouti" ).removeClass "selected"
    $( "#delete" ).attr "data-id", "#{id}"
    
    setTimeout (-> $("#delete").hide()),2000
    $( this )
      .addClass "selected"
      .css zIndex: MAX++
    

  $( "body" ).on "click", "#delete", ->
    $( "##{$(this).attr 'data-id'}" ).remove()
    $( this ).hide()
      
  $( ".main-container" ).toggle()
  $("#toggle-menu").on "click", -> $( ".main-container" ).toggle()
  
  $( "#menu-div" ).draggable()
  $("#slider-s").slider       
    value: SCALE
    min  : 0
    max  : 4
    step : 0.01
    slide: (event, ui) ->
      SCALE = ui.value
      $( "#scale-info" ).html("x#{SCALE}")
      $('.selected').css 'transform', "rotate(#{ROTATION}deg) scale(#{SCALE})"
          
  $("#slider-r").slider    
    value: ROTATION
    orientation: "vertical"
    min  : -180
    max  : 180
    step : 1
    slide: (event, ui) ->
      ROTATION = ui.value
      $( "#rotation-info" ).html("#{ROTATION}°")
      $('.selected').css 'transform', "rotate(#{ROTATION}deg) scale(#{SCALE})"






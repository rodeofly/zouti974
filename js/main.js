// Generated by CoffeeScript 1.10.0
(function() {
  var ROTATION, SCALE, UNIQUE_ID, Zouti;

  SCALE = 1;

  ROTATION = 0;

  UNIQUE_ID = 1;

  Zouti = (function() {
    function Zouti(type) {
      var html;
      this.type = type;
      if (!$("#Zouti").length) {
        $("body").prepend("<div id='Zouti'></div>");
      }
      this.id = UNIQUE_ID++;
      html = "<div id='" + this.id + "' class='zouti " + this.type + "' data-scale='1' data-rotation='0'></div>";
      $(".zouti").removeClass("selected");
      $("#Zouti").prepend(html);
      $("#" + this.id).draggable().addClass("selected");
    }

    return Zouti;

  })();

  $(function() {
    var audioSelect, errorCallback, gotSources, screen, start, successCallback, videoElement, videoSelect;
    gotSources = function(sourceInfos) {
      var i, option, sourceInfo;
      i = 0;
      while (i !== sourceInfos.length) {
        sourceInfo = sourceInfos[i];
        option = document.createElement('option');
        option.value = sourceInfo.id;
        if (sourceInfo.kind === 'audio') {
          option.text = sourceInfo.label || 'microphone ' + audioSelect.length + 1;
          audioSelect.appendChild(option);
        } else if (sourceInfo.kind === 'video') {
          option.text = sourceInfo.label || 'camera ' + videoSelect.length + 1;
          videoSelect.appendChild(option);
        } else {
          console.log('Some other kind of source: ', sourceInfo);
        }
        ++i;
      }
    };
    successCallback = function(stream) {
      window.stream = stream;
      videoElement.src = window.URL.createObjectURL(stream);
      videoElement.play();
    };
    errorCallback = function(error) {
      console.log('navigator.getUserMedia error: ', error);
    };
    start = function() {
      var audioSource, constraints, videoSource;
      if (window.stream) {
        videoElement.src = null;
        window.stream.stop();
      }
      audioSource = audioSelect.value;
      videoSource = videoSelect.value;
      constraints = {
        audio: {
          optional: [
            {
              sourceId: audioSource
            }
          ]
        },
        video: {
          optional: [
            {
              sourceId: videoSource
            }
          ]
        }
      };
      navigator.getUserMedia(constraints, successCallback, errorCallback);
    };
    'use strict';
    videoElement = document.querySelector('video');
    audioSelect = document.querySelector('select#audioSource');
    videoSelect = document.querySelector('select#videoSource');
    navigator.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia;
    if (!navigator.mediaDevices || !navigator.mediaDevices.enumerateDevices) {
      alert('This browser does not support MediaStreamTrack.\n\nTry Chrome.');
    } else {
      MediaStreamTrack.getSources(gotSources);
    }
    audioSelect.onchange = start();
    videoSelect.onchange = start();
    start();
    screen = $('body')[0];
    $("#menu-div").toggle();
    $("#menu").on("click", function() {
      return $("#menu-div").toggle();
    });
    $("#create-equerre").on("click", function() {
      return new Zouti("equerre");
    });
    $("#create-rapporteur").on("click", function() {
      return new Zouti("rapporteur");
    });
    $("body").on("click", ".zouti", function() {
      $(".zouti").removeClass("selected");
      $(this).addClass("selected");
      $("#slider-r").slider;
      return $("#slider-s").slider;
    });
    $(".main-container").toggle();
    $("#toggle-menu").on("click", function() {
      return $(".main-container").toggle();
    });
    $("#slider-s").slider({
      value: SCALE,
      min: 0,
      max: 4,
      step: 0.01,
      slide: function(event, ui) {
        SCALE = ui.value;
        return $('.selected').css('transform', "rotate(" + ROTATION + "deg) scale(" + SCALE + ")");
      }
    });
    return $("#slider-r").slider({
      value: ROTATION,
      orientation: "vertical",
      min: -180,
      max: 180,
      step: 1,
      slide: function(event, ui) {
        ROTATION = ui.value;
        return $('.selected').css('transform', "rotate(" + ROTATION + "deg) scale(" + SCALE + ")");
      }
    });
  });

}).call(this);

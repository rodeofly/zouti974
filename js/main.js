// Generated by CoffeeScript 1.10.0
(function() {
  var MAX, ROTATION, SCALE, UNIQUE_ID, Zouti;

  SCALE = 1;

  ROTATION = 0;

  UNIQUE_ID = 1;

  MAX = 0;

  Zouti = (function() {
    function Zouti(type) {
      var html, x;
      this.type = type;
      if (!$("#Zouti").length) {
        $("#cam").after("<div id='Zouti'></div>");
      }
      this.id = UNIQUE_ID++;
      html = "<div id='" + this.id + "' class='zouti " + this.type + "' data-scale='1' data-rotation='0'></div>";
      $(".zouti").removeClass("selected");
      $("#Zouti").append(html);
      x = $("#" + this.id).offset();
      $("#" + this.id).draggable().addClass("selected").css({
        top: -x.top,
        left: -x.left
      });
      $("#delete").attr("data-id", "" + this.id);
    }

    return Zouti;

  })();

  $(function() {
    var audioSelect, errorCallback, gotSources, screen, start, successCallback, videoElement, videoSelect;
    gotSources = function(sourceInfos) {
      var i, option, results, sourceInfo;
      i = 0;
      results = [];
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
        results.push(++i);
      }
      return results;
    };
    successCallback = function(stream) {
      window.stream = stream;
      return videoElement.src = window.URL.createObjectURL(stream);
    };
    errorCallback = function(error) {
      return console.log('navigator.getUserMedia error: ', error);
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
      return navigator.getUserMedia(constraints, successCallback, errorCallback);
    };
    videoElement = document.querySelector('video');
    audioSelect = document.querySelector('select#audioSource');
    videoSelect = document.querySelector('select#videoSource');
    navigator.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia;
    if (!navigator.mediaDevices || !navigator.mediaDevices.enumerateDevices) {
      alert('This browser does not support MediaStreamTrack.\n\nTry Chrome.');
    } else {
      MediaStreamTrack.getSources(gotSources);
    }
    $(audioSelect).on("change", function() {
      return start();
    });
    $(videoSelect).on("change", function() {
      return start();
    });
    screen = $('body')[0];
    $("#menu-div").toggle();
    $("#menu").on("click", function() {
      return $("#menu-div").toggle();
    });
    $("#create-equerre").on("click", function() {
      return new Zouti("equerre");
    });
    $("#create-regle").on("click", function() {
      return new Zouti("regle");
    });
    $("#create-rapporteur-180").on("click", function() {
      return new Zouti("rapporteur-180");
    });
    $("#create-rapporteur-360").on("click", function() {
      return new Zouti("rapporteur-360");
    });
    $("#create-grille").on("click", function() {
      return new Zouti("grille");
    });
    $("#create-couleurs").on("click", function() {
      return new Zouti("couleurs");
    });
    $("#create-pied-a-coulisse").on("click", function() {
      new Zouti("pied-a-coulisse");
      return $("#glissiere2").draggable();
    });
    $("body").on("click", ".zouti", function() {
      var id;
      $("#delete").show();
      id = $(this).attr("id");
      $(".zouti").removeClass("selected");
      $("#delete").attr("data-id", "" + id);
      setTimeout((function() {
        return $("#delete").hide();
      }), 2000);
      return $(this).addClass("selected").css({
        zIndex: MAX++
      });
    });
    $("body").on("click", "#delete", function() {
      $("#" + ($(this).attr('data-id'))).remove();
      return $(this).hide();
    });
    $(".main-container").toggle();
    $("#toggle-menu").on("click", function() {
      return $(".main-container").toggle();
    });
    $("#menu-div").draggable();
    $("#slider-s").slider({
      value: SCALE,
      min: 0,
      max: 4,
      step: 0.01,
      slide: function(event, ui) {
        SCALE = ui.value;
        $("#scale-info").html("x" + SCALE);
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
        $("#rotation-info").html(ROTATION + "°");
        return $('.selected').css('transform', "rotate(" + ROTATION + "deg) scale(" + SCALE + ")");
      }
    });
  });

}).call(this);

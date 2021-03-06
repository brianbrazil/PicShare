#= require jquery.fileupload/jquery.fileupload

jQuery ->
  event_id = $("#fileupload").data().eventid
  $("#fileupload").fileupload
    dataType: "json"
    formData: [ {name: 'event_id', value: event_id} ]
    done: (e, data) ->
      $.each data.result.files, (index, file) ->
        $("<p/>").text(file.name).appendTo document.body
    progressall: (e, data) ->
      progress = parseInt(data.loaded / data.total * 100, 10)
      $("#progress .bar").css "width", progress + "%"
    fail: (e, data) ->
      alert "Fail"
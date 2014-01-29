#= require _uploader

$('.datepicker').datepicker
  dateFormat: 'DD, d MM, yy'
  onClose: (selectedDate) ->
    $('#event_endDate').datepicker('option', 'minDate', selectedDate)
    $('#event_startDate').datepicker('option', 'maxDate', selectedDate)
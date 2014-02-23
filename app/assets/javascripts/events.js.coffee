#= require _uploader
#= require jquery.grid-a-licious
#= require colorbox-rails

$('.datepicker').datepicker
  dateFormat: 'DD, d MM, yy'
  onClose: (selectedDate) ->
    $('#event_endDate').datepicker('option', 'minDate', selectedDate)
    $('#event_startDate').datepicker('option', 'maxDate', selectedDate)

$('.gridalicious').gridalicious
  selector: '.gridItem'
  animate: true
  width: 240
  gutter: 2
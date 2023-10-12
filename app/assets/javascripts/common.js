$(function() {
  $('.datepicker').datetimepicker({ format: 'DD-MM-YYYY', useCurrent: false, maxDate: 'now', icons: { previous: "fa fa-chevron-left", next: "fa fa-chevron-right" }});

  $(document).on("dp.change", ".filter-form input", function() {
    $(this).parents('form').submit();
  });

  $(document).on("change", ".time-interval", function() {
    $(this).parents('form').submit();
  });

  $(".delete-icon").on("click", function() {
    $(this).prev(".delete-attachment").val(true);
    $(this).parent().hide();
  });

  $('#attachmentModal').on('show.bs.modal', function (event) {
    var button = $(event.relatedTarget);
    var url = button.data('url');
    $("#attachment").attr('data', url);
  });
});

$('#otp').on('keyup mouseout', function() {
  if($(this).val().length == 6){
    $('#authenticate_otp_btn').prop('disabled', false);
  } else {
    $('#authenticate_otp_btn').prop('disabled', true);
  }
});

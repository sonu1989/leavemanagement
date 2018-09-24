$(document).on('click', '.accept-reject-btn', function(){
  $('#reject-leave-model').modal('show');
})

$(document).on('click', '#menu_toggle', function(){
  $('body').toggleClass('nav-md nav-sm')
});

$(document).on('click', "#reject-save-btn", function(e){
  var reason = $('.reason').val();
  var id = $('.accept-reject-btn').attr('leave-id');
  var status = $('#heading-hidden').val();
  status = 'unapproved';
  url = ''
  role = $("#user-role").val()
  if (role == 'manager'){
    url = "/leaves/"+id
  }else{
    url = "/admin/leaves/"+id
  }
  if (reason.length <= 0){
    $('.error').css('display','block');
    e.preventDefault();
  }else{
    $.ajax({
      type: "PUT",
      url: url,
      data: {
        id: id,
        reason: reason,
        status: status
      },
      success: function(data) {
        $('.status').text(data.leave.status);
        $('.accept-reject-btn').attr('status', data.leave.status);
        $('.accept-reject-btn').hide();
        $('#reject-leave-model').modal('hide');
        return false;
      },
      error: function(data) {
        return false;
      }
    });
  }
})
$(document).ready(function(){
  $('.holiday_date').datepicker({format: 'dd-mm-yyyy'});

  $('.holiday_date').on('changeDate', function(ev){
    $(this).datepicker('hide');
  });

  $('#user_joining_date').datepicker({format: 'dd-mm-yyyy'});

  $('#user_joining_date').on('changeDate', function(ev){
    $(this).datepicker('hide');
  });

});


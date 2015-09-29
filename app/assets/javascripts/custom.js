$(document).on('click', '.accept-reject-btn', function(){
  $('#reject-leave-model').modal('show');
})

$(document).on('click', "#reject-save-btn", function(e){
  var reason = $('.reason').val();
  var id = $('.accept-reject-btn').attr('leave-id');
  var status = $('#heading-hidden').val();
  status = status == 'Accept' ? 'accepted' : 'rejected';
  if (reason.length <= 0){
    $('.error').css('display','block');
    e.preventDefault();
  }else{
    $.ajax({
      type: "PUT",
      url: "/leaves/"+id,
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
$(document).on('turbolinks:load', function() {
  var days = []
  $('a.day').on('click', function(){
    date = $(this).attr('date');
    _this = $(this);
    leave_type = ''
    check_leave_type = false
    $('.leave_type').hide();
    $("input[type='radio']:checked"). val();
    $("input[type='radio']").each(function(index, element){
      if ($(element).is(":checked")){
        check_leave_type = true
      }
    });
    if (check_leave_type == false){
      $('.leave_type').show();
    }
    else{
      $(this).parent().addClass('selected')
      leave_days(days, date, _this)
    }
  });

  // Save leave
  $('#save_leave').on('click', function(e){
    var form_url = $(this).parents('form').attr('action')
    description = $("#leave_description").val()
    user_id = $("#leave_user_id").val()
    e.preventDefault();
    if(days.length < 1){
      $('.description_error').show().text('Select at least one date');
    }
    else if (description.length < 1){
      $('.description_error').show().text("Description can't blank");
    }
    else{
      $.ajax({
        url: form_url,
        type: "POST",
        data: {leave: {days: days, description: description, user_id: user_id}}
      });
    }
  });

  $('a').on('click', function(e){
    url =  $(this).attr('href')
    if(url.includes('/leaves/new?')){
      window.location.reload()
    }
  })
    
  $('.simple-calendar').find('.taken').each(function(index, element){
    title = $(element).attr('title')
    $(element).parent().attr('title', title)
    $(element).parent().addClass('taken');
  });

  $('.simple-calendar').find('.holiday').each(function(index, element){
    title = $(element).attr('title')
    $(element).parent().attr('title', title)
    $(element).parent().addClass('holiday');
  });

});


function leave_days(days, date, that){
  leave_type = $("input[type='radio']:checked").val();
  if(days.length == 0){
    day = {date: date, leave_type: leave_type}
    days.push(day)
  }
  else{
    count = 1;
    break_loop = false
    days.forEach(function(element, index) {
      if (element.date != date && break_loop == false){
        if (days.length == count){
          day = {date: date, leave_type: leave_type}
          days.push(day);
          break_loop = true
        }
        else{
          count = count+1
        }
      }
      else{
        console.log(that)
        that.parent().removeClass('selected')
        days.splice(index,1);
      }
    });
  }
}

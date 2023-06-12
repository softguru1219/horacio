$(document).ready(function(){
  // Set to required password and confirmation 
  $( ".edit-js-validate" ).submit(function( event ) {
    event.preventDefault();
    if ($("#user_current_password").val()){
      $("#user_password").prop('required',true);
      $("#user_password_confirmation").prop('required',true);
    }
    else{
      $("#user_password").prop('required',false);
      $("#user_password_confirmation").prop('required',false);
    }

  });

  //hsCore function
  hsCore()
  
  // Active the current day of week
  active_day()

  // Remove chart guide image
  remove_chart_guide()

  // Add the color of column by odd or even
  change_column_color(table_id="next-exams")
  change_column_color(table_id="completed-exams")

  // Preview the uploaded image
  showMyImage(fileInput=null)

  // Show the date for Prochain cours and examens
  balanceDate()

  // Disable the pagination button if current week
  diable_pagination()

  // Loading the data when clicked the forward or prev button
  get_prev_forward_date()

})

function hsCore(){
  $.HSCore.components.HSValidation.init('.js-validate', {
    rules: {
      username: {
        presence: true
      },
      password: {
        presence: true
      }
    }
  });

  $.HSCore.components.HSValidation.init('.edit-js-validate', {
    current_password: {
      presence: true,
    },
    password: {
      presence: true
    },
    password_confirmation: {
      equalTo: '#user_password'
    },
  });

  // initialization of datatables
  $.HSCore.components.HSDatatables.init('.js-datatable');

  // initialization of select picker
  $.HSCore.components.HSSelectPicker.init('.js-select');

  // initialization of forms
  $.HSCore.components.HSFocusState.init();

  $.HSCore.components.HSRangeDatepicker.init('.js-range-datepicker');

  // initialization of autonomous popups
  $.HSCore.components.HSModalWindow.init('[data-modal-target]', '.js-modal-window', {
    autonomous: true
  });

  // Select data from calendar
  $('#date-simulate').click(function(){
    post_datepicker()
  })

  // Simulating the email 
  $('#date-simulate').click(function(){
    post_datepicker()
  })

  $('#email-simulate').click(function(){
    email_checking()
  })

}

function active_day(){
  active_day = new Date().getDay()
  rows = $(".days_of_week tr")
  if (rows[active_day - 1]){
    rows.eq(active_day - 1).removeClass("inactive_day")
    rows.eq(active_day - 1).addClass("active-day")
  }
}

function remove_chart_guide(){
  $('g[aria-labelledby="id-66-title"]').hide()
  $('g[aria-labelledby="id-141-title"]').hide()
  $('g[aria-labelledby="id-153-title"]').hide()
  
}

function change_column_color(table_id) {
  tr_tags = $("tbody#"+ table_id + " tr")
  for (i=0; i<tr_tags.length; i++){
    if (i % 2 === 0) {
      tr_tags.eq(i).addClass("odd")
    } else {
      tr_tags.eq(i).addClass("event")
    }
  }
}

function post_datepicker(){
  var url = window.location.pathname; 
  selected_date = $('input.js-range-datepicker').val()
  $.ajax({
    url : "/schedule",
    type : "get",
    data : { selected_date: selected_date },
    success: function(data) {
      url += '?selected_date=' + selected_date
      window.location.href = url;
    },
  });
}

function email_checking(){
  var url = window.location.pathname; 
  selected_date = $('input.js-range-datepicker').val()
  $.ajax({
    url : "/schedule",
    type : "get",
    data : { selected_date: selected_date, email_checking: true},
    success: function(data) {
      url += '?selected_date=' + selected_date
      window.location.href = url;
    },
  });
}

function showMyImage(fileInput) {
  if (fileInput != null){
    var files = fileInput.files;
    for (var i = 0; i < files.length; i++) {           
      var file = files[i];
      var imageType = /image.*/;     
      if (!file.type.match(imageType)) {
          continue;
      }           
      var img=document.getElementById("thumbnil");            
      img.file = file;    
      var reader = new FileReader();
      reader.onload = (function(aImg) { 
        return function(e) { 
            aImg.src = e.target.result; 
        }; 
      })(img);
      reader.readAsDataURL(file);
    }    
  }
}

function balanceDate(){
  var next_cours_date = $("tr.active-day").next("tr").find("td:eq(0)").text()
  var am_cours = $("tr.active-day").next("tr").find("td:eq(1)").text()
  var pm_cours = $("tr.active-day").next("tr").find("td:eq(2)").text()

  if (next_cours_date.length > 0){
    if (am_cours != '-' || pm_cours != '-') {
      $("#cours-date").html(next_cours_date)
    } else {
      $("#cours-date").html('-')
    }
  } else {
    $("#cours-date").html('-')
  }
  
  var examen_date = $('#next-exams tr td').eq(0).text()
  $("#examen-date").html(examen_date)
}

function getMonday(d) {
  d = new Date(d);
  var day = d.getDay(),
  diff = d.getDate() - day + (day == 0 ? -6:1); // adjust when day is sunday
  return new Date(d.setDate(diff));
}

function diable_pagination() {
  // picker_date = $('input.js-range-datepicker').val()
  // if (picker_date.length > 0) {
  //   selected_date = new Date(picker_date.split("/").reverse().join("-"))
  // }else {
  //   selected_date = new Date()
  // }
  
  // selected_monday_date = getMonday(selected_date)
  hide_selected_date = $('#hide-seleted-date').text()
  hide_current_date = $('#hide-current-date').text()
  

  if (hide_selected_date === hide_current_date){
    $("a#previous").addClass("disabled")
  } else {
    $("a#previous").removeClass("disabled")
  }
}

function get_prev_forward_date(){
  var url = window.location.pathname;
  
  $("a#forward").click(function(){
    hide_selected_date = $('#hide-seleted-date').text()
    $.ajax({
      url : "/schedule",
      type : "get",
      data : { selected_date: hide_selected_date, forward: true},
      success: function(data) {
        url += '?selected_date=' + hide_selected_date + '&forward=' + 'true'
        window.location.href = url;
      },
    });
  })

  $("a#previous").click(function(){
    hide_selected_date = $('#hide-seleted-date').text()
    $.ajax({
      url : "/schedule",
      type : "get",
      data : { selected_date: hide_selected_date, previous: true},
      success: function(data) {
        url += '?selected_date=' + hide_selected_date + '&previous=' + 'true'
        window.location.href = url;
      },
    });
  })
}



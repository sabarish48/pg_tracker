var divCalendar;
var Calendar = {
  initCalendar: function(){
    divCalendar = $("divCalendar");
    Calendar.title = $("CalendarTitle");
    Calendar.currentDate = new Date();
    Calendar.visible = false;
    Calendar.initialize();
    Calendar.setDate(new Date());
  },

  initialize: function(){
    for (var i = 1; i < 43; i++) {
      if($('day_' + i).addEventListener) {
        $('day_' + i).addEventListener('click', Calendar.dateSelected, false);
      } else if ($('day_' + i).attachEvent) {
        $('day_' + i).attachEvent('onclick', Calendar.dateSelected);
      }
    }
  },

  popup: function(trgt, listener, date, beginDate){
    if (Calendar.visible == true) {
      Calendar.cancel();
      return;
    }

    if(beginDate){
        temp_date = new Date(beginDate.substr(0, 4), beginDate.substr(5, 2) - 1, beginDate.substr(8, 2))
        if(temp_date != "Invalid Date" && temp_date  != 'NaN'){
            Calendar.beginDate = beginDate;
        }
    }
    else{
        Calendar.beginDate = null;
    }

    if (date) {
      sent_date = validDate(date.substr(0, 4), date.substr(5, 2) - 1, date.substr(8, 2));
      Calendar.setDate(sent_date);
    }
    else if(Calendar.beginDate){
      sent_date = validDate(Calendar.beginDate.substr(0, 4), Calendar.beginDate.substr(5, 2) - 1, new Number(Calendar.beginDate.substr(8, 2)) + 1);
      Calendar.setDate(sent_date);
    }
    else {
      Calendar.setDate(new Date());
    }
    Calendar.target = trgt;
    Calendar.listener = listener;

    if(trgt.nextSiblings) {
     trgt.nextSiblings().first().appendChild(divCalendar);
    } else {
      Element.nextSiblings(trgt).first().appendChild(divCalendar);
    }
    divCalendar.style.display = "";
    Calendar.visible = true;
  },

  cancel: function(){
    Calendar.target = null;
    divCalendar.style.display = "none";
    Calendar.visible = false;
  },

  dateSelected: function(evt){
    if (Calendar.target) {
      var value = evt.target ? evt.target.value : evt.srcElement.value;
      if (value) {
        Calendar.listener(Calendar.target, value);
        Calendar.cancel();
      }
    }
  },

  setDate: function(someDate, beginDate){
    var baseDate = new Date(someDate.getFullYear(), someDate.getMonth(), 1);
    var date_index = baseDate.getDay();

    baseDate.setDate(-date_index + 1);
    Calendar.currentDate = new Date(someDate.getFullYear(), someDate.getMonth(), someDate.getDate());

    Calendar.title.innerHTML = monthStrings[Calendar.currentDate.getMonth()] + ", " + Calendar.currentDate.getFullYear();

    var divDay;
    var i = 1;
    for (i; i < 43; i++) {
      divDay = document.getElementById("day_" + i);
      if (divDay) {
        divDay.innerHTML = baseDate.getDate();

        if (baseDate.getMonth() == someDate.getMonth()) {
          if (Calendar.beginDate && (validDate(Calendar.beginDate.substr(0, 4), Calendar.beginDate.substr(5, 2) - 1, Calendar.beginDate.substr(8, 2)) >= baseDate)) {
            divDay.className = "calendar_day_old_date";
            divDay.value = "";
          }
          else {
            divDay.className = "calendar_day";
            divDay.value = new Date(baseDate.getFullYear(), baseDate.getMonth(), baseDate.getDate());
          }

          if (baseDate.getDate() == someDate.getDate()) {
            divDay.className = divDay.className + " selected";
          }

        }
        else {
          divDay.className = "calendar_day_diff_month";
        }

        divDay.className = divDay.className;
      }
      baseDate.setDate(baseDate.getDate() + 1);
    }
  }
}

function validDate(y, m, d){
   new_date = new Date(y, m, d);
   if (new_date == "Invalid Date" || new_date  == 'NaN'){
       return new Date();
   }
   else{
       return new_date;
   }
}

function PreviewMonth(){
  var prevDate = new Date(Calendar.currentDate.getFullYear(), Calendar.currentDate.getMonth(), Calendar.currentDate.getDate());
  prevDate.setDate(0);
  Calendar.setDate(prevDate);
}

function NextMonth(){
  var nextDate = new Date(Calendar.currentDate.getFullYear(), Calendar.currentDate.getMonth(), Calendar.currentDate.getDate());
  nextDate.setMonth(nextDate.getMonth() + 1);
  nextDate.setDate(1);
  Calendar.setDate(nextDate);
}

var monthStrings = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
var monthNumbers = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"];

/**
 * Returns the date in the format "August 18, 1986"
 * @param {Object} date - Date to be formatted
 */
function formatDate(date){
  return date.getFullYear() + "-" + monthNumbers[date.getMonth()] + "-" + date.getDate();
}

var transactionDateListener = function(sender, value) {
  $('item_transaction_date').value = formatDate(value);
}

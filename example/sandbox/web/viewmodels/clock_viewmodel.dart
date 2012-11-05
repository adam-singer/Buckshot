part of sandbox;

class ClockViewModel extends ViewModelBase
{
  const months = const ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul',
                        'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  FrameworkProperty<num> secondInDegs;
  FrameworkProperty<num> minuteInDegs;
  FrameworkProperty<num> hourInDegs;
  FrameworkProperty<String> dayAndMonth;

  ClockViewModel(){
    _initClockViewModelProperties();

    _startTimer();
  }

  void _startTimer(){
    window.setInterval((){
      Date d = new Date.now();

      _updateDate(d);

      secondInDegs.value = d.second * 6;

      minuteInDegs.value = (d.minute * 6) + (d.second / 10);

      final hour = d.hour % 24 > 0 ? d.hour - 12 : d.hour;

      hourInDegs.value = (hour * 30) + (d.minute / 2);
    }, 1000);

  }

  void _updateDate(Date d){
    dayAndMonth.value = "${d.day} ${months[d.month]}";
  }



  void _initClockViewModelProperties(){
    secondInDegs = new FrameworkProperty(this, 'secondInDegs',
        defaultValue: 0);

    hourInDegs = new FrameworkProperty(this, 'hourInDegs',
        defaultValue: 0);

    minuteInDegs = new FrameworkProperty(this, 'minuteInDegs',
        defaultValue: 0);

    dayAndMonth = new FrameworkProperty(this, 'dayAndMonth',
        defaultValue: '');
  }
}

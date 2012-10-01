
class ClockViewModel extends ViewModelBase
{
  FrameworkProperty secondInDegsProperty;
  FrameworkProperty minuteInDegsProperty;
  FrameworkProperty hourInDegsProperty;
  FrameworkProperty dayAndMonthProperty;

  ClockViewModel(){
    _initClockViewModelProperties();

    _startTimer();
  }

  void _startTimer(){
    window.setInterval((){
      Date d = new Date.now();

      _updateDate(d);

      setValue(secondInDegsProperty, d.second * 6);

      setValue(minuteInDegsProperty, (d.minute * 6) + (d.second / 10));

      final hour = d.hour % 24 > 0 ? d.hour - 12 : d.hour;

      setValue(hourInDegsProperty, (hour * 30) + (d.minute / 2));
    }, 1000);

  }

  void _updateDate(Date d){
    final months = const ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul',
                          'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    setValue(dayAndMonthProperty, "${d.day} ${months[d.month]}");
  }



  void _initClockViewModelProperties(){
    secondInDegsProperty = new FrameworkProperty(this, 'secondInDegs',
        defaultValue: 0);

    hourInDegsProperty = new FrameworkProperty(this, 'hourInDegs',
        defaultValue: 0);

    minuteInDegsProperty = new FrameworkProperty(this, 'minuteInDegs',
        defaultValue: 0);

    dayAndMonthProperty = new FrameworkProperty(this, 'dayAndMonth',
        defaultValue: '');
  }
}

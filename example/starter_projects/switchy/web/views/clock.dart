
class Clock extends View
{
  Clock() : super.fromResource('#clock'){
    ready.then((t){
      t.dataContext = new ClockViewModel();
    });
  }
}

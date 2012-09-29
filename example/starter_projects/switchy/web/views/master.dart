
/**
 * Represents the master view of the Switch application.
 */
class Master extends View
{
  Master() : super.fromResource('#master'){
    ready.then((t){
      t.dataContext = new MasterViewModel();
    });
  }
}


class Error extends View
{
  Error(){
    Template.deserialize(Template.getTemplate('#error'))
    .then((t){
      rootVisual = t;
    });
  }
}


class AccordionItem extends Control implements IFrameworkContainer 
{
  AccordionItem()
  {
    Browser.appendClass(rawElement, "AccordionItem");
  }

  AccordionItem.register() : super.register();
  makeMe() => new AccordionItem();
}

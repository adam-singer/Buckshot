
class AccordionItem extends Control implements IFrameworkContainer
{
  FrameworkProperty<FrameworkElement> header;
  FrameworkProperty<FrameworkElement> body;

  AccordionItem()
  {
    Browser.appendClass(rawElement, "AccordionItem");

    _initAccordionItemProperties();

    stateBag[FrameworkObject.CONTAINER_CONTEXT] = body;
  }

  AccordionItem.register() : super.register();
  makeMe() => new AccordionItem();

  get containerContent => body.value;

  void _initAccordionItemProperties(){
    header = new FrameworkProperty(this, 'header');
    body = new FrameworkProperty(this, 'body');
  }
}

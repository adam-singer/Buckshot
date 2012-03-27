class StringToFrameworkElementConverter implements IValueConverter
{
  const StringToFrameworkElementConverter();
  
  Dynamic convert(Dynamic value, [Dynamic parameter]){
    if (!(value is String)) return value;

    return (BuckshotSystem.namedElements.containsKey(value)) ? BuckshotSystem.namedElements[value] : null;
  }
}

class StringToFrameworkElementConverter implements IValueConverter
{
  const StringToFrameworkElementConverter();
  
  Dynamic convert(Dynamic value, [Dynamic parameter]){
    if (!(value is String)) return value;

    return (Buckshot.namedElements.containsKey(value)) ? Buckshot.namedElements[value] : null;
  }
}

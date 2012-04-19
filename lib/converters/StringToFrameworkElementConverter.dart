class StringToFrameworkElementConverter implements IValueConverter
{
  const StringToFrameworkElementConverter();
  
  Dynamic convert(Dynamic value, [Dynamic parameter]){
    if (!(value is String)) return value;

    return (buckshot.namedElements.containsKey(value)) ? buckshot.namedElements[value] : null;
  }
}

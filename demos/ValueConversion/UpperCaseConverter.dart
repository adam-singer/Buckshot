/**
* Converts a string value into an uppercase version */
class UpperCaseConverter implements IValueConverter{

  Dynamic convert(Dynamic value, [Dynamic parameter]) => (value is String) ? value.toUpperCase() : value;
  
}

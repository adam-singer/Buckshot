/**
* A demo value convert which takes any value and halves it */
class InHalfValueConverter implements IValueConverter
{
  
  Dynamic convert(Dynamic value, [Dynamic parameter]) => (value / 2).toInt();

}

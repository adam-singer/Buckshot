// This is a platform-agnostic mirror of the framework, for use by the
// code generation facility.

abstract class FrameworkProperty extends BuckshotObject {}

abstract class AnimatingFrameworkProperty extends FrameworkProperty {}

abstract class FrameworkEvent<T> {}

abstract class BuckshotEvent<T> extends FrameworkEvent {}

abstract class BuckshotObject implements Hashable{}

abstract class FrameworkObject extends BuckshotObject
{
  FrameworkProperty dataContextProperty;

  FrameworkEvent loaded;
  FrameworkEvent unloaded;
  FrameworkEvent measurementChanged;
}

abstract class FrameworkElement extends FrameworkObject
{
  FrameworkProperty marginProperty;
  FrameworkProperty widthProperty;
  FrameworkProperty heightProperty;
  FrameworkProperty htmlIDProperty;
  FrameworkProperty maxWidthProperty;
  FrameworkProperty minWidthProperty;
  FrameworkProperty maxHeightProperty;
  FrameworkProperty minHeightProperty;
  FrameworkProperty cursorProperty;
  FrameworkProperty tagProperty;
  FrameworkProperty hAlignProperty;
  FrameworkProperty vAlignProperty;
  FrameworkProperty zOrderProperty;
  FrameworkProperty actualWidthProperty;
  FrameworkProperty actualHeightProperty;
  AnimatingFrameworkProperty opacityProperty;
  AnimatingFrameworkProperty visibilityProperty;
  FrameworkProperty styleProperty;
  FrameworkProperty draggableProperty;
  AnimatingFrameworkProperty translateXProperty;
  AnimatingFrameworkProperty translateYProperty;
  AnimatingFrameworkProperty translateZProperty;
  AnimatingFrameworkProperty scaleXProperty;
  AnimatingFrameworkProperty scaleYProperty;
  AnimatingFrameworkProperty scaleZProperty;
  AnimatingFrameworkProperty rotateXProperty;
  AnimatingFrameworkProperty rotateYProperty;
  AnimatingFrameworkProperty rotateZProperty;
  FrameworkProperty transformOriginXProperty;
  FrameworkProperty transformOriginYProperty;
  FrameworkProperty transformOriginZProperty;
  FrameworkProperty perspectiveProperty;
  FrameworkProperty actionsProperty;

  FrameworkEvent gotFocus;
  FrameworkEvent lostFocus;
  FrameworkEvent mouseEnter;
  FrameworkEvent mouseLeave;
  FrameworkEvent click;
  FrameworkEvent mouseMove;
  FrameworkEvent mouseDown;
  FrameworkEvent mouseUp;

  FrameworkEvent dragEnter;
  FrameworkEvent dragLeave;
  FrameworkEvent dragOver;
  FrameworkEvent drop;
  FrameworkEvent dragStart;
  FrameworkEvent dragEnd;
}
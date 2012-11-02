part of core_buckshotui_org;

// Copyright (c) 2012, John Evans
// https://github.com/prujohn/dartnet_event_model
// See LICENSE file for Apache 2.0 licensing information.

/**
* Defines event information for property changing event types.
*
* ## See Also
* * [FrameworkPropertyBase]
* * [FrameworkProperty]
* * [AttachedFrameworkProperty]
*/
class PropertyChangingEventArgs extends EventArgs
{
   /// holds the previous value of the [FrameworkPropertyBase].
   final dynamic oldValue;
   /// Holds the new value of the [FrameworkPropertyBase].
   final dynamic newValue;

   PropertyChangingEventArgs(this.oldValue, this.newValue);
}

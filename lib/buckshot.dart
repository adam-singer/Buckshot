// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/// ## Try Buckshot Online ##
/// <http://www.buckshotui.org/sandbox>

#library('core.buckshotui.org');

#import('dart:html');
#import('dart:json');
#import('dart:isolate');
#import('dart:math');

#import('package:xml/xml.dart');
#import('package:dartnet_event_model/events.dart');
#import('package:dart_utils/web.dart');
#import('package:dart_utils/shared.dart');

// Uncomment this to run with reflection.
// Also below, set reflectionEnabled = true.
// #import('dart:mirrors');

#source('src/core/globals.dart');
#source('src/core/buckshot_system.dart');
#source('src/core/framework_object.dart');
#source('src/core/framework_property.dart');
#source('src/core/observable_list.dart');
#source('src/core/framework_element.dart');
#source('src/core/buckshot_object.dart');
#source('src/core/framework_property_base.dart');
#source('src/core/attached_framework_property.dart');
#source('src/core/framework_container.dart');

#source('src/core/polly/polly.dart');
#source('src/core/polly/flex_model.dart');
#source('src/core/polly/_brutus.dart');

#source('src/events/buckshot_event.dart');
#source('src/events/measurement_changed_event_args.dart');
#source('src/events/attached_property_changed_event_args.dart');
#source('src/events/property_changed_event_args.dart');
#source('src/events/drag_event_args.dart');

#source('src/mvvm/view_model_base.dart');
#source('src/mvvm/view.dart');
#source('src/mvvm/data_template.dart');


#source('src/binding/binding.dart');
#source('src/binding/binding_mode.dart');
#source('src/binding/binding_data.dart');

#source('src/elements/panel.dart');
#source('src/elements/stack_panel.dart');
#source('src/elements/text_block.dart');
#source('src/elements/border/border.dart');
#source('src/elements/border/border_style.dart');
#source('src/elements/border/string_to_border_style.dart');
#source('src/elements/layout_canvas.dart');
#source('src/elements/image.dart');
#source('src/elements/raw_html.dart');
#source('src/elements/grid/grid.dart');
#source('src/elements/grid/row_definition.dart');
#source('src/elements/grid/column_definition.dart');
#source('src/elements/grid/_grid_cell.dart');
#source('src/elements/grid/grid_layout_definition.dart');
#source('src/elements/grid/grid_length.dart');
#source('src/elements/collection_presenter.dart');
#source('src/elements/content_presenter.dart');
//#source('elements/DockPanel.dart');

#source('src/elements/actions/action_base.dart');
#source('src/elements/actions/play_animation.dart');
#source('src/elements/actions/set_property.dart');
#source('src/elements/actions/toggle_property.dart');

#source('src/controls/text_box.dart');
#source('src/controls/control/control.dart');
#source('src/controls/control/control_template.dart');
#source('src/controls/radio_button.dart');
#source('src/controls/radio_button_group.dart');
#source('src/controls/button.dart');
#source('src/controls/check_box.dart');
#source('src/controls/text_area.dart');
#source('src/controls/slider.dart');
#source('src/controls/hyperlink.dart');
#source('src/controls/drop_down_list.dart');

#source('src/converters/string_to_numeric.dart');
#source('src/converters/string_to_thickness.dart');
#source('src/converters/string_to_boolean.dart');
#source('src/converters/string_to_gridlength.dart');
#source('src/converters/string_to_gridunittype.dart');
#source('src/converters/string_to_horizontalalignment.dart');
#source('src/converters/string_to_orientation.dart');
#source('src/converters/string_to_verticalalignment.dart');
#source('src/converters/string_to_color.dart');
#source('src/converters/string_to_color_string.dart');
#source('src/converters/string_to_solidcolorbrush.dart');
#source('src/converters/string_to_radialgradientdrawmode.dart');
#source('src/converters/string_to_frameworkelement.dart');
#source('src/converters/string_to_visibility.dart');
#source('src/converters/string_to_inputtypes.dart');
#source('src/converters/string_to_location.dart');

#source('src/resources/framework_resource.dart');
#source('src/resources/resource_collection.dart');
#source('src/resources/var.dart');
#source('src/resources/color.dart');
#source('src/resources/brush.dart');
#source('src/resources/solid_color_brush.dart');
#source('src/resources/linear_gradient_brush.dart');
#source('src/resources/radial_gradient_brush.dart');
#source('src/resources/setter.dart');
#source('src/resources/style_template.dart');
#source('src/resources/gradient_stop.dart');

#source('src/animation/framework_animation.dart');
#source('src/animation/animation_resource.dart');
#source('src/animation/animation_key_frame.dart');
#source('src/animation/animation_state.dart');
#source('src/animation/_css_compiler.dart');

#source('src/elements/shape/shape.dart');
#source('src/elements/shape/ellipse.dart');
#source('src/elements/shape/rectangle.dart');
//#source('elements/shape/Line.dart');
//#source('elements/shape/PolyLine.dart');
//#source('elements/shape/Polygon.dart');

#source('src/templates/presentation_format_provider.dart');
#source('src/templates/xml_template_provider.dart');
#source('src/templates/template.dart');
#source('src/templates/template_object.dart');

//Use this to generate clean dart docs of just the buckshot library
main(){}

/**
 * Set this to true in order to use the mirror-based code.
 *
 * You must also uncomment the import directive for mirrors.
 */
bool reflectionEnabled = false;

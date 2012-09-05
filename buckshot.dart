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

#import('package:dart-xml/xml.dart');
#import('package:DartNet-Event-Model/events.dart');
#import('package:dart_utils/web.dart');
#import('package:dart_utils/shared.dart');
#import('lib/yaml/yaml.dart');

// Uncomment this to run with reflection.  
// Also below, set reflectionEnabled = true.
//#import('dart:mirrors');

#source('lib/core/globals.dart');
#source('lib/core/buckshot_system.dart');
#source('lib/core/framework_object.dart');
#source('lib/core/framework_property.dart');
#source('lib/core/observable_list.dart');
#source('lib/core/framework_element.dart');
#source('lib/core/buckshot_object.dart');
#source('lib/core/framework_property_base.dart');
#source('lib/core/attached_framework_property.dart');
#source('lib/core/data_template.dart');
#source('lib/core/framework_container.dart');

#source('lib/core/polly/polly.dart');
#source('lib/core/polly/flex_model.dart');
#source('lib/core/polly/_brutus.dart');

#source('lib/events/buckshot_event.dart');
#source('lib/events/measurement_changed_event_args.dart');
#source('lib/events/drag_event_args.dart');

#source('lib/mvvm/view_model_base.dart');
#source('lib/mvvm/view.dart');

#source('lib/binding/binding.dart');
#source('lib/binding/binding_mode.dart');
#source('lib/binding/binding_data.dart');

#source('lib/elements/panel.dart');
#source('lib/elements/stack_panel.dart');
#source('lib/elements/text_block.dart');
#source('lib/elements/border.dart');
#source('lib/elements/layout_canvas.dart');
#source('lib/elements/image.dart');
#source('lib/elements/raw_html.dart');
#source('lib/elements/grid/grid.dart');
#source('lib/elements/grid/row_definition.dart');
#source('lib/elements/grid/column_definition.dart');
#source('lib/elements/grid/_grid_cell.dart');
#source('lib/elements/grid/grid_layout_definition.dart');
#source('lib/elements/grid/grid_length.dart');
#source('lib/elements/collection_presenter.dart');
#source('lib/elements/content_presenter.dart');
//#source('elements/DockPanel.dart');

#source('lib/elements/actions/action_base.dart');
#source('lib/elements/actions/play_animation.dart');
#source('lib/elements/actions/set_property.dart');
#source('lib/elements/actions/toggle_property.dart');

#source('lib/controls/text_box.dart');
#source('lib/controls/control/control.dart');
#source('lib/controls/control/control_template.dart');
#source('lib/controls/radio_button.dart');
#source('lib/controls/radio_button_group.dart');
#source('lib/controls/button.dart');
#source('lib/controls/check_box.dart');
#source('lib/controls/text_area.dart');
#source('lib/controls/slider.dart');
#source('lib/controls/hyperlink.dart');
#source('lib/controls/drop_down_list.dart');

#source('lib/converters/string_to_numeric.dart');
#source('lib/converters/string_to_thickness.dart');
#source('lib/converters/string_to_boolean.dart');
#source('lib/converters/string_to_gridlength.dart');
#source('lib/converters/string_to_gridunittype.dart');
#source('lib/converters/string_to_horizontalalignment.dart');
#source('lib/converters/string_to_orientation.dart');
#source('lib/converters/string_to_verticalalignment.dart');
#source('lib/converters/string_to_color.dart');
#source('lib/converters/string_to_solidcolorbrush.dart');
#source('lib/converters/string_to_radialgradientdrawmode.dart');
#source('lib/converters/string_to_frameworkelement.dart');
#source('lib/converters/string_to_visibility.dart');
#source('lib/converters/string_to_inputtypes.dart');
#source('lib/converters/string_to_location.dart');

#source('lib/resources/framework_resource.dart');
#source('lib/resources/resource_collection.dart');
#source('lib/resources/var.dart');
#source('lib/resources/color.dart');
#source('lib/resources/brush.dart');
#source('lib/resources/solid_color_brush.dart');
#source('lib/resources/linear_gradient_brush.dart');
#source('lib/resources/radial_gradient_brush.dart');
#source('lib/resources/setter.dart');
#source('lib/resources/style_template.dart');
#source('lib/resources/gradient_stop.dart');

#source('lib/animation/framework_animation.dart');
#source('lib/animation/animation_resource.dart');
#source('lib/animation/animation_key_frame.dart');
#source('lib/animation/animation_state.dart');
#source('lib/animation/_css_compiler.dart');

#source('lib/elements/shape/shape.dart');
#source('lib/elements/shape/ellipse.dart');
#source('lib/elements/shape/rectangle.dart');
//#source('elements/shape/Line.dart');
//#source('elements/shape/PolyLine.dart');
//#source('elements/shape/Polygon.dart');

#source('lib/templates/presentation_format_provider.dart');
#source('lib/templates/xml_template_provider.dart');
#source('lib/templates/json_template_provider.dart');
#source('lib/templates/yaml_template_provider.dart');
#source('lib/templates/template.dart');
#source('lib/templates/template_object.dart');

//Use this to generate clean dart docs of just the buckshot library
main(){}

/** 
 * Set this to true in order to use the mirror-based code.
 * Note that you muse also enable the import directives for mirrors and miriam.
 */
bool reflectionEnabled = false;

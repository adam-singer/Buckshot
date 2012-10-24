part of core_buckshotui_org;

// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.


/**
 * A [ResourceCollection] template representing default property settings
 * for Buckshot controls.
 *
 * Buckshot will use this theme template if no other is declared.
 */
final String defaultTheme =
'''
<resourcecollection>
  <!-- 
  "Theme: 50 Shades of Grrr" 
  -->

  <color key='theme_debug' value='Orange' />

  <!-- 
  Default Palette 
  -->
  <color key='theme_background_light' value='White' />
  <color key='theme_background_dark' value='WhiteSmoke' />
  <color key='theme_background_mouse_hover' value='LightGray' />
  <color key='theme_background_mouse_down' value='DarkGray' />

  <!-- 
  Default Brushes 
  -->
  <solidcolorbrush key='theme_light_brush' color='{resource theme_background_light}' />
  <solidcolorbrush key='theme_dark_brush' color='{resource theme_background_dark}' />

  <!-- 
  Shadows 
  --> 
  <color key='theme_shadow_color' value='Black' />
  <var key='theme_shadow_x' value='2' />
  <var key='theme_shadow_y' value='2' />
  <var key='theme_shadow_blur' value='4' />

  <!-- 
  Border 
  -->
  <color key='theme_border_color' value='LightGray' />
  <color key='theme_border_color_dark' value='DarkGray' />
  <var key='theme_border_thickness' value='1' />
  <var key='theme_border_padding' value='5' />
  <var key='theme_border_corner_radius' value='0' />
  <!-- Note that border does not have a default background brush. -->

  <!-- 
  Text 
  -->
  <var key='theme_text_font_family' value='Arial' />
  <color key='theme_text_foreground' value='Black' />

  <!-- 
  TextBox 
  -->
  <color key='theme_textbox_border_color' value='Black' />
  <color key='theme_textbox_foreground' value='Black' />
  <solidcolorbrush key='theme_textbox_background' color='{resource theme_background_light}' />
  <var key='theme_textbox_border_thickness' value='1' />
  <var key='theme_textbox_corner_radius' value='0' />
  <var key='theme_textbox_border_style' value='solid' />
  <var key='theme_textbox_padding' value='1' />

  <!--
  TextArea
  -->
  <color key='theme_textarea_border_color' value='Black' />
  <color key='theme_textarea_foreground' value='Black' />
  <solidcolorbrush key='theme_textarea_background' color='{resource theme_background_light}' />
  <var key='theme_textarea_border_thickness' value='1' />
  <var key='theme_textarea_corner_radius' value='0' />
  <var key='theme_textarea_border_style' value='solid' />
  <var key='theme_textarea_padding' value='0' />
  <var key='theme_textarea_font_family' value='courier' />

  <!-- 
  Button 
  -->
  <color key='theme_button_border_color' value='LightGray' />
  <solidcolorbrush key='theme_button_background' color='{resource theme_background_dark}' />
  <lineargradientbrush key='theme_button_background_hover' direction='vertical'>
    <stops>
       <gradientstop color='{resource theme_background_dark}' />
       <gradientstop color='{resource theme_background_mouse_hover}' />
    </stops>
  </lineargradientbrush>
  <var key='theme_button_border_thickness' value='{resource theme_border_thickness}' />
  <var key='theme_button_padding' value='{resource theme_border_padding}' />

  <!-- 
  Accordion
  -->
  <var key='theme_accordion_header_padding' value='{resource theme_border_padding}' />
  <var key='theme_accordion_header_border_thickness' value='0,0,1,0' />
  <lineargradientbrush key='theme_accordion_background_hover_brush' direction='vertical'>
    <stops>
       <gradientstop color='{resource theme_background_dark}' />
       <gradientstop color='{resource theme_background_mouse_hover}' />
    </stops>
  </lineargradientbrush>
  <solidcolorbrush key='theme_accordion_background_mouse_down_brush' color='{resource theme_background_mouse_down}' />
  <solidcolorbrush key='theme_accordion_header_background_brush' color='{resource theme_background_dark}' />
  <solidcolorbrush key='theme_accordion_body_background_brush' color='{resource theme_background_light}' />

  <!-- 
  Menu & MenuStrip
  -->
  <var key='theme_menu_padding' value='{resource theme_border_padding}' />
    <lineargradientbrush key='theme_menu_background_hover_brush' direction='vertical'>
    <stops>
       <gradientstop color='{resource theme_background_dark}' />
       <gradientstop color='{resource theme_background_mouse_hover}' />
    </stops>
  </lineargradientbrush>
  <solidcolorbrush key='theme_menu_background_mouse_down_brush' color='{resource theme_background_mouse_down}' />
  <solidcolorbrush key='theme_menu_background_brush' color='{resource theme_background_dark}' />

  <!--
  Popup
  -->
  <var key='theme_popup_padding' value='5' />
  <var key='theme_popup_border_thickness' value='1' />
  <color key='theme_popup_border_color' value='{resource theme_border_color}' />
  <var key='theme_popup_shadow_x' value='2' />
  <var key='theme_popup_shadow_y' value='2' />
  <var key='theme_popup_shadow_blur' value='4' />
  <var key='theme_popup_corner_radius' value='0' />
  <var key='theme_popup_border_thickness' value='1' />
  <solidcolorbrush key='theme_popup_background_brush' color='{resource theme_background_dark}' />

  <!--
  TabControl
  -->
  
  <var key='zoidberg' value='http://www.buckshotui.org/resources/images/zoidberg.jpg' />
  <var key='buckshot_logo_uri' value='http://www.buckshotui.org/resources/images/buckshot_logo.png' />
</resourcecollection>
''';
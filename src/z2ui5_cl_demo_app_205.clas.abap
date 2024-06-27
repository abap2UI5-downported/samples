class z2ui5_cl_demo_app_205 definition
  public
  create public .

public section.

  interfaces IF_SERIALIZABLE_OBJECT .
  interfaces Z2UI5_IF_APP .

  data CHECK_INITIALIZED type ABAP_BOOL .
  PROTECTED SECTION.

    METHODS display_view
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS on_event
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_205 IMPLEMENTATION.


  METHOD DISPLAY_VIEW.

    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA temp1 TYPE xsdboolean.
    DATA layout TYPE REF TO z2ui5_cl_xml_view.
    temp1 = boolc( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ).
    page = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Flex Box - Basic Alignment`
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton  = temp1 ).

    
    layout = page->vbox(
                   )->panel( headertext = `Upper left`
                   )->flex_box( height = `100px`
                                alignItems = `Start`
                                justifyContent = `Start`
                              )->button( text = `1` type = `Emphasized` class = `sapUiSmallMarginEnd`
                              )->button( text = `2` type = `Reject` class = `sapUiSmallMarginEnd`
                              )->button( text = `3` type = `Accept` )->get_parent( )->get_parent(
                   )->panel( headertext = `Upper center`
                   )->flex_box( height = `100px`
                                alignItems = `Start`
                                justifyContent = `Center`
                              )->button( text = `1` type = `Emphasized` class = `sapUiSmallMarginEnd`
                              )->button( text = `2` type = `Reject` class = `sapUiSmallMarginEnd`
                              )->button( text = `3` type = `Accept` )->get_parent( )->get_parent(
                   )->panel( headertext = `Upper right`
                   )->flex_box( height = `100px`
                                alignItems = `Start`
                                justifyContent = `End`
                              )->button( text = `1` type = `Emphasized` class = `sapUiSmallMarginEnd`
                              )->button( text = `2` type = `Reject` class = `sapUiSmallMarginEnd`
                              )->button( text = `3` type = `Accept` )->get_parent( )->get_parent(
                   )->panel( headertext = `Middle left`
                   )->flex_box( height = `100px`
                                alignItems = `Center`
                                justifyContent = `Start`
                              )->button( text = `1` type = `Emphasized` class = `sapUiSmallMarginEnd`
                              )->button( text = `2` type = `Reject` class = `sapUiSmallMarginEnd`
                              )->button( text = `3` type = `Accept` )->get_parent( )->get_parent(
                   )->panel( headertext = `Middle center`
                   )->flex_box( height = `100px`
                                alignItems = `Center`
                                justifyContent = `Center`
                              )->button( text = `1` type = `Emphasized` class = `sapUiSmallMarginEnd`
                              )->button( text = `2` type = `Reject` class = `sapUiSmallMarginEnd`
                              )->button( text = `3` type = `Accept` )->get_parent( )->get_parent(
                   )->panel( headertext = `Middle right`
                   )->flex_box( height = `100px`
                                alignItems = `Center`
                                justifyContent = `End`
                              )->button( text = `1` type = `Emphasized` class = `sapUiSmallMarginEnd`
                              )->button( text = `2` type = `Reject` class = `sapUiSmallMarginEnd`
                              )->button( text = `3` type = `Accept` )->get_parent( )->get_parent(
                   )->panel( headertext = `Lower left`
                   )->flex_box( height = `100px`
                                alignItems = `End`
                                justifyContent = `Start`
                              )->button( text = `1` type = `Emphasized` class = `sapUiSmallMarginEnd`
                              )->button( text = `2` type = `Reject` class = `sapUiSmallMarginEnd`
                              )->button( text = `3` type = `Accept` )->get_parent( )->get_parent(
                   )->panel( headertext = `Lower center`
                   )->flex_box( height = `100px`
                                alignItems = `End`
                                justifyContent = `Center`
                              )->button( text = `1` type = `Emphasized` class = `sapUiSmallMarginEnd`
                              )->button( text = `2` type = `Reject` class = `sapUiSmallMarginEnd`
                              )->button( text = `3` type = `Accept` )->get_parent( )->get_parent(
                   )->panel( headertext = `Lower right`
                   )->flex_box( height = `100px`
                                alignItems = `End`
                                justifyContent = `End`
                              )->button( text = `1` type = `Emphasized` class = `sapUiSmallMarginEnd`
                              )->button( text = `2` type = `Reject` class = `sapUiSmallMarginEnd`
                              )->button( text = `3` type = `Accept`
                   ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD ON_EVENT.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( ).
    ENDCASE.

  ENDMETHOD.


  METHOD Z2UI5_IF_APP~MAIN.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      display_view( client ).
    ENDIF.

    on_event( client ).

  ENDMETHOD.
ENDCLASS.

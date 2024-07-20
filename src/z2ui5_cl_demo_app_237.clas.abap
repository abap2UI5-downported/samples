class z2ui5_cl_demo_app_237 definition
  public
  create public .

public section.

  interfaces Z2UI5_IF_APP .

  data CHECK_INITIALIZED type ABAP_BOOL .
  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client.

    METHODS display_view
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS on_event
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS z2ui5_display_popover
      IMPORTING
        id TYPE string.

  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_237 IMPLEMENTATION.


  METHOD DISPLAY_VIEW.

    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA temp1 TYPE xsdboolean.
    DATA layout TYPE REF TO z2ui5_cl_xml_view.
    temp1 = boolc( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ).
    page = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = 'abap2UI5 - Sample: Slider'
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton  = temp1
                                     )->header_content(
                             )->button( id = `hint_icon`
                                        icon = `sap-icon://hint`
                                        tooltip = `Sample information`
                                        press = client->_event( 'POPOVER' )
                             )->get_parent(
                             ).

    
    layout = page->vertical_layout( class  = `sapUiContentPadding` width = `100%`
                          )->text( text = `Slider without text field` class = `sapUiSmallMarginBottom`
                              )->slider( value = `30` width = `90%` class = `sapUiSmallMarginBottom`
                              )->slider( value = `27` width = `10em` class = `sapUiSmallMarginBottom`
                              )->slider( value = `40` width = `15em` class = `sapUiSmallMarginBottom`
                              )->slider( value = `9` width = `77%`
                                         min = `0` max = `10` class = `sapUiSmallMarginBottom`
                          )->text( text = `Slider whose value cannot be changed` class = `sapUiSmallMarginBottom`
                              )->slider( value = `5` width = `66%`
                                         min = `0` max = `50` enabled = abap_false class = `sapUiSmallMarginBottom`
                          )->text( text = `Slider with text field` class = `sapUiSmallMarginBottom`
                              )->slider( value = `50` width = `100%`
                                         min = `0` max = `100`
                                         showadvancedtooltip = abap_true
                                         inputsastooltips = abap_false
                                         class = `sapUiMediumMarginBottom`
                          )->text( text = `Slider with input field` class = `sapUiSmallMarginBottom`
                              )->slider( value = `30` width = `100%`
                                         min = `0` max = `200`
                                         showadvancedtooltip = abap_true
                                         showhandletooltip = abap_false
                                         inputsastooltips = abap_true
                                         class = `sapUiMediumMarginBottom`
                          )->text( text = `Slider with tickmarks` class = `sapUiSmallMarginBottom`
                              )->slider( enableTickmarks = abap_true min = `0` max = `10` class = `sapUiMediumMarginBottom` width = `100%`
                              )->slider( enableTickmarks = abap_true class = `sapUiMediumMarginBottom` width = `100%`
                          )->text( text = `Slider with tickmarks and step '5'` class = `sapUiSmallMarginBottom`
                              )->slider( enableTickmarks = abap_true min = `-100` max = `100` step = `5` class = `sapUiMediumMarginBottom` width = `100%`
                          )->text( text = `Slider with tickmarks and labels` class = `sapUiSmallMarginBottom`
                              )->slider( min = `0` max = `30` enableTickmarks = abap_true class = `sapUiMediumMarginBottom` width = `100%` )->get(
                                  )->responsive_scale( tickmarksBetweenLabels = `3`
                   ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD ON_EVENT.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( ).
      WHEN 'POPOVER'.
        z2ui5_display_popover( `hint_icon` ).
    ENDCASE.

  ENDMETHOD.


  METHOD Z2UI5_DISPLAY_POPOVER.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    view = z2ui5_cl_xml_view=>factory_popup( ).
    view->quick_view( placement = `Bottom`
              )->quick_view_page( pageid = `sampleInformationId`
                                  header = `Sample information`
                                  description = `With the Slider a user can choose a value from a numerical range.`
                                  )->get_parent( ).

    client->popover_display(
      xml   = view->stringify( )
      by_id = id
    ).

  ENDMETHOD.


  METHOD Z2UI5_IF_APP~MAIN.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      display_view( client ).
    ENDIF.

    on_event( client ).

  ENDMETHOD.
ENDCLASS.

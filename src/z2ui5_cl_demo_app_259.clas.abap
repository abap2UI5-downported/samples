CLASS z2ui5_cl_demo_app_259 DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA check_initialized TYPE abap_bool.

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



CLASS z2ui5_cl_demo_app_259 IMPLEMENTATION.


  METHOD display_view.

    DATA page_01 TYPE REF TO z2ui5_cl_xml_view.
    DATA temp13 TYPE xsdboolean.
    DATA temp1 TYPE string_table.
    DATA temp2 TYPE string_table.
    DATA temp3 TYPE string_table.
    DATA temp4 TYPE string_table.
    DATA temp5 TYPE string_table.
    DATA temp6 TYPE string_table.
    DATA temp7 TYPE string_table.
    DATA temp8 TYPE string_table.
    DATA temp9 TYPE string_table.
    DATA temp10 TYPE string_table.
    DATA temp11 TYPE string_table.
    DATA temp12 TYPE string_table.
    DATA page_02 TYPE REF TO z2ui5_cl_xml_view.
    temp13 = boolc( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ).
    page_01 = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Button`
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton  = temp13 ).

    page_01->header_content(
       )->button( id = `button_hint_id`
           icon = `sap-icon://hint`
           tooltip = `Sample information`
           press = client->_event( 'CLICK_HINT_ICON' ) ).

    page_01->header_content(
       )->link(
           text   = 'UI5 Demo Kit'
           target = '_blank'
           href   = 'https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Button/sample/sap.m.sample.Button' ).

    
    CLEAR temp1.
    INSERT `${$source>/id}` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `${$source>/id}` INTO TABLE temp2.
    
    CLEAR temp3.
    INSERT `${$source>/id}` INTO TABLE temp3.
    
    CLEAR temp4.
    INSERT `${$source>/id}` INTO TABLE temp4.
    
    CLEAR temp5.
    INSERT `${$source>/id}` INTO TABLE temp5.
    
    CLEAR temp6.
    INSERT `${$source>/id}` INTO TABLE temp6.
    
    CLEAR temp7.
    INSERT `${$source>/id}` INTO TABLE temp7.
    
    CLEAR temp8.
    INSERT `${$source>/id}` INTO TABLE temp8.
    
    CLEAR temp9.
    INSERT `${$source>/id}` INTO TABLE temp9.
    
    CLEAR temp10.
    INSERT `${$source>/id}` INTO TABLE temp10.
    
    CLEAR temp11.
    INSERT `${$source>/id}` INTO TABLE temp11.
    
    CLEAR temp12.
    INSERT `${$source>/id}` INTO TABLE temp12.
    
    page_02 = page_01->page(
                              title = `Page`
                              class = `sapUiContentPadding`
                              )->custom_header(
                                  )->toolbar(
                                      )->button( type = `Back` press = client->_event( val = `onPress` t_arg = temp1 )
                                      )->toolbar_spacer(
                                      )->title( text = `Title` level = `H2`
                                      )->toolbar_spacer(
                                      )->button( icon = `sap-icon://edit` type = `Transparent` press = client->_event( val = `onPress` t_arg = temp2 ) arialabelledby = `editButtonLabel`
                                  )->get_parent(

                              )->get_parent(
                              )->sub_header(
                                  )->toolbar(
                                      )->toolbar_spacer(
                                      )->button( text = `Default` press = client->_event( val = `onPress` t_arg = temp3 )
                                      )->button( type = `Reject` text = `Reject` press = client->_event( val = `onPress` t_arg = temp4 )
                                      )->button( icon = `sap-icon://action` type = `Transparent` press = client->_event( val = `onPress` t_arg = temp5 ) ariaLabelledBy = `actionButtonLabel`
                                      )->toolbar_spacer(
                                  )->get_parent(

                              )->get_parent(
                              )->content(
                                  )->hbox(
                                      )->button( text = `Default`
                                                 press = client->_event( val = `onPress` t_arg = temp6 )
                                                 ariadescribedby = `defaultButtonDescription genericButtonDescription`)->get(
                                          )->layout_data(
                                              )->flex_item_data( growfactor = `1`
                                          )->get_parent(
                                      )->get_parent(
                                      )->button( type = `Accept`
                                                 text = `Accept`
                                                 press = client->_event( val = `onPress` t_arg = temp7 )
                                                 ariadescribedby = `acceptButtonDescription genericButtonDescription`)->get(
                                          )->layout_data(
                                              )->flex_item_data( growfactor = `1`
                                          )->get_parent(
                                      )->get_parent(
                                      )->button( type = `Reject`
                                                 text = `Reject`
                                                 press = client->_event( val = `onPress` t_arg = temp8 )
                                                 ariadescribedby = `rejectButtonDescription genericButtonDescription` )->get(
                                          )->layout_data(
                                              )->flex_item_data( growfactor = `1`
                                          )->get_parent(
                                      )->get_parent(
                                      )->button( text = `Coming Soon`
                                                 press = client->_event( val = `onPress` t_arg = temp9 )
                                                 ariadescribedby = `comingSoonButtonDescription genericButtonDescription`
                                                 enabled = abap_false )->get(
                                          )->layout_data(
                                              )->flex_item_data( growfactor = `1`
                                          )->get_parent(
                                      )->get_parent(

                                  )->get_parent(

                                  " Collection of labels (some of which are invisible) used to provide ARIA descriptions for the buttons
                                  )->label( id = `genericButtonDescription` text = `Note: The buttons in this sample display MessageToast when pressed.`

                                  )->invisible_text( ns = `core` id = `defaultButtonDescription` text = `Description of default button goes here.` )->get_parent(
                                  )->invisible_text( ns = `core` id = `acceptButtonDescription` text = `Description of accept button goes here.` )->get_parent(
                                  )->invisible_text( ns = `core` id = `rejectButtonDescription` text = `Description of reject button goes here.` )->get_parent(
                                  )->invisible_text( ns = `core` id = `comingSoonButtonDescription` text = `This feature is not active just now.` )->get_parent(
                                  " These labels exist only to provide targets for the ARIA label on the Edit and Action buttons
                                  )->invisible_text( ns = `core` id = `editButtonLabel` text = `Edit Button Label` )->get_parent(
                                  )->invisible_text( ns = `core` id = `actionButtonLabel` text = `Action Button Label` )->get_parent(
                              )->get_parent(
                              )->footer(
                                  )->toolbar(
                                      )->toolbar_spacer(
                                      )->button( type = `Emphasized` text = `Emphasized` press = client->_event( val = `onPress` t_arg = temp10 )
                                      )->button( text = `Default` press = client->_event( val = `onPress` t_arg = temp11 )
                                      )->button( icon = `sap-icon://action` type = `Transparent` press = client->_event( val = `onPress` t_arg = temp12 ) )->get_parent(
                                  )->get_parent(
                              )->get_parent(
                             ).

    client->view_display( page_02->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( ).
      WHEN 'CLICK_HINT_ICON'.
        z2ui5_display_popover( `button_hint_id` ).
      WHEN 'onPress'.
        client->message_toast_display( client->get_event_arg( 1 ) && ` Pressed` ).
    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_display_popover.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    view = z2ui5_cl_xml_view=>factory_popup( ).
    view->quick_view( placement = `Bottom` width = `auto`
              )->quick_view_page( pageid = `sampleInformationId`
                                  header = `Sample information`
                                  description = `Buttons trigger user actions and come in a variety of shapes and colors. Placing a button on a page header or footer changes its appearance.` ).

    client->popover_display(
      xml   = view->stringify( )
      by_id = id
    ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      display_view( client ).
    ENDIF.

    on_event( client ).

  ENDMETHOD.
ENDCLASS.

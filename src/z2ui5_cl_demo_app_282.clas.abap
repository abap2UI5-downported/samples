CLASS z2ui5_cl_demo_app_282 DEFINITION
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



CLASS z2ui5_cl_demo_app_282 IMPLEMENTATION.


  METHOD display_view.

    DATA page_01 TYPE REF TO z2ui5_cl_xml_view.
    DATA temp2 TYPE xsdboolean.
    DATA temp1 TYPE z2ui5_if_types=>ty_s_name_value.
    DATA page_02 TYPE REF TO z2ui5_cl_xml_view.
    temp2 = boolc( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ).
    page_01 = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: InvisibleText`
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton  = temp2 ).

    page_01->header_content(
       )->button( id = `button_hint_id`
           icon = `sap-icon://hint`
           tooltip = `Sample information`
           press = client->_event( 'CLICK_HINT_ICON' ) ).

    page_01->header_content(
       )->link(
           text   = 'UI5 Demo Kit'
           target = '_blank'
           href   = 'https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.core.InvisibleText/sample/sap.ui.core.sample.InvisibleText' ).


    
    CLEAR temp1.
    temp1-n = `core:require`.
    temp1-v = `{ MessageToast: 'sap/m/MessageToast' }`.
    page_01->_generic_property( temp1 ).

    
    page_02 = page_01->page(
                             title = `Page`
                             class = `sapUiContentPadding`
                             )->custom_header(
                                 )->toolbar(
                                     )->button( type = `Back` press = `MessageToast.show( ${$source>/id} + ' Pressed' )`
                                     )->toolbar_spacer(
                                     )->title( text = `Title`
                                     )->toolbar_spacer(
                                     )->button( icon = `sap-icon://edit` press = `MessageToast.show( ${$source>/id} + ' Pressed' )` arialabelledby = `editButtonLabel` )->get_parent( )->get_parent(

                             )->sub_header(
                                 )->toolbar(
                                     )->toolbar_spacer(
                                     )->button( text = `Default` press = `MessageToast.show( ${$source>/id} + ' Pressed' )`
                                     )->button( type = `Reject` text = `Reject` press = `MessageToast.show( ${$source>/id} + ' Pressed' )`
                                     )->button( icon = `sap-icon://action` press = `MessageToast.show( ${$source>/id} + ' Pressed' )` arialabelledby = `actionButtonLabel`
                                     )->toolbar_spacer(  )->get_parent( )->get_parent(

                             )->content(
                                 )->hbox(
                                     )->button( text = `Default`
                                                press = `MessageToast.show( ${$source>/id} + ' Pressed' )`
                                                ariadescribedby = `defaultButtonDescription genericButtonDescription` )->get(
                                         )->layout_data(
                                             )->flex_item_data( growfactor = `1` )->get_parent( )->get_parent(
                                     )->button( type = `Accept`
                                                text = `Accept`
                                                press = `MessageToast.show( ${$source>/id} + ' Pressed' )`
                                                ariadescribedby = `acceptButtonDescription genericButtonDescription` )->get(
                                         )->layout_data(
                                             )->flex_item_data( growfactor = `1` )->get_parent( )->get_parent(
                                     )->button( type = `Reject`
                                                text = `Reject`
                                                press = `MessageToast.show( ${$source>/id} + ' Pressed' )`
                                                ariadescribedby = `rejectButtonDescription genericButtonDescription` )->get(
                                         )->layout_data(
                                             )->flex_item_data( growfactor = `1` )->get_parent( )->get_parent(
                                     )->button( text = `Coming Soon`
                                                press = `MessageToast.show( ${$source>/id} + ' Pressed' )`
                                                ariadescribedby = `comingSoonButtonDescription genericButtonDescription`
                                                enabled = abap_false )->get(
                                         )->layout_data(
                                             )->flex_item_data( growfactor = `1` )->get_parent( )->get_parent( )->get_parent(

                                 " Collection of labels (some of which are invisible) used to provide ARIA descriptions for the buttons
                                 )->label( id = `genericButtonDescription` text = `Note: The buttons in this sample display MessageToast when pressed.`

                                 )->invisible_text( ns = `core` id = `defaultButtonDescription` text = `Description of default button goes here.` )->get_parent(
                                 )->invisible_text( ns = `core` id = `acceptButtonDescription` text = `Description of accept button goes here.` )->get_parent(
                                 )->invisible_text( ns = `core` id = `rejectButtonDescription` text = `Description of reject button goes here.` )->get_parent(
                                 )->invisible_text( ns = `core` id = `comingSoonButtonDescription` text = `This feature is not active just now.` )->get_parent(

                                 " These labels exist only to provide targets for the ARIA label on the Edit and Action buttons
                                 )->invisible_text( ns = `core` id = `editButtonLabel` text = `Edit Button Label` )->get_parent(
                                 )->invisible_text( ns = `core` id = `actionButtonLabel` text = `Action Button Label` )->get_parent( )->get_parent(

                             )->footer(
                                 )->toolbar(
                                     )->toolbar_spacer(
                                     )->button( type = `Emphasized` text = `Emphasized` press = `MessageToast.show( ${$source>/id} + ' Pressed' )`
                                     )->button( text = `Default` press = `MessageToast.show( ${$source>/id} + ' Pressed' )`
                                     )->button( icon = `sap-icon://action` press = `MessageToast.show( ${$source>/id} + ' Pressed' )`
                      ).

    client->view_display( page_02->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( ).
      WHEN 'CLICK_HINT_ICON'.
        z2ui5_display_popover( `button_hint_id` ).
    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_display_popover.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    view = z2ui5_cl_xml_view=>factory_popup( ).
    view->quick_view( placement = `Bottom` width = `auto`
              )->quick_view_page( pageid = `sampleInformationId`
                                  header = `Sample information`
                                  description = `Many controls provide the associations ariaLabelledBy and ariaDescribedBy for accessibility purposes. ` &&
                                                `The InvisibleText control can be used by application to provide hidden texts on the UI which can be referenced via these associations.` ).

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

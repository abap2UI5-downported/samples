CLASS z2ui5_cl_demo_app_213 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app .

    DATA check_initialized TYPE abap_bool .
  PROTECTED SECTION.

    METHODS display_view
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS on_event
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_213 IMPLEMENTATION.


  METHOD display_view.

    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA temp1 TYPE xsdboolean.
    DATA layout TYPE REF TO z2ui5_cl_xml_view.
    temp1 = boolc( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ).
    page = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = 'abap2UI5 - Sample: Input - Password'
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton  = temp1 ).

    
    layout = page->vertical_layout( class = `sapUiContentPadding`
                                          width = `100%` ).
    layout->label( text     = `Password`
                   labelfor = `passwordInput` ).
    layout->input( id          = `passwordInput`
                   type        = `Password`
                   placeholder = `Enter password` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( ).
    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      display_view( client ).
    ENDIF.

    on_event( client ).

  ENDMETHOD.
ENDCLASS.

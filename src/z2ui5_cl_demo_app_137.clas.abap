CLASS z2ui5_cl_demo_app_137 DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.
    DATA instance_counter TYPE i READ-ONLY.
    DATA check_initialized TYPE abap_bool READ-ONLY.
    DATA session_is_stateful TYPE abap_bool READ-ONLY.
    DATA session_text TYPE string READ-ONLY.

  PROTECTED SECTION.
  PRIVATE SECTION.

    METHODS initialize_view
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

    METHODS on_event
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

    METHODS set_session_stateful
      IMPORTING
        client   TYPE REF TO z2ui5_if_client
        stateful TYPE abap_bool.

ENDCLASS.

CLASS z2ui5_cl_demo_app_137 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.
    IF check_initialized = abap_false.
      check_initialized = abap_true.
      initialize_view( client ).
    ENDIF.

    on_event( client ).
  ENDMETHOD.

  METHOD initialize_view.
    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA temp1 TYPE xsdboolean.
    DATA vbox TYPE REF TO z2ui5_cl_xml_view.
    DATA hbox TYPE REF TO z2ui5_cl_xml_view.
    set_session_stateful( client = client stateful = abap_true ).

    
    view = z2ui5_cl_xml_view=>factory( ).

    
    
    temp1 = boolc( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ).
    page = view->shell( )->page(
      title          = `abap2UI5 - Sample: Sticky Session`
      navbuttonpress = client->_event( 'BACK' )
      shownavbutton  = temp1 ).

    
    vbox = page->vbox( ).
    vbox->info_label( text = client->_bind( session_text ) ).

    
    hbox = vbox->hbox( alignitems = 'Center' ).
    hbox->label( text = 'press button to increment counter in backend session' class = 'sapUiTinyMarginEnd' ).
    hbox->button(
      text  = client->_bind( instance_counter )
      press = client->_event( 'INCREMENT' )
      type = 'Emphasized' ).

    hbox = vbox->hbox( ).
    hbox->button(
      text  = 'End session'
      press = client->_event( 'END_SESSION' ) ).

    hbox->button(
      text  = 'Start session again'
      press = client->_event( 'START_SESSION' ) ).

    client->view_display( view->stringify( ) ).
  ENDMETHOD.

  METHOD on_event.
    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( ).
      WHEN 'INCREMENT'.
        instance_counter = lcl_static_container=>increment( ).
        client->view_model_update( ).
      WHEN 'END_SESSION'.
        set_session_stateful( client = client stateful = abap_false ).
      WHEN 'START_SESSION'.
        set_session_stateful( client = client stateful = abap_true ).
    ENDCASE.
  ENDMETHOD.

  METHOD set_session_stateful.
    client->set_session_stateful( stateful ).
    session_is_stateful = stateful.
    IF stateful = abap_true.
      session_text = 'Session ON (stateful)'.
    ELSE.
      session_text = 'Session OFF (stateless)'.
    ENDIF.
    client->view_model_update( ).
  ENDMETHOD.
ENDCLASS.

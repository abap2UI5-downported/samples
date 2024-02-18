CLASS Z2UI5_CL_DEMO_APP_024 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES Z2UI5_if_app.

    DATA mv_input TYPE string.
    DATA mv_input2 TYPE string.
    DATA mv_backend_event TYPE string.

  PROTECTED SECTION.

    METHODS display_view
      IMPORTING
        client TYPE REF TO Z2UI5_if_client.

  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_024 IMPLEMENTATION.


  METHOD display_view.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    view = z2ui5_cl_xml_view=>factory( ).
    view->shell(
        )->page( title = 'abap2UI5 - flow logic - APP 01' navbuttonpress = client->_event( val = 'BACK' check_view_destroy = abap_true ) shownavbutton = abap_true
        )->header_content(
            )->link( text = 'Demo'        target = '_blank' href = `https://twitter.com/abap2UI5/status/1640743794206228480`
            )->link( text = 'Source_Code' target = '_blank' href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
        )->get_parent(

       )->grid( 'L6 M12 S12' )->content( 'layout'

       )->simple_form( 'Controller' )->content( 'form'

         )->label( 'Demo'
         )->button( text = 'call new app (first View)' press = client->_event( 'CALL_NEW_APP' )
         )->label( 'Demo'
         )->button( text = 'call new app (second View)' press = client->_event( 'CALL_NEW_APP_VIEW' )
         )->label( 'Demo'
         )->button( text = 'call new app (set Event)' press = client->_event( 'CALL_NEW_APP_EVENT' )
         )->label( 'Demo'
         )->input( client->_bind_edit( mv_input )
         )->button( text = 'call new app (set data)' press = client->_event( 'CALL_NEW_APP_READ' )
              )->label( 'some data, you can read in the next app'
         )->input( client->_bind_edit( mv_input2 ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD Z2UI5_if_app~main.
        DATA temp1 TYPE REF TO z2ui5_cl_demo_app_025.
        DATA lo_app TYPE REF TO Z2UI5_CL_DEMO_APP_025.
        DATA lo_app_next TYPE REF TO Z2UI5_CL_DEMO_APP_025.
        DATA lo_prev_stack_app TYPE REF TO z2ui5_if_app.
            DATA temp2 TYPE REF TO z2ui5_cl_demo_app_025.
            DATA lo_called_app LIKE temp2.

    IF client->get( )-check_on_navigated = abap_true.
      display_view( client ).
    ENDIF.

    CASE client->get( )-event.

      WHEN 'CALL_NEW_APP'.
        
        CREATE OBJECT temp1 TYPE Z2UI5_CL_DEMO_APP_025.
        client->nav_app_call( temp1 ).

      WHEN 'CALL_NEW_APP_VIEW'.
        
        CREATE OBJECT lo_app TYPE Z2UI5_CL_DEMO_APP_025.
        lo_app->mv_show_view = 'SECOND'.
        client->nav_app_call( lo_app ).

      WHEN 'CALL_NEW_APP_READ'.
        
        CREATE OBJECT lo_app_next TYPE Z2UI5_CL_DEMO_APP_025.
        lo_app_next->mv_input_previous_set = mv_input.
        client->nav_app_call( lo_app_next ).

      WHEN 'CALL_NEW_APP_EVENT'.
        CREATE OBJECT lo_app_next TYPE Z2UI5_CL_DEMO_APP_025.
        lo_app_next->mv_event_backend = 'NEW_APP_EVENT'.
        client->nav_app_call( lo_app_next  ).

      WHEN 'BACK'.
        
        lo_prev_stack_app = client->get_app( client->get( )-s_draft-id_prev_app_stack ).
        client->nav_app_leave( lo_prev_stack_app ).

      WHEN OTHERS.

        CASE mv_backend_event.
          WHEN 'CALL_PREVIOUS_APP_INPUT_RETURN'.
            
            temp2 ?= client->get_app( client->get( )-s_draft-id_prev_app ).
            
            lo_called_app = temp2.
            clear mv_backend_event.
            client->message_box_display( `Input made in the previous app:` && lo_called_app->mv_input ).
        ENDCASE.

    ENDCASE.

  ENDMETHOD.
ENDCLASS.

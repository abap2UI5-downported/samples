CLASS z2ui5_cl_demo_app_154 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA client TYPE REF TO z2ui5_if_client.

    DATA mv_check_initialized TYPE abap_bool.
    METHODS ui5_display.
    METHODS ui5_event.
    METHODS ui5_callback.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_154 IMPLEMENTATION.


  METHOD ui5_event.
        DATA temp1 TYPE z2ui5_cl_pop_messages=>ty_t_msg.
        DATA temp2 LIKE LINE OF temp1.
        DATA lo_app TYPE REF TO z2ui5_cl_pop_messages.

    CASE client->get( )-event.

      WHEN 'POPUP'.

        
        CLEAR temp1.
        
        temp2-message = 'An empty Report field causes an empty XML Message to be sent'.
        temp2-type = 'E'.
        temp2-id = 'MSG1'.
        temp2-number = '001'.
        INSERT temp2 INTO TABLE temp1.
        temp2-message = 'Check was executed for wrong Scenario'.
        temp2-type = 'E'.
        temp2-id = 'MSG1'.
        temp2-number = '002'.
        INSERT temp2 INTO TABLE temp1.
        temp2-message = 'Request was handled without errors'.
        temp2-type = 'S'.
        temp2-id = 'MSG1'.
        temp2-number = '003'.
        INSERT temp2 INTO TABLE temp1.
        temp2-message = 'product activated'.
        temp2-type = 'S'.
        temp2-id = 'MSG4'.
        temp2-number = '375'.
        INSERT temp2 INTO TABLE temp1.
        temp2-message = 'check the input values'.
        temp2-type = 'W'.
        temp2-id = 'MSG2'.
        temp2-number = '375'.
        INSERT temp2 INTO TABLE temp1.
        temp2-message = 'product already in use'.
        temp2-type = 'I'.
        temp2-id = 'MSG2'.
        temp2-number = '375'.
        INSERT temp2 INTO TABLE temp1.
        
        lo_app = z2ui5_cl_pop_messages=>factory( temp1 ).
        client->nav_app_call( lo_app ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD ui5_display.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA temp1 TYPE xsdboolean.
    view = z2ui5_cl_xml_view=>factory( ).
    
    temp1 = boolc( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ).
    view->shell(
        )->page(
                title          = 'abap2UI5 - Popup Messages'
                navbuttonpress = client->_event( val = 'BACK' )
                shownavbutton = temp1
            )->header_content(
                )->link(
                    text = 'Source_Code'
                    target = '_blank'

                    )->get_parent(
           )->button(
            text  = 'Open Popup...'
            press = client->_event( 'POPUP' ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->get( )-check_on_navigated = abap_true.
      IF mv_check_initialized = abap_false.
        mv_check_initialized = abap_true.
        ui5_display( ).
      ELSE.
        ui5_callback( ).
      ENDIF.
      RETURN.
    ENDIF.

    ui5_event( ).

  ENDMETHOD.

  METHOD ui5_callback.
        DATA lo_prev TYPE REF TO z2ui5_if_app.
        DATA temp3 TYPE REF TO z2ui5_cl_pop_messages.
        DATA lo_dummy LIKE temp3.

    TRY.
        
        lo_prev = client->get_app( client->get(  )-s_draft-id_prev_app ).
        
        temp3 ?= lo_prev.
        
        lo_dummy = temp3.
        client->message_box_display( `callback after popup messages` ).
      CATCH cx_root.
    ENDTRY.

  ENDMETHOD.

ENDCLASS.

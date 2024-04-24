CLASS z2ui5_cl_demo_app_156 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA client TYPE REF TO z2ui5_if_client.

    METHODS ui5_display.
    METHODS ui5_event.
    METHODS ui5_callback.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_156 IMPLEMENTATION.


  METHOD ui5_callback.
        DATA lo_prev TYPE REF TO z2ui5_if_app.
        DATA temp1 TYPE REF TO z2ui5_cl_pop_input_val.
        DATA lv_text TYPE z2ui5_cl_pop_input_val=>ty_s_result-value.

    TRY.
        
        lo_prev = client->get_app( client->get(  )-s_draft-id_prev_app ).
        
        temp1 ?= lo_prev.
        
        lv_text = temp1->result( )-value.
        client->message_box_display( `the input is ` && lv_text ).
      CATCH cx_root.
    ENDTRY.

  ENDMETHOD.


  METHOD ui5_display.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA temp1 TYPE xsdboolean.
    view = z2ui5_cl_xml_view=>factory( ).
    
    temp1 = boolc( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ).
    view->shell(
        )->page(
                title          = 'abap2UI5 - Popup Input Value'
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


  METHOD ui5_event.
        DATA lo_app TYPE REF TO z2ui5_cl_pop_input_val.

    CASE client->get( )-event.

      WHEN 'POPUP'.
        
        lo_app = z2ui5_cl_pop_input_val=>factory( text = `Amount of products:` ).
        client->nav_app_call( lo_app ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->get( )-check_on_navigated = abap_true.
      ui5_display( ).
      ui5_callback( ).
      RETURN.
    ENDIF.

    ui5_event( ).

  ENDMETHOD.
ENDCLASS.

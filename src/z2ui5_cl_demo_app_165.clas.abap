CLASS z2ui5_cl_demo_app_165 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA client TYPE REF TO z2ui5_if_client.

    METHODS ui5_display.
    METHODS ui5_event.
    METHODS ui5_callback.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_165 IMPLEMENTATION.


  METHOD ui5_event.
            DATA lv_dummy TYPE i.
            DATA lx TYPE REF TO cx_root.
        DATA lo_app TYPE REF TO z2ui5_cl_pop_error.

    CASE client->get( )-event.

      WHEN 'POPUP'.
        TRY.
            
            lv_dummy = 1 / 0.
            
          CATCH cx_root INTO lx.
        ENDTRY.
        
        lo_app = z2ui5_cl_pop_error=>factory( lx ).
        client->nav_app_call( lo_app ).

      WHEN 'BACK'.
        client->nav_app_leave( ).

    ENDCASE.

  ENDMETHOD.


  METHOD ui5_display.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA temp1 TYPE xsdboolean.
    view = z2ui5_cl_xml_view=>factory( ).
    
    temp1 = boolc( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ).
    view->shell(
        )->page(
                title          = 'abap2UI5 - Popup Error'
                navbuttonpress = client->_event( val = 'BACK' )
                shownavbutton = temp1
           )->button(
            text  = 'Open Popup...'
            press = client->_event( 'POPUP' ) ).

    client->view_display( view->stringify( ) ).

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

  METHOD ui5_callback.
        DATA lo_prev TYPE REF TO z2ui5_if_app.
        DATA temp1 TYPE REF TO z2ui5_cl_pop_to_inform.
        DATA lo_dummy LIKE temp1.

    TRY.
        
        lo_prev = client->get_app( client->get(  )-s_draft-id_prev_app ).
        
        temp1 ?= lo_prev.
        
        lo_dummy = temp1.
        client->message_box_display( `callback after popup to inform` ).
      CATCH cx_root.
    ENDTRY.

  ENDMETHOD.

ENDCLASS.

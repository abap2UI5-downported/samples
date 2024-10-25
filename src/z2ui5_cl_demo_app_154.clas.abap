CLASS z2ui5_cl_demo_app_154 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA client TYPE REF TO z2ui5_if_client.
    METHODS ui5_display.
    METHODS ui5_event.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_154 IMPLEMENTATION.


  METHOD ui5_event.
        DATA temp1 TYPE bapirettab.
        DATA temp2 LIKE LINE OF temp1.
        DATA lt_msg LIKE temp1.
            DATA lv_dummy TYPE i.
            DATA lx TYPE REF TO cx_root.
        DATA lo_app TYPE REF TO z2ui5_cl_pop_error.

    CASE client->get( )-event.

      WHEN 'POPUP_BAPIRET'.

        
        CLEAR temp1.
        
        temp2-type = 'E'.
        temp2-id = 'MSG1'.
        temp2-number = '001'.
        temp2-message = 'An empty Report field causes an empty XML Message to be sent'.
        INSERT temp2 INTO TABLE temp1.
        temp2-type = 'I'.
        temp2-id = 'MSG2'.
        temp2-number = '002'.
        temp2-message = 'Product already in use'.
        INSERT temp2 INTO TABLE temp1.
        
        lt_msg = temp1.

        client->nav_app_call( z2ui5_cl_pop_messages=>factory( lt_msg ) ).

      WHEN 'POPUP_BALLOG'.

*        DATA(lt_ballog) = VALUE bapirettab(
*            ( type = 'E' id = 'MSG1' number = '001' message = 'An empty Report field causes an empty XML Message to be sent' )
*            ( type = 'I' id = 'MSG2' number = '002' message = 'Product already in use' )
*        ).
*
*        client->nav_app_call( z2ui5_cl_pop_messages=>factory( lt_ballog ) ).


      WHEN 'POPUP_EXCEPTION'.
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
                title          = 'abap2UI5 - Popup Messages'
                navbuttonpress = client->_event( val = 'BACK' )
                shownavbutton  = temp1
           )->button(
            text  = 'Open Popup BAPIRET'
            press = client->_event( 'POPUP_BAPIRET' )
*                  )->button(
*            text  = 'Open Popup BALLOG'
*            press = client->_event( 'POPUP_BALLOG' )
                             )->button(
            text  = 'Open Popup Exception'
            press = client->_event( 'POPUP_EXCEPTION' )
             ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ) IS NOT INITIAL.
      ui5_display( ).
      RETURN.
    ENDIF.

    ui5_event( ).

  ENDMETHOD.

ENDCLASS.

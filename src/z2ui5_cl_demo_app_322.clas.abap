CLASS z2ui5_cl_demo_app_322 DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mv_quantity TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.


CLASS z2ui5_cl_demo_app_322 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.
      DATA view TYPE REF TO z2ui5_cl_xml_view.

    IF client->check_on_navigated( ) IS NOT INITIAL.
      
      view = z2ui5_cl_xml_view=>factory( ).
      client->view_display( val = view->shell(
             )->page(
                     title          = 'abap2UI5 - Navigation with app state'
                     navbuttonpress = client->_event_client( 'HISTORY_BACK' )
                     shownavbutton  = client->check_app_prev_stack( )
          )->simple_form( title = 'Form Title' editable = abap_true
                     )->content( 'form'
                         )->title( 'Input'
                         )->label( 'quantity'
                         )->input( client->_bind_edit( mv_quantity )
                         )->button(
                             text  = 'post'
                             press = client->_event( val = 'BUTTON_POST' )
                         )->button(
                             text  = 'back'
                             press = client->_event_client( 'HISTORY_BACK' )
              )->stringify( ) ).

      client->set_push_state( ).
      RETURN.
    ENDIF.

    CASE client->get( )-event.
      WHEN 'BUTTON_POST'.
        client->set_push_state( ).
    ENDCASE.
    client->message_toast_display( `data updated` ).


  ENDMETHOD.

ENDCLASS.

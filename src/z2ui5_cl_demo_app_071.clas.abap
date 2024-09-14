CLASS z2ui5_cl_demo_app_071 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF s_combobox,
        key  TYPE string,
        text TYPE string,
      END OF s_combobox.
    TYPES ty_t_combo TYPE STANDARD TABLE OF s_combobox WITH DEFAULT KEY.

    DATA mv_set_size_limit TYPE i VALUE 100.
    DATA mv_combo_number TYPE i VALUE 105.
    DATA check_initialized TYPE abap_bool.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_071 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.
    DATA temp1 TYPE ty_t_combo.
    DATA lt_combo LIKE temp1.
      DATA temp2 TYPE z2ui5_cl_demo_app_071=>s_combobox.
    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA temp3 TYPE z2ui5_if_types=>ty_s_event_control.
    DATA temp4 TYPE z2ui5_if_types=>ty_s_view_config.
    DATA temp5 TYPE xsdboolean.

    CASE client->get( )-event.
      WHEN `UPDATE2`.
        client->view_model_update( ).
        RETURN.

      WHEN 'BACK'.
        client->nav_app_leave( ).
        RETURN.
    ENDCASE.

    client->message_toast_display( `View updated` ).

    
    CLEAR temp1.
    
    lt_combo = temp1.
    DO mv_combo_number TIMES.
      
      CLEAR temp2.
      temp2-key = sy-index.
      temp2-text = sy-index.
      INSERT temp2 INTO TABLE lt_combo.
    ENDDO.

    
    view = z2ui5_cl_xml_view=>factory( ).
    
    CLEAR temp3.
    temp3-check_view_destroy = abap_true.
    
    CLEAR temp4.
    temp4-set_size_limit = mv_set_size_limit.
    
    temp5 = boolc( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ).
    client->view_display( val = view->shell(
         )->page(
                 title          = 'abap2UI5 - First Example'
                 navbuttonpress = client->_event( val = 'BACK' s_ctrl = temp3 )
                 shownavbutton = temp5
             )->simple_form( title = 'Form Title' editable = abap_true
                 )->content( 'form'
                     )->title( 'Input'
                     )->label( 'Link'
                     )->label( 'setSizeLimit'
                     )->input( value =  client->_bind_edit( mv_set_size_limit )
                     )->label( 'Number of Entries'
                     )->input( value =  client->_bind_edit( mv_combo_number )
                     )->label( 'demo'
                     )->combobox( items = client->_bind_local( lt_combo )
                        )->item( key = '{KEY}' text = '{TEXT}'
                        )->get_parent( )->get_parent(
                     )->button(
                         text  = 'update'
                         press = client->_event( val = 'UPDATE' )
*                                )->button(
*                         text  = 'update model'
*                         press = client->_event( val = 'UPDATE2' )
        )->stringify( ) s_config = temp4 ).

  ENDMETHOD.
ENDCLASS.

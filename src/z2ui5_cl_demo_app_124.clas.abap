CLASS z2ui5_cl_demo_app_124 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app .

    DATA mv_scan_input TYPE string.
    DATA mv_scan_type TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_124 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.
        DATA lt_arg TYPE string_table.
        DATA temp1 LIKE LINE OF lt_arg.
        DATA temp2 LIKE sy-tabix.
        DATA temp3 LIKE LINE OF lt_arg.
        DATA temp4 LIKE sy-tabix.
    DATA temp5 TYPE string_table.
    DATA temp6 TYPE xsdboolean.
    DATA temp7 TYPE xsdboolean.

    CASE client->get( )-event.

      WHEN 'ON_SCAN_SUCCESS'.
        client->message_box_display( `Scan finished!`).
        
        lt_arg = client->get( )-t_event_arg.
        
        
        temp2 = sy-tabix.
        READ TABLE lt_arg INDEX 1 INTO temp1.
        sy-tabix = temp2.
        IF sy-subrc <> 0.
          ASSERT 1 = 0.
        ENDIF.
        mv_scan_input = temp1.
        
        
        temp4 = sy-tabix.
        READ TABLE lt_arg INDEX 2 INTO temp3.
        sy-tabix = temp4.
        IF sy-subrc <> 0.
          ASSERT 1 = 0.
        ENDIF.
        mv_scan_type  = temp3.
        client->view_model_update( ).
        RETURN.

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack  ) ).
        RETURN.

    ENDCASE.

    
    CLEAR temp5.
    INSERT `${$parameters>/text}` INTO TABLE temp5.
    INSERT `${$parameters>/format}` INTO TABLE temp5.
    
    temp6 = boolc( abap_false = client->get( )-check_launchpad_active ).
    
    temp7 = boolc( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ).
    client->view_display( z2ui5_cl_ui5=>_factory( )->_ns_m( )->shell(
          )->page(
                 showheader       = temp6
                  title          = 'abap2UI5'
                  navbuttonpress = client->_event( val = 'BACK' check_view_destroy = abap_true )
                  shownavbutton = temp7
              )->headercontent(
                  )->link(
                      text = 'Source_Code'
                      href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code(  )
                      target = '_blank'
              )->_go_up( )->_ns_ui(
              )->simpleform( title = 'Information' editable = abap_true
                  )->content( )->_ns_m(
                      )->label( 'mv_scan_input'
                      )->input( client->_bind_edit( mv_scan_input )
                      )->label( `mv_scan_type`
                      )->input( client->_bind_edit( mv_scan_type )
                      )->label( `scanner` )->_ns_ndc(
                      )->barcodescannerbutton(
                        scansuccess     = client->_event( val = 'ON_SCAN_SUCCESS' t_arg = temp5 )
                        dialogtitle     = `Barcode Scanner`
           )->_stringify( ) ).

  ENDMETHOD.
ENDCLASS.

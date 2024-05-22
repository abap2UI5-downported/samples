CLASS z2ui5_cl_demo_app_188 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mv_title          TYPE string VALUE `my title`.
    DATA check_initialized TYPE abap_bool.

  PROTECTED SECTION.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_188 IMPLEMENTATION.
  METHOD z2ui5_if_app~main.
      DATA view TYPE REF TO z2ui5_cl_xml_view.
      DATA page TYPE REF TO z2ui5_cl_xml_view.
        DATA lv_text TYPE string.
        DATA lt_params TYPE z2ui5_if_types=>ty_t_name_value.
        DATA ls_param LIKE LINE OF lt_params.
    IF check_initialized = abap_false.
      check_initialized = abap_true.

      IF client->get( )-check_launchpad_active = abap_false.
        client->message_box_display( `No Launchpad Active, Sample not working!` ).
      ENDIF.

      
      view = z2ui5_cl_xml_view=>factory( ).
      
      page = view->shell( )->page( showheader = abap_false  ).

      page->_z2ui5( )->lp_title( client->_bind_edit( mv_title ) ).

      client->view_display( page->simple_form( title = 'Set Launchpad Title Dynamically' editable = abap_true
                     )->content( 'form'
                         )->label( ``
                         )->input( client->_bind_edit( mv_title )
                         )->label( ``
                         )->button( text  = 'Go Back'
                                    press = client->_event( val = 'BACK' ) )->stringify( ) ).

    ENDIF.

   CASE client->get( )-event.

      WHEN 'READ_PARAMS'.
        
        lv_text = `Start Parameter: `.
        
        lt_params = client->get( )-t_comp_params.
        
        LOOP AT lt_params INTO ls_param.
          lv_text = |{ lv_text } / { ls_param-n } = { ls_param-v }|.
        ENDLOOP.
        client->message_box_display( lv_text ).

      WHEN 'BACK'.
        client->nav_app_leave( ).
    ENDCASE.

  ENDMETHOD.
ENDCLASS.

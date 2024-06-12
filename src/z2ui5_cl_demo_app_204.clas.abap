CLASS z2ui5_cl_demo_app_204 DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA ms_t004 TYPE z2ui5_t004.

  PROTECTED SECTION.
    DATA client            TYPE REF TO z2ui5_if_client.
    DATA check_initialized TYPE abap_bool.

    DATA mv_active_f4      TYPE string.

    METHODS on_init.
    METHODS on_event.
    METHODS render_main.
    METHODS call_f4.

  PRIVATE SECTION.
    METHODS on_after_f4.

ENDCLASS.


CLASS z2ui5_cl_demo_app_204 IMPLEMENTATION.

  METHOD on_event.

    CASE client->get( )-event.

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

      WHEN `CALL_POPUP_F4`.

        call_f4( ).

      WHEN OTHERS.

    ENDCASE.

  ENDMETHOD.

  METHOD on_init.

    render_main( ).

  ENDMETHOD.

  METHOD render_main.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA temp2 TYPE xsdboolean.
    DATA temp1 TYPE string_table.
    view = z2ui5_cl_xml_view=>factory( ). "->shell( ).

    
    
    temp2 = boolc( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ).
    page = view->page( title          = 'Layout'
                             navbuttonpress = client->_event( 'BACK' )
                             shownavbutton  = temp2
                             class          = 'sapUiContentPadding' ).

    
    CLEAR temp1.
    INSERT `GUID` INTO TABLE temp1.
    page->simple_form( title    = 'F4-Help'
                       editable = abap_true
                    )->content( 'form'
                        )->text(
                            `Table Z2UI5_T004 field GUID is linked to table Z2UI5 field GUID via a foreign key link.`
                        )->label( `GUID`
                        )->input( value            = client->_bind_edit( ms_t004-guid )
                                  showvaluehelp    = abap_true
                                  valuehelprequest = client->_event( val   = 'CALL_POPUP_F4'
                                                                     t_arg = temp1 ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

  METHOD z2ui5_if_app~main.
    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      on_init( ).
    ENDIF.

    on_event( ).

    on_after_f4( ).

  ENDMETHOD.

  METHOD call_f4.

    DATA lt_arg TYPE string_table.
    DATA temp3 TYPE string.
    DATA temp1 LIKE LINE OF lt_arg.
    DATA temp2 LIKE sy-tabix.
        DATA temp4 TYPE string.
    lt_arg = client->get( )-t_event_arg.

    
    CLEAR temp3.
    
    
    temp2 = sy-tabix.
    READ TABLE lt_arg INDEX 1 INTO temp1.
    sy-tabix = temp2.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    temp3 = temp1.
    mv_active_f4 = temp3.

    CASE mv_active_f4.
      WHEN `GUID`.

        
        temp4 = ms_t004-guid.
        client->nav_app_call( z2ui5_cl_pop_f4_help=>factory( i_table = 'Z2UI5_T004'
                                                             i_fname = 'GUID'
                                                             i_value = temp4 ) ).
      WHEN OTHERS.

    ENDCASE.

  ENDMETHOD.

  METHOD on_after_f4.
        DATA temp5 TYPE REF TO z2ui5_cl_pop_f4_help.
        DATA app LIKE temp5.
              DATA temp6 TYPE guid.

    IF client->get( )-check_on_navigated = abap_false.
      RETURN.
    ENDIF.

    TRY.
        
        temp5 ?= client->get_app( client->get( )-s_draft-id_prev_app ).
        
        app = temp5.

        IF app->mv_return_value IS NOT INITIAL.

          CASE mv_active_f4.
            WHEN `GUID`.

              
              temp6 = app->mv_return_value.
              ms_t004-guid = temp6.

            WHEN OTHERS.

          ENDCASE.

          client->view_model_update( ).

        ENDIF.

      CATCH cx_root.
    ENDTRY.

  ENDMETHOD.

ENDCLASS.

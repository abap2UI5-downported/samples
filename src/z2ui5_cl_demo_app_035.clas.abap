CLASS z2ui5_cl_demo_app_035 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES Z2UI5_if_app.

    DATA mv_type           TYPE string.
    DATA mv_path           TYPE string.
    DATA mv_editor         TYPE string.
    DATA mv_check_editable TYPE abap_bool.
    DATA check_initialized TYPE abap_bool.

    DATA client            TYPE REF TO Z2UI5_if_client.

    METHODS view_display.

  PROTECTED SECTION.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_035 IMPLEMENTATION.
  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_m.
    DATA page TYPE REF TO z2ui5_cl_ui5.
    DATA temp7 TYPE xsdboolean.
    DATA grid TYPE REF TO z2ui5_cl_ui5_ui.
   DATA temp TYPE REF TO z2ui5_cl_ui5_m.
     DATA temp1 TYPE z2ui5_if_types=>ty_t_name_value.
     DATA lt_types LIKE temp1.
    DATA temp4 TYPE z2ui5_if_types=>ty_t_name_value.
    DATA temp6 TYPE string_table.
    DATA row LIKE LINE OF temp6.
      DATA temp5 LIKE LINE OF temp4.
    DATA temp3 TYPE REF TO z2ui5_cl_ui5_m.
     DATA temp2 TYPE REF TO z2ui5_cl_ui5.
    DATA temp8 TYPE xsdboolean.
    view = z2ui5_cl_ui5=>_factory( )->_ns_m( ).

    
    
    temp7 = boolc( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ).
    page = view->shell( )->page( title          = 'abap2UI5 - File Editor'
                                       navbuttonpress = client->_event( 'BACK' )
                                       shownavbutton = temp7
            )->headercontent(
                )->link( text = 'Demo'        target = '_blank' href = 'https://twitter.com/abap2UI5/status/1631562906570575875'
                )->link( text = 'Source_Code' target = '_blank' href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
        )->_go_up( ).

    
    grid = page->_ns_ui( )->grid( 'L7 M12 S12' )->content( `sap.ui.layout` ).

   
   temp = grid->simpleform( title = 'File' editable = abap_true )->content( )->_ns_m(
         )->label( 'path'
         )->input( client->_bind_edit( mv_path )
         )->label( 'Option' ).

     
     CLEAR temp1.
     
     lt_types = temp1.
    
    CLEAR temp4.
    
    temp6 = z2ui5_cl_util=>source_get_file_types( ).
    
    LOOP AT temp6 INTO row.
      
      temp5-n = shift_right( shift_left( row ) ).
      temp5-v = shift_right( shift_left( row ) ).
      INSERT temp5 INTO TABLE temp4.
    ENDLOOP.
    lt_types = temp4.

    
    temp3 = temp->input( value = client->_bind_edit( mv_type )
                   suggestionitems = client->_bind_local( lt_types ) ).
     
     temp2 =  temp3->_go_new( ).

          temp2->_ns_m(
            )->suggestionitems( )->_ns_ui(
                )->listitem( text = '{NAME}' additionaltext = '{VALUE}'
         )->_go_up( )->_go_up( )->_ns_m(
         )->button( text  = 'Download'
                    press = client->_event( 'DB_LOAD' )
                    icon  = 'sap-icon://download-from-cloud' ).

    grid = page->_ns_ui( )->grid( 'L12 M12 S12' )->content( `sap.ui.layout` ).

    page->_ns_ui( )->codeeditor( type     = mv_type
                       editable = mv_check_editable
                       value    = client->_bind( mv_editor ) ).

    
    temp8 = boolc( mv_editor IS NOT INITIAL ).
    page->_ns_m( )->footer( )->overflowtoolbar(
        )->button( text  = 'Clear'
                   press = client->_event( 'CLEAR' )
                   icon  = 'sap-icon://delete'
        )->toolbarspacer(
        )->button( text  = 'Edit'
                   press = client->_event( 'EDIT' )
                   icon  = 'sap-icon://edit'
        )->button( text    = 'Upload'
                   press   = client->_event( 'DB_SAVE' )
                   type    = 'Emphasized'
                   icon    = 'sap-icon://upload-to-cloud'
                   enabled = temp8 ).

    client->view_display( page->_stringify( ) ).
  ENDMETHOD.

  METHOD Z2UI5_if_app~main.
        DATA temp6 TYPE string.
        DATA temp9 TYPE xsdboolean.
    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      mv_path = '../../demo/text'.
      mv_type = 'plain_text'.
      view_display( ).
    ENDIF.

    CASE client->get( )-event.

      WHEN 'DB_LOAD'.

        
        IF mv_path CS 'abap'.
          temp6 = lcl_file_api=>read_abap( ).
        ELSEIF mv_path CS 'json'.
          temp6 = lcl_file_api=>read_json( ).
        ELSEIF mv_path CS 'yaml'.
          temp6 = lcl_file_api=>read_yaml( ).
        ELSEIF mv_path CS 'text'.
          temp6 = lcl_file_api=>read_text( ).
        ELSEIF mv_path CS 'js'.
          temp6 = lcl_file_api=>read_js( ).
        ELSE.
          CLEAR temp6.
        ENDIF.
        mv_editor = temp6.

        client->message_toast_display( 'Download successfull' ).

        client->view_model_update( ).

      WHEN 'DB_SAVE'.
        client->message_box_display( text = 'Upload successfull. File saved!' type = 'success' ).
      WHEN 'EDIT'.
        
        temp9 = boolc( mv_check_editable = abap_false ).
        mv_check_editable = temp9.
      WHEN 'CLEAR'.
        mv_editor = ``.
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
    ENDCASE.
  ENDMETHOD.
ENDCLASS.

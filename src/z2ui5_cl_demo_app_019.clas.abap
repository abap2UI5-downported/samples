CLASS Z2UI5_CL_DEMO_APP_019 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES Z2UI5_if_app.

    TYPES:
      BEGIN OF ty_row,
        selkz TYPE abap_bool,
        title TYPE string,
        value TYPE string,
        descr TYPE string,
      END OF ty_row.

    TYPES temp1_49ac77ef2f TYPE STANDARD TABLE OF ty_row WITH DEFAULT KEY.
DATA t_tab TYPE temp1_49ac77ef2f.
    TYPES temp2_49ac77ef2f TYPE STANDARD TABLE OF ty_row WITH DEFAULT KEY.
DATA t_tab_sel TYPE temp2_49ac77ef2f.
    DATA mv_sel_mode TYPE string.
    DATA check_initialized TYPE abap_bool.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_019 IMPLEMENTATION.


  METHOD Z2UI5_if_app~main.
          DATA temp1 LIKE t_tab.
          DATA temp2 LIKE LINE OF temp1.
    DATA view TYPE REF TO z2ui5_cl_xml_view.
        DATA page TYPE REF TO z2ui5_cl_xml_view.
        DATA temp3 TYPE xsdboolean.

        IF check_initialized = abap_false.
          check_initialized = abap_true.

          mv_sel_mode = 'None'.
          
          CLEAR temp1.
          
          temp2-descr = 'this is a description'.
          temp2-title = 'title_01'.
          temp2-value = 'value_01'.
          INSERT temp2 INTO TABLE temp1.
          temp2-title = 'title_02'.
          temp2-value = 'value_02'.
          INSERT temp2 INTO TABLE temp1.
          temp2-title = 'title_03'.
          temp2-value = 'value_03'.
          INSERT temp2 INTO TABLE temp1.
          temp2-title = 'title_04'.
          temp2-value = 'value_04'.
          INSERT temp2 INTO TABLE temp1.
          temp2-title = 'title_05'.
          temp2-value = 'value_05'.
          INSERT temp2 INTO TABLE temp1.
          t_tab = temp1.

        ENDIF.

        CASE client->get( )-event.
          WHEN 'BUTTON_SEGMENT_CHANGE'.
            client->message_toast_display( `Selection Mode changed` ).

          WHEN 'BUTTON_READ_SEL'.
            t_tab_sel = t_tab.
            DELETE t_tab_sel WHERE selkz <> abap_true.

          WHEN 'BACK'.
            client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

        ENDCASE.

    
    view = z2ui5_cl_xml_view=>factory( ).
        
        
        temp3 = boolc( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ).
        page = view->shell(
            )->page(
                title          = 'abap2UI5 - Table with different Selection Modes'
                navbuttonpress = client->_event( 'BACK' )
                shownavbutton = temp3
                )->header_content(
                    )->link(
                        text = 'Demo' target = '_blank'
                        href = 'https://twitter.com/abap2UI5/status/1637852441671528448'
                    )->link(
                        text = 'Source_Code' target = '_blank'
                        href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
                )->get_parent( ).

        page->segmented_button(
            selected_key     = client->_bind_edit( mv_sel_mode )
            selection_change = client->_event( 'BUTTON_SEGMENT_CHANGE' ) )->get(
                )->items( )->get(
                    )->segmented_button_item(
                        key  = 'None'
                        text = 'None'
                    )->segmented_button_item(
                        key  = 'SingleSelect'
                        text = 'SingleSelect'
                    )->segmented_button_item(
                        key  = 'SingleSelectLeft'
                        text = 'SingleSelectLeft'
                    )->segmented_button_item(
                        key  = 'SingleSelectMaster'
                        text = 'SingleSelectMaster'
                    )->segmented_button_item(
                        key = 'MultiSelect'
                        text = 'MultiSelect' ).

        page->table(
            headertext = 'Table'
            mode = mv_sel_mode
            items = client->_bind_edit( t_tab )
            )->columns(
                )->column( )->text( 'Title' )->get_parent(
                )->column( )->text( 'Value' )->get_parent(
                )->column( )->text( 'Description'
            )->get_parent( )->get_parent(
            )->items(
                )->column_list_item( selected = '{SELKZ}'
                    )->cells(
                        )->text( '{TITLE}'
                        )->text( '{VALUE}'
                        )->text( '{DESCR}' ).

        page->table( client->_bind( t_tab_sel )
            )->header_toolbar(
                )->overflow_toolbar(
                    )->title( 'Selected Entries'
                    )->button(
                        icon = 'sap-icon://pull-down'
                        text = 'copy selected entries'
                        press = client->_event( 'BUTTON_READ_SEL' )
          )->get_parent( )->get_parent(
          )->columns(
            )->column( )->text( 'Title' )->get_parent(
            )->column( )->text( 'Value' )->get_parent(
            )->column( )->text( 'Description'
            )->get_parent( )->get_parent(
            )->items( )->column_list_item( )->cells(
                )->text( '{TITLE}'
                )->text( '{VALUE}'
                )->text( '{DESCR}' ).

  client->view_display( view->stringify( ) ).

  ENDMETHOD.
ENDCLASS.

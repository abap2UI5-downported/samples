CLASS Z2UI5_CL_DEMO_APP_099 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES Z2UI5_if_app .

    TYPES:
      BEGIN OF ty_row,
        title    TYPE string,
        value    TYPE string,
        descr    TYPE string,
        icon     TYPE string,
        info     TYPE string,
        selected TYPE abap_bool,
      END OF ty_row.

    DATA t_tab TYPE STANDARD TABLE OF ty_row WITH DEFAULT KEY.

    TYPES:
      BEGIN OF ty_sort,
        text     TYPE string,
        key      TYPE string,
        selected TYPE abap_bool,
      END OF ty_sort.

    DATA t_tab_sort TYPE STANDARD TABLE OF ty_sort WITH DEFAULT KEY.
    DATA t_tab_group TYPE STANDARD TABLE OF ty_sort WITH DEFAULT KEY.
    DATA t_tab_filter_title TYPE STANDARD TABLE OF ty_sort WITH DEFAULT KEY.

    DATA mv_sorter_group TYPE string.
    DATA mv_filter TYPE string.

    DATA mv_sort_descending TYPE abap_bool.
    DATA mv_group_descending TYPE abap_bool.
    DATA mv_group_desc_str TYPE string VALUE `false`.

  PROTECTED SECTION.

    DATA client TYPE REF TO Z2UI5_if_client.
    DATA check_initialized TYPE abap_bool.

    METHODS Z2UI5_set_data.
    METHODS Z2UI5_view_display.
    METHODS Z2UI5_view_sort_popup.
    METHODS Z2UI5_view_filter_popup.
    METHODS Z2UI5_view_group_popup.
    METHODS Z2UI5_view_settings_popup.
    METHODS Z2UI5_on_event.


  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_099 IMPLEMENTATION.


  METHOD Z2UI5_if_app~main.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

      Z2UI5_set_data( ).

      Z2UI5_view_display( ).
      RETURN.
    ENDIF.

    Z2UI5_on_event( ).

  ENDMETHOD.


  METHOD Z2UI5_on_event.
        DATA lt_arg TYPE string_table.
          DATA sort_field LIKE LINE OF lt_arg.
          DATA temp1 LIKE LINE OF lt_arg.
          DATA temp2 LIKE sy-tabix.
          DATA filter_string LIKE LINE OF lt_arg.
          DATA temp3 LIKE LINE OF lt_arg.
          DATA temp4 LIKE sy-tabix.
          DATA lv_dummy TYPE string.
          DATA lv_field TYPE string.
          DATA lv_values TYPE string.
          DATA lv_values_len TYPE i.
          DATA lt_values TYPE STANDARD TABLE OF string WITH DEFAULT KEY.
            DATA lv_val LIKE LINE OF lt_values.
          DATA mv_filter_len TYPE i.
          DATA group_field LIKE LINE OF lt_arg.
          DATA temp5 LIKE LINE OF lt_arg.
          DATA temp6 LIKE sy-tabix.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
      WHEN 'ALL'.
        Z2UI5_view_settings_popup( ).
      WHEN 'SORT'.
        Z2UI5_view_sort_popup( ).
      WHEN 'FILTER'.
        Z2UI5_view_filter_popup( ).
      WHEN 'GROUP'.
        Z2UI5_view_group_popup( ).
      WHEN 'CONFIRM_SORT'.
        
        lt_arg = client->get( )-t_event_arg.

        IF lt_arg IS NOT INITIAL.

          
          
          
          temp2 = sy-tabix.
          READ TABLE lt_arg INDEX 1 INTO temp1.
          sy-tabix = temp2.
          IF sy-subrc <> 0.
            RAISE EXCEPTION TYPE cx_sy_itab_line_not_found.
          ENDIF.
          sort_field = temp1.

          IF mv_sort_descending = abap_true.
            SORT t_tab BY (sort_field) DESCENDING.
          ELSE.
            SORT t_tab BY (sort_field) ASCENDING.

          ENDIF.

          client->view_model_update( ).

        ENDIF.

      WHEN 'CONFIRM_FILTER'.
        CLEAR mv_filter.
        lt_arg = client->get( )-t_event_arg.

        IF lt_arg IS NOT INITIAL.

          
          
          
          temp4 = sy-tabix.
          READ TABLE lt_arg INDEX 1 INTO temp3.
          sy-tabix = temp4.
          IF sy-subrc <> 0.
            RAISE EXCEPTION TYPE cx_sy_itab_line_not_found.
          ENDIF.
          filter_string = temp3.
          
          SPLIT filter_string AT ':' INTO lv_dummy filter_string.
          CONDENSE filter_string NO-GAPS.
          
          
          SPLIT filter_string AT `(` INTO lv_field lv_values.
          TRANSLATE lv_field TO UPPER CASE.
          
          lv_values_len = strlen( lv_values ) - 1.
          lv_values = lv_values+0(lv_values_len).
          
          SPLIT lv_values AT ',' INTO TABLE lt_values IN CHARACTER MODE.
          IF sy-subrc = 0.
            
            LOOP AT lt_values INTO lv_val.
              mv_filter = mv_filter && `{path:'` && lv_field && `',operator: 'EQ',value1:'` && lv_val && `'},`.
            ENDLOOP.
          ENDIF.
          
          mv_filter_len = strlen( mv_filter ) - 1.
          mv_filter = mv_filter+0(mv_filter_len).


          Z2UI5_view_display( ).

        ENDIF.

      WHEN 'CONFIRM_GROUP'.
        lt_arg = client->get( )-t_event_arg.

        IF lt_arg IS NOT INITIAL.

          
          
          
          temp6 = sy-tabix.
          READ TABLE lt_arg INDEX 1 INTO temp5.
          sy-tabix = temp6.
          IF sy-subrc <> 0.
            RAISE EXCEPTION TYPE cx_sy_itab_line_not_found.
          ENDIF.
          group_field = temp5.

          IF group_field IS NOT INITIAL.

            IF mv_group_descending = abap_true.
              SORT t_tab BY (group_field) DESCENDING.
            ELSE.
              SORT t_tab BY (group_field) ASCENDING.
            ENDIF.

            mv_sorter_group = group_field.
            TRANSLATE mv_sorter_group TO UPPER CASE.

          ENDIF.

          Z2UI5_view_display( ).

        ENDIF.

      WHEN 'RESET_GROUP'.
    ENDCASE.

  ENDMETHOD.


  METHOD Z2UI5_set_data.

    DATA temp1 LIKE t_tab.
    DATA temp2 LIKE LINE OF temp1.
    DATA temp3 LIKE t_tab_group.
    DATA temp4 LIKE LINE OF temp3.
    DATA temp5 LIKE t_tab_sort.
    DATA temp6 LIKE LINE OF temp5.
    DATA temp7 LIKE t_tab_filter_title.
    DATA temp8 LIKE LINE OF temp7.
    CLEAR temp1.
    
    temp2-title = 'row_01'.
    temp2-info = 'completed'.
    temp2-descr = 'this is a description'.
    temp2-icon = 'sap-icon://account'.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = 'row_02'.
    temp2-info = 'incompleted'.
    temp2-descr = 'this is a description'.
    temp2-icon = 'sap-icon://account'.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = 'row_03'.
    temp2-info = 'working'.
    temp2-descr = 'this is a description'.
    temp2-icon = 'sap-icon://account'.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = 'row_04'.
    temp2-info = 'working'.
    temp2-descr = 'this is a description'.
    temp2-icon = 'sap-icon://account'.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = 'row_05'.
    temp2-info = 'completed'.
    temp2-descr = 'this is a description'.
    temp2-icon = 'sap-icon://account'.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = 'row_06'.
    temp2-info = 'completed'.
    temp2-descr = 'this is a description'.
    temp2-icon = 'sap-icon://account'.
    INSERT temp2 INTO TABLE temp1.
    t_tab = temp1.

    
    CLEAR temp3.
    
    temp4-text = `Title`.
    temp4-key = `title`.
    INSERT temp4 INTO TABLE temp3.
    temp4-text = `Info`.
    temp4-key = `info`.
    INSERT temp4 INTO TABLE temp3.
    temp4-text = `Description`.
    temp4-key = `descr`.
    INSERT temp4 INTO TABLE temp3.
    t_tab_group = temp3.

    
    CLEAR temp5.
    
    temp6-text = `Title`.
    temp6-key = `title`.
    INSERT temp6 INTO TABLE temp5.
    temp6-text = `Info`.
    temp6-key = `info`.
    INSERT temp6 INTO TABLE temp5.
    temp6-text = `Description`.
    temp6-key = `descr`.
    INSERT temp6 INTO TABLE temp5.
    t_tab_sort = temp5.

    
    CLEAR temp7.
    
    temp8-text = `Info`.
    temp8-key = `Completed`.
    INSERT temp8 INTO TABLE temp7.
    temp8-text = `Info`.
    temp8-key = `Incompleted`.
    INSERT temp8 INTO TABLE temp7.
    t_tab_filter_title = temp7.


  ENDMETHOD.


  METHOD Z2UI5_view_display.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    view = z2ui5_cl_xml_view=>factory( ).
    
    page = view->shell(
        )->page(
            title          = 'abap2UI5 - List'
            navbuttonpress = client->_event( 'BACK' )
              shownavbutton = abap_true
            )->header_content(
                )->link(
                    text = 'Source_Code'  target = '_blank'
                    href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
            )->get_parent( ).


    page->table(
        headertext      = 'Table Output'
        items           = `{path:'` && client->_bind_edit( val = t_tab path = abap_true )
                            && `',sorter:{path:'` && mv_sorter_group
                            && `',group:` && `true` && `}`
                            && `,filters:[` && mv_filter && `] }`
       )->header_toolbar(
        )->overflow_toolbar(
          )->title( text = `Table` level = `H2`
          )->toolbar_spacer(
          )->button( icon = `sap-icon://sort` tooltip  = `Sort` press = client->_event( `SORT` )
          )->button( icon = `sap-icon://filter` tooltip  = `Filter` press = client->_event( `FILTER` )
          )->button( icon = `sap-icon://group-2` tooltip  = `Group` press = client->_event( `GROUP` )
          )->button( icon = `sap-icon://action-settings` tooltip  = `Group` press = client->_event( `ALL` )
         )->get_parent( )->get_parent(
       )->columns(
        )->column( )->text( text = `Title` )->get_parent(
        )->column( )->text( text = `Info` )->get_parent(
        )->column( )->text( text = `Descr` )->get_parent(
        )->column( )->text( text = `Icon` )->get_parent(
       )->get_parent(
      )->items(
        )->column_list_item( valign = `Middle`
          )->cells(
            )->text( text = `{TITLE}`
            )->text( text = `{INFO}`
            )->text( text = `{DESCR}`
            )->avatar( src = `{ICON}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD Z2UI5_view_filter_popup.

    DATA popup_filter TYPE REF TO z2ui5_cl_xml_view.
    DATA temp9 TYPE string_table.
    DATA filter_view TYPE REF TO z2ui5_cl_xml_view.
    popup_filter = Z2UI5_cl_xml_view=>factory_popup( ).

    
    CLEAR temp9.
    INSERT `${$parameters>/filterString}` INTO TABLE temp9.
    
    filter_view = popup_filter->view_settings_dialog( filteritems = client->_bind_edit( t_tab_filter_title )
                                                            confirm = client->_event( val = `CONFIRM_FILTER` t_arg = temp9 )
      )->filter_items(
        )->view_settings_filter_item( text = `Info` key = `INFO` multiselect = abap_true
          )->items(
            )->view_settings_item( text = `{TEXT}` key = `{KEY}` )->get_parent(
*            )->view_settings_item( text = `Completed` key = `Completed` )->get_parent(
*            )->view_settings_item( text = `Incompleted` key = `Incompleted` )->get_parent(
*            )->view_settings_item( text = `Working` key = `Working`
        ).

    client->popup_display( filter_view->stringify( ) ) .

  ENDMETHOD.


  METHOD Z2UI5_view_group_popup.

    DATA popup_group TYPE REF TO z2ui5_cl_xml_view.
    DATA temp11 TYPE string_table.
    DATA group_view TYPE REF TO z2ui5_cl_xml_view.
    popup_group = Z2UI5_cl_xml_view=>factory_popup( ).

    
    CLEAR temp11.
    INSERT `${$parameters>/groupItem/mProperties/key}` INTO TABLE temp11.
    
    group_view = popup_group->view_settings_dialog( confirm = client->_event( val = `CONFIRM_GROUP` t_arg = temp11 )
                                                          reset = client->_event( `RESET_GROUP` )
                                                          groupdescending = client->_bind_edit( mv_group_descending )
                                                          groupitems = client->_bind_edit( t_tab_group )
                                                          filteritems = client->_bind_edit( t_tab_filter_title )
                        )->group_items(
                          )->view_settings_item( text = `{TEXT}` key = `{KEY}` selected = `{SELECTED}`
                         ).

    client->popup_display( group_view->stringify( ) ).

  ENDMETHOD.


  METHOD Z2UI5_view_settings_popup.
    DATA popup_settings TYPE REF TO z2ui5_cl_xml_view.
    popup_settings = Z2UI5_cl_xml_view=>factory_popup( ).

    popup_settings = popup_settings->view_settings_dialog(
                                    confirm = client->_event( 'ALL_EVENT' )
                                    sortitems = client->_bind_edit( t_tab_sort )
                                    groupitems = client->_bind_edit( t_tab_group )
                        )->sort_items(
                          )->view_settings_item( text = `{TEXT}` key = `{KEY}` selected = `{SELECTED}` )->get_parent( )->get_parent(
                        )->group_items(
                          )->view_settings_item( text = `{TEXT}` key = `{KEY}` selected = `{SELECTED}` )->get_parent( )->get_parent(
                        )->filter_items(
                          )->view_settings_filter_item( text = `Info` key = `INFO` multiselect = abap_true
                            )->items(
                              )->view_settings_item( text = `{TEXT}` key = `{KEY}` ).

    client->popup_display( popup_settings->stringify( ) ).

  ENDMETHOD.


  METHOD Z2UI5_view_sort_popup.

    DATA popup_sort TYPE REF TO z2ui5_cl_xml_view.
    DATA temp13 TYPE string_table.
    DATA sort_view TYPE REF TO z2ui5_cl_xml_view.
    popup_sort = Z2UI5_cl_xml_view=>factory_popup( ).

    
    CLEAR temp13.
    INSERT `${$parameters>/sortItem/mProperties/key}` INTO TABLE temp13.
    
    sort_view = popup_sort->view_settings_dialog(
                                    confirm = client->_event( val = `CONFIRM_SORT` t_arg = temp13 )
                                    sortitems = client->_bind_edit( t_tab_sort )
                                    sortdescending = client->_bind_edit( mv_sort_descending )
                        )->sort_items(
                          )->view_settings_item( text = `{TEXT}` key = `{KEY}` selected = `{SELECTED}` ).

    client->popup_display( sort_view->stringify( ) ).

  ENDMETHOD.
ENDCLASS.

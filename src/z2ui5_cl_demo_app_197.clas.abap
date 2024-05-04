CLASS z2ui5_cl_demo_app_197 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_serializable_object .
    INTERFACES z2ui5_if_app .

    TYPES:
      BEGIN OF ty_s_tab,
        selkz            TYPE abap_bool,
        product          TYPE string,
        create_date      TYPE string,
        create_by        TYPE string,
        storage_location TYPE string,
        quantity         TYPE i,
      END OF ty_s_tab .
    TYPES:
      ty_t_table TYPE STANDARD TABLE OF ty_s_tab WITH DEFAULT KEY .

    DATA mt_table TYPE ty_t_table .
    DATA mt_table_products TYPE ty_t_table .
    DATA check_initialized TYPE abap_bool .
    DATA client TYPE REF TO z2ui5_if_client .
    DATA mv_check_popover TYPE abap_bool .
    DATA mv_product TYPE string .

    METHODS z2ui5_set_data .
    METHODS z2ui5_display_view .

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_197 IMPLEMENTATION.


  METHOD z2ui5_display_view.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA temp2 TYPE xsdboolean.
    DATA temp1 TYPE string_table.
    DATA facet TYPE REF TO z2ui5_cl_xml_view.
    DATA tab TYPE REF TO z2ui5_cl_xml_view.
    DATA lo_columns TYPE REF TO z2ui5_cl_xml_view.
    DATA lo_cells TYPE REF TO z2ui5_cl_xml_view.
    view = z2ui5_cl_xml_view=>factory( ).

    
    
    temp2 = boolc( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ).
    page = view->page( id = `page_main`
            title          = 'abap2UI5 - List Report Features'
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton = temp2 ).

    
    CLEAR temp1.
    INSERT `$event.mParameters.selectedItems` INTO TABLE temp1.
    
    facet = page->facet_filter( id = `idFacetFilter` type = `Light` showpersonalization = abap_true showreset = abap_true
      )->facet_filter_list( title = `Products` mode = `MultiSelect` items = client->_bind( mt_table_products ) listclose = client->_event( val = `FILTER`
*                                                                           t_arg = VALUE #( ( `${$parameters>/selectedAll}` ) ) )
*                                                                           t_arg = VALUE #( ( `$event.mParameters` ) ) )
                                                                           t_arg = temp1 )
        )->facet_filter_item( text = `{PRODUCT}` ).

    
    tab = page->table( id = `tab` items = client->_bind_edit( val = mt_table ) ).

    
    lo_columns = tab->columns( ).
    lo_columns->column( )->text( text = `Product` ).
    lo_columns->column( )->text( text = `Date` ).
    lo_columns->column( )->text( text = `Name` ).
    lo_columns->column( )->text( text = `Location` ).
    lo_columns->column( )->text( text = `Quantity` ).

    
    lo_cells = tab->items(  )->column_list_item( ).
    lo_cells->link( id = `link` text = '{PRODUCT}' press = client->_event( val = `POPOVER_DETAIL` ) ).
    lo_cells->text( `{CREATE_DATE}` ).
    lo_cells->text( `{CREATE_BY}` ).
    lo_cells->text( `{STORAGE_LOCATION}` ).
    lo_cells->text( `{QUANTITY}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.
TYPES BEGIN OF ty_t_arg.
TYPES mProperties TYPE string.
TYPES val TYPE string.
TYPES END OF ty_t_arg.
        TYPES temp3 TYPE TABLE OF ty_t_arg.
DATA mt_t_arg TYPE temp3.
        DATA lt_arg TYPE string_table.
        DATA lv_json LIKE LINE OF lt_arg.
        DATA temp1 LIKE LINE OF lt_arg.
        DATA temp2 LIKE sy-tabix.
            DATA lo_json TYPE REF TO z2ui5_cl_ajson.
            DATA l_members TYPE string_table.
            DATA l_member LIKE LINE OF l_members.
              DATA lv_val TYPE string.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      z2ui5_display_view( ).
      z2ui5_set_data( ).
      RETURN.
    ENDIF.

    CASE client->get( )-event.
      WHEN 'FILTER'.

        

        


        
        lt_arg = client->get( )-t_event_arg.
        
        
        
        temp2 = sy-tabix.
        READ TABLE lt_arg INDEX 1 INTO temp1.
        sy-tabix = temp2.
        IF sy-subrc <> 0.
          ASSERT 1 = 0.
        ENDIF.
        lv_json = temp1.
        TRY.
            
            lo_json = z2ui5_cl_ajson=>parse( lv_json ).

            
            l_members = lo_json->members( '/' ).

            
            LOOP AT l_members INTO l_member.
              
              lv_val =  lo_json->get( '/' && l_member && '/mProperties/text' ).
            ENDLOOP.

          CATCH cx_root.
        ENDTRY.

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_set_data.

    DATA temp3 TYPE z2ui5_cl_demo_app_197=>ty_t_table.
    DATA temp4 LIKE LINE OF temp3.
    CLEAR temp3.
    
    temp4-product = 'table'.
    temp4-create_date = `01.01.2023`.
    temp4-create_by = `Peter`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 400.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = 'chair'.
    temp4-create_date = `01.01.2022`.
    temp4-create_by = `James`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 123.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = 'sofa'.
    temp4-create_date = `01.05.2021`.
    temp4-create_by = `Simone`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 700.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = 'computer'.
    temp4-create_date = `27.01.2023`.
    temp4-create_by = `Theo`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 200.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = 'printer'.
    temp4-create_date = `01.01.2023`.
    temp4-create_by = `Hannah`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 90.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = 'table2'.
    temp4-create_date = `01.01.2023`.
    temp4-create_by = `Julia`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 110.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = 'table'.
    temp4-create_date = `01.01.2023`.
    temp4-create_by = `Peter`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 400.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = 'chair'.
    temp4-create_date = `01.01.2022`.
    temp4-create_by = `James`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 123.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = 'sofa'.
    temp4-create_date = `01.05.2021`.
    temp4-create_by = `Simone`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 700.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = 'computer'.
    temp4-create_date = `27.01.2023`.
    temp4-create_by = `Theo`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 200.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = 'printer'.
    temp4-create_date = `01.01.2023`.
    temp4-create_by = `Hannah`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 90.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = 'table2'.
    temp4-create_date = `01.01.2023`.
    temp4-create_by = `Julia`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 110.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = 'table'.
    temp4-create_date = `01.01.2023`.
    temp4-create_by = `Peter`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 400.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = 'chair'.
    temp4-create_date = `01.01.2022`.
    temp4-create_by = `James`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 123.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = 'sofa'.
    temp4-create_date = `01.05.2021`.
    temp4-create_by = `Simone`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 700.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = 'computer'.
    temp4-create_date = `27.01.2023`.
    temp4-create_by = `Theo`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 200.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = 'printer'.
    temp4-create_date = `01.01.2023`.
    temp4-create_by = `Hannah`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 90.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = 'table2'.
    temp4-create_date = `01.01.2023`.
    temp4-create_by = `Julia`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 110.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = 'table'.
    temp4-create_date = `01.01.2023`.
    temp4-create_by = `Peter`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 400.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = 'chair'.
    temp4-create_date = `01.01.2022`.
    temp4-create_by = `James`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 123.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = 'sofa'.
    temp4-create_date = `01.05.2021`.
    temp4-create_by = `Simone`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 700.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = 'computer'.
    temp4-create_date = `27.01.2023`.
    temp4-create_by = `Theo`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 200.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = 'printer'.
    temp4-create_date = `01.01.2023`.
    temp4-create_by = `Hannah`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 90.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = 'table2'.
    temp4-create_date = `01.01.2023`.
    temp4-create_by = `Julia`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 110.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = 'table'.
    temp4-create_date = `01.01.2023`.
    temp4-create_by = `Peter`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 400.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = 'chair'.
    temp4-create_date = `01.01.2022`.
    temp4-create_by = `James`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 123.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = 'sofa'.
    temp4-create_date = `01.05.2021`.
    temp4-create_by = `Simone`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 700.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = 'computer'.
    temp4-create_date = `27.01.2023`.
    temp4-create_by = `Theo`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 200.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = 'printer'.
    temp4-create_date = `01.01.2023`.
    temp4-create_by = `Hannah`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 90.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = 'table2'.
    temp4-create_date = `01.01.2023`.
    temp4-create_by = `Julia`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 110.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = 'table'.
    temp4-create_date = `01.01.2023`.
    temp4-create_by = `Peter`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 400.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = 'chair'.
    temp4-create_date = `01.01.2022`.
    temp4-create_by = `James`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 123.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = 'sofa'.
    temp4-create_date = `01.05.2021`.
    temp4-create_by = `Simone`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 700.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = 'computer'.
    temp4-create_date = `27.01.2023`.
    temp4-create_by = `Theo`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 200.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = 'printer'.
    temp4-create_date = `01.01.2023`.
    temp4-create_by = `Hannah`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 90.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = 'table2'.
    temp4-create_date = `01.01.2023`.
    temp4-create_by = `Julia`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 110.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = 'table'.
    temp4-create_date = `01.01.2023`.
    temp4-create_by = `Peter`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 400.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = 'chair'.
    temp4-create_date = `01.01.2022`.
    temp4-create_by = `James`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 123.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = 'sofa'.
    temp4-create_date = `01.05.2021`.
    temp4-create_by = `Simone`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 700.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = 'computer'.
    temp4-create_date = `27.01.2023`.
    temp4-create_by = `Theo`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 200.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = 'printer'.
    temp4-create_date = `01.01.2023`.
    temp4-create_by = `Hannah`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 90.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = 'table2'.
    temp4-create_date = `01.01.2023`.
    temp4-create_by = `Julia`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 110.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = 'table'.
    temp4-create_date = `01.01.2023`.
    temp4-create_by = `Peter`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 400.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = 'chair'.
    temp4-create_date = `01.01.2022`.
    temp4-create_by = `James`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 123.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = 'sofa'.
    temp4-create_date = `01.05.2021`.
    temp4-create_by = `Simone`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 700.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = 'computer'.
    temp4-create_date = `27.01.2023`.
    temp4-create_by = `Theo`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 200.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = 'printer'.
    temp4-create_date = `01.01.2023`.
    temp4-create_by = `Hannah`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 90.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = 'table2'.
    temp4-create_date = `01.01.2023`.
    temp4-create_by = `Julia`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 110.
    INSERT temp4 INTO TABLE temp3.
    mt_table = temp3.

    mt_table_products = mt_table.

    SORT mt_table_products BY product.

    DELETE ADJACENT DUPLICATES FROM mt_table_products COMPARING product.

  ENDMETHOD.
ENDCLASS.

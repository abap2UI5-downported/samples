CLASS Z2UI5_CL_DEMO_APP_059 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES Z2UI5_if_app.

    TYPES:
      BEGIN OF ty_s_tab,
        selkz            TYPE abap_bool,
        product          TYPE string,
        create_date      TYPE string,
        create_by        TYPE string,
        storage_location TYPE string,
        quantity         TYPE i,
      END OF ty_s_tab.

    TYPES ty_t_table TYPE STANDARD TABLE OF ty_s_tab WITH DEFAULT KEY.

    DATA mv_search_value TYPE string.
    DATA mt_table TYPE ty_t_table.
    data mv_key type string.

  PROTECTED SECTION.

    DATA client TYPE REF TO Z2UI5_if_client.
    DATA check_initialized TYPE abap_bool.

    METHODS Z2UI5_on_init.
    METHODS Z2UI5_on_event.
    METHODS Z2UI5_set_search.
    METHODS Z2UI5_set_data.
    methods Z2UI5_view_display.

  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_059 IMPLEMENTATION.


  METHOD Z2UI5_if_app~main.

    me->client     = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      Z2UI5_on_init( ).
      Z2UI5_view_display( ).
      RETURN.
    ENDIF.

    Z2UI5_on_event( ).

  ENDMETHOD.


  METHOD Z2UI5_on_event.

    CASE client->get( )-event.

      WHEN 'BUTTON_SEARCH' OR 'BUTTON_START'.
        Z2UI5_set_data( ).
        Z2UI5_set_search( ).
        client->view_model_update( ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD Z2UI5_on_init.

     mv_key = 'VIEW_REFRESH'.

  ENDMETHOD.


  METHOD Z2UI5_set_data.

    DATA temp1 TYPE z2ui5_cl_demo_app_059=>ty_t_table.
    DATA temp2 LIKE LINE OF temp1.
    CLEAR temp1.
    
    temp2-product = 'table'.
    temp2-create_date = `01.01.2023`.
    temp2-create_by = `Peter`.
    temp2-storage_location = `AREA_001`.
    temp2-quantity = 400.
    INSERT temp2 INTO TABLE temp1.
    temp2-product = 'chair'.
    temp2-create_date = `01.01.2022`.
    temp2-create_by = `James`.
    temp2-storage_location = `AREA_001`.
    temp2-quantity = 123.
    INSERT temp2 INTO TABLE temp1.
    temp2-product = 'sofa'.
    temp2-create_date = `01.05.2021`.
    temp2-create_by = `Simone`.
    temp2-storage_location = `AREA_001`.
    temp2-quantity = 700.
    INSERT temp2 INTO TABLE temp1.
    temp2-product = 'computer'.
    temp2-create_date = `27.01.2023`.
    temp2-create_by = `Theo`.
    temp2-storage_location = `AREA_001`.
    temp2-quantity = 200.
    INSERT temp2 INTO TABLE temp1.
    temp2-product = 'printer'.
    temp2-create_date = `01.01.2023`.
    temp2-create_by = `Hannah`.
    temp2-storage_location = `AREA_001`.
    temp2-quantity = 90.
    INSERT temp2 INTO TABLE temp1.
    temp2-product = 'table2'.
    temp2-create_date = `01.01.2023`.
    temp2-create_by = `Julia`.
    temp2-storage_location = `AREA_001`.
    temp2-quantity = 110.
    INSERT temp2 INTO TABLE temp1.
    mt_table = temp1.

  ENDMETHOD.


  METHOD Z2UI5_set_search.
      DATA temp3 LIKE LINE OF mt_table.
      DATA lr_row LIKE REF TO temp3.
        DATA lv_row TYPE string.
        DATA lv_index TYPE i.
          FIELD-SYMBOLS <field> TYPE any.

    IF mv_search_value IS NOT INITIAL.

      
      
      LOOP AT mt_table REFERENCE INTO lr_row.
        
        lv_row = ``.
        
        lv_index = 1.
        DO.
          
          ASSIGN COMPONENT lv_index OF STRUCTURE lr_row->* TO <field>.
          IF sy-subrc <> 0.
            EXIT.
          ENDIF.
          lv_row = lv_row && <field>.
          lv_index = lv_index + 1.
        ENDDO.

        IF lv_row NS mv_search_value.
          DELETE mt_table.
        ENDIF.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.


method Z2UI5_view_display.

 DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA page1 TYPE REF TO z2ui5_cl_xml_view.
    DATA temp1 TYPE xsdboolean.
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA header_title TYPE REF TO z2ui5_cl_xml_view.
    DATA lo_box TYPE REF TO z2ui5_cl_xml_view.
    DATA cont TYPE REF TO z2ui5_cl_xml_view.
    DATA tab TYPE REF TO z2ui5_cl_xml_view.
    DATA lo_columns TYPE REF TO z2ui5_cl_xml_view.
    DATA lo_cells TYPE REF TO z2ui5_cl_xml_view.
 view = z2ui5_cl_xml_view=>factory( ).

    
    
    temp1 = boolc( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ).
    page1 = view->page( id = `page_main`
            title          = 'abap2UI5 - List Report Features'
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton = temp1 ).

      page1->header_content(
            )->link(
                text = 'Demo' target = '_blank'
                href = 'https://twitter.com/abap2UI5/status/1674437273943937025'
            )->link(
                text = 'Source_Code' target = '_blank' href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
       ).

    
    page = page1->dynamic_page( headerexpanded = abap_true headerpinned = abap_true ).

    
    header_title = page->title( ns = 'f'  )->get( )->dynamic_page_title( ).
    header_title->heading( ns = 'f' )->hbox( )->title( `Search Field` ).
    header_title->expanded_content( 'f' ).
    header_title->snapped_content( ns = 'f' ).

    
    lo_box = page->header( )->dynamic_page_header( pinnable = abap_true
         )->flex_box( alignitems = `Start` justifycontent = `SpaceBetween` )->flex_box( alignItems = `Start` ).

    lo_box->vbox( )->text( `Search` )->search_field(
         value  = client->_bind_edit( mv_search_value )
         search = client->_event( 'BUTTON_SEARCH' )
         change = client->_event( 'BUTTON_SEARCH' )
         livechange = client->_event( 'BUTTON_SEARCH' )
         width  = `17.5rem`
         id     = `SEARCH`
         ).

    lo_box->get_parent( )->hbox( justifycontent = `End` )->button(
        text = `Go`
        press = client->_event( `BUTTON_START` )
        type = `Emphasized` ).

    
    cont = page->content( ns = 'f' ).

    
    tab = cont->table( items = client->_bind( val = mt_table ) ).

    
    lo_columns = tab->columns( ).
    lo_columns->column( )->text( text = `Product` ).
    lo_columns->column( )->text( text = `Date` ).
    lo_columns->column( )->text( text = `Name` ).
    lo_columns->column( )->text( text = `Location` ).
    lo_columns->column( )->text( text = `Quantity` ).

    
    lo_cells = tab->items( )->column_list_item( ).
    lo_cells->text( `{PRODUCT}` ).
    lo_cells->text( `{CREATE_DATE}` ).
    lo_cells->text( `{CREATE_BY}` ).
    lo_cells->text( `{STORAGE_LOCATION}` ).
    lo_cells->text( `{QUANTITY}` ).

    client->view_display( view->stringify( ) ).

endmethod.
ENDCLASS.

CLASS z2ui5_cl_demo_app_077 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_serializable_object .
    INTERFACES z2ui5_if_app .

    TYPES:
      BEGIN OF ty_value_map,
        pc TYPE string,
        ea TYPE string,
      END OF ty_value_map.

    TYPES:
      BEGIN OF ty_column_config,
        label             TYPE string,
        property          TYPE string,
        type              TYPE string,
        unit              TYPE string,
        delimiter         TYPE abap_bool,
        unit_property     TYPE string,
        width             TYPE string,
        scale             TYPE i,
        text_align        TYPE string,
        display_unit      TYPE string,
        true_value        TYPE string,
        false_value       TYPE string,
        template          TYPE string,
        input_format      TYPE string,
        wrap              TYPE abap_bool,
        auto_scale        TYPE abap_bool,
        timezone          TYPE string,
        timezone_property TYPE string,
        display_timezone  TYPE abap_bool,
        utc               TYPE abap_bool,
        value_map         TYPE ty_value_map,
      END OF ty_column_config.

    TYPES temp1_c15caaba07 TYPE STANDARD TABLE OF ty_column_config WITH DEFAULT KEY.
DATA: mt_column_config TYPE temp1_c15caaba07.
    DATA: mv_column_config TYPE string.

    TYPES:
      BEGIN OF ty_s_tab,
        selkz           TYPE abap_bool,
        rowid           TYPE string,
        product         TYPE string,
        createdate      TYPE string,
        createby        TYPE string,
        storagelocation TYPE string,
        quantity        TYPE i,
        meins           TYPE meins,
        price           TYPE p LENGTH 10 DECIMALS 2,
        waers           TYPE waers,
        selected        TYPE abap_bool,
      END OF ty_s_tab .
    TYPES:
      ty_t_table TYPE STANDARD TABLE OF ty_s_tab WITH DEFAULT KEY .
    DATA mt_table TYPE ty_t_table.
  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client.
    DATA check_initialized TYPE abap_bool VALUE abap_false.
    DATA check_load_cc   TYPE abap_bool VALUE abap_false.

    METHODS z2ui5_on_init.
    METHODS z2ui5_on_event.
    METHODS z2ui5_set_data.

  PRIVATE SECTION.

ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_077 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF check_load_cc = abap_false.
      check_load_cc = abap_true.
      z2ui5_set_data( ).
*      client->nav_app_call( z2ui5_cl_popup_js_loader=>factory( z2ui5_cl_cc_spreadsheet=>get_js( mv_column_config ) ) ).
      client->nav_app_call( z2ui5_cl_pop_js_loader=>factory( z2ui5_cl_cc_spreadsheet=>get_js( ) ) ).
      RETURN.
    ELSEIF check_initialized = abap_false.
      check_initialized = abap_true.
      z2ui5_on_init( ).
      RETURN.
    ENDIF.

    z2ui5_on_event( ).

  ENDMETHOD.


  METHOD z2ui5_on_event.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_on_init.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA page1 TYPE REF TO z2ui5_cl_xml_view.
    DATA temp2 TYPE xsdboolean.
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA header_title TYPE REF TO z2ui5_cl_xml_view.
    DATA lo_box TYPE REF TO z2ui5_cl_xml_view.
    DATA cont TYPE REF TO z2ui5_cl_xml_view.
    DATA tab TYPE REF TO z2ui5_cl_xml_view.
    DATA temp1 TYPE REF TO z2ui5_cl_cc_spreadsheet.
    view = z2ui5_cl_xml_view=>factory( ).

    
    
    temp2 = boolc( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ).
    page1 = view->page( id = `page_main`
            title          = 'abap2UI5 - XLSX Export'
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton = temp2
            class = 'sapUiContentPadding' ).

    page1->header_content(
       )->link( text = 'Demo' target = '_blank' href = `https://twitter.com/abap2UI5/status/1683753816716345345`
       )->link( text = 'Source_Code' target = '_blank'  ).

    
    page = page1->dynamic_page( headerexpanded = abap_true headerpinned = abap_true ).

    
    header_title = page->title( ns = 'f'  )->get( )->dynamic_page_title( ).
    header_title->heading( ns = 'f' )->hbox( )->title( `Table XLSX Export` ).
    header_title->expanded_content( 'f' ).
    header_title->snapped_content( ns = 'f' ).

    
    lo_box = page->header( )->dynamic_page_header( pinnable = abap_true
         )->flex_box( alignitems = `Start` justifycontent = `SpaceBetween`
         )->flex_box( alignitems = `Start` ).

    
    cont = page->content( ns = 'f' ).

    
    
    CREATE OBJECT temp1 TYPE z2ui5_cl_cc_spreadsheet.
    tab = cont->table(
              id = `exportTable`
              items = client->_bind( mt_table )
          )->header_toolbar(
              )->overflow_toolbar(
                  )->title( 'title of the table'
                  )->toolbar_spacer(
                  )->_z2ui5( )->spreadsheet_export(
                tableid = 'exportTable'
                icon = 'sap-icon://excel-attachment'
                type = 'Emphasized'
                columnconfig = client->_bind( val = mt_column_config
                                              custom_filter = temp1
                                              custom_mapper = z2ui5_cl_ajson_mapping=>create_lower_case( )
                                             )
          )->get_parent( )->get_parent( ).

    tab->columns(
        )->column(
            )->text( 'Row ID' )->get_parent(
        )->column(
            )->text( 'Product' )->get_parent(
        )->column(
            )->text( 'Create Date' )->get_parent(
        )->column(
            )->text( 'Create By' )->get_parent(
        )->column( )->text( 'Location' )->get_parent(
        )->column( )->text( 'Quantity' )->get_parent(
        )->column( )->text( 'Unit' )->get_parent(
        )->column( )->text( 'Price' ).

    tab->items( )->column_list_item(
      )->cells(
          )->text( text = '{ROWID}'
          )->text( text = '{PRODUCT}'
          )->text( text = '{CREATEDATE}'
          )->text( text = '{CREATEBY}'
          )->text( text = '{STORAGELOCATION}'
          )->text( text = '{QUANTITY}'
          )->text( text = '{MEINS}'
          )->text( text = '{PRICE}' ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_set_data.

    DATA temp1 TYPE z2ui5_cl_demo_app_077=>ty_t_table.
    DATA temp2 LIKE LINE OF temp1.
    DATA temp3 LIKE mt_column_config.
    DATA temp4 LIKE LINE OF temp3.
    CLEAR temp1.
    
    temp2-selkz = abap_false.
    temp2-rowid = '1'.
    temp2-product = 'table'.
    temp2-createdate = `01.01.2023`.
    temp2-createby = `Olaf`.
    temp2-storagelocation = `AREA_001`.
    temp2-quantity = 400.
    temp2-meins = 'PC'.
    temp2-price = '1000.50'.
    temp2-waers = 'EUR'.
    INSERT temp2 INTO TABLE temp1.
    temp2-selkz = abap_false.
    temp2-rowid = '2'.
    temp2-product = 'chair'.
    temp2-createdate = `01.01.2022`.
    temp2-createby = `Karlo`.
    temp2-storagelocation = `AREA_001`.
    temp2-quantity = 123.
    temp2-meins = 'PC'.
    temp2-price = '2000.55'.
    temp2-waers = 'USD'.
    INSERT temp2 INTO TABLE temp1.
    temp2-selkz = abap_false.
    temp2-rowid = '3'.
    temp2-product = 'sofa'.
    temp2-createdate = `01.05.2021`.
    temp2-createby = `Elin`.
    temp2-storagelocation = `AREA_002`.
    temp2-quantity = 700.
    temp2-meins = 'PC'.
    temp2-price = '3000.11'.
    temp2-waers = 'CNY'.
    INSERT temp2 INTO TABLE temp1.
    temp2-selkz = abap_false.
    temp2-rowid = '4'.
    temp2-product = 'computer'.
    temp2-createdate = `27.01.2023`.
    temp2-createby = `Theo`.
    temp2-storagelocation = `AREA_002`.
    temp2-quantity = 200.
    temp2-meins = 'EA'.
    temp2-price = '4000.88'.
    temp2-waers = 'USD'.
    INSERT temp2 INTO TABLE temp1.
    temp2-selkz = abap_false.
    temp2-rowid = '5'.
    temp2-product = 'printer'.
    temp2-createdate = `01.01.2023`.
    temp2-createby = `Renate`.
    temp2-storagelocation = `AREA_003`.
    temp2-quantity = 90.
    temp2-meins = 'PC'.
    temp2-price = '5000.47'.
    temp2-waers = 'EUR'.
    INSERT temp2 INTO TABLE temp1.
    temp2-selkz = abap_false.
    temp2-rowid = '6'.
    temp2-product = 'table2'.
    temp2-createdate = `01.01.2023`.
    temp2-createby = `Angela`.
    temp2-storagelocation = `AREA_003`.
    temp2-quantity = 1110.
    temp2-meins = 'PC'.
    temp2-price = '6000.33'.
    temp2-waers = 'GBP'.
    INSERT temp2 INTO TABLE temp1.
    mt_table = temp1.

    
    CLEAR temp3.
    
    temp4-label = 'Index'.
    temp4-property = 'ROWID'.
    temp4-type = 'String'.
    INSERT temp4 INTO TABLE temp3.
    temp4-label = 'Product'.
    temp4-property = 'PRODUCT'.
    temp4-type = 'String'.
    INSERT temp4 INTO TABLE temp3.
    temp4-label = 'Date'.
    temp4-property = 'CREATEDATE'.
    temp4-type = 'String'.
    INSERT temp4 INTO TABLE temp3.
    temp4-label = 'Name'.
    temp4-property = 'CREATEBY'.
    temp4-type = 'String'.
    INSERT temp4 INTO TABLE temp3.
    temp4-label = 'Location'.
    temp4-property = 'STORAGELOCATION'.
    temp4-type = 'String'.
    INSERT temp4 INTO TABLE temp3.
    temp4-label = 'Quantity'.
    temp4-property = 'QUANTITY'.
    temp4-type = 'Number'.
    temp4-delimiter = abap_true.
    INSERT temp4 INTO TABLE temp3.
    temp4-label = 'Unit'.
    temp4-property = 'MEINS'.
    temp4-type = 'String'.
    INSERT temp4 INTO TABLE temp3.
    temp4-label = 'Price'.
    temp4-property = 'PRICE'.
    temp4-type = 'Currency'.
    temp4-unit_property = 'WAERS'.
    temp4-width = 14.
    temp4-scale = 2.
    INSERT temp4 INTO TABLE temp3.
    mt_column_config = temp3.

    mv_column_config =  /ui2/cl_json=>serialize(
                          data             = mt_column_config
                          compress         = abap_true
                          pretty_name      = 'X' ).

  ENDMETHOD.
ENDCLASS.

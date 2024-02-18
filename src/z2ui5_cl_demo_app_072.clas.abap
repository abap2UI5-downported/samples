CLASS Z2UI5_CL_DEMO_APP_072 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES Z2UI5_if_app.

    TYPES:
      BEGIN OF ty_s_tab,
        productid     TYPE string,
        productname   TYPE string,
        Suppliername  TYPE string,
        Measure       TYPE p LENGTH 10 DECIMALS 2,
        unit          TYPE string, "meins,
        price         TYPE p LENGTH 14 DECIMALS 3, "p LENGTH 10 DECIMALS 2,
        waers         TYPE waers,
        Width         TYPE string,
        Depth         TYPE string,
        Height        TYPE string,
        DimUnit       TYPE meins,
        state_price   TYPE string,
        state_measure TYPE string,
        rating        TYPE string,
      END OF ty_s_tab .
    TYPES:
      ty_t_table TYPE STANDARD TABLE OF ty_s_tab WITH DEFAULT KEY .

    DATA mt_table TYPE ty_t_table .
    DATA lv_cnt_total TYPE i .
    DATA lv_cnt_pos TYPE i .
    DATA lv_cnt_heavy TYPE i .
    DATA lv_cnt_neg TYPE i .
    DATA lv_selectedkey TYPE string .
    CONSTANTS c_lcb TYPE string VALUE '{' ##NO_TEXT.
    CONSTANTS c_rcb TYPE string VALUE '}' ##NO_TEXT.
  PROTECTED SECTION.

    DATA client TYPE REF TO Z2UI5_if_client .
    DATA check_initialized TYPE abap_bool .

    METHODS Z2UI5_on_init .
    METHODS Z2UI5_on_event .
    METHODS Z2UI5_set_data .
  PRIVATE SECTION.

    METHODS set_filter .
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_072 IMPLEMENTATION.


  METHOD Z2UI5_if_app~main.
    me->client     = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      Z2UI5_set_data( ).
      Z2UI5_on_init( ).
      RETURN.
    ENDIF.

    Z2UI5_on_event( ).

  ENDMETHOD.


  METHOD Z2UI5_on_event.

    CASE client->get( )-event.
      WHEN 'OnSelectIconTabBar' .
        client->message_toast_display( |Event SelectedTabBar Key { lv_selectedKey  } | ).
        set_filter( ).
        client->view_model_update( ).
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
    ENDCASE.

  ENDMETHOD.


  METHOD Z2UI5_on_init.


    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA temp2 TYPE xsdboolean.
    DATA temp3 TYPE xsdboolean.
    DATA temp1 TYPE string_table.
    DATA lo_items TYPE REF TO z2ui5_cl_xml_view.
    DATA tab TYPE REF TO z2ui5_cl_xml_view.
    view = z2ui5_cl_xml_view=>factory( ).

    
    
    temp2 = boolc( abap_false = client->get( )-check_launchpad_active ).
    
    temp3 = boolc( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ).
    page = view->page( id = `page_main`
           showheader       = temp2
            title          = 'abap2UI5 - IconTabBar'
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton = temp3
            class = 'sapUiContentPadding' ).

    page->header_content(
          )->link(
              text = 'Source_Code' target = '_blank' href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( ) ).
    
    CLEAR temp1.
    INSERT `${LV_SELECTEDKEY}` INTO TABLE temp1.
    
    lo_items = page->icon_tab_bar( class = 'sapUiResponsiveContentPadding' selectedKey = client->_bind_edit( lv_selectedKey )  select = client->_event( val = 'OnSelectIconTabBar' t_arg = temp1 ) )->items( ).
    lo_items->icon_tab_filter( count = client->_bind_edit( lv_cnt_total ) text = 'Products' key = 'ALL' showall = abap_true ).
    lo_items->icon_tab_separator(  ).
    lo_items->icon_tab_filter( icon = 'sap-icon://begin'     iconcolor = 'Positive' count = client->_bind_edit( lv_cnt_pos ) text = 'OK' key = 'OK'  ).
    lo_items->icon_tab_filter( icon = 'sap-icon://compare'   iconcolor = 'Critical' count = client->_bind_edit( lv_cnt_heavy ) text = 'Heavy' key = 'HEAVY'  ).
    lo_items->icon_tab_filter( icon = 'sap-icon://inventory' iconcolor = 'Negative' count = client->_bind_edit( lv_cnt_neg ) text = 'Overweight' key = 'OVERWEIGHT'  ).

    
    tab = page->scroll_container( height = '70%' vertical = abap_true
       )->table(
           inset = abap_false
           showSeparators = 'Inner'
           headerText = 'Products'
           items               = client->_bind( mt_table ) ).

    tab->columns(
        )->column( width = '12em'
            )->text( 'Product' )->get_parent(
        )->column( minScreenWidth = 'Tablet' demandPopin = abap_true
            )->text( 'Supplier' )->get_parent(
        )->column( minScreenWidth = 'Desktop' demandPopin = abap_true hAlign = 'End'
            )->text( 'Dimensions' )->get_parent(
        )->column( minScreenWidth = 'Desktop' demandPopin = abap_true hAlign = 'Center'
            )->text( 'Weight' )->get_parent(
         )->column( hAlign = 'End'
            )->text( 'Price' )->get_parent(
         )->column( hAlign = 'End'
             )->text( 'Rating' ) .

    tab->items(
        )->column_list_item(
           )->cells(
             )->object_identifier( text = '{PRODUCTNAME}' title =  '{PRODUCTID}' )->get_parent(
             )->text( text = '{SUPPLIERNAME}' )->get_parent(
             )->text( text = '{WIDTH} x {DEPTH} x {HEIGHT} {DIMUNIT}'
             )->object_number( number = '{MEASURE}' unit =  '{UNIT}' state = '{STATE_MEASURE}'
             )->object_number(
                   state = '{STATE_PRICE}'
                   number = `{ parts: [ { path : 'PRICE' } , { path : 'WAERS' } ] } `
             )->rating_indicator( VALUE = '{RATING}'  class = 'sapUiSmallMarginBottom' iconSize = '12px' maxvalue ='6' enabled = 'false' ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD Z2UI5_set_data.
    DATA temp3 TYPE z2ui5_cl_demo_app_072=>ty_t_table.
    DATA temp4 LIKE LINE OF temp3.
    DATA temp1 TYPE i.
    DATA i TYPE i.
    DATA temp6 LIKE LINE OF mt_table.
    DATA temp2 TYPE i.
    DATA j TYPE i.
    DATA temp5 LIKE LINE OF mt_table.
    DATA temp7 TYPE i.
    DATA k TYPE i.
    DATA wa LIKE LINE OF mt_table.
    CLEAR temp3.
    
    temp4-Productid = '1'.
    temp4-productname = 'table'.
    temp4-suppliername = 'Company 1'.
    temp4-Width = '10'.
    temp4-Depth = '20'.
    temp4-Height = '30'.
    temp4-DimUnit = 'CM'.
    temp4-Measure = 100.
    temp4-unit = 'ST'.
    temp4-price = '1000.50'.
    temp4-waers = 'EUR'.
    temp4-state_price = `Success`.
    temp4-rating = '0'.
    temp4-state_measure = `Warning`.
    INSERT temp4 INTO TABLE temp3.
    temp4-Productid = '2'.
    temp4-productname = 'chair'.
    temp4-suppliername = 'Company 2'.
    temp4-Width = '10'.
    temp4-Depth = '20'.
    temp4-Height = '30'.
    temp4-DimUnit = 'CM'.
    temp4-Measure = 123.
    temp4-unit = 'ST'.
    temp4-price = '2000.55'.
    temp4-waers = 'USD'.
    temp4-state_price = `Error`.
    temp4-rating = '1'.
    temp4-state_measure = `Warning`.
    INSERT temp4 INTO TABLE temp3.
    temp4-Productid = '3'.
    temp4-productname = 'sofa'.
    temp4-suppliername = 'Company 3'.
    temp4-Width = '10'.
    temp4-Depth = '20'.
    temp4-Height = '30'.
    temp4-DimUnit = 'CM'.
    temp4-Measure = 700.
    temp4-unit = 'ST'.
    temp4-price = '3000.11'.
    temp4-waers = 'CNY'.
    temp4-state_price = `Success`.
    temp4-rating = '2'.
    temp4-state_measure =
`Warning`.
    INSERT temp4 INTO TABLE temp3.
    temp4-Productid = '4'.
    temp4-productname = 'computer'.
    temp4-suppliername = 'Company 4'.
    temp4-Width = '10'.
    temp4-Depth = '20'.
    temp4-Height = '30'.
    temp4-DimUnit = 'CM'.
    temp4-Measure = 200.
    temp4-unit = 'ST'.
    temp4-price = '4000.88'.
    temp4-waers = 'USD'.
    temp4-state_price = `Success`.
    temp4-rating = '3'.
    temp4-state_measure =
`Success`.
    INSERT temp4 INTO TABLE temp3.
    temp4-Productid = '5'.
    temp4-productname = 'printer'.
    temp4-suppliername = 'Company 5'.
    temp4-Width = '10'.
    temp4-Depth = '20'.
    temp4-Height = '30'.
    temp4-DimUnit = 'CM'.
    temp4-Measure = 90.
    temp4-unit = 'ST'.
    temp4-price = '5000.47'.
    temp4-waers = 'EUR'.
    temp4-state_price = `Error`.
    temp4-rating = '4'.
    temp4-state_measure =
`Warning`.
    INSERT temp4 INTO TABLE temp3.
    temp4-Productid = '6'.
    temp4-productname = 'table2'.
    temp4-suppliername = 'Company 6'.
    temp4-Width = '10'.
    temp4-Depth = '20'.
    temp4-Height = '30'.
    temp4-DimUnit = 'CM'.
    temp4-Measure = 600.
    temp4-unit = 'ST'.
    temp4-price = '6000.33'.
    temp4-waers = 'GBP'.
    temp4-state_price = `Success`.
    temp4-rating = '5'.
    temp4-state_measure =
`Information`.
    INSERT temp4 INTO TABLE temp3.
    mt_table = temp3.

    lv_cnt_total = lines( mt_table ).
    
    
    i = 0.
    
    LOOP AT mt_table INTO temp6 WHERE measure > 0 AND measure <= 100.
      i = i + 1.
    ENDLOOP.
    temp1 = i.
    lv_cnt_pos = temp1.
    
    
    j = 0.
    
    LOOP AT mt_table INTO temp5 WHERE measure > 100 AND measure <= 500.
      j = j + 1.
    ENDLOOP.
    temp2 = j.
    lv_cnt_heavy = temp2.
    
    
    k = 0.
    
    LOOP AT mt_table INTO wa WHERE measure > 500.
      k = k + 1.
    ENDLOOP.
    temp7 = k.
    lv_cnt_neg = temp7.

  ENDMETHOD.


  METHOD set_filter.
    Z2UI5_set_data( ).
    CASE lv_selectedkey.
      WHEN 'ALL'.
      WHEN 'OK'.
        DELETE mt_table WHERE  NOT measure BETWEEN 0 AND 100.
      WHEN 'HEAVY'.
        DELETE mt_table WHERE NOT measure BETWEEN 101 AND 500.
      WHEN 'OVERWEIGHT'.
        DELETE mt_table WHERE NOT measure > 500 .
    ENDCASE.
  ENDMETHOD.
ENDCLASS.

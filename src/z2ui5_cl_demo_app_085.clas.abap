CLASS Z2UI5_CL_DEMO_APP_085 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_serializable_object .
    INTERFACES Z2UI5_if_app .

    TYPES:
      BEGIN OF ty_s_tab,
        key           TYPE string,
        productid     TYPE i,
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
        pic           TYPE string,
        rating        TYPE string,
        process       TYPE string,
      END OF ty_s_tab .
    TYPES:
      BEGIN OF ty_s_tab_supplier,
        Suppliername TYPE string,
        email        TYPE string,
        phone        TYPE string,
        zipcode      TYPE string,
        city         TYPE string,
        street       TYPE string,
        country      TYPE string,
      END OF ty_s_tab_supplier .
    TYPES:
      ty_t_table          TYPE STANDARD TABLE OF ty_s_tab WITH DEFAULT KEY .
    TYPES:
      ty_t_table_supplier TYPE STANDARD TABLE OF ty_s_tab_supplier WITH DEFAULT KEY .

    DATA mt_table TYPE ty_t_table .
    DATA mt_table_supplier TYPE ty_t_table_supplier .
    DATA check_initialized TYPE abap_bool .
    DATA mv_search_value TYPE string.
  PROTECTED SECTION.

    DATA client TYPE REF TO Z2UI5_if_client .

    METHODS view_display_master .
    METHODS view_display_detail .
    METHODS Z2UI5_set_data .
    METHODS Z2UI5_on_event .
    METHODS Z2UI5_on_init .
    METHODS Z2UI5_set_search.
  PRIVATE SECTION.

    DATA lv_layout TYPE string .
    DATA ls_detail TYPE ty_s_tab .
    DATA lv_sort_desc TYPE boolean VALUE abap_true.
    DATA c_pic_url TYPE string VALUE 'https://sapui5.hana.ondemand.com/sdk/test-resources/sap/ui/documentation/sdk/images/'.
    DATA ls_detail_supplier TYPE ty_s_tab_supplier .
    DATA check_detail_active TYPE abap_bool.

    METHODS sort .
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_085 IMPLEMENTATION.


  METHOD sort.
    IF lv_sort_desc = abap_true.
      SORT mt_table BY productid ASCENDING.
      lv_sort_desc = abap_false.
    ELSE.
      SORT mt_table BY productid DESCENDING.
      lv_sort_desc = abap_true.
    ENDIF.
  ENDMETHOD.


  METHOD view_display_detail.

    DATA lo_view_nested TYPE REF TO z2ui5_cl_xml_view.
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA header_title TYPE REF TO z2ui5_cl_xml_view.
    DATA temp1 TYPE string.
    DATA temp4 TYPE string.
    DATA header_content TYPE REF TO z2ui5_cl_xml_view.
    DATA temp2 TYPE string.
    DATA sections TYPE REF TO z2ui5_cl_xml_view.
    DATA temp3 TYPE string_table.
    lo_view_nested = z2ui5_cl_xml_view=>factory( ).

    
    page = lo_view_nested->object_page_layout(
            showtitleinheadercontent = abap_true
            showeditheaderbutton     = abap_true
            editheaderbuttonpress    =  client->_event( 'EDIT_HEADER_PRESS' )
            uppercaseanchorbar       =  abap_false
        ).

    
    header_title = page->header_title(  )->object_page_dyn_header_title( ).

    header_title->expanded_heading(
            )->hbox(
*                )->title( Text = |Product Id |
                )->info_label( text = |Product Id | && client->_bind_local( val = ls_detail-productid ) colorScheme = '9'
                               width = '200px' icon = 'sap-icon://home-share' ) .

    header_title->snapped_heading(
            )->flex_box( alignitems = `Center`
              )->avatar( src = c_pic_url && ls_detail-pic class = 'sapUiTinyMarginEnd'
                )->info_label( text = |Product Id | && client->_bind_local( val = ls_detail-productid ) colorScheme = '9'
                               width = '200px' icon = 'sap-icon://home-share' ) .

    header_title->expanded_content( ns = `uxap` )->text( client->_bind_local( val = ls_detail-productname ) ).
    header_title->snapped_Content( ns = `uxap` )->text( client->_bind_local( val = ls_detail-productname  ) ).
    header_title->snapped_Title_On_Mobile( )->title(  client->_bind_local( val = ls_detail-productname )  ).

    
    CASE lv_layout.
      WHEN 'TwoColumnsMidExpanded'.
        temp1 = 'false'.
      WHEN 'MidColumnFullScreen'.
        temp1 = 'true'.
    ENDCASE.
    
    CASE lv_layout.
      WHEN 'TwoColumnsMidExpanded'.
        temp4 = 'true'.
      WHEN 'MidColumnFullScreen'.
        temp4 = 'false'.
    ENDCASE.
    header_title->actions( ns = `uxap` )->overflow_toolbar(
         )->overflow_toolbar_button(
             icon    = `sap-icon://supplier`
             text    = 'Supplier Detail'
             type    = 'Transparent'
             enabled  = 'true'
             tooltip = 'Goto Supplier'
             press = client->_event( 'ONGOTOSUPPLIER' )
         )->overflow_toolbar_button(
             icon    = `sap-icon://exit-full-screen`
             text    = 'Exit Fullscreen Mode'
             type    = 'Transparent'
             tooltip = 'Close Fullscreen Mode'
             enabled  = temp1
             press = client->_event( 'ONEXITFULLSCREENMODE' )
          )->overflow_toolbar_button(
             icon    = `sap-icon://full-screen`
             text    = 'Enter Fullscreen Mode'
             type    = 'Transparent'
             enabled  = temp4
             tooltip = 'Fullscreen Mode'
             press = client->_event( 'ONFULLSCREENMODE' )
          )->overflow_toolbar_button(
             icon    = `sap-icon://decline`
             text    = 'Exit Detail Screen'
             type    = 'Transparent'
             enabled  = 'true'
             tooltip = 'Close Detail'
             press = client->_event( 'ONCLOSEDETAIL' )
         ).

    
    header_content = page->header_Content( ns = 'uxap').
    
    temp2 = ls_detail-measure.
    header_content->flex_box( wrap = 'Wrap'
       )->avatar( src = c_pic_url && ls_detail-pic class = 'sapUiSmallMarginEnd' displaySize = 'layout'
        )->vertical_layout( class = 'sapUiSmallMarginBeginEnd'
            )->label(  text    = 'Dimension'
            )->label(  text    = 'Weight'
            )->label(  text    = 'Price'
            )->label(  text    = 'Rating'
            )->label(  text    = 'Achived goals'
        )->get_parent(
        )->vertical_layout( class = 'sapUiSmallMarginBeginEnd'
            )->text( text    = | { ls_detail-width } x { ls_detail-depth } x { ls_detail-height } { ls_detail-dimunit }|
            )->object_number( number = temp2 unit =  ls_detail-unit state = ls_detail-state_measure
            )->text( text = |{ ls_detail-price } { ls_detail-waers } |
**            )->object_number( number = `{ parts: [ { path : 'PRICE' } , { path : 'WAERS' } ] } ` state = ls_detail-state_price
            )->vbox(
            )->rating_indicator( class = 'sapUiSmallMarginBottom' value = ls_detail-rating maxvalue = '6' displayOnly = 'true'
            )->get_parent(
            )->progress_indicator( percentvalue = ls_detail-process displayvalue = |{ ls_detail-process } %| state = ls_detail-state_price showvalue = 'true'
        )->get_parent( )->get_parent(
        )->vertical_layout( class = 'sapUiSmallMarginBeginEnd'
            )->label( text    = 'Supplier'
            )->label( text    = 'Country'
            )->label( text    = 'City'
            )->label( text    = 'Street'
            )->label( text    = 'Mail'
            )->label( text    = 'Phone'
        )->get_parent(
        )->vertical_layout( class = 'sapUiSmallMarginBeginEnd'
            )->label( text    = ls_detail_supplier-suppliername
            )->label( text    = ls_detail_supplier-country
            )->label( text    = |{ ls_detail_supplier-zipcode }-{ ls_detail_supplier-city } |
            )->link( text = ls_detail_supplier-street href = |https://www.google.com/maps/search/?api=1&query={ ls_detail_supplier-street },{ ls_detail_supplier-city },{ ls_detail_supplier-country }|
             target = '_blank'
            )->link( text = ls_detail_supplier-email href = |mailto:{ ls_detail_supplier-email }| target = '_blank'
            )->link( text = ls_detail_supplier-phone href = |tel:{ ls_detail_supplier-phone }|
        )->get_parent(
    ).

    
    sections = page->sections( ).

    sections->object_page_section( titleuppercase = abap_false id = 'SectionDescription' title = 'Description'
        )->heading( ns = `uxap`
*            )->message_strip( text = 'this is a message strip'
        )->get_parent(
        )->sub_sections(
            )->object_page_sub_section( id = 'SectionDescription1' title = 'Description'
                )->blocks(
                      )->vbox(
                          )->text_area( rows = '10' value = 'Text' editable = 'false' width = '100%'
            )->get_parent( )->get_parent( )->get_parent(
            )->object_page_sub_section( id = 'SectionDescription2' title = 'Picture'
                  )->blocks(
                        )->vbox(
                  )->image( src = c_pic_url && ls_detail-pic  ).

    sections->object_page_section( titleuppercase = abap_false id = 'SupplierSection' title = 'Supplier'
       )->heading( ns = `uxap`
       )->get_parent(
       )->sub_sections(
           )->object_page_sub_section( id = 'SupplierSection1' title = 'Connect'
               )->blocks(
*                     )->simple_form( layout = 'ResponsiveGridLayout' editable = 'false'
*                     )->content(
                     )->label( text    = |Phone { ls_detail_supplier-phone }|
                     )->label( text    = |Mail  { ls_detail_supplier-email }|
           )->get_parent( )->get_parent( )->get_parent(
           )->object_page_sub_section( id = 'SupplierSection2' title = 'Payment information  '
                 )->blocks(
                     )->label( text    = '20 Days Net' ).

    sections->object_page_section( titleuppercase = abap_false id = 'Others' title = 'Others'
     )->heading( ns = `uxap`
     )->get_parent(
     )->sub_sections(
         )->object_page_sub_section( id = 'Others1' title = 'Information'
                )->blocks(
                   )->vbox(
                   )->label( text    = 'info'
                   )->label( text    = 'info'
                )->get_parent( )->get_parent( )->get_parent(
                      )->object_page_sub_section( id = 'Others2' title = 'Details '
                      )->blocks(
                            )->vbox(
                          )->label( text    = 'details'
                          )->label( text    = 'details'

                          )->label( text    = 'details' ).




    
    CLEAR temp3.
    INSERT `${SUPPLIERNAME}` INTO TABLE temp3.
    sections->object_page_section( titleuppercase = abap_false id = 'OtherSuppliers' title = 'Other Supplier'
     )->heading( ns = `uxap`
     )->get_parent(
     )->sub_sections(
       )->object_page_sub_section( id = 'OtherSupplier1' title = 'Supplier List'
       )->scroll_container( height = '100%' vertical = abap_true
          )->table(
              inset = abap_false
              showSeparators = 'Inner'
              headerText = 'Suppliers'
*                   growing             = abap_true
*                   growingthreshold    = '20'
*                   growingscrolltoload = abap_true
              items               = client->_bind( mt_table_supplier )
              sticky              = 'ColumnHeaders,HeaderToolbar'

      )->columns(
        )->column(
            )->text( 'Supplier' )->get_parent(
        )->column(
            )->text( 'Country' )->get_parent(
        )->column(
            )->text( 'City' )->get_parent(
             )->get_parent(


    )->items(
        )->column_list_item( type = 'Navigation'  press = client->_event( val = `ONPRESSSUPPLIER` t_arg = temp3 )
           )->cells(
             )->text( text = '{SUPPLIERNAME}' )->get_parent(
             )->text( text = '{COUNTRY}'
             )->text( text = '{CITY}'
              ).


    check_detail_active = abap_true.
    client->nest_view_display(
      val            = lo_view_nested->stringify( )
      id             = `Detail`
      method_insert  = 'addMidColumnPage'
      method_destroy = 'removeAllMidColumnPages'
    ).

  ENDMETHOD.


  METHOD view_display_master.
    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA lr_master TYPE REF TO z2ui5_cl_xml_view.
    DATA tab TYPE REF TO z2ui5_cl_xml_view.
    DATA temp5 TYPE string_table.
    view = z2ui5_cl_xml_view=>factory( ).

    
    page = view->shell( )->page(
          title          = 'abap2UI5 - Master Detail'
          navbuttonpress = client->_event( 'BACK' )
            shownavbutton = abap_true
          )->header_content(
             )->link( text = 'Demo'    target = '_blank'    href = `https://twitter.com/abap2UI5/status/1691003695654133760`
             )->link( text = 'Source_Code'  target = '_blank'
         )->get_parent( ).

    
    lr_master = page->flexible_column_layout( layout = lv_layout id ='Detail' )->begin_column_pages( ).

    
    tab = lr_master->scroll_container( height = '100%' vertical = abap_true
   )->table(
       inset = abap_false
       showSeparators = 'Inner'
       headerText = 'Products'
*            growing             = abap_true
*            growingthreshold    = '20'
*            growingscrolltoload = abap_true
       items               = client->_bind( mt_table )
       sticky              = 'ColumnHeaders,HeaderToolbar' ).


    tab->header_toolbar( )->overflow_toolbar(
          )->search_field( id = `SEARCH` width = '17.5rem' search = client->_event( 'ONSEARCH' ) change = client->_event( 'ONSEARCH' ) value  = client->_bind_edit( mv_search_value )
          )->toolbar_spacer(
          )->overflow_toolbar_button( icon = 'sap-icon://sort' type = 'Transparent' press = client->_event( 'ONSORT' ) ).

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
            )->text( 'Price' ).

    
    CLEAR temp5.
    INSERT `${KEY}` INTO TABLE temp5.
    tab->items(
        )->column_list_item( type = 'Navigation'  press = client->_event( val = `ONPRESSMASTER` t_arg = temp5 )
           )->cells(
             )->object_identifier( text = '{PRODUCTNAME}' title =  '{PRODUCTID}' )->get_parent(
             )->text( text = '{SUPPLIERNAME}' )->get_parent(
             )->text( text = '{WIDTH} x {DEPTH} x {HEIGHT} {DIMUNIT}'
             )->object_number( number = '{MEASURE}' unit =  '{UNIT}' state = '{STATE_MEASURE}'
             )->object_number( "number = '{MEASURE}' unit =  '{UNIT}'
                   state = '{STATE_PRICE}'
                   number = `{ parts: [ { path : 'PRICE' } , { path : 'WAERS' } ] } ` ",  type: 'sap.ui.model.type.Currency , formatOptions: { currencyCode : false } } `
              ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD Z2UI5_if_app~main.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      Z2UI5_set_data( ).
      sort( ).
      Z2UI5_on_init( ).
      RETURN.
    ENDIF.

    IF client->get( )-check_on_navigated = abap_true.
      view_display_master( ).
      view_display_detail( ).
      RETURN.
    ENDIF.

    Z2UI5_on_event( ).
  ENDMETHOD.


  METHOD Z2UI5_on_event.
        DATA lo_app_next TYPE REF TO Z2UI5_CL_DEMO_APP_086.
        DATA lt_arg TYPE string_table.
        DATA temp7 LIKE LINE OF lt_arg.
        DATA temp8 LIKE sy-tabix.
        DATA temp9 LIKE LINE OF lt_arg.
        DATA temp10 LIKE sy-tabix.
        DATA temp11 LIKE LINE OF lt_arg.
        DATA temp12 LIKE sy-tabix.
        DATA temp13 LIKE LINE OF lt_arg.
        DATA temp14 LIKE sy-tabix.
*    https://sapui5.hana.ondemand.com/sdk/#/topic/3b9f760da5b64adf8db7f95247879086
    CASE client->get( )-event.
      WHEN 'ONGOTOSUPPLIER' .
        
        CREATE OBJECT lo_app_next TYPE Z2UI5_CL_DEMO_APP_086.
        lo_app_next->ls_detail_supplier = ls_detail_supplier.
        client->nav_app_call( lo_app_next ).
      WHEN 'ONEXITFULLSCREENMODE' .
        lv_layout = 'TwoColumnsMidExpanded'.
        view_display_master( ).
        view_display_detail(  ).
        client->nest_view_model_update( ).
        client->message_toast_display( |Event Close FullScreen Mode | ).
      WHEN 'ONFULLSCREENMODE' .
        lv_layout = 'MidColumnFullScreen'.
        view_display_master( ).
        view_display_detail(  ).
        client->nest_view_model_update( ).
        client->message_toast_display( |Event FullScreen Detail | ).
      WHEN 'ONCLOSEDETAIL' .
        lv_layout = 'OneColumn'.
        view_display_master( ).
        view_display_detail(  ).
        check_detail_active = abap_false.
        client->nest_view_model_update( ).
        client->message_toast_display( |Event Close Detail | ).
      WHEN 'ONPRESSSUPPLIER'.
        
        lt_arg = client->get( )-t_event_arg.
        
        
        temp8 = sy-tabix.
        READ TABLE lt_arg INDEX 1 INTO temp7.
        sy-tabix = temp8.
        IF sy-subrc <> 0.
          ASSERT 1 = 0.
        ENDIF.
        READ TABLE mt_table_supplier WITH KEY suppliername = temp7 INTO ls_detail_supplier.
        
        
        temp10 = sy-tabix.
        READ TABLE lt_arg INDEX 1 INTO temp9.
        sy-tabix = temp10.
        IF sy-subrc <> 0.
          ASSERT 1 = 0.
        ENDIF.
        client->message_toast_display( |Event Press Supplier List Name: { temp9 } | ).
        CREATE OBJECT lo_app_next TYPE Z2UI5_CL_DEMO_APP_086.
        lo_app_next->ls_detail_supplier = ls_detail_supplier.
        client->nav_app_call( lo_app_next ).
      WHEN `ONPRESSMASTER`.
        lt_arg = client->get( )-t_event_arg.
        
        
        temp12 = sy-tabix.
        READ TABLE lt_arg INDEX 1 INTO temp11.
        sy-tabix = temp12.
        IF sy-subrc <> 0.
          ASSERT 1 = 0.
        ENDIF.
        client->message_toast_display( |Event Press Master - Product Id { temp11 } | ).
        
        
        temp14 = sy-tabix.
        READ TABLE lt_arg INDEX 1 INTO temp13.
        sy-tabix = temp14.
        IF sy-subrc <> 0.
          ASSERT 1 = 0.
        ENDIF.
        READ TABLE mt_table WITH KEY key = temp13 INTO ls_detail.
        READ TABLE mt_table_supplier WITH KEY suppliername = ls_detail-suppliername INTO ls_detail_supplier.
        lv_layout = 'TwoColumnsMidExpanded'.
        IF check_detail_active = abap_false.
          view_display_master( ).
        ENDIF.
        view_display_detail(  ).
        client->view_model_update( ).
        client->nest_view_model_update( ).
      WHEN `UPDATE_DETAIL`.
        view_display_detail(  ).
      WHEN 'ONSORT' .
        client->message_toast_display( 'Sort Entries' ).
        sort( ).
        READ TABLE mt_table INDEX 1 INTO ls_detail.
        view_display_master( ).
        view_display_detail(  ).
        client->view_model_update( ).
        client->nest_view_model_update( ).
      WHEN 'ONSEARCH' .
        client->message_toast_display( 'Search Entries' ).
        Z2UI5_set_data( ).
        Z2UI5_set_search( ).
        client->view_model_update( ).
        client->nest_view_model_update( ).
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
    ENDCASE.
  ENDMETHOD.


  METHOD Z2UI5_on_init.
    view_display_master( ) .
*    view_display_detail( ).
  ENDMETHOD.


  METHOD Z2UI5_set_data.
    DATA temp15 TYPE z2ui5_cl_demo_app_085=>ty_t_table.
    DATA temp16 LIKE LINE OF temp15.
    DATA temp17 TYPE z2ui5_cl_demo_app_085=>ty_t_table_supplier.
    DATA temp18 LIKE LINE OF temp17.
    DATA temp19 LIKE LINE OF mt_table.
    DATA temp20 LIKE sy-tabix.
    CLEAR temp15.
    
    temp16-key = '1'.
    temp16-Productid = '1'.
    temp16-productname = 'table'.
    temp16-suppliername = 'Company 1'.
    temp16-Width = '10'.
    temp16-Depth = '20'.
    temp16-Height = '30'.
    temp16-DimUnit = 'CM'.
    temp16-Measure = 100.
    temp16-unit = 'ST'.
    temp16-price = '1000.50'.
    temp16-waers = 'EUR'.
    temp16-state_price = `Success`.
    temp16-state_measure = `Warning`.
    temp16-Pic = 'HT-1010.jpg'.
    temp16-rating = '0'.
    temp16-process = '0'.
    INSERT temp16 INTO TABLE temp15.
    temp16-key = '2'.
    temp16-Productid = '2'.
    temp16-productname = 'chair'.
    temp16-suppliername = 'Company 2'.
    temp16-Width = '10'.
    temp16-Depth = '20'.
    temp16-Height = '30'.
    temp16-DimUnit = 'CM'.
    temp16-Measure = 123.
    temp16-unit = 'ST'.
    temp16-price = '2000.55'.
    temp16-waers = 'USD'.
    temp16-state_price = `Error`.
    temp16-state_measure = `Error`.
    temp16-Pic = 'HT-2001.jpg'.
    temp16-rating = '1'.
    temp16-process = '10'.
    INSERT temp16 INTO TABLE temp15.
    temp16-key = '3'.
    temp16-Productid = '3'.
    temp16-productname = 'sofa'.
    temp16-suppliername = 'Company 3'.
    temp16-Width = '10'.
    temp16-Depth = '20'.
    temp16-Height = '30'.
    temp16-DimUnit = 'CM'.
    temp16-Measure = 700.
    temp16-unit = 'ST'.
    temp16-price = '3000.11'.
    temp16-waers = 'CNY'.
    temp16-state_price = `Success`.
    temp16-state_measure = `Warning`.
    temp16-Pic = 'HT-1251.jpg'.
    temp16-rating = '2'.
    temp16-process = '15'.
    INSERT temp16 INTO TABLE temp15.
    temp16-key = '4'.
    temp16-Productid = '4'.
    temp16-productname = 'computer'.
    temp16-suppliername = 'Company 4'.
    temp16-Width = '10'.
    temp16-Depth = '20'.
    temp16-Height = '30'.
    temp16-DimUnit = 'CM'.
    temp16-Measure = 200.
    temp16-unit = 'ST'.
    temp16-price = '4000.88'.
    temp16-waers = 'USD'.
    temp16-state_price = `Success`.
    temp16-state_measure = `Success`.
    temp16-Pic = 'HT-6100.jpg'.
    temp16-rating = '3'.
    temp16-process = '38'.
    INSERT temp16 INTO TABLE temp15.
    temp16-key = '5'.
    temp16-Productid = '5'.
    temp16-productname = 'printer'.
    temp16-suppliername = 'Company 5'.
    temp16-Width = '10'.
    temp16-Depth = '20'.
    temp16-Height = '30'.
    temp16-DimUnit = 'CM'.
    temp16-Measure = 90.
    temp16-unit = 'ST'.
    temp16-price = '5000.47'.
    temp16-waers = 'EUR'.
    temp16-state_price = `Error`.
    temp16-state_measure = `Warning`.
    temp16-Pic = 'HT-1000.jpg'.
    temp16-rating = '4'.
    temp16-process = '66'.
    INSERT temp16 INTO TABLE temp15.
    temp16-key = '6'.
    temp16-Productid = '6'.
    temp16-productname = 'table2'.
    temp16-suppliername = 'Company 6'.
    temp16-Width = '10'.
    temp16-Depth = '20'.
    temp16-Height = '30'.
    temp16-DimUnit = 'CM'.
    temp16-Measure = 600.
    temp16-unit = 'ST'.
    temp16-price = '6000.33'.
    temp16-waers = 'GBP'.
    temp16-state_price = `Success`.
    temp16-state_measure = `Information`.
    temp16-Pic = 'HT-1137.jpg'.
    temp16-rating = '2'.
    temp16-process = '91'.
    INSERT temp16 INTO TABLE temp15.
    temp16-key = '7'.
    temp16-Productid = '7'.
    temp16-productname = 'table3'.
    temp16-suppliername = 'Company 7'.
    temp16-Width = '10'.
    temp16-Depth = '20'.
    temp16-Height = '30'.
    temp16-DimUnit = 'CM'.
    temp16-Measure = 600.
    temp16-unit = 'ST'.
    temp16-price = '6000.33'.
    temp16-waers = 'GBP'.
    temp16-state_price = `Success`.
    temp16-state_measure = `Warning`.
    temp16-Pic = 'HT-7000.jpg'.
    temp16-rating = '6'.
    temp16-process = '5'.
    INSERT temp16 INTO TABLE temp15.
    temp16-key = '8'.
    temp16-Productid = '8'.
    temp16-productname = 'table4'.
    temp16-suppliername = 'Company 8'.
    temp16-Width = '10'.
    temp16-Depth = '20'.
    temp16-Height = '30'.
    temp16-DimUnit = 'CM'.
    temp16-Measure = 600.
    temp16-unit = 'ST'.
    temp16-price = '6000.33'.
    temp16-waers = 'GBP'.
    temp16-state_price = `Warning`.
    temp16-state_measure = `Error`.
    temp16-Pic = 'HT-9997.jpg'.
    temp16-rating = '0'.
    temp16-process = '75'.
    INSERT temp16 INTO TABLE temp15.
    temp16-key = '9'.
    temp16-Productid = '9'.
    temp16-productname = 'table5'.
    temp16-suppliername = 'Company 9'.
    temp16-Width = '10'.
    temp16-Depth = '20'.
    temp16-Height = '30'.
    temp16-DimUnit = 'CM'.
    temp16-Measure = 600.
    temp16-unit = 'ST'.
    temp16-price = '6000.33'.
    temp16-waers = 'GBP'.
    temp16-state_price = `Information`.
    temp16-state_measure = `Success`.
    temp16-Pic = 'HT-7020.jpg'.
    temp16-rating = '1'.
    temp16-process = '81'.
    INSERT temp16 INTO TABLE temp15.
    temp16-key = '10'.
    temp16-Productid = '10'.
    temp16-productname = 'table6'.
    temp16-suppliername = 'Company 10'.
    temp16-Width = '10'.
    temp16-Depth = '20'.
    temp16-Height = '30'.
    temp16-DimUnit = 'CM'.
    temp16-Measure = 600.
    temp16-unit = 'ST'.
    temp16-price = '6000.33'.
    temp16-waers = 'GBP'.
    temp16-state_price = `Success`.
    temp16-state_measure = `Information`.
    temp16-Pic = 'HT-1023.jpg'.
    temp16-rating = '4'.
    temp16-process = '24'.
    INSERT temp16 INTO TABLE temp15.
    temp16-key = '11'.
    temp16-Productid = '11'.
    temp16-productname = 'table7'.
    temp16-suppliername = 'Company 11'.
    temp16-Width = '10'.
    temp16-Depth = '20'.
    temp16-Height = '30'.
    temp16-DimUnit = 'CM'.
    temp16-Measure = 600.
    temp16-unit = 'ST'.
    temp16-price = '6000.33'.
    temp16-waers = 'GBP'.
    temp16-state_price = `Information`.
    temp16-state_measure = `Success`.
    temp16-Pic = 'HT-1085.jpg'.
    temp16-rating = '5'.
    temp16-process = '46'.
    INSERT temp16 INTO TABLE temp15.
    mt_table = temp15.
*Rungestraße 79-78, 18055 RostockMarktstraße, 03046 CottbusMarktpl. 1, 06108 Halle (Saale)
    
    CLEAR temp17.
    
    temp18-suppliername = 'Company 1'.
    temp18-email = 'company1@sap.com'.
    temp18-phone = '+49 1234567890'.
    temp18-country = 'Germany'.
    temp18-city = 'Dresden'.
    temp18-street = 'Neumarkt'.
    temp18-zipcode = '01067'.
    INSERT temp18 INTO TABLE temp17.
    temp18-suppliername = 'Company 2'.
    temp18-email = 'company2@sap.com'.
    temp18-phone = '+49 1234567890'.
    temp18-country = 'Germany'.
    temp18-city = 'Erfurt'.
    temp18-street = 'Domplatz'.
    temp18-zipcode = '99084'.
    INSERT temp18 INTO TABLE temp17.
    temp18-suppliername = 'Company 3'.
    temp18-email = 'company3@sap.com'.
    temp18-phone = '+49 1234567890'.
    temp18-country = 'Germany'.
    temp18-city = 'Suhl'.
    temp18-street = 'Carl-Fiedler-Straße 58'.
    temp18-zipcode = '98527'.
    INSERT temp18 INTO TABLE temp17.
    temp18-suppliername = 'Company 4'.
    temp18-email = 'company4@sap.com'.
    temp18-phone = '+49 1234567890'.
    temp18-country = 'Germany'.
    temp18-city = 'Hildburgheusen'.
    temp18-street = 'Markt'.
    temp18-zipcode = '98646'.
    INSERT temp18 INTO TABLE temp17.
    temp18-suppliername = 'Company 5'.
    temp18-email = 'company5@sap.com'.
    temp18-phone = '+49 1234567890'.
    temp18-country = 'Germany'.
    temp18-city = 'Sonneberg'.
    temp18-street = 'Beethovenstraße 10'.
    temp18-zipcode = '96515'.
    INSERT temp18 INTO TABLE temp17.
    temp18-suppliername = 'Company 6'.
    temp18-email = 'company6@sap.com'.
    temp18-phone = '+49 1234567890'.
    temp18-country = 'Germany'.
    temp18-city = 'Meiningen'.
    temp18-street = 'Schloßplatz 1'.
    temp18-zipcode = '98617'.
    INSERT temp18 INTO TABLE temp17.
    temp18-suppliername = 'Company 7'.
    temp18-email = 'company7@sap.com'.
    temp18-phone = '+49 1234567890'.
    temp18-country = 'Germany'.
    temp18-city = 'Leipzig'.
    temp18-street = 'Pfaffendorfer Str. 29'.
    temp18-zipcode = '04105'.
    INSERT temp18 INTO TABLE temp17.
    temp18-suppliername = 'Company 8'.
    temp18-email = 'company8@sap.com'.
    temp18-phone = '+49 1234567890'.
    temp18-country = 'Germany'.
    temp18-city = 'Magdeburg'.
    temp18-street = 'Am Dom 1'.
    temp18-zipcode = '39104'.
    INSERT temp18 INTO TABLE temp17.
    temp18-suppliername = 'Company 9'.
    temp18-email = 'company9@sap.com'.
    temp18-phone = '+49 1234567890'.
    temp18-country = 'Germany'.
    temp18-city = 'Schwerin'.
    temp18-street = 'Lennéstraße 1'.
    temp18-zipcode = '19053'.
    INSERT temp18 INTO TABLE temp17.
    temp18-suppliername = 'Company 10'.
    temp18-email = 'company10@sap.com'.
    temp18-phone = '+49 1234567890'.
    temp18-country = 'Germany'.
    temp18-city = 'Rostock'.
    temp18-street = 'Rungestraße 79-78'.
    temp18-zipcode = '18055'.
    INSERT temp18 INTO TABLE temp17.
    temp18-suppliername = 'Company 11'.
    temp18-email = 'company11@sap.com'.
    temp18-phone = '+49 1234567890'.
    temp18-country = 'Germany'.
    temp18-city = 'Cottbus'.
    temp18-street = 'Marktstraße'.
    temp18-zipcode = '03046'.
    INSERT temp18 INTO TABLE temp17.
    temp18-suppliername = 'Company 12'.
    temp18-email = 'company12@sap.com'.
    temp18-phone = '+49 1234567890'.
    temp18-country = 'Germany'.
    temp18-city = 'Halle (Saale)'.
    temp18-street = 'Marktpl. 1'.
    temp18-zipcode = '06108'.
    INSERT temp18 INTO TABLE temp17.
    mt_table_supplier = temp17.

    
    
    temp20 = sy-tabix.
    READ TABLE mt_table INDEX 1 INTO temp19.
    sy-tabix = temp20.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    ls_detail = temp19.
  ENDMETHOD.


  METHOD Z2UI5_set_search.
      DATA temp21 LIKE LINE OF mt_table.
      DATA lr_row LIKE REF TO temp21.
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
ENDCLASS.

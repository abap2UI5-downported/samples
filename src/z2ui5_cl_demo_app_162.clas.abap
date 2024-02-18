CLASS z2ui5_cl_demo_app_162 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

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

    DATA mt_table TYPE ty_t_table.
    DATA mt_sql TYPE z2ui5_cl_util=>ty_t_filter_multi.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
    DATA mv_check_initialized TYPE abap_bool.
    METHODS on_event.
    METHODS view_display.
    METHODS set_data.

  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_162 IMPLEMENTATION.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `BUTTON_START`.
        set_data( ).
        client->view_model_update( ).

      WHEN `PREVIEW_FILTER`.
        client->nav_app_call( z2ui5_cl_popup_get_range_multi=>factory( mt_sql ) ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
    ENDCASE.

  ENDMETHOD.


  METHOD set_data.

    "replace this with a db select here...
    DATA temp1 TYPE z2ui5_cl_demo_app_162=>ty_t_table.
    DATA temp2 LIKE LINE OF temp1.
    CLEAR temp1.
    
    temp2-product = 'table'.
    temp2-create_date = `01.01.2023`.
    temp2-create_by = `Peter`.
    temp2-storage_location = `AREA_001`.
    temp2-quantity = 400.
    INSERT temp2 INTO TABLE temp1.
    temp2-product = 'chair'.
    temp2-create_date = `01.01.2023`.
    temp2-create_by = `Peter`.
    temp2-storage_location = `AREA_001`.
    temp2-quantity = 400.
    INSERT temp2 INTO TABLE temp1.
    temp2-product = 'sofa'.
    temp2-create_date = `01.01.2023`.
    temp2-create_by = `Peter`.
    temp2-storage_location = `AREA_001`.
    temp2-quantity = 400.
    INSERT temp2 INTO TABLE temp1.
    temp2-product = 'computer'.
    temp2-create_date = `01.01.2023`.
    temp2-create_by = `Peter`.
    temp2-storage_location = `AREA_001`.
    temp2-quantity = 400.
    INSERT temp2 INTO TABLE temp1.
    temp2-product = 'oven'.
    temp2-create_date = `01.01.2023`.
    temp2-create_by = `Peter`.
    temp2-storage_location = `AREA_001`.
    temp2-quantity = 400.
    INSERT temp2 INTO TABLE temp1.
    temp2-product = 'table2'.
    temp2-create_date = `01.01.2023`.
    temp2-create_by = `Peter`.
    temp2-storage_location = `AREA_001`.
    temp2-quantity = 400.
    INSERT temp2 INTO TABLE temp1.
    mt_table = temp1.

*    DATA lt_result LIKE mt_table.
*    "put the range in the where clause of your abap sql command
*    "here we use an internal table instead
*    LOOP AT mt_sql INTO DATA(ls_tab).
*
*      "do filtering here..
*
*    ENDLOOP.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA temp1 TYPE xsdboolean.
    DATA vbox TYPE REF TO z2ui5_cl_xml_view.
    DATA tab TYPE REF TO z2ui5_cl_xml_view.
    DATA lo_columns TYPE REF TO z2ui5_cl_xml_view.
    DATA lo_cells TYPE REF TO z2ui5_cl_xml_view.
    view = z2ui5_cl_xml_view=>factory( ).

    
    temp1 = boolc( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ).
    view = view->shell( )->page( id = `page_main`
             title          = 'abap2UI5 - Select-Options'
             navbuttonpress = client->_event( 'BACK' )
             shownavbutton = temp1
         )->header_content(
             )->link(
                 text = 'Source_Code' target = '_blank' href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
        )->get_parent( ).

    
    vbox = view->vbox( ).

    
    tab = vbox->table(
        items = client->_bind( val = mt_table )
           )->header_toolbar(
             )->overflow_toolbar(
                 )->toolbar_spacer(
                 )->button( text = `Filter` press = client->_event( `PREVIEW_FILTER` ) icon = `sap-icon://filter`
           )->button(  text = `Go` press = client->_event( `BUTTON_START` ) type = `Emphasized`
            )->get_parent( )->get_parent( ).

    
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

  ENDMETHOD.


  METHOD z2ui5_if_app~main.
          DATA temp3 TYPE REF TO z2ui5_cl_popup_get_range_multi.
          DATA lo_value_help LIKE temp3.

    me->client = client.

    IF mv_check_initialized = abap_false.
      mv_check_initialized = abap_true.
      mt_sql = z2ui5_cl_util=>filter_get_multi_by_data( mt_table ).
      view_display( ).
      RETURN.
    ENDIF.

    IF client->get( )-check_on_navigated = abap_true.
      TRY.
          
          temp3 ?= client->get_app( client->get( )-s_draft-id_prev_app ).
          
          lo_value_help = temp3.
          IF lo_value_help->result( )-check_confirmed = abap_true.
            mt_sql = lo_value_help->result( )-t_sql.
            set_data( ).
            client->view_model_update( ).
          ENDIF.
        CATCH cx_root.
      ENDTRY.
      RETURN.
    ENDIF.

    IF client->get( )-event IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.

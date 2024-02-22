CLASS z2ui5_cl_demo_app_174 DEFINITION PUBLIC.

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

    DATA ms_layout  TYPE z2ui5_cl_popup_layout_v2=>ty_s_layout.

PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
    DATA mv_check_initialized TYPE abap_bool.
    METHODS on_event.
    METHODS view_display.
    METHODS set_data.
    METHODS on_after_layout.
    METHODS on_event_layout.
    METHODS create_layout.

  PRIVATE SECTION.

ENDCLASS.


CLASS z2ui5_cl_demo_app_174 IMPLEMENTATION.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
      WHEN OTHERS.
        on_event_layout( ).
    ENDCASE.

  ENDMETHOD.


  METHOD set_data.

    "replace this with a db select here...
    DATA temp1 TYPE z2ui5_cl_demo_app_174=>ty_t_table.
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
    temp2-product = 'sofa'.
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

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA temp1 TYPE xsdboolean.
    DATA table TYPE REF TO z2ui5_cl_xml_view.
    DATA headder TYPE REF TO z2ui5_cl_xml_view.
    DATA columns TYPE REF TO z2ui5_cl_xml_view.
    DATA temp3 LIKE LINE OF ms_layout-t_layout.
    DATA layout LIKE REF TO temp3.
      DATA lv_index LIKE sy-tabix.
    DATA temp4 TYPE string_table.
    DATA cells TYPE REF TO z2ui5_cl_xml_view.
    view = z2ui5_cl_xml_view=>factory( ).

    
    temp1 = boolc( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ).
    view = view->shell( )->page( id = `page_main`
             title          = 'abap2UI5 - Popup Layout'
             navbuttonpress = client->_event( 'BACK' )
             shownavbutton = temp1
         ).

    
    table = view->table(
      growing    = 'true'
      width      = 'auto'
      items      = client->_bind( val = mt_table )
      headertext = 'Table'
    ).

    
    headder =  table->header_toolbar(
               )->overflow_toolbar(
                 )->title(   text =  'Table'
                 )->toolbar_spacer(
                 ).

    headder = z2ui5_cl_popup_layout_v2=>render_layout_function( xml    = headder
                                                                client = client ).

    
    columns = table->columns( ).


    
    
    LOOP AT ms_layout-t_layout REFERENCE INTO layout.
      
      lv_index = sy-tabix.

      columns->column(
        visible         = client->_bind( val = layout->visible tab = ms_layout-t_layout tab_index = lv_index )
        halign          = client->_bind( val = layout->halign tab = ms_layout-t_layout tab_index = lv_index )
        importance      = client->_bind( val = layout->importance tab = ms_layout-t_layout tab_index = lv_index )
        mergeduplicates = client->_bind( val = layout->merge tab = ms_layout-t_layout tab_index = lv_index )
        minscreenwidth  = client->_bind( val = layout->width tab = ms_layout-t_layout tab_index = lv_index )
                          )->text( layout->fname ).

    ENDLOOP.


    
    CLEAR temp4.
    INSERT `${ROW_ID}` INTO TABLE temp4.
    
    cells = columns->get_parent( )->items(
                                       )->column_list_item( valign = 'Middle'
                                                            type   = 'Navigation'
                                                            press  = client->_event( val   = 'ROW_SELECT'
                                                                                     t_arg = temp4 )
                                       )->cells( ).

    LOOP AT ms_layout-t_layout REFERENCE INTO layout.

      cells->object_identifier( text = '{' && layout->fname && '}' ).

    ENDLOOP.

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF mv_check_initialized = abap_false.
      mv_check_initialized = abap_true.

      set_data( ).

      create_layout( ).

      view_display( ).

      RETURN.

    ENDIF.

    on_after_layout( ).

    IF client->get( )-event IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.

  METHOD create_layout.

    DATA: tab         TYPE REF TO data.
    DATA: lr_tabdescr TYPE REF TO cl_abap_tabledescr.
    FIELD-SYMBOLS: <fs_tab> TYPE ANY TABLE.
    DATA class TYPE abap_abstypename.
    DATA temp6 TYPE string.

    lr_tabdescr ?= cl_abap_tabledescr=>describe_by_data( mt_table ).
    CREATE DATA tab TYPE HANDLE lr_tabdescr.
    ASSIGN tab->* TO <fs_tab>.
    <fs_tab> = mt_table.

    
    class   = cl_abap_classdescr=>get_class_name( me ).

    
    temp6 = class.
    ms_layout = z2ui5_cl_popup_layout_v2=>init_layout(
      tab   = tab
      classname = temp6 ).

  ENDMETHOD.


  METHOD on_after_layout.
          DATA temp7 TYPE REF TO z2ui5_cl_popup_layout_v2.
          DATA app LIKE temp7.

    IF client->get( )-check_on_navigated = abap_true.

      TRY.
          
          temp7 ?= client->get_app( client->get( )-s_draft-id_prev_app ).
          
          app = temp7.
          ms_layout = app->ms_layout.
          view_display( ).

        CATCH cx_root.
      ENDTRY.

    ENDIF.

  ENDMETHOD.


  METHOD on_event_layout.

    client = z2ui5_cl_popup_layout_v2=>on_event_layout(
      client = client
      layout = ms_layout ).

  ENDMETHOD.

ENDCLASS.

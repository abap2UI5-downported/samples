CLASS z2ui5_cl_demo_app_200 DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mt_table  TYPE REF TO data.
    DATA ms_layout TYPE z2ui5_cl_pop_layout_v2=>ty_s_layout.

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

  PROTECTED SECTION.
    DATA client            TYPE REF TO z2ui5_if_client.
    DATA check_initialized TYPE abap_bool.

    METHODS on_init.
    METHODS on_event.
    METHODS render_main.
    METHODS get_data.
    METHODS init_layout.
    METHODS on_after_navigation.

  PRIVATE SECTION.

ENDCLASS.


CLASS z2ui5_cl_demo_app_200 IMPLEMENTATION.

  METHOD on_event.

    CASE client->get( )-event.

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

      WHEN OTHERS.

        client = z2ui5_cl_pop_layout_v2=>on_event_layout( client = client
                                                          layout = ms_layout ).

    ENDCASE.
  ENDMETHOD.

  METHOD on_init.

    get_data( ).

    init_layout( ).

    render_main( ).
  ENDMETHOD.

  METHOD render_main.

    FIELD-SYMBOLS <tab> TYPE data.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA temp2 TYPE xsdboolean.
    DATA table TYPE REF TO z2ui5_cl_xml_view.
    DATA headder TYPE REF TO z2ui5_cl_xml_view.
    DATA columns TYPE REF TO z2ui5_cl_xml_view.
    DATA temp1 LIKE LINE OF ms_layout-t_layout.
    DATA layout LIKE REF TO temp1.
      DATA lv_index LIKE sy-tabix.
    DATA cells TYPE REF TO z2ui5_cl_xml_view.
        DATA sub_col TYPE string.
        DATA index TYPE i.
        DATA subcol LIKE LINE OF layout->t_sub_col.
          DATA line TYPE z2ui5_cl_pop_layout_v2=>ty_s_positions.
    view = z2ui5_cl_xml_view=>factory( )->shell( ).

    
    
    temp2 = boolc( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ).
    page = view->page( title          = 'Layout'
                             navbuttonpress = client->_event( 'BACK' )
                             shownavbutton  = temp2
                             class          = 'sapUiContentPadding' ).

    page->header_content( )->scroll_container( height   = '70%'
                                               vertical = abap_true ).

    ASSIGN mt_table->* TO <tab>.

    
    table = page->table( growing = 'true'
                               width   = 'auto'
                               items   = client->_bind_edit( val = <tab> ) ).

    " TODO: variable is assigned but never used (ABAP cleaner)
    
    headder = table->header_toolbar(
               )->overflow_toolbar(
                 )->toolbar_spacer( ).

    headder = z2ui5_cl_pop_layout_v2=>render_layout_function( xml    = headder
                                                              client = client ).

    
    columns = table->columns( ).

    
    
    LOOP AT ms_layout-t_layout REFERENCE INTO layout.
      
      lv_index = sy-tabix.

      columns->column( visible         = client->_bind( val       = layout->visible
                                                        tab       = ms_layout-t_layout
                                                        tab_index = lv_index )
                       halign          = client->_bind( val       = layout->halign
                                                        tab       = ms_layout-t_layout
                                                        tab_index = lv_index )
                       importance      = client->_bind( val       = layout->importance
                                                        tab       = ms_layout-t_layout
                                                        tab_index = lv_index )
                       mergeduplicates = client->_bind( val       = layout->merge
                                                        tab       = ms_layout-t_layout
                                                        tab_index = lv_index )
                       width           = client->_bind( val       = layout->width
                                                        tab       = ms_layout-t_layout
                                                        tab_index = lv_index )

       )->text( layout->tlabel ).

    ENDLOOP.

    
    cells = columns->get_parent( )->items(
                                       )->column_list_item( valign = 'Middle'
                                                            type   = 'Navigation'

                                       )->cells( ).

    " Subcolumns require new rendering....
    LOOP AT ms_layout-t_layout REFERENCE INTO layout.

      IF layout->t_sub_col IS NOT INITIAL.

        
        sub_col = ``.
        
        index = 0.
        
        LOOP AT layout->t_sub_col INTO subcol.

          index = index + 1.

          
          READ TABLE ms_layout-t_layout INTO line WITH KEY fname = subcol-fname.

          IF index = 1.
            sub_col = |{ line-tlabel }: \{{ subcol-fname }\}|.
          ELSE.
            sub_col = |{ sub_col }{ cl_abap_char_utilities=>cr_lf } { line-tlabel }: \{{ subcol-fname }\}|.
          ENDIF.

        ENDLOOP.

        cells->object_identifier( title = |\{{ layout->fname }\}|
                                  text  = sub_col ).

      ELSE.
        cells->object_identifier( text = |\{{ layout->fname }\}| ).
      ENDIF.
    ENDLOOP.

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

  METHOD z2ui5_if_app~main.
    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      on_init( ).
    ENDIF.

    on_event( ).

    on_after_navigation( ).

  ENDMETHOD.

  METHOD get_data.

    FIELD-SYMBOLS <table> TYPE STANDARD TABLE.
    DATA temp2 TYPE ty_t_table.
    DATA temp3 LIKE LINE OF temp2.

    CREATE DATA mt_table TYPE ty_t_table.
    ASSIGN mt_table->* TO <table>.

    
    CLEAR temp2.
    
    temp3-create_date = `01.01.2023`.
    temp3-create_by = `Peter`.
    temp3-storage_location = `AREA_001`.
    temp3-quantity = 400.
    temp3-product = 'table'.
    INSERT temp3 INTO TABLE temp2.
    temp3-product = 'chair'.
    INSERT temp3 INTO TABLE temp2.
    temp3-product = 'sofa'.
    INSERT temp3 INTO TABLE temp2.
    temp3-product = 'computer'.
    INSERT temp3 INTO TABLE temp2.
    temp3-product = 'oven'.
    INSERT temp3 INTO TABLE temp2.
    temp3-product = 'table2'.
    INSERT temp3 INTO TABLE temp2.
    <table> = temp2.

  ENDMETHOD.

  METHOD init_layout.
    DATA class TYPE abap_abstypename.
    DATA temp4 TYPE z2ui5_cl_pop_layout_v2=>handle.
    DATA temp1 TYPE z2ui5_cl_pop_layout_v2=>handle.

    IF ms_layout IS NOT INITIAL.
      RETURN.
    ENDIF.

    
    class = cl_abap_classdescr=>get_class_name( me ).
    SHIFT class LEFT DELETING LEADING '\CLASS='.

    
    temp4 = class.
    
    temp1 = 'z2ui5_t_01'.
    ms_layout = z2ui5_cl_pop_layout_v2=>init_layout( control  = z2ui5_cl_pop_layout_v2=>m_table
                                                     data     = mt_table
                                                     handle01 = temp4
                                                     handle02 = temp1
                                                     handle03 = ''
                                                     handle04 = '' ).

  ENDMETHOD.

  METHOD on_after_navigation.
        DATA temp5 TYPE REF TO z2ui5_cl_pop_layout_v2.
        DATA app LIKE temp5.

    IF client->get( )-check_on_navigated = abap_false.
      RETURN.
    ENDIF.

    TRY.

        
        temp5 ?= client->get_app( client->get( )-s_draft-id_prev_app ).
        
        app = temp5.

        ms_layout = app->ms_layout.

        IF app->mv_rerender = abap_true.
          " subcolumns need rerendering to work ..
          render_main( ).
        ELSE.
          "  for all other changes in Layout View Model Update is enough.
          client->view_model_update( ).
        ENDIF.
      CATCH cx_root.
    ENDTRY.

  ENDMETHOD.

ENDCLASS.

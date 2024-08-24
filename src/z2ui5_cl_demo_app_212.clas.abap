CLASS z2ui5_cl_demo_app_212 DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mv_view_display      TYPE abap_bool.
    DATA mv_view_model_update TYPE abap_bool.
    DATA mo_parent_view       TYPE REF TO z2ui5_cl_xml_view.
    DATA mt_table             TYPE REF TO data.
    DATA mt_table_tmp         TYPE REF TO data.
    DATA ms_table_row         TYPE REF TO data.
    DATA ms_layout            TYPE z2ui5_cl_pop_layout_v2=>ty_s_layout.

    METHODS set_app_data
      IMPORTING
        !table TYPE string.

  PROTECTED SECTION.
    DATA mv_table             TYPE string.
    DATA mt_comp              TYPE abap_component_tab.
    DATA mt_dfies             TYPE z2ui5_cl_stmpncfctn_api=>ty_t_dfies.
    DATA client            TYPE REF TO z2ui5_if_client.
    DATA check_initialized TYPE abap_bool.

    METHODS on_init.

    METHODS on_event.

    METHODS render_main.

    METHODS get_data.

    METHODS get_comp
      RETURNING
        VALUE(result) TYPE abap_component_tab.

    METHODS init_layout.

    METHODS on_after_navigation.

    METHODS row_select.

    METHODS prefill_popup_values
      IMPORTING
        !index TYPE string.

    METHODS render_popup.

  PRIVATE SECTION.
    METHODS get_dfies.

ENDCLASS.


CLASS z2ui5_cl_demo_app_212 IMPLEMENTATION.

  METHOD on_event.

    CASE client->get( )-event.

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

      WHEN 'ROW_SELECT'.

        row_select( ).

      WHEN OTHERS.

        client = z2ui5_cl_pop_layout_v2=>on_event_layout( client = client
                                                          layout = ms_layout ).

    ENDCASE.
  ENDMETHOD.

  METHOD row_select.

    DATA lt_arg TYPE string_table.
    DATA ls_arg TYPE string.
    lt_arg = client->get( )-t_event_arg.
    
    READ TABLE lt_arg INTO ls_arg INDEX 1.

    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    prefill_popup_values( ls_arg ).

    render_popup( ).
  ENDMETHOD.

  METHOD prefill_popup_values.

    FIELD-SYMBOLS <tab>       TYPE STANDARD TABLE.
    FIELD-SYMBOLS <table_row> TYPE any.
    FIELD-SYMBOLS <row> TYPE any.
    DATA dfies LIKE LINE OF mt_dfies.
      FIELD-SYMBOLS <value_tab> TYPE any.
      FIELD-SYMBOLS <value_struc> TYPE any.

    ASSIGN mt_table->* TO <tab>.

    
    READ TABLE <tab> INDEX index ASSIGNING <row>.

    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    
    LOOP AT mt_dfies INTO dfies.

      
      ASSIGN COMPONENT dfies-fieldname OF STRUCTURE <row> TO <value_tab>.
      ASSIGN ms_table_row->* TO <table_row>.
      
      ASSIGN COMPONENT dfies-fieldname OF STRUCTURE <table_row> TO <value_struc>.

      IF <value_tab> IS ASSIGNED AND <value_struc> IS ASSIGNED.
        <value_struc> = <value_tab>.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.

  METHOD get_dfies.

    mt_dfies = z2ui5_cl_util=>rtti_get_t_dfies_by_table_name( mv_table ).

  ENDMETHOD.

  METHOD render_popup.

    FIELD-SYMBOLS <row> TYPE any.

    DATA popup TYPE REF TO z2ui5_cl_xml_view.
    DATA content TYPE REF TO z2ui5_cl_xml_view.
    DATA temp1 LIKE LINE OF mt_dfies.
    DATA dfies LIKE REF TO temp1.
      FIELD-SYMBOLS <val> TYPE any.
      DATA text TYPE z2ui5_cl_pop_layout_v2=>ty_s_positions-tlabel.
      DATA temp2 LIKE LINE OF ms_layout-t_layout.
      DATA temp3 LIKE sy-tabix.
    popup = z2ui5_cl_xml_view=>factory_popup( ).

    
    content = popup->dialog( contentwidth = '60%'
          )->simple_form( layout   = 'ResponsiveGridLayout'
                          editable = abap_true
          )->content( ns = 'form' ).

    " Gehe über alle Comps wenn wir im Edit sind dann sind keyfelder nicht eingabebereit.
    
    
    LOOP AT mt_dfies REFERENCE INTO dfies.

      ASSIGN ms_table_row->* TO <row>.
      
      ASSIGN COMPONENT dfies->fieldname OF STRUCTURE <row> TO <val>.
      IF <val> IS NOT ASSIGNED.
        CONTINUE.
      ENDIF.

      
      
      
      temp3 = sy-tabix.
      READ TABLE ms_layout-t_layout WITH KEY fname = dfies->fieldname INTO temp2.
      sy-tabix = temp3.
      IF sy-subrc <> 0.
        ASSERT 1 = 0.
      ENDIF.
      text = temp2-tlabel.

      content->label(  text   = text ).

      content->input( value       = client->_bind_edit( <val> )
                    enabled       = abap_false
                    showvaluehelp = abap_false ).

    ENDLOOP.

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.

  METHOD on_init.
    get_data( ).

    get_dfies( ).

    init_layout( ).

    render_main( ).
  ENDMETHOD.

  METHOD init_layout.
    DATA class TYPE abap_abstypename.
    DATA temp2 TYPE z2ui5_cl_pop_layout_v2=>handle.
    DATA temp4 TYPE z2ui5_cl_pop_layout_v2=>handle.

    IF ms_layout IS NOT INITIAL.
      RETURN.
    ENDIF.

    
    class = cl_abap_classdescr=>get_class_name( me ).
    SHIFT class LEFT DELETING LEADING '\CLASS='.

    
    temp2 = class.
    
    temp4 = mv_table.
    ms_layout = z2ui5_cl_pop_layout_v2=>init_layout( control  = z2ui5_cl_pop_layout_v2=>m_table
                                                     data     = mt_table
                                                     handle01 = temp2
                                                     handle02 = temp4
                                                     handle03 = ''
                                                     handle04 = '' ).

  ENDMETHOD.

  METHOD render_main.

    FIELD-SYMBOLS <tab> TYPE data.
      DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA table TYPE REF TO z2ui5_cl_xml_view.
    DATA headder TYPE REF TO z2ui5_cl_xml_view.
    DATA columns TYPE REF TO z2ui5_cl_xml_view.
    DATA temp3 LIKE LINE OF ms_layout-t_layout.
    DATA layout LIKE REF TO temp3.
      DATA lv_index LIKE sy-tabix.
    DATA temp4 TYPE string_table.
    DATA cells TYPE REF TO z2ui5_cl_xml_view.
        DATA sub_col TYPE string.
        DATA index TYPE i.
        DATA subcol LIKE LINE OF layout->t_sub_col.
          DATA line TYPE z2ui5_cl_pop_layout_v2=>ty_s_positions.

    IF mo_parent_view IS INITIAL.
      
      page = z2ui5_cl_xml_view=>factory( ).
    ELSE.
      page = mo_parent_view->get( `Page` ).
    ENDIF.

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

    
    CLEAR temp4.
    INSERT `${ROW_ID}` INTO TABLE temp4.
    
    cells = columns->get_parent( )->items(
                                       )->column_list_item(
                                           valign = 'Middle'
                                           type   = 'Navigation'
                                           press  = client->_event( val   = 'ROW_SELECT'
                                                                    t_arg = temp4 )
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

    IF mo_parent_view IS INITIAL.

      client->view_display( page->get_root( )->xml_get( ) ).

    ELSE.

      mv_view_display = abap_true.

    ENDIF.

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

  METHOD set_app_data.

    mv_table = table.

  ENDMETHOD.

  METHOD get_data.

    FIELD-SYMBOLS <table>     TYPE STANDARD TABLE.
    FIELD-SYMBOLS <table_tmp> TYPE STANDARD TABLE.
        DATA new_struct_desc TYPE REF TO cl_abap_structdescr.
        DATA new_table_desc TYPE REF TO cl_abap_tabledescr.

    mt_comp = get_comp( ).

    TRY.

        
        new_struct_desc = cl_abap_structdescr=>create( mt_comp ).

        
        new_table_desc = cl_abap_tabledescr=>create( p_line_type  = new_struct_desc
                                                           p_table_kind = cl_abap_tabledescr=>tablekind_std ).

        CREATE DATA mt_table     TYPE HANDLE new_table_desc.
        CREATE DATA mt_table_tmp TYPE HANDLE new_table_desc.
        CREATE DATA ms_table_row TYPE HANDLE new_struct_desc.

        ASSIGN mt_table->* TO <table>.

        SELECT *
          FROM (mv_table)
          INTO CORRESPONDING FIELDS OF TABLE <table>
          UP TO 100 ROWS.

      CATCH cx_root.

    ENDTRY.

    ASSIGN mt_table_tmp->* TO <table_tmp>.

    <table_tmp> = <table>.

  ENDMETHOD.

  METHOD get_comp.

    DATA index TYPE int4.
            DATA typedesc TYPE REF TO cl_abap_typedescr.
            DATA temp6 TYPE REF TO cl_abap_structdescr.
            DATA structdesc LIKE temp6.
            DATA comp TYPE abap_component_tab.
            DATA com LIKE LINE OF comp.
        DATA temp7 TYPE cl_abap_structdescr=>component_table.
        DATA temp8 LIKE LINE OF temp7.
        DATA temp5 TYPE REF TO cl_abap_datadescr.
        DATA component LIKE temp7.

    TRY.
        TRY.

            
            cl_abap_typedescr=>describe_by_name( EXPORTING  p_name         = mv_table
                                                 RECEIVING  p_descr_ref    = typedesc
                                                 EXCEPTIONS type_not_found = 1
                                                            OTHERS         = 2 ).

            
            temp6 ?= typedesc.
            
            structdesc = temp6.
            
            comp = structdesc->get_components( ).

            
            LOOP AT comp INTO com.
              IF com-as_include = abap_false.
                APPEND com TO result.
              ENDIF.
            ENDLOOP.

          CATCH cx_root.

        ENDTRY.

        
        CLEAR temp7.
        
        temp8-name = 'ROW_ID'.
        
        temp5 ?= cl_abap_datadescr=>describe_by_data( index ).
        temp8-type = temp5.
        INSERT temp8 INTO TABLE temp7.
        
        component = temp7.

        APPEND LINES OF component TO result.

      CATCH cx_root.
    ENDTRY.
  ENDMETHOD.

  METHOD on_after_navigation.
        DATA temp9 TYPE REF TO z2ui5_cl_pop_layout_v2.
        DATA app LIKE temp9.

    IF client->get( )-check_on_navigated = abap_false.
      RETURN.
    ENDIF.

    TRY.

        
        temp9 ?= client->get_app( client->get( )-s_draft-id_prev_app ).
        
        app = temp9.

        ms_layout = app->ms_layout.

        IF app->mv_rerender = abap_true.
          " subcolumns need rerendering to work ..
          render_main( ).
          mv_view_display = abap_TRUE.
        ELSE.
          "  for all other changes in Layout View Model Update is enough.
          mv_view_model_update = abap_true.

        ENDIF.
      CATCH cx_root.
    ENDTRY.

  ENDMETHOD.

ENDCLASS.

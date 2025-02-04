CLASS z2ui5_cl_demo_app_190 DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mv_view_display TYPE abap_bool.
    DATA mo_parent_view  TYPE REF TO z2ui5_cl_xml_view.

    DATA mv_table        TYPE string.
    DATA mt_table        TYPE REF TO data.
    DATA mt_table_tmp    TYPE REF TO data.

    DATA mt_comp         TYPE abap_component_tab.
    DATA ms_fixval       TYPE REF TO data.

    METHODS set_app_data
      IMPORTING !count TYPE string
                !table TYPE string.

  PROTECTED SECTION.
    DATA client            TYPE REF TO z2ui5_if_client.
    DATA check_initialized TYPE abap_bool.

    METHODS on_init.
    METHODS on_event.

    METHODS render_main.

  PRIVATE SECTION.
    METHODS get_data.

    METHODS get_comp
      RETURNING VALUE(result) TYPE abap_component_tab.

    METHODS get_fixval.
ENDCLASS.

CLASS z2ui5_cl_demo_app_190 IMPLEMENTATION.

  METHOD on_event.

    FIELD-SYMBOLS <row> TYPE any.

    CASE client->get( )-event.

      WHEN 'BACK'.

        client->nav_app_leave( ).

    ENDCASE.
  ENDMETHOD.

  METHOD on_init.
    get_data( ).
    render_main( ).
  ENDMETHOD.

  METHOD render_main.
    FIELD-SYMBOLS <tab> TYPE data.
      DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA table TYPE REF TO z2ui5_cl_xml_view.
    DATA columns TYPE REF TO z2ui5_cl_xml_view.
    DATA comp LIKE LINE OF mt_comp.
    DATA cells TYPE REF TO z2ui5_cl_xml_view.

    IF mo_parent_view IS INITIAL.
      
      page = z2ui5_cl_xml_view=>factory( ).
    ELSE.
      page = mo_parent_view->get( `Page` ).
    ENDIF.


    ASSIGN mt_table->* TO <tab>.

    
    table = page->table( growing = 'true'
                               width   = 'auto'
                               items   = client->_bind( <tab> )
*                               headertext = mv_table
                               ).

    
    columns = table->columns( ).

    
    LOOP AT mt_comp INTO comp.

      columns->column( )->text( comp-name ).

    ENDLOOP.

    
    cells = columns->get_parent( )->items(
                                       )->column_list_item( valign = 'Middle'
                                                            type   = 'Navigation'
                                       )->cells( ).

    LOOP AT mt_comp INTO comp.
      cells->object_identifier( text = '{' && comp-name && '}' ).
    ENDLOOP.

    page->footer( )->overflow_toolbar(
                         )->toolbar_spacer(
                         )->button( text  = 'Save'
                                    press = client->_event( 'BUTTON' )
                                    type  = 'Success' ).

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
  ENDMETHOD.

  METHOD set_app_data.
    " TODO: parameter COUNT is never used (ABAP cleaner)

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


        ASSIGN mt_table->* TO <table>.

        SELECT *
          FROM (mv_table)
          INTO CORRESPONDING FIELDS OF TABLE <table>
          UP TO 100 ROWS.

      CATCH cx_root.

    ENDTRY.

    ASSIGN mt_table_tmp->* TO <table_tmp>.

    <table_tmp> = <table>.
    get_fixval( ).

  ENDMETHOD.

  METHOD get_fixval.

    TYPES:
      BEGIN OF fixvalue,
        low        TYPE string,
        high       TYPE string,
        option     TYPE string,
        ddlanguage TYPE string,
        ddtext     TYPE string,
      END OF fixvalue.
    TYPES fixvalues TYPE STANDARD TABLE OF fixvalue WITH DEFAULT KEY.

    DATA comp        TYPE cl_abap_structdescr=>component_table.
    DATA structdescr TYPE REF TO cl_abap_structdescr.
    DATA lt_fixval   TYPE fixvalues.

    DATA temp1 LIKE LINE OF mt_comp.
    DATA dfies LIKE REF TO temp1.
      DATA temp2 TYPE cl_abap_structdescr=>component_table.
      DATA temp3 LIKE LINE OF temp2.
      DATA temp4 TYPE REF TO cl_abap_datadescr.
    LOOP AT mt_comp REFERENCE INTO dfies.

      
      CLEAR temp2.
      temp2 = comp.
      
      temp3-name = dfies->name.
      
      temp4 ?= cl_abap_datadescr=>describe_by_data( lt_fixval ).
      temp3-type = temp4.
      INSERT temp3 INTO TABLE temp2.
      comp = temp2.
    ENDLOOP.

    structdescr = cl_abap_structdescr=>create( comp ).

    CREATE DATA ms_fixval TYPE HANDLE structdescr.


  ENDMETHOD.

  METHOD get_comp.
    DATA index TYPE int4.
            DATA typedesc TYPE REF TO cl_abap_typedescr.
            DATA temp4 TYPE REF TO cl_abap_structdescr.
            DATA structdesc LIKE temp4.
            DATA comp TYPE abap_component_tab.
            DATA com LIKE LINE OF comp.
        DATA temp5 TYPE cl_abap_structdescr=>component_table.
        DATA temp6 LIKE LINE OF temp5.
        DATA temp7 TYPE REF TO cl_abap_datadescr.
        DATA component LIKE temp5.
    TRY.



        TRY.

            
            cl_abap_typedescr=>describe_by_name( EXPORTING  p_name         = mv_table
                                                 RECEIVING p_descr_ref     = typedesc
                                                 EXCEPTIONS type_not_found = 1
                                                            OTHERS         = 2 ).

            
            temp4 ?= typedesc.
            
            structdesc = temp4.
            
            comp = structdesc->get_components( ).

            
            LOOP AT comp INTO com.
              IF com-as_include = abap_false.
                APPEND com TO result.
              ENDIF.
            ENDLOOP.

          CATCH cx_root.

        ENDTRY.

        
        CLEAR temp5.
        
        temp6-name = 'ROW_ID'.
        
        temp7 ?= cl_abap_datadescr=>describe_by_data( index ).
        temp6-type = temp7.
        INSERT temp6 INTO TABLE temp5.
        
        component = temp5.

        APPEND LINES OF component TO result.

      CATCH cx_root.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.

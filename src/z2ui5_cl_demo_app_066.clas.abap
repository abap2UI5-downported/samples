CLASS z2ui5_cl_demo_app_066 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app .

    DATA mv_input_master TYPE string.
    DATA mv_input_detail TYPE string.
    TYPES:
      BEGIN OF ts_tree_row_base,
        object TYPE string,
        col2   TYPE string,
        col3   TYPE string,
        col4   TYPE string,
      END OF ts_tree_row_base .
    TYPES:
      BEGIN OF ts_tree_level3.
        INCLUDE TYPE ts_tree_row_base.
      TYPES END OF ts_tree_level3 .
    TYPES
      tt_tree_level3 TYPE STANDARD TABLE OF ts_tree_level3 WITH KEY object .
    TYPES
      BEGIN OF ts_tree_level2.
    INCLUDE TYPE ts_tree_row_base.
    TYPES   categories TYPE tt_tree_level3.
    TYPES END OF ts_tree_level2.

    TYPES
      tt_tree_level2 TYPE STANDARD TABLE OF ts_tree_level2 WITH KEY object.
    TYPES:
      BEGIN OF ts_tree_level1.
        INCLUDE TYPE ts_tree_row_base.
        TYPES   categories TYPE tt_tree_level2.
    TYPES END OF ts_tree_level1 .
    TYPES
      tt_tree_level1 TYPE STANDARD TABLE OF ts_tree_level1 WITH KEY object .

    DATA mt_tree TYPE tt_tree_level1.
    DATA check_initialized TYPE abap_bool .

    DATA mv_check_enabled_01 TYPE abap_bool VALUE abap_true.
    DATA mv_check_enabled_02 TYPE abap_bool.

  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display_master.
    METHODS view_display_detail.

  PRIVATE SECTION.

ENDCLASS.



CLASS z2ui5_cl_demo_app_066 IMPLEMENTATION.


  METHOD view_display_detail.

    DATA lo_view_nested TYPE REF TO z2ui5_cl_xml_view.
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    lo_view_nested = z2ui5_cl_xml_view=>factory( ).

    
    page = lo_view_nested->page( title = `Nested View` ).

    page->button( text = 'event' press = client->_event( 'UPDATE_DETAIL' )
    )->input( id = `inputNest`
      value = `{path:'` && client->_bind_edit( val = mv_input_detail view = client->cs_view-nested path = abap_true ) && `',type:'sap.ui.model.type.String', constraints: { maxLength: 3 } }` ).

    page->button(
          text = 'button 01'
*            type    = 'Transparent'
          press   = client->_event( `NEST_TEST` )
          enabled = client->_bind( mv_check_enabled_01 ) ).

    page->button(
        text = 'button 02'
*            type    = 'Transparent'
        press   = client->_event( `NEST_TEST` )
        enabled = client->_bind( mv_check_enabled_02 )
       ).

    client->nest_view_display(
      val            = lo_view_nested->stringify( )
      id             = `test`
      method_insert  = 'addMidColumnPage'
      method_destroy = 'removeAllMidColumnPages'
    ).

  ENDMETHOD.


  METHOD view_display_master.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA col_layout TYPE REF TO z2ui5_cl_xml_view.
    DATA lr_master TYPE REF TO z2ui5_cl_xml_view.
    DATA tab TYPE REF TO z2ui5_cl_xml_view.
    view = z2ui5_cl_xml_view=>factory( ).
    
    page = view->shell(
        )->page(
           title          = 'abap2UI5 - Master Detail Page with Nested View'
           navbuttonpress = client->_event( 'BACK' )
             shownavbutton = abap_true ).

    page->header_content(
             )->link( text = 'Demo'    target = '_blank'    href = `https://twitter.com/abap2UI5/status/1628701535222865922`
             )->link(
         )->get_parent( ).

    
    col_layout =  page->flexible_column_layout( layout = 'TwoColumnsBeginExpanded' id ='test' ).

    
    lr_master = col_layout->begin_column_pages( ).

    client->_bind( mt_tree ).
    
    tab = lr_master->vbox( )->tree_table(
      rows = `{path:'/MT_TREE', parameters: {arrayNames:['CATEGORIES']}}` ).
    tab->tree_columns(
    )->tree_column( label = 'Object'
        )->tree_template(
        )->text( text = '{OBJECT}')->get_parent( )->get_parent(
        )->tree_column( label = 'Column2'
        )->tree_template(
        )->text( text = '{COL2}')->get_parent( )->get_parent(
        )->tree_column( label = 'Column3'
        )->tree_template(
        )->text( text = '{COL3}')->get_parent( )->get_parent(
        )->tree_column( label = 'Column4'
        )->tree_template(
        )->text( text = '{COL4}').

    tab->get_parent( )->label( text = `input master` )->input( id = `inputMain`
     value = `{path:'` && client->_bind_edit( val = mv_input_master view = client->cs_view-main path = abap_true ) && `',type:'sap.ui.model.type.String', constraints: { maxLength: 3 } }`
     )->button( press = client->_event( `TEST` ) text = `button` ).


    client->view_display( page->stringify( ) ).



  ENDMETHOD.


  METHOD z2ui5_if_app~main.
        DATA temp1 TYPE z2ui5_cl_demo_app_066=>tt_tree_level1.
        DATA temp2 LIKE LINE OF temp1.
        DATA temp3 TYPE z2ui5_cl_demo_app_066=>tt_tree_level2.
        DATA temp4 LIKE LINE OF temp3.
        DATA temp9 TYPE z2ui5_cl_demo_app_066=>tt_tree_level3.
        DATA temp10 LIKE LINE OF temp9.
        DATA temp5 TYPE z2ui5_cl_demo_app_066=>tt_tree_level2.
        DATA temp6 LIKE LINE OF temp5.
        DATA temp7 TYPE z2ui5_cl_demo_app_066=>tt_tree_level2.
        DATA temp8 LIKE LINE OF temp7.
        DATA temp11 TYPE xsdboolean.
        DATA temp12 TYPE xsdboolean.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

        view_display_master(  ).
        view_display_detail(  ).

        
        CLEAR temp1.
        
        temp2-object = '1'.
        
        CLEAR temp3.
        
        temp4-object = '1.1'.
        
        CLEAR temp9.
        
        temp10-object = '1.1.1'.
        INSERT temp10 INTO TABLE temp9.
        temp10-object = '1.1.2'.
        INSERT temp10 INTO TABLE temp9.
        temp4-categories = temp9.
        INSERT temp4 INTO TABLE temp3.
        temp4-object = '1.2'.
        INSERT temp4 INTO TABLE temp3.
        temp2-categories = temp3.
        INSERT temp2 INTO TABLE temp1.
        temp2-object = '2'.
        
        CLEAR temp5.
        
        temp6-object = '2.1'.
        INSERT temp6 INTO TABLE temp5.
        temp6-object = '2.2'.
        INSERT temp6 INTO TABLE temp5.
        temp2-categories = temp5.
        INSERT temp2 INTO TABLE temp1.
        temp2-object = '3'.
        
        CLEAR temp7.
        
        temp8-object = '3.1'.
        INSERT temp8 INTO TABLE temp7.
        temp8-object = '3.2'.
        INSERT temp8 INTO TABLE temp7.
        temp2-categories = temp7.
        INSERT temp2 INTO TABLE temp1.
        mt_tree = temp1.

    ENDIF.

    CASE client->get( )-event.


      WHEN `UPDATE_DETAIL`.
        view_display_detail(  ).

      WHEN 'TEST'.
        client->message_toast_display( `output: ` && mv_input_master ).

      WHEN `NEST_TEST`.

        
        temp11 = boolc( mv_check_enabled_01 = abap_false ).
        mv_check_enabled_01 = temp11.
        
        temp12 = boolc( mv_check_enabled_01 = abap_false ).
        mv_check_enabled_02 = temp12.
        client->message_toast_display( mv_input_detail ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
    ENDCASE.

  ENDMETHOD.
ENDCLASS.

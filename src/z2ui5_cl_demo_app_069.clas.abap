CLASS Z2UI5_CL_DEMO_APP_069 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES Z2UI5_if_app .

    TYPES:
      BEGIN OF ty_t_tree3,
        is_selected TYPE abap_bool,
        text        TYPE string,
      END OF ty_t_tree3,
      BEGIN OF ty_t_tree2,
        is_selected TYPE abap_bool,
        text        TYPE string,
        nodes       TYPE STANDARD TABLE OF ty_t_tree3 WITH DEFAULT KEY,
      END OF ty_t_tree2,
      BEGIN OF ty_t_tree1,
        is_selected TYPE abap_bool,
        text        TYPE string,
        nodes       TYPE STANDARD TABLE OF ty_t_tree2 WITH DEFAULT KEY,
      END OF ty_t_tree1,
      ty_t_tree TYPE STANDARD TABLE OF ty_t_tree1 WITH DEFAULT KEY.

    DATA mt_tree TYPE ty_t_tree.

    DATA check_initialized TYPE abap_bool .

    DATA mv_check_enabled_01 TYPE abap_bool VALUE abap_true.
    DATA mv_check_enabled_02 TYPE abap_bool.

  PROTECTED SECTION.

    DATA client TYPE REF TO Z2UI5_if_client.

    METHODS view_display_master.
    METHODS view_display_app_01.
    METHODS view_display_app_02.

  PRIVATE SECTION.

ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_069 IMPLEMENTATION.


  METHOD view_display_app_01.

    DATA lo_view_nested TYPE REF TO z2ui5_cl_xml_view.
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    lo_view_nested = z2ui5_cl_xml_view=>factory( ).

    
    page = lo_view_nested->page( title = `APP_01` ).

    page->button( text = 'Update this view' press = client->_event( 'UPDATE_DETAIL' ) ).

    client->nest_view_display(
      val            = lo_view_nested->stringify( )
      id             = `test`
      method_insert  = 'addMidColumnPage'
      method_destroy = 'removeAllMidColumnPages'
    ).

  ENDMETHOD.


  METHOD view_display_app_02.

    DATA lo_view_nested TYPE REF TO z2ui5_cl_xml_view.
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    lo_view_nested = z2ui5_cl_xml_view=>factory( ).

    
    page = lo_view_nested->page( title = `APP_02` ).

    page->button( text = 'Update this view' press = client->_event( 'UPDATE_DETAIL' )
    )->input( ).

    page->button(
          text = 'button 01'
          press   = client->_event( `NEST_TEST` )
          enabled = client->_bind( mv_check_enabled_01 ) ).

    page->button(
          text = 'button 01'
          press   = client->_event( `NEST_TEST` )
          enabled = client->_bind( mv_check_enabled_01 ) ).

    page->button(
        text = 'button 02'
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
    DATA lr_master TYPE REF TO z2ui5_cl_xml_view.
    DATA temp1 TYPE string_table.
    view = z2ui5_cl_xml_view=>factory( ).

    
    page = view->shell( )->page(
          title          = 'abap2UI5 - Master-Detail View with Nested Views'
          navbuttonpress = client->_event( 'BACK' )
            shownavbutton = abap_true
          )->header_content(
             )->link( text = 'Demo'    target = '_blank'    href = `https://twitter.com/abap2UI5/status/1680907265891618817`
             )->link(  
         )->get_parent( ).

    
    lr_master = page->flexible_column_layout( layout = 'TwoColumnsBeginExpanded' id ='test' )->begin_column_pages( ).

    
    CLEAR temp1.
    INSERT `${TEXT}` INTO TABLE temp1.
    lr_master->tree( items = client->_bind( mt_tree ) )->items(
        )->standard_tree_item(
            type = 'Active'
            title = '{TEXT}' press = client->_event( val = `EVENT_ITEM`
            t_arg = temp1 ) ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD Z2UI5_if_app~main.
      DATA temp3 TYPE z2ui5_cl_demo_app_069=>ty_t_tree.
      DATA temp4 LIKE LINE OF temp3.
      DATA temp1 TYPE z2ui5_cl_demo_app_069=>ty_t_tree1-nodes.
      DATA temp2 LIKE LINE OF temp1.
      DATA temp9 TYPE z2ui5_cl_demo_app_069=>ty_t_tree2-nodes.
      DATA temp10 LIKE LINE OF temp9.
      DATA temp7 TYPE z2ui5_cl_demo_app_069=>ty_t_tree1-nodes.
      DATA temp8 LIKE LINE OF temp7.
      DATA temp11 TYPE z2ui5_cl_demo_app_069=>ty_t_tree2-nodes.
      DATA temp12 LIKE LINE OF temp11.
      DATA temp13 TYPE z2ui5_cl_demo_app_069=>ty_t_tree2-nodes.
      DATA temp14 LIKE LINE OF temp13.
        DATA lt_arg TYPE string_table.
        DATA temp5 LIKE LINE OF lt_arg.
        DATA temp6 LIKE sy-tabix.
        DATA temp15 TYPE xsdboolean.
        DATA temp16 TYPE xsdboolean.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

      
      CLEAR temp3.
      
      temp4-text = 'Apps'.
      
      CLEAR temp1.
      
      temp2-text = 'Frontend'.
      
      CLEAR temp9.
      
      temp10-text = 'App_001'.
      INSERT temp10 INTO TABLE temp9.
      temp10-text = 'App_002'.
      INSERT temp10 INTO TABLE temp9.
      temp2-nodes = temp9.
      INSERT temp2 INTO TABLE temp1.
      temp4-nodes = temp1.
      INSERT temp4 INTO TABLE temp3.
      temp4-text = 'Configuration'.
      
      CLEAR temp7.
      
      temp8-text = 'User Interface'.
      
      CLEAR temp11.
      
      temp12-text = 'Theme'.
      INSERT temp12 INTO TABLE temp11.
      temp12-text = 'Library'.
      INSERT temp12 INTO TABLE temp11.
      temp8-nodes = temp11.
      INSERT temp8 INTO TABLE temp7.
      temp8-text = 'Database'.
      
      CLEAR temp13.
      
      temp14-text = 'HANA'.
      INSERT temp14 INTO TABLE temp13.
      temp14-text = 'ANY DB'.
      INSERT temp14 INTO TABLE temp13.
      temp8-nodes = temp13.
      INSERT temp8 INTO TABLE temp7.
      temp4-nodes = temp7.
      INSERT temp4 INTO TABLE temp3.
      mt_tree = temp3.

      view_display_master(  ).

    ENDIF.

    CASE client->get( )-event.

      WHEN `UPDATE_DETAIL`.
        view_display_app_01(  ).

      WHEN `EVENT_ITEM`.
        
        lt_arg = client->get( )-t_event_arg.
        
        
        temp6 = sy-tabix.
        READ TABLE lt_arg INDEX 1 INTO temp5.
        sy-tabix = temp6.
        IF sy-subrc <> 0.
          ASSERT 1 = 0.
        ENDIF.
        CASE temp5.
          WHEN 'App_001'.
            view_display_app_01(  ).
          WHEN 'App_002'.
            view_display_app_02(  ).
        ENDCASE.

      WHEN `NEST_TEST`.
        
        temp15 = boolc( mv_check_enabled_01 = abap_false ).
        mv_check_enabled_01 = temp15.
        
        temp16 = boolc( mv_check_enabled_01 = abap_false ).
        mv_check_enabled_02 = temp16.

        client->nest_view_model_update( ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
    ENDCASE.

  ENDMETHOD.
ENDCLASS.

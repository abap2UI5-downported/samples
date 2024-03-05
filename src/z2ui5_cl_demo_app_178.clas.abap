CLASS z2ui5_cl_demo_app_178 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_prodh_node_level3,
        is_selected TYPE abap_bool,
        text        TYPE string,
        prodh       TYPE string,
      END OF ty_prodh_node_level3 .
    TYPES:
      BEGIN OF ty_prodh_node_level2,
        is_selected TYPE abap_bool,
        text        TYPE string,
        prodh       TYPE string,
        expanded    TYPE abap_bool,
        nodes       TYPE STANDARD TABLE OF ty_prodh_node_level3 WITH DEFAULT KEY,
      END OF ty_prodh_node_level2 .
    TYPES:
      BEGIN OF ty_prodh_node_level1,
        is_selected TYPE abap_bool,
        text        TYPE string,
        prodh       TYPE string,
        expanded    TYPE abap_bool,
        nodes       TYPE STANDARD TABLE OF ty_prodh_node_level2 WITH DEFAULT KEY,
      END OF ty_prodh_node_level1 .
    TYPES:
      ty_prodh_nodes TYPE STANDARD TABLE OF ty_prodh_node_level1 WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_prodh_node_level2_ex,
        expanded TYPE abap_bool,
      END OF ty_prodh_node_level2_ex .
    TYPES:
      BEGIN OF ty_prodh_node_level1_ex,
        expanded TYPE abap_bool,
        nodes    TYPE STANDARD TABLE OF ty_prodh_node_level2_ex WITH DEFAULT KEY,
      END OF ty_prodh_node_level1_ex .
    TYPES:
      ty_prodh_nodes_ex TYPE STANDARD TABLE OF ty_prodh_node_level1_ex WITH DEFAULT KEY .

    DATA prodh_nodes TYPE ty_prodh_nodes .
    DATA prodh_nodes_ex TYPE ty_prodh_nodes_ex .
    DATA is_initialized TYPE abap_bool .

    METHODS ui5_display_view .
  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client.
    METHODS ui5_initialize.
    METHODS ui5_display_popup_tree_select.

  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_178 IMPLEMENTATION.


  METHOD ui5_display_popup_tree_select.
    DATA dialog TYPE REF TO z2ui5_cl_xml_view.
    DATA temp1 TYPE string_table.

    client->_bind_edit( prodh_nodes_ex ).

    
    dialog = z2ui5_cl_xml_view=>factory_popup(
        )->dialog( title = 'Choose Product here...' contentheight = '50%' contentwidth  = '50%' ).

    
    CLEAR temp1.
    INSERT `${$parameters>/itemContext/sPath}` INTO TABLE temp1.
    INSERT `${$parameters>/expanded}` INTO TABLE temp1.
    dialog->tree(
        mode  = 'SingleSelectMaster'
        items = client->_bind_edit( prodh_nodes )
*        toggleopenstate = client->_event( val = 'TOGGLE_STATE' t_arg = VALUE #( ( `${$parameters>/itemIndex}` ) ( `${$parameters>/expanded}` ) ) )
        toggleopenstate = client->_event( val = 'TOGGLE_STATE' t_arg = temp1 )
        )->items(
            )->standard_tree_item( selected = '{IS_SELECTED}' title = '{TEXT}' ).

    dialog->buttons(
        )->button( text  = 'Continue'
               icon  = `sap-icon://accept`
               type  = `Accept`
               press = client->_event( 'CONTINUE' )
        )->button( text  = 'Cancel'
               icon  = `sap-icon://decline`
               type  = `Reject`
               press = client->_event( 'CANCEL' ) ).

    client->popup_display( dialog->stringify( ) ).

  ENDMETHOD.


  METHOD ui5_display_view.

    DATA page TYPE REF TO z2ui5_cl_xml_view.
    page = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = 'abap2UI5 - Popup Tree select Entry'
            navbuttonpress = client->_event( 'BACK' )
              shownavbutton = abap_true ).

    client->view_display( page->button( text = 'Open Popup here...' press = client->_event( 'POPUP_TREE' ) )->stringify( ) ).

  ENDMETHOD.


  METHOD ui5_initialize.
    DATA temp3 TYPE z2ui5_cl_demo_app_178=>ty_prodh_nodes.
    DATA temp4 LIKE LINE OF temp3.
    DATA temp1 TYPE z2ui5_cl_demo_app_178=>ty_prodh_node_level1-nodes.
    DATA temp2 LIKE LINE OF temp1.
    DATA temp13 TYPE z2ui5_cl_demo_app_178=>ty_prodh_node_level2-nodes.
    DATA temp14 LIKE LINE OF temp13.
    DATA temp7 TYPE z2ui5_cl_demo_app_178=>ty_prodh_node_level1-nodes.
    DATA temp8 LIKE LINE OF temp7.
    DATA temp15 TYPE z2ui5_cl_demo_app_178=>ty_prodh_node_level2-nodes.
    DATA temp16 LIKE LINE OF temp15.
    DATA temp5 TYPE z2ui5_cl_demo_app_178=>ty_prodh_nodes_ex.
    DATA temp6 LIKE LINE OF temp5.
    DATA temp9 TYPE z2ui5_cl_demo_app_178=>ty_prodh_node_level1_ex-nodes.
    DATA temp10 LIKE LINE OF temp9.
    DATA temp11 TYPE z2ui5_cl_demo_app_178=>ty_prodh_node_level1_ex-nodes.
    DATA temp12 LIKE LINE OF temp11.
    CLEAR temp3.
    
    temp4-text = 'Machines'.
    temp4-prodh = '00100'.
    
    CLEAR temp1.
    
    temp2-text = 'Pumps'.
    temp2-prodh = '0010000100'.
    
    CLEAR temp13.
    
    temp14-text = 'Pump 001'.
    temp14-prodh = '001000010000000100'.
    INSERT temp14 INTO TABLE temp13.
    temp14-text = 'Pump 002'.
    temp14-prodh = '001000010000000105'.
    INSERT temp14 INTO TABLE temp13.
    temp2-nodes = temp13.
    INSERT temp2 INTO TABLE temp1.
    temp4-nodes = temp1.
    INSERT temp4 INTO TABLE temp3.
    temp4-text = 'Paints'.
    temp4-prodh = '00110'.
    
    CLEAR temp7.
    
    temp8-text = 'Gloss paints'.
    temp8-prodh = '0011000105'.
    
    CLEAR temp15.
    
    temp16-text = 'Paint 001'.
    temp16-prodh = '001100010500000100'.
    INSERT temp16 INTO TABLE temp15.
    temp16-text = 'Paint 002'.
    temp16-prodh = '001100010500000105'.
    INSERT temp16 INTO TABLE temp15.
    temp8-nodes = temp15.
    INSERT temp8 INTO TABLE temp7.
    temp4-nodes = temp7.
    INSERT temp4 INTO TABLE temp3.
    prodh_nodes =
    temp3.
    
    CLEAR temp5.
    
    temp6-expanded = abap_false.
    
    CLEAR temp9.
    
    temp10-expanded = abap_false.
    INSERT temp10 INTO TABLE temp9.
    temp6-nodes = temp9.
    INSERT temp6 INTO TABLE temp5.
    temp6-expanded = abap_false.
    
    CLEAR temp11.
    
    temp12-expanded = abap_false.
    INSERT temp12 INTO TABLE temp11.
    temp6-nodes = temp11.
    INSERT temp6 INTO TABLE temp5.
    prodh_nodes_ex =
      temp5.
  ENDMETHOD.


  METHOD z2ui5_if_app~main.
        DATA lt_arg TYPE string_table.
        DATA row LIKE LINE OF lt_arg.
        DATA temp13 LIKE LINE OF lt_arg.
        DATA temp14 LIKE sy-tabix.
        DATA expanded LIKE LINE OF lt_arg.
        DATA temp15 LIKE LINE OF lt_arg.
        DATA temp16 LIKE sy-tabix.
        DATA lt_indxs TYPE STANDARD TABLE OF string WITH DEFAULT KEY.
          DATA lv_node LIKE LINE OF lt_indxs.
          DATA temp17 LIKE LINE OF lt_indxs.
          DATA temp18 LIKE sy-tabix.
          DATA lv_child_node LIKE LINE OF lt_indxs.
          DATA temp19 LIKE LINE OF lt_indxs.
          DATA temp20 LIKE sy-tabix.
          FIELD-SYMBOLS <fss> TYPE abap_bool.
          DATA temp21 LIKE LINE OF prodh_nodes_ex.
          DATA temp22 LIKE sy-tabix.
          DATA temp25 LIKE LINE OF temp21-nodes.
          DATA temp26 LIKE sy-tabix.
          DATA temp7 LIKE LINE OF lt_indxs.
          DATA temp8 LIKE sy-tabix.
          FIELD-SYMBOLS <fss1> TYPE abap_bool.
          DATA temp23 LIKE LINE OF prodh_nodes_ex.
          DATA temp24 LIKE sy-tabix.

    me->client = client.

    IF is_initialized = abap_false.
      is_initialized = abap_true.
      ui5_initialize( ).
      ui5_display_view( ).
    ENDIF.

    CASE client->get( )-event.

      WHEN 'TOGGLE_STATE'.
        
        lt_arg = client->get( )-t_event_arg.
        
        
        
        temp14 = sy-tabix.
        READ TABLE lt_arg INDEX 1 INTO temp13.
        sy-tabix = temp14.
        IF sy-subrc <> 0.
          ASSERT 1 = 0.
        ENDIF.
        row = temp13.
        
        
        
        temp16 = sy-tabix.
        READ TABLE lt_arg INDEX 2 INTO temp15.
        sy-tabix = temp16.
        IF sy-subrc <> 0.
          ASSERT 1 = 0.
        ENDIF.
        expanded = temp15.

        
        SPLIT row AT '/' INTO TABLE lt_indxs.

        IF row CS '/NODES/'.
          
          
          
          temp18 = sy-tabix.
          READ TABLE lt_indxs INDEX 4 INTO temp17.
          sy-tabix = temp18.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          lv_node = temp17.
          
          
          
          temp20 = sy-tabix.
          READ TABLE lt_indxs INDEX 6 INTO temp19.
          sy-tabix = temp20.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          lv_child_node = temp19.
          
          
          
          temp22 = sy-tabix.
          READ TABLE prodh_nodes_ex INDEX lv_node + 1 INTO temp21.
          sy-tabix = temp22.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          
          
          temp26 = sy-tabix.
          READ TABLE temp21-nodes INDEX lv_child_node + 1 INTO temp25.
          sy-tabix = temp26.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          ASSIGN temp25-expanded TO <fss>.
          <fss> = expanded.
        ELSE.
          
          
          temp8 = sy-tabix.
          READ TABLE lt_indxs INDEX 4 INTO temp7.
          sy-tabix = temp8.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          lv_node = temp7.
          
          
          
          temp24 = sy-tabix.
          READ TABLE prodh_nodes_ex INDEX lv_node + 1 INTO temp23.
          sy-tabix = temp24.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          ASSIGN temp23-expanded TO <fss1>.
          <fss1> = expanded.
        ENDIF.

        client->popup_model_update( ).


      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

      WHEN 'POPUP_TREE'.
        ui5_display_popup_tree_select( ).

      WHEN 'CONTINUE'.
        client->popup_destroy( ).
        client->message_box_display( `Selected entry is set in the backend` ).

      WHEN 'CANCEL'.
        client->popup_destroy( ).

    ENDCASE.

  ENDMETHOD.
ENDCLASS.

CLASS z2ui5_cl_demo_app_180 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

*    TYPES:
*      BEGIN OF ty_prodh_node_level3,
*        is_selected TYPE abap_bool,
*        text        TYPE string,
*        prodh       TYPE string,
*      END OF ty_prodh_node_level3 .
*    TYPES:
*      BEGIN OF ty_prodh_node_level2,
*        is_selected TYPE abap_bool,
*        text        TYPE string,
*        prodh       TYPE string,
*        expanded    TYPE abap_bool,
*        nodes       TYPE STANDARD TABLE OF ty_prodh_node_level3 WITH DEFAULT KEY,
*      END OF ty_prodh_node_level2 .
*    TYPES:
*      BEGIN OF ty_prodh_node_level1,
*        is_selected TYPE abap_bool,
*        text        TYPE string,
*        prodh       TYPE string,
*        expanded    TYPE abap_bool,
*        nodes       TYPE STANDARD TABLE OF ty_prodh_node_level2 WITH DEFAULT KEY,
*      END OF ty_prodh_node_level1 .
*    TYPES:
*      ty_prodh_nodes TYPE STANDARD TABLE OF ty_prodh_node_level1 WITH DEFAULT KEY .
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

*    DATA prodh_nodes TYPE ty_prodh_nodes .
    DATA prodh_nodes_ex TYPE ty_prodh_nodes_ex .
    DATA is_initialized TYPE abap_bool .

    METHODS ui5_display_view .
  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client.
    METHODS ui5_initialize.
*    METHODS ui5_display_popup_tree_select.

  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_180 IMPLEMENTATION.


  METHOD ui5_display_view.
    DATA page TYPE REF TO z2ui5_cl_xml_view.

    client->_bind_edit( prodh_nodes_ex ).

    
    page = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = 'abap2UI5 - Popup Tree select Entry'
            navbuttonpress = client->_event( 'BACK' )
              shownavbutton = abap_true ).

    page->button( text = 'Server Roundtrip 1' press = client->_event( 'POST_01' ) ).
    page->button( text = 'Server Roundtrip 2' press = client->_event( 'POST_02' ) ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD ui5_initialize.
*    prodh_nodes =
*    VALUE #( ( text = 'Machines'
*               prodh = '00100'
*               nodes = VALUE #( ( text = 'Pumps'
*                                  prodh = '0010000100'
*                                  nodes = VALUE #( ( text = 'Pump 001'
*                                                     prodh = '001000010000000100' )
*                                                   ( text = 'Pump 002'
*                                                     prodh = '001000010000000105' )
*                                          )
*                       ) )
*             )
*             ( text = 'Paints'
*               prodh = '00110'
*               nodes = VALUE #( ( text = 'Gloss paints'
*                                  prodh = '0011000105'
*                                  nodes = VALUE #( ( text = 'Paint 001'
*                                                     prodh = '001100010500000100' )
*                                                   ( text = 'Paint 002'
*                                                     prodh = '001100010500000105' )
*                                          )
*                       ) )
*             )
*    ).
    DATA temp1 TYPE z2ui5_cl_demo_app_180=>ty_prodh_nodes_ex.
    DATA temp2 LIKE LINE OF temp1.
    DATA temp3 TYPE z2ui5_cl_demo_app_180=>ty_prodh_node_level1_ex-nodes.
    DATA temp4 LIKE LINE OF temp3.
    DATA temp5 TYPE z2ui5_cl_demo_app_180=>ty_prodh_node_level1_ex-nodes.
    DATA temp6 LIKE LINE OF temp5.
    CLEAR temp1.
    
    temp2-expanded = abap_false.
    
    CLEAR temp3.
    
    temp4-expanded = abap_false.
    INSERT temp4 INTO TABLE temp3.
    temp2-nodes = temp3.
    INSERT temp2 INTO TABLE temp1.
    temp2-expanded = abap_false.
    
    CLEAR temp5.
    
    temp6-expanded = abap_false.
    INSERT temp6 INTO TABLE temp5.
    temp2-nodes = temp5.
    INSERT temp2 INTO TABLE temp1.
    prodh_nodes_ex =
      temp1.
  ENDMETHOD.


  METHOD z2ui5_if_app~main.
        FIELD-SYMBOLS <temp3> LIKE LINE OF prodh_nodes_ex.
        DATA temp4 LIKE sy-tabix.
        FIELD-SYMBOLS <temp5> LIKE LINE OF prodh_nodes_ex.
        DATA temp6 LIKE sy-tabix.
        FIELD-SYMBOLS <temp7> LIKE LINE OF <temp5>-nodes.
        DATA temp8 LIKE sy-tabix.

    me->client = client.

    IF is_initialized = abap_false.
      is_initialized = abap_true.
      ui5_initialize( ).
      ui5_display_view( ).
    ENDIF.

    CASE client->get( )-event.

      WHEN 'POST_01'.
        
        
        temp4 = sy-tabix.
        READ TABLE prodh_nodes_ex INDEX 1 ASSIGNING <temp3>.
        sy-tabix = temp4.
        IF sy-subrc <> 0.
          ASSERT 1 = 0.
        ENDIF.
        <temp3>-expanded = abap_true.
        client->view_model_update( ).

      WHEN 'POST_02'.
        
        
        temp6 = sy-tabix.
        READ TABLE prodh_nodes_ex INDEX 1 ASSIGNING <temp5>.
        sy-tabix = temp6.
        IF sy-subrc <> 0.
          ASSERT 1 = 0.
        ENDIF.
        
        
        temp8 = sy-tabix.
        READ TABLE <temp5>-nodes INDEX 1 ASSIGNING <temp7>.
        sy-tabix = temp8.
        IF sy-subrc <> 0.
          ASSERT 1 = 0.
        ENDIF.
        <temp7>-expanded = abap_true.
        client->view_model_update( ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

    ENDCASE.

  ENDMETHOD.
ENDCLASS.

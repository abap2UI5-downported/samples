CLASS z2ui5_cl_demo_app_118 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_serializable_object .
    INTERFACES z2ui5_if_app .

    TYPES: BEGIN OF s_row,
             id    TYPE i,
             descr TYPE string,
             adate TYPE d,
             atime TYPE t,
           END OF s_row.
    TYPES: t_rows TYPE STANDARD TABLE OF s_row WITH DEFAULT KEY.

    DATA: problematic_rows TYPE t_rows.
    DATA: these_are_fine_rows TYPE t_rows.

    DATA: check_initialized TYPE abap_bool.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_118 IMPLEMENTATION.
  METHOD z2ui5_if_app~main.
      DATA temp1 TYPE z2ui5_cl_demo_app_118=>t_rows.
      DATA temp2 LIKE LINE OF temp1.
      DATA temp3 TYPE z2ui5_cl_demo_app_118=>t_rows.
      DATA temp4 LIKE LINE OF temp3.
    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA tab_ko TYPE REF TO z2ui5_cl_xml_view.
    DATA tab_ok TYPE REF TO z2ui5_cl_xml_view.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      
      CLEAR temp1.
      
      temp2-id = 1.
      temp2-descr = 'First row'.
      temp2-adate = sy-datum.
      temp2-atime = sy-uzeit.
      INSERT temp2 INTO TABLE temp1.
      temp2-id = 2.
      temp2-descr = 'Second row'.
      temp2-adate = sy-datum.
      temp2-atime = sy-uzeit.
      INSERT temp2 INTO TABLE temp1.
      temp2-id = 3.
      temp2-descr = 'Third row'.
      temp2-adate = ''.
      temp2-atime = ''.
      INSERT temp2 INTO TABLE temp1.
      temp2-id = 4.
      temp2-descr = 'Fourth row'.
      temp2-adate = ''.
      temp2-atime = ''.
      INSERT temp2 INTO TABLE temp1.
      temp2-id = 5.
      temp2-descr = 'Fifth row'.
      temp2-adate = sy-datum.
      temp2-atime = sy-uzeit.
      INSERT temp2 INTO TABLE temp1.
      problematic_rows = temp1.

      
      CLEAR temp3.
      
      temp4-id = 1.
      temp4-descr = 'First row'.
      temp4-adate = sy-datum.
      temp4-atime = sy-uzeit.
      INSERT temp4 INTO TABLE temp3.
      temp4-id = 2.
      temp4-descr = 'Second row'.
      temp4-adate = 0.
      temp4-atime = 0.
      INSERT temp4 INTO TABLE temp3.
      temp4-id = 3.
      temp4-descr = 'Third row'.
      temp4-adate = 0.
      temp4-atime = 0.
      INSERT temp4 INTO TABLE temp3.
      temp4-id = 4.
      temp4-descr = 'Fourth row'.
      temp4-adate = 0.
      temp4-atime = 0.
      INSERT temp4 INTO TABLE temp3.
      temp4-id = 5.
      temp4-descr = 'Fifth row'.
      temp4-adate = sy-datum.
      temp4-atime = sy-uzeit.
      INSERT temp4 INTO TABLE temp3.
      these_are_fine_rows = temp3.

    ENDIF.


    
    view = z2ui5_cl_xml_view=>factory( ).

    
    page = view->_z2ui5( )->title( 'ABAP2UI5 Weird behavior showcase' )->shell(
        )->page(
            title          = 'ABAP2UI5 Weird behavior showcase'
            navbuttonpress = client->_event( 'BACK' )
            showheader     = abap_true ).

    
    tab_ko = page->table(
                        mode = 'MultiSelect'
                        items = client->_bind_edit( problematic_rows ) ).

    tab_ko->header_toolbar(
            )->toolbar(
                )->title( |This table has the weird behavior|
                )->toolbar_spacer(
                )->button(
                    text = |Go|
                    icon = 'sap-icon://blur'
                    press = client->_event( 'ON_BTN_GO' ) ).

    tab_ko->columns(
            )->column(  )->text( 'ID' )->get_parent(
            )->column( )->text( 'Description' )->get_parent(
            )->column( )->text( 'Date ' )->get_parent(
            )->column( )->text( 'Time' ).

    tab_ko->items(
         )->column_list_item(
             )->cells(
                 )->object_identifier( title = '{ID}' text = '{DESCR}' )->get_parent(
                 )->text( '{ADATE}'
                 )->text( '{ATIME}' ).


    
    tab_ok = page->table(
                        mode = 'MultiSelect'
                        items = client->_bind_edit( these_are_fine_rows ) ).

    tab_ok->header_toolbar(
            )->toolbar(
                )->title( |This table is fine| ).

    tab_ok->columns(
            )->column(  )->text( 'ID' )->get_parent(
            )->column( )->text( 'Description' )->get_parent(
            )->column( )->text( 'Date ' )->get_parent(
            )->column( )->text( 'Time' ).

    tab_ok->items(
         )->column_list_item(
             )->cells(
                 )->object_identifier( title = '{ID}' text = '{DESCR}' )->get_parent(
                 )->text( '{ADATE}'
                 )->text( '{ATIME}' ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.

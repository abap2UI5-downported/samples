CLASS Z2UI5_CL_DEMO_APP_054 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES Z2UI5_if_app.

    TYPES:
      BEGIN OF ty_row,
        count    TYPE i,
        value    TYPE string,
        descr    TYPE string,
        icon     TYPE string,
        info     TYPE string,
        checkbox TYPE abap_bool,
      END OF ty_row.

    DATA t_tab TYPE STANDARD TABLE OF ty_row WITH DEFAULT KEY.


    METHODS refresh_data.


protected section.
private section.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_054 IMPLEMENTATION.


  METHOD refresh_data.
      DATA temp1 TYPE ty_row.
      DATA temp2 TYPE z2ui5_cl_demo_app_054=>ty_row-info.
      DATA ls_row LIKE temp1.

    DO 100 TIMES.
      
      CLEAR temp1.
      temp1-count = sy-index.
      temp1-value = 'red'.
      
      IF sy-index < 50.
        temp2 = 'completed'.
      ELSE.
        temp2 = 'uncompleted'.
      ENDIF.
      temp1-info = temp2.
      temp1-descr = 'this is a description'.
      temp1-checkbox = abap_true.
      
      ls_row = temp1.
      INSERT ls_row INTO TABLE t_tab.
    ENDDO.

  ENDMETHOD.


  METHOD Z2UI5_if_app~main.

*    IF check_initialized = abap_false.
*      check_initialized = abap_true.
*      refresh_data( ).
*    ENDIF.
*
*    clear next.
*
*    CASE client->get( )-event.
*
*      WHEN 'BUTTON_POST'.
*        client->popup_message_box( 'button post was pressed' ).
*      WHEN 'BACK'.
*        client->nav_app_leave( ).
*
*    ENDCASE.
*
*  IF mv_check_popover = abap_false.
*
*    DATA(page) = Z2UI5_cl_xml_view=>factory( )->shell(
*        )->page(
*            title          = 'abap2UI5 - Scroll Container with Table and Toolbar'
*            navbuttonpress = client->_event( 'BACK' )
*            shownavbutton = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
*            ).
*
*    DATA(tab) = page->scroll_container( height = '70%' vertical = abap_true
*        )->table(
*            growing             = abap_true
*            growingthreshold    = '20'
*            growingscrolltoload = abap_true
*            items               = client->_bind_one( t_tab )
*            sticky              = 'ColumnHeaders,HeaderToolbar' ).
*
*    tab->columns(
*        )->column(
*            )->text( 'Color' )->get_parent(
*        )->column(
*            )->text( 'Info' )->get_parent(
*        )->column(
*            )->text( 'Description' )->get_parent(
*        )->column(
*            )->text( 'Checkbox' )->get_parent(
*         )->column(
*            )->text( 'Counter' ).
*
*    tab->items( )->column_list_item( )->cells(
**       )->link( text = '{VALUE}' press = client->_event( val = `POPOVER_DETAIL` data = `${$source>/id}` hold_view = abap_true )
*       )->text( '{INFO}'
*       )->text( '{DESCR}'
*       )->checkbox( selected = '{CHECKBOX}' enabled = abap_false
*       )->text( '{COUNT}' ).
*
*    next-xml_main = page->get_root( )->xml_get( ).
*
*    else.
*
*      mv_check_popover = abap_false.
*
*      DATA(lo_popup) = Z2UI5_cl_xml_view=>factory_popup( ).
*
*      lo_popup->popover( placement = `Bottom` title = 'abap2UI5 - Layout'  contentwidth = `50%`
*          )->button( text = `Save` press = client->_event( `BUTTON_SAVE_LAYOUT` )
*          )->footer( )->overflow_toolbar(
*              )->toolbar_spacer(
*               )->button(
*                  text  = 'load'
*                  press = client->_event( 'POPUP_LAYOUT_LOAD' )
*                  type  = 'Emphasized'
*              )->button(
*                  text  = 'close'
*                  press = client->_event( 'POPUP_LAYOUT_CONTINUE' )
*                  type  = 'Emphasized' ).
*
*      next-xml_popup = lo_popup->get_root( )->xml_get( ).
*    ENDIF.
*
*
*    client->set_next( next ).

  ENDMETHOD.
ENDCLASS.

CLASS Z2UI5_CL_DEMO_APP_003 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES Z2UI5_if_app.

    TYPES:
      BEGIN OF ty_row,
        title    TYPE string,
        value    TYPE string,
        descr    TYPE string,
        icon     TYPE string,
        info     TYPE string,
        selected TYPE abap_bool,
        checkbox TYPE abap_bool,
      END OF ty_row.

    DATA t_tab TYPE STANDARD TABLE OF ty_row WITH DEFAULT KEY.
    DATA check_initialized TYPE abap_bool.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_003 IMPLEMENTATION.


  METHOD Z2UI5_if_app~main.
      DATA temp1 LIKE t_tab.
      DATA temp2 LIKE LINE OF temp1.
      DATA view TYPE REF TO z2ui5_cl_xml_view.
      DATA page TYPE REF TO z2ui5_cl_xml_view.
        DATA lt_sel LIKE t_tab.
        DATA temp3 LIKE LINE OF lt_sel.
        DATA temp4 LIKE sy-tabix.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

      
      CLEAR temp1.
      
      temp2-title = 'row_01'.
      temp2-info = 'completed'.
      temp2-descr = 'this is a description'.
      temp2-icon = 'sap-icon://account'.
      INSERT temp2 INTO TABLE temp1.
      temp2-title = 'row_02'.
      temp2-info = 'incompleted'.
      temp2-descr = 'this is a description'.
      temp2-icon = 'sap-icon://account'.
      INSERT temp2 INTO TABLE temp1.
      temp2-title = 'row_03'.
      temp2-info = 'working'.
      temp2-descr = 'this is a description'.
      temp2-icon = 'sap-icon://account'.
      INSERT temp2 INTO TABLE temp1.
      temp2-title = 'row_04'.
      temp2-info = 'working'.
      temp2-descr = 'this is a description'.
      temp2-icon = 'sap-icon://account'.
      INSERT temp2 INTO TABLE temp1.
      temp2-title = 'row_05'.
      temp2-info = 'completed'.
      temp2-descr = 'this is a description'.
      temp2-icon = 'sap-icon://account'.
      INSERT temp2 INTO TABLE temp1.
      temp2-title = 'row_06'.
      temp2-info = 'completed'.
      temp2-descr = 'this is a description'.
      temp2-icon = 'sap-icon://account'.
      INSERT temp2 INTO TABLE temp1.
      t_tab = temp1.

      
      view = z2ui5_cl_xml_view=>factory( ).
      
      page = view->shell(
          )->page(
              title          = 'abap2UI5 - List'
              navbuttonpress = client->_event( 'BACK' )
                shownavbutton = abap_true
              )->header_content(
                  )->link(
                      text = 'Source_Code'  target = '_blank'
                      href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
              )->get_parent( ).

      page->list(
          headertext      = 'List Ouput'
          items           = client->_bind_edit( t_tab )
          mode            = `SingleSelectMaster`
          selectionchange = client->_event( 'SELCHANGE' )
          )->standard_list_item(
              title       = '{TITLE}'
              description = '{DESCR}'
              icon        = '{ICON}'
              info        = '{INFO}'
              press       = client->_event( 'TEST' )
              selected    = `{SELECTED}`
         ).

      client->view_display( view->stringify( ) ).

    ENDIF.

    CASE client->get( )-event.

      WHEN 'SELCHANGE'.
        
        lt_sel = t_tab.
        DELETE lt_sel WHERE selected = abap_false.
        
        
        temp4 = sy-tabix.
        READ TABLE lt_sel INDEX 1 INTO temp3.
        sy-tabix = temp4.
        IF sy-subrc <> 0.
          ASSERT 1 = 0.
        ENDIF.
        client->message_box_display( `go to details for item ` && temp3-title ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
    ENDCASE.

  ENDMETHOD.
ENDCLASS.

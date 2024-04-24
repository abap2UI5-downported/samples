CLASS z2ui5_cl_demo_app_061 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA t_tab TYPE REF TO data.
    DATA check_initialized TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
    METHODS set_view.

  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_061 IMPLEMENTATION.


  METHOD set_view.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    FIELD-SYMBOLS <tab> TYPE table.
    DATA temp1 TYPE z2ui5_if_types=>ty_s_event_control.
    DATA tab TYPE REF TO z2ui5_cl_xml_view.
    view = z2ui5_cl_xml_view=>factory( ).
    
    page = view->shell(
        )->page(
                title          = 'abap2UI5 - RTTI created Table'
                navbuttonpress = client->_event( 'BACK' )
                  shownavbutton = abap_true
            )->header_content(
                )->link(
                    text = 'Demo' target = '_blank'
                    href = 'https://twitter.com/abap2UI5/status/1676522756781817857'
                )->link(
                    text = 'Source_Code' target = '_blank'

        )->get_parent( ).


    
    ASSIGN  t_tab->* TO <tab>.

    
    CLEAR temp1.
    temp1-check_view_destroy = abap_true.
    
    tab = page->table(
            items = client->_bind_edit( <tab> )
            mode  = 'MultiSelect'
        )->header_toolbar(
            )->overflow_toolbar(
                )->title( 'Dynamic typed table'
                )->toolbar_spacer(
                )->button(
                    text  = `server <-> client`
                    press = client->_event( val = 'SEND' s_ctrl = temp1 )
        )->get_parent( )->get_parent( ).

    tab->columns(
        )->column(
            )->text( 'uuid' )->get_parent(
        )->column(
            )->text( 'time' )->get_parent(
        )->column(
            )->text( 'previous' )->get_parent( ).

    tab->items( )->column_list_item( selected = '{SELKZ}'
      )->cells(
          )->input( value = '{ID}'
          )->input( value = '{TIMESTAMPL}'
          )->input( value = '{ID_PREV}' ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.
      FIELD-SYMBOLS <tab> TYPE table.
      DATA temp2 TYPE z2ui5_t_01.
      DATA temp3 TYPE z2ui5_t_01.
      DATA temp4 TYPE z2ui5_t_01.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

      CREATE DATA t_tab TYPE STANDARD TABLE OF ('Z2UI5_T_CORE_01').
      
      ASSIGN t_tab->* TO <tab>.

      
      CLEAR temp2.
      temp2-id = 'this is an uuid'.
      temp2-timestampl = '2023234243'.
      temp2-id_prev = 'previous'.
      INSERT temp2
        INTO TABLE <tab>.

      
      CLEAR temp3.
      temp3-id = 'this is an uuid'.
      temp3-timestampl = '2023234243'.
      temp3-id_prev = 'previous'.
      INSERT temp3
          INTO TABLE <tab>.
      
      CLEAR temp4.
      temp4-id = 'this is an uuid'.
      temp4-timestampl = '2023234243'.
      temp4-id_prev = 'previous'.
      INSERT temp4
          INTO TABLE <tab>.


    ENDIF.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

    ENDCASE.

    set_view(  ).

  ENDMETHOD.
ENDCLASS.

CLASS Z2UI5_CL_DEMO_APP_041 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES Z2UI5_if_app.

    TYPES:
      BEGIN OF ty_row,
        title    TYPE string,
        value    TYPE string,
        descr    TYPE string,
        icon     TYPE string,
        info     TYPE string,
        checkbox TYPE abap_bool,
      END OF ty_row.
    TYPES temp1_c60bee611f TYPE STANDARD TABLE OF ty_row WITH DEFAULT KEY.
DATA t_tab TYPE temp1_c60bee611f.
    DATA mv_Counter TYPE i.

  PROTECTED SECTION.

    DATA client TYPE REF TO Z2UI5_if_client.
    DATA:
      BEGIN OF app,
        check_initialized TYPE abap_bool,
        view_main         TYPE string,
        view_popup        TYPE string,
        get               TYPE z2ui5_if_types=>ty_s_get,
      END OF app.

    METHODS Z2UI5_on_init.
    METHODS Z2UI5_on_event.
    METHODS Z2UI5_on_render.

  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_041 IMPLEMENTATION.


  METHOD Z2UI5_if_app~main.

    me->client     = client.
    app-get        = client->get( ).
    app-view_popup = ``.

    IF app-check_initialized = abap_false.
      app-check_initialized = abap_true.
      Z2UI5_on_init( ).
    ENDIF.

    IF app-get-event IS NOT INITIAL.
      Z2UI5_on_event( ).
    ENDIF.

          Z2UI5_on_render( ).

    CLEAR app-get.

  ENDMETHOD.


  METHOD Z2UI5_on_event.
        DATA temp1 TYPE z2ui5_cl_demo_app_041=>ty_row.

    CASE app-get-event.

      WHEN 'TIMER_FINISHED'.
        mv_counter = mv_counter + 1.
        
        CLEAR temp1.
        temp1-title = 'entry' && mv_counter.
        temp1-info = 'completed'.
        temp1-descr = 'this is a description'.
        temp1-icon = 'sap-icon://account'.
        INSERT temp1
            INTO TABLE t_tab.

*        client->timer_set(
*          interval_ms    = '2000'
*          event_finished = client->_event( 'TIMER_FINISHED' )
*        ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( app-get-s_draft-id_prev_app_stack ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD Z2UI5_on_init.
    DATA temp2 LIKE t_tab.
    DATA temp3 LIKE LINE OF temp2.

    mv_counter = 1.

    
    CLEAR temp2.
    
    temp3-title = 'entry' && mv_counter.
    temp3-info = 'completed'.
    temp3-descr = 'this is a description'.
    temp3-icon = 'sap-icon://account'.
    INSERT temp3 INTO TABLE temp2.
    t_tab = temp2.

*    client->timer_set(
*      interval_ms    = '2000'
*      event_finished = client->_event( 'TIMER_FINISHED' )
*    ).

  ENDMETHOD.


  METHOD Z2UI5_on_render.

    DATA lo_view TYPE REF TO z2ui5_cl_xml_view.
    DATA lo_view2 TYPE REF TO z2ui5_cl_xml_view.
    DATA temp1 TYPE xsdboolean.
    DATA point TYPE REF TO z2ui5_cl_xml_view.
    DATA temp4 LIKE LINE OF t_tab.
    DATA lr_line LIKE REF TO temp4.
      DATA temp5 TYPE string.
    lo_view = z2ui5_cl_xml_view=>factory( ).
   lo_view->_z2ui5( )->timer( finished = client->_event( `TIMER_FINISHED` ) delayms = `2000` checkrepeat = abap_true ).
    
    
    temp1 = boolc( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ).
    lo_view2 = lo_view->shell( )->page(
             title          = 'abap2UI5 - CL_GUI_TIMER - Monitor'
             navbuttonpress = client->_event( 'BACK' )
             shownavbutton = temp1
         )->header_content(
             )->link( text = 'Demo'    target = '_blank'    href = `https://twitter.com/abap2UI5/status/1645816100813152256`
             )->link(
                 text = 'Source_Code' target = '_blank'
                 href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
         )->get_parent(
          ).

    
    point = lo_view2->flex_box(
        width      = '22rem'
        height     = '13rem'
        alignitems = 'Center'
        class      = 'sapUiSmallMargin'
        )->items( )->interact_line_chart(
        selectionchanged = client->_event( 'LINE_CHANGED' )
        precedingpoint   = '15'
        succeddingpoint  = '89'
        )->points( ).
    
    
    LOOP AT t_tab REFERENCE INTO lr_line.
      
      temp5 = sy-tabix.
      point->interact_line_chart_point( label = lr_line->title  value = temp5  ).
    ENDLOOP.

    lo_view2->list(
         headertext = 'Data auto refresh (2 sec)'
         items      = client->_bind( t_tab )
         )->standard_list_item(
             title       = '{TITLE}'
             description = '{DESCR}'
             icon        = '{ICON}'
             info        = '{INFO}' ).

    client->view_display( lo_view->get_root( )->xml_get( ) ).

  ENDMETHOD.
ENDCLASS.

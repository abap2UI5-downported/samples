CLASS Z2UI5_CL_DEMO_APP_049 DEFINITION PUBLIC.

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
    TYPES temp1_fca4b40911 TYPE STANDARD TABLE OF ty_row WITH DEFAULT KEY.
DATA t_tab TYPE temp1_fca4b40911.
    DATA mv_Counter TYPE i.
    DATA mv_key TYPE string.

  PROTECTED SECTION.

    DATA client TYPE REF TO Z2UI5_if_client.
    DATA check_initialized TYPE abap_bool.

    METHODS Z2UI5_on_init.
    METHODS Z2UI5_on_event.
    METHODS Z2UI5_view_display.

  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_049 IMPLEMENTATION.


  METHOD Z2UI5_if_app~main.

    me->client     = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      Z2UI5_on_init( ).
      Z2UI5_view_display( ).
    ENDIF.

    IF client->get( )-event IS NOT INITIAL.
      Z2UI5_on_event( ).
    ENDIF.

    IF mv_key = `VIEW_REFRESH`.
      Z2UI5_view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD Z2UI5_on_event.
        DATA temp1 TYPE z2ui5_cl_demo_app_049=>ty_row.

    CASE client->get( )-event.

      WHEN 'TIMER_FINISHED'.

      do 5 times.
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
        enddo.

    client->view_model_update( ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD Z2UI5_on_init.
    DATA temp2 LIKE t_tab.
    DATA temp3 LIKE LINE OF temp2.

    mv_counter = 1.
    mv_key = 'VIEW_REFRESH'.
    
    CLEAR temp2.
    
    temp3-title = 'entry' && mv_counter.
    temp3-info = 'completed'.
    temp3-descr = 'this is a description'.
    temp3-icon = 'sap-icon://account'.
    INSERT temp3 INTO TABLE temp2.
    t_tab = temp2.

  ENDMETHOD.


  METHOD Z2UI5_view_display.

    DATA lo_view TYPE REF TO z2ui5_cl_xml_view.
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA temp1 TYPE xsdboolean.
    lo_view = z2ui5_cl_xml_view=>factory( ).
    lo_view->_z2ui5( )->timer( finished = client->_event( `TIMER_FINISHED` ) delayms = `2000` checkrepeat = abap_true ).
    
    
    temp1 = boolc( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ).
    page = lo_view->shell( )->page(
             title          = 'abap2UI5 - CL_GUI_TIMER - Monitor'
             navbuttonpress = client->_event( 'BACK' )
             shownavbutton = temp1
         )->header_content(
             )->link( text = 'Demo'    target = '_blank' href = `https://twitter.com/abap2UI5/status/1645816100813152256`
             )->link(
                 text = 'Source_Code' target = '_blank'

         )->get_parent(
          ).


    page->segmented_button( selected_key = client->_bind_edit( mv_key )
        )->items(
            )->segmented_button_item(
                key = 'VIEW_REFRESH'
*                icon = 'sap-icon://accept'
                text = 'Old (rerender View)'
            )->segmented_button_item(
                key = 'MODEL_ONLY'
*                icon = 'sap-icon://add-favorite'
                text = 'New (update only Model)'
            ).

    page->list(
         headertext = 'Data auto refresh (2 sec)'
         items      = client->_bind( t_tab )
         )->standard_list_item(
             title       = '{TITLE}'
             description = '{DESCR}'
             icon        = '{ICON}'
             info        = '{INFO}' ).

    client->view_display( lo_view->stringify( ) ).

  ENDMETHOD.
ENDCLASS.

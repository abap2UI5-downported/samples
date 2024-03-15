CLASS z2ui5_cl_demo_app_147 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA mv_input_main TYPE string .
    DATA mv_input_nest TYPE string .
    DATA check_initialized TYPE abap_bool .
    DATA mv_path TYPE string .
    DATA mv_value TYPE string .
    DATA mv_file TYPE string .

    METHODS on_rendering
      IMPORTING
        !client TYPE REF TO z2ui5_if_client .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_147 IMPLEMENTATION.


 METHOD on_rendering.
    DATA lo_view TYPE REF TO z2ui5_cl_xml_view.
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA lo_view_nested TYPE REF TO z2ui5_cl_xml_view.
    DATA lo_view_nested2 TYPE REF TO z2ui5_cl_xml_view.
    lo_view = z2ui5_cl_xml_view=>factory( ).

    
    page = lo_view->shell(
        )->page(
                title = `Popover on Nested View` id = `test`
                navbuttonpress = client->_event( 'BACK' )
                  shownavbutton = abap_true
            )->header_content(
                )->link(
                    text = 'Source_Code'  target = '_blank'
            )->get_parent( )->vbox(
             )->button( id = 'TEST_MAIN' text = 'SHOW POPOVER MAIN' press = client->_event( 'SHOW POPOVER_MAIN' )
             )->button( text = 'SHOW POPOVER IN POPUP' press = client->_event( 'SHOW POPOVER_IN_POPUP' ) ).

    
    lo_view_nested = z2ui5_cl_xml_view=>factory(
          )->panel( headertext = `Nested View`
              )->button( id = 'TEST_NESTED' text = 'SHOW POPOVER NESTED' press = client->_event( 'SHOW POPOVER_NESTED' ) ).

    
    lo_view_nested2 = z2ui5_cl_xml_view=>factory(
           )->panel( headertext = `Nested2 View`
              )->button( id = 'TEST_NESTED2' text = 'SHOW POPOVER NESTED2' press = client->_event( 'SHOW POPOVER_NESTED2' ) ).

    client->view_display( lo_view->stringify( ) ).
    client->nest_view_display( val = lo_view_nested->stringify( ) id = `test` method_insert = 'addContent'  ).
    client->nest2_view_display( val = lo_view_nested2->stringify( ) id = `test` method_insert = 'addContent'  ).

  ENDMETHOD.


 METHOD z2ui5_if_app~main.
        DATA lr_view_popup_popover TYPE REF TO z2ui5_cl_xml_view.
        DATA lr_popover_popup TYPE REF TO z2ui5_cl_xml_view.
        DATA lr_vbox_popup_popover TYPE REF TO z2ui5_cl_xml_view.
        DATA lr_view_popup TYPE REF TO z2ui5_cl_xml_view.
        DATA lr_popup TYPE REF TO z2ui5_cl_xml_view.
        DATA lr_view_nest2 TYPE REF TO z2ui5_cl_xml_view.
        DATA lr_popover_nest2 TYPE REF TO z2ui5_cl_xml_view.
        DATA lr_vbox_nest2 TYPE REF TO z2ui5_cl_xml_view.
        DATA lr_view TYPE REF TO z2ui5_cl_xml_view.
        DATA lr_popover TYPE REF TO z2ui5_cl_xml_view.
        DATA lr_vbox TYPE REF TO z2ui5_cl_xml_view.
        DATA lr_view_main TYPE REF TO z2ui5_cl_xml_view.
        DATA lr_popover_main TYPE REF TO z2ui5_cl_xml_view.
        DATA lr_vbox_main TYPE REF TO z2ui5_cl_xml_view.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      on_rendering( client = client ).
    ENDIF.

    CASE client->get( )-event.
      WHEN 'START'.
        on_rendering( client = client ).

      WHEN 'OPEN_POPOVER_FROM_POPUP'.
        
        lr_view_popup_popover = z2ui5_cl_xml_view=>factory_popup( ).

* ---------- Create popover window ----------------------------------------------------------------
        
        lr_popover_popup = lr_view_popup_popover->popover( placement = 'Right'
                                             showheader = abap_false
                                             class = `sapUiContentPadding` ).

* ---------- Create vertical box ------------------------------------------------------------------
        
        lr_vbox_popup_popover = lr_popover_popup->vbox(  ).

* ---------- Set text -----------------------------------------------------------------------------
        lr_vbox_popup_popover->text( text = 'Discard all changes?' ).

* ---------- Set button ---------------------------------------------------------------------------
        lr_vbox_popup_popover->button( text = 'Discard'
                         press = client->_event_client( client->cs_event-popover_close )
                         width = `16rem` ).

* ---------- Return xml ---------------------------------------------------------------------------
        client->popover_display( xml = lr_view_popup_popover->stringify( ) by_id = 'TEST_POPUP' ).

      WHEN 'SHOW POPOVER_IN_POPUP'.

        
        lr_view_popup = z2ui5_cl_xml_view=>factory_popup( ).
        
        lr_popup = lr_view_popup->dialog( ).
        lr_popup->button( id = 'TEST_POPUP' text = `OPEN POPOVER` press = client->_event( 'OPEN_POPOVER_FROM_POPUP' ) class = `sapUiLargeMarginEnd` ).
        lr_popup->button( type = `Emphasized` text = `Close Popup` press = client->_event_client( client->cs_event-popup_close ) ).

        client->popup_display( lr_view_popup->stringify( ) ).

      WHEN 'SHOW POPOVER_NESTED2'.
* ---------- Create View --------------------------------------------------------------------------
        
        lr_view_nest2 = z2ui5_cl_xml_view=>factory_popup( ).

* ---------- Create popover window ----------------------------------------------------------------
        
        lr_popover_nest2 = lr_view_nest2->popover( placement = 'Right'
                                             showheader = abap_false
                                             class = `sapUiContentPadding` ).

* ---------- Create vertical box ------------------------------------------------------------------
        
        lr_vbox_nest2 = lr_popover_nest2->vbox(  ).

* ---------- Set text -----------------------------------------------------------------------------
        lr_vbox_nest2->text( text = 'Discard all changes?' ).

* ---------- Set button ---------------------------------------------------------------------------
        lr_vbox_nest2->button( text = 'Discard'
                         press = client->_event( 'DISCARD' )
                         width = `16rem` ).

* ---------- Return xml ---------------------------------------------------------------------------
        client->popover_display( xml = lr_view_nest2->stringify( ) by_id = 'TEST_NESTED2' ).
      WHEN 'SHOW POPOVER_NESTED'.
* ---------- Create View --------------------------------------------------------------------------
        
        lr_view = z2ui5_cl_xml_view=>factory_popup( ).

* ---------- Create popover window ----------------------------------------------------------------
        
        lr_popover = lr_view->popover( placement = 'Right'
                                             showheader = abap_false
                                             class = `sapUiContentPadding` ).

* ---------- Create vertical box ------------------------------------------------------------------
        
        lr_vbox = lr_popover->vbox(  ).

* ---------- Set text -----------------------------------------------------------------------------
        lr_vbox->text( text = 'Discard all changes?' ).

* ---------- Set button ---------------------------------------------------------------------------
        lr_vbox->button( text = 'Discard'
                         press = client->_event( 'DISCARD' )
                         width = `16rem` ).

* ---------- Return xml ---------------------------------------------------------------------------
        client->popover_display( xml = lr_view->stringify( ) by_id = 'TEST_NESTED' ).

      WHEN 'SHOW POPOVER_MAIN'.
* ---------- Create View --------------------------------------------------------------------------
        
        lr_view_main = z2ui5_cl_xml_view=>factory_popup( ).

* ---------- Create popover window ----------------------------------------------------------------
        
        lr_popover_main = lr_view_main->popover( placement = 'Right'
                                                  showheader = abap_false
                                                  class = `sapUiContentPadding` ).

* ---------- Create vertical box ------------------------------------------------------------------
        
        lr_vbox_main = lr_popover_main->vbox(  ).

* ---------- Set text -----------------------------------------------------------------------------
        lr_vbox_main->text( text = 'Discard all changes?' ).

* ---------- Set button ---------------------------------------------------------------------------
        lr_vbox_main->button( text = 'Discard' press = client->_event( 'DISCARD' ) width = `16rem` ).

* ---------- Return xml ---------------------------------------------------------------------------
        client->popover_display( xml = lr_view_main->stringify( ) by_id = 'TEST_MAIN' ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack  ) ).

    ENDCASE.

  ENDMETHOD.
ENDCLASS.

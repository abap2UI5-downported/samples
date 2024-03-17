CLASS z2ui5_cl_demo_app_180 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_serializable_object .
    INTERFACES z2ui5_if_app .

    DATA mv_initialized TYPE abap_bool.
    DATA mv_url TYPE string.

    METHODS on_event.
    METHODS view_display.

  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_180 IMPLEMENTATION.


  METHOD on_event.
        DATA temp1 TYPE string_table.

    CASE client->get( )-event.

      WHEN 'CUSTOM_JS_FROM_EB'.

        client->follow_up_action( custom_js = `sap.z2ui5.afterBE()` ).

      WHEN 'CALL_EF'.

        mv_url = `https://www.google.com`.

        client->view_model_update( ).

        
        CLEAR temp1.
        INSERT mv_url INTO TABLE temp1.
        client->follow_up_action( custom_js = client->_event_client( val = client->cs_event-open_new_tab t_arg = temp1 ) ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
        RETURN.
    ENDCASE.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    view = z2ui5_cl_xml_view=>factory( ).
    view->_generic( name = `script` ns = `html` )->_cc_plain_xml( `sap.z2ui5.afterBE = () => { alert("afterBE triggered !!"); }` ).

    
    page = view->shell( )->page( title = `Client->FOLLOW_UP_ACTION use cases` class = `sapUiContentPadding` ).
    page = page->vbox( ).
    page->button( text = `call frontend event from backend event` press = client->_event( `CALL_EF` ) ).
    page->label( text =  `MV_URL was set AFTER backend event and model update to:` ).
    page->label( text =  client->_bind_edit( mv_url ) ).

    page->get_parent( )->hbox( class = `sapUiSmallMargin` ).
*    page = page->vbox( ).
    page->button( text = `call custom JS from EB` press = client->_event( 'CUSTOM_JS_FROM_EB' ) ).


    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF mv_initialized = abap_false.
      mv_initialized = abap_true.

      view_display( ).

    ENDIF.

    on_event( ).

  ENDMETHOD.
ENDCLASS.

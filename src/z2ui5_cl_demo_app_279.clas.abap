CLASS z2ui5_cl_demo_app_279 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_serializable_object .
    INTERFACES z2ui5_if_app .

    DATA text_input TYPE string .
    DATA dirty TYPE abap_bool.

  PRIVATE SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
    DATA initialized TYPE abap_bool.

    METHODS display_view.
    METHODS on_event.
    METHODS render_popup.

ENDCLASS.



CLASS z2ui5_cl_demo_app_279 IMPLEMENTATION.


  METHOD display_view.

    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA temp1 TYPE xsdboolean.
    DATA box TYPE REF TO z2ui5_cl_xml_view.
    temp1 = boolc( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ).
    page = z2ui5_cl_xml_view=>factory(
                   )->shell(
                   )->page(
                      title          = 'abap2UI5 - data loss protection'
                      navbuttonpress = client->_event( 'BACK' )
                      shownavbutton  = temp1 ).

    
    box = page->flex_box( direction = `Row` alignitems = `Start` class = 'sapUiTinyMargin' ).

    box->input(
      id          = `input`
      value       = client->_bind_edit( text_input )
      submit      = client->_event( 'submit' )
      width       = `40rem`
      placeholder = `Enter data, submit and navigate back to trigger data loss protection` ).

    box->info_label(
      text        = 'dirty'
      colorscheme = '8'
      icon        = 'sap-icon://message-success'
      class       = `sapUiSmallMarginBegin sapUiTinyMarginTop`
      visible     = client->_bind( dirty ) ).

    box->button(
      text    = 'Reset'
      press   = client->_event( 'reset' )
      class   = `sapUiSmallMarginBegin`
      visible = client->_bind( dirty ) ).

    page->_z2ui5( )->focus( focusid = `input` ).

*    page->_z2ui5( )->dirty( dirty ).
    page->_z2ui5( )->dirty( client->_bind( dirty ) ).
*    page->_z2ui5( )->dirty(  '{= $' &&  client->_bind_Edit( text_input ) && ' !== "" }' ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
        DATA temp2 TYPE xsdboolean.

    CASE client->get( )-event.
      WHEN 'BACK'.
        IF text_input IS NOT INITIAL.
          render_popup( ).
        ELSE.
          client->nav_app_leave( ).
        ENDIF.
      WHEN 'submit'.
        
        temp2 = boolc( text_input IS NOT INITIAL ).
        dirty = temp2.
      WHEN 'reset'.
        CLEAR:
          dirty,
          text_input.
      WHEN 'popup_decide_cancel'.
        CLEAR: dirty.
        client->popup_destroy( ).
        client->nav_app_leave( ).
      WHEN 'popup_decide_continue'.
        client->popup_destroy( ).
    ENDCASE.

  ENDMETHOD.


  METHOD render_popup.

    DATA popup TYPE REF TO z2ui5_cl_xml_view.
    popup = z2ui5_cl_xml_view=>factory_popup( ).
    popup->dialog( title = 'Warning' icon = 'sap-icon://status-critical'
        )->vbox(
            )->text( text = 'Your entries will be lost when you leave this page.'
                     class ='sapUiSmallMargin'
        )->get_parent(
        )->buttons(
            )->button(
                text  = 'Leave Page'
                type  = 'Emphasized'
                press = client->_event( 'popup_decide_cancel' )
            )->button(
                text  = 'Cancel'
                press = client->_event( 'popup_decide_continue' ) ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    on_event( ).

    IF initialized = abap_false.
      initialized = abap_true.
      display_view( ).
    ELSE.
      client->view_model_update( ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.

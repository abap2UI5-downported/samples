CLASS z2ui5_cl_demo_app_152 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA client TYPE REF TO z2ui5_if_client.

    TYPES:
      BEGIN OF ty_row,
        title TYPE string,
        value TYPE string,
        descr TYPE string,
      END OF ty_row.
    TYPES temp1_eeb45a0adc TYPE STANDARD TABLE OF ty_row WITH DEFAULT KEY.
DATA mt_tab TYPE temp1_eeb45a0adc.

    DATA mv_check_initialized TYPE abap_bool.
    METHODS ui5_display.
    METHODS ui5_event.
    METHODS ui5_callback.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_152 IMPLEMENTATION.


  METHOD ui5_event.
        DATA temp1 LIKE mt_tab.
        DATA temp2 LIKE LINE OF temp1.
        DATA lo_app TYPE REF TO z2ui5_cl_popup_to_select.

    CASE client->get( )-event.

      WHEN 'POPUP'.

        
        CLEAR temp1.
        
        temp2-descr = 'this is a description'.
        temp2-title = 'title_01'.
        temp2-value = 'value_01'.
        INSERT temp2 INTO TABLE temp1.
        temp2-title = 'title_02'.
        temp2-value = 'value_02'.
        INSERT temp2 INTO TABLE temp1.
        temp2-title = 'title_03'.
        temp2-value = 'value_03'.
        INSERT temp2 INTO TABLE temp1.
        temp2-title = 'title_04'.
        temp2-value = 'value_04'.
        INSERT temp2 INTO TABLE temp1.
        temp2-title = 'title_05'.
        temp2-value = 'value_05'.
        INSERT temp2 INTO TABLE temp1.
        mt_tab = temp1.

        
        lo_app = z2ui5_cl_popup_to_select=>factory( mt_tab ).
        client->nav_app_call( lo_app ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD ui5_display.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA temp1 TYPE xsdboolean.
    view = z2ui5_cl_xml_view=>factory( ).
    
    temp1 = boolc( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ).
    view->shell(
        )->page(
                title          = 'abap2UI5 - Popup To Select'
                navbuttonpress = client->_event( val = 'BACK' )
                shownavbutton = temp1
            )->header_content(
                )->link(
                    text = 'Source_Code'
                    target = '_blank'
                    href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
                    )->get_parent(
           )->button(
            text  = 'Open Popup...'
            press = client->_event( 'POPUP' ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->get( )-check_on_navigated = abap_true.
      IF mv_check_initialized = abap_false.
        mv_check_initialized = abap_true.
        ui5_display( ).
      ELSE.
        ui5_callback( ).
      ENDIF.
      RETURN.
    ENDIF.

    ui5_event( ).

  ENDMETHOD.

  METHOD ui5_callback.
        DATA lo_prev TYPE REF TO z2ui5_if_app.
        DATA temp3 TYPE REF TO z2ui5_cl_popup_to_select.
        DATA ls_result TYPE z2ui5_cl_popup_to_select=>ty_s_result.
        FIELD-SYMBOLS <row> TYPE ty_row.

    TRY.
        
        lo_prev = client->get_app( client->get(  )-s_draft-id_prev_app ).
        
        temp3 ?= lo_prev.
        
        ls_result = temp3->result( ).
        
        ASSIGN ls_result-row->* TO <row>.
        client->message_box_display( `callback after popup to select: ` && <row>-title ).
      CATCH cx_root.
    ENDTRY.

  ENDMETHOD.

ENDCLASS.

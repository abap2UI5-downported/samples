CLASS z2ui5_cl_demo_app_314 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_314 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.
      DATA view TYPE REF TO z2ui5_cl_xml_view.
      DATA page TYPE REF TO z2ui5_cl_xml_view.
      DATA temp2 TYPE xsdboolean.
      DATA tab TYPE REF TO z2ui5_cl_xml_view.
      DATA temp1 TYPE string_table.

    IF client->check_on_init( ) IS NOT INITIAL.
      
      view = z2ui5_cl_xml_view=>factory( ).
      
      
      temp2 = boolc( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ).
      page = view->shell(
          )->page(
              title          = 'abap2UI5 - Table with odata source'
              navbuttonpress = client->_event( 'BACK' )
              shownavbutton  = temp2 ).

      
      tab = page->table(
        items = `{odata>/BookingSupplement}`
        growing = abap_true
         ).
      tab->columns(
          )->column(  )->text( 'TravelID' )->get_parent(
          )->column( )->text( 'BookingID' )->get_parent(
          )->column( )->text( 'BookingSupplementID' )->get_parent(
          )->column( )->text( 'SupplementID' )->get_parent(
          )->column( )->text( 'SupplementText' )->get_parent(
          )->column( )->text( 'Price' )->get_parent(
          )->column( )->text( 'CurrencyCode' )->get_parent(
          ).

      tab->items( )->column_list_item( )->cells(
         )->text( '{odata>TravelID}'
         )->text( '{odata>BookingID}'
         )->text( '{odata>BookingSupplementID}'
         )->text( '{odata>SupplementID}'
         )->text( '{odata>SupplementText}'
         )->text( '{odata>Price}'
         )->text( '{odata>CurrencyCode}'
         ).

      client->view_display( view->stringify( ) ).
      
      CLEAR temp1.
      INSERT `/sap/opu/odata/DMO/API_TRAVEL_U_V2/` INTO TABLE temp1.
      INSERT `odata` INTO TABLE temp1.
      client->follow_up_action(
        client->_event_client(
            val   = z2ui5_if_client=>cs_event-set_odata_model
            t_arg = temp1 ) ).
    ENDIF.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( ).
    ENDCASE.

  ENDMETHOD.
ENDCLASS.

CLASS z2ui5_cl_demo_app_315 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_315 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.
      DATA view TYPE REF TO z2ui5_cl_xml_view.
      DATA page TYPE REF TO z2ui5_cl_xml_view.
      DATA temp2 TYPE xsdboolean.
     DATA tab TYPE REF TO z2ui5_cl_xml_view.
    DATA temp1 TYPE string_table.
    DATA temp3 TYPE string_table.

    IF client->check_on_init( ) IS NOT INITIAL.

      
      view = z2ui5_cl_xml_view=>factory( ).
      
      
      temp2 = boolc( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ).
      page = view->shell(
          )->page(
              title          = 'abap2UI5 - Table with odata source'
              navbuttonpress = client->_event( 'BACK' )
              shownavbutton  = temp2 ).

     
     tab = page->table(
        items = `{TRAVEL>/BookingSupplement}`
        growing = abap_true ).

    tab->header_toolbar( )->toolbar(
      )->title( 'table with odata model' ).

    tab->columns(
      )->column(  )->text( 'TravelID' )->get_parent(
      )->column( )->text( 'BookingID' )->get_parent(
      )->column( )->text( 'BookingSupplementID' )->get_parent(
      )->column( )->text( 'SupplementID' )->get_parent(
      )->column( )->text( 'SupplementText' )->get_parent(
      )->column( )->text( 'Price' )->get_parent(
      )->column( )->text( 'CurrencyCode' )->get_parent( ).

    tab->items( )->column_list_item( )->cells(
      )->text( '{TRAVEL>TravelID}'
      )->text( '{TRAVEL>BookingID}'
      )->text( '{TRAVEL>BookingSupplementID}'
      )->text( '{TRAVEL>SupplementID}'
      )->text( '{TRAVEL>SupplementText}'
      )->text( '{TRAVEL>Price}'
      )->text( '{TRAVEL>CurrencyCode}' ).

    tab = page->table(
      items = `{FLIGHT>/Airport}`
      growing = abap_true ).

    tab->header_toolbar( )->toolbar(
      )->title( 'table with odata model' ).

    tab->columns(
      )->column(  )->text( 'AirportID' )->get_parent(
      )->column( )->text( 'Name' )->get_parent(
      )->column( )->text( 'City' )->get_parent(
      )->column( )->text( 'CountryCode' )->get_parent( ).

    tab->items( )->column_list_item( )->cells(
      )->text( '{FLIGHT>AirportID}'
      )->text( '{FLIGHT>Name}'
      )->text( '{FLIGHT>City}'
      )->text( '{FLIGHT>CountryCode}' ).

    client->view_display( val = view->stringify( ) switchdefaultmodel = `` ).

    
    CLEAR temp1.
    INSERT `/sap/opu/odata/DMO/API_TRAVEL_U_V2/` INTO TABLE temp1.
    INSERT `TRAVEL` INTO TABLE temp1.
    client->follow_up_action( client->_event_client(
      val = z2ui5_if_client=>cs_event-set_odata_model
      t_arg = temp1 ) ).

    
    CLEAR temp3.
    INSERT `/sap/opu/odata/DMO/ui_flight_r_v2/` INTO TABLE temp3.
    INSERT `FLIGHT` INTO TABLE temp3.
    client->follow_up_action( client->_event_client(
      val = z2ui5_if_client=>cs_event-set_odata_model
      t_arg = temp3 ) ).

    ENDIF.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( ).
    ENDCASE.

  ENDMETHOD.
ENDCLASS.

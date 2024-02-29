CLASS z2ui5_cl_demo_app_109 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app .

    DATA product TYPE string .
    DATA quantity TYPE string .
    DATA mv_placement TYPE string .

  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client.
    DATA check_initialized TYPE abap_bool.

    METHODS z2ui5_on_init.
    METHODS z2ui5_on_event.
    METHODS z2ui5_display_view.
    METHODS z2ui5_display_popover
      IMPORTING
        id TYPE string.

  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_109 IMPLEMENTATION.


  METHOD z2ui5_display_popover.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    view = z2ui5_cl_xml_view=>factory_popup( ).
    view->quick_view( placement = mv_placement
*                      beforeclose = client->_event( val = `CLOSE_POPOVER` )
*                      beforeclose = client->_event_client( client->cs_event-popover_close )
*                      afterclose = client->_event( `CLOSE_POPOVER` )
              )->quick_view_page( pageid = `employeePageId`
                                  header = `Employee Info`
                                  title  = `choper725`
                                  titleurl = `https://github.com/abap2UI5/abap2UI5`
                                  description = `Enjoy`
                            )->quick_view_group( heading = `Contact Details`
                              )->quick_view_group_element( label = `Mobile`
                                                           value = `123-456-789`
                                                           type = `mobile`
                                                         )->get_parent(
                              )->quick_view_group_element( label = `Phone`
                                                           value = `789-456-123`
                                                           type = `phone`
                                                         )->get_parent(
                              )->quick_view_group_element( label = `Email`
                                                           value = `thisisemail@email.com`
                                                           emailsubject = `Subject`
                                                           type = `email`
                                                         )->get_parent(
                              )->get_parent(
                           )->quick_view_group( heading = `Company`
                            )->quick_view_group_element( label = `Name`
                                                           value = `Adventure Company`
                                                           url = `https://github.com/abap2UI5/abap2UI5`
                                                           type = `link`
                                                         )->get_parent(
                            )->quick_view_group_element( label = `Address`
                                                           value = `Here"`
                                                         )->get_parent( ).


    client->popover_display(
      xml   = view->stringify( )
      by_id = id
    ).

  ENDMETHOD.


  METHOD z2ui5_display_view.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA temp1 TYPE xsdboolean.
    view = z2ui5_cl_xml_view=>factory( ).
    
    temp1 = boolc( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ).
    view->shell(
      )->page(
              title          = 'abap2UI5 - Popover Quickview Examples'
              navbuttonpress = client->_event( val = 'BACK' )
              shownavbutton = temp1
          )->simple_form( 'QuickView Popover'
              )->content( 'form'
                  )->title( 'QuickView Popover'
                  )->label( 'placement'
                  )->segmented_button( client->_bind_edit( mv_placement )
                        )->items(
                        )->segmented_button_item(
                                key = 'Left'
                                icon = 'sap-icon://add-favorite'
                                text = 'Left'
                        )->segmented_button_item(
                                key = 'Top'
                                icon = 'sap-icon://accept'
                                text = 'Top'
                        )->segmented_button_item(
                                key = 'Bottom'
                                icon = 'sap-icon://accept'
                                text = 'Bottom'
                        )->segmented_button_item(
                                key = 'Right'
                                icon = 'sap-icon://attachment'
                                text = 'Right'
                  )->get_parent( )->get_parent(
                    )->label( 'popover'
                    )->button(
                        text  = 'show'
                        press = client->_event( 'POPOVER' )
                        id = 'TEST'
                        width = `10rem`
          ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      z2ui5_on_init( ).
      z2ui5_display_view( ).
      RETURN.
    ENDIF.

    z2ui5_on_event( ).

  ENDMETHOD.


  METHOD z2ui5_on_event.

    CASE client->get( )-event.
      WHEN 'CLOSE_POPOVER'.
        client->popover_destroy( ).
      WHEN 'POPOVER'.
        z2ui5_display_popover( `TEST` ).

      WHEN 'BUTTON_CONFIRM'.
        client->message_toast_display( |confirm| ).
        client->popover_destroy( ).

      WHEN 'BUTTON_CANCEL'.
        client->message_toast_display( |cancel| ).
        client->popover_destroy( ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_on_init.

    mv_placement = 'Left'.
    product  = 'tomato'.
    quantity = '500'.

  ENDMETHOD.
ENDCLASS.

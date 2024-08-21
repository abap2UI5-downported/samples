CLASS z2ui5_cl_demo_app_269 DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.
ENDCLASS.


CLASS z2ui5_cl_demo_app_269 IMPLEMENTATION.
  METHOD z2ui5_if_app~main.
    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA xml TYPE string.
    view = z2ui5_cl_xml_view=>factory( ).

    view->shell_bar(
        title               = `Application Title`
        secondTitle         = `Short description`
        homeIcon            = `https://sapui5.hana.ondemand.com/sdk/resources/sap/ui/documentation/sdk/images/logo_sap.png`
        showCopilot         = abap_true
        showSearch          = abap_true
        showNotifications   = abap_true
        notificationsNumber = `2`
        )->_generic( name = `menu`
                     ns   = `f`
            )->_generic( name = `Menu`
                )->menu_item( text = `Flight booking`
                              icon = `sap-icon://flight`
                )->menu_item( text = `Car rental`
                              icon = `sap-icon://car-rental`
                )->get_parent(
            )->get_parent(
        )->_generic( name = `profile`
                     ns   = `f`
            )->avatar( initials = 'UI' ).

    
    xml = view->stringify( ).

    client->view_display( xml ).
  ENDMETHOD.
ENDCLASS.

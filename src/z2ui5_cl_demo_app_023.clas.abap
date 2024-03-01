CLASS z2ui5_cl_demo_app_023 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA product  TYPE string.
    DATA quantity TYPE string.

    DATA client TYPE REF TO z2ui5_if_client.
    DATA:
      BEGIN OF app,
        check_initialized TYPE abap_bool,
        view_main         TYPE string,
        view_popup        TYPE string,
        s_get             TYPE z2ui5_if_types=>ty_s_get,
      END OF app.

    METHODS z2ui5_on_init.
    METHODS z2ui5_on_event.
    METHODS z2ui5_on_render_main.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_023 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    me->client = client.
    app-s_get  = client->get( ).

    IF app-check_initialized = abap_false.
      app-check_initialized = abap_true.
      z2ui5_on_init( ).
    ENDIF.

    IF app-s_get-event IS NOT INITIAL.
      z2ui5_on_event( ).
    ENDIF.

    z2ui5_on_render_main( ).

    CLEAR app-s_get.

  ENDMETHOD.


  METHOD z2ui5_on_event.

    CASE app-s_get-event.

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( app-s_get-s_draft-id_prev_app_stack ) ).

      WHEN OTHERS.
        app-view_main = app-s_get-event.

    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_on_init.

    product  = 'tomato'.
    quantity = '500'.
    app-view_main = 'NORMAL'.

  ENDMETHOD.


  METHOD z2ui5_on_render_main.

    DATA lo_view TYPE REF TO z2ui5_cl_xml_view.
        DATA lv_xml TYPE string.
        DATA lv_view_normal_xml TYPE string.
        DATA temp15 TYPE xsdboolean.
        DATA temp1 TYPE z2ui5_if_types=>ty_t_name_value.
        DATA temp2 LIKE LINE OF temp1.
        DATA temp3 TYPE z2ui5_if_types=>ty_t_name_value.
        DATA temp4 LIKE LINE OF temp3.
        DATA temp5 TYPE z2ui5_if_types=>ty_t_name_value.
        DATA temp6 LIKE LINE OF temp5.
        DATA temp7 TYPE z2ui5_if_types=>ty_t_name_value.
        DATA temp8 LIKE LINE OF temp7.
        DATA temp9 TYPE z2ui5_if_types=>ty_t_name_value.
        DATA temp10 LIKE LINE OF temp9.
        DATA temp11 TYPE z2ui5_if_types=>ty_t_name_value.
        DATA temp12 LIKE LINE OF temp11.
        DATA temp13 TYPE z2ui5_if_types=>ty_t_name_value.
        DATA temp14 LIKE LINE OF temp13.
        DATA lv_view_gen_xml TYPE string.
    lo_view = z2ui5_cl_xml_view=>factory( ).

    CASE app-view_main.

      WHEN 'XML'.

        
        lv_xml = `<mvc:View displayBlock="true" height="100%" xmlns:core="sap.ui.core" xmlns:l="sap.ui.layout" xmlns:html="http://www.w3.org/1999/xhtml" xmlns:f="sap.ui.layout.form" xmlns:mvc="sap.ui.co` &&
    `re.mvc" xmlns:editor="sap.ui.codeeditor" xmlns:ui="sap.ui.table" xmlns="sap.m" xmlns:uxap="sap.uxap" xmlns:mchart="sap.suite.ui.microchart" xmlns:z2ui5="z2ui5" xmlns:webc="sap.ui.webc.main" xmlns:text="sap.ui.richtexteditor" > <Shell> <Page ` && |\n|
    &&
                              `  title="abap2UI5 - XML XML XML" ` && |\n|  &&
                              `  showNavButton="true" ` && |\n|  &&
                              `  navButtonPress="` &&  client->_event( 'BACK' ) && `" ` && |\n|  &&
                              ` > <headerContent ` && |\n|  &&
                              ` > <Link ` && |\n|  &&
                              `  text="Source_Code" ` && |\n|  &&
                              `  target="_blank" ` && |\n|  &&
                              `  href="&lt;system&gt;sap/bc/adt/oo/classes/Z2UI5_CL_DEMO_APP_023/source/main" ` && |\n|  &&
                              ` /></headerContent> <f:SimpleForm ` && |\n|  &&
                              `  title="Form Title" ` && |\n|  &&
                              ` > <f:content ` && |\n|  &&
                              ` > <Title ` && |\n|  &&
                              `  text="Input" ` && |\n|  &&
                              ` /> <Label ` && |\n|  &&
                              `  text="quantity" ` && |\n|  &&
                              ` /> <Input ` && |\n|  &&
                              `  value="` &&  client->_bind( quantity ) && `" ` && |\n|  &&
                              ` /> <Button ` && |\n|  &&
                              `  press="` &&  client->_event( 'NORMAL' ) && `"`  && |\n|  &&
                              `  text="NORMAL" ` && |\n|  &&
                              ` /> <Button ` && |\n|  &&
                                  `  press="` &&  client->_event( 'GENERIC' ) && `"`  && |\n|  &&
                              `  text="GENERIC" ` && |\n|  &&
                              ` /> <Button ` && |\n|  &&
                                 `  press="` &&  client->_event( 'XML' ) && `"`  && |\n|  &&
                              `  text="XML" ` && |\n|  &&
                              ` /></f:content></f:SimpleForm></Page></Shell></mvc:View>`.

        client->view_display( lv_xml ).

      WHEN 'NORMAL'.

        
        
        temp15 = boolc( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ).
        lv_view_normal_xml = z2ui5_cl_xml_view=>factory(
            )->page(
                    title          = 'abap2UI5 - NORMAL NORMAL NORMAL'
                    navbuttonpress = client->_event( 'BACK' )
                    shownavbutton = temp15
                )->header_content(
                )->simple_form( 'Form Title'
                    )->content( `form`
                        )->title( 'Input'
                        )->label( 'quantity'
                        )->input( client->_bind( quantity )
                        )->button(
                            text  = 'NORMAL'
                            press = client->_event( 'NORMAL' )
                        )->button(
                            text  = 'GENERIC'
                            press = client->_event( 'GENERIC' )
                        )->button(
                            text  = 'XML'
                            press = client->_event( 'XML' )
                 )->stringify( ).

        client->view_display( lv_view_normal_xml ).

      WHEN 'GENERIC'.

        
        CLEAR temp1.
        
        temp2-n = `title`.
        temp2-v = 'abap2UI5 - GENERIC GENERIC GENERIC'.
        INSERT temp2 INTO TABLE temp1.
        temp2-n = `showNavButton`.
        temp2-v = `true`.
        INSERT temp2 INTO TABLE temp1.
        temp2-n = `navButtonPress`.
        temp2-v = client->_event( 'BACK' ).
        INSERT temp2 INTO TABLE temp1.
        
        CLEAR temp3.
        
        temp4-n = `title`.
        temp4-v = 'title'.
        INSERT temp4 INTO TABLE temp3.
        
        CLEAR temp5.
        
        temp6-n = `text`.
        temp6-v = 'quantity'.
        INSERT temp6 INTO TABLE temp5.
        
        CLEAR temp7.
        
        temp8-n = `value`.
        temp8-v = client->_bind( quantity ).
        INSERT temp8 INTO TABLE temp7.
        
        CLEAR temp9.
        
        temp10-n = `text`.
        temp10-v = `NORMAL`.
        INSERT temp10 INTO TABLE temp9.
        temp10-n = `press`.
        temp10-v = client->_event( 'NORMAL' ).
        INSERT temp10 INTO TABLE temp9.
        
        CLEAR temp11.
        
        temp12-n = `text`.
        temp12-v = `GENERIC`.
        INSERT temp12 INTO TABLE temp11.
        temp12-n = `press`.
        temp12-v = client->_event( 'GENERIC' ).
        INSERT temp12 INTO TABLE temp11.
        
        CLEAR temp13.
        
        temp14-n = `text`.
        temp14-v = `XML`.
        INSERT temp14 INTO TABLE temp13.
        temp14-n = `press`.
        temp14-v = client->_event( 'XML' ).
        INSERT temp14 INTO TABLE temp13.
        
        lv_view_gen_xml = z2ui5_cl_ui5=>_factory(
           )->_add(
                n   = 'Shell'
                ns  = `sap.m`
           )->_add(
                n   = `Page`
                ns  = `sap.m`
                t_p = temp1
           )->_add(
                n   = `SimpleForm`
                ns  = `sap.ui.layout.form`
                t_p = temp3
           )->_add(
                n  = `content`
                ns = `sap.ui.layout.form`
           )->_add(
                n   = `Label`
                ns  = `sap.m`
                t_p = temp5 )->_go_up(
           )->_add(
                n   = `Input`
                ns  = `sap.m`
                t_p = temp7 )->_go_up(
           )->_add(
                n   = `Button`
                ns  = `sap.m`
                t_p = temp9 )->_go_up(
           )->_add(
                n   = `Button`
                ns  = `sap.m`
                t_p = temp11 )->_go_up(
           )->_add(
                n = `Button`
                ns  = `sap.m`
                t_p = temp13
           )->_stringify( ).

        client->view_display( lv_view_gen_xml ).

    ENDCASE.

  ENDMETHOD.
ENDCLASS.

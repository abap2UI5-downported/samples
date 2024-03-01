CLASS z2ui5_cl_demo_app_146 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_serializable_object .
    INTERFACES z2ui5_if_app .

    TYPES:
      BEGIN OF ty_tab,
        text  TYPE string,
        class TYPE string,
      END OF ty_tab .

    DATA check_initialized TYPE abap_bool .
    DATA:
      t_tab TYPE TABLE OF ty_tab WITH DEFAULT KEY .
  PROTECTED SECTION.

    METHODS z2ui5_on_rendering
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS z2ui5_on_event
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS z2ui5_on_init.

  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_146 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      z2ui5_on_init( ).

      z2ui5_on_rendering( client ).

    ENDIF.

    z2ui5_on_event( client ).

  ENDMETHOD.


  METHOD z2ui5_on_event.

    CASE client->get( )-event.
      WHEN 'RERUN'.
        z2ui5_on_rendering( client ).
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_on_init.
    DATA temp1 LIKE t_tab.
    DATA temp2 LIKE LINE OF temp1.
    CLEAR temp1.
    
    temp2-text = `bounce`.
    temp2-class = `animate__animated animate__bounce`.
    INSERT temp2 INTO TABLE temp1.
    temp2-text = `flash`.
    temp2-class = `animate__animated animate__flash`.
    INSERT temp2 INTO TABLE temp1.
    temp2-text = `pulse`.
    temp2-class = `animate__animated animate__pulse`.
    INSERT temp2 INTO TABLE temp1.
    temp2-text = `rubberBand`.
    temp2-class = `animate__animated animate__rubberBand`.
    INSERT temp2 INTO TABLE temp1.
    temp2-text = `shakeX`.
    temp2-class = `animate__animated animate__shakeX`.
    INSERT temp2 INTO TABLE temp1.
    temp2-text = `shakeY`.
    temp2-class = `animate__animated animate__shakeY`.
    INSERT temp2 INTO TABLE temp1.
    temp2-text = `headShake`.
    temp2-class = `animate__animated animate__headShake`.
    INSERT temp2 INTO TABLE temp1.
    temp2-text = `swing`.
    temp2-class = `animate__animated animate__swing`.
    INSERT temp2 INTO TABLE temp1.
    temp2-text = `tada`.
    temp2-class = `animate__animated animate__tada`.
    INSERT temp2 INTO TABLE temp1.
    temp2-text = `wobble`.
    temp2-class = `animate__animated animate__wobble`.
    INSERT temp2 INTO TABLE temp1.
    temp2-text = `jello`.
    temp2-class = `animate__animated animate__jello`.
    INSERT temp2 INTO TABLE temp1.
    temp2-text = `heartBeat`.
    temp2-class = `animate__animated animate__heartBeat`.
    INSERT temp2 INTO TABLE temp1.
    temp2-text = `backInDown`.
    temp2-class = `animate__animated animate__backInDown`.
    INSERT temp2 INTO TABLE temp1.
    temp2-text = `backInLeft`.
    temp2-class = `animate__animated animate__backInLeft`.
    INSERT temp2 INTO TABLE temp1.
    temp2-text = `backInRight`.
    temp2-class = `animate__animated animate__backInRight`.
    INSERT temp2 INTO TABLE temp1.
    temp2-text = `backInUp`.
    temp2-class = `animate__animated animate__backInUp`.
    INSERT temp2 INTO TABLE temp1.
    temp2-text = `backOutDown`.
    temp2-class = `animate__animated animate__backOutDown`.
    INSERT temp2 INTO TABLE temp1.
    temp2-text = `backOutLeft`.
    temp2-class = `animate__animated animate__backOutLeft`.
    INSERT temp2 INTO TABLE temp1.
    temp2-text = `backOutRight`.
    temp2-class = `animate__animated animate__backOutRight`.
    INSERT temp2 INTO TABLE temp1.
    temp2-text = `backOutUp`.
    temp2-class = `animate__animated animate__backOutUp`.
    INSERT temp2 INTO TABLE temp1.
    temp2-text = `bounceIn`.
    temp2-class = `animate__animated animate__bounceIn`.
    INSERT temp2 INTO TABLE temp1.
    temp2-text = `bounceInDown`.
    temp2-class = `animate__animated animate__bounceInDown`.
    INSERT temp2 INTO TABLE temp1.
    temp2-text = `bounceInLeft`.
    temp2-class = `animate__animated animate__bounceInLeft`.
    INSERT temp2 INTO TABLE temp1.
    temp2-text = `bounceInRight`.
    temp2-class = `animate__animated animate__bounceInRight`.
    INSERT temp2 INTO TABLE temp1.
    temp2-text = `bounceInUp`.
    temp2-class = `animate__animated animate__bounceInUp`.
    INSERT temp2 INTO TABLE temp1.
    temp2-text = `bounceOut`.
    temp2-class = `animate__animated animate__bounceOut`.
    INSERT temp2 INTO TABLE temp1.
    temp2-text = `bounceOutDown`.
    temp2-class = `animate__animated animate__bounceOutDown`.
    INSERT temp2 INTO TABLE temp1.
    temp2-text = `bounceOutLeft`.
    temp2-class = `animate__animated animate__bounceOutLeft`.
    INSERT temp2 INTO TABLE temp1.
    temp2-text = `bounceOutRight`.
    temp2-class = `animate__animated animate__bounceOutRight`.
    INSERT temp2 INTO TABLE temp1.
    temp2-text = `bounceOutUp`.
    temp2-class = `animate__animated animate__bounceOutUp`.
    INSERT temp2 INTO TABLE temp1.
    temp2-text = `fadeIn`.
    temp2-class = `animate__animated animate__fadeIn`.
    INSERT temp2 INTO TABLE temp1.
    temp2-text = `fadeInDown`.
    temp2-class = `animate__animated animate__fadeInDown`.
    INSERT temp2 INTO TABLE temp1.
    t_tab = temp1.
  ENDMETHOD.


  METHOD z2ui5_on_rendering.


    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA temp1 TYPE xsdboolean.
    DATA items TYPE REF TO z2ui5_cl_xml_view.
    DATA ls_tab LIKE LINE OF t_tab.
    view = z2ui5_cl_xml_view=>factory( ).

    view->_generic( name = `style` ns = `html` )->_cc_plain_xml( z2ui5_cl_cc_animatecss=>load_css( ) )->get_parent( ).

    
    
    temp1 = boolc( abap_false = client->get( )-check_launchpad_active ).
    page = view->shell(
         )->page(
          showheader       = temp1
            title          = 'abap2UI5 - animate.css demo'
            navbuttonpress = client->_event( 'BACK' )
              shownavbutton = abap_true ).

    page->header_content(
             )->link( text = 'Demo'        target = '_blank' href = `https://twitter.com/abap2UI5/status/1628701535222865922`
             )->link( text = 'Source_Code' target = '_blank'
             )->button( press = client->_event( 'RERUN' ) text = 'RERUN'
         )->get_parent( ).


    
    items = page->table( mode = `None`
            )->columns(
                )->column( )->text( 'Text in label control' )->get_parent(
                )->column( )->text( 'Class Value' )->get_parent(
            )->get_parent(
            )->items( ).
    
    LOOP AT t_tab INTO ls_tab.
      items->column_list_item( )->cells( )->label( text = ls_tab-text class = ls_tab-class
        )->label( text = ls_tab-class ).
    ENDLOOP.

    client->view_display( page->stringify( ) ).

  ENDMETHOD.
ENDCLASS.

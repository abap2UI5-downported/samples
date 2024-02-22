CLASS z2ui5_cl_demo_app_002 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA:
      BEGIN OF screen,
        check_is_active TYPE abap_bool,
        colour          TYPE string,
        combo_key       TYPE string,
        combo_key2      TYPE string,
        segment_key     TYPE string,
        date            TYPE string,
        date_time       TYPE string,
        time_start      TYPE string,
        time_end        TYPE string,
        check_switch_01 TYPE abap_bool VALUE abap_false,
        check_switch_02 TYPE abap_bool VALUE abap_false,
      END OF screen.

    TYPES:
      BEGIN OF s_suggestion_items,
        value TYPE string,
        descr TYPE string,
      END OF s_suggestion_items.
    TYPES temp1_1f6edbe174 TYPE STANDARD TABLE OF s_suggestion_items WITH DEFAULT KEY.
DATA mt_suggestion TYPE temp1_1f6edbe174.

    TYPES:
      BEGIN OF s_combobox,
        key  TYPE string,
        text TYPE string,
      END OF s_combobox.

    TYPES ty_t_combo TYPE STANDARD TABLE OF s_combobox WITH DEFAULT KEY.



    DATA check_initialized TYPE abap_bool.

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



CLASS z2ui5_cl_demo_app_002 IMPLEMENTATION.


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

      WHEN 'BUTTON_SEND'.
        client->message_box_display( 'success - values send to the server' ).
      WHEN 'BUTTON_CLEAR'.
        CLEAR screen.
        client->message_toast_display( 'View initialized' ).
      WHEN 'BACK'.
        client->nav_app_leave( ).

    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_on_init.
    DATA temp1 LIKE mt_suggestion.
    DATA temp2 LIKE LINE OF temp1.

    CLEAR screen.
    screen-check_is_active = abap_true.
    screen-colour = 'BLUE'.
    screen-combo_key = 'GRAY'.
    screen-segment_key = 'GREEN'.
    screen-date = '07.12.22'.
    screen-date_time = '23.12.2022, 19:27:20'.
    screen-time_start = '05:24:00'.
    screen-time_end = '17:23:57'.

    
    CLEAR temp1.
    
    temp2-descr = 'Green'.
    temp2-value = 'GREEN'.
    INSERT temp2 INTO TABLE temp1.
    temp2-descr = 'Blue'.
    temp2-value = 'BLUE'.
    INSERT temp2 INTO TABLE temp1.
    temp2-descr = 'Black'.
    temp2-value = 'BLACK'.
    INSERT temp2 INTO TABLE temp1.
    temp2-descr = 'Grey'.
    temp2-value = 'GREY'.
    INSERT temp2 INTO TABLE temp1.
    temp2-descr = 'Blue2'.
    temp2-value = 'BLUE2'.
    INSERT temp2 INTO TABLE temp1.
    temp2-descr = 'Blue3'.
    temp2-value = 'BLUE3'.
    INSERT temp2 INTO TABLE temp1.
    mt_suggestion = temp1.

  ENDMETHOD.


  METHOD z2ui5_on_rendering.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA temp1 TYPE xsdboolean.
    DATA temp2 TYPE xsdboolean.
    DATA grid TYPE REF TO z2ui5_cl_xml_view.
    DATA form TYPE REF TO z2ui5_cl_xml_view.
    DATA lv_test TYPE REF TO z2ui5_cl_xml_view.
    DATA temp3 TYPE ty_t_combo.
    DATA temp4 LIKE LINE OF temp3.
    DATA temp5 TYPE ty_t_combo.
    DATA temp6 LIKE LINE OF temp5.
    view = z2ui5_cl_xml_view=>factory( ).

    
    
    temp1 = boolc( abap_false = client->get( )-check_launchpad_active ).
    
    temp2 = boolc( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ).
    page = view->shell(
         )->page(
          showheader       = temp1
            title          = 'abap2UI5 - Selection-Screen Example'
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton = temp2
            ).

    
    grid = page->grid( 'L6 M12 S12'
        )->content( 'layout' ).

    grid->simple_form( title = 'Input' editable = abap_true
        )->content( 'form'
            )->label( 'Input with value help'
            )->input(
                    value           = client->_bind_edit( screen-colour )
                    placeholder     = 'fill in your favorite colour'
                    suggestionitems = client->_bind( mt_suggestion )
                    showsuggestion  = abap_true )->get(
                )->suggestion_items( )->get(
                    )->list_item(
                        text = '{VALUE}'
                        additionaltext = '{DESCR}' ).

    grid->simple_form( title = 'Time Inputs' editable = abap_true
        )->content( 'form'
            )->label( 'Date'
            )->date_picker( client->_bind_edit( screen-date )
            )->label( 'Date and Time'
            )->date_time_picker( client->_bind_edit( screen-date_time )
            )->label( 'Time Begin/End'
            )->time_picker( client->_bind_edit( screen-time_start )
            )->time_picker( client->_bind_edit( screen-time_end ) ).


    
    form = grid->get_parent( )->get_parent( )->grid( 'L12 M12 S12'
        )->content( 'layout'
            )->simple_form( title = 'Input with select options' editable = abap_true
                )->content( 'form' ).

    
    lv_test = form->label( 'Checkbox'
         )->checkbox(
             selected = client->_bind_edit( screen-check_is_active )
             text     = 'this is a checkbox'
             enabled  = abap_true ).

    
    CLEAR temp3.
    
    temp4-key = 'BLUE'.
    temp4-text = 'green'.
    INSERT temp4 INTO TABLE temp3.
    temp4-key = 'GREEN'.
    temp4-text = 'blue'.
    INSERT temp4 INTO TABLE temp3.
    temp4-key = 'BLACK'.
    temp4-text = 'red'.
    INSERT temp4 INTO TABLE temp3.
    temp4-key = 'GRAY'.
    temp4-text = 'gray'.
    INSERT temp4 INTO TABLE temp3.
    lv_test->label( 'Combobox'
      )->combobox(
          selectedkey = client->_bind_edit( screen-combo_key )
          items       = client->_bind_local( temp3 )
              )->item(
                  key = '{KEY}'
                  text = '{TEXT}'
      )->get_parent( )->get_parent( ).

    
    CLEAR temp5.
    
    temp6-key = 'BLUE'.
    temp6-text = 'green'.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = 'GREEN'.
    temp6-text = 'blue'.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = 'BLACK'.
    temp6-text = 'red'.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = 'GRAY'.
    temp6-text = 'gray'.
    INSERT temp6 INTO TABLE temp5.
    lv_test->label( 'Combobox2'
      )->combobox(
          selectedkey = client->_bind_edit( screen-combo_key2 )
          items       = client->_bind_local( temp5 )
              )->item(
                  key = '{KEY}'
                  text = '{TEXT}'
      )->get_parent( )->get_parent( ).

    lv_test->label( 'Segmented Button'
    )->segmented_button( client->_bind_edit( screen-segment_key )
        )->items(
            )->segmented_button_item(
                key = 'BLUE'
                icon = 'sap-icon://accept'
                text = 'blue'
            )->segmented_button_item(
                key = 'GREEN'
                icon = 'sap-icon://add-favorite'
                text = 'green'
            )->segmented_button_item(
                key = 'BLACK'
                icon = 'sap-icon://attachment'
                text = 'black'
   )->get_parent( )->get_parent(

   )->label( 'Switch disabled'
   )->switch(
        enabled       = abap_false
        customtexton  = 'A'
        customtextoff = 'B'
   )->label( 'Switch accept/reject'
   )->switch(
        state         = client->_bind_edit( screen-check_switch_01 )
        customtexton  = 'on'
        customtextoff = 'off'
        type = 'AcceptReject'
   )->label( 'Switch normal'
   )->switch(
        state         = client->_bind_edit( screen-check_switch_02 )
        customtexton  = 'YES'
        customtextoff = 'NO' ).

    page->footer( )->overflow_toolbar(
         )->toolbar_spacer(
         )->button(
             text  = 'Clear'
             press = client->_event( 'BUTTON_CLEAR' )
             type  = 'Reject'
             icon  = 'sap-icon://delete'
         )->button(
             text  = 'Send to Server'
             press = client->_event( 'BUTTON_SEND' )
             type  = 'Success' ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.
ENDCLASS.

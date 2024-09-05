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

    DATA client TYPE REF TO z2ui5_if_client.

  PROTECTED SECTION.

    METHODS z2ui5_on_rendering.
    METHODS z2ui5_on_event.
    METHODS z2ui5_on_init.

  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_002 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.
      DATA lv_script TYPE string.

    me->client = client.

    IF check_initialized = abap_false.

      
      lv_script = `` && |\n| &&
                        `function setInputFIlter(){` && |\n| &&
                        ` var inp = sap.z2ui5.oView.byId('suggInput');` && |\n| &&
                        ` inp.setFilterFunction(function(sValue, oItem){` && |\n| &&
                        `   var aSplit = sValue.split(" ");` && |\n| &&
                        `   if (aSplit.length > 0) {` && |\n| &&
                        `     var sTermNew = aSplit.slice(-1)[0];` && |\n| &&
                        `     sTermNew.trim();` && |\n| &&
                        `     if (sTermNew) {` && |\n| &&
                        `       return oItem.getText().match(new RegExp(sTermNew, "i"));` && |\n| &&
                        `     }` && |\n| &&
                        `   }` && |\n| &&
                        ` });` && |\n| &&
                        `}`.


      client->view_display( z2ui5_cl_xml_view=>factory(
       )->_z2ui5( )->timer(  client->_event( `START` )
         )->_generic( ns = `html` name = `script` )->_cc_plain_xml( lv_script
         )->stringify( ) ).

      check_initialized = abap_true.
      z2ui5_on_init( ).
    ENDIF.

    z2ui5_on_event( ).

  ENDMETHOD.


  METHOD z2ui5_on_event.
        DATA temp1 TYPE string_table.

    CASE client->get( )-event.
      WHEN 'START'.
        z2ui5_on_rendering( ).
      WHEN 'BUTTON_MCUSTOM'.
*        send type = '' is mandatory in order to not break current implementation
        
        CLEAR temp1.
        INSERT `First Button` INTO TABLE temp1.
        INSERT `Second Button` INTO TABLE temp1.
        client->message_box_display( type = '' text = 'Custom MessageBox' icon = `SUCCESS`
                                     title = 'Custom MessageBox' actions = temp1 emphasizedaction = `First Button`
                                     onclose = `callMessageToast()` details = `<h3>these are details</h3>`).
      WHEN 'BUTTON_MCONFIRM'.
        client->message_box_display( type = 'confirm' text = 'Confirm MessageBox' ).
      WHEN 'BUTTON_MALERT'.
        client->message_box_display( type = 'alert' text = 'Alert MessageBox' ).
      WHEN 'BUTTON_MERROR'.
        client->message_box_display( type = 'error' text = 'Error MessageBox' ).
      WHEN 'BUTTON_MINFO'.
        client->message_box_display( type = 'information' text = 'Information MessageBox' ).
      WHEN 'BUTTON_MWARNING'.
        client->message_box_display( type = 'warning' text = 'Warning MessageBox' ).
      WHEN 'BUTTON_MSUCCESS'.
        client->message_box_display( type = 'success' text = 'Success MessageBox' icon = `sap-icon://accept` ).
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
    DATA temp3 LIKE mt_suggestion.
    DATA temp4 LIKE LINE OF temp3.

    CLEAR screen.
    screen-check_is_active = abap_true.
    screen-colour = 'BLUE'.
    screen-combo_key = 'GRAY'.
    screen-segment_key = 'GREEN'.
    screen-date = '07.12.22'.
    screen-date_time = '23.12.2022, 19:27:20'.
    screen-time_start = '05:24:00'.
    screen-time_end = '17:23:57'.

    
    CLEAR temp3.
    
    temp4-descr = 'Green'.
    temp4-value = 'GREEN'.
    INSERT temp4 INTO TABLE temp3.
    temp4-descr = 'Blue'.
    temp4-value = 'BLUE'.
    INSERT temp4 INTO TABLE temp3.
    temp4-descr = 'Black'.
    temp4-value = 'BLACK'.
    INSERT temp4 INTO TABLE temp3.
    temp4-descr = 'Gray'.
    temp4-value = 'GRAY'.
    INSERT temp4 INTO TABLE temp3.
    temp4-descr = 'Blue2'.
    temp4-value = 'BLUE2'.
    INSERT temp4 INTO TABLE temp3.
    temp4-descr = 'Blue3'.
    temp4-value = 'BLUE3'.
    INSERT temp4 INTO TABLE temp3.
    mt_suggestion = temp3.

  ENDMETHOD.


  METHOD z2ui5_on_rendering.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA temp1 TYPE xsdboolean.
    DATA temp2 TYPE xsdboolean.
    DATA grid TYPE REF TO z2ui5_cl_xml_view.
    DATA form TYPE REF TO z2ui5_cl_xml_view.
    DATA lv_test TYPE REF TO z2ui5_cl_xml_view.
    DATA temp5 TYPE ty_t_combo.
    DATA temp6 LIKE LINE OF temp5.
    DATA temp7 TYPE ty_t_combo.
    DATA temp8 LIKE LINE OF temp7.
    view = z2ui5_cl_xml_view=>factory( ).
    view->_generic( name = `script` ns = `html` )->_cc_plain_xml( `function callMessageToast(sAction) { sap.m.MessageToast.show('Hello there !!'); }` ).
    
    
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
            )->label( 'Input with suggestion items'
            )->input(
                    id              = `suggInput`
                    value           = client->_bind_edit( screen-colour )
                    placeholder     = 'Fill in your favorite color'
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
    lv_test->label( 'Combobox'
      )->combobox(
          selectedkey = client->_bind_edit( screen-combo_key )
          items       = client->_bind_local( temp5 )
              )->item(
                  key = '{KEY}'
                  text = '{TEXT}'
      )->get_parent( )->get_parent( ).

    
    CLEAR temp7.
    
    temp8-key = 'BLUE'.
    temp8-text = 'green'.
    INSERT temp8 INTO TABLE temp7.
    temp8-key = 'GREEN'.
    temp8-text = 'blue'.
    INSERT temp8 INTO TABLE temp7.
    temp8-key = 'BLACK'.
    temp8-text = 'red'.
    INSERT temp8 INTO TABLE temp7.
    temp8-key = 'GRAY'.
    temp8-text = 'gray'.
    INSERT temp8 INTO TABLE temp7.
    lv_test->label( 'Combobox2'
      )->combobox(
          selectedkey = client->_bind_edit( screen-combo_key2 )
          items       = client->_bind_local( temp7 )
              )->item(
                  key = '{KEY}'
                  text = '{TEXT}'
      )->get_parent( )->get_parent( ).

    lv_test->label( 'Segmented Button'
    )->segmented_button( selected_key = client->_bind_edit( screen-segment_key )
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
         )->text( text = `MessageBox Types`
         )->button(
             text  = 'Confirm'
             press = client->_event( 'BUTTON_MCONFIRM' )
         )->button(
             text  = 'Alert'
             press = client->_event( 'BUTTON_MALERT' )
         )->button(
             text  = 'Error'
             press = client->_event( 'BUTTON_MERROR' )
         )->button(
             text  = 'Information'
             press = client->_event( 'BUTTON_MINFO' )
         )->button(
             text  = 'Warning'
             press = client->_event( 'BUTTON_MWARNING' )
         )->button(
             text  = 'Success'
             press = client->_event( 'BUTTON_MSUCCESS' )
         )->button(
             text  = 'Custom'
             press = client->_event( 'BUTTON_MCUSTOM' )
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


    view->_generic( name = `script` ns = `html` )->_cc_plain_xml( `setInputFIlter()` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.
ENDCLASS.

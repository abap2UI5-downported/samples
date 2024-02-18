CLASS Z2UI5_CL_DEMO_APP_005 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES Z2UI5_if_app.

    DATA:
      BEGIN OF screen,
        check_initialized TYPE abap_bool,
        check_is_active   TYPE abap_bool,
        colour            TYPE string,
        combo_key         TYPE string,
        segment_key       TYPE string,
        date              TYPE string,
        date_time         TYPE string,
        time_start        TYPE string,
        time_end          TYPE string,
        check_switch_01   TYPE abap_bool VALUE abap_false,
        check_switch_02   TYPE abap_bool VALUE abap_false,
        progress_value    TYPE string VALUE '3',
        step_val_01       TYPE string VALUE '4',
        step_val_02       TYPE string VALUE '10',
        text_area         TYPE string,
      END OF screen.

    DATA mv_textarea TYPE string.

    TYPES:
      BEGIN OF ty_s_token,
        key     TYPE string,
        text    TYPE string,
        visible TYPE abap_bool,
        selkz   TYPE abap_bool,
      END OF ty_s_token.

    DATA mt_token            TYPE STANDARD TABLE OF ty_s_token WITH DEFAULT KEY.
    DATA mt_token_sugg       TYPE STANDARD TABLE OF ty_s_token WITH DEFAULT KEY.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_005 IMPLEMENTATION.


  METHOD Z2UI5_if_app~main.
      DATA temp1 LIKE mt_token.
      DATA temp2 LIKE LINE OF temp1.
      DATA temp3 LIKE mt_token_sugg.
      DATA temp4 LIKE LINE OF temp3.
        DATA lv_dummy TYPE c LENGTH 68.
    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA grid TYPE REF TO z2ui5_cl_xml_view.

    IF screen-check_initialized = abap_false.
      screen-check_initialized = abap_true.

      
      CLEAR temp1.
      
      temp2-key = 'VAL1'.
      temp2-text = 'value_1'.
      temp2-selkz = abap_true.
      temp2-visible = abap_true.
      INSERT temp2 INTO TABLE temp1.
      temp2-key = 'VAL3'.
      temp2-text = 'value_3'.
      temp2-selkz = abap_false.
      temp2-visible = abap_true.
      INSERT temp2 INTO TABLE temp1.
      temp2-key = 'VAL4'.
      temp2-text = 'value_4'.
      temp2-selkz = abap_true.
      INSERT temp2 INTO TABLE temp1.
      mt_token = temp1.

      
      CLEAR temp3.
      
      temp4-key = 'VAL1'.
      temp4-text = 'value_1'.
      INSERT temp4 INTO TABLE temp3.
      temp4-key = 'VAL2'.
      temp4-text = 'value_2'.
      INSERT temp4 INTO TABLE temp3.
      temp4-key = 'VAL3'.
      temp4-text = 'value_3'.
      INSERT temp4 INTO TABLE temp3.
      temp4-key = 'VAL4'.
      temp4-text = 'value_4'.
      INSERT temp4 INTO TABLE temp3.
      mt_token_sugg = temp3.

      CLEAR screen.
      screen-check_initialized = abap_true.
      screen-check_is_active = abap_true.
      screen-colour = 'BLUE'.
      screen-combo_key = 'GRAY'.
      screen-segment_key = 'GREEN'.
      screen-date = '07.12.22'.
      screen-date_time = '23.12.2022, 19:27:20'.
      screen-time_start = '05:24:00'.
      screen-time_end = '17:23:57'.

      mv_textarea = `Lorem ipsum dolor st amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magn` &&
                      `a aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd` &&
                  ` gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam n ` &&
                    `  onumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. Lorem ipsum dolor sit am ` &&
                    `  et, consetetur sadipscing elitr, sed diam nonumy eirm sed diam voluptua. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam no ` &&
                          `numy eirmod tempor invidunt ut labore et dolore magna aliquyam erat.`.

    ENDIF.


    CASE client->get( )-event.

      WHEN 'BUTTON_ROUNDTRIP'.
        
        lv_dummy = 'user pressed a button, your custom implementation can be called here'.

      WHEN 'BUTTON_MSG_BOX'.
        client->message_box_display(
          text = 'this is a message box with a custom text'
          type = 'success' ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

    ENDCASE.

    
    view = z2ui5_cl_xml_view=>factory( ).
    
    page = view->shell(
        )->page(
                title          = 'abap2UI5 - Selection-Screen more Controls'
                navbuttonpress = client->_event( 'BACK' )
                  shownavbutton = abap_true
            )->header_content(
                )->link(
                    text = 'Source_Code'  target = '_blank'
                    href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
            )->get_parent( ).

    page->generic_tag(
            arialabelledby = 'genericTagLabel'
            text           = 'Project Cost'
            design         = 'StatusIconHidden'
            status         = 'Error'
            class          = 'sapUiSmallMarginBottom'
        )->object_number(
            state      = 'Error'
            emphasized = 'false'
            number     = '3.5M'
            unit       = 'EUR' ).

    page->generic_tag(
        arialabelledby = 'genericTagLabel'
        text           = 'Project Cost'
        design         = 'StatusIconHidden'
        status         = 'Success'
        class          = 'sapUiSmallMarginBottom'
        )->object_number(
            state      = 'Success'
            emphasized = 'false'
            number     = '3.5M'
            unit       = 'EUR' ).

    page->generic_tag(
        arialabelledby = 'genericTagLabel'
        text           = 'Input'
        design         = 'StatusIconHidden'
        class          = 'sapUiSmallMarginBottom'
        )->object_number(
            emphasized = 'true'
            number     = '3.5M'
            unit       = 'EUR' ).

    
    grid = page->grid( 'L12 M12 S12' )->content( 'layout' ).

    grid->simple_form( title = 'More Controls' editable = abap_true )->content( 'form'
        )->label( 'ProgressIndicator'
        )->progress_indicator(
            percentvalue    = screen-progress_value
            displayvalue    = '0,44GB of 32GB used'
            showvalue       = abap_true
            state           = 'Success'
        )->label( 'StepInput'
        )->step_input(
            value = client->_bind_edit( screen-step_val_01 )
            step = '2'
            min = '0'
            max = '20'
        )->step_input(
            value = client->_bind_edit( screen-step_val_02 )
            step = '10'
            min = '0'
            max = '100'
        )->label( 'Range Slider'
        )->range_slider(
            max           = '100'
            min           = '0'
            step          = '10'
            startvalue    = '10'
            endvalue      = '20'
            showtickmarks = abap_true
            labelinterval = '2'
            width         = '80%'
            class         = 'sapUiTinyMargin'
        )->label( 'MultiInput'
        )->multi_input(
                tokens          = client->_bind_edit( mt_token )
                showclearicon   = abap_true
                showvaluehelp   = abap_true
                suggestionitems = client->_bind( mt_token_sugg )
            )->item(
                    key = `{KEY}`
                    text = `{TEXT}`
            )->tokens(
                )->token(
                    key = `{KEY}`
                    text = `{TEXT}`
                    selected = `{SELKZ}`
                    visible = `{VISIBLE}`
    ).

    grid->simple_form( title = 'Text Area' editable = abap_true )->content( 'form'
        )->label( 'text area'
        )->text_area(
            valueLiveUpdate = abap_true
            value = client->_bind_edit( mv_textarea )
            growing = abap_true
            growingmaxlines = '7'
            width = '100%' ).

    page->footer(
        )->overflow_toolbar(
            )->button(
                text  = 'Button with Badge'
                class = 'sapUiTinyMarginBeginEnd'
                icon  = 'sap-icon://cart' )->get(
                )->custom_data(
                    )->badge_custom_data(
                        key     = 'badge'
                        value   = '5'
                        visible = abap_true
            )->get_parent( )->get_parent(
            )->button(
                text    = 'Emphasized Button with Badge'
                type    = 'Emphasized'
                class   = 'sapUiTinyMarginBeginEnd'
                icon    = 'sap-icon://cart' )->get(
                )->custom_data(
                    )->badge_custom_data(
                        key     = 'badge'
                        value   = '23'
                        visible = abap_true
            )->get_parent( )->get_parent(
            )->toolbar_spacer(
            )->overflow_toolbar_button(
                text  = 'Clear'
                press = client->_event( 'BUTTON_CLEAR' )
                type  = 'Reject'
                icon  = 'sap-icon://delete'
            )->overflow_toolbar_button(
                text  = 'Send to Server'
                press = client->_event( 'BUTTON_SEND' )
                type  = 'Success' ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.
ENDCLASS.

CLASS z2ui5_cl_demo_app_060 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_currency,
        language          TYPE string,
        currency          TYPE string,
        currencyname      TYPE string,
        currencyshortname TYPE string,
      END OF ty_s_currency.


    TYPES temp1_f7eccf02fa TYPE STANDARD TABLE OF ty_s_currency.
DATA mt_suggestion_out TYPE temp1_f7eccf02fa.
    TYPES temp2_f7eccf02fa TYPE STANDARD TABLE OF ty_s_currency.
DATA mt_suggestion TYPE temp2_f7eccf02fa.
    DATA input TYPE string.

  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client.
    DATA check_initialized TYPE abap_bool.

    METHODS z2ui5_on_event.
    METHODS z2ui5_view_display.
    METHODS set_data.

  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_060 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      set_data( ).
      z2ui5_view_display( ).
    ENDIF.

    IF client->get( )-event IS NOT INITIAL.
      z2ui5_on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD z2ui5_on_event.
        TYPES temp3 TYPE RANGE OF string.
DATA lt_range TYPE temp3.
        DATA temp1 LIKE lt_range.
        DATA temp2 LIKE LINE OF temp1.
        DATA ls_sugg LIKE LINE OF mt_suggestion.

    CASE client->get( )-event.

      WHEN 'ON_SUGGEST'.

        

        
        CLEAR temp1.
        
        temp2-sign = 'I'.
        temp2-option = 'CP'.
        temp2-low = `*` && input && `*`.
        INSERT temp2 INTO TABLE temp1.
        lt_range = temp1.

        CLEAR mt_suggestion_out.
        
        LOOP AT mt_suggestion INTO ls_sugg
            WHERE currencyname IN lt_range.
          INSERT ls_sugg INTO TABLE mt_suggestion_out.
        ENDLOOP.

*        SELECT FROM i_currencytext
*          FIELDS *
*          WHERE currencyname IN @lt_range
*          AND  language = 'E'
*          INTO CORRESPONDING FIELDS OF TABLE @mt_suggestion.

        client->view_model_update( ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_view_display.

    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA temp1 TYPE xsdboolean.
    DATA grid TYPE REF TO z2ui5_cl_xml_view.
    DATA input TYPE REF TO z2ui5_cl_xml_view.
    temp1 = boolc( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ).
    page = z2ui5_cl_xml_view=>factory( )->shell( )->page(
       title          = 'abap2UI5 - Live Suggestion Event'
       navbuttonpress = client->_event( 'BACK' )
       shownavbutton = temp1 ).

    page->header_content(
             )->link( text = 'Demo'        target = '_blank' href = `https://twitter.com/abap2UI5/status/1675074394710765568`
             )->link( text = 'Source_Code' target = '_blank'
         )->get_parent( ).

    
    grid = page->grid( 'L6 M12 S12'
        )->content( 'layout' ).

    
    input = grid->simple_form( 'Input'
        )->content( 'form'
            )->label( 'Input with value help'
            )->input(
                    value           = client->_bind_edit( input )
                    suggest         = client->_event( 'ON_SUGGEST' )
                    showtablesuggestionvaluehelp = abap_false
                    suggestionrows  = client->_bind( mt_suggestion_out )
                    showsuggestion  = abap_true
                    valueliveupdate = abap_true
                    autocomplete    = abap_false
                 )->get( ).

    input->suggestion_columns(
        )->column( )->label( text = 'Name' )->get_parent(
        )->column( )->label( text = 'Currency' ).

    input->suggestion_rows(
        )->column_list_item(
            )->label( text = '{CURRENCYNAME}'
            )->label( text = '{CURRENCY}' ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.

  METHOD set_data.

    TYPES:
      BEGIN OF ty_s_currency,
        language          TYPE string,
        currency          TYPE string,
        currencyname      TYPE string,
        currencyshortname TYPE string,
      END OF ty_s_currency.

    DATA temp3 LIKE mt_suggestion.
    DATA temp4 LIKE LINE OF temp3.
    CLEAR temp3.
    
    temp4-language = 'E'.
    temp4-currency = 'ADP'.
    temp4-currencyname = 'Andorran Peseta --> (Old --> EUR)'.
    temp4-currencyshortname = 'Peseta'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'AED'.
    temp4-currencyname = 'United Arab Emirates Dirham'.
    temp4-currencyshortname = 'Dirham'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'AFA'.
    temp4-currencyname = 'Afghani (Old)'.
    temp4-currencyshortname = 'Afghani'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'AFN'.
    temp4-currencyname = 'Afghani'.
    temp4-currencyshortname = 'Afghani'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'ALL'.
    temp4-currencyname = 'Albanian Lek'.
    temp4-currencyshortname = 'Lek'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'AMD'.
    temp4-currencyname = 'Armenian Dram'.
    temp4-currencyshortname = 'Dram'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'ANG'.
    temp4-currencyname = 'West Indian Guilder'.
    temp4-currencyshortname = 'W.Ind.Guilder'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'AOA'.
    temp4-currencyname = 'Angolanische Kwanza'.
    temp4-currencyshortname = 'Kwansa'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'AON'.
    temp4-currencyname = 'Angolan New Kwanza (Old)'.
    temp4-currencyshortname = 'New Kwanza'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'AOR'.
    temp4-currencyname = 'Angolan Kwanza Reajustado (Old)'.
    temp4-currencyshortname = 'Kwanza Reajust.'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'ARS'.
    temp4-currencyname = 'Argentine Peso'.
    temp4-currencyshortname = 'Arg. Peso'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'ATS'.
    temp4-currencyname = 'Austrian Schilling (Old --> EUR)'.
    temp4-currencyshortname = 'Shilling'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'AUD'.
    temp4-currencyname = 'Australian Dollar'.
    temp4-currencyshortname = 'Austr. Dollar'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'AWG'.
    temp4-currencyname = 'Aruban Florin'.
    temp4-currencyshortname = 'Aruban Florin'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'AZM'.
    temp4-currencyname = 'Azerbaijani Manat (Old)'.
    temp4-currencyshortname = 'Manat'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'AZN'.
    temp4-currencyname = 'Azerbaijani Manat'.
    temp4-currencyshortname = 'Manat'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'BAM'.
    temp4-currencyname = 'Bosnia and Herzegovina Convertible Mark'.
    temp4-currencyshortname = 'Convert. Mark'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'BBD'.
    temp4-currencyname = 'Barbados Dollar'.
    temp4-currencyshortname = 'Dollar'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'BDT'.
    temp4-currencyname = 'Bangladesh Taka'.
    temp4-currencyshortname = 'Taka'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'BEF'.
    temp4-currencyname = 'Belgian Franc (Old --> EUR)'.
    temp4-currencyshortname = 'Belgian Franc'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'BGN'.
    temp4-currencyname = 'Bulgarian Lev'.
    temp4-currencyshortname = 'Lev'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'BHD'.
    temp4-currencyname = 'Bahraini Dinar'.
    temp4-currencyshortname = 'Dinar'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'BIF'.
    temp4-currencyname = 'Burundi Franc'.
    temp4-currencyshortname = 'Burundi Franc'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'BMD'.
    temp4-currencyname = 'Bermudan Dollar'.
    temp4-currencyshortname = 'Bermudan Dollar'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'BND'.
    temp4-currencyname = 'Brunei Dollar'.
    temp4-currencyshortname = 'Dollar'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'BOB'.
    temp4-currencyname = 'Boliviano'.
    temp4-currencyshortname = 'Boliviano'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'BRL'.
    temp4-currencyname = 'Brazilian Real'.
    temp4-currencyshortname = 'Real'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'BSD'.
    temp4-currencyname = 'Bahaman Dollar'.
    temp4-currencyshortname = 'Dollar'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'BTN'.
    temp4-currencyname = 'Bhutan Ngultrum'.
    temp4-currencyshortname = 'Ngultrum'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'BWP'.
    temp4-currencyname = 'Botswana Pula'.
    temp4-currencyshortname = 'Pula'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'BYB'.
    temp4-currencyname = 'Belarusian Ruble (Old)'.
    temp4-currencyshortname = 'Belarus. Ruble'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'BYN'.
    temp4-currencyname = 'Belarusian Ruble (New)'.
    temp4-currencyshortname = 'Bela. Ruble N.'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'BYR'.
    temp4-currencyname = 'Belarusian Ruble'.
    temp4-currencyshortname = 'Ruble'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'BZD'.
    temp4-currencyname = 'Belize Dollar'.
    temp4-currencyshortname = 'Dollar'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'CAD'.
    temp4-currencyname = 'Canadian Dollar'.
    temp4-currencyshortname = 'Canadian Dollar'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'CDF'.
    temp4-currencyname = 'Congolese Franc'.
    temp4-currencyshortname = 'test data'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'CFP'.
    temp4-currencyname = 'French Franc (Pacific Islands)'.
    temp4-currencyshortname = 'Fr. Franc (Pac)'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'CHF'.
    temp4-currencyname = 'Swiss Franc'.
    temp4-currencyshortname = 'Swiss Franc'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'CLP'.
    temp4-currencyname = 'Chilean Peso'.
    temp4-currencyshortname = 'Peso'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'CNY'.
    temp4-currencyname = 'Chinese Renminbi'.
    temp4-currencyshortname = 'Renminbi'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'COP'.
    temp4-currencyname = 'Colombian Peso'.
    temp4-currencyshortname = 'Peso'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'CRC'.
    temp4-currencyname = 'Costa Rica Colon'.
    temp4-currencyshortname = 'Cost.Rica Colon'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'CSD'.
    temp4-currencyname = 'Serbian Dinar (Old)'.
    temp4-currencyshortname = 'Serbian Dinar'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'CUC'.
    temp4-currencyname = 'Peso Convertible'.
    temp4-currencyshortname = 'Peso Convertib.'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'CUP'.
    temp4-currencyname = 'Cuban Peso'.
    temp4-currencyshortname = 'Cuban Peso'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'CVE'.
    temp4-currencyname = 'Cape Verde Escudo'.
    temp4-currencyshortname = 'Escudo'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'CYP'.
    temp4-currencyname = 'Cyprus Pound  (Old --> EUR)'.
    temp4-currencyshortname = 'Cyprus Pound'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'CZK'.
    temp4-currencyname = 'Czech Krona'.
    temp4-currencyshortname = 'Krona'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'DEM'.
    temp4-currencyname = 'German Mark    (Old --> EUR)'.
    temp4-currencyshortname = 'German Mark'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'DEM3'.
    temp4-currencyname = '(Internal) German Mark (3 dec.places)'.
    temp4-currencyshortname = '(Int.) DEM 3 DP'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'DJF'.
    temp4-currencyname = 'Djibouti Franc'.
    temp4-currencyshortname = 'Djibouti Franc'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'DKK'.
    temp4-currencyname = 'Danish Krone'.
    temp4-currencyshortname = 'Danish Krone'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'DOP'.
    temp4-currencyname = 'Dominican Peso'.
    temp4-currencyshortname = 'Dominican Peso'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'DZD'.
    temp4-currencyname = 'Algerian Dinar'.
    temp4-currencyshortname = 'Dinar'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'ECS'.
    temp4-currencyname = 'Ecuadorian Sucre (Old --> USD)'.
    temp4-currencyshortname = 'Sucre'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'EEK'.
    temp4-currencyname = 'Estonian Krone (Old --> EUR)'.
    temp4-currencyshortname = 'Krona'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'EGP'.
    temp4-currencyname = 'Egyptian Pound'.
    temp4-currencyshortname = 'Pound'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'ERN'.
    temp4-currencyname = 'Eritrean Nafka'.
    temp4-currencyshortname = 'Nakfa'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'ESP'.
    temp4-currencyname = 'Spanish Peseta (Old --> EUR)'.
    temp4-currencyshortname = 'Peseta'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'ETB'.
    temp4-currencyname = 'Ethiopian Birr'.
    temp4-currencyshortname = 'Birr'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'EUR'.
    temp4-currencyname = 'European Euro'.
    temp4-currencyshortname = 'Euro'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'FIM'.
    temp4-currencyname = 'Finnish Markka (Old --> EUR)'.
    temp4-currencyshortname = 'Finnish markka'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'FJD'.
    temp4-currencyname = 'Fiji Dollar'.
    temp4-currencyshortname = 'Dollar'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'FKP'.
    temp4-currencyname = 'Falkland Pound'.
    temp4-currencyshortname = 'Falkland Pound'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'FRF'.
    temp4-currencyname = 'French Franc (Old --> EUR)'.
    temp4-currencyshortname = 'French Franc'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'GBP'.
    temp4-currencyname = 'British Pound'.
    temp4-currencyshortname = 'Pound sterling'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'GEL'.
    temp4-currencyname = 'Georgian Lari'.
    temp4-currencyshortname = 'Lari'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'GHC'.
    temp4-currencyname = 'Ghanaian Cedi (Old)'.
    temp4-currencyshortname = 'Cedi'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'GHS'.
    temp4-currencyname = 'Ghanian Cedi'.
    temp4-currencyshortname = 'Cedi'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'GIP'.
    temp4-currencyname = 'Gibraltar Pound'.
    temp4-currencyshortname = 'Gibraltar Pound'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'GMD'.
    temp4-currencyname = 'Gambian Dalasi'.
    temp4-currencyshortname = 'Dalasi'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'GNF'.
    temp4-currencyname = 'Guinean Franc'.
    temp4-currencyshortname = 'Franc'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'GRD'.
    temp4-currencyname = 'Greek Drachma (Old --> EUR)'.
    temp4-currencyshortname = 'Drachma'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'GTQ'.
    temp4-currencyname = 'Guatemalan Quetzal'.
    temp4-currencyshortname = 'Quetzal'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'GWP'.
    temp4-currencyname = 'Guinea Peso (Old --> SHP)'.
    temp4-currencyshortname = 'Guinea Peso'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'GYD'.
    temp4-currencyname = 'Guyana Dollar'.
    temp4-currencyshortname = 'Guyana Dollar'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'HKD'.
    temp4-currencyname = 'Hong Kong Dollar'.
    temp4-currencyshortname = 'H.K.Dollar'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'HNL'.
    temp4-currencyname = 'Honduran Lempira'.
    temp4-currencyshortname = 'Lempira'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'HRK'.
    temp4-currencyname = 'Croatian Kuna'.
    temp4-currencyshortname = 'Kuna'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'HTG'.
    temp4-currencyname = 'Haitian Gourde'.
    temp4-currencyshortname = 'Gourde'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'HUF'.
    temp4-currencyname = 'Hungarian Forint'.
    temp4-currencyshortname = 'Forint'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'IDR'.
    temp4-currencyname = 'Indonesian Rupiah'.
    temp4-currencyshortname = 'Rupiah'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'IEP'.
    temp4-currencyname = 'Irish Punt (Old --> EUR)'.
    temp4-currencyshortname = 'Irish Punt'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'ILS'.
    temp4-currencyname = 'Israeli Scheckel'.
    temp4-currencyshortname = 'Scheckel'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'INR'.
    temp4-currencyname = 'Indian Rupee'.
    temp4-currencyshortname = 'Rupee'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'IQD'.
    temp4-currencyname = 'Iraqui Dinar'.
    temp4-currencyshortname = 'Dinar'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'IRR'.
    temp4-currencyname = 'Iranian Rial'.
    temp4-currencyshortname = 'Rial'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'ISK'.
    temp4-currencyname = 'Iceland Krona'.
    temp4-currencyshortname = 'Krona'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'ITL'.
    temp4-currencyname = 'Italian Lira (Old --> EUR)'.
    temp4-currencyshortname = 'Lire'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'JMD'.
    temp4-currencyname = 'Jamaican Dollar'.
    temp4-currencyshortname = 'Jamaican Dollar'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'JOD'.
    temp4-currencyname = 'Jordanian Dinar'.
    temp4-currencyshortname = 'Jordanian Dinar'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'JPY'.
    temp4-currencyname = 'Japanese Yen'.
    temp4-currencyshortname = 'Yen'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'KES'.
    temp4-currencyname = 'Kenyan Shilling'.
    temp4-currencyshortname = 'Shilling'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'KGS'.
    temp4-currencyname = 'Kyrgyzstan Som'.
    temp4-currencyshortname = 'Som'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'KHR'.
    temp4-currencyname = 'Cambodian Riel'.
    temp4-currencyshortname = 'Riel'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'KMF'.
    temp4-currencyname = 'Comoros Franc'.
    temp4-currencyshortname = 'Comoros Franc'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'KPW'.
    temp4-currencyname = 'North Korean Won'.
    temp4-currencyshortname = 'N. Korean Won'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'KRW'.
    temp4-currencyname = 'South Korean Won'.
    temp4-currencyshortname = 'S.Korean Won'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'KWD'.
    temp4-currencyname = 'Kuwaiti Dinar'.
    temp4-currencyshortname = 'Dinar'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'KYD'.
    temp4-currencyname = 'Cayman Dollar'.
    temp4-currencyshortname = 'Cayman Dollar'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'KZT'.
    temp4-currencyname = 'Kazakstanian Tenge'.
    temp4-currencyshortname = 'Tenge'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'LAK'.
    temp4-currencyname = 'Laotian Kip'.
    temp4-currencyshortname = 'Kip'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'LBP'.
    temp4-currencyname = 'Lebanese Pound'.
    temp4-currencyshortname = 'Lebanese Pound'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'LKR'.
    temp4-currencyname = 'Sri Lankan Rupee'.
    temp4-currencyshortname = 'Sri Lanka Rupee'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'LRD'.
    temp4-currencyname = 'Liberian Dollar'.
    temp4-currencyshortname = 'Liberian Dollar'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'LSL'.
    temp4-currencyname = 'Lesotho Loti'.
    temp4-currencyshortname = 'Loti'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'LTL'.
    temp4-currencyname = 'Lithuanian Lita'.
    temp4-currencyshortname = 'Lita'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'LUF'.
    temp4-currencyname = 'Luxembourg Franc (Old --> EUR)'.
    temp4-currencyshortname = 'Lux. Franc'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'LVL'.
    temp4-currencyname = 'Latvian Lat'.
    temp4-currencyshortname = 'Lat'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'LYD'.
    temp4-currencyname = 'Libyan Dinar'.
    temp4-currencyshortname = 'Libyan Dinar'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'MAD'.
    temp4-currencyname = 'Moroccan Dirham'.
    temp4-currencyshortname = 'Dirham'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'MDL'.
    temp4-currencyname = 'Moldavian Leu'.
    temp4-currencyshortname = 'Leu'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'MGA'.
    temp4-currencyname = 'Madagascan Ariary'.
    temp4-currencyshortname = 'Madagasc.Ariary'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'MGF'.
    temp4-currencyname = 'Madagascan Franc (Old'.
    temp4-currencyshortname = 'Madagascan Fr.'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'MKD'.
    temp4-currencyname = 'Macedonian Denar'.
    temp4-currencyshortname = 'Maced. Denar'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'MMK'.
    temp4-currencyname = 'Myanmar Kyat'.
    temp4-currencyshortname = 'Kyat'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'MNT'.
    temp4-currencyname = 'Mongolian Tugrik'.
    temp4-currencyshortname = 'Tugrik'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'MOP'.
    temp4-currencyname = 'Macao Pataca'.
    temp4-currencyshortname = 'Pataca'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'MRO'.
    temp4-currencyname = 'Mauritanian Ouguiya'.
    temp4-currencyshortname = 'Ouguiya'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'MTL'.
    temp4-currencyname = 'Maltese Lira (Old --> EUR)'.
    temp4-currencyshortname = 'Lira'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'MUR'.
    temp4-currencyname = 'Mauritian Rupee'.
    temp4-currencyshortname = 'Rupee'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'MVR'.
    temp4-currencyname = 'Maldive Rufiyaa'.
    temp4-currencyshortname = 'Rufiyaa'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'MWK'.
    temp4-currencyname = 'Malawi Kwacha'.
    temp4-currencyshortname = 'Malawi Kwacha'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'MXN'.
    temp4-currencyname = 'Mexican Pesos'.
    temp4-currencyshortname = 'Peso'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'MYR'.
    temp4-currencyname = 'Malaysian Ringgit'.
    temp4-currencyshortname = 'Ringgit'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'MZM'.
    temp4-currencyname = 'Mozambique Metical (Old)'.
    temp4-currencyshortname = 'Metical'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'MZN'.
    temp4-currencyname = 'Mozambique Metical'.
    temp4-currencyshortname = 'Metical'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'NAD'.
    temp4-currencyname = 'Namibian Dollar'.
    temp4-currencyshortname = 'Namibian Dollar'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'NGN'.
    temp4-currencyname = 'Nigerian Naira'.
    temp4-currencyshortname = 'Naira'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'NIO'.
    temp4-currencyname = 'Nicaraguan Cordoba Oro'.
    temp4-currencyshortname = 'Cordoba Oro'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'NLG'.
    temp4-currencyname = 'Dutch Guilder (Old --> EUR)'.
    temp4-currencyshortname = 'Guilder'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'NOK'.
    temp4-currencyname = 'Norwegian Krone'.
    temp4-currencyshortname = 'Norwegian Krone'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'NPR'.
    temp4-currencyname = 'Nepalese Rupee'.
    temp4-currencyshortname = 'Rupee'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'NZD'.
    temp4-currencyname = 'New Zealand Dollars'.
    temp4-currencyshortname = 'N.Zeal.Dollars'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'OMR'.
    temp4-currencyname = 'Omani Rial'.
    temp4-currencyshortname = 'Omani Rial'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'PAB'.
    temp4-currencyname = 'Panamanian Balboa'.
    temp4-currencyshortname = 'Balboa'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'PEN'.
    temp4-currencyname = 'Peruvian New Sol'.
    temp4-currencyshortname = 'New Sol'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'PGK'.
    temp4-currencyname = 'Papua New Guinea Kina'.
    temp4-currencyshortname = 'Kina'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'PHP'.
    temp4-currencyname = 'Philippine Peso'.
    temp4-currencyshortname = 'Peso'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'PKR'.
    temp4-currencyname = 'Pakistani Rupee'.
    temp4-currencyshortname = 'Rupee'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'PLN'.
    temp4-currencyname = 'Polish Zloty (new)'.
    temp4-currencyshortname = 'Zloty'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'PTE'.
    temp4-currencyname = 'Portuguese Escudo (Old --> EUR)'.
    temp4-currencyshortname = 'Escudo'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'PYG'.
    temp4-currencyname = 'Paraguayan Guarani'.
    temp4-currencyshortname = 'Guarani'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'QAR'.
    temp4-currencyname = 'Qatar Rial'.
    temp4-currencyshortname = 'Rial'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'RMB'.
    temp4-currencyname = 'Chinese Yuan Renminbi'.
    temp4-currencyshortname = 'Yuan Renminbi'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'ROL'.
    temp4-currencyname = 'Romanian Leu (Old)'.
    temp4-currencyshortname = 'Leu (Old)'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'RON'.
    temp4-currencyname = 'Romanian Leu'.
    temp4-currencyshortname = 'Leu'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'RSD'.
    temp4-currencyname = 'Serbian Dinar'.
    temp4-currencyshortname = 'Serbian Dinar'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'RUB'.
    temp4-currencyname = 'Russian Ruble'.
    temp4-currencyshortname = 'Ruble'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'RWF'.
    temp4-currencyname = 'Rwandan Franc'.
    temp4-currencyshortname = 'Franc'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'SAR'.
    temp4-currencyname = 'Saudi Riyal'.
    temp4-currencyshortname = 'Rial'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'SBD'.
    temp4-currencyname = 'Solomon Islands Dollar'.
    temp4-currencyshortname = 'Sol.Isl.Dollar'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'SCR'.
    temp4-currencyname = 'Seychelles Rupee'.
    temp4-currencyshortname = 'Rupee'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'SDD'.
    temp4-currencyname = 'Sudanese Dinar (Old)'.
    temp4-currencyshortname = 'Dinar'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'SDG'.
    temp4-currencyname = 'Sudanese Pound'.
    temp4-currencyshortname = 'Pound'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'SDP'.
    temp4-currencyname = 'Sudanese Pound (until 1992)'.
    temp4-currencyshortname = 'Pound'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'SEK'.
    temp4-currencyname = 'Swedish Krona'.
    temp4-currencyshortname = 'Swedish Krona'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'SGD'.
    temp4-currencyname = 'Singapore Dollar'.
    temp4-currencyshortname = 'Sing.Dollar'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'SHP'.
    temp4-currencyname = 'St.Helena Pound'.
    temp4-currencyshortname = 'St.Helena Pound'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'SIT'.
    temp4-currencyname = 'Slovenian Tolar (Old --> EUR)'.
    temp4-currencyshortname = 'Tolar'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'SKK'.
    temp4-currencyname = 'Slovakian Krona (Old --> EUR)'.
    temp4-currencyshortname = 'Krona'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'SLL'.
    temp4-currencyname = 'Sierra Leone Leone'.
    temp4-currencyshortname = 'Leone'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'SOS'.
    temp4-currencyname = 'Somalian Shilling'.
    temp4-currencyshortname = 'Shilling'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'SRD'.
    temp4-currencyname = 'Surinam Dollar'.
    temp4-currencyshortname = 'Surinam Doillar'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'SRG'.
    temp4-currencyname = 'Surinam Guilder (Old)'.
    temp4-currencyshortname = 'Surinam Guilder'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'SSP'.
    temp4-currencyname = 'South Sudanese Pound'.
    temp4-currencyshortname = 'Pound'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'STD'.
    temp4-currencyname = 'Sao Tome / Principe Dobra'.
    temp4-currencyshortname = 'Dobra'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'SVC'.
    temp4-currencyname = 'El Salvador Colon'.
    temp4-currencyshortname = 'Colon'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'SYP'.
    temp4-currencyname = 'Syrian Pound'.
    temp4-currencyshortname = 'Syrian Pound'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'SZL'.
    temp4-currencyname = 'Swaziland Lilangeni'.
    temp4-currencyshortname = 'Lilangeni'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'THB'.
    temp4-currencyname = 'Thailand Baht'.
    temp4-currencyshortname = 'Baht'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'TJR'.
    temp4-currencyname = 'Tajikistani Ruble (Old)'.
    temp4-currencyshortname = 'Ruble'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'TJS'.
    temp4-currencyname = 'Tajikistani Somoni'.
    temp4-currencyshortname = 'Somoni'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'TMM'.
    temp4-currencyname = 'Turkmenistani Manat (Old)'.
    temp4-currencyshortname = 'Manat (Old)'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'TMT'.
    temp4-currencyname = 'Turkmenistani Manat'.
    temp4-currencyshortname = 'Manat'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'TND'.
    temp4-currencyname = 'Tunisian Dinar'.
    temp4-currencyshortname = 'Dinar'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'TOP'.
    temp4-currencyname = 'Tongan Pa''anga'.
    temp4-currencyshortname = 'Pa''anga'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'TPE'.
    temp4-currencyname = 'Timor Escudo --> USD'.
    temp4-currencyshortname = 'Timor Escudo'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'TRL'.
    temp4-currencyname = 'Turkish Lira (Old)'.
    temp4-currencyshortname = 'Lira (Old)'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'TRY'.
    temp4-currencyname = 'Turkish Lira'.
    temp4-currencyshortname = 'Lira'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'TTD'.
    temp4-currencyname = 'Trinidad and Tobago Dollar'.
    temp4-currencyshortname = 'T.+ T. Dollar'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'TWD'.
    temp4-currencyname = 'New Taiwan Dollar'.
    temp4-currencyshortname = 'Dollar'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'TZS'.
    temp4-currencyname = 'Tanzanian Shilling'.
    temp4-currencyshortname = 'Shilling'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'UAH'.
    temp4-currencyname = 'Ukraine Hryvnia'.
    temp4-currencyshortname = 'Hryvnia'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'UGX'.
    temp4-currencyname = 'Ugandan Shilling'.
    temp4-currencyshortname = 'Shilling'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'USD'.
    temp4-currencyname = 'United States Dollar'.
    temp4-currencyshortname = 'US Dollar'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'USDN'.
    temp4-currencyname = '(Internal) United States Dollar (5 Dec.)'.
    temp4-currencyshortname = 'US Dollar'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'UYU'.
    temp4-currencyname = 'Uruguayan Peso'.
    temp4-currencyshortname = 'Peso'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'UZS'.
    temp4-currencyname = 'Uzbekistan Som'.
    temp4-currencyshortname = 'Total'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'VEB'.
    temp4-currencyname = 'Venezuelan Bolivar (Old)'.
    temp4-currencyshortname = 'Bolivar (Old)'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'VEF'.
    temp4-currencyname = 'Venezuelan Bolivar'.
    temp4-currencyshortname = 'Bolivar'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'VND'.
    temp4-currencyname = 'Vietnamese Dong'.
    temp4-currencyshortname = 'Dong'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'VUV'.
    temp4-currencyname = 'Vanuatu Vatu'.
    temp4-currencyshortname = 'Vatu'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'WST'.
    temp4-currencyname = 'Samoan Tala'.
    temp4-currencyshortname = 'Tala'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'XAF'.
    temp4-currencyname = 'Gabon CFA Franc BEAC'.
    temp4-currencyshortname = 'CFA Franc BEAC'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'XCD'.
    temp4-currencyname = 'East Carribean Dollar'.
    temp4-currencyshortname = 'Dollar'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'XEU'.
    temp4-currencyname = 'European Currency Unit (E.C.U.)'.
    temp4-currencyshortname = 'E.C.U.'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'XOF'.
    temp4-currencyname = 'Benin CFA Franc BCEAO'.
    temp4-currencyshortname = 'CFA Franc BCEAO'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'XPF'.
    temp4-currencyname = 'CFP Franc'.
    temp4-currencyshortname = 'Franc'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'YER'.
    temp4-currencyname = 'Yemeni Ryal'.
    temp4-currencyshortname = 'Yemeni Ryal'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'YUM'.
    temp4-currencyname = 'New Yugoslavian Dinar (Old)'.
    temp4-currencyshortname = 'New Dinar'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'ZAR'.
    temp4-currencyname = 'South African Rand'.
    temp4-currencyshortname = 'Rand'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'ZMK'.
    temp4-currencyname = 'Zambian Kwacha (Old)'.
    temp4-currencyshortname = 'Kwacha'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'ZMW'.
    temp4-currencyname = 'Zambian Kwacha (New)'.
    temp4-currencyshortname = 'Kwacha'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'ZRN'.
    temp4-currencyname = 'Zaire (Old)'.
    temp4-currencyshortname = 'Zaire'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'ZWD'.
    temp4-currencyname = 'Zimbabwean Dollar (Old)'.
    temp4-currencyshortname = 'Zimbabwe Dollar'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'ZWL'.
    temp4-currencyname = 'Zimbabwean Dollar (New)'.
    temp4-currencyshortname = 'Zimbabwe Dollar'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'ZWN'.
    temp4-currencyname = 'Zimbabwean Dollar (Old)'.
    temp4-currencyshortname = 'Zimbabwe Dollar'.
    INSERT temp4 INTO TABLE temp3.
    temp4-language = 'E'.
    temp4-currency = 'ZWR'.
    temp4-currencyname = 'Zimbabwean Dollar (Old)'.
    temp4-currencyshortname = 'Zimbabwe Dollar'.
    INSERT temp4 INTO TABLE temp3.
    mt_suggestion = temp3.

  ENDMETHOD.

ENDCLASS.

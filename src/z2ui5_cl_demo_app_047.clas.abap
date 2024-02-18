CLASS z2ui5_cl_demo_app_047 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA int1    TYPE i.
    DATA int2    TYPE i.
    DATA int_sum TYPE i.

    DATA dec1    TYPE p LENGTH 10 DECIMALS 4.
    DATA dec2    TYPE p LENGTH 10 DECIMALS 4.
    DATA dec_sum TYPE p LENGTH 10 DECIMALS 4.

    DATA date    TYPE d.
    DATA time    TYPE t.

    TYPES:
      BEGIN OF ty_s_row,
        date TYPE d,
        time TYPE t,
      END OF ty_s_row.
    TYPES temp1_244327dede TYPE STANDARD TABLE OF ty_s_row WITH DEFAULT KEY.
DATA mt_tab TYPE temp1_244327dede.

    DATA check_initialized TYPE abap_bool.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_047 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.
      DATA temp1 LIKE mt_tab.
      DATA temp2 LIKE LINE OF temp1.
    DATA temp3 TYPE xsdboolean.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      date = sy-datum.
      time = sy-uzeit.
      dec1 = -1 / 3.

      
      CLEAR temp1.
      
      temp2-date = sy-datum.
      temp2-time = sy-uzeit.
      INSERT temp2 INTO TABLE temp1.
      mt_tab = temp1.
      client->_bind_edit( mt_tab ).
    ENDIF.

    CASE client->get( )-event.
      WHEN 'BUTTON_INT'.
        int_sum = int1 + int2.
      WHEN 'BUTTON_DEC'.
        dec_sum = dec1 + dec2.
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack  ) ).
    ENDCASE.

    
    temp3 = boolc( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ).
    client->view_display( z2ui5_cl_xml_view=>factory( )->shell(
        )->page(
                title          = 'abap2UI5 - Integer and Decimals'
                navbuttonpress = client->_event( 'BACK' )
                shownavbutton = temp3
            )->header_content(
                )->link(
                    text = 'Source_Code'
                    href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
                    target = '_blank'
            )->get_parent(
            )->simple_form( title = 'Integer and Decimals' editable = abap_true
                )->content( 'form'
                    )->title( 'Input'
                    )->label( 'integer'
                    )->input( value = client->_bind_edit( int1 )
                    )->input( value = client->_bind_edit( int2 )
                    )->input( enabled = abap_false value = client->_bind_edit( int_sum )
                    )->button( text  = 'calc sum' press = client->_event( 'BUTTON_INT' )
                    )->label( 'decimals'
                    )->input( client->_bind_edit( dec1 )
                    )->input( client->_bind_edit( dec2 )
                    )->input( enabled = abap_false value = client->_bind_edit( dec_sum )
                    )->button( text  = 'calc sum' press = client->_event( 'BUTTON_DEC' )
                    )->label( 'date'
                    )->input( client->_bind_edit( date )
                    )->label( 'time'
                    )->input( client->_bind_edit( time )
               )->stringify( ) ).

  ENDMETHOD.
ENDCLASS.

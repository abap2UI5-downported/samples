class Z2UI5_CL_DEMO_APP_210 definition
  public
  create public .

public section.

  interfaces IF_SERIALIZABLE_OBJECT .
  interfaces Z2UI5_IF_APP .

  data CHECK_INITIALIZED type ABAP_BOOL .
  PROTECTED SECTION.

    METHODS display_view
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS on_event
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_210 IMPLEMENTATION.


  METHOD DISPLAY_VIEW.

    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA temp1 TYPE xsdboolean.
    DATA layout TYPE REF TO z2ui5_cl_xml_view.
    temp1 = boolc( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ).
    page = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = 'abap2UI5 - Sample: Input - Types'
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton  = temp1 ).

    
    layout = page->vertical_layout( class  = `sapUiContentPadding` width = `100%` ).

    layout->label( text = `Text` labelfor = `inputText` ).
    layout->input( id = `inputText`
                   placeholder = `Enter text`
                   class = `sapUiSmallMarginBottom` ).

    layout->label( text = `Email` labelfor = `inputEmail` ).
    layout->input( id = `inputEmail`
                   type = `Email`
                   placeholder = `Enter email`
                   class = `sapUiSmallMarginBottom` ).

    layout->label( text = `Telephone` labelfor = `inputTel` ).
    layout->input( id = `inputTel`
                   type = `Tel`
                   placeholder = `Enter telephone number`
                   class = `sapUiSmallMarginBottom` ).

    layout->label( text = `Number` labelfor = `inputNumber` ).
    layout->input( id = `inputNumber`
                   type = `Number`
                   placeholder = `Enter a number`
                   class = `sapUiSmallMarginBottom` ).

    layout->label( text = `URL` labelfor = `inputUrl` ).
    layout->input( id = `inputUrl`
                   type = `Url`
                   placeholder = `Enter URL`
                   class = `sapUiSmallMarginBottom` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD ON_EVENT.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( ).
    ENDCASE.

  ENDMETHOD.


  METHOD Z2UI5_IF_APP~MAIN.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      display_view( client ).
    ENDIF.

    on_event( client ).

  ENDMETHOD.
ENDCLASS.

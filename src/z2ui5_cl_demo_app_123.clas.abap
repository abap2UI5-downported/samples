CLASS z2ui5_cl_demo_app_123 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app .

    TYPES:
      BEGIN OF ty_spot,
        tooltip       TYPE string,
        type          TYPE string,
        pos           TYPE string,
        scale         TYPE string,
        contentoffset TYPE string,
        key           TYPE string,
        icon          TYPE string,
      END OF ty_spot.
    TYPES temp1_d73221ca3a TYPE TABLE OF ty_spot.
DATA mt_spot TYPE temp1_d73221ca3a.

    DATA check_initialized TYPE abap_bool.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_123 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.
      DATA temp1 LIKE mt_spot.
      DATA temp2 LIKE LINE OF temp1.
    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA temp3 TYPE xsdboolean.


    IF check_initialized = abap_false.
      check_initialized = abap_true.

      
      CLEAR temp1.
      
      temp2-pos = `9.98336;53.55024;0`.
      temp2-contentoffset = `0;-6`.
      temp2-scale = `1;1;1`.
      temp2-key = `Hamburg`.
      temp2-tooltip = `Hamburg`.
      temp2-type = `Default`.
      temp2-icon = `factory`.
      INSERT temp2 INTO TABLE temp1.
      temp2-pos = `11.5820;48.1351;0`.
      temp2-contentoffset = `0;-5`.
      temp2-scale = `1;1;1`.
      temp2-key = `Munich`.
      temp2-tooltip = `Munich`.
      temp2-type = `Default`.
      temp2-icon = `factory`.
      INSERT temp2 INTO TABLE temp1.
      temp2-pos = `8.683340000;50.112000000;0`.
      temp2-contentoffset = `0;-6`.
      temp2-scale = `1;1;1`.
      temp2-key = `Frankfurt`.
      temp2-tooltip = `Frankfurt`.
      temp2-type = `Default`.
      temp2-icon = `factory`.
      INSERT temp2 INTO TABLE temp1.
      mt_spot = temp1.

    ENDIF.


    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack  ) ).
        RETURN.

    ENDCASE.


    
    view = z2ui5_cl_xml_view=>factory( ).
    
    temp3 = boolc( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ).
    client->view_display( view->shell(
          )->page(
                  title          = 'abap2UI5 - Map Container'
                  navbuttonpress = client->_event( val = 'BACK' )
                  shownavbutton = temp3
              )->header_content(
                  )->link(
                      text = 'Source_Code'
                      href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
                      target = '_blank'
              )->get_parent(
            )->map_container(  autoadjustheight = abap_true
                )->content( ns = `vk`
                    )->container_content(
                      title = `Analytic Map`
                      icon  = `sap-icon://geographic-bubble-chart`
                        )->content( ns = `vk`
                            )->analytic_map(
                              initialposition = `9.933573;50;0`
                              initialzoom = `6`
                            )->vos(
                                )->spots( client->_bind( mt_spot )
                                )->spot(
                                  position      = `{POS}`
                                  contentoffset = `{CONTENTOFFSET}`
                                  type          =  `{TYPE}`
                                  scale         =  `{SCALE}`
                                  tooltip       =  `{TOOLTIP}`
           )->stringify( ) ).

  ENDMETHOD.
ENDCLASS.

CLASS z2ui5_cl_demo_app_182 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF t_attributes3,
             label TYPE i,
             value TYPE string,
           END OF t_attributes3.
    TYPES: tt_attributes3 TYPE STANDARD TABLE OF t_attributes3 WITH DEFAULT KEY.
    TYPES: BEGIN OF t_nodes2,
             id         TYPE string,
             title      TYPE string,
             src        TYPE string,
             attributes TYPE tt_attributes3,
             team       TYPE i,
             supervisor TYPE string,
             location   TYPE string,
             position   TYPE string,
             email      TYPE string,
             phone      TYPE string,
           END OF t_nodes2.
    TYPES: BEGIN OF t_lines4,
             from TYPE string,
             to   TYPE string,
           END OF t_lines4.
    TYPES: tt_nodes2 TYPE STANDARD TABLE OF t_nodes2 WITH DEFAULT KEY.
    TYPES: tt_lines4 TYPE STANDARD TABLE OF t_lines4 WITH DEFAULT KEY.
    TYPES: BEGIN OF t_json1,
             nodes TYPE tt_nodes2,
             lines TYPE tt_lines4,
           END OF t_json1.

    DATA mv_initialized TYPE abap_bool .
    DATA mt_data TYPE t_json1 .

    METHODS on_event .
    METHODS view_display .
    METHODS detail_popover IMPORTING id TYPE string .
  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_182 IMPLEMENTATION.


  METHOD detail_popover.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    view = z2ui5_cl_xml_view=>factory_popup( ).
    view->quick_view( placement = `Left`
              )->quick_view_page( pageid = `employeePageId`
                                  header = `Employee Info`
                                  title  = `choper725`
                                  titleurl = `https://github.com/abap2UI5/abap2UI5`
                                  description = `Enjoy`
                            )->quick_view_group( heading = `Contact Details`
                              )->quick_view_group_element( label = `Mobile`
                                                           value = `123-456-789`
                                                           type = `mobile`
                                                         )->get_parent(
                              )->quick_view_group_element( label = `Phone`
                                                           value = `789-456-123`
                                                           type = `phone`
                                                         )->get_parent(
                              )->quick_view_group_element( label = `Email`
                                                           value = `thisisemail@email.com`
                                                           emailsubject = `Subject`
                                                           type = `email`
                                                         )->get_parent(
                              )->get_parent(
                           )->quick_view_group( heading = `Company`
                            )->quick_view_group_element( label = `Name`
                                                           value = `Adventure Company`
                                                           url = `https://github.com/abap2UI5/abap2UI5`
                                                           type = `link`
                                                         )->get_parent(
                            )->quick_view_group_element( label = `Address`
                                                           value = `Here"`
                                                         )->get_parent( ).


    client->popover_display(
      xml   = view->stringify( )
      by_id = id
    ).

  ENDMETHOD.


  METHOD on_event.
        DATA lt_arg TYPE string_table.
        DATA temp1 LIKE LINE OF lt_arg.
        DATA temp2 LIKE sy-tabix.

    CASE client->get( )-event.
      WHEN 'LINE_PRESS'.
        client->message_toast_display( 'LINE_PRESSED' ).

      WHEN 'DETAIL_POPOVER'.
        
        lt_arg = client->get( )-t_event_arg.

        
        
        temp2 = sy-tabix.
        READ TABLE lt_arg INDEX 1 INTO temp1.
        sy-tabix = temp2.
        IF sy-subrc <> 0.
          ASSERT 1 = 0.
        ENDIF.
        detail_popover( id = temp1 ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
        RETURN.
    ENDCASE.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA temp1 TYPE xsdboolean.
    DATA temp3 TYPE string_table.
    DATA graph TYPE REF TO z2ui5_cl_xml_view.
    view = z2ui5_cl_xml_view=>factory( ).
    
    
    temp1 = boolc( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ).
    page = view->shell( )->page(
                    title          = 'abap2UI5 - Network Graph - Org Tree'
                    navbuttonpress = client->_event( val = 'BACK' )
                    shownavbutton = temp1
              ).

    
    CLEAR temp3.
    INSERT `${$source>/id}` INTO TABLE temp3.
    
    graph = page->network_graph( enablewheelzoom = abap_false
                                       orientation = `TopBottom`
                                       nodes = client->_bind( mt_data-nodes )
                                       lines = client->_bind( mt_data-lines )
                                       layout = `Layered`
                                       searchsuggest = `suggest`
                                       search = `search`
                                       id = `graph`
                                     )->get( )->layout_algorithm( )->layered_layout( mergeedges = abap_true nodeplacement = `Simple` nodespacing = `40`
                                     )->get_parent(
                                     )->get_parent(
                                  )->nodes( ns = `networkgraph`
                                    )->node( icon = `sap-icon://action-settings`
                                             key  = `{ID}`
                                             description  = `{TITLE}`
                                             title  = `{TITLE}`
                                             width  = `90`
                                             collapsed  = `{COLLAPSED}`
                                             attributes  = `{ATTRIBUTES}`
*                                             actionbuttons  = `{ATTRIBUTES}`
                                             showactionlinksbutton  = abap_false
                                             showdetailbutton  = abap_false
                                             descriptionlinesize  = `0`
                                             shape  = `Box`
                                            )->get( )->custom_data( ns = `networkgraph` )->core_custom_data( key = `supervisor` value = `{SUPERVISOR}`
                                                                                        )->core_custom_data( key = `team` value = `{TEAM}`
                                                                                        )->core_custom_data( key = `location` value = `{LOCATION}`
                                                                                        )->core_custom_data( key = `position` value = `{POSITION}`
                                                                                        )->core_custom_data( key = `team` value = `{TEAM}`
                                                                                        )->core_custom_data( key = `email` value = `{EMAIL}`
                                                                                        )->core_custom_data( key = `phone` value = `{PHONE}`
                                           )->get_parent(
                                           )->get( )->get_parent( )->get_parent( )->attributes( ns = `networkgraph`
                                            )->element_attribute( label = `{LABEL}` value = `{VALUE}`
                                           )->get_parent(
                                           )->get_parent(
                                           )->get( )->get_parent( )->get_parent( )->action_buttons(
                                            )->action_button( "id = `{ID}`
                                                              position = `Left`
                                                              title = `Detail`
                                                              icon = `sap-icon://employee`
                                                              press = client->_event( val = `DETAIL_POPOVER` t_arg = temp3 )
*                                                              press = client->_event( val = `DETAIL_POPOVER` t_arg = VALUE #( ( `${$parameters>/buttonElement}` ) ) )
                                           )->get_parent(
                                           )->get_parent(
                                           )->get( )->get_parent( )->get_parent( )->_generic( ns = `networkgraph` name = `image`
                                            )->node_image( src = `{SRC}`
                                                           width = `80`
                                                           height = `100`
                                                          )->get_parent(
                                                       )->get_parent(
                                                )->get_parent(
                                          )->get_parent(
                                          )->lines(
                                            )->line( from = `{FROM}`
                                                     to   = `{TO}`
                                                     arroworientation = `None`
                                                     press = client->_event( `LINE_PRESS` )


    ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.
      DATA temp1 TYPE z2ui5_cl_demo_app_182=>tt_nodes2.
      DATA temp2 LIKE LINE OF temp1.
      DATA temp5 TYPE z2ui5_cl_demo_app_182=>tt_attributes3.
      DATA temp6 LIKE LINE OF temp5.
      DATA temp7 TYPE z2ui5_cl_demo_app_182=>tt_attributes3.
      DATA temp8 LIKE LINE OF temp7.
      DATA temp9 TYPE z2ui5_cl_demo_app_182=>tt_attributes3.
      DATA temp10 LIKE LINE OF temp9.
      DATA temp3 TYPE z2ui5_cl_demo_app_182=>tt_lines4.
      DATA temp4 LIKE LINE OF temp3.

    me->client = client.

    IF mv_initialized = abap_false.
      mv_initialized = abap_true.

      CLEAR mt_data.
      
      CLEAR temp1.
      
      temp2-id = `Dinter`.
      temp2-title = `Sophie Dinter`.
      temp2-src = ``.
      
      CLEAR temp5.
      
      temp6-label = 35.
      temp6-value = ``.
      INSERT temp6 INTO TABLE temp5.
      temp2-attributes = temp5.
      temp2-team = 13.
      temp2-location = `Walldorf`.
      temp2-position = `lobal Solutions Manager`.
      temp2-email = `sophie.dinter@example.com`.
      temp2-phone = `+000 423 230 000`.
      INSERT temp2 INTO TABLE temp1.
      temp2-id = `Ninsei`.
      temp2-title = `Yamasaki Ninsei`.
      temp2-src = ``.
      
      CLEAR temp7.
      
      temp8-label = 9.
      temp8-value = ``.
      INSERT temp8 INTO TABLE temp7.
      temp2-attributes = temp7.
      temp2-supervisor = `Dinter`.
      temp2-team = 9.
      temp2-location = `Walldorf`.
      temp2-position = `Lead Markets Manage`.
      temp2-email = `yamasaki.ninsei@example.com`.
      temp2-phone = `+000 423 230 002`.
      INSERT temp2 INTO TABLE temp1.
      temp2-id = `Mills`.
      temp2-title = `Henry Mills`.
      temp2-src = ``.
      
      CLEAR temp9.
      
      temp10-label = 4.
      temp10-value = ``.
      INSERT temp10 INTO TABLE temp9.
      temp2-attributes = temp9.
      temp2-supervisor = `Ninsei`.
      temp2-team = 4.
      temp2-location = `Praha`.
      temp2-position = `Sales Manager`.
      temp2-email = `henry.mills@example.com`.
      temp2-phone = `+000 423 232 003`.
      INSERT temp2 INTO TABLE temp1.
      temp2-id = `Polak`.
      temp2-title = `Adam Polak`.
      temp2-src = ``.
      temp2-supervisor = `Mills`.
      temp2-team = 4.
      temp2-location = `Praha`.
      temp2-position = `Marketing Specialist`.
      temp2-email = `adam.polak@example.com`.
      temp2-phone = `+000 423 232 004`.
      INSERT temp2 INTO TABLE temp1.
      temp2-id = `Sykorova`.
      temp2-title = `Vlasta Sykorova`.
      temp2-src = ``.
      temp2-supervisor = `Mills`.
      temp2-team = 4.
      temp2-location = `Praha`.
      temp2-position = `Human Assurance Officer`.
      temp2-email = `vlasta.sykorova@example.com`.
      temp2-phone = `+000 423 232 005`.
      INSERT temp2 INTO TABLE temp1.
      mt_data-nodes = temp1.
      
      CLEAR temp3.
      
      temp4-from = `Dinter`.
      temp4-to = `Ninsei`.
      INSERT temp4 INTO TABLE temp3.
      temp4-from = `Ninsei`.
      temp4-to = `Mills`.
      INSERT temp4 INTO TABLE temp3.
      temp4-from = `Mills`.
      temp4-to = `Polak`.
      INSERT temp4 INTO TABLE temp3.
      temp4-from = `Mills`.
      temp4-to = `Sykorova`.
      INSERT temp4 INTO TABLE temp3.
      mt_data-lines = temp3.

      view_display( ).

    ENDIF.

    on_event( ).

  ENDMETHOD.
ENDCLASS.

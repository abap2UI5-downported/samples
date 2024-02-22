CLASS z2ui5_cl_demo_app_173 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_serializable_object .
    INTERFACES z2ui5_if_app .

    TYPES: BEGIN OF ty_s_data,
             name TYPE string,
           END OF ty_s_data,
           ty_t_data TYPE STANDARD TABLE OF ty_s_data WITH DEFAULT KEY.

    DATA mt_data TYPE ty_t_data.
    DATA client TYPE REF TO z2ui5_if_client .

  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS render_main.
ENDCLASS.



CLASS z2ui5_cl_demo_app_173 IMPLEMENTATION.



  METHOD z2ui5_if_app~main.
      DATA temp1 TYPE z2ui5_cl_demo_app_173=>ty_t_data.
      DATA temp2 LIKE LINE OF temp1.

    me->client = client.

    IF client->get( )-check_on_navigated = abap_true.

      
      CLEAR temp1.
      
      temp2-name = 'Theo'.
      INSERT temp2 INTO TABLE temp1.
      temp2-name = 'Lore'.
      INSERT temp2 INTO TABLE temp1.
      mt_data = temp1.

      client->_bind( mt_data  ).

      render_main( ).

    ENDIF.

  ENDMETHOD.

  METHOD render_main.

    DATA xml TYPE string.
    xml =
    '<mvc:View xmlns="sap.m" xmlns:mvc="sap.ui.core.mvc" xmlns:template="http://schemas.sap.com/sapui5/extension/sap.ui.core.template/1">' &&
    '   <App>                                                                                                                            ' &&
    '     <Page title="XML Templating">                                                                                                  ' &&
    '       <OverflowToolbar>                                                                                                            ' &&
    '         <ToolbarSpacer />                                                                                                          ' &&
    '         <template:repeat list="{meta>/MT_DATA}" var="MT_DATA">                                                                     ' &&
    '           <ToggleButton text="{MT_DATA>NAME}" />                                                                                   ' &&
    '         </template:repeat>                                                                                                         ' &&
    '         <ToolbarSpacer />                                                                                                          ' &&
    '         <OverflowToolbarButton icon="sap-icon://action-settings" />                                                                ' &&
    '      </OverflowToolbar>                                                                                                            ' &&
    '     </Page>                                                                                                                        ' &&
    '   </App>                                                                                                                           ' &&
    '</mvc:View>'.

    client->view_display( xml ).


  ENDMETHOD.

ENDCLASS.

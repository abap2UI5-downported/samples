CLASS z2ui5_cl_demo_app_173 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_data,
        name TYPE string,
        DATE type string,
        AGE  type string,
      END OF ty_s_data,
      ty_t_data TYPE STANDARD TABLE OF ty_s_data WITH DEFAULT KEY.

    TYPES:
      BEGIN OF ty_s_layout,
        FNAME      type string,
        merge      TYPE string,
        visible    TYPE string,
      END OF ty_s_layout,
      ty_t_layout TYPE STANDARD TABLE OF ty_s_layout WITH DEFAULT KEY.

    DATA mt_layout TYPE ty_t_layout.
    DATA mt_data   TYPE ty_t_data.

PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_173 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.
    DATA temp1 TYPE z2ui5_cl_demo_app_173=>ty_t_data.
    DATA temp2 LIKE LINE OF temp1.
    DATA temp3 TYPE z2ui5_cl_demo_app_173=>ty_t_layout.
    DATA temp4 LIKE LINE OF temp3.
    DATA xml TYPE string.

    client->_bind( mt_data ).
    client->_bind( mt_layout ).

    
    CLEAR temp1.
    
    temp2-name = 'Theo'.
    temp2-date = '01.01.2000'.
    temp2-age = '5'.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = 'Lore'.
    temp2-date = '01.01.2000'.
    temp2-age = '1'.
    INSERT temp2 INTO TABLE temp1.
    mt_data = temp1.

    
    CLEAR temp3.
    
    temp4-fname = 'NAME'.
    temp4-merge = 'false'.
    temp4-visible = 'true'.
    INSERT temp4 INTO TABLE temp3.
    temp4-fname = 'DATE'.
    temp4-merge = 'false'.
    temp4-visible = 'true'.
    INSERT temp4 INTO TABLE temp3.
    temp4-fname = 'AGE'.
    temp4-merge = 'false'.
    temp4-visible = 'false'.
    INSERT temp4 INTO TABLE temp3.
    mt_layout = temp3.

    
    xml =
`<mvc:View xmlns="sap.m" xmlns:core="sap.ui.core" xmlns:mvc="sap.ui.core.mvc" xmlns:template="http://schemas.sap.com/sapui5/extension/sap.ui.core.template/1" displayBlock="true" height="100%" >` &&
`  <Shell>` &&
`    <Page>` &&
`      <Table items="{/MT_DATA}">` &&
`        <columns>` &&
`          <template:repeat list="{meta>/MT_LAYOUT} " var="MT_LAYOUT">` &&
`            <Column` &&
`           mergeDuplicates="{MT_LAYOUT>MERGE}"` &&
`           visible="{MT_LAYOUT>VISIBLE}"/>` &&
`          </template:repeat>` &&
`        </columns>` &&
`        <items>` &&
`          <ColumnListItem>` &&
`            <cells>` &&
`              <template:repeat list="{meta>/MT_LAYOUT}" var="MT_LAYOUT">` &&
`                <ObjectIdentifier text="{MT_LAYOUT>FNAME}"/>` &&
`              </template:repeat>` &&
`            </cells>` &&
`          </ColumnListItem>` &&
`        </items>` &&
`      </Table>` &&
`    </Page>` &&
`  </Shell>` &&
`</mvc:View> `.

    client->view_display( xml ).

  ENDMETHOD.

ENDCLASS.

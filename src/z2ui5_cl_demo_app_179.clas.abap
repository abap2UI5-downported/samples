CLASS z2ui5_cl_demo_app_179 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_relationships,
        id           TYPE string,
        successor    TYPE string,
        presuccessor TYPE string,
      END OF ty_s_relationships.

    TYPES ty_t_relation TYPE STANDARD TABLE OF ty_s_relationships WITH DEFAULT KEY .

    TYPES:
      BEGIN OF t_subtask5,
        id        TYPE string,
        starttime TYPE string,
        endtime   TYPE string,
      END OF t_subtask5 .
    TYPES:
      tt_subtask5 TYPE STANDARD TABLE OF t_subtask5 WITH DEFAULT KEY .
    TYPES:
      BEGIN OF t_task3,
        id        TYPE string,
        starttime TYPE string,
        endtime   TYPE string,
      END OF t_task3 .
    TYPES:
      BEGIN OF t_children4,
        id        TYPE string,
        text      TYPE string,
        subtask   TYPE tt_subtask5,
        relations TYPE ty_t_relation,
      END OF t_children4 .
    TYPES:
      tt_task3 TYPE STANDARD TABLE OF t_task3 WITH DEFAULT KEY .
    TYPES:
      tt_children4 TYPE STANDARD TABLE OF t_children4 WITH DEFAULT KEY .

    TYPES:
      BEGIN OF t_children2,
        id            TYPE string,
        text          TYPE string,
        task          TYPE tt_task3,
        children      TYPE tt_children4,
        relationships TYPE ty_t_relation,
      END OF t_children2 .
    TYPES:
      tt_children2 TYPE STANDARD TABLE OF t_children2 WITH DEFAULT KEY .
    TYPES:
      BEGIN OF t_root6,
        children TYPE tt_children2,
      END OF t_root6 .
    TYPES:
      BEGIN OF t_json1,
        root TYPE t_root6,
      END OF t_json1 .

    DATA mt_table TYPE t_root6 .
    DATA zoomlevel TYPE i .

  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client .
    DATA check_initialized TYPE abap_bool .

    METHODS z2ui5_on_init .
    METHODS z2ui5_on_event .
    METHODS z2ui5_set_data .

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_179 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.
    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

      z2ui5_set_data( ).
      z2ui5_on_init( ).
      RETURN.
    ENDIF.

    z2ui5_on_event( ).

  ENDMETHOD.


  METHOD z2ui5_on_event.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_on_init.


    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA temp1 TYPE z2ui5_if_types=>ty_s_name_value.
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA temp2 TYPE xsdboolean.
    DATA cont TYPE REF TO z2ui5_cl_xml_view.
    DATA tool TYPE REF TO z2ui5_cl_xml_view.
    DATA gantt_container TYPE REF TO z2ui5_cl_xml_view.
    DATA gantt TYPE REF TO z2ui5_cl_xml_view.
    DATA table TYPE REF TO z2ui5_cl_xml_view.
    DATA gantt_row_template TYPE REF TO z2ui5_cl_xml_view.
    DATA gantt_rs TYPE REF TO z2ui5_cl_xml_view.
    DATA lo_s TYPE REF TO z2ui5_cl_xml_view.
    DATA lo_rel TYPE REF TO z2ui5_cl_xml_view.
    view = z2ui5_cl_xml_view=>factory( ).

    
    CLEAR temp1.
    temp1-n = `core:require`.
    temp1-v = `{Helper:'z2ui5/Util'}`.
    view->_generic_property( temp1 ).

    
    
    temp2 = boolc( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ).
    page = view->page( id = `page_main`
            title          = 'abap2UI5 - Gantt'
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton = temp2
            class = 'sapUiContentPadding' ).

    
    cont = page->scroll_container(
*               height     =
*               width      =
*               vertical   =
                   horizontal = abap_true
*               id         =
*               focusable  =
*               visible    =
                 ).

    
    tool = cont->container_toolbar(
      EXPORTING
        showsearchbutton          = abap_true
        showdisplaytypebutton     =  abap_true
        showlegendbutton          =  abap_true
        showsettingbutton         =  abap_true
        showtimezoomcontrol       =  abap_true
        findbuttonpress           = client->_event( val = 'FIRE' )
*    stepcountofslider         =
*    zoomcontroltype           =
        zoomlevel                 = client->_bind_edit( zoomlevel )
*  RECEIVING
*    result                    =
    ).


    
    gantt_container = cont->gantt_chart_container(   ).
    
    gantt = gantt_container->gantt_chart_with_table( id = `gantt` shapeselectionmode = `Single` ).

    gantt->axis_time_strategy(
      )->proportion_zoom_strategy( zoomlevel = client->_bind_edit( zoomlevel )
        )->total_horizon(
          )->time_horizon( starttime = `20181029000000` endtime = `20181231000000` )->get_parent( )->get_parent(
        )->visible_horizon(
          )->time_horizon( starttime = `20181029000000` endtime = `20181131000000` )->get_parent( )->get_parent( )->get_parent( )->get_parent(
  ).
    
    table =  gantt->gantt_table( )->tree_table( rows = `{path: '` && client->_bind( val = mt_table path = abap_true ) && `', parameters: {arrayNames: ['CHILDREN'],numberOfExpandedLevels: 1}}`
        ).
    
    gantt_row_template =   table->tree_columns(
           )->tree_column( label = 'Col 1' )->tree_template( )->text( text = `{TEXT}` )->get_parent( )->get_parent( )->get_parent(
*            )->tree_column( label = 'Col 1' template = 'text' )->get_parent( )->get_parent(
         )->row_settings_template(
           ).

    
    gantt_rs =  gantt_row_template->gantt_row_settings( rowid = `{ID}`
                                  shapes1 = `{path: 'TASK', templateShareable:false}`
                                  shapes2 = `{path: 'SUBTASK', templateShareable:false}`
                                  relationships = `{path:'RELATIONSHIPS', templateShareable:false}`
            ).

    gantt_rs->shapes1(
            )->task( id = 'TSK1' time = `{= Helper.DateCreateObject(${STARTTIME} ) }`
            endtime = `{= Helper.DateCreateObject(${ENDTIME} ) }` type = `SummaryExpanded` color = `sapUiAccent5`  connectable = abap_true )."->get_parent( )->get_parent(

    gantt_rs->shapes2(
      )->task( id = 'TSK2' time = `{= Helper.DateCreateObject(${STARTTIME} ) }`
      endtime = `{= Helper.DateCreateObject(${ENDTIME} ) }`
      connectable = abap_true ).




    
    lo_s = gantt_rs->relationships( ).


*                 <gnt2:relationships>
*                   <gnt2:Relationship shapeId="{data>RelationID}"
*                   predecessor="{data>PredecTaskID}" successor="{data>SuccTaskID}" type="{data>RelationType}" tooltip="{data>RelationType}"
*                   selectable="true"/>
*                 </gnt2:relationships>




    
    CALL METHOD lo_s->relationship
      EXPORTING
        shapeid          = '{ID}'
        successor   = '{SUCCESSOR}'
        predecessor = '{PRESUCCESSOR}'
        type        = 'StartToFinish'
      RECEIVING
        result      = lo_rel.

*  RECEIVING
*    result =.



    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_set_data.
    DATA temp1 TYPE z2ui5_cl_demo_app_179=>tt_children2.
    DATA temp2 LIKE LINE OF temp1.
    DATA temp3 TYPE z2ui5_cl_demo_app_179=>tt_task3.
    DATA temp4 LIKE LINE OF temp3.
    DATA temp5 TYPE z2ui5_cl_demo_app_179=>ty_t_relation.
    DATA temp6 LIKE LINE OF temp5.
    DATA temp7 TYPE z2ui5_cl_demo_app_179=>tt_children4.
    DATA temp8 LIKE LINE OF temp7.
    DATA temp9 TYPE z2ui5_cl_demo_app_179=>tt_subtask5.
    DATA temp10 LIKE LINE OF temp9.
    DATA temp11 TYPE z2ui5_cl_demo_app_179=>ty_t_relation.
    DATA temp12 LIKE LINE OF temp11.


    CLEAR mt_table.
    
    CLEAR temp1.
    
    temp2-id = `line`.
    temp2-text = `Level 1`.
    
    CLEAR temp3.
    
    temp4-id = `rectangle1`.
    temp4-starttime = `2018-11-01T09:00:00`.
    temp4-endtime = `2018-11-27T09:00:00`.
    INSERT temp4 INTO TABLE temp3.
    temp2-task = temp3.
    
    CLEAR temp5.
    
    temp6-id = '34'.
    temp6-successor = `chevron1`.
    temp6-presuccessor = `chevron2`.
    INSERT temp6 INTO TABLE temp5.
    temp2-relationships = temp5.
    
    CLEAR temp7.
    
    temp8-id = `line2`.
    temp8-text = `Level 2`.
    
    CLEAR temp9.
    
    temp10-id = `chevron1`.
    temp10-starttime = `2018-11-01T09:00:00`.
    temp10-endtime = `2018-11-13T09:00:00`.
    INSERT temp10 INTO TABLE temp9.
    temp10-id = `chevron2`.
    temp10-starttime = `2018-11-15T09:00:00`.
    temp10-endtime = `2018-11-27T09:00:00`.
    INSERT temp10 INTO TABLE temp9.
    temp8-subtask = temp9.
    
    CLEAR temp11.
    
    temp12-id = '34'.
    temp12-successor = `chevron1`.
    temp12-presuccessor = `chevron2`.
    INSERT temp12 INTO TABLE temp11.
    temp8-relations = temp11.
    INSERT temp8 INTO TABLE temp7.
    temp2-children = temp7.
    INSERT temp2 INTO TABLE temp1.
    mt_table-children = temp1.

  ENDMETHOD.
ENDCLASS.

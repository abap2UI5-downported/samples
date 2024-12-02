class Z2UI5_CL_DEMO_APP_312 definition
  public
  create public .

public section.

  interfaces IF_SERIALIZABLE_OBJECT .
  interfaces Z2UI5_IF_APP .

  types:
    BEGIN OF ts_data_chart,
        week    TYPE string,
        revenue TYPE string,
        cost    TYPE string,
      END OF ts_data_chart .
  types:
    tt_data_chart TYPE STANDARD TABLE OF ts_data_chart WITH DEFAULT KEY .
  types:
    BEGIN OF ts_combobox,
        key  TYPE string,
        text TYPE string,
      END OF ts_combobox .
  types:
    tt_combobox TYPE STANDARD TABLE OF ts_combobox WITH KEY key .
  types:
    BEGIN OF ts_screen,
             viztype    TYPE string,
             viztypesel TYPE string,
           END OF ts_screen .

  data MS_SCREEN type TS_SCREEN .
  data MT_DATA_CHART type TT_DATA_CHART .
  data MV_PROP type STRING .
  data:
    mt_feed_values TYPE TABLE OF string .
  data CHECK_INITIALIZED type ABAP_BOOL .
  data MT_VIZTYPES type TT_COMBOBOX .
protected section.

  data CLIENT type ref to Z2UI5_IF_CLIENT .

  methods ON_RENDERING .
  methods ON_EVENT .
  methods ON_INIT .
private section.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_312 IMPLEMENTATION.


  METHOD ON_EVENT.
    DATA: lt_param   TYPE string_table,
          lv_message TYPE string.

* ---------- Get event parameter ------------------------------------------------------------------
    lt_param = client->get( )-t_event_arg.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( ).

      WHEN 'EVT_DATA_SELECT'.
        READ TABLE lt_param INTO lv_message INDEX 1.
        client->message_toast_display( text = lv_message ).

      WHEN 'EVT_VIZTYPE_CHANGE'.

        me->ms_screen-viztype = me->ms_screen-viztypesel.
        me->on_rendering( ).
    ENDCASE.

  ENDMETHOD.


  METHOD ON_INIT.
* ---------- Set vizframe chart data --------------------------------------------------------------
    DATA temp1 TYPE z2ui5_cl_demo_app_312=>tt_data_chart.
    DATA temp2 LIKE LINE OF temp1.
    DATA temp3 LIKE me->mt_feed_values.
    DATA temp5 TYPE z2ui5_cl_demo_app_312=>tt_combobox.
    DATA temp6 LIKE LINE OF temp5.
    CLEAR temp1.
    
    temp2-week = 'Week 1 - 4'.
    temp2-revenue = '431000.22'.
    temp2-cost = '230000.00'.
    INSERT temp2 INTO TABLE temp1.
    temp2-week = 'Week 5 - 8'.
    temp2-revenue = '494000.30'.
    temp2-cost = '238000.00'.
    INSERT temp2 INTO TABLE temp1.
    temp2-week = 'Week 9 - 12'.
    temp2-revenue = '491000.17'.
    temp2-cost = '221000.00'.
    INSERT temp2 INTO TABLE temp1.
    temp2-week = 'Week 13 - 16'.
    temp2-revenue = '536000.34'.
    temp2-cost = '280000.00'.
    INSERT temp2 INTO TABLE temp1.
    me->mt_data_chart = temp1.
* ---------- Set vizframe properties (optional) ---------------------------------------------------
    me->mv_prop = `{` && |\n|  &&
    `"plotArea": {` && |\n|  &&
        `"dataLabel": {` && |\n|  &&
            `"formatString": "",` && |\n|  &&
            `"visible": true` && |\n|  &&
        `}` && |\n|  &&
    `},` && |\n|  &&
    `"valueAxis": {` && |\n|  &&
        `"label": {` && |\n|  &&
            `"formatString": ""` && |\n|  &&
        `},` && |\n|  &&
        `"title": {` && |\n|  &&
            `"visible": true` && |\n|  &&
        `}` && |\n|  &&
    `},` && |\n|  &&
    `"categoryAxis": {` && |\n|  &&
        `"title": {` && |\n|  &&
            `"visible": true` && |\n|  &&
        `}` && |\n|  &&
    `},` && |\n|  &&
    `"title": {` && |\n|  &&
        `"visible": true,` && |\n|  &&
        `"text": "Vizframe Charts for 2UI5"` && |\n|  &&
    `}` && |\n|  &&
`}`.

* ---------- Set vizframe feed item values for value axis -----------------------------------------
    
    CLEAR temp3.
    INSERT `Revenue` INTO TABLE temp3.
    INSERT `Cost` INTO TABLE temp3.
    me->mt_feed_values = temp3 .

* ---------- Set viz type default -----------------------------------------------------------------
    me->ms_screen-viztype = 'column'.
    me->ms_screen-viztypesel = 'column'.

* ---------- Set VizFrame types -------------------------------------------------------------------
    
    CLEAR temp5.
    
    temp6-key = 'column'.
    temp6-text = 'column'.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = 'bar'.
    temp6-text = 'bar'.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = 'stacked_bar'.
    temp6-text = 'stacked_bar'.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = 'stacked_column'.
    temp6-text = 'stacked_column'.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = 'line'.
    temp6-text = 'line'.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = 'combination'.
    temp6-text = 'combination'.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = 'bullet'.
    temp6-text = 'bullet'.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = 'vertical_bullet'.
    temp6-text = 'vertical_bullet'.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = '100_stacked_bar'.
    temp6-text = '100_stacked_bar'.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = '100_stacked_column'.
    temp6-text = '100_stacked_column'.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = 'stacked_combination'.
    temp6-text = 'stacked_combination'.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = 'horizontal_stacked_combination'.
    temp6-text = 'horizontal_stacked_combination'.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = 'waterfall'.
    temp6-text = 'waterfall'.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = 'horizontal_waterfall'.
    temp6-text = 'horizontal_waterfall'.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = 'area'.
    temp6-text = 'area'.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = 'radar'.
    temp6-text = 'radar'.
    INSERT temp6 INTO TABLE temp5.
    me->mt_viztypes = temp5.

  ENDMETHOD.


  METHOD ON_RENDERING.

    DATA lr_view TYPE REF TO z2ui5_cl_xml_view.
    DATA lr_dyn_page TYPE REF TO z2ui5_cl_xml_view.
    DATA lr_header_title TYPE REF TO z2ui5_cl_xml_view.
    DATA lr_header TYPE REF TO z2ui5_cl_xml_view.
    DATA lr_filter_bar TYPE REF TO z2ui5_cl_xml_view.
    DATA lr_filter TYPE REF TO z2ui5_cl_xml_view.
    DATA lr_content TYPE REF TO z2ui5_cl_xml_view.
    DATA temp7 TYPE string_table.
    DATA lr_vizframe TYPE REF TO z2ui5_cl_xml_view.
    DATA lr_dataset TYPE REF TO z2ui5_cl_xml_view.
    DATA lr_flatteneddataset TYPE REF TO z2ui5_cl_xml_view.
    DATA lr_dimensions TYPE REF TO z2ui5_cl_xml_view.
    DATA lr_dimensions_def TYPE REF TO z2ui5_cl_xml_view.
    DATA lr_measures TYPE REF TO z2ui5_cl_xml_view.
    DATA lr_measures_def1 TYPE REF TO z2ui5_cl_xml_view.
    DATA lr_measures_def2 TYPE REF TO z2ui5_cl_xml_view.
    DATA lr_feeds TYPE REF TO z2ui5_cl_xml_view.
    DATA lr_lr_feed_item1 TYPE REF TO z2ui5_cl_xml_view.
    DATA lr_lr_feed_item2 TYPE REF TO z2ui5_cl_xml_view.
    lr_view = z2ui5_cl_xml_view=>factory( ).

* ---------- Set dynamic page ---------------------------------------------------------------------
    
    lr_dyn_page =  lr_view->dynamic_page( showfooter = abap_false ).

* ---------- Get header title ---------------------------------------------------------------------
    
    lr_header_title = lr_dyn_page->title( ns = 'f' )->get( )->dynamic_page_title( ).

* ---------- Set header title text ----------------------------------------------------------------
    lr_header_title->heading( ns = 'f' )->title( 'abap2UI5 - VizFrame Charts' ).

* ---------- Get page header area ----------------------------------------------------------------
    
    lr_header = lr_dyn_page->header( ns = 'f' )->dynamic_page_header( pinnable = abap_true )->content( ns = 'f' ).

* ---------- Set Filter bar -----------------------------------------------------------------------
    
    lr_filter_bar = lr_header->filter_bar( usetoolbar = 'false' )->filter_group_items( ).

* ---------- Set filter ---------------------------------------------------------------------------
    
    lr_filter = lr_filter_bar->filter_group_item(  name  = 'VizFrameType'
                                                         label = 'VizFrame type'
                                                         groupname = |GroupVizFrameType|
                                                         visibleinfilterbar = 'true'
                                                         )->filter_control( ).

* ---------- Set combo box input field ------------------------------------------------------------
    lr_filter->combobox( selectedkey    = client->_bind_edit( me->ms_screen-viztypesel )
                         change         = client->_event( val = 'EVT_VIZTYPE_CHANGE' )
                         showclearicon  = abap_true
                         items          = client->_bind( me->mt_viztypes )
                              )->item(
                                  key = '{KEY}'
                                  text = '{TEXT}' ).

* ---------- Get page content area ----------------------------------------------------------------
    
    lr_content = lr_dyn_page->content( ns = 'f' ).

* ---------- Set vizframe chart -------------------------------------------------------------------
    
    CLEAR temp7.
    INSERT `${$parameters>/data/0/data/}` INTO TABLE temp7.
    
    lr_vizframe = lr_content->viz_frame(
                          id                = 'idVizFrame'
*                      legendvisible     =
*                      vizcustomizations =
                      vizproperties     = me->mv_prop
*                      vizscales         =
                          viztype           = client->_bind( me->ms_screen-viztype )
                          height            = '500px'
                          width             = '100%'
*                      uiconfig          = `{applicationSet:'fiori'}`
*                      visible           =
                          selectdata    = client->_event( val = 'EVT_DATA_SELECT'
                                                           t_arg = temp7 ) ).

* ---------- Set vizframe dataset -----------------------------------------------------------------
    
    lr_dataset = lr_vizframe->viz_dataset( ).

* ---------- Set vizframe flattened dataset --------------------------------------------------------
    
    lr_flatteneddataset = lr_dataset->viz_flattened_dataset( data = client->_bind( me->mt_data_chart ) ).

* ---------- Set vizframe dimensions ---------------------------------------------------------------
    
    lr_dimensions = lr_flatteneddataset->viz_dimensions( ).

* ---------- Set vizframe dimension ----------------------------------------------------------------
    
    lr_dimensions_def = lr_dimensions->viz_dimension_definition(
*                            axis         =
*                            datatype     =
*                            displayvalue =
*                            identity     =
                                name         = 'Week'
*                            sorter       =
                                value        = '{WEEK}' ).

* ---------- Set vizframe measures ----------------------------------------------------------------
    
    lr_measures = lr_flatteneddataset->viz_measures( ).

* ---------- Set vizframe measure definition 1 ----------------------------------------------------
    
    lr_measures_def1 = lr_measures->viz_measure_definition(
*                              format   =
*                              group    =
*                              identity =
                               name     = 'Revenue'
*                              range    =
*                              unit     =
                               value    = '{REVENUE}' ).

* ---------- Set vizframe measure definition 2 ----------------------------------------------------
    
    lr_measures_def2 = lr_measures->viz_measure_definition(
*                              format   =
*                              group    =
*                              identity =
                               name     = 'Cost'
*                              range    =
*                              unit     =
                               value    = '{COST}' ).


* ---------- Set vizframe feeds -------------------------------------------------------------------
    
    lr_feeds = lr_vizframe->viz_feeds( ).

* ---------- Set vizframe feed for value axis -----------------------------------------------------
    
    lr_lr_feed_item1 = lr_feeds->viz_feed_item(
                               id     = 'valueAxisFeed'
                               uid    = 'valueAxis'
                               type   = 'Measure'
                               values = client->_bind( me->mt_feed_values ) ).

* ---------- Set vizframe feed for category axis --------------------------------------------------
    
    lr_lr_feed_item2 = lr_feeds->viz_feed_item(
                               id     = 'categoryAxisFeed'
                               uid    = 'categoryAxis'
                               type   = 'Dimension'
                               values = 'Week' ).


    client->view_display( lr_view->stringify( ) ).

  ENDMETHOD.


  METHOD Z2UI5_IF_APP~MAIN.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

* ---------- ON INIT ------------------------------------------------------------------------------
      me->on_init( ).

* ---------- ON RENDERING -------------------------------------------------------------------------
      me->on_rendering( ).
      RETURN.

    ENDIF.

* ---------- ON EVENT -----------------------------------------------------------------------------
    me->on_event( ).

  ENDMETHOD.
ENDCLASS.

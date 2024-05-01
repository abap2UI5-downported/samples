CLASS z2ui5_cl_demo_app_148 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.


    INTERFACES z2ui5_if_app .

    DATA ls_dataset TYPE z2ui5_cl_cc_chartjs=>ty_dataset.
    DATA check_initialized TYPE abap_bool .

    "bar charts
    DATA ms_chartjs_config_bar TYPE z2ui5_cl_cc_chartjs=>ty_chart .
    DATA ms_chartjs_config_bar2 TYPE z2ui5_cl_cc_chartjs=>ty_chart .
    DATA ms_chartjs_config_hbar TYPE z2ui5_cl_cc_chartjs=>ty_chart .

    "venn chart - plugin
    DATA ms_chartjs_config_venn TYPE z2ui5_cl_cc_chartjs=>ty_chart .

    "wordCloud
    DATA ms_chartjs_config_wordcloud TYPE z2ui5_cl_cc_chartjs=>ty_chart .

    "line charts
    DATA ms_chartjs_config_line TYPE z2ui5_cl_cc_chartjs=>ty_chart .

    "area charts
    DATA ms_chartjs_config_area TYPE z2ui5_cl_cc_chartjs=>ty_chart .

    "pie charts
    DATA ms_chartjs_config_pie TYPE z2ui5_cl_cc_chartjs=>ty_chart .

    "bubble charts
    DATA ms_chartjs_config_bubble TYPE z2ui5_cl_cc_chartjs=>ty_chart .

    "polar charts
    DATA ms_chartjs_config_polar TYPE z2ui5_cl_cc_chartjs=>ty_chart .

    "doughnut charts
    DATA ms_chartjs_config_doughnut TYPE z2ui5_cl_cc_chartjs=>ty_chart .


  PROTECTED SECTION.

    METHODS z2ui5_on_rendering.
    METHODS z2ui5_on_event.
    METHODS z2ui5_on_init.

  PRIVATE SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_148 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      z2ui5_on_init( ).

      client->view_display( z2ui5_cl_xml_view=>factory(
        )->_z2ui5( )->timer( finished = client->_event( `START` ) delayms = `0`
           )->_generic( ns = `html` name = `script` )->_cc_plain_xml( z2ui5_cl_cc_chartjs=>load_js( datalabels = abap_true
                                                                                                    autocolors = abap_false
                                                                                                    venn       = abap_true
                                                                                                    wordcloud  = abap_true
                                                                                                    annotation = abap_true
           ) )->get_parent(
           )->_generic( ns = `html` name = `script` )->_cc_plain_xml( z2ui5_cl_cc_chartjs=>load_cc( )
        )->stringify( ) ).

    ENDIF.

    z2ui5_on_event( ).

  ENDMETHOD.


  METHOD z2ui5_on_event.
        FIELD-SYMBOLS <fs_bar> TYPE z2ui5_cl_cc_chartjs=>ty_dataset.
        DATA temp1 TYPE string_table.
        DATA temp3 TYPE string_table.
        DATA temp5 TYPE z2ui5_cl_cc_chartjs=>ty_data_venn_t.
        DATA temp6 LIKE LINE OF temp5.
        DATA temp2 TYPE string_table.
        DATA temp7 TYPE string_table.
        DATA temp9 TYPE string_table.
        DATA temp11 TYPE string_table.
        DATA temp13 TYPE string_table.
        DATA temp15 TYPE string_table.
        DATA temp17 TYPE string_table.

    CASE client->get( )-event.
      WHEN 'UPDATE_CHART'.
        
        READ TABLE ms_chartjs_config_bar-data-datasets ASSIGNING <fs_bar> INDEX 1.
        
        CLEAR temp1.
        INSERT `11` INTO TABLE temp1.
        INSERT `1` INTO TABLE temp1.
        INSERT `1` INTO TABLE temp1.
        INSERT `13` INTO TABLE temp1.
        INSERT `15` INTO TABLE temp1.
        INSERT `12` INTO TABLE temp1.
        INSERT `13` INTO TABLE temp1.
        <fs_bar>-data = temp1.

        ms_chartjs_config_bar2-options-plugins-legend-position = `left`.

        
        CLEAR temp3.
        INSERT `Reading` INTO TABLE temp3.
        INSERT `Maths` INTO TABLE temp3.
        INSERT `GPS` INTO TABLE temp3.
        INSERT `Reading ∩ Maths` INTO TABLE temp3.
        INSERT `GPS ∩ Reading` INTO TABLE temp3.
        INSERT `Maths ∩ GPS` INTO TABLE temp3.
        INSERT `Reading ∩ Maths ∩ GPS` INTO TABLE temp3.
        ms_chartjs_config_venn-data-labels = temp3.

        CLEAR ls_dataset.
        ls_dataset-label = `At or Above Expected`.
        ls_dataset-background_color = `rgba(75, 192, 192, 0.2)`.
        ls_dataset-border_color = `rgba(75, 192, 192, 1)`.
        
        CLEAR temp5.
        
        
        CLEAR temp2.
        INSERT `Reading` INTO TABLE temp2.
        temp6-sets = temp2.
        temp6-value = `15%`.
        INSERT temp6 INTO TABLE temp5.
        
        CLEAR temp7.
        INSERT `Maths` INTO TABLE temp7.
        temp6-sets = temp7.
        temp6-value = `3%`.
        INSERT temp6 INTO TABLE temp5.
        
        CLEAR temp9.
        INSERT `GPS` INTO TABLE temp9.
        temp6-sets = temp9.
        temp6-value = `3%`.
        INSERT temp6 INTO TABLE temp5.
        
        CLEAR temp11.
        INSERT `Reading` INTO TABLE temp11.
        INSERT `Maths` INTO TABLE temp11.
        temp6-sets = temp11.
        temp6-value = `3%`.
        INSERT temp6 INTO TABLE temp5.
        
        CLEAR temp13.
        INSERT `GPS` INTO TABLE temp13.
        INSERT `Reading` INTO TABLE temp13.
        temp6-sets = temp13.
        temp6-value = `21%`.
        INSERT temp6 INTO TABLE temp5.
        
        CLEAR temp15.
        INSERT `Maths` INTO TABLE temp15.
        INSERT `GPS` INTO TABLE temp15.
        temp6-sets = temp15.
        temp6-value = `0%`.
        INSERT temp6 INTO TABLE temp5.
        
        CLEAR temp17.
        INSERT `Reading` INTO TABLE temp17.
        INSERT `Maths` INTO TABLE temp17.
        INSERT `GPS` INTO TABLE temp17.
        temp6-sets = temp17.
        temp6-value = `13%`.
        INSERT temp6 INTO TABLE temp5.
        ls_dataset-data_venn = temp5.
        CLEAR ms_chartjs_config_venn-data-datasets.
        APPEND ls_dataset TO ms_chartjs_config_venn-data-datasets.


        ms_chartjs_config_wordcloud-options-plugins-datalabels-display = abap_false.

        client->view_model_update( ).

      WHEN 'START'.
        z2ui5_on_rendering( ).
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_on_init.
    DATA temp7 TYPE string_table.
    DATA temp9 TYPE string_table.
    DATA temp11 TYPE string_table.
    DATA temp13 TYPE string_table.
    DATA temp15 TYPE string_table.
    DATA temp17 TYPE string_table.
    DATA temp19 TYPE z2ui5_cl_cc_chartjs=>ty_data_venn_t.
    DATA temp20 LIKE LINE OF temp19.
    DATA temp22 TYPE string_table.
    DATA temp26 TYPE string_table.
    DATA temp30 TYPE string_table.
    DATA temp38 TYPE string_table.
    DATA temp42 TYPE string_table.
    DATA temp44 TYPE string_table.
    DATA temp46 TYPE string_table.
    DATA temp21 TYPE string_table.
    DATA temp23 TYPE string_table.
    DATA temp25 TYPE string_table.
    DATA temp27 TYPE string_table.
    DATA temp29 TYPE string_table.
    DATA temp31 TYPE z2ui5_cl_cc_chartjs=>ty_x_y_r_data_t.
    DATA temp32 LIKE LINE OF temp31.
    DATA temp33 TYPE z2ui5_cl_cc_chartjs=>ty_x_y_r_data_t.
    DATA temp34 LIKE LINE OF temp33.
    DATA temp35 TYPE string_table.
    DATA temp37 TYPE string_table.
    DATA temp39 TYPE string_table.
    DATA temp41 TYPE string_table.

    "bar
    ms_chartjs_config_bar-type = 'bar'.
    
    CLEAR temp7.
    INSERT `Red` INTO TABLE temp7.
    INSERT `Blue` INTO TABLE temp7.
    INSERT `Yellow` INTO TABLE temp7.
    INSERT `Green` INTO TABLE temp7.
    INSERT `Purple` INTO TABLE temp7.
    INSERT `Orange` INTO TABLE temp7.
    INSERT `Black` INTO TABLE temp7.
    ms_chartjs_config_bar-data-labels = temp7.

    ms_chartjs_config_bar-options-plugins-annotation-annotations-shape1-type = 'line'.
    ms_chartjs_config_bar-options-plugins-annotation-annotations-shape1-border_color = 'black'.
    ms_chartjs_config_bar-options-plugins-annotation-annotations-shape1-border_width = '5'.
    ms_chartjs_config_bar-options-plugins-annotation-annotations-shape1-label-background_color = 'red'.
    ms_chartjs_config_bar-options-plugins-annotation-annotations-shape1-label-content = 'Test Label'.
    ms_chartjs_config_bar-options-plugins-annotation-annotations-shape1-label-display = abap_true.
    ms_chartjs_config_bar-options-plugins-annotation-annotations-shape1-scaleid = 'y'.
    ms_chartjs_config_bar-options-plugins-annotation-annotations-shape1-value = '14'.

    ls_dataset-border_width = 1.
    ls_dataset-label = `# of Votes`.
    ls_dataset-rtl = abap_true.
    
    CLEAR temp9.
    INSERT `1` INTO TABLE temp9.
    INSERT `12` INTO TABLE temp9.
    INSERT `19` INTO TABLE temp9.
    INSERT `3` INTO TABLE temp9.
    INSERT `5` INTO TABLE temp9.
    INSERT `2` INTO TABLE temp9.
    INSERT `3` INTO TABLE temp9.
    ls_dataset-data = temp9.
    APPEND ls_dataset TO ms_chartjs_config_bar-data-datasets.


    ms_chartjs_config_bar-options-plugins-datalabels-text_align = `center`.
    ms_chartjs_config_bar-options-scales-y-begin_at_zero = abap_true.

    ms_chartjs_config_bar2-type = 'bar'.
    
    CLEAR temp11.
    INSERT `Jan` INTO TABLE temp11.
    INSERT `Feb` INTO TABLE temp11.
    INSERT `Mar` INTO TABLE temp11.
    INSERT `Apr` INTO TABLE temp11.
    INSERT `May` INTO TABLE temp11.
    INSERT `Jun` INTO TABLE temp11.
    ms_chartjs_config_bar2-data-labels = temp11.

    CLEAR ls_dataset.
    ls_dataset-label = 'Fully Rounded'.
    ls_dataset-border_width = 2.
    ls_dataset-border_radius = 200.
    ls_dataset-border_skipped = abap_false.
    
    CLEAR temp13.
    INSERT `1` INTO TABLE temp13.
    INSERT `-12` INTO TABLE temp13.
    INSERT `19` INTO TABLE temp13.
    INSERT `3` INTO TABLE temp13.
    INSERT `5` INTO TABLE temp13.
    INSERT `-2` INTO TABLE temp13.
    INSERT `3` INTO TABLE temp13.
    ls_dataset-data = temp13.
    APPEND ls_dataset TO ms_chartjs_config_bar2-data-datasets.


    CLEAR ls_dataset.
    ls_dataset-label = 'Small Radius'.
    ls_dataset-border_width = 2.
    ls_dataset-border_radius = 5.
    ls_dataset-border_skipped = abap_false.
    
    CLEAR temp15.
    INSERT `11` INTO TABLE temp15.
    INSERT `2` INTO TABLE temp15.
    INSERT `-3` INTO TABLE temp15.
    INSERT `13` INTO TABLE temp15.
    INSERT `-9` INTO TABLE temp15.
    INSERT `7` INTO TABLE temp15.
    INSERT `-4` INTO TABLE temp15.
    ls_dataset-data = temp15.
    APPEND ls_dataset TO ms_chartjs_config_bar2-data-datasets.

    ms_chartjs_config_bar2-options-responsive = abap_true.
    ms_chartjs_config_bar2-options-plugins-legend-position = `top`.
    ms_chartjs_config_bar2-options-plugins-title-display = abap_true.
    ms_chartjs_config_bar2-options-plugins-title-text = `Bar Chart`.

    ms_chartjs_config_bar2-options-plugins-autocolors-offset = 11.
    ms_chartjs_config_bar2-options-plugins-autocolors-mode = 'dataset'.
    ms_chartjs_config_bar2-options-plugins-datalabels-text_align = `center`.
    ms_chartjs_config_bar2-options-plugins-datalabels-color = `white`.


    "venn
    ms_chartjs_config_venn-type = 'venn'.
    
    CLEAR temp17.
    INSERT `Soccer` INTO TABLE temp17.
    INSERT `Tennis` INTO TABLE temp17.
    INSERT `Volleyball` INTO TABLE temp17.
    INSERT `Soccer ∩ Tennis` INTO TABLE temp17.
    INSERT `Soccer ∩ Volleyball` INTO TABLE temp17.
    INSERT `Tennis ∩ Volleyball` INTO TABLE temp17.
    INSERT `Soccer ∩ Tennis ∩ Volleyball` INTO TABLE temp17.
    ms_chartjs_config_venn-data-labels = temp17.

    CLEAR ls_dataset.
    ls_dataset-label = `Sports`.
    
    CLEAR temp19.
    
    
    CLEAR temp22.
    INSERT `Soccer` INTO TABLE temp22.
    temp20-sets = temp22.
    temp20-value = `2`.
    INSERT temp20 INTO TABLE temp19.
    
    CLEAR temp26.
    INSERT `Tennis` INTO TABLE temp26.
    temp20-sets = temp26.
    temp20-value = `0`.
    INSERT temp20 INTO TABLE temp19.
    
    CLEAR temp30.
    INSERT `Volleyball` INTO TABLE temp30.
    temp20-sets = temp30.
    temp20-value = `1`.
    INSERT temp20 INTO TABLE temp19.
    
    CLEAR temp38.
    INSERT `Soccer` INTO TABLE temp38.
    INSERT `Tennis` INTO TABLE temp38.
    temp20-sets = temp38.
    temp20-value = `1`.
    INSERT temp20 INTO TABLE temp19.
    
    CLEAR temp42.
    INSERT `Soccer` INTO TABLE temp42.
    INSERT `Volleyball` INTO TABLE temp42.
    temp20-sets = temp42.
    temp20-value = `0`.
    INSERT temp20 INTO TABLE temp19.
    
    CLEAR temp44.
    INSERT `Tennis` INTO TABLE temp44.
    INSERT `Volleyball` INTO TABLE temp44.
    temp20-sets = temp44.
    temp20-value = `1`.
    INSERT temp20 INTO TABLE temp19.
    
    CLEAR temp46.
    INSERT `Soccer` INTO TABLE temp46.
    INSERT `Tennis` INTO TABLE temp46.
    INSERT `Volleyball` INTO TABLE temp46.
    temp20-sets = temp46.
    temp20-value = `1`.
    INSERT temp20 INTO TABLE temp19.
    ls_dataset-data_venn = temp19.

    APPEND ls_dataset TO ms_chartjs_config_venn-data-datasets.

    "wordcloud

    ms_chartjs_config_wordcloud-type = `wordCloud`.
    
    CLEAR temp21.
    INSERT `Hello` INTO TABLE temp21.
    INSERT `world` INTO TABLE temp21.
    INSERT `normally` INTO TABLE temp21.
    INSERT `you` INTO TABLE temp21.
    INSERT `want` INTO TABLE temp21.
    INSERT `more` INTO TABLE temp21.
    INSERT `words` INTO TABLE temp21.
    INSERT `than` INTO TABLE temp21.
    INSERT `this` INTO TABLE temp21.
    ms_chartjs_config_wordcloud-data-labels = temp21.
    CLEAR ls_dataset.
    ls_dataset-label = `DS`.
    
    CLEAR temp23.
    INSERT `90` INTO TABLE temp23.
    INSERT `80` INTO TABLE temp23.
    INSERT `70` INTO TABLE temp23.
    INSERT `60` INTO TABLE temp23.
    INSERT `50` INTO TABLE temp23.
    INSERT `40` INTO TABLE temp23.
    INSERT `30` INTO TABLE temp23.
    INSERT `20` INTO TABLE temp23.
    INSERT `10` INTO TABLE temp23.
    ls_dataset-data = temp23.

    APPEND ls_dataset TO ms_chartjs_config_wordcloud-data-datasets.

    "disable datalabels
    ms_chartjs_config_wordcloud-options-plugins-datalabels-display = '-'.


    "line
    ms_chartjs_config_line-type = 'line'.
    
    CLEAR temp25.
    INSERT `Jan` INTO TABLE temp25.
    INSERT `Feb` INTO TABLE temp25.
    INSERT `Mar` INTO TABLE temp25.
    INSERT `Apr` INTO TABLE temp25.
    INSERT `May` INTO TABLE temp25.
    INSERT `Jun` INTO TABLE temp25.
    INSERT `Jul` INTO TABLE temp25.
    ms_chartjs_config_line-data-labels = temp25.

    CLEAR ls_dataset.
    ls_dataset-label = `Dataset 1`.
    
    CLEAR temp27.
    INSERT `65` INTO TABLE temp27.
    INSERT `59` INTO TABLE temp27.
    INSERT `80` INTO TABLE temp27.
    INSERT `81` INTO TABLE temp27.
    INSERT `56` INTO TABLE temp27.
    INSERT `55` INTO TABLE temp27.
    INSERT `40` INTO TABLE temp27.
    ls_dataset-data = temp27.
    APPEND ls_dataset TO ms_chartjs_config_line-data-datasets.

    CLEAR ls_dataset.
    ls_dataset-label = `Dataset 2`.
    
    CLEAR temp29.
    INSERT `100` INTO TABLE temp29.
    INSERT `33` INTO TABLE temp29.
    INSERT `22` INTO TABLE temp29.
    INSERT `19` INTO TABLE temp29.
    INSERT `11` INTO TABLE temp29.
    INSERT `49` INTO TABLE temp29.
    INSERT `30` INTO TABLE temp29.
    ls_dataset-data = temp29.
    APPEND ls_dataset TO ms_chartjs_config_line-data-datasets.


    ms_chartjs_config_line-options-responsive = abap_true.
    ms_chartjs_config_line-options-plugins-title-display = abap_true.
    ms_chartjs_config_line-options-plugins-title-text = `Min and Max Settings`.

    "bubble
    ms_chartjs_config_bubble-type = 'bubble'.

    CLEAR ls_dataset.
    ls_dataset-label = `Dataset 1`.
    
    CLEAR temp31.
    
    temp32-x = `26`.
    temp32-y = `79`.
    temp32-r = `12.3`.
    INSERT temp32 INTO TABLE temp31.
    temp32-x = `37`.
    temp32-y = `65`.
    temp32-r = `13.8`.
    INSERT temp32 INTO TABLE temp31.
    temp32-x = `27`.
    temp32-y = `24`.
    temp32-r = `5.8`.
    INSERT temp32 INTO TABLE temp31.
    temp32-x = `38`.
    temp32-y = `39`.
    temp32-r = `5.8`.
    INSERT temp32 INTO TABLE temp31.
    temp32-x = `47`.
    temp32-y = `36`.
    temp32-r = `8.4`.
    INSERT temp32 INTO TABLE temp31.
    temp32-x = `77`.
    temp32-y = `65`.
    temp32-r = `9.5`.
    INSERT temp32 INTO TABLE temp31.
    temp32-x = `87`.
    temp32-y = `43`.
    temp32-r = `6.66`.
    INSERT temp32 INTO TABLE temp31.
    ls_dataset-data_radial = temp31.
    APPEND ls_dataset TO ms_chartjs_config_bubble-data-datasets.

    CLEAR ls_dataset.
    ls_dataset-label = `Dataset 2`.
    
    CLEAR temp33.
    
    temp34-x = `5`.
    temp34-y = `18`.
    temp34-r = `8.9`.
    INSERT temp34 INTO TABLE temp33.
    temp34-x = `15`.
    temp34-y = `88`.
    temp34-r = `6.9`.
    INSERT temp34 INTO TABLE temp33.
    temp34-x = `19`.
    temp34-y = `56`.
    temp34-r = `13.1`.
    INSERT temp34 INTO TABLE temp33.
    temp34-x = `64`.
    temp34-y = `31`.
    temp34-r = `10.8`.
    INSERT temp34 INTO TABLE temp33.
    temp34-x = `71`.
    temp34-y = `13`.
    temp34-r = `9.8`.
    INSERT temp34 INTO TABLE temp33.
    temp34-x = `78`.
    temp34-y = `70`.
    temp34-r = `7.02`.
    INSERT temp34 INTO TABLE temp33.
    temp34-x = `90`.
    temp34-y = `72`.
    temp34-r = `10.96`.
    INSERT temp34 INTO TABLE temp33.
    ls_dataset-data_radial = temp33.
    APPEND ls_dataset TO ms_chartjs_config_bubble-data-datasets.

    ms_chartjs_config_bubble-options-responsive = abap_true.
    ms_chartjs_config_bubble-options-plugins-legend-position = `top`.
    ms_chartjs_config_bubble-options-plugins-title-display = abap_true.
    ms_chartjs_config_bubble-options-plugins-title-text = `Bubble Chart`.

    "doughnut
    ms_chartjs_config_doughnut-type = `doughnut`.
    
    CLEAR temp35.
    INSERT `Red` INTO TABLE temp35.
    INSERT `Orange` INTO TABLE temp35.
    INSERT `Yellow` INTO TABLE temp35.
    INSERT `Green` INTO TABLE temp35.
    INSERT `Blue` INTO TABLE temp35.
    ms_chartjs_config_doughnut-data-labels = temp35.

    CLEAR ls_dataset.
    ls_dataset-label = `Dataset 1`.

    
    CLEAR temp37.
    INSERT `63.411` INTO TABLE temp37.
    INSERT `47.831` INTO TABLE temp37.
    INSERT `50.666` INTO TABLE temp37.
    INSERT `21.3` INTO TABLE temp37.
    INSERT `38.744` INTO TABLE temp37.
    ls_dataset-data = temp37.

    APPEND ls_dataset TO ms_chartjs_config_doughnut-data-datasets.

*  ms_chartjs_config_doughnut-options-responsive = abap_true.
    ms_chartjs_config_doughnut-options-plugins-legend-position = `bottom`.
    ms_chartjs_config_doughnut-options-plugins-title-display = abap_false.
    ms_chartjs_config_doughnut-options-plugins-title-text = `Doughnut Chart`.
    ms_chartjs_config_doughnut-options-plugins-datalabels-text_align = `center`.

    "pie
    ms_chartjs_config_pie-type = `pie`.
    
    CLEAR temp39.
    INSERT `Red` INTO TABLE temp39.
    INSERT `Orange` INTO TABLE temp39.
    INSERT `Yellow` INTO TABLE temp39.
    INSERT `Green` INTO TABLE temp39.
    INSERT `Blue` INTO TABLE temp39.
    ms_chartjs_config_pie-data-labels = temp39.

    CLEAR ls_dataset.
    ls_dataset-label = `Dataset 1`.

    
    CLEAR temp41.
    INSERT `63.411` INTO TABLE temp41.
    INSERT `47.831` INTO TABLE temp41.
    INSERT `50.666` INTO TABLE temp41.
    INSERT `21.3` INTO TABLE temp41.
    INSERT `38.744` INTO TABLE temp41.
    ls_dataset-data = temp41.

    APPEND ls_dataset TO ms_chartjs_config_pie-data-datasets.

    ms_chartjs_config_pie-options-plugins-legend-position = `bottom`.
    ms_chartjs_config_pie-options-plugins-title-display = abap_false.
    ms_chartjs_config_pie-options-plugins-title-text = `Pie Chart`.
    ms_chartjs_config_pie-options-plugins-datalabels-text_align = `center`.


  ENDMETHOD.


  METHOD z2ui5_on_rendering.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA temp1 TYPE xsdboolean.
    DATA car TYPE REF TO z2ui5_cl_xml_view.
    DATA vl1 TYPE REF TO z2ui5_cl_xml_view.
    DATA fb1 TYPE REF TO z2ui5_cl_xml_view.
    DATA fb2 TYPE REF TO z2ui5_cl_xml_view.
    DATA temp43 TYPE REF TO z2ui5_cl_cc_chartjs.
    DATA temp44 TYPE REF TO z2ui5_cl_cc_chartjs.
    DATA temp45 TYPE REF TO z2ui5_cl_cc_chartjs.
    DATA temp46 TYPE REF TO z2ui5_cl_cc_chartjs.
    DATA vl11 TYPE REF TO z2ui5_cl_xml_view.
    DATA fb11 TYPE REF TO z2ui5_cl_xml_view.
    DATA fb22 TYPE REF TO z2ui5_cl_xml_view.
    DATA temp47 TYPE REF TO z2ui5_cl_cc_chartjs.
    DATA temp48 TYPE REF TO z2ui5_cl_cc_chartjs.
    DATA temp49 TYPE REF TO z2ui5_cl_cc_chartjs.
    DATA temp50 TYPE REF TO z2ui5_cl_cc_chartjs.
    view = z2ui5_cl_xml_view=>factory( ).

    
    
    temp1 = boolc( abap_false = client->get( )-check_launchpad_active ).
    page = view->shell(
         )->page(
          showheader       = temp1
            title          = 'abap2UI5 - ChartJS demo'
            navbuttonpress = client->_event( 'BACK' )
            enablescrolling = abap_false
              shownavbutton = abap_true ).

    page->header_content(
             )->link( text = 'Demo'        target = '_blank' href = `https://twitter.com/abap2UI5/status/1628701535222865922`
             )->link( text = 'Source_Code' target = '_blank'
             )->button( text = 'Update Chart' press = client->_event( 'UPDATE_CHART' )
         )->get_parent( ).


*    DATA(vbox) = page->vbox( justifycontent = `Center`  ).
    
    car = page->carousel( class = `sapUiContentPadding` ).
    
    vl1 = car->vertical_layout( width = `100%` ).
    
    fb1 = vl1->flex_box( width = `100%` height = `50%` justifycontent = `SpaceAround` ).
    
    fb2 = vl1->flex_box( width = `100%` height = `50%` justifycontent = `SpaceAround` ).
    
    CREATE OBJECT temp43 TYPE z2ui5_cl_cc_chartjs.
    fb1->vbox( justifycontent = `Center`
      )->_z2ui5( )->chartjs( canvas_id = `bar`
                             height = `300`
                             width = `400`
                             config = client->_bind_edit(
                             val = ms_chartjs_config_bar
                             custom_filter = temp43
                             custom_mapper = z2ui5_cl_ajson_mapping=>create_camel_case( iv_first_json_upper = abap_false )
                            custom_mapper_back = z2ui5_cl_ajson_mapping=>create_to_snake_case( )
                               )
                          ).
    
    CREATE OBJECT temp44 TYPE z2ui5_cl_cc_chartjs.
    fb1->vbox( justifycontent = `Center`
      )->_z2ui5( )->chartjs( canvas_id = `bar2`
                             height = `300`
                             width = `600`
                             config = client->_bind_edit( val = ms_chartjs_config_bar2
                              custom_filter = temp44
                              custom_mapper = z2ui5_cl_ajson_mapping=>create_camel_case( iv_first_json_upper = abap_false )
                             custom_mapper_back = z2ui5_cl_ajson_mapping=>create_to_snake_case( )
                                 )
                          ).
    
    CREATE OBJECT temp45 TYPE z2ui5_cl_cc_chartjs.
    fb2->vbox( justifycontent = `Center`
      )->_z2ui5( )->chartjs( canvas_id = `venn`
                             height = `300`
                             width = `600`
                             config = client->_bind_edit( val = ms_chartjs_config_venn
                             custom_filter = temp45
                             custom_mapper = z2ui5_cl_ajson_mapping=>create_camel_case( iv_first_json_upper = abap_false )
                             custom_mapper_back = z2ui5_cl_ajson_mapping=>create_to_snake_case( )
                              )
                          ).
    
    CREATE OBJECT temp46 TYPE z2ui5_cl_cc_chartjs.
    fb2->vbox( justifycontent = `Center`
      )->_z2ui5( )->chartjs( canvas_id = `wordCloud`
                             height = `300`
                             width = `600`
                             config = client->_bind_edit( val = ms_chartjs_config_wordcloud
                            custom_filter = temp46
                             custom_mapper = z2ui5_cl_ajson_mapping=>create_camel_case( iv_first_json_upper = abap_false )
                             custom_mapper_back = z2ui5_cl_ajson_mapping=>create_to_snake_case( )
                               ) ).

    
    vl11 = car->vertical_layout( width = `100%` ).
    
    fb11 = vl11->flex_box( width = `100%` height = `50%` justifycontent = `SpaceAround` ).
    
    fb22 = vl11->flex_box( width = `100%` height = `50%` justifycontent = `SpaceAround` ).
    
    CREATE OBJECT temp47 TYPE z2ui5_cl_cc_chartjs.
    fb11->vbox( justifycontent = `Center`
      )->_z2ui5( )->chartjs( canvas_id = `line`
                             height = `300`
                             width = `600`
                             config = client->_bind_edit( val = ms_chartjs_config_line
                             custom_filter = temp47
                             custom_mapper = z2ui5_cl_ajson_mapping=>create_camel_case( iv_first_json_upper = abap_false )
                             custom_mapper_back = z2ui5_cl_ajson_mapping=>create_to_snake_case( )
                               ) ).
    
    CREATE OBJECT temp48 TYPE z2ui5_cl_cc_chartjs.
    fb11->vbox( justifycontent = `Center`
      )->_z2ui5( )->chartjs( canvas_id = `bubble`
                             height = `300`
                             width = `600`
                             config = client->_bind_edit( val = ms_chartjs_config_bubble
                             custom_filter = temp48
                             custom_mapper = z2ui5_cl_ajson_mapping=>create_camel_case( iv_first_json_upper = abap_false )
                              custom_mapper_back = z2ui5_cl_ajson_mapping=>create_to_snake_case( )
                               ) ).

    
    CREATE OBJECT temp49 TYPE z2ui5_cl_cc_chartjs.
    fb22->vbox( justifycontent = `Center`
      )->_z2ui5( )->chartjs( canvas_id = `doughnut`
                             height = `300`
                             width = `300`
                             config = client->_bind_edit( val = ms_chartjs_config_doughnut
                             custom_filter = temp49
                             custom_mapper = z2ui5_cl_ajson_mapping=>create_camel_case( iv_first_json_upper = abap_false )
                             custom_mapper_back = z2ui5_cl_ajson_mapping=>create_to_snake_case( )
                               ) ).

    
    CREATE OBJECT temp50 TYPE z2ui5_cl_cc_chartjs.
    fb22->vbox( justifycontent = `Center`
      )->_z2ui5( )->chartjs( canvas_id = `pie`
                             height = `300`
                             width = `300`
                             config = client->_bind_edit( val = ms_chartjs_config_pie
                             custom_filter = temp50
                             custom_mapper = z2ui5_cl_ajson_mapping=>create_camel_case( iv_first_json_upper = abap_false )
                              custom_mapper_back = z2ui5_cl_ajson_mapping=>create_to_snake_case( )
                               ) ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.
ENDCLASS.

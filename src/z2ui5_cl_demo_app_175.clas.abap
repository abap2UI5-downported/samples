CLASS z2ui5_cl_demo_app_175 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.
    DATA mv_check_initialized TYPE abap_bool.

  PROTECTED SECTION.

    METHODS on_rendering
      IMPORTING
        !ir_client TYPE REF TO z2ui5_if_client .

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_175 IMPLEMENTATION.


  METHOD on_rendering.

    DATA lr_view TYPE REF TO z2ui5_cl_xml_view.
    DATA lr_dyn_page TYPE REF TO z2ui5_cl_xml_view.
    DATA lr_header_title TYPE REF TO z2ui5_cl_xml_view.
    DATA lr_header TYPE REF TO z2ui5_cl_xml_view.
    DATA lr_content TYPE REF TO z2ui5_cl_xml_view.
    DATA lr_wizard TYPE REF TO z2ui5_cl_xml_view.
    DATA lr_wiz_step1 TYPE REF TO z2ui5_cl_xml_view.
    DATA lr_wiz_step2 TYPE REF TO z2ui5_cl_xml_view.
    DATA lr_wiz_step3 TYPE REF TO z2ui5_cl_xml_view.
    DATA lr_wiz_step4 TYPE REF TO z2ui5_cl_xml_view.
    lr_view = z2ui5_cl_xml_view=>factory( ).

    
    lr_dyn_page =  lr_view->dynamic_page(
        showfooter = abap_false  ).

    
    lr_header_title = lr_dyn_page->title( ns = 'f' )->get( )->dynamic_page_title( ).
    lr_header_title->heading( ns = 'f' )->title( `Demo - Wizard Control` ).
    
    lr_header = lr_dyn_page->header( ns = 'f' )->dynamic_page_header( pinnable = abap_true )->content( ns = 'f' ).
    
    lr_content = lr_dyn_page->content( ns = 'f' ).
    
    lr_wizard = lr_content->wizard( ).
    
    lr_wiz_step1 = lr_wizard->wizard_step( title = 'Step1'  validated          = abap_true ).
    lr_wiz_step1->message_strip( text = 'STEP1' ).
    
    lr_wiz_step2 = lr_wizard->wizard_step( title              = 'Step2'
                                                 validated          = abap_true ).

    lr_wiz_step2->message_strip( text = 'STEP2' ).
    
    lr_wiz_step3 = lr_wizard->wizard_step( title              = 'Step3'
                                                 validated          = abap_true ).

    lr_wiz_step3->message_strip( text = 'STEP3' ).
    
    lr_wiz_step4 = lr_wizard->wizard_step( title              = 'Step4'
                                                 validated          = abap_true ).

    lr_wiz_step4->message_strip( text = 'STEP4' ).

    ir_client->view_display( lr_view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->on_rendering( ir_client = client ).

  ENDMETHOD.
ENDCLASS.

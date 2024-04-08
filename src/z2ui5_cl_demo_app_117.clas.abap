CLASS z2ui5_cl_demo_app_117 DEFINITION
  PUBLIC
    INHERITING FROM Z2UI5_CL_DEMO_APP_131
  CREATE PUBLIC.

  PUBLIC SECTION.

  PROTECTED SECTION.

METHODS on_init REDEFINITION.

  PRIVATE SECTION.

ENDCLASS.

CLASS z2ui5_cl_demo_app_117 IMPLEMENTATION.




  METHOD on_init.

    DATA temp1 TYPE z2ui5_cl_demo_app_131=>ty_t_t002.
    DATA temp2 LIKE LINE OF temp1.
    CLEAR temp1.
    
    temp2-id = '1'.
    temp2-class = 'Z2UI5_CL_DEMO_APP_126'.
    temp2-count = '10'.
    temp2-table = 'Z2UI5_T001'.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = '2'.
    temp2-class = 'Z2UI5_CL_DEMO_APP_126'.
    temp2-count = '12'.
    temp2-table = 'Z2UI5_T002'.
    INSERT temp2 INTO TABLE temp1.
    mt_t002 = temp1.

    mv_selectedkey = '1'.

  ENDMETHOD.

ENDCLASS.

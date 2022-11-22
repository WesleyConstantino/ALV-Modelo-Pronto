
*----------------------------------------------------------------------*
*                             ****ALV******                            *
*                         No início do código                          *
*vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv*


*&---------------------------------------------------------------------*
*                          t_out e wa_out                              *
*&---------------------------------------------------------------------*
DATA: t_out  TYPE TABLE OF ztrewes001,       "Troco  ztrewes001 pela minha estrutura ou tabela 
      wa_out LIKE LINE OF t_out.





*||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||*
*||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||*





*----------------------------------------------------------------------*
*                             ****ALV******                            *
*                          No final do código                          *
*vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv*


*&---------------------------------------------------------------------*
*                      FORM:     zf_show_alv                           *
*                  Necessário alterar os campos abaixo                 *
*&---------------------------------------------------------------------*
FORM zf_show_alv.

  LOOP AT tg_mara INTO wg_mara.
    READ TABLE tg_makt INTO wg_makt WITH KEY matnr = wg_mara-matnr.

    wa_out-matnr = wg_mara-matnr.
    wa_out-ersda = wg_mara-ersda.
    wa_out-ernam = wg_mara-ernam.
    wa_out-maktx =  wg_makt-maktx.

    APPEND wa_out TO t_out.

    CLEAR: wa_out,
           wg_mara,
           wg_makt.
  ENDLOOP.
  PERFORM f_display_alv.
ENDFORM.


*&---------------------------------------------------------------------*
*                      FORM:     f_display_alv                           *
*&---------------------------------------------------------------------*
FORM f_display_alv.

* Declaração das variáveis base do ALV
  DATA: lt_fieldcat TYPE slis_t_fieldcat_alv,
        wa_layout   TYPE slis_layout_alv.


* Declaração das variáveis base do ALV
  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name       = 'ZTREWES001'    "Troco  ztrewes001 pela minha estrutura ou tabela 
      i_client_never_display = abap_true
    CHANGING
      ct_fieldcat            = lt_fieldcat[]
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2.


* Chamada da função que exibe o ALV em tela
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      is_layout     = wa_layout
      it_fieldcat   = lt_fieldcat[]
    TABLES
      t_outtab      = t_out[]  " Inserir a Tabela Interna.
    EXCEPTIONS
      program_error = 1
      OTHERS        = 2.

ENDFORM.

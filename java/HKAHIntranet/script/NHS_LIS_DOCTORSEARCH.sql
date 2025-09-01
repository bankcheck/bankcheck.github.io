create or replace
FUNCTION "NHS_LIS_DOCTORSEARCH"(V_DOCCODE  IN VARCHAR2,
                                                  V_DOCFNAME IN VARCHAR2,
                                                  V_DOCGNAME IN VARCHAR2,
                                                  V_DOCSEX   IN VARCHAR2,
                                                  V_DOCTYPE  IN VARCHAR2,
                                                  V_SPCCODE  IN VARCHAR2,
                                                  V_DOCBDATE IN VARCHAR2,
                                                  V_DOCSTS   IN VARCHAR2)
  RETURN TYPES.CURSOR_TYPE AS
  OUTCUR TYPES.CURSOR_TYPE;
BEGIN
  OPEN OUTCUR FOR
    SELECT '',
           DR.DOCCODE,
           DR.DOCFNAME,
           DR.DOCGNAME,
           DR.DOCSEX,
           SP.SPCNAME,
           DR.SPCCODE,
           DR.DOCMTEL,
           DR.DOCPTEL,
           DR.DOCHTEL,
           DR.DOCOTEL,
           DR.DOCTYPE,
           DR.DOCOFFADD1,
           DR.DOCOFFADD2,
           DR.DOCOFFADD3,
           DR.DOCOFFADD4
      FROM DOCTOR@IWEB DR, SPEC@IWEB SP
     WHERE DR.SPCCODE = SP.SPCCODE(+)
       AND (DR.DOCCODE LIKE '%' || V_DOCCODE || '%')
       AND (DR.DOCFNAME LIKE '%' || V_DOCFNAME || '%')
       AND (DR.DOCGNAME LIKE '%' || V_DOCGNAME || '%')
       AND (DR.DOCSEX = V_DOCSEX OR V_DOCSEX IS NULL)
       AND (DR.DOCTYPE = V_DOCTYPE OR V_DOCTYPE IS NULL)
       AND (DR.SPCCODE LIKE '%' || V_SPCCODE || '%')
       AND (DR.DOCBDATE = TO_DATE(V_DOCBDATE, 'DD/MM/YYYY') OR
           V_DOCBDATE IS NULL)
       AND (DR.DOCSTS = V_DOCSTS OR V_DOCSTS IS NULL)
     ORDER BY DR.DOCCODE;
  RETURN OUTCUR;
END NHS_LIS_DOCTORSEARCH;
CREATE OR REPLACE FUNCTION NHS_CMB_CARDTYPE(
 v_paycode IN VARCHAR2
)
RETURN Types.CURSOR_type
AS
  outcur types.cursor_type;
BEGIN
 if v_paycode is null then
   OPEN OUTCUR FOR
        SELECT craname
             FROM cardrate
             order by craname;
  else
    OPEN OUTCUR FOR
        SELECT craname
             FROM cardrate
             where paycode=v_paycode
             order by craname;
  end if;
   RETURN OUTCUR;
end NHS_CMB_CARDTYPE;
/



CREATE OR REPLACE FUNCTION NHS_UTL_GETCHARGECODE(
  v_Used VARCHAR2 := 'NO USE'
  )
  RETURN VARCHAR2
AS
  v_mrscode medreason.mrscode%TYPE;
  v_chrg VARCHAR2(300);
  CURSOR mrscode_cur (v_used_arg VARCHAR2) is
  select mrscode from medreason where (charge = -1) and (used = v_used_arg or v_used_arg = 'NO USE');
BEGIN
  open mrscode_cur (v_Used);
    loop
      fetch mrscode_cur into v_mrscode;
      exit when mrscode_cur%NOTFOUND;
      IF v_mrscode IS NOT NULL AND LENGTH(TRIM(v_mrscode)) > 0 THEN
        IF  v_chrg IS NULL THEN
          v_chrg := v_mrscode;
        ELSE
          v_chrg := v_chrg || ', ' || v_mrscode;
        END IF;
      END IF;
    end loop;
  close mrscode_cur;
  RETURN v_chrg;

  EXCEPTION
    WHEN OTHERS THEN
      RETURN 'NHS_UTL_GETCHARGECODE' || ' ' || SQLERRM;
END NHS_UTL_GETCHARGECODE;
/

create or replace
FUNCTION "NHS_LIS_STATUSVIEWALL"
(v_DUMMY IN VARCHAR2)
  RETURN TYPES.CURSOR_TYPE
AS
  OUTCUR    TYPES.CURSOR_TYPE;
  v_BPDAY   NUMBER;
BEGIN
  BEGIN
    SELECT Param1 INTO v_BPDAY FROM SysParam WHERE PARCDE = 'DUPBPDAY';
    IF v_BPDAY = 0 THEN
      v_BPDAY := 1;
    END IF;
  EXCEPTION WHEN OTHERS THEN
    v_BPDAY := 1;
  END;
  
  OPEN OUTCUR FOR
    select pbpid, patno, patidno, upper(patfname) as patfname, upper(patgname) as patgname from bedprebok
    WHERE BPBSTS = 'N'
       AND TRUNC(BPBHDATE) BETWEEN TRUNC(SYSDATE) AND
           TRUNC(SYSDATE) + v_BPDAY
    order by patfname, patgname;
  RETURN OUTCUR;
END NHS_LIS_STATUSVIEWALL;
/

create or replace
FUNCTION NHS_LIS_PATSTATVIEW_FILLNUM(
  dummy IN VARCHAR2
)
  RETURN Types.cursor_type
AS
  outcur Types.cursor_type;
BEGIN
   open outcur for
    select A.AA, B.BB from (SELECT COUNT(*) AS AA from Reg r,
    InPat i WHERE r.inpid = i.inpid  and r.regtype = 'I'
    and r.regsts = 'N' and i.inpddate is NULL) A,
    (SELECT COUNT(*) AS BB from bedprebok WHERE BPBHDATE >= trunc(sysdate)
    AND BPBSTS = 'N') B;

   RETURN outcur;
end NHS_LIS_PATSTATVIEW_FILLNUM;
/

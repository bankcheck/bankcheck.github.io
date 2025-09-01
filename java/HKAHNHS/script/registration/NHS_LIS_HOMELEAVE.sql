create or replace
function "NHS_LIS_HOMELEAVE"
(
    v_slpNo VARCHAR2
)
return types.cursor_type
AS
    v_inpId NUMBER;
    outcur types.cursor_type;

BEGIN
    SELECT i.INPID INTO v_inpId FROM slip s,
     reg r,
     inpat i
    WHERE s.REGID = r.REGID
      and r.INPID = i.INPID
      and s.SLPNO = v_slpNo;

      open outcur for
      select
       hlid,
       slpno,
       inpid,
       to_char(leave_date,'dd/mm/yyyy hh24:mi:ss'),
       leave_user,
       to_char(return_date,'dd/mm/yyyy hh24:mi:ss'),
       return_user
from
     home_leave
where
      slpno= v_slpNo
      and inpid = v_inpId;
    return outcur;
end NHS_LIS_HOMELEAVE;
/

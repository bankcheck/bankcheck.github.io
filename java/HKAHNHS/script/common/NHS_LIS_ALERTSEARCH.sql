CREATE OR REPLACE FUNCTION NHS_LIS_ALERTSEARCH
(
   v_userId in varchar2,
   v_patnum in varchar2
)
return types.cursor_type
as
  outcur types.cursor_type;
begin
  open outcur for

     select altid, altcode, altdesc from alert where altid in((Select distinct R.altid
        from Usrrole U, Rolaltlink R where U.Rolid = R.Rolid and U.Usrid = v_userId)intersect
        (Select altid from pataltlink where Patno = v_patnum and usrid_c is null));

     return outcur;
end NHS_LIS_ALERTSEARCH;
/



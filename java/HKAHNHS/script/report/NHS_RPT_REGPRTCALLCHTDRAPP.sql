create or replace
function "NHS_RPT_REGPRTCALLCHTDRAPP" (
	v_SGName varchar2,
	v_patNum varchar2,
	v_SteCode varchar2,
	v_DocCode varchar2,
  v_bkgid varchar2,
  v_slpNo varchar2,
  V_Nooflbl varchar2

)
	return TYPES.CURSOR_TYPE
as
	outcur TYPES.CURSOR_TYPE;
	v_patnoF varchar2(50);
  v_useid varchar2(200);
  v_amclerk varchar2(200);

begin 
	SELECT lpad(v_patNum, 10, ' ') into v_patnoF from dual;
  IF v_bkgid IS NOT NULL THEN
    select u.usrname into v_useid from booking b,usr u where upper(b.usrid)=upper(u.usrid) and b.bkgid=v_bkgid;
   END IF;
  IF v_slpNo IS NOT NULL THEN
  	select usrid into v_amclerk from slip s where s.slpno= v_slpNo;
    select usrname into v_useid from usr u where u.usrid = v_amclerk;
  END IF;
	OPEN outcur FOR
	SELECT
		v_SGName as bkgpname,
		v_patNum as patno,
		substr(v_patnoF, 1, 2) as patnoA,
		substr(v_patnoF, 3, 2) as patnoB,
		substr(v_patnoF, 5, 2) as patnoC,
		substr(v_patnoF, 7, 2) as patnoD,
		substr(v_patnoF, 9, 2) as patnoE,
		d.DocFname || ' ' || d.DocGname as DocName,
		d.DocCode,
		sp.spccode,
		TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI') as bkgsdate2,
		TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI') as bkgsdate,
		s.SteName,
		(SELECT DECODE(PATSTAFF, -1, '(S)', '') FROM PATIENT WHERE PATNO = V_PATNUM) as isStaff,
		GET_ALERT_CODE(V_PATNUM, GET_CURRENT_SteCode) as alert,
    v_useid as userID
	FROM
		Doctor d,
		Spec sp,
		Site s
     Left Join
    (Select 1 From Dual Connect By Level <= V_Nooflbl) On 1=1
	WHERE d.SpcCode = sp.SpcCode
	and   s.SteCode = v_SteCode
	and   d.DocCode = v_DocCode;

	return outcur;
end NHS_RPT_REGPRTCALLCHTDRAPP;
/

CREATE OR REPLACE FUNCTION "NHS_RPT_PRTCALLCHT" (
	i_FGName       VARCHAR2,
	i_patNo        VARCHAR2,
	i_userName     VARCHAR2,
	i_computerName VARCHAR2,
	i_siteName     VARCHAR2,
	i_Nooflbl      VARCHAR2
)
	RETURN types.cursor_type
as
	outcur types.cursor_type;
	v_Patnof VARCHAR2(50);
Begin
	SELECT LPAD(i_patNo, 10, ' ') INTO v_Patnof FROM DUAL;
	OPEN OUTCUR FOR
		SELECT
			i_FGName AS bkgpname,
			i_patNo AS patno,
			SUBSTR(v_Patnof, 1, 2) AS patnoA,
			SUBSTR(v_Patnof, 3, 2) AS patnoB,
			SUBSTR(v_Patnof, 5, 2) AS patnoC,
			SUBSTR(v_Patnof, 7, 2) AS patnoD,
			SUBSTR(v_Patnof, 9, 2) AS patnoE,
			i_userName AS docname,
			i_computerName AS spcname,
			TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI') AS bkgsdate2,
			TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI') AS bkgsdate,
			i_siteName AS stename,
			(SELECT DECODE(PATSTAFF, -1, '(S)', '') FROM PATIENT WHERE PATNO = i_patNo) AS isStaff,
			GET_ALERT_CODE(i_patNo, i_siteName) AS alert
		FROM DUAL
		LEFT JOIN
		(Select 1 From Dual Connect By Level <= i_Nooflbl) On 1=1;

	RETURN outcur;
end NHS_RPT_PRTCALLCHT;
/

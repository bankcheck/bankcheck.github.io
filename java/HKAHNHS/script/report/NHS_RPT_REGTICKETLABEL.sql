CREATE OR REPLACE FUNCTION "NHS_RPT_REGTICKETLABEL" (
	v_REGID IN VARCHAR2
)
	RETURN TYPES.CURSOR_TYPE
AS
	OUTCUR TYPES.CURSOR_TYPE;
BEGIN
	OPEN OUTCUR FOR
        	SELECT R.PATNO,
        		TO_CHAR(R.TICKETNO)AS TICKETNO,
                	NHS_UTL_TICKETFORMAT(r.ticketno, r.REGOPCAT) as newticketno,
                	d.docfname||' '||d.docgname, d.doccname AS doccname,
                	P.PATFNAME||' '||P.PATGNAME, P.PATCNAME,TO_CHAR(SYSDATE,'dd/mm/yyyy hh24:mi') AS CAPTIME,
                	(
                  		SELECT TO_CHAR(BKGSDATE, 'DD/MM/YYYY HH24:MI')
                  		FROM BOOKING
                  		WHERE BKGID = (SELECT BKGID FROM REG WHERE REGID = v_REGID)
                	) AS APPTTIME
        	FROM  REG R, DOCTOR D, PATIENT P
        	WHERE r.doccode = d.doccode
        	AND   R.PATNO = P.PATNO
        	AND   r.regid = v_REGID;
    	RETURN OUTCUR;
END NHS_RPT_REGTICKETLABEL;
/

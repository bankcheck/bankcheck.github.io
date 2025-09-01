CREATE OR REPLACE FUNCTION "NHS_RPT_APP2DBARCODE" (
	v_Patno VARCHAR2,
	v_Sltid VARCHAR2,
	v_Schid VARCHAR2,
	v_BKID  VARCHAR2,
	v_user  VARCHAR2
)
	RETURN types.cursor_type
AS
	v_bkgid Varchar2(100);
	v_SHOWCHIDATE VARCHAR2(1);
	Outcur Types.Cursor_Type;
BEGIN
	IF v_BKID IS NULL THEN
		SELECT Bkgid  Into v_bkgid
		FROM   Booking
		WHERE (Patno = v_Patno OR PATNO IS NULL)
		AND    Schid = v_Schid
		AND    Sltid = v_Sltid
		AND    Bkgsts = 'N';
	ELSE
		v_bkgid := v_BKID;
	END IF;

	SELECT PARAM1 INTO v_SHOWCHIDATE
	FROM   SYSPARAM
	WHERE  PARCDE = 'CHIAPPDATE';

	open outcur for
		SELECT
			b.Patno,
			DECODE(NVL(b.Patno, 'Non'),
				b.Patno,
				p.patfname || ' '|| p.patgname,
				'Non',
				b.Bkgpname) As Patname,
			DECODE(NVL(b.Patno, 'Non'), b.Patno, DECODE(NVL(p.patcname, ''), '', '', p.patcname, ',  ' || p.Patcname), 'Non', Decode(NVL(b.Bkgpcname, ''), '', '', b.Bkgpcname, ',  ' || b.Bkgpcname)) AS Patcname,
			TO_CHAR(b.bkgsdate,'dd Mon yyyy (Dy) HH12:MIAM','NLS_DATE_LANGUAGE=AMERICAN') AS appointDate,
			d.Docfname|| ' '|| d.Docgname||'<C>'||d.doccname As Doctorname,
			'<BT>AL</BT><CAPTURE>' || TO_CHAR(b.bkgcdate,'dd/mm/yyyy hh24:mi:ss')
				|| '</CAPTURE><CBY>'
				|| b.usrid
				|| '</CBY><PRINT>'
				|| TO_CHAR(sysdate,'dd/mm/yyyy hh24:mi:ss')
				||'</PRINT><PBY>'||v_user||'</PBY><ID>'
				|| b.bkgid
				||'</ID>' As Barcode,
			DECODE(v_SHOWCHIDATE, 'Y', TO_CHAR(b.bkgsdate,'yyyy"年"mm"月"dd"日" (Dy) AMHH12:MI','NLS_DATE_LANGUAGE=''TRADITIONAL CHINESE'''), '') AS chiAppointDate
		FROM  booking b, Schedule s, Doctor d, patient p
		WHERE b.patno   = p.patno(+)
		AND   b.schid   = s.schid
		AND   s.Doccode = d.Doccode
		And   B.Bkgid   = V_Bkgid
		AND   b.bkgsts  in ('N', 'F', 'C');
	RETURN Outcur;
end NHS_RPT_APP2DBARCODE;
/

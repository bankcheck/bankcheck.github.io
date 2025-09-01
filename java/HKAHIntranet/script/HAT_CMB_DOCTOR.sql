CREATE OR REPLACE FUNCTION "HAT_CMB_DOCTOR"( i_source IN VARCHAR2)
RETURN types.cursor_type
AS
outcur types.cursor_type;
BEGIN
	IF i_source = 'Pre-addmission' THEN
		OPEN outcur FOR
			SELECT doccode, docfname, docgname
			FROM  Doctor@IWEB
			where docsts=-1
			and   substr(doccode,1,1) between '1' and '9'
			and   not (substr(doccode,1,1) in ('7','9') and length(doccode)=4 )
			order by docfname;
	ELSIF i_source = 'obbooking' THEN
		OPEN outcur FOR
			SELECT D.doccode, D.docfname, D.docgname
			FROM   Doctor@IWEB D, OB_DOCTOR_QUOTA Q
			WHERE  D.DOCCODE = Q.OB_DOCTOR_CODE
			AND    Q.OB_ENABLED = 1
			GROUP BY D.doccode, D.docfname, D.docgname
			ORDER BY D.docfname, D.docgname;
	ELSIF i_source = 'osb' THEN
		OPEN outcur FOR
			SELECT doccode, docfname, docgname
			FROM  Doctor@IWEB
			where docsts=-1
			order by docfname;		
	ELSIF i_source = 'all' THEN
		OPEN outcur FOR
			SELECT doccode, docfname, docgname
			FROM  Doctor@IWEB			
			order by docfname, docgname;
	ELSE
		OPEN outcur FOR
			SELECT doccode, docfname, docgname
			FROM   Doctor@IWEB
			WHERE  docsts = '-1' and substr(doccode,1,1) between '1' and '9'
			AND    not (substr(doccode,1,1) in ('7','9') and length(doccode)=4 )
			AND    SPCCODE in ('OBGYN', 'REPMED')
			ORDER BY docfname, docgname;
	END IF;
	RETURN outcur;
END HAT_CMB_DOCTOR;
/
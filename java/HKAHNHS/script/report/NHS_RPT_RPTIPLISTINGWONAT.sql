create or replace
function "NHS_RPT_RPTIPLISTINGWONAT"
(
    v_stecode varchar2,
    V_SORTBY  varchar2
)
return types.cursor_type
as
    outcur types.cursor_type;
    sqlStr VARCHAR2(3000);
begin
	sqlStr := '
	   SELECT
	     sit.stename,
	     w.WRDNAME,
	     i.bedcode,
	     b.EXTPHONE,
	     i.acmcode,
	     p.patfname,
	     p.patgname,
	     p.patcname,
	     r.patno,
	     p.patsex,
	     p.patbdate,
	     r.doccode,
	     d.DOCFNAME,
	     d.DOCGNAME,
	     To_Char(R.Regdate,''ddMonyyyy'',''NLS_DATE_LANGUAGE=AMERICAN'') as regdate,
	     re.reldesc as religious,
	     p.mothcode,
	     to_char(r.regdate, ''HH24:MI'') as regtime,
	     decode(p.patbdate,null,'''',round(Months_between(sysdate,p.patbdate)/12-0.5)) as age,
	    To_Char(sysdate,''ddMonyyyy HH24:MI:SS'',''NLS_DATE_LANGUAGE=AMERICAN'') as prtdate,
	    p.racdesc
	FROM
	    inpat i,
	    reg r,
	    doctor d,
	    patient p,
	    bed b,
	    room rm,
	    site sit,
	    religious re,
		ward w
	WHERE
	      i.inpddate is null
	      AND r.stecode= ''' || v_stecode || '''
	      AND r.regsts = ''N''
	      AND r.regtype = ''I''
	      AND r.inpid = i.inpid
	      AND r.patno = p.patno
	      AND d.doccode = r.doccode
	      AND i.bedcode = b.bedcode
	      AND b.romcode = rm.romcode
	      AND p.religious = re.relcode (+)
		  AND w.wrdcode = rm.wrdcode
	      AND sit.stecode = r.stecode';
	IF V_SORTBY = 'racdesc' THEN
		sqlStr := sqlStr || ' order by p.racdesc,rm.wrdcode,i.bedcode';
	ELSE
		sqlStr := sqlStr || ' order by rm.wrdcode,i.bedcode';
	END IF;

	OPEN OUTCUR FOR sqlStr;
	RETURN OUTCUR;
end NHS_RPT_RPTIPLISTINGWONAT;
/
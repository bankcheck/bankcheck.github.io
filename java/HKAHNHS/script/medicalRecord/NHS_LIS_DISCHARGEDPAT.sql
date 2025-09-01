create or replace FUNCTION "NHS_LIS_DISCHARGEDPAT" (
	v_STECODE      IN VARCHAR2,
	v_INPDDATEFROM IN VARCHAR2,
	v_INPDDATETO   IN VARCHAR2,
	v_SDSCODE      IN VARCHAR2,
	v_WRDCODE      IN VARCHAR2,
	v_PATNO        IN VARCHAR2
)
	RETURN TYPES.CURSOR_TYPE
AS
	OUTCUR TYPES.CURSOR_TYPE;
	subdisstr VARCHAR2(2000);
	subdisqy varchar2(3000);
	tempstr varchar(100);
	regxcount number;
	sqlbuff VARCHAR2(5000);
BEGIN

	IF v_SDSCODE IS NOT NULL THEN
		subdisstr :=replace(v_SDSCODE,'/',',');
		subdisqy :=' AND ( ';
		regxcount := instr(subdisstr,',');
		WHILE regxcount > 0 LOOP
		tempstr := substr(subdisstr,0,regxcount-1);
		if (instr(tempstr,'-')) > 0 then
			subdisqy := subdisqy || ' (IP.SDSCODE >= '''||substr(tempstr,0,instr(tempstr,'-')-1)||''' and IP.SDSCODE <= '''||substr(tempstr,instr(tempstr,'-')+1,length(tempstr))||''' ) OR ';
		ELSE
			subdisqy := subdisqy || ' IP.SDSCODE = '''||tempstr||''' OR ';
		end if;
		subdisstr := substr(subdisstr,regxcount+1,length(subdisstr));
		regxcount := instr(subdisstr,',');
		END LOOP;
		if (length(subdisstr) > 0) then
			if (instr(subdisstr,'-')) > 0 then
				subdisqy := subdisqy || ' (IP.SDSCODE >= '''||substr(subdisstr,0,instr(subdisstr,'-')-1)||''' and IP.SDSCODE <= '''||substr(subdisstr,instr(subdisstr,'-')+1,length(subdisstr))||''' ) OR ';
			else
				subdisqy := subdisqy || ' IP.SDSCODE = '''||subdisstr||''' OR ';
			end if;
		end if;
		subdisqy := substr(subdisqy,0,length(subdisqy)-3)|| ') ';
	END IF;

	sqlbuff :=
		'SELECT DISTINCT *
			FROM (
				SELECT
					DECODE(TRUNC(P.PATBDATE) - TRUNC(R.REGDATE),
						0,
						DECODE(R.REGNB,-1, DECODE(IP.SDSCODE, NULL, NULL, ''*''),NULL),
						NULL) AS NEWBORNFLAG,
					IP.INPID,
					P.PATNO,
					P.PATFNAME || '' '' || P.PATGNAME AS PATNAME,
					P.PATMOTHER,
					DECODE(R.REGNB, -1, ''Y'', ''N'') AS NEWBORN,
					TO_CHAR(R.REGDATE,''DD/MM/YYYY HH24:MI:SS''),
					TO_CHAR(IP.INPDDATE,''DD/MM/YYYY HH24:MI:SS'')as inpdt,
					W.WRDCODE,
					IP.SDSCODE,
					IP.DESCODE,
					IP.RSNCODE,
					D.SPCCODE,--10
					TO_CHAR(IP.RECVDT,''DD/MM/YYYY''),
					TO_CHAR(IP.NURSERY,''DD/MM/YYYY''),
					TO_CHAR(IP.CODEDT,''DD/MM/YYYY''),
					IP.INPSBCNT,
					DECODE(COMPLICATION,-1, ''Y'', ''N''),
					IP.INPREMARK,
					DECODE(R.REGNB, -1, ''Y'', ''N'') AS ORINEWBORN,
					R.REGID AS REGID,
					SD.ISPAIRED,
					TO_CHAR(P.PATBDATE,''DD/MM/YYYY''),
					R.REGNB,
					COMPLICATION,
          '''' as INPR2
				FROM
					INPAT    IP,
					REG      R,
					PATIENT  P,
					WARD     W,
					DOCTOR   D,
					BED      B,
					ROOM     RM,
					SDISEASE SD
				WHERE IP.INPDDATE IS NOT NULL
				AND   R.INPID = IP.INPID
				AND   P.PATNO = R.PATNO
				AND   B.BEDCODE = IP.BEDCODE
				AND   B.STECODE = P.STECODE
				AND   RM.ROMCODE = B.ROMCODE
				AND   RM.STECODE = P.STECODE
				AND   W.WRDCODE = RM.WRDCODE
				AND   W.STECODE = P.STECODE
				AND   IP.SDSCODE = SD.SDSCODE(+)
				AND   D.DOCCODE = IP.DOCCODE_D
				AND   R.REGSTS <> ''C''
				AND   P.STECODE = '''||v_STECODE||'''
				AND   IP.INPDDATE >= TO_DATE('''||v_INPDDATEFROM||''', ''DD/MM/YYYY'')
				AND   IP.INPDDATE < TO_DATE('''||v_INPDDATETO||''', ''DD/MM/YYYY'') + 1';
	IF v_WRDCODE IS NOT NULL THEN
	      sqlbuff := sqlbuff || ' AND W.WRDCODE = '''||v_WRDCODE||'''';
	END IF;
	IF v_PATNO IS NOT NULL THEN
	      sqlbuff := sqlbuff || ' AND R.PATNO = '''||v_PATNO||'''';
	END IF;
	sqlbuff := sqlbuff ||subdisqy||' ORDER BY IP.INPDDATE, WRDCODE, PATNO)';
	sqlbuff := sqlbuff || ' order by to_date(inpdt,''DD/MM/YYYY HH24:MI:SS'') asc, WRDCODE,PATNO';
--	dbms_output.put_line(sqlbuff) ;
	OPEN OUTCUR FOR sqlbuff;
	RETURN OUTCUR;
END NHS_LIS_DISCHARGEDPAT;
/

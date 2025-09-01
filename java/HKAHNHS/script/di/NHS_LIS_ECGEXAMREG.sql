create or replace FUNCTION NHS_LIS_ECGEXAMREG (
	patNo IN VARCHAR2,
    diNo IN VARCHAR2,
    examPkgCode IN VARCHAR2
)
	RETURN Types.cursor_type

AS
	OUTCUR types.cursor_type;
	SQLREGSLIPTX VARCHAR2(32767);
	SQLEXISTSLIP VARCHAR2(32767);
	SQLSTR VARCHAR2(32767);
	SQLSTR1 VARCHAR2(32767);
	SQLSTR2 VARCHAR2(32767);
    SQLSTR3 VARCHAR2(32767);
    slpinfo_sql VARCHAR2(5000);
	varFName VARCHAR2(40);
	varGName VARCHAR2(40);
	l_slipNo SLIP.SLPNO%TYPE;
	l_regDate REG.REGDATE%TYPE;
	l_docCode REG.DOCCODE%TYPE;
	l_patType REG.REGTYPE%TYPE;
	l_bedCode INPAT.BEDCODE%TYPE;
	l_acmCode INPAT.ACMCODE%TYPE;
    
BEGIN
	/*IF diNo IS NOT NULL THEN 
        --GET PATNO
        SELECT * FROM REG;
    END IF;*/
    
    IF diNo IS NOT NULL THEN 
       /*
        SELECT
            x.SlpNo || 'X' || x.StnID as Key, 
            x.SlpNo, 
            s.SlpType, 
            s.DocCode,
            x.StnID, 
            st.StnTDate, 
            st.PkgCode, 
            st.ItmCode, 
            st.StnDesc,
            ST.STNDESC1 ,
            ST3.StnOAmt,
            ST3.StnBAmt,
            ST3.StnDisc,
            ST3.StnNAmt,
            ST3.ONAmt,
            ST3.OBAmt,
            --0 as Selected,
            decode(p.xrpid, Null, '', 'Y') As reported,
            st.UsrID, 
            st.GlcCode, 
            0 as ExmTime, 
            a.XapID,
            x.ermCode, 
            x.xrgRemark as Remark, 
            to_char(x.xrgDate ,'DD/MM/YYYY') as xrgDate ,
            ST.UNIT,	
            a.xapEstTime, 
            x.xrgID, 
            to_char(a.XapDate ,'DD/MM/YYYY HH24:MI') as XapDate ,
            '' as itemDesc
            FROM
                Xreg x, SlipTx st, Xapp a, Slip s, xreport p , SlipTx tmp, 
                (select sl.slpno,TMP.dixref, 
                to_char(Sum(decode(tmp.stnsts,'N',tmp.stnOAmt,0))) as StnOAmt,
                to_char(Sum(tmp.stnBAmt)) as StnBAmt,
                to_char(sum(decode(tmp.stnsts,'N',tmp.stnDisc,0))) as StnDisc,
                to_char(Sum(tmp.stnNAmt)) as StnNAmt,
                to_char(Sum(tmp.stnNAmt)) as ONAmt,
                to_char(Sum(tmp.stnBAmt)) as OBAmt 
                from sliptx TMP, xreg sl 
                Where tmp.DixRef = sl.Stnid 
                and sl.xjbno = 'DI1427717'
                group by sl.slpno,TMP.dixref) ST3 
            where X.StnID = st.StnID
            and st.dixref = tmp.dixref
            and st.SlpNo = s.SlpNo
            and st.DIXREF = x.StnID
            and x.StnID = a.StnID (+)
            and x.XjbNo = 'DI1427717'
            and x.XrgSts = 'N'
            and x.xrgid = p.xrgid(+) 
            AND ST.DIXREF = st3.DIXREF 
       */
       SQLSTR3 := 'SELECT
                    x.SlpNo || ''X'' || x.StnID as Key, 
                    x.SlpNo, 
                    s.SlpType, 
                    s.DocCode,
                    x.StnID, 
                    st.StnTDate, 
                    st.PkgCode, 
                    st.ItmCode, 
                    st.StnDesc,
                    ST.STNDESC1,
                    ST3.StnOAmt,
                    ST3.StnBAmt,
                    ST3.StnDisc,
                    ST3.StnNAmt,
                    ST3.ONAmt,
                    ST3.OBAmt,
                    --0 as Selected,
                    decode(p.xrpid, Null, '''', ''Y'') As reported,
                    st.UsrID, 
                    st.GlcCode, 
                    0 as ExmTime, 
                    a.XapID,
                    x.ermCode, 
                    x.xrgRemark as Remark, 
                    to_char(x.xrgDate ,''DD/MM/YYYY'') as xrgDate ,
                    ST.UNIT,	
                    a.xapEstTime, 
                    x.xrgID, 
                    to_char(a.XapDate ,''DD/MM/YYYY HH24:MI'') as XapDate ,
                    '''' as itemDesc
                    FROM
                        Xreg x, SlipTx st, Xapp a, Slip s, xreport p , SlipTx tmp, 
                        (select sl.slpno,TMP.dixref, 
                        to_char(Sum(decode(tmp.stnsts,''N'',tmp.stnOAmt,0))) as StnOAmt,
                        to_char(Sum(tmp.stnBAmt)) as StnBAmt,
                        to_char(sum(decode(tmp.stnsts,''N'',tmp.stnDisc,0))) as StnDisc,
                        to_char(Sum(tmp.stnNAmt)) as StnNAmt,
                        to_char(Sum(tmp.stnNAmt)) as ONAmt,
                        to_char(Sum(tmp.stnBAmt)) as OBAmt 
                        from sliptx TMP, xreg sl 
                        Where tmp.DixRef = sl.Stnid 
                        and sl.xjbno = ''' || diNo || '''
                        group by sl.slpno,TMP.dixref) ST3 
                    where X.StnID = st.StnID
                    and st.dixref = tmp.dixref
                    and st.SlpNo = s.SlpNo
                    and st.DIXREF = x.StnID
                    and x.StnID = a.StnID (+)
                    and x.XjbNo = ''' || diNo || '''
                    and x.XrgSts = ''N''
                    and x.xrgid = p.xrgid(+) 
                    AND ST.DIXREF = st3.DIXREF ';
    END IF;
    
	IF SUBSTR( patNo, 0, 1) = 'R' THEN
		/*SQLREGSLIPTX := 'SELECT G.STNID 
						FROM XREG G, XJOB J, OUTREFPAT O
						WHERE G.XJBNO = J.XJBNO 
						AND J.PATNO = O.ORPNO
						AND G.STNID IS NOT NULL
						AND J.PATNO = ''' || patNo || '''
						AND O.ORPFNAME = varFname 
						AND O.ORPGNAME = varGname';*/
		SQLEXISTSLIP := 'SELECT SLPNO FROM SLIP
						WHERE S.SLPFNAME = ''' || varFname || ''' 
						AND S.SLPGNAME = ''' || varGname || '''
						AND S.PATNO IS NULL ';
	ELSE 
		/*SQLREGSLIPTX := 'SELECT G.STNID  
						FROM XREG G, XJOB J  
						WHERE G.XJBNO = J.XJBNO  
						AND G.STNID IS NOT NULL  
						AND J.PATNO = ''' || patNo || ''' ';*/
		SQLEXISTSLIP := 'SELECT SLPNO FROM SLIP WHERE PATNO = ''' || patNo || ''' ' ;
	END IF;
    
	--SQLSTR1 SEARCH EXAM FOR OUTPATIENT (30 fields)
	SQLSTR1 := 'SELECT 
        TO_CHAR(ST.DIXREF) || ''X'' || TO_CHAR(A.XAPID) AS KEY, --0
        ST.SLPNO, 
        DECODE(S.SLPTYPE, ''D'', ''DC'', S.SLPTYPE) AS SLPTYPE, 
        ST.DOCCODE, 
        ST.DIXREF AS STNID, --0
        ST.STNTDATE, --0
        ST.PKGCODE AS PKGCODE, 
        ST.ITMCODE, 
        ST.STNDESC,
        ST. STNDESC1, 
        ST3.STNOAMT, 
        ST3.STNBAMT, 
        ST3.STNDISC, 
        ST3.STNNAMT, 
        ST3.ONAMT, 
        ST3.OBAMT,  
        --'''' AS SELECTED, 
        '''' AS REPORTED, 
        ST.USRID AS USRID, --0
        ST.GLCCODE, --0
        NVL(E.EXMTIME,0) AS EXMTIME,
        A.XAPID, --0  
        A.ERMCODE, 
        '''' AS REMARK, 
        to_char(NULL) AS xrgdate, 
        ST.UNIT,	
        a.xapEstTime, 
        to_char(NULL) AS xrgid, 
        to_char(a.XapDate ,''DD/MM/YYYY HH24:MI'') as XapDate ,
        '''' as itemDesc
        FROM SLIPTX ST, EXAM E, SLIP S, XAPP A, SLIPTX ST2,  
            (SELECT S1.SLPNO, ST2.DIXREF,  
            TO_CHAR(SUM(DECODE(ST2.STNSTS, ''N'', ST2.STNOAMT, 0))) AS STNOAMT, 
            TO_CHAR(SUM(ST2.STNBAMT)) AS STNBAMT, 
            TO_CHAR(SUM(DECODE(ST2.STNSTS, ''N'', ST2.STNDISC, 0))) AS STNDISC,  
            TO_CHAR(SUM(ST2.STNNAMT)) AS STNNAMT,  
            TO_CHAR( SUM(ST2.STNNAMT)) AS ONAMT,  
            TO_CHAR(SUM(ST2.STNBAMT)) AS OBAMT  
            FROM SLIPTX ST2, SLIP S1  
            WHERE ST2.SLPNO = S1.SLPNO 
            AND S1.PATNO = '''||patNo||''' 
            GROUP BY S1.SLPNO, ST2.DIXREF) ST3 
        WHERE ST.STNDIFLAG = -1  
        AND ST.SLPNO = S.SLPNO 
        AND ((S.SLPPAMT + S.SLPCAMT + S.SLPDAMT) <= 0 OR S.SLPTYPE <> ''O'' OR S.SLPUSEAR = -1) 
        AND ST.STNSTS = ''N'' 
        AND S.SLPNO IN ('||SQLEXISTSLIP||') 
        AND ST.ITMCODE = E.EXMCODE (+) 
        AND ST.DIXREF = A.STNID    (+)
        AND ST.SLPNO = ST2.SLPNO   
        AND ST.DIXREF = ST2.DIXREF   
        AND ST.SLPNO = ST3.SLPNO   
        AND ST.DIXREF = ST3.DIXREF
            UNION 
        SELECT  
        ''X'' || TO_CHAR(A.XAPID) AS KEY, 
        A.SLPNO, 
        '''' AS SLPTYPE, 
        '''' AS DOCCDE, 
        A.STNID,   --0
        A.XAPRDATE AS STNTDATE, --0
        A.PKGCODE AS PKGCODE,  
        A.EXMCODE AS ITMCODE, 
        I.ITMNAME AS STNDESC,   
        '''' AS STNDESC,   
        '''' AS STNOAMT, 
        '''' AS STNBAMT, 
        '''' AS STNDISC, 
        '''' AS STNNAMT, 
        '''' AS ONAMT, 
        '''' AS OBAMT, 
        --'''' AS SELECTED, 
        '''' AS REPORTED, 
        A.USRID_R AS USRID, --0
        '''' AS GLCCODE,   --0
        NVL(E.EXMTIME, 0) AS EXMTIME,
        A.XAPID, --0
        A.ERMCODE,
        '''' AS REMARK, 
        TO_CHAR(NULL) AS xrgdate,
        TO_NUMBER(NULL) AS UNIT, 
        A.XAPESTTIME,
        TO_CHAR(NULL) AS XRGID, 
        TO_CHAR(A.XAPDATE, ''DD/MM/YYYY HH24:MI'') AS XAPDATE,  
        '''' AS ITEMDESC  
        FROM XAPP A, ITEM I, EXAM E  
        WHERE A.EXMCODE = E.EXMCODE  (+)
        AND A.EXMCODE = I.ITMCODE   
        AND A.PATNO = ''' || patNo || '''  
        AND A.STNID IS NULL  
        AND SLPNO IS NULL 
        AND XAPSTS IN (''A'',''P'') 
        ORDER BY ITMCODE';

IF diNo IS NOT NULL THEN     
    SQLSTR := SQLSTR3;
ELSE
    SQLSTR := SQLSTR1;
END IF;

OPEN OUTCUR FOR SQLSTR;
RETURN OUTCUR;
--RETURN SQLSTR;
END NHS_LIS_ECGEXAMREG;
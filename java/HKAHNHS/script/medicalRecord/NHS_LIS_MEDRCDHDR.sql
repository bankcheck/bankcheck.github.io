CREATE OR REPLACE FUNCTION "NHS_LIS_MEDRCDHDR"(V_PATNO  IN VARCHAR2,
                                               V_MRHSTS IN VARCHAR2)

 RETURN TYPES.CURSOR_TYPE
 AS
  OUTCUR TYPES.CURSOR_TYPE;
  SQLSTR VARCHAR2(2000);

BEGIN
  SQLSTR := 'SELECT '' '',
              H.PATNO || ''/'' || H.MRHVOLLAB AS RECID,
              D.USRID,
              U.USRNAME,
              D.MRLID_S,
              L3.MRLDESC,
              DECODE(D.MRLID_R, NULL, D.MRLID_L, D.MRLID_R) AS MRLID_C,
              DECODE(D.MRLID_R, NULL, L1.MRLDESC,L2.MRLDESC),
              D.DOCCODE,
              DT.DOCFNAME || '' '' || DT.DOCGNAME,
              D.MRDRMK,
              H.MRMID,
              M.MRMDESC,
              H.MRHSTS,
              DECODE(H.MRHSTS,''N'', ''Normal'',''M'', ''Missing'',''D'', ''Delete'',''P'', ''Permanent delete''),
              TO_CHAR(D.MRDDDATE, ''DD/MM/YYYY HH24:MI:SS''),
              H.MRHID,
              D.MRDID,
              H.PATNO,
              D.MRLID_L,
              D.MRLID_R,
              H.MRHVOLLAB
         FROM MEDRECHDR H, MEDRECDTL D, DOCTOR DT, USR U,MEDRECLOC L1,MEDRECLOC L2,MEDRECLOC L3,MEDRECMED M
        WHERE H.MRDID = D.MRDID
          AND D.DOCCODE = DT.DOCCODE(+)
          AND H.MRMID = M.MRMID(+)
          AND D.USRID = U.USRID(+)
          AND D.MRLID_L = L1.MRLID(+)
          AND D.MRLID_R = L2.MRLID(+)
          AND D.MRLID_S = L3.MRLID(+)';

  IF V_MRHSTS = 'N' THEN
    SQLSTR := SQLSTR || ' AND H.MRHSTS <> ''P''';
  END IF;
  IF V_PATNO IS NOT NULL THEN
    SQLSTR := SQLSTR || ' AND H.PATNO = '''||V_PATNO||'''';
  END IF;
  SQLSTR := SQLSTR || ' ORDER BY DECODE(length(H.MRHVOLLAB),2,''0''||H.MRHVOLLAB,H.MRHVOLLAB) DESC';

  OPEN OUTCUR FOR SQLSTR;
    RETURN OUTCUR;
END NHS_LIS_MEDRCDHDR;
/

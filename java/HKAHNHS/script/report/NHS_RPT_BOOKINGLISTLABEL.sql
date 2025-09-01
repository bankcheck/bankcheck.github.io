create or replace FUNCTION "NHS_RPT_BOOKINGLISTLABEL" (
	v_BKGSDATE IN VARCHAR2,
	v_BKGEDATE IN VARCHAR2,
  	v_BKGCDATE IN VARCHAR2,
	v_DOCCODE  IN VARCHAR2,
	v_ORDERBY  IN VARCHAR2
)
	RETURN TYPES.CURSOR_TYPE
AS
	OUTCUR TYPES.CURSOR_TYPE;
BEGIN
	OPEN OUTCUR FOR
		SELECT D.DOCFNAME ||' ' ||D.DOCGNAME AS DOCNAME,
            TO_CHAR(B.BPBHDATE, 'HH24:MI (DD/MM/YYYY)'),
            DECODE(Is_Number(B.PATNO), 0, TRIM(TO_CHAR(B.PATNO, '0000000')), B.PATNO) AS PATNO_T,
            B.BPBPNAME,
            W.WRDNAME,
            (
              SELECT L.MRLDESC
              FROM   MEDRECHDR H, MEDRECDTL D, MEDRECLOC L, DOCTOR DOC
              WHERE  H.PATNO = B.PATNO
              AND    D.DOCCODE = DOC.DOCCODE(+)
              AND    H.MRHVOLLAB = (SELECT MAX(MRHVOLLAB) AS MAXVOL FROM MEDRECHDR WHERE PATNO = H.PATNO AND MRHSTS = 'N')
              AND    H.MRDID = D.MRDID
              AND    NVL(D.MRLID_R, D.MRLID_L) = L.MRLID
              AND    H.mrhsts = 'N'
            ) AS LOC,
            (
              SELECT H.MRHVOLLAB
              FROM   MEDRECHDR H, MEDRECDTL D, MEDRECLOC L
              WHERE  H.PATNO = B.PATNO
              AND    H.MRHVOLLAB = (SELECT MAX(MRHVOLLAB) AS MAXVOL FROM MEDRECHDR WHERE PATNO = H.PATNO AND MRHSTS = 'N')
              AND    H.MRDID = D.MRDID
              AND    NVL(D.MRLID_R, D.MRLID_L) = L.MRLID
              AND    H.mrhsts = 'N'
            ) AS VOLNUM
    FROM BEDPREBOK B, DOCTOR D, WARD W
    WHERE W.WRDCODE = B.WRDCODE
    AND D.DOCCODE = B.DOCCODE
    AND B.BPBSTS = 'N'
    AND B.PATNO IS NOT NULL
    AND (B.BPBODATE >= TO_DATE(replace(v_BKGCDATE,'+',' '), 'DD/MM/YYYY HH24:MI') OR v_BKGCDATE IS NULL)
    AND (
          (
            B.WRDCODE <> 'U100'
            AND B.BPBHDATE >= TO_DATE( replace(v_BKGSDATE,'+',' '), 'DD/MM/YYYY HH24:MI')
            AND B.BPBHDATE <= TO_DATE( replace(v_BKGEDATE,'+',' '), 'DD/MM/YYYY HH24:MI')
          )
          OR B.PBPID IN ( SELECT B.PBPID
                          FROM BEDPREBOK B, OT_APP OA, OT_PROC OP
                          WHERE B.WRDCODE = 'U100'
                          AND OP.OTPID = '179'
                          AND OA.OTPID = OP.OTPID
                          AND OA.PBPID = B.PBPID
                          AND OA.OTAOSDATE >= TO_DATE( replace(v_BKGSDATE,'+',' '), 'DD/MM/YYYY HH24:MI')
                          AND OA.OTAOSDATE <= TO_DATE( replace(v_BKGEDATE,'+',' '), 'DD/MM/YYYY HH24:MI')
                        )
        )
    --AND B.BPBHDATE >= TO_DATE( replace(v_BKGSDATE,'+',' '), 'DD/MM/YYYY HH24:MI')
    --AND B.BPBHDATE <= TO_DATE( replace(v_BKGEDATE,'+',' '), 'DD/MM/YYYY HH24:MI')
    AND (B.DOCCODE = v_DOCCODE OR v_DOCCODE IS NULL)
		ORDER BY
			CASE WHEN v_ORDERBY = 'P' THEN DECODE(Is_Number(B.PATNO), 0, TRIM(TO_CHAR(B.PATNO, '0000000')), LPAD(B.PATNO, 7, '0'))
				WHEN v_ORDERBY = 'T' THEN SUBSTR(LPAD(PATNO_T, 7, '0'), 10, 2)
				ELSE B.PATNO END,
			CASE WHEN v_ORDERBY = 'T' THEN SUBSTR(LPAD(PATNO_T, 7, '0'), 8, 2)
				ELSE B.PATNO END,
			CASE WHEN v_ORDERBY = 'T' THEN SUBSTR(LPAD(PATNO_T, 7, '0'), 6, 2)
				ELSE B.PATNO END,
			CASE WHEN v_ORDERBY = 'T' THEN SUBSTR(LPAD(PATNO_T, 7, '0'), 4, 2)
				ELSE B.PATNO END,
			CASE WHEN v_ORDERBY = 'T' THEN SUBSTR(LPAD(PATNO_T, 7, '0'), 2, 2)
				ELSE B.PATNO END
--		AND S.DOCCODE IN (v_DOCCODESS)
		;

	RETURN Outcur;
END NHS_RPT_BOOKINGLISTLABEL;
/
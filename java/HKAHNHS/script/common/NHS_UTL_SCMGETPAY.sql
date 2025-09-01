CREATE OR REPLACE FUNCTION "NHS_UTL_SCMGETPAY" (
    v_SLPNO     IN VARCHAR2,
    v_WITHZERO  IN BOOLEAN
)
    RETURN TYPES.CURSOR_TYPE
AS
    OUTCUR TYPES.CURSOR_TYPE;
    SQLSTR VARCHAR2(8000);

    SLIPTX_TYPE_CREDIT VARCHAR2(1) := 'C';
    SLIPTX_TYPE_REFUND VARCHAR2(1) := 'R';
    SLIPTX_TYPE_PAYMENT_C VARCHAR2(1) := 'S';
    SLIPTX_TYPE_DEPOSIT_I VARCHAR2(1) := 'I';
    SLIPTX_STATUS_NORMAL VARCHAR2(1) := 'N';
BEGIN
    SQLSTR := 'SELECT * FROM ((SELECT T.STNTYPE || T.STNID AS KEY, T.STNTYPE, T.ITMCODE,
                      T.STNDESC, T.STNXREF, T.STNCDATE, T.STNID AS PAYREF,
                      '''' AS ARCCODE, T.STNNAMT AS STNNAMT
               FROM SLIPTX T, SPECOMDTL SYD ';

    IF v_SLPNO IS NULL THEN
        SQLSTR := SQLSTR || 'WHERE 1 = 2 ';
    ELSE
        SQLSTR := SQLSTR ||
			'WHERE T.SLPNO = ''' || v_SLPNO || '''
			AND T.STNTYPE IN (''' || SLIPTX_TYPE_CREDIT || ''', ''' || SLIPTX_TYPE_REFUND || ''', ''' || SLIPTX_TYPE_PAYMENT_C || ''', ''' || SLIPTX_TYPE_DEPOSIT_I || ''')
			AND T.STNID = SYD.PAYREF(+)
			AND T.STNASCM IS NULL
			AND T.STNSTS = ''' || SLIPTX_STATUS_NORMAL || ''' ';
    END IF;

    SQLSTR := SQLSTR ||
			'GROUP BY T.STNTYPE || T.STNID, T.STNTYPE, T.ITMCODE, T.STNDESC,
			        T.STNNAMT, T.STNXREF, T.STNCDATE, T.STNID ';

    IF v_WITHZERO THEN
        SQLSTR := SQLSTR || ') ';
    ELSE
        SQLSTR := SQLSTR || 'HAVING T.STNNAMT <> 0) ';
    END IF;

    SQLSTR := SQLSTR ||
              'UNION ALL
               (SELECT T.STNTYPE || C.ATXID AS KEY, T.STNTYPE, T.ITMCODE,
               T.STNDESC, T.STNXREF, C.ATXCDATE AS STNCDATE, C.ATXID AS PAYREF,
               C.ARCCODE, C.ATXAMT AS STNNAMT
               FROM SLIPTX T, ARTX D, ARTX C,
                    (SELECT * FROM SPECOMDTL
                      WHERE SLPNO = ''' || v_SLPNO || '''
                      AND STNTYPE = ''P'') SYD ';

    IF v_SLPNO IS NULL THEN
        SQLSTR := SQLSTR || 'WHERE 1 = 2 ';
    ELSE
        SQLSTR := SQLSTR ||
                  'WHERE T.SLPNO = '''||v_SLPNO||'''
                   AND T.STNTYPE = ''P''
                   AND T.STNXREF = D.ATXID
                   AND D.SLPNO = T.SLPNO
                   AND C.SLPNO = T.SLPNO
                   AND D.ATXID = C.ATXREFID
                   AND C.ATXID = SYD.PAYREF(+)
                   AND T.STNSTS = ''' || SLIPTX_STATUS_NORMAL || '''
                   AND C.ARPID IS NOT NULL
                   AND D.ATXSTS = ''' || SLIPTX_STATUS_NORMAL || '''
                   AND C.ATXSTS = ''' || SLIPTX_STATUS_NORMAL || '''
                   AND T.STNASCM IS NULL ';
    END IF;

    SQLSTR := SQLSTR ||
              'GROUP BY T.STNTYPE || C.ATXID, T.STNTYPE, T.ITMCODE, T.STNDESC,
                        C.ATXAMT, T.STNXREF, C.ATXCDATE, C.ATXID, C.ARCCODE ';

    IF v_WITHZERO THEN
        SQLSTR := SQLSTR || ') ';
    ELSE
        SQLSTR := SQLSTR || 'HAVING C.ATXAMT <> 0) ';
    END IF;

    SQLSTR := SQLSTR || ') ORDER BY KEY DESC ';

    OPEN OUTCUR FOR SQLSTR;
    RETURN OUTCUR;
EXCEPTION
WHEN OTHERS THEN
    dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);

    RETURN NULL;
END NHS_UTL_SCMGETPAY;
/

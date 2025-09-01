create or replace FUNCTION "NHS_ACT_CREATE_DPC"
(   v_action    IN VARCHAR2,
    v_REGID     IN VARCHAR2,
    v_PATNO     IN VARCHAR2,
    v_DOCCODE   IN VARCHAR2, 
    v_VERSION   IN VARCHAR2,
    v_USERID    IN VARCHAR2,
    v_SELECTITEM IN VARCHAR2,
    v_source IN VARCHAR2
)
  RETURN TYPES.CURSOR_TYPE
AS
	OUTCUR TYPES.CURSOR_TYPE;

    v_DPCID DPCHARGE.DPCID%TYPE;
    V_DPCTXID DPCTX.DPCTXID%TYPE;
    v_ITMCODE DPCTX.ITMCODE%TYPE;
    v_PKGCODE DPCTX.PKGCODE%TYPE;
    v_PRICE DPCTX.DPCAMT%TYPE;
    v_DPCBOX DPCTX.DPCBOX%TYPE;
    V_UNIT DPCTX.UNIT%TYPE;
    v_ITEMTOTAL DPCTX.DPCAMTTOTAL%TYPE;
    V_ISINHATS VARCHAR2(1);    
        
    CURSOR v_RECORD IS 
        SELECT REGEXP_SUBSTR(v_SELECTITEM,'[^;]+', 1, LEVEL) AS TEMP FROM DUAL 
        CONNECT BY REGEXP_SUBSTR(v_SELECTITEM,'[^;]+', 1, LEVEL) IS NOT NULL;      
    
BEGIN
    IF v_action = 'ADD' THEN
        --GET NEW DPCID
        SELECT SEQ_DPCID.nextval INTO v_DPCID FROM DUAL;

      --INSERT NEW QUOTATION    
        INSERT INTO DPCHARGE
        (DPCID, DOCCODE, PATNO, REGID, VERSION, CREATEDATE, CREATEUSER, SOURCE) 
        VALUES
        (v_DPCID,v_DOCCODE,v_PATNO,v_REGID,v_VERSION,SYSDATE,v_USERID, v_source);

        FOR VAL IN v_RECORD LOOP
            BEGIN
                EXECUTE IMMEDIATE 
                'SELECT 
                REGEXP_SUBSTR('''||VAL.TEMP||''',''(^|,)([^,]*)'',1,1,null,2),
                REGEXP_SUBSTR('''||VAL.TEMP||''',''(^|,)([^,]*)'',1,2,null,2),
                REGEXP_SUBSTR('''||VAL.TEMP||''',''(^|,)([^,]*)'',1,3,null,2),
                REGEXP_SUBSTR('''||VAL.TEMP||''',''(^|,)([^,]*)'',1,4,null,2),
                REGEXP_SUBSTR('''||VAL.TEMP||''',''(^|,)([^,]*)'',1,5,null,2),
                REGEXP_SUBSTR('''||VAL.TEMP||''',''(^|,)([^,]*)'',1,6,null,2), 
                DECODE(REGEXP_SUBSTR('''||VAL.TEMP||''',''(^|,)([^,]*)'',1,7,null,2),''Y'',1,0) FROM DUAL'
                INTO v_ITMCODE, v_PKGCODE, v_PRICE, v_DPCBOX, v_UNIT, v_ITEMTOTAL, V_ISINHATS ;
            EXCEPTION WHEN OTHERS THEN
                ROLLBACK;
                v_DPCID:='-1';
            END;          
          
            SELECT SEQ_DPCTXID.nextval INTO v_DPCTXID FROM DUAL;
            
          --INSERT RECORD TO DPCTX    
            INSERT INTO DPCTX
            (DPCTXID, DPCID, ITMCODE, PKGCODE, DPCAMT, CREATEDATE, CREATEUSER, DPCBOX, UNIT, DPCAMTTOTAL, ISTXHATS) 
            VALUES
            (v_DPCTXID, v_DPCID, v_ITMCODE, v_PKGCODE, v_PRICE, SYSDATE,V_ISINHATS, v_DPCBOX, v_UNIT, v_ITEMTOTAL, TO_NUMBER(V_ISINHATS));
    
        END LOOP;  
    END IF;  
    OPEN OUTCUR FOR
        SELECT v_DPCID FROM DUAL;
    RETURN OUTCUR;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	DBMS_OUTPUT.PUT_LINE('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
    OPEN OUTCUR FOR
        SELECT '-1' FROM DUAL;
    RETURN OUTCUR;
END NHS_ACT_CREATE_DPC;
/

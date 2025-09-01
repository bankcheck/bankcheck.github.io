create or replace FUNCTION "NHS_ACT_ECGEXAMREG" 
(   	
	l_JobNo            IN VARCHAR2,		
	l_StnID            IN VARCHAR2,
	l_PatNo            IN VARCHAR2,
	l_PatType          IN VARCHAR2,
	l_FilmTo		   IN VARCHAR2,
	l_FilmName		   IN VARCHAR2,
	a_SlipNo           IN VARCHAR2,
	a_ItemCode         IN VARCHAR2,
	a_ItemType         IN VARCHAR2,
	a_EntryType        IN VARCHAR2,
	a_StnOAmt          IN NUMBER,
	a_StnBAmt          IN NUMBER,
	a_DoctorCode       IN VARCHAR2,
	a_ReportLevel      IN NUMBER,
	a_AccomodationCode IN VARCHAR2,
	a_Discount         IN NUMBER,
	a_PackageCode      IN VARCHAR2,
	a_capturedate      IN DATE,
	a_TransactionDate  IN DATE,
	a_Description      IN VARCHAR2,
	a_Status           IN VARCHAR2,
	a_GlcCode          IN VARCHAR2,
	a_ReferenceID      IN NUMBER,
	a_CashierClosed    IN BOOLEAN := FALSE,
	a_BedCode          IN VARCHAR2,
	a_dixref           IN NUMBER,
	a_flagToDi         IN BOOLEAN := TRUE,
	a_ConPceSetFlag    IN VARCHAR2 := '',
	a_Cpsid            IN NUMBER,
	a_unit             IN NUMBER,
	a_Stndesc1         IN VARCHAR2 := '',
	a_IRefNo           IN VARCHAR2,
	a_vDeptCode        IN VARCHAR2,
	a_userid           IN VARCHAR2
)
    RETURN NUMBER
AS
	o_errcode NUMBER;
    o_errmsg VARCHAR2(100);
	OUTCUR TYPES.CURSOR_TYPE;
	
	l_XRGID XREG.XRGID%TYPE;
	l_STNSTS VARCHAR2(1) := 'N';
	l_isSurCharge NUMBER;
    l_STNNAMT NUMBER(14,4);
    
	XREG_STATUS_NORMAL VARCHAR2(1) := 'N';
  
    DI_CHECKTRUE NUMBER:= -1;
    DI_CHECKFALSE NUMBER:= 0;
    DI_CHECKNULL NUMBER:= 1;

    rs_slip  slip%rowtype;
    rs_sliptx sliptx%rowtype;
	v_DIFlag SLIPTX.STNDIFLAG%TYPE;
	
    
    c_PATNO PATIENT.PATNO%TYPE;
    c_SLPNO VARCHAR2(15);
    c_PATTYPE VARCHAR2(1);
    c_DPTCODE DEPT.DPTCODE%TYPE;
	c_JOBNO VARCHAR2(15);
	c_STNID VARCHAR2(15);
    c_NormalStnid VARCHAR2(15);
    c_STNSEQ SLIPTX.STNSEQ%TYPE;
    
    c_PARAM VARCHAR2(1);
    
	UpdateXRDate BOOLEAN := False;
    v_XEXXRDATE XEXPIRE.XEXXRDATE%TYPE;
    v_XEXCTDATE XEXPIRE.XEXCTDATE%TYPE;
    v_XEXXRDIS XEXPIRE.XEXXRDIS%TYPE;
    v_XEXCTDIS XEXPIRE.XEXCTDIS%TYPE;
    UpdateCTDate BOOLEAN := False;
    REOPENDFLAG BOOLEAN := False;
    nSlip BOOLEAN := FALSE;
    isTrue boolean;
	o_stnid NUMBER;
	o_stnseq NUMBER;
    v_PARCDE VARCHAR2(10);
    
    
    v_EXMREP EXAM.EXMREP%TYPE;
    v_EXMCM EXAM.EXMCM%TYPE;
    v_EXMMOD EXAM.EXMMOD%TYPE;
    v_EXMECG EXAM.EXMECG%TYPE;
    
    has_EXMREP BOOLEAN := False; --EXAM.EXMREP%TYPE;
    has_EXMCM BOOLEAN := False; --EXAM.EXMCM%TYPE;
    has_EXMMOD BOOLEAN := False; --EXAM.EXMMOD%TYPE;
    has_EXMECG BOOLEAN := False; --EXAM.EXMECG%TYPE;
    
    v_ESCCODE EXSURCHG.ESCCODE%TYPE;

	
BEGIN

	o_errcode := 0;
	o_errmsg := 'OK';
       
        -- STNNAMT
		IF a_unit > 0 THEN
			IF a_Discount >0 THEN
				l_STNNAMT := ROUND((a_StnBAmt / a_unit) *
										(1 - a_Discount / 100)) * a_unit;
			ELSE
				l_STNNAMT := a_StnBAmt;
			END IF;
		ELSE
			l_STNNAMT := ROUND(a_StnBAmt *
									(1 - a_Discount / 100));
		END IF;
       
        --getExamOption
        SELECT EXMREP, EXMCM, EXMMOD, EXMECG 
        INTO v_EXMREP, v_EXMCM, v_EXMMOD, v_EXMECG
        FROM EXAM 
        WHERE EXMCODE = a_ItemCode;
        IF v_EXMREP IS NOT NULL THEN
            has_EXMREP := CASE WHEN v_EXMREP = DI_CHECKTRUE THEN TRUE ELSE FALSE END;
            has_EXMCM := CASE WHEN v_EXMCM = DI_CHECKTRUE THEN TRUE ELSE FALSE END;
            has_EXMMOD := CASE WHEN v_EXMMOD = DI_CHECKTRUE THEN TRUE ELSE FALSE END;
            has_EXMECG := CASE WHEN v_EXMECG = DI_CHECKTRUE THEN TRUE ELSE FALSE END;
            UpdateXRDate := has_EXMREP;
            UpdateCTDate := has_EXMCM; 
        END IF;
        
        
        --AddXRegSQL
        SELECT seq_XREG.NEXTVAL INTO l_XRGID FROM DUAL;
        BEGIN
            SELECT ESCCODE INTO v_ESCCODE FROM EXSURCHG WHERE ESCCODE = a_ItemCode; 
        EXCEPTION WHEN OTHERS THEN
            v_ESCCODE := NULL;
        END;
        l_isSurCharge := CASE WHEN v_ESCCODE IS NULL THEN DI_CHECKFALSE ELSE DI_CHECKTRUE END;
                
        INSERT INTO
        XREG
        (
            XRGID, 
            XJBNO,
            SLPNO,
            STNID,
            XRGDATE,
            USRID,
            XRGSC,
            XRGSTS,
            ERMCODE,
            XRGREMARK,
            XRGFILM,
            XRGCT,
            XRGRPTFLAG,
            XRGCMFLAG,
            XRGMODFLAG,
            XRGECGFLAG,
            XRGECG
        )
        VALUES 
        (
            l_XRGID,
            l_JobNo,
            a_SlipNo,
            l_StnID,
            a_TransactionDate, 
            a_userid,
            l_isSurCharge,
            XREG_STATUS_NORMAL,
            NULL,
            NULL,
            v_EXMREP,
            v_EXMCM,
            v_EXMREP,
            v_EXMCM,
            v_EXMMOD,
            v_EXMECG,
            v_EXMECG
        );
      
        
        -- XregAuditSQL
        INSERT INTO XREGADJ
        (XRAID,
        STNID,
        XRGID,
        XRADATE,
        XRASTS,
        XRAONAMT,
        XRANAMT,
        USRID
        )
        VALUES
        (seq_XREGADJ.NEXTVAL,
        l_StnID,
        l_XRGID,
        SYSDATE,
        l_STNSTS,
        a_StnOAmt,
        l_STNNAMT,
        a_userid
        );
        o_errmsg:= o_errmsg|| '// INSERT XREGADJ:';
        
        IF l_FilmTo != 'X' THEN
            IF NOT l_isSurCharge = DI_CHECKTRUE AND has_EXMREP THEN
                INSERT INTO XLENDRET
                (XLRID,
                XRGID,
                XJBTLOC,
                XJBTLOCDESC,
                XLRREMARK,
                XLRDEL
                )
                VALUES
                (seq_XLENDRET.NEXTVAL,
                l_XRGID,
                l_FilmTo,
                l_FilmName,
                NULL,
                DI_CHECKFALSE
                );
                o_errmsg:= o_errmsg|| '// INSERT XLENDRET:';
            END IF;
        END IF;
        
        -- UpdateExpireDate
        IF UpdateXRDate THEN
            v_PARCDE := 'XR'||l_PatType;
            SELECT PARAM1 INTO c_PARAM FROM SYSPARAM WHERE PARCDE = v_PARCDE;
            IF c_PARAM IS NULL THEN
                v_XEXXRDATE := NULL;
                v_XEXXRDIS := NULL;
            ELSE
                v_XEXXRDATE := add_months(sysdate,c_PARAM*12);
                v_XEXXRDIS := -1;
            END IF;
        ELSE
            v_XEXXRDATE := NULL;
            v_XEXXRDIS := NULL;
        END IF;
        
        IF UpdateCTDate THEN
            v_PARCDE := 'CT'||l_PatType;
            SELECT PARAM1 INTO c_PARAM FROM SYSPARAM WHERE PARCDE = v_PARCDE;
            IF c_PARAM IS NULL THEN
                v_XEXCTDATE := NULL;
                v_XEXCTDIS := NULL;
            ELSE
                v_XEXCTDATE := add_months(sysdate,c_PARAM*12);
                v_XEXCTDIS := -1;
            END IF;
        ELSE
            v_XEXCTDATE := NULL;
            v_XEXCTDIS := NULL;
        END IF;

        --UpdateSlip
        NHS_UTL_UPDATESLIP(a_SlipNo);
        
        o_errcode := 1;
	RETURN o_errcode;
EXCEPTION
WHEN OTHERS THEN
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);

	RETURN -999;
END NHS_ACT_ECGEXAMREG;
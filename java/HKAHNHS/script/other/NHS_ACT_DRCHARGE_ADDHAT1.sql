create or replace FUNCTION NHS_ACT_DRCHARGE_ADDHAT1 (
	i_DOCCODE     IN  VARCHAR2,
	i_DPCID       IN  VARCHAR2,
  i_REGID       IN  VARCHAR2,
  i_SLPNO       IN VARCHAR2,
	i_USRID       IN  VARCHAR2,
  i_pcname      IN VARCHAR2
)
  RETURN TYPES.CURSOR_TYPE
AS
	o_ERRCODE NUMBER;
	v_noOfRec NUMBER;
	v_CPSID ARCODE.CPSID%TYPE;
	v_PKGCODE SLIPTX.PKGCODE%TYPE;
	v_ITMCODE SLIPTX.ITMCODE%TYPE;
  v_ITMCODE1 SLIPTX.ITMCODE%TYPE;
	v_ITMCAT ITEM.ITMCAT%TYPE;
	v_STNOAMT SLIPTX.STNOAMT%TYPE;
	v_STNBAMT SLIPTX.STNBAMT%TYPE;
  v_DRINPUTAMT SLIPTX.STNBAMT%TYPE;
	v_STNDISC SLIP.SLPHDISC%TYPE;
	v_TRANSDATE VARCHAR2(10);
	v_DOCCODE2 SLIPTX.DOCCODE%TYPE;
	v_DOCNAME VARCHAR2(81);
	v_STNDESC SLIPTX.STNDESC%TYPE;
	v_ACMCODE2 SLIPTX.ACMCODE%TYPE;
  v_ACMCODE SLIPTX.ACMCODE%TYPE;
	v_STNDIFLAG VARCHAR2(2);
	v_STNCPSFLAG SLIPTX.STNCPSFLAG%TYPE;
	v_UNIT SLIPTX.UNIT%TYPE;
  v_DRINPUTUNIT SLIPTX.UNIT%TYPE;
	v_STNDESC1 SLIPTX.STNDESC%TYPE;
	v_IREFNO SLIPTX.IREFNO%TYPE;
	v_STNRLVL SLIPTX.STNRLVL%TYPE;
	v_ITMTYPE SLIPTX.ITMTYPE%TYPE;
	v_STNDIFLAG2 BOOLEAN;
	OUTCUR TYPES.CURSOR_TYPE;
	v_ITEMROW TYPES.CURSOR_TYPE;
  v_REGTYPE REG.REGTYPE%TYPE;
  o_errmsg	VARCHAR2(500); 
  --agree rate 
  v_stdamt ITEMCHG.ITCAMT1%TYPE;
  v_ardrchgamt ITEMCHG.ITCAMT1%TYPE;
  v_ardrchgamtPerUnit ITEMCHG.ITCAMT1%TYPE;
  v_ardrchgpct ITEMCHG.CPSPCT%TYPE;
  v_amt ITEMCHG.ITCAMT1%TYPE;
  v_pct ITEMCHG.CPSPCT%TYPE;
  v_CursorType 	TYPES.CURSOR_TYPE;
  v_CursorLock 	TYPES.CURSOR_TYPE;
  v_arccode ARDRCHG.ARCCODE%TYPE;
  v_slptype SLIP.SLPTYPE%TYPE;
  v_dpctxid DPCTX.DPCTXID%TYPE;
  v_lockResult integer;
  V_tellogid TELLOG.LOGID%TYPE;
  v_desc1 DPCTX.DESC1%TYPE;
  v_slpsts  SLIP.SLPSTS%TYPE;
  
BEGIN
	o_ERRCODE := 0;
	o_ERRMSG  := 'OK';

	v_noOfRec := 0;

	-- check doctor code
	IF i_DPCID IS NOT NULL THEN
		SELECT COUNT(1) INTO v_noOfRec
		FROM   DPCHARGE
		WHERE  DPCID = i_DPCID
    AND REGID = i_REGID
		AND    ENABLED = -1;


		IF v_noOfRec > 0 THEN
    
    FOR r IN (
          SELECT R.USRID, U.USRNAME
          FROM   RLOCK R, USR U
          WHERE  R.USRID = U.USRID
          AND    UPPER(R.RLKTYPE) = UPPER('Slip')
          AND    R.RLKKEY = i_SLPNO
          ) LOOP
          if (r.usrid is not null) THEN
            v_lockResult:=999;
          END IF;
    END LOOP;
  
    SELECT SLPSTS INTO v_slpsts FROM SLIP WHERE SLPNO = i_SLPNO;
    if (v_slpsts = 'C' OR v_slpsts = 'R') THEN
      v_lockResult := 777;
    END IF;
      
			OPEN OUTCUR FOR
				SELECT R.REGTYPE, null, T.ITMCODE, T.DPCAMTTOTAL, T.UNIT, T.DPCTXID, T.DPCAMT, T.DESC1
				FROM   DPCHARGE D, REG R,DPCTX T
        WHERE D.REGID = R.REGID 
        AND D.DPCID = T.DPCID
        AND D.DPCID = i_DPCID        
        AND D. REGID = i_REGID
        AND D.DOCCODE = i_DOCCODE
        AND T.ISTXHATS = 0
        AND    D.ENABLED = -1;
		END IF;
	END IF;

	IF v_noOfRec > 0 AND OUTCUR IS NOT NULL  THEN
    o_errcode := 888;
		BEGIN
			SELECT Cpsid INTO v_CPSID
			FROM   SLIP, ARCODE
			WHERE  SLIP.ARCCODE = ARCODE.ARCCODE
			AND    SLIP.SLPNO = i_SLPNO;
		EXCEPTION
		WHEN OTHERS THEN
			v_CPSID := NULL;
		END;

		LOOP
			FETCH OUTCUR INTO v_REGTYPE, v_ACMCODE, v_ITMCODE1, v_DRINPUTAMT, v_DRINPUTUNIT, v_dpctxid, v_ardrchgamtPerUnit, v_desc1 ;
			EXIT WHEN OUTCUR%NOTFOUND;
      
      if (v_lockResult = 999 OR v_lockResult = 777) THEN
        o_errcode := 999;
      ELSE
        o_errcode := 0;
      END IF;
      
      v_ITEMROW :=  NHS_GET_ITEMCHG('ADD',i_SLPNO,'O',to_char(sysdate,'dd/mm/yyyy'),v_ITMCODE1,v_DOCCODE2,'', v_DRINPUTUNIT, '0', '0', '0', '-1','TWAH', 'N', '0', NULL);


			IF v_ITEMROW IS NOT NULL THEN
				LOOP
					FETCH v_ITEMROW INTO v_PKGCODE, v_ITMCODE, v_ITMCAT, v_STNOAMT,
										v_STNBAMT, v_STNDISC, v_TRANSDATE, v_DOCCODE2, v_DOCNAME,
										v_STNDESC, v_ACMCODE2, v_STNDIFLAG, v_STNCPSFLAG,
										v_UNIT, v_STNDESC1, v_IREFNO, v_STNRLVL, v_ITMTYPE;
               
--        o_errcode := NHS_ACT_SYSLOG('ADD', 'DRCHARGE_ADDHAT', '1c', 'i_SLPNO:'||i_SLPNO||' v_ITMCODE:'||v_STNDESC||' v_STNBAMT:'||v_STNBAMT,'TWAH', NULL, o_errmsg); 
--                     o_errmsg :='v_UNIT:'||v_UNIT;

					EXIT WHEN v_ITEMROW%NOTFOUND;

					IF v_STNDIFLAG = 'Y' THEN
						v_STNDIFLAG2 := TRUE;
					ELSE
						v_STNDIFLAG2 := FALSE;
					END IF;
          
      v_ardrchgamt := null;
      v_ardrchgpct := null;
      v_stdamt := null;
      
     SELECT ARCCODE,SLPTYPE INTO v_arccode,v_slptype FROM SLIP where slpno = i_SLPNO;
          -- check ar agree rate for doctor
        IF NHS_UTL_ARDRCHG_EXIST1(v_ITMCODE,v_PKGCODE,i_SLPNO,v_ACMCODE,i_DOCCODE,TO_CHAR(SYSDATE, 'DD/MM/YYYY'), v_arccode) > 0 Then
      
        V_Cursortype := NHS_LIS_ARDRCHG_DTL(i_SLPNO, v_ITMCODE,
                                   v_PKGCODE,v_ACMCODE,
                                   i_DOCCODE,v_arccode,TO_CHAR(SYSDATE, 'DD/MM/YYYY'),i_USRID);
              LOOP
                FETCH v_CursorType INTO
                      v_ardrchgamt,
                      v_ardrchgpct,
                      v_stdamt;   
              
                  V_NOOFREC:= v_CursorType%ROWCOUNT;
                Exit When V_Cursortype%Notfound;
              End Loop;
              
              IF v_ardrchgamt IS NOT null then
                  v_amt := v_ardrchgamt;
              ELSIF v_ardrchgpct IS NOT NULL THEN
                  v_amt := v_STNBAMT;
                  v_pct := v_ardrchgpct;
              ELSE
                v_amt := v_STNBAMT;
                v_pct := v_STNDISC;
              end if;
      
        ELSE
                v_amt := v_DRINPUTAMT;
                v_pct := v_STNDISC;
        END IF;
        
      if (o_errcode != 999) then
					o_errcode := NHS_UTL_ADDENTRY(
									i_SLPNO, v_ITMCODE, v_ITMTYPE, 'D',
									v_STNOAMT, TO_NUMBER(v_amt), i_DOCCODE,
									v_STNRLVL, v_ACMCODE, TO_NUMBER(v_pct),
									v_PKGCODE, SYSDATE,
									TO_DATE(v_TRANSDATE, 'DD/MM/YYYY'),
									v_STNDESC, '', '', '', FALSE,
									null, '', v_STNDIFLAG2,
									v_STNCPSFLAG, v_CPSID, v_UNIT, NVL(V_DESC1,v_STNDESC1),
									v_IREFNO, NULL, i_USRID);
                       o_errcode := NHS_ACT_SYSLOG('ADD', 'DRCHARGE_ADDHAT', '1d', 'o_errcode:'||o_errcode||'i_DPCID:'||i_DPCID||' v_dpctxid:'||v_dpctxid||' v_ITMCODE:'||v_ITMCODE,'TWAH', NULL, o_errmsg); 
        end if;
        
        if(o_errcode = 999) then
          if (v_lockResult = 777) THEN
              o_errcode := 777;
          END IF;
          select SEQ_TELLOG.nextval into V_tellogid from dual;
          
            insert into TELLOG
              ( logid, fromsys, slpno, chargecde, amount, reasons, status, LASTUPDT, unit, irefno, TXTYPE,STNDESC1 )
            values
              ( V_tellogid, 'DOCCHG', i_SLPNO, v_ITMCODE, TO_NUMBER(v_amt/v_unit), 'Slip lock by other system.', 'N', sysdate, v_UNIT, v_dpctxid, '', v_desc1 );
        end if;
          IF (o_errcode >= 0) THEN
              UPDATE DPCTX 
              SET ISTXHATS = DECODE(o_errcode,999,-1,777,-1,1)
              WHERE DPCID = i_DPCID
              AND DPCTXID = v_dpctxid
              AND ITMCODE = v_ITMCODE
              AND ENABLED = 1;              
          END IF;
          
				END LOOP;
			END IF;
			CLOSE v_ITEMROW;
		END LOOP;
		CLOSE OUTCUR;
	END IF;
    OPEN OUTCUR FOR
        SELECT o_errcode FROM DUAL;
    RETURN OUTCUR;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	DBMS_OUTPUT.PUT_LINE('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
    OPEN OUTCUR FOR
        SELECT '-1' FROM DUAL;
    RETURN OUTCUR;
END NHS_ACT_DRCHARGE_ADDHAT1;
/

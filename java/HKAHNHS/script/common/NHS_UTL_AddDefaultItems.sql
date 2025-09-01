create or replace
FUNCTION NHS_UTL_AddDefaultItems (
	i_DOCCODE     IN  VARCHAR2,
	i_SLPNO       IN  VARCHAR2,
	i_REGTYPE     IN  VARCHAR2,
	i_ACMCODE     IN  VARCHAR2,
	i_BEDCODE     IN  VARCHAR2,
	i_USRID       IN  VARCHAR2,
	o_ERRMSG      OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_ERRCODE NUMBER;
	v_noOfRec NUMBER;
	v_CPSID ARCODE.CPSID%TYPE;
	v_PKGCODE SLIPTX.PKGCODE%TYPE;
	v_ITMCODE SLIPTX.ITMCODE%TYPE;
	v_ITMCAT ITEM.ITMCAT%TYPE;
	v_STNOAMT SLIPTX.STNOAMT%TYPE;
	v_STNBAMT SLIPTX.STNBAMT%TYPE;
	v_STNDISC SLIP.SLPHDISC%TYPE;
	v_TRANSDATE VARCHAR2(10);
	v_DOCCODE2 SLIPTX.DOCCODE%TYPE;
	v_DOCNAME VARCHAR2(81);
	v_STNDESC SLIPTX.STNDESC%TYPE;
	v_ACMCODE2 SLIPTX.ACMCODE%TYPE;
	v_STNDIFLAG VARCHAR2(2);
	v_STNCPSFLAG SLIPTX.STNCPSFLAG%TYPE;
	v_UNIT SLIPTX.UNIT%TYPE;
	v_STNDESC1 SLIPTX.STNDESC%TYPE;
	v_IREFNO SLIPTX.IREFNO%TYPE;
	v_STNRLVL SLIPTX.STNRLVL%TYPE;
	v_ITMTYPE SLIPTX.ITMTYPE%TYPE;
	v_STNDIFLAG2 BOOLEAN;
	v_WrdCode Ward.WrdCode%TYPE;
	OUTCUR TYPES.CURSOR_TYPE;
	v_ITEMROW TYPES.CURSOR_TYPE;
  
  --agree rate 
  v_stdamt ITEMCHG.ITCAMT1%TYPE;
  v_ardrchgamt ITEMCHG.ITCAMT1%TYPE;
  v_ardrchgpct ITEMCHG.CPSPCT%TYPE;
  v_amt ITEMCHG.ITCAMT1%TYPE;
  v_pct ITEMCHG.CPSPCT%TYPE;
  v_CursorType 	TYPES.CURSOR_TYPE;
  v_arccode ARDRCHG.ARCCODE%TYPE;
  v_slptype SLIP.SLPTYPE%TYPE;
  
BEGIN
	o_ERRCODE := 0;
	o_ERRMSG  := 'OK';

	IF i_BEDCODE IS NOT NULL THEN
		SELECT COUNT(1) INTO v_noOfRec
		FROM   Bed, Room, Ward
		WHERE  Bed.RomCode = Room.RomCode
		AND    Room.WrdCode = Ward.WrdCode
		AND    Bed.BedCode = i_BEDCODE;

		IF v_noOfRec > 0 THEN
			SELECT Ward.WrdCode INTO v_WrdCode
			FROM   Bed, Room, Ward
			WHERE  Bed.RomCode = Room.RomCode
			AND    Room.WrdCode = Ward.WrdCode
			AND    Bed.BedCode = i_BEDCODE;
		END IF;
	END IF;

	v_noOfRec := 0;

	-- check doctor code
	IF v_noOfRec = 0 THEN
		SELECT COUNT(1) INTO v_noOfRec
		FROM   HPSTATUS
		WHERE  HPTYPE = 'DOC2ITEM'
		AND    HPKEY = i_DOCCODE
		AND    HPACTIVE = -1;

		IF v_noOfRec > 0 THEN
			OPEN OUTCUR FOR
				SELECT HPSTATUS
				FROM   HPSTATUS
				WHERE  HPTYPE = 'DOC2ITEM'
				AND    HPKEY = i_DOCCODE
				AND    HPACTIVE = -1;
		END IF;
	END IF;

	-- check spec code
	IF v_noOfRec = 0 THEN
		SELECT COUNT(1) INTO v_noOfRec
		FROM   HPSTATUS
		WHERE  HPTYPE = 'SPEC2ITEM'
		AND    HPKEY = ( SELECT SPCCODE FROM DOCTOR WHERE DOCCODE = i_DOCCODE )
		AND    HPACTIVE = -1;

		IF v_noOfRec > 0 THEN
			OPEN OUTCUR FOR
				SELECT HPSTATUS
				FROM   HPSTATUS
				WHERE  HPTYPE = 'SPEC2ITEM'
				AND    HPKEY = ( SELECT SPCCODE FROM DOCTOR WHERE DOCCODE = i_DOCCODE )
				AND    HPACTIVE = -1;
		END IF;
	END IF;

	-- check ward code
--	IF v_noOfRec = 0 AND v_WrdCode IS NOT NULL THEN
    IF v_noOfRec = 0 OR (v_WrdCode IS NOT NULL AND i_REGTYPE <> 'O' ) THEN
		SELECT COUNT(1) INTO v_noOfRec
		FROM   HPSTATUS
		WHERE  HPTYPE = 'WARD2ITEM'
		AND    HPKEY = v_WrdCode
		AND    HPACTIVE = -1;

		IF v_noOfRec > 0 THEN
			OPEN OUTCUR FOR
				SELECT HPSTATUS
				FROM   HPSTATUS
				WHERE  HPTYPE = 'WARD2ITEM'
				AND    HPKEY = v_WrdCode
				AND    HPACTIVE = -1;
		END IF;
	END IF;

	IF v_noOfRec > 0 AND OUTCUR IS NOT NULL THEN
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
			FETCH OUTCUR INTO v_ITMCODE;
			EXIT WHEN OUTCUR%NOTFOUND;

			v_ITEMROW := NHS_GET_ITEMCHG(
							'ADD', i_SLPNO, i_REGTYPE, TO_CHAR(SYSDATE, 'DD/MM/YYYY'),
							v_ITMCODE, i_DOCCODE, i_ACMCODE, '1', '0', '0', '0', '-1',
							i_USRID, 'N', '0', NULL);

			IF v_ITEMROW IS NOT NULL THEN
				LOOP
					FETCH v_ITEMROW INTO v_PKGCODE, v_ITMCODE, v_ITMCAT, v_STNOAMT,
										v_STNBAMT, v_STNDISC, v_TRANSDATE, v_DOCCODE2, v_DOCNAME,
										v_STNDESC, v_ACMCODE2, v_STNDIFLAG, v_STNCPSFLAG,
										v_UNIT, v_STNDESC1, v_IREFNO, v_STNRLVL, v_ITMTYPE;
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
        IF NHS_UTL_ARDRCHG_EXIST1(v_ITMCODE,v_PKGCODE,i_SLPNO,i_ACMCODE,i_DOCCODE,TO_CHAR(SYSDATE, 'DD/MM/YYYY'), v_arccode) > 0 Then
      
        V_Cursortype := NHS_LIS_ARDRCHG_DTL(i_SLPNO, v_ITMCODE,
                                   v_PKGCODE,i_ACMCODE,
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
                v_amt := v_STNBAMT;
                v_pct := v_STNDISC;
        END IF;

					o_errcode := NHS_UTL_ADDENTRY(
									i_SLPNO, v_ITMCODE, v_ITMTYPE, 'D',
									v_STNOAMT, TO_NUMBER(v_amt), i_DOCCODE,
									v_STNRLVL, i_ACMCODE, TO_NUMBER(v_pct),
									v_PKGCODE, SYSDATE,
									TO_DATE(v_TRANSDATE, 'DD/MM/YYYY'),
									v_STNDESC, '', '', '', FALSE,
									i_BEDCODE, '', v_STNDIFLAG2,
									v_STNCPSFLAG, v_CPSID, v_UNIT, v_STNDESC1,
									v_IREFNO, NULL, i_USRID);
				END LOOP;
			END IF;
			CLOSE v_ITEMROW;
		END LOOP;
		CLOSE OUTCUR;
	END IF;

	RETURN o_errcode;
EXCEPTION
WHEN OTHERS THEN
	o_errmsg := SQLERRM;
	DBMS_OUTPUT.PUT_LINE('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	RETURN -999;
END NHS_UTL_AddDefaultItems;
/

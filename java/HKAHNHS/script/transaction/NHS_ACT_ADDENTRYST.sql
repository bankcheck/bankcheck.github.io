create or replace
FUNCTION NHS_ACT_ADDENTRYST(
    	v_action           IN VARCHAR2,
    	i_usrid            IN VARCHAR2,
	v_ADDENTRY         IN TEMPLATE_OBJ_TAB,
    	o_errmsg           OUT VARCHAR2
)
	RETURN NUMBER
AS
    	o_errcode  NUMBER;
    	v_syslog_remark	syslog.remark%TYPE;
      
      --agree rate 
    v_stdamt ITEMCHG.ITCAMT1%TYPE;
    v_ardrchgamt ITEMCHG.ITCAMT1%TYPE;
    v_ardrchgpct ITEMCHG.CPSPCT%TYPE;
    v_amt ITEMCHG.ITCAMT1%TYPE;
    v_pct ITEMCHG.CPSPCT%TYPE;
    v_CursorType 	TYPES.CURSOR_TYPE;
    v_arccode ARDRCHG.ARCCODE%TYPE;
    v_slptype SLIP.SLPTYPE%TYPE;
    v_noOfRec  		number;
BEGIN
	o_errmsg := 'OK';
	o_errcode := 0;
  V_NOOFREC := 0;

	IF v_action = 'ADD' OR v_action = 'MOD' THEN
		FOR I IN 1..v_ADDENTRY.COUNT LOOP
      v_ardrchgamt := null;
      v_ardrchgpct := null;
      v_stdamt := null;
      
     SELECT ARCCODE,SLPTYPE INTO v_arccode,v_slptype FROM SLIP where slpno = v_ADDENTRY(I).COLUMN01;
          -- check ar agree rate for doctor
        IF NHS_UTL_ARDRCHG_EXIST1(V_ADDENTRY(I).COLUMN02,V_ADDENTRY(I).COLUMN11,V_ADDENTRY(I).COLUMN01,V_ADDENTRY(I).COLUMN09,V_ADDENTRY(I).COLUMN07,V_ADDENTRY(I).COLUMN13, v_arccode) > 0 Then
      
V_Cursortype := NHS_LIS_ARDRCHG_DTL(V_ADDENTRY(I).COLUMN01, V_ADDENTRY(I).COLUMN02,
                                   V_ADDENTRY(I).COLUMN11,V_ADDENTRY(I).COLUMN09,
                                   v_ADDENTRY(I).COLUMN07,v_arccode,v_ADDENTRY(I).COLUMN13,i_usrid);
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
                  v_amt := V_ADDENTRY(I).COLUMN06;
                  v_pct := v_ardrchgpct;
              ELSE
                v_amt := V_ADDENTRY(I).COLUMN06;
                v_pct := V_ADDENTRY(I).COLUMN10;
              end if;
      
        ELSE
                v_amt := V_ADDENTRY(I).COLUMN06;
                v_pct := V_ADDENTRY(I).COLUMN10;
        END IF;
        
			o_errcode := NHS_UTL_ADDENTRY(
				V_ADDENTRY(I).COLUMN01,
				V_ADDENTRY(I).COLUMN02,
				V_ADDENTRY(I).COLUMN03,
				V_ADDENTRY(I).COLUMN04,
				TO_NUMBER(V_ADDENTRY(I).COLUMN05),
				--TO_NUMBER(V_ADDENTRY(I).COLUMN06),
        TO_NUMBER(v_amt),
				V_ADDENTRY(I).COLUMN07,
				TO_NUMBER(V_ADDENTRY(I).COLUMN08),
				V_ADDENTRY(I).COLUMN09,
				--TO_NUMBER(V_ADDENTRY(I).COLUMN10),
        TO_NUMBER(v_pct),
				V_ADDENTRY(I).COLUMN11,
				TO_DATE(V_ADDENTRY(I).COLUMN12, 'DD/MM/YYYY HH24:MI:SS'),
				TO_DATE(V_ADDENTRY(I).COLUMN13, 'DD/MM/YYYY HH24:MI:SS'),
				V_ADDENTRY(I).COLUMN14,
				V_ADDENTRY(I).COLUMN15,
				V_ADDENTRY(I).COLUMN16,
				TO_NUMBER(V_ADDENTRY(I).COLUMN17),
				CASE WHEN V_ADDENTRY(I).COLUMN18 = '-1' THEN TRUE ELSE FALSE END,
				V_ADDENTRY(I).COLUMN19,
				TO_NUMBER(V_ADDENTRY(I).COLUMN20),
				CASE WHEN V_ADDENTRY(I).COLUMN21 = '-1' THEN TRUE ELSE FALSE END,
				V_ADDENTRY(I).COLUMN22,
				TO_NUMBER(V_ADDENTRY(I).COLUMN23),
				TO_NUMBER(V_ADDENTRY(I).COLUMN24),
				V_ADDENTRY(I).COLUMN25,
				V_ADDENTRY(I).COLUMN26,
				NULL,
				i_usrid
			);

			IF o_errcode < 0 THEN
				ROLLBACK;
				o_errmsg := 'insert fail.';
/*
				o_errmsg := 'insert fail.[' || V_ADDENTRY(I).COLUMN01 || ']['
							|| V_ADDENTRY(I).COLUMN02 || ']['
							|| V_ADDENTRY(I).COLUMN03 || ']['
							|| V_ADDENTRY(I).COLUMN04 || ']['
							|| V_ADDENTRY(I).COLUMN05 || ']['
							|| V_ADDENTRY(I).COLUMN06 || ']['
							|| V_ADDENTRY(I).COLUMN07 || ']['
							|| V_ADDENTRY(I).COLUMN08 || ']['
							|| V_ADDENTRY(I).COLUMN09 || ']['
							|| V_ADDENTRY(I).COLUMN10 || ']['
							|| V_ADDENTRY(I).COLUMN11 || ']['
							|| V_ADDENTRY(I).COLUMN12 || ']['
							|| V_ADDENTRY(I).COLUMN13 || ']['
							|| V_ADDENTRY(I).COLUMN14 || ']['
							|| V_ADDENTRY(I).COLUMN15 || ']['
							|| V_ADDENTRY(I).COLUMN16 || ']['
							|| V_ADDENTRY(I).COLUMN17 || ']['
							|| V_ADDENTRY(I).COLUMN18 || ']['
							|| V_ADDENTRY(I).COLUMN19 || ']['
							|| V_ADDENTRY(I).COLUMN20 || ']['
							|| V_ADDENTRY(I).COLUMN21 || ']['
							|| V_ADDENTRY(I).COLUMN22 || ']['
							|| V_ADDENTRY(I).COLUMN23 || ']['
							|| V_ADDENTRY(I).COLUMN24 || ']['
							|| V_ADDENTRY(I).COLUMN25 || ']['
							|| V_ADDENTRY(I).COLUMN26 || ']';
*/
				RETURN o_errcode;
			END IF;
		END LOOP;
	ELSE
		o_errmsg := 'parameter error.';
		o_errcode := -1;
	END IF;

	RETURN o_errcode;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	o_ErrMsg := SQLERRM || o_ErrMsg;

	o_errcode := -999;
	return o_errcode;
END NHS_ACT_ADDENTRYST;
/

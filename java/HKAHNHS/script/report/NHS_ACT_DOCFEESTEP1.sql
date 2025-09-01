CREATE OR REPLACE FUNCTION NHS_ACT_DOCFEESTEP1 (
v_ACTION		IN VARCHAR2,
v_DATEEND 		IN VARCHAR2,
v_IS_CONFIRM	IN VARCHAR2,
v_STECODE		IN VARCHAR2,
v_UserID		IN VARCHAR2,
v_COMP_NAME		IN VARCHAR2,
o_ERRMSG		OUT VARCHAR2)
	RETURN NUMBER
AS
	o_ERRCODE  NUMBER;
	v_ERRMSG  	VARCHAR2(1000);
	v_Count    	NUMBER;
	v_return    NUMBER;
	SQLSTR		VARCHAR2(2000);
	
	l_file        UTL_FILE.file_type;
    l_file_name   VARCHAR2(60);
	
	V_SPHID		NUMBER(22);
	v_STATUS	VARCHAR2(20);
	cp_DATEEND	df_chkpt.DATEEND%TYPE;
	cp_SPHID	df_chkpt.SPHID%TYPE;
	cp_STATUS	df_chkpt.STATUS%TYPE;
	cp_NEXTNO	df_chkpt.NEXTNO%TYPE;
	cp_PCYID	df_chkpt.PCYID%TYPE;
	cp_REPORT	df_chkpt.REPORT%TYPE;
	cp_USRID	df_chkpt.USRID%TYPE;
	cp_MACHINE	df_chkpt.MACHINE%TYPE;
	
	CUR1    	TYPES.CURSOR_TYPE;
	CUR2    	TYPES.CURSOR_TYPE;
	RETCUR    	TYPES.CURSOR_TYPE;
	V_bFindCommission	BOOLEAN;
	P_SPDID		Slppaydtl.SPDID%TYPE;
	P_stnid 	Slppaydtl.stnid%TYPE;
	P_slptype	Slppaydtl.slptype%TYPE;
	P_stntype	Slppaydtl.stntype%TYPE;
	P_payref	Slppaydtl.payref%TYPE;
	P_spdsts	Slppaydtl.spdsts%TYPE;
	P_spdid_r	Slppaydtl.spdid_r%TYPE;
	P_pcyid_D	Slppaydtl.pcyid%TYPE;
	P_doccode	sliptx.doccode%TYPE;
	P_itmcode	sliptx.itmcode%TYPE;
	P_dsccode	sliptx.dsccode%TYPE;
	P_dixref	sliptx.dixref%TYPE;
	P_stnsts	sliptx.stnsts%TYPE;
	P_pcyid_S	slip.pcyid%TYPE;
	P_stntdate	sliptx.stntdate%TYPE;
	P_dif_amt	FLOAT(126);
	V_FIXVALUE	FLOAT(126);
	V_PCTVALUE	FLOAT(126);
	V_reverse_spdpamt	FLOAT(126);
	V_reverse_spdcamt	FLOAT(126);
	V_curValue	FLOAT(126);
	V_preValue	FLOAT(126);
	V_SHRVALUE	FLOAT(126);
	
	C_STAGE_1 VARCHAR2(3) := '10';
	C_STAGE_2 VARCHAR2(3) := '20';
	C_STAGE_25 VARCHAR2(3) := '25';
	C_STAGE_27 VARCHAR2(3) := '27';
	C_STAGE_3 VARCHAR2(3) := '30';
	C_STAGE_4 VARCHAR2(3) := '40';
	C_STAGE_41 VARCHAR2(3) := '41';
	C_STAGE_42 VARCHAR2(3) := '42';
	C_STAGE_43 VARCHAR2(3) := '43';
	C_STAGE_44 VARCHAR2(3) := '44';
	C_STAGE_45 VARCHAR2(3) := '45';
	C_STAGE_5 VARCHAR2(3) := '50';
	C_STAGE_55 VARCHAR2(3) := '55';
	C_STAGE_6 VARCHAR2(3) := '60';
	C_STAGE_7 VARCHAR2(3) := '70';
	C_STAGE_75 VARCHAR2(3) := '75';
	C_STAGE_8 VARCHAR2(3) := '80';
	C_STAGE_9 VARCHAR2(3) := '90';
	C_STAGE_10 VARCHAR2(3) := '100';
	C_STAGE_11 VARCHAR2(3) := '110';
	C_REPORT_NAME_DOCFEE VARCHAR2(10) := 'Doctor Fee';
	C_SLIP_PAYMENT_CANCEL VARCHAR2(1) := 'C';
	C_SLIP_PAYMENT_B4_PAID_REVERSE VARCHAR2(1) := 'X';
	C_SLIPTX_STATUS_ADJUST VARCHAR2(1) := 'A';
	C_SLIPTX_STATUS_CANCEL VARCHAR2(1) := 'C';
	C_SLIPTX_STATUS_TRANSFER VARCHAR2(1) := 'T';
	C_SLIP_PAYMENT_USER_ALLOCATE VARCHAR2(1) := 'N';
	C_SLIP_PAYMENT_AUTO_ALLOCATE VARCHAR2(1) := 'A';
BEGIN
	o_ERRMSG  := 'OK';
	o_ERRCODE := -1;
	
	--------------
	-- log
	--------------
	SELECT 'NewDocFeeLog-' || TO_CHAR (SYSDATE, 'yyyymmddhh24miss') || '.txt'
     INTO l_file_name
     FROM DUAL;
     
     --l_file := UTL_FILE.fopen ('UTL_DIR', l_file_name, 'A');
     
	--------------
	-- DocFeeStep1
	--------------
	cp_DATEEND := NULL;
	cp_SPHID := NULL;
	cp_STATUS := NULL;
	cp_NEXTNO := NULL;
	cp_PCYID := NULL;
	cp_REPORT := NULL;
	cp_USRID := NULL;
	Cp_Machine := NULL;
  
	Cur1 := Nhs_Get_Docfee_Chkpt;
	Fetch Cur1 Into Cp_Dateend, Cp_Sphid, Cp_Status, Cp_Nextno, Cp_Pcyid, Cp_Report, Cp_Usrid, Cp_Machine;
	close Cur1;
	
	IF cp_SPHID IS NULL THEN
		V_SPHID := SEQ_SLPPAYHDR.NEXTVAL;
		INSERT INTO SLPPAYHDR(SPHID, SPHDATE, DATEEND, STECODE, CONFIRM)
		VALUES (
			V_SPHID,
			SYSDATE,
			TO_DATE(v_DATEEND, 'DD/MM/YYYY'),
			v_STECODE,
			CASE WHEN v_IS_CONFIRM = 'Y' THEN -1 ELSE 0 END
		);
		
		--DocFeeUpdateCheckpoint dEndDate, cp_sphid, STAGE_1, , , REPORT_NAME_DOCFEE, CurrentUser.UserID, ComputerName
		v_return := NHS_ACT_DOCFEE_UPDCHKPT('MOD', v_DATEEND, V_SPHID, C_STAGE_1, NULL, NULL, NULL, v_UserID, v_COMP_NAME, v_ERRMSG);
		v_STATUS := C_STAGE_1;
		COMMIT;
	ELSE
		IF cp_REPORT <> C_REPORT_NAME_DOCFEE OR cp_USRID <> v_UserID OR cp_machine <> v_COMP_NAME THEN
			o_ERRCODE := -101;
			o_ERRMSG  := 'Report is currently printing by ' || cp_USRID || ' at ' || cp_machine || '.';
			
			RETURN o_ERRCODE;
		END IF;
	END IF;
	
   	-- Update Detail Record
    IF v_STATUS = C_STAGE_1 THEN
    	UPDATE SLPPAYDTL SET SPHID = V_SPHID, STNNAMT = (select stnnamt from sliptx where slppaydtl.stnid = sliptx.stnid) where SPHID is null and SPDCDATE < TRUNC(TO_DATE(v_DATEEND, 'DD/MM/YYYY')) + 1;
    	v_return := NHS_ACT_DOCFEE_UPDCHKPT('MOD', NULL, NULL, C_STAGE_2, NULL, NULL, NULL, NULL, NULL, v_ERRMSG);
    	v_STATUS := C_STAGE_2;
    	COMMIT;
    END IF;
	
	
    -- Update Detail Record's Share Percentage and Fix Amount, STNNAMT
    -- Find Percentage and Fix Amount
    -- SlipTx's StnNAMT => SlpPayDtl's StnNAMT
    -- Sum Old Current Payment => Previous Payment
    IF v_STATUS = C_STAGE_2 THEN
		cp_DATEEND := NULL;
		cp_SPHID := NULL;
		cp_STATUS := NULL;
		cp_NEXTNO := NULL;
		cp_PCYID := NULL;
		cp_REPORT := NULL;
		cp_USRID := NULL;
		Cp_Machine := NULL;
	  
		Cur1 := Nhs_Get_Docfee_Chkpt;
		Fetch Cur1 Into Cp_Dateend, Cp_Sphid, Cp_Status, Cp_Nextno, Cp_Pcyid, Cp_Report, Cp_Usrid, Cp_Machine;
		close Cur1;

		OPEN CUR2 FOR 
			select d.spdid, d.stnid, d.slptype, d.stntype, d.payref, d.spdsts, d.spdid_r, d.pcyid as pcyid_d,
				tx.doccode, tx.itmcode, tx.dsccode, tx.dixref, tx.stnsts, s.pcyid as pcyid_s, tx.stntdate
			from slppaydtl d, sliptx tx, slip s
			where d.sphid = cp_SPHID
				and d.stnID = tx.stnID
				and tx.slpno = s.slpno
				and d.spdid in (
					Select Spdid 
					From Slppaydtl 
					Where Sphid = cp_SPHID
					And (Spdid > cp_nextNo OR cp_nextNo Is Null)
				)
				and spdsts not in (C_SLIP_PAYMENT_CANCEL, C_SLIP_PAYMENT_B4_PAID_REVERSE);
    	LOOP
			FETCH CUR2
				INTO P_SPDID, P_stnid, P_slptype, P_stntype, P_payref, P_spdsts, P_spdid_r, P_pcyid_D,
				P_doccode, P_itmcode, P_dsccode, P_dixref, P_stnsts, P_pcyid_S, P_stntdate;
		    EXIT WHEN CUR2%NOTFOUND;
		    V_COUNT := CUR2%ROWCOUNT;
		    
		    V_bFindCommission := True;
		    
		    IF P_spdid_r IS NOT NULL THEN
		        -- Reverse entry
                -- Share Amount => 0
                -- Original Allocated Amount => Amount to be reverse
                -- Original Current Amount => (-ve) Current Reverse Amount
		    
		    	SELECT COUNT(1) INTO v_Count FROM slppaydtl WHERE spdid = P_spdid_r;
				IF v_Count > 0 THEN
	                SELECT SPDPCT, SPDFAMT, SPDAAMT, -SPDCAMT
	                INTO V_PCTVALUE, V_FIXVALUE, V_reverse_spdpamt, V_reverse_spdcamt
	                FROM slppaydtl
	                WHERE spdid = P_spdid_r;
				END IF;
				
				IF V_PCTVALUE IS NOT NULL OR V_FIXVALUE IS NOT NULL THEN
                	V_bFindCommission := False;
                END IF;
		    ELSIF P_stnid <> P_dixref THEN
		        -- If previous Percentage or Fix Amt exist, use the previous one, otherwise, find new one
                -- => is Adjust, not Normal
		       	SELECT COUNT(1) INTO v_Count FROM slppaydtl WHERE spdid = P_spdid_r;
				IF v_Count > 0 THEN
			        SELECT SPDPCT,SPDFAMT 
			        INTO V_PCTVALUE, V_FIXVALUE
			        FROM slppaydtl
		            WHERE stnid = P_dixref
		            	AND sphid < cp_SPHID
		            	AND (pcyid = P_pcyid_S OR P_pcyid_S IS NULL);
		        ELSE
		        	V_PCTVALUE := NULL;
		        	V_FIXVALUE := NULL;
		        END IF;
		        
		        IF V_PCTVALUE IS NOT NULL OR V_FIXVALUE IS NOT NULL THEN
                	V_bFindCommission := False;
                END IF;
		    END IF;		    
		    
		    IF V_bFindCommission = TRUE THEN
				CUR1 := NHS_GET_DOCITMPCT(P_doccode, P_slptype, P_pcyid_S, P_dsccode, P_itmcode, P_stntdate, v_STECODE);
				FETCH CUR1 INTO V_PCTVALUE, V_FIXVALUE;	-- single row
				CLOSE CUR1;
		    END IF;
		    
		    -- Special Handle for Fix Amount and Adjust Entry
		    IF V_FIXVALUE IS NOT NULL AND P_stnsts = C_SLIPTX_STATUS_ADJUST THEN
		    	V_FIXVALUE := 0;
		    END IF;
		    
		    --In Report,
			-- Balance = Dr Share - Previous Payment - Current Payment
			-- if balance is ZERO, then the Applied Dr Fee Flag, "STNADOC", can be marked in transaction detail.
			
		    -- P_spdid_r IS NULL -> Is Normal Case,
		    -- 		In Dr Share Value, if stnsts is C or T -> Reimbusement: no matter how much is allocated, same amount of payment should be reverse back to Hospital 
		    -- P_spdid_r not null -> Dr Share Value of Reverse Entry should be 0
		    
		    
		    -- DEBUG
		    /*
		    IF P_SPDID = '3375815' THEN
		    	insert into syslog(MODULE, ACTION, REMARK, USERID, SYSTIME, PCNAME) 
		    	select 
		    		'DOCFEES1', C_STAGE_25,
		    		'spdid=3375815, V_PCTVALUE=' || V_PCTVALUE || ', V_FIXVALUE=' || V_FIXVALUE || ', P_spdid_r=' || P_spdid_r || ', SPDAAMT=' || SPDAAMT || ', STNNAMT=' || STNNAMT,
		    		'SYSTEM', sysdate, null
		    	from slppaydtl
		    	where spdid = P_SPDID;
		    	
		    END IF;
		    */
		    
		    -- update
	    	update slppaydtl 
	    	set SPDPCT = V_PCTVALUE, 
	    		SPDFAMT = V_FIXVALUE,
	    		SPDPAMT = CASE WHEN P_spdid_r IS NULL THEN
	    				(select nvl(sum(spdaamt),0) from slppaydtl where stnid = P_stnid and sphid < cp_sphid and spdsts in (C_SLIP_PAYMENT_USER_ALLOCATE, C_SLIP_PAYMENT_AUTO_ALLOCATE))
	    			ELSE V_reverse_spdpamt END,
	    		SPDSAMT = CASE WHEN P_spdid_r IS NULL THEN
	    				CASE WHEN P_stnsts = C_SLIPTX_STATUS_CANCEL OR P_stnsts = C_SLIPTX_STATUS_TRANSFER THEN 0 	-- 'Reimbusement: no matter how much is allocated, same amount of payment should be reverse back to Hospital
	    					ELSE CASE WHEN V_PCTVALUE IS NULL THEN V_FIXVALUE ELSE Round(STNNAMT * V_PCTVALUE/100) END
	    				END
	    			ELSE 0 END,
	    		SPDCAMT = CASE WHEN P_spdid_r IS NULL THEN
	    				CASE WHEN V_PCTVALUE IS NULL THEN Round(SPDAAMT * V_FIXVALUE / STNNAMT) ELSE Round(SPDAAMT * V_PCTVALUE /100) END
	    			ELSE V_reverse_spdcamt END,
	    		PCYID = CASE WHEN P_spdid_r IS NULL THEN P_pcyid_S else PCYID END
	    	where spdid = P_SPDID;
		END LOOP;
		CLOSE CUR2;
		

		v_return := NHS_ACT_DOCFEE_UPDCHKPT('MOD', NULL, NULL, C_STAGE_25, NULL, NULL, NULL, NULL, NULL, v_ERRMSG);
        v_STATUS := C_STAGE_25;
        COMMIT;
    END IF; 
    
    -- Update Last Allocation
    IF  v_STATUS = C_STAGE_25 THEN
		cp_DATEEND := NULL;
		cp_SPHID := NULL;
		cp_STATUS := NULL;
		cp_NEXTNO := NULL;
		cp_PCYID := NULL;
		cp_REPORT := NULL;
		cp_USRID := NULL;
		Cp_Machine := NULL;
	  
		Cur1 := Nhs_Get_Docfee_Chkpt;
		Fetch Cur1 Into Cp_Dateend, Cp_Sphid, Cp_Status, Cp_Nextno, Cp_Pcyid, Cp_Report, Cp_Usrid, Cp_Machine;
		close Cur1;
		
		OPEN CUR2 FOR 
		    select stnid, max(spdid) as spdid,
		      spdsamt - decode(spdpct,null,round(spdpamt*spdfamt/stnnamt),round(spdpamt*spdpct/100)) - sum(spdcamt) as dif_amt
		    From Slppaydtl
		    Where sphid = cp_SPHID
		    group by stnid, stnnamt, spdpamt, spdsamt, spdpct, spdfamt
		    having stnnamt - spdpamt - sum(spdaamt) = 0
		      And Spdsamt <> Decode(Spdpct,Null,Round(Spdpamt*Spdfamt/Stnnamt),Round(Spdpamt*Spdpct/100)) + Sum(Spdcamt)
		      and (cp_nextNo is null or stnid > cp_nextNo)
		    order by stnid;
    	LOOP
			FETCH CUR2
				INTO P_stnid, P_SPDID, P_dif_amt;
		    EXIT WHEN CUR2%NOTFOUND;
		    V_COUNT := CUR2%ROWCOUNT;
		    
		    -- DEBUG
		    /*
		    IF P_SPDID = '3375815' THEN
		    	insert into syslog(MODULE, ACTION, REMARK, USERID, SYSTIME, PCNAME) 
		    	select 
		    		'DOCFEES1', C_STAGE_3,
		    		'spdid=23161148, P_dif_amt=' || P_dif_amt || ', spdcamt=' || spdcamt,
		    		'SYSTEM', sysdate, null
		    	from slppaydtl
		    	where spdid = P_SPDID;
		    END IF;
		    */
		    
		    IF P_dif_amt <> 0 THEN
	            update slppaydtl
	            set spdcamt = spdcamt + P_dif_amt
	            where spdid = P_SPDID;
	        END IF;
		    
		    v_return := NHS_ACT_DOCFEE_UPDCHKPT('MOD', NULL, NULL, NULL, P_stnid, NULL, NULL, NULL, NULL, v_ERRMSG);

		END LOOP;
		CLOSE CUR2;
		
		v_return := NHS_ACT_DOCFEE_UPDCHKPT('MOD', NULL, NULL, C_STAGE_3, NULL, NULL, NULL, NULL, NULL, v_ERRMSG);
        v_STATUS := C_STAGE_3;
        COMMIT;
    END IF;
    --------------
	-- END of DocFeeStep1
	--------------

	--UTL_FILE.putf(l_file, l_file_name);
   	--UTL_FILE.fclose(l_file);
   
	o_ERRCODE := 0;

	RETURN o_ERRCODE;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	o_ERRMSG := SQLERRM;

	RETURN -999;
END NHS_ACT_DOCFEESTEP1;
/

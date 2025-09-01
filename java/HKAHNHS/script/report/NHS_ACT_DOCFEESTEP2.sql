CREATE OR REPLACE FUNCTION NHS_ACT_DOCFEESTEP2 (
v_ACTION		IN VARCHAR2,
V_OTP2 			IN VARCHAR2,
V_OTP3 			IN VARCHAR2,
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
	SQLSTR		VARCHAR2(3000);
	
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
	P_pcyid		df_sliptx.pcyid%TYPE;
	P_doccode	df_sliptx.doccode%TYPE;
	P_itmcode	df_sliptx.itmcode%TYPE;
	P_dsccode	df_sliptx.dsccode%TYPE;
  	P_slptype	Df_Sliptx.slptype%TYPE;
	P_Stnid 	Df_Sliptx.Stnid%Type;
	P_subgrp	Df_Sliptx.subgrp%TYPE;
	P_stntdate	Df_Sliptx.stntdate%TYPE;
	
	V_ROWID		VARCHAR(100);
	V_BUFFER_SIZE		NUMBER;
	
	V_FIXVALUE	FLOAT(126);
	V_PCTVALUE	FLOAT(126);
	V_curValue	FLOAT(126);
	V_preValue	FLOAT(126);
	V_SHRVALUE	FLOAT(126);
	V_STNNAMT	slppaydtl.STNNAMT%TYPE;
	V_IS_CALC_SHRVALUE	VARCHAR2(1) := 'N';
	
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
	
	SELECT 'NewDocFeeLog-' || TO_CHAR (SYSDATE, 'yyyymmddhh24miss') || '.txt'
     INTO l_file_name
     FROM DUAL;
     
     --l_file := UTL_FILE.fopen ('UTL_DIR', l_file_name, 'A');
     BEGIN
    	SELECT PARAM1 INTO V_BUFFER_SIZE FROM SYSPARAM WHERE PARCDE = 'DOCFEEBUFF';
     EXCEPTION WHEN OTHERS THEN
     	V_BUFFER_SIZE := 30;
     END;
    
	--------------
	-- DocFeeStep2
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
	
	-- Get Slip
	IF cp_status = C_STAGE_3 THEN
		execute immediate 'truncate table df_slip';
		
		INSERT into df_slip
		(
			select slpno from slip where slpadoc is null
			union
			select slpno from slppaydtl where sphid = cp_sphid
		);
		
		v_return := NHS_ACT_DOCFEE_UPDCHKPT('MOD', NULL, NULL, C_STAGE_4, NULL, NULL, NULL, v_UserID, v_COMP_NAME, v_ERRMSG);
		cp_status := C_STAGE_4;
		COMMIT;
	END IF;
	
	-- Part A for OUTSTANDING CHARGES
	-- Normal and Adjust
	IF cp_status = C_STAGE_4 THEN
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
		
		execute immediate 'truncate table df_sliptx';
		
		insert into df_sliptx
		(GRP,SUBGRP,DOCCODE,DOCFNAME,DOCGNAME,SLPNO,SLPTYPE,
			 STNID,STNSTS,STNCDATE,ITMCODE,STNDESC,STNBAMT,STNDISC,STNNAMT,
			 PATNO,SLPFNAME,SLPGNAME,PATFNAME,PATGNAME,PCYID,DSCCODE,stntdate,
			 ARCCODE,AR_PCT)
		select
			'C','A',
			d.doccode, d.docfname , d.docgname,
			s.slpno, s.slptype,
			tx.stnid, tx.stnsts, tx.stncdate, tx.itmcode, tx.stndesc, tx.stnbamt, tx.stndisc, tx.stnnamt,
			s.patno, s.slpfname, s.slpgname, p.patfname, p.patgname, s.pcyid, tx.dsccode, tx.stntdate, s.ARCCODE, ae.AR_PCT
		from
			df_slip ds, slip s, patient p, sliptx tx, doctor d, arcode_extra ae
		where
			ds.SlpNo = s.SlpNo
			and ds.slpno = tx.slpno
			and s.patno = p.patno (+)
			and s.ARCCODE = ae.ARCCODE (+)
			and tx.doccode = d.doccode
			and tx.stnsts in ('N','A')
			and tx.itmtype = 'D'
			and tx.stntype = 'D'
			and tx.stnadoc is null
			and tx.stncdate < cp_DATEEND + 1;
		
		-- DocFeeLog sql
		
		v_return := NHS_ACT_DOCFEE_UPDCHKPT('MOD', NULL, NULL, C_STAGE_41, NULL, NULL, NULL, v_UserID, v_COMP_NAME, v_ERRMSG);
		cp_status := C_STAGE_41;
		COMMIT;
	END IF;
	
	IF cp_status = C_STAGE_41 THEN
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
		
		update df_sliptx
		  set subgrp = 'B'
		  where slpno || '~' || stnid || '~' || pcyid in
		  (
			  select slpno || '~' || stnid || '~' || pcyid from slppaydtl
			  where
			  sphid = cp_sphid
			  and spdsts in ('N','A')
		  );

		v_return := NHS_ACT_DOCFEE_UPDCHKPT('MOD', NULL, NULL, C_STAGE_42, NULL, NULL, NULL, v_UserID, v_COMP_NAME, v_ERRMSG);
		cp_status := C_STAGE_42;
		COMMIT;
	END IF;
	
	-- Cancel
	IF cp_status = C_STAGE_42 THEN
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
		
	   SQLSTR := '';
       IF V_Otp2 = '1' THEN
          IF V_Otp3 = '1' THEN
             SQLSTR := SQLSTR || 'insert into df_sliptx' ||
                ' (GRP,SUBGRP,DOCCODE,DOCFNAME,DOCGNAME,SLPNO,SLPTYPE,' ||
                '  STNID,STNSTS,STNCDATE,ITMCODE,STNDESC,STNBAMT,STNDISC,STNNAMT,' ||
                '  PATNO,SLPFNAME,SLPGNAME,PATFNAME,PATGNAME,PCYID,DSCCODE,' ||
                '  DFX_PCT,DFX_FAMT,DFX_SAMT,DFX_PAMT,DFX_CAMT,stntdate,ARCCODE,AR_PCT)' ||
                ' select ''C'',''C'',' ||
                ' d.doccode, d.docfname, d.docgname,' ||
                ' spd.slpno, spd.slptype, spd.stnid, tx.stnsts, tx.stncdate, tx.itmcode, tx.stndesc, -tx.stnbamt, tx.stndisc, -tx.stnnamt,' ||
                ' s.PatNo , s.slpfname, s.slpgname, p.PatFName, p.PatGName, spd.PcyID, tx.DscCode,' ||
                ' spd.spdpct, spd.spdfamt, sum(spd.spdcamt), 0, sum(spd.spdcamt), tx.stntdate, s.ARCCODE, ae.AR_PCT' ||
                ' from slppaydtl spd, slip s, sliptx tx, patient p, doctor d, arcode_extra ae' ||
                ' where';
          ELSE
            SQLSTR := SQLSTR || 'insert into df_sliptx' ||
                ' (GRP,SUBGRP,DOCCODE,DOCFNAME,DOCGNAME,SLPNO,SLPTYPE,' ||
                '  STNID,STNSTS,STNCDATE,ITMCODE,STNDESC,STNBAMT,STNDISC,STNNAMT,' ||
                '  PATNO,SLPFNAME,SLPGNAME,PATFNAME,PATGNAME,PCYID,DSCCODE,' ||
                '  DFX_PCT,DFX_FAMT,DFX_SAMT,DFX_PAMT,DFX_CAMT,stntdate, ARCCODE,AR_PCT)' ||
                ' select ''C'',''C'',' ||
                ' d.doccode, d.docfname, d.docgname,' ||
                ' spd.slpno, spd.slptype, spd.payref, tx.stnsts, tx.stncdate, tx.itmcode, tx.stndesc, tx.stnbamt, tx.stndisc, tx.stnnamt,' ||
                ' s.PatNo , s.slpfname, s.slpgname, p.PatFName, p.PatGName, spd.PcyID, tx.DscCode,' ||
                ' spd.spdpct, spd.spdfamt, spd.spdsamt, -spd.spdcamt, spd.spdcamt, tx.stntdate, s.ARCCODE, ae.AR_PCT' ||
                ' from slppaydtl spd, slip s, sliptx tx, patient p, doctor d, arcode_extra ae' ||
                ' where';
          END IF;
        ELSE
            SQLSTR := SQLSTR || 'insert into df_sliptx' ||
                ' (GRP,SUBGRP,DOCCODE,DOCFNAME,DOCGNAME,SLPNO,SLPTYPE,' ||
                '  STNID,STNSTS,STNCDATE,ITMCODE,STNDESC,STNBAMT,STNDISC,STNNAMT,' ||
                '  PATNO,SLPFNAME,SLPGNAME,PATFNAME,PATGNAME,PCYID,DSCCODE,' ||
                '  DFX_PCT,DFX_FAMT,DFX_SAMT,DFX_PAMT,DFX_CAMT,stntdate, ARCCODE,AR_PCT)' ||
                ' select ''C'',''C'',' ||
                ' d.doccode, d.docfname, d.docgname,' ||
                ' spd.slpno, spd.slptype, spd.stnid, tx.stnsts, tx.stncdate, tx.itmcode, tx.stndesc, tx.stnbamt, tx.stndisc, tx.stnnamt,' ||
                ' s.PatNo , s.slpfname, s.slpgname, p.PatFName, p.PatGName, spd.PcyID, tx.DscCode,' ||
                ' spd.spdpct, spd.spdfamt, spd.spdsamt, -spd.spdcamt, spd.spdcamt, tx.stntdate, s.ARCCODE, ae.AR_PCT' ||
                ' from slppaydtl spd, slip s, sliptx tx, patient p, doctor d, arcode_extra ae' ||
                ' where';
        END IF;

       SQLSTR := SQLSTR || ' sphid = ' || cp_sphid ||
            ' and spdsts in (''R'',''U'')' ||
            ' and spd.slpno = s.slpno' ||
            ' and spd.stnid = tx.stnid' ||
            ' and s.patno = p.patno (+)' ||
            ' and s.ARCCODE = ae.ARCCODE (+)' ||
            ' and tx.doccode = d.doccode' ||
            ' and not (spd.spdcamt is null and spd.stntype = ''S'')';

		IF V_OTP3 = '1' THEN
        	SQLSTR := SQLSTR || ' group by d.doccode, d.docfname, d.docgname, spd.slpno,' ||
            	' spd.slptype,spd.stnid,tx.stnsts, tx.stncdate,' ||
                ' tx.itmcode, tx.stndesc, tx.stnbamt, tx.stndisc,' ||
                ' tx.stnnamt, s.PatNo, s.slpfname, s.slpgname, p.PatFName,' ||
                ' p.PatGName, spd.PcyID, tx.DscCode, spd.spdpct, spd.spdfamt, tx.stntdate, s.ARCCODE, ae.AR_PCT';
        END IF;
        
		EXECUTE IMMEDIATE SQLSTR;
		
		v_return := NHS_ACT_DOCFEE_UPDCHKPT('MOD', NULL, NULL, C_STAGE_43, NULL, NULL, NULL, v_UserID, v_COMP_NAME, v_ERRMSG);
		cp_status := C_STAGE_43;
		COMMIT;
	END IF;
	-- Sub Group C - Canceled (Handle in Stage 43)
	
	-- Batch Update for Sub Group A - Outstanding
	IF cp_status = C_STAGE_43 THEN
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
			select rowid from df_sliptx
			where subgrp = 'A'
				and (cp_nextNo IS NULL OR rowid > cp_nextNo)
			order by rowid;
		LOOP
			FETCH CUR2 INTO V_ROWID;
			EXIT WHEN CUR2%NOTFOUND;

			select Count(1)	into v_count
			from 
			(
				select spd.SPDPCT, spd.SPDFAMT, spd.SPDSAMT, spd.STNNAMT, nvl(sum(SPDCAMT),0) as SPDPAMT
				from df_sliptx tx, slppaydtl spd
				where
					tx.rowid = V_ROWID
					and tx.slpno = spd.slpno
					and tx.stnid = spd.stnid
					and nvl(tx.pcyid,-1) = nvl(spd.pcyid,-1)
					and spd.spdsts in ('N','A')
					and spd.sphid < cp_sphid
				group by spd.spdpct, spd.spdfamt, spd.spdsamt, spd.stnnamt
			);
			
			IF v_count = 0 THEN
				select doccode, slptype, pcyid, dsccode, itmcode, stntdate
				into P_doccode, P_slptype, P_pcyid, P_dsccode, P_itmcode, P_stntdate
				from df_sliptx where rowid = V_ROWID;
			
				RETCUR := NHS_GET_DOCITMPCT(P_doccode, P_slptype, P_pcyid, P_dsccode, P_itmcode, P_stntdate, v_STECODE);
				FETCH RETCUR INTO V_PCTVALUE, V_FIXVALUE;	-- single row
				CLOSE RETCUR;
				
				IF V_PCTVALUE IS NULL THEN
                    V_shrValue := V_FIXVALUE;
                ELSE
                	V_IS_CALC_SHRVALUE := 'Y';
                END IF;
                
                V_PREVALUE := 0;
			ELSE
				select spd.SPDPCT, spd.SPDFAMT, spd.SPDSAMT, spd.STNNAMT, nvl(sum(SPDCAMT),0) as SPDPAMT
					into V_PCTVALUE, V_FIXVALUE, V_SHRVALUE, V_STNNAMT, V_PREVALUE
				from df_sliptx tx, slppaydtl spd
				where
					tx.rowid = V_ROWID
					and tx.slpno = spd.slpno
					and tx.stnid = spd.stnid
					and nvl(tx.pcyid,-1) = nvl(spd.pcyid,-1)
					and spd.spdsts in ('N','A')
					and spd.sphid < cp_sphid
					--and rownum = 1	-- vb get first row, no sorting in sql
				group by spd.spdpct, spd.spdfamt, spd.spdsamt, spd.stnnamt;
			END IF;
			
			update df_sliptx
			set
				dfx_pct  = V_PCTVALUE,
				dfx_famt = V_FIXVALUE,
				dfx_samt = CASE WHEN V_IS_CALC_SHRVALUE = 'Y' THEN Round(STNNAMT * V_PCTVALUE/100) ELSE V_SHRVALUE END, 
				dfx_pamt = V_PREVALUE,
				dfx_camt = 0
			where rowid = V_ROWID;
		END LOOP;
		CLOSE CUR2;
		
        v_return := NHS_ACT_DOCFEE_UPDCHKPT('MOD', NULL, NULL, C_STAGE_44, NULL, NULL, NULL, v_UserID, v_COMP_NAME, v_ERRMSG);
        cp_status := C_STAGE_44;
        COMMIT;
	END IF;
	
	-- Batch Update for Sub Group B - Allocated
	IF cp_status = C_STAGE_44 THEN
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
		
		V_COUNT := 0;
		OPEN CUR2 FOR
			select rowid from df_sliptx
			where subgrp = 'B'
				and (cp_nextNo IS NULL OR rowid > cp_nextNo)
			order by rowid;
		LOOP
			FETCH CUR2 INTO V_ROWID;
			EXIT WHEN CUR2%NOTFOUND;

			update df_sliptx
			set (dfx_pct, dfx_famt, dfx_pamt, dfx_samt, dfx_camt) =
			(
			    select spd.SPDPCT, spd.SPDFAMT,
					Round(decode(spd.SPDPCT,null,spd.SPDFAMT * spd.SPDPAMT / spd.STNNAMT, spd.SPDPCT / 100 * spd.SPDPAMT)) ,
					spd.SPDSAMT, sum(spd.SPDCAMT) as SPDCAMT
				from df_sliptx tx, slppaydtl spd
				where
						tx.rowid = V_ROWID
					and tx.slpno = spd.slpno
					and tx.stnid = spd.stnid
					and spd.spdsts in ('N','A')
					and nvl(tx.pcyid,-1) = nvl(spd.pcyid,-1)
					and spd.sphid = Cp_Sphid 
				group by spd.SPDPCT, spd.SPDFAMT, spd.SPDPAMT, spd.SPDSAMT, spd.STNNAMT
			)
			where rowid = V_ROWID;
			
			V_COUNT := V_COUNT + 1;
			IF V_COUNT > V_BUFFER_SIZE THEN
				v_return := NHS_ACT_DOCFEE_UPDCHKPT('MOD', NULL, NULL, NULL, V_ROWID, NULL, NULL, v_UserID, v_COMP_NAME, v_ERRMSG);
				V_COUNT := 0;
			END IF;
			
		END LOOP;
		CLOSE CUR2;

        v_return := NHS_ACT_DOCFEE_UPDCHKPT('MOD', NULL, NULL, C_STAGE_5, NULL, NULL, NULL, v_UserID, v_COMP_NAME, v_ERRMSG);
        cp_status := C_STAGE_5;
        COMMIT;
	END IF;
	
	-- Function : Card commission
	OPEN CUR1 FOR 
		SELECT STNID, SUBGRP
		FROM df_sliptx;
    LOOP
    	FETCH CUR1 INTO P_STNID, P_SUBGRP;
		EXIT WHEN CUR1%NOTFOUND;
			
    	Update Df_Sliptx
		Set Commission = 
		(
		  Case When Subgrp = 'C' Then
		    (Select Nvl(Sum(Round(Crarate /100 * Spdcamt)), 0) As Comm
		    From Slppaydtl Where Sphid = cp_sphid
		      AND STNID = P_STNID
		      and spdsts in ('R','U'))
		  else
		    (Select Nvl(Sum(Round(Crarate /100 * Spdcamt)), 0) As Comm
		    From Slppaydtl Where Sphid = cp_sphid
		      And Stnid = P_STNID
		      And Spdsts In ('N','A'))
		  End
		)
		Where STNID = P_STNID AND Dfx_Camt <> 0 and SUBGRP = P_SUBGRP;
	END LOOP;
	CLOSE CUR1;
	
	
	-- Part B for DOCTOR CREDIT (LESS)
	IF cp_status = C_STAGE_5 THEN
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
		/*
		insert into df_sliptx
          (GRP,SUBGRP,DOCCODE,DOCFNAME,DOCGNAME,SLPNO,SLPTYPE,
           STNID,STNCDATE,ITMCODE,STNDESC,STNBAMT,STNDISC,STNNAMT,
           PATNO,SLPFNAME,SLPGNAME,PATFNAME,PATGNAME,DFX_CAMT,STNTDATE,ARCCODE,AR_PCT)
  		select
			'W','W',
			d.doccode, d.docfname , d.docgname,
			s.slpno, s.slptype,
			tx.stnid, tx.stncdate, tx.itmcode, tx.stndesc, tx.stnbamt, tx.stndisc, tx.stnnamt,
			s.PatNo , s.slpfname, s.slpgname, p.PatFName, p.PatGName, sum(stnnamt), tx.stntdate, s.ARCCODE, ae.AR_PCT
  		from
  			df_slip ds, slip s, patient p, sliptx tx, doctor d, item i, arcode_extra ae
  		where
			ds.SlpNo = s.SlpNo
			and ds.slpno = tx.slpno
			and s.patno = p.patno (+)
			and s.ARCCODE = ae.ARCCODE (+)
			and tx.doccode = d.doccode 		
			and tx.itmtype = 'D'
			and tx.stntype = 'C'
			and tx.itmcode = i.itmcode
			and i.itmdoccr = -1
			and tx.stnadoc is null
			and tx.stncdate < cp_DATEEND + 1
		group by
			d.doccode, d.docfname , d.docgname,
			s.slpno, s.slptype,
			tx.stnid, tx.stncdate, tx.itmcode, tx.stndesc, tx.stnbamt, tx.stndisc, tx.stnnamt,
			s.PatNo , s.slpfname, s.slpgname, p.PatFName, p.PatGName, tx.stntdate;
			
		--  DocFeeLog sql
			*/
		
		-- 2020/04/09 credit from doctor until normal item is paid
		insert into df_sliptx
          (GRP,SUBGRP,DOCCODE,DOCFNAME,DOCGNAME,SLPNO,SLPTYPE,
           STNID,STNCDATE,ITMCODE,STNDESC,STNBAMT,STNDISC,STNNAMT,
           PATNO,SLPFNAME,SLPGNAME,PATFNAME,PATGNAME,STNTDATE,ARCCODE,AR_PCT)
  		select
			'W','W',
			d.doccode, d.docfname , d.docgname,
			s.slpno, s.slptype,
			tx.stnid, tx.stncdate, tx.itmcode, tx.stndesc, tx.stnbamt, tx.stndisc, tx.stnnamt,
			s.PatNo , s.slpfname, s.slpgname, p.PatFName, p.PatGName, tx.stntdate, s.ARCCODE, ae.AR_PCT
  		from
  			df_slip ds, slip s, patient p, sliptx tx, doctor d, item i, arcode_extra ae
  		where
			ds.SlpNo = s.SlpNo
			and ds.slpno = tx.slpno
			and s.patno = p.patno (+)
			and s.ARCCODE = ae.ARCCODE (+)
			and tx.doccode = d.doccode 		
			and tx.itmtype = 'D'
			and tx.stntype = 'C'
			and tx.itmcode = i.itmcode
			and i.itmdoccr = -1
			and tx.stnadoc is null
			and tx.stncdate < cp_DATEEND + 1
            and (
                (select sum(spdcamt) from slppaydtl where slpno = tx.slpno and sphid <= Cp_Sphid and spdsts in ('N','A') group by slpno) > 0 or
                (select count(1) from slppaydtl where slpno = tx.slpno and sphid <= Cp_Sphid and spdsts in ('N','A')  group by slpno) > 0
            )
		group by
			d.doccode, d.docfname , d.docgname,
			s.slpno, s.slptype,
			tx.stnid, tx.stncdate, tx.itmcode, tx.stndesc, tx.stnbamt, tx.stndisc, tx.stnnamt,
			s.PatNo , s.slpfname, s.slpgname, p.PatFName, p.PatGName, tx.stntdate, s.ARCCODE, ae.AR_PCT;

		V_COUNT := 0;
		OPEN CUR2 FOR
			select rowid from df_sliptx
			where subgrp = 'W'
				and (cp_nextNo IS NULL OR rowid > cp_nextNo)
			order by rowid;
		LOOP
			FETCH CUR2 INTO V_ROWID;
			EXIT WHEN CUR2%NOTFOUND;

			update df_sliptx
			set (dfx_camt) =
			(
			    select sum(tx.stnnamt)
				from df_sliptx dstx, sliptx tx
				where
						dstx.rowid = V_ROWID
					and dstx.slpno = tx.slpno
					and dstx.stnid = tx.stnid
					and dstx.slpno in
						(select slpno from slppaydtl where slpno = dstx.slpno and sphid <= Cp_Sphid and spdsts in ('N','A'))
			)
			where rowid = V_ROWID;
			
			V_COUNT := V_COUNT + 1;
			IF V_COUNT > V_BUFFER_SIZE THEN
				v_return := NHS_ACT_DOCFEE_UPDCHKPT('MOD', NULL, NULL, NULL, V_ROWID, NULL, NULL, v_UserID, v_COMP_NAME, v_ERRMSG);
				V_COUNT := 0;
			END IF;
			
		END LOOP;
		CLOSE CUR2;

        v_return := NHS_ACT_DOCFEE_UPDCHKPT('MOD', NULL, NULL, C_STAGE_6, NULL, NULL, NULL, v_UserID, v_COMP_NAME, v_ERRMSG);
        cp_status := C_STAGE_6;
        COMMIT;
	END IF;
	
	-- Added On 2002-09-05 By Brian Lau for doctor waived commission
	UPDATE DF_SLIPTX SET COMMISSION = 0 WHERE COMMISSION IS NULL;
    --------------
	-- END of DocFeeStep2
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
END NHS_ACT_DOCFEESTEP2;
/

CREATE OR REPLACE FUNCTION NHS_ACT_DOCFEESTEP5 (
v_ACTION		IN VARCHAR2,
v_DUMMY			IN VARCHAR2,
o_ERRMSG		OUT VARCHAR2)
	RETURN NUMBER
AS
	o_ERRCODE  NUMBER;
	v_ERRMSG  	VARCHAR2(1000);
	v_Count    	NUMBER;
	v_return    NUMBER;
	
	l_file        UTL_FILE.file_type;
    l_file_name   VARCHAR2(60);
	
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
	V_STNID		NUMBER(22);
	V_SLPNO		VARCHAR2(15);
	
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
	C_SLIP_STATUS_CLOSE VARCHAR2(1) := 'C';--Closed  
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
	-- DocFeeStep5
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
	
	-- Update SlipTx Doctor Flag
	IF cp_status = C_STAGE_7 THEN
		OPEN CUR1 FOR
			select distinct stnid
			from slppaydtl
			where sphid = cp_sphid
				and (cp_nextno is null or stnid >= cp_nextno)
			order by stnid;
		LOOP
			FETCH CUR1 INTO V_STNID;
			EXIT WHEN CUR1%NOTFOUND;
			
			update sliptx set stnadoc = cp_DATEEND
			where stnid in 
			(
				select tx.stnid
				from slppaydtl spd, sliptx tx
				where spd.stnid in (V_STNID)
				and spd.stnid = tx.stnid
				group by tx.stnid, tx.stnnamt, tx.stnsts
				having
				(tx.stnsts in ('N','A') and tx.stnnamt = sum(SPDAAMT))
				or
				(tx.stnsts in ('C','T') and sum(SPDAAMT) = 0)
			);
		END LOOP;
		CLOSE CUR1;
		
		-- Applied Dr Fee Flag can be update when:
        -- Full settlement for (Normal and Adjust) or Full reimbusement for (Cancel and Transfer)
		
        v_return := NHS_ACT_DOCFEE_UPDCHKPT('MOD', NULL, NULL, C_STAGE_75, NULL, NULL, NULL, NULL, NULL, v_ERRMSG);
    	cp_status := C_STAGE_75;
    	COMMIT;
	END IF;
	
	-- Update SlipTx Doctor Flag for Credit
    IF cp_status = C_STAGE_75 THEN
		update sliptx set stnadoc = cp_DATEEND
		where stnid in (			
			select stnid 
			from df_sliptx 
			where grp = 'W'
				and (cp_nextno is null or stnid >= cp_nextno)
		);
				
        v_return := NHS_ACT_DOCFEE_UPDCHKPT('MOD', NULL, NULL, C_STAGE_8, NULL, NULL, NULL, NULL, NULL, v_ERRMSG);
    	cp_status := C_STAGE_8;
    	COMMIT;
    END IF;
    
    -- Update Slip Doctor Flag
    IF cp_status = C_STAGE_8 THEN
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
		
		OPEN CUR1 FOR
			select distinct slpno 
			from slppaydtl 
			where sphid = cp_sphid
				and (cp_nextno is null or slpno >= cp_nextno)
			order by slpno;
		LOOP
			FETCH CUR1 INTO V_SLPNO;
			EXIT WHEN CUR1%NOTFOUND;
			
			update slip 
			set slpadoc = cp_DATEEND
			where slpno in (V_SLPNO)
				and slpno not in
				(
					select slpno from sliptx tx
					where
						tx.slpno in (V_SLPNO)
						and tx.itmtype = 'D'
						and tx.stntype = 'D'
						and tx.stnsts in ('N','A')
						and tx.stnadoc is null
				)
				and slpsts = C_SLIP_STATUS_CLOSE;
		END LOOP;
		CLOSE CUR1;
		
        v_return := NHS_ACT_DOCFEE_UPDCHKPT('MOD', NULL, NULL, C_STAGE_9, NULL, NULL, NULL, NULL, NULL, v_ERRMSG);
    	cp_status := C_STAGE_9;
    	COMMIT;
    END IF;
    --------------
	-- END of DocFeeStep5
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
END NHS_ACT_DOCFEESTEP5;
/

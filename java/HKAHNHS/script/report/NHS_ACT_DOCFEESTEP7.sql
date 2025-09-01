CREATE OR REPLACE FUNCTION NHS_ACT_DOCFEESTEP7 (
v_ACTION		IN VARCHAR2,
v_IS_CONFIRM	IN VARCHAR2,
o_ERRMSG		OUT VARCHAR2)
	RETURN NUMBER
AS
	o_ERRCODE  NUMBER;
	v_ERRMSG  	VARCHAR2(1000);
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
	-- DocFeeStep7
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

	IF cp_status = C_STAGE_10 THEN
		IF v_IS_CONFIRM = 'Y' THEN
			-- Not A Trial Run

			-- Log 415
            -- 2002-06-04 For those Net Amount is Zero
            -- Update Doctor Flag: StnADoc
			update sliptx set stnadoc = cp_DATEEND
			where stnid in (select stnid from df_sliptx where stnnamt = 0);

			execute immediate 'truncate table df_chkpt';
			
			-- backup actual data
			execute immediate 'truncate table df_sliptx_actual';
			
			insert into df_sliptx_actual
			select * from df_sliptx;
		ELSE
			-- A Trial Run, then rollback the update in SLIP (SLPADOC) and SLIPTX (STNADOC)

			-- Rollback SLIPTX
			update sliptx set stnadoc = null
			where stnadoc = cp_dateend
			and stnid in (
				select stnid
				from slppaydtl
				where sphid = cp_sphid
					and (cp_nextno is null or stnid >= cp_nextno)
			);

			-- Rollback SLIP
			update slip set slpadoc = null
			where slpno in (select distinct slpno from sliptx where stnid in (
				select stnid
				from slppaydtl
				where sphid = cp_sphid
					and (cp_nextno is null or stnid >= cp_nextno)
			));

			-- Rollback SLPPAYDTL
			update slppaydtl set
			SPDPCT = null,
			SPDFAMT = null,
			SPHID = null,
			SPDPAMT = null,
			STNNAMT = null,
			SPDSAMT = null,
			SPDCAMT = null
			where sphid = cp_sphid
			and stnid in (
				select stnid
				from slppaydtl
				where sphid = cp_sphid
					and (cp_nextno is null or stnid >= cp_nextno)
			);

			update sliptx set stnadoc = null where stnid in (select stnid from df_sliptx where grp = 'W');
			update slip   set slpadoc = null where slpno in (select slpno from df_sliptx where grp = 'W');

		    v_return := NHS_ACT_DOCFEE_UPDCHKPT('MOD', NULL, NULL, C_STAGE_11, NULL, NULL, NULL, NULL, NULL, v_ERRMSG);
    		v_STATUS := C_STAGE_11;

    		execute immediate 'truncate table df_chkpt';
    		COMMIT;
		END IF;
	END IF;
    --------------
	-- END of DocFeeStep7
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
END NHS_ACT_DOCFEESTEP7;
/

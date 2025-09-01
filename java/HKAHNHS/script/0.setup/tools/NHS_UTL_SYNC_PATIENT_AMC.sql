-- run at master site (HKAH-SR) only
create or replace PROCEDURE NHS_UTL_SYNC_PATIENT_AMC
IS
	o_errCode VARCHAR2(10);
	o_errmsg VARCHAR2(200);
	v_usrid  VARCHAR2(50);
	v_REAL_STECODE VARCHAR2(10);
	v_from_stecode VARCHAR2(10);
	v_to_stecode1 VARCHAR2(10);
	v_to_stecode2 VARCHAR2(10);
	v_ACTION VARCHAR2(10);
	v_log_action VARCHAR2(20);
	v_sql VARCHAR2(6000);
	v_sql_update VARCHAR2(3000);
	v_sql_insert_col_a VARCHAR2(3000);
	v_sql_insert_col_b VARCHAR2(3000);
	v_update1_dblink VARCHAR2(15);
	v_update2_dblink VARCHAR2(15);
	v_src_dblink VARCHAR2(15);
	v_amc1_dblink VARCHAR2(15) := 'amc1hat_sync';
	v_amc2_dblink VARCHAR2(15) := 'amc2hat_sync';
	v_get_update_cols VARCHAR2(1000) := 'select listagg(''a.'' || column_name ||  ''=b.'' || column_name, '','' ) within group (order by column_id) from all_tab_cols where table_name = :1 and column_name <> :2';
	v_get_insert_cols_a VARCHAR2(1000) := 'select listagg(''a.'' || column_name, '','' ) within group (order by column_name) from all_tab_cols where table_name = :1';
	v_get_insert_cols_b VARCHAR2(1000) := 'select listagg(''b.'' || column_name, '','' ) within group (order by column_name) from all_tab_cols where table_name = :1';
BEGIN
	v_REAL_STECODE := GET_REAL_STECODE;
	
	for r in ( 
		select
		    patno,
		    max(action) keep (dense_rank first order by lastupd desc) action,
		    max(stecode) keep (dense_rank first order by lastupd desc) stecode,
		    max(lastupd) keep (dense_rank first order by lastupd desc) lastupd
		from 
		(
		    select * from patient_sync_pending where sync_date is null
		        union 
		    select * from patient_sync_pending@amc2hat_sync where sync_date is null
		        union 
		    select * from patient_sync_pending@amc1hat_sync where sync_date is null
		)
		group by patno
		order by lastupd 
	) loop
		v_from_stecode := r.stecode;
		IF r.stecode = 'AMC1' THEN
			v_src_dblink := '@' || v_amc1_dblink;
			v_update1_dblink := '';
			v_update2_dblink := '@' || v_amc2_dblink;
			v_to_stecode1 := 'HKAH';
			v_to_stecode2 := 'AMC2';
		ELSIF r.stecode = 'AMC2' THEN
			v_src_dblink := '@' || v_amc2_dblink;
			v_update1_dblink := '';
			v_update2_dblink := '@' || v_amc1_dblink;
			v_to_stecode1 := 'HKAH';
			v_to_stecode2 := 'AMC1';		
		ELSIF r.stecode = 'HKAH' THEN
			v_src_dblink := '';
			v_update1_dblink := '@' || v_amc1_dblink;
			v_update2_dblink := '@' || v_amc2_dblink;
			v_to_stecode1 := 'AMC1';
			v_to_stecode2 := 'AMC2';	
		END IF;

		BEGIN
			-- PATIENT
			execute immediate v_get_update_cols into v_sql_update using 'PATIENT', 'PATNO';
			execute immediate v_get_insert_cols_a into v_sql_insert_col_a using 'PATIENT';
			execute immediate v_get_insert_cols_b into v_sql_insert_col_b using 'PATIENT';
			
			v_sql := 'MERGE INTO PATIENT' || v_update1_dblink || ' a ' ||
				'USING ' ||
				'( ' ||
				'select * ' ||
	         	'from (select row_number() over(partition by p.patno order by p.patno desc) rd, ' ||
	            '          p.*, ' ||
	            '          p.rowid row_id ' ||
	            '     from PATIENT' || v_src_dblink || ' p where p.patno = :1) ' ||
	       		'where rd = 1 ' ||
				')b ' ||
				'ON(a.patno = b.patno) ' ||
				'WHEN MATCHED THEN UPDATE SET ' || v_sql_update || ' ' ||
				'WHEN NOT MATCHED THEN INSERT(' || v_sql_insert_col_a || ')' ||
				'VALUES(' || v_sql_insert_col_b || ')'
				;
			execute immediate v_sql using r.patno;
			
			v_sql := 'MERGE INTO PATIENT' || v_update2_dblink || ' a ' ||
				'USING ' ||
				'( ' ||
				'select * ' ||
	         	'from (select row_number() over(partition by p.patno order by p.patno desc) rd, ' ||
	            '          p.*, ' ||
	            '          p.rowid row_id ' ||
	            '     from PATIENT' || v_src_dblink || ' p where p.patno = :1) ' ||
	       		'where rd = 1 ' ||
				')b ' ||
				'ON(a.patno = b.patno) ' ||
				'WHEN MATCHED THEN UPDATE SET ' || v_sql_update || ' ' ||
				'WHEN NOT MATCHED THEN INSERT(' || v_sql_insert_col_a || ')' ||
				'VALUES(' || v_sql_insert_col_b || ')'
				;
			execute immediate v_sql using r.patno;
			
			-- PATIENT_EXTRA
			execute immediate v_get_update_cols into v_sql_update using 'PATIENT_EXTRA', 'PATNO';
			execute immediate v_get_insert_cols_a into v_sql_insert_col_a using 'PATIENT_EXTRA';
			execute immediate v_get_insert_cols_b into v_sql_insert_col_b using 'PATIENT_EXTRA';
			
			v_sql := 'MERGE INTO PATIENT_EXTRA' || v_update1_dblink || ' a ' ||
				'USING ' ||
				'( ' ||
				'select * ' ||
	         	'from (select row_number() over(partition by p.patno order by p.patno desc) rd, ' ||
	            '          p.*, ' ||
	            '          p.rowid row_id ' ||
	            '     from PATIENT_EXTRA' || v_src_dblink || ' p where p.patno = :1) ' ||
	       		'where rd = 1 ' ||
				')b ' ||
				'ON(a.patno = b.patno) ' ||
				'WHEN MATCHED THEN UPDATE SET ' || v_sql_update || ' ' ||
				'WHEN NOT MATCHED THEN INSERT(' || v_sql_insert_col_a || ')' ||
				'VALUES(' || v_sql_insert_col_b || ')'
				;
			execute immediate v_sql using r.patno;
			
			v_sql := 'MERGE INTO PATIENT_EXTRA' || v_update2_dblink || ' a ' ||
				'USING ' ||
				'( ' ||
				'select * ' ||
	         	'from (select row_number() over(partition by p.patno order by p.patno desc) rd, ' ||
	            '          p.*, ' ||
	            '          p.rowid row_id ' ||
	            '     from PATIENT_EXTRA' || v_src_dblink || ' p where p.patno = :1) ' ||
	       		'where rd = 1 ' ||
				')b ' ||
				'ON(a.patno = b.patno) ' ||
				'WHEN MATCHED THEN UPDATE SET ' || v_sql_update || ' ' ||
				'WHEN NOT MATCHED THEN INSERT(' || v_sql_insert_col_a || ')' ||
				'VALUES(' || v_sql_insert_col_b || ')'
				;
			execute immediate v_sql using r.patno;
			
			-- PATIENT_UPDATE_LOG
			v_sql := 'DELETE FROM PATIENT_UPDATE_LOG' || v_update1_dblink;
			execute immediate v_sql;
			v_sql := 'INSERT INTO PATIENT_UPDATE_LOG' || v_update1_dblink || ' SELECT * FROM PATIENT_UPDATE_LOG' || v_src_dblink;
			execute immediate v_sql;
			
			v_sql := 'DELETE FROM PATIENT_UPDATE_LOG' || v_update2_dblink;
			execute immediate v_sql;
			v_sql := 'INSERT INTO PATIENT_UPDATE_LOG' || v_update2_dblink || ' SELECT * FROM PATIENT_UPDATE_LOG' || v_src_dblink;
			execute immediate v_sql;
			
			execute immediate 'update patient_sync_pending' || v_src_dblink || ' set sync_date = sysdate where patno = :1 and sync_date is null' using r.patno;
			execute immediate 'update patient_sync_pending' || v_update1_dblink || ' set sync_date = sysdate where patno = :1  and sync_date is null' using r.patno;
			execute immediate 'update patient_sync_pending' || v_update2_dblink || ' set sync_date = sysdate where patno = :1  and sync_date is null' using r.patno;
			
			-- SYSLOG (only in master site)
			IF r.action is null THEN
				v_log_action := 'SYNC_AMC';
			ELSE
				v_log_action := r.action || '_AMC';
			END IF;
			SELECT sys_context('USERENV', 'SESSION_USER') INTO v_usrid FROM dual;
			o_errcode := NHS_ACT_SYSLOG('ADD', 'Patient Master Index', v_log_action, 'Success sync from ' || v_from_stecode || ' to ' || v_to_stecode1 || ',' || v_to_stecode2 || ' of #' || r.patno, v_usrid, NULL, o_errmsg);
		EXCEPTION		
			WHEN OTHERS THEN
				o_errcode := NHS_ACT_SYSLOG('ADD', 'Patient Master Index', v_log_action, 'Fail sync from ' || v_from_stecode || ' to ' || v_to_stecode1 || ',' || v_to_stecode2 || ' of #' || r.patno  || ' Err:' || o_errmsg || SQLERRM, v_usrid, NULL, o_errmsg);
				o_errmsg:= o_errmsg || SQLERRM;
            RAISE;
		END;
  	end loop ;
EXCEPTION
WHEN OTHERS THEN
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
    RAISE;
END NHS_UTL_SYNC_PATIENT_AMC;
/
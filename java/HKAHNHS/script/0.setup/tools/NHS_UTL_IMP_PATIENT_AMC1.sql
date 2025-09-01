create or replace procedure NHS_UTL_IMP_PATIENT_AMC1(
	i_action  IN VARCHAR2)
as
  v_count number := 0;
  v_sys_remark varchar2(200) := '';
  v_update_usrid  varchar2(5) := 'AMC1';
  v_create_stecode  varchar2(5) := 'AMC1';
begin
  if i_action = 'GET_PATNO' then
	  for r in (
	  	select 
	        a.*
		from patient_amc1 a
		where patno is null
		order by a.amc1patno
	  ) loop
	  	-- apply patno
	  	update patient_amc1 set patno = SEQ_PATIENT_AMC1_PATNO.nextval where amc1patno = r.amc1patno;
	    v_count := v_count + 1;
	  end loop;
	  
	  v_sys_remark := 'Get new patno success (total: ' || v_count || ' )';
  elsif i_action = 'IMPORT' then
    SELECT COUNT(1) INTO v_count FROM PATIENT_AMC1 WHERE PATNO NOT IN (SELECT PATNO FROM PATIENT) AND IMPORTDATE IS NULL;
    
    INSERT INTO PATIENT
	    (PATNO, PATFNAME, PATGNAME, PATCNAME, PATIDNO, PATBDATE, PATSEX, PATADD1, PATADD2, PATADD3, TITDESC,
	    PATHTEL, LOCCODE, COUCODE, PATRDATE, PATVCNT, PATNB, PATSTS, STECODE, PATSTAFF, PATITP, PATPAGER, 
	    LASTUPD, USRID, PATEMAIL, PATSMS, PATIDCOUCODE, PATCHKID, PATPAGERUPUSR, PATPAGERUPDT,
	    PATHTELUPUSR, PATHTELUPDT, PATADDUPUSR, PATADDUPDT, PATMKTSRC)
	SELECT 
	    PATNO, PATFNAME, PATGNAME, PATCNAME, PATIDNO, PATBDATE, PATSEX, PATADD1, PATADD2, PATADD3, TITDESC,
	    PATHTEL, CASE WHEN LOCCODE IS NULL THEN '#1' ELSE LOCCODE END, COUCODE, TRUNC(SYSDATE), 0, 0, 0, 'HKAH', PATSTAFF, 0, PATPAGER,
	    SYSDATE, v_update_usrid, PATEMAIL, 0, PATIDCOUCODE, 0, CASE WHEN PATPAGER IS NULL THEN NULL ELSE v_update_usrid END, CASE WHEN PATPAGER IS NULL THEN NULL ELSE SYSDATE END,
	    CASE WHEN PATHTEL IS NULL THEN NULL ELSE v_update_usrid END, CASE WHEN PATHTEL IS NULL THEN NULL ELSE SYSDATE END, CASE WHEN PATADD1 IS NULL THEN NULL ELSE v_update_usrid END, CASE WHEN PATADD1 IS NULL THEN NULL ELSE SYSDATE END, 'S'
	FROM PATIENT_AMC1
	WHERE PATNO NOT IN (SELECT PATNO FROM PATIENT)
		AND IMPORTDATE IS NULL;

	INSERT INTO PATIENT_EXTRA
	    (PATNO, DOCTYPE, PATCDATE, STECODE, PATPGRCOUCODE)
	SELECT 
	    PATNO, DOCTYPE, SYSDATE, v_create_stecode, PATPGRCOUCODE
	FROM PATIENT_AMC1
	WHERE PATNO NOT IN (SELECT PATNO FROM PATIENT_EXTRA)
		AND IMPORTDATE IS NULL;
		
	INSERT INTO patient_sync_pending
	    (PATNO, ACTION, STECODE, LASTUPD, SYNC_DATE)
	SELECT 
	    PATNO, 'INSERT', GET_REAL_STECODE, SYSDATE, NULL
	FROM PATIENT_AMC1
	WHERE IMPORTDATE IS NULL;
	    
	UPDATE PATIENT_AMC1 SET IMPORTDATE = SYSDATE
	WHERE IMPORTDATE IS NULL;
	
	v_sys_remark := 'Import to PATIENT success (total: ' || v_count || ' )';
  end if;
  
  insert into syslog (
	module,
	action,
	remark,
	userid,
	systime
  ) values (
	'Patient Master Index',
	'IMPORT_AMC1',
	v_sys_remark,
    'HKAH',
	sysdate
  );
    
exception 
  when others then
    rollback;
    insert into syslog (
    	module,
    	action,
    	remark,
    	userid,
    	systime
    ) values (
		'Patient Master Index',
		'IMPORT_AMC1',
		'Fail to process action: ' || i_action,
        'HKAH',
		sysdate
    );
END NHS_UTL_IMP_PATIENT_AMC1;
/
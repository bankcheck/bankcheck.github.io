CREATE OR REPLACE FUNCTION NHS_UTL_CLONE_DOCCODE (
	i_action  IN VARCHAR2,
	i_doccode_old IN VARCHAR2,
	i_doccode_new IN VARCHAR2,
	o_errmsg  OUT	VARCHAR2
)
	RETURN NUMBER
AS
	v_noOfRec NUMBER;
	o_errcode NUMBER;
begin
	o_errcode := 0;
	v_noOfRec := 0;
	
	IF i_action = 'CLONE' THEN
		/*
		 * Table
		 * ------
			select * from doctor;
			select * from doctor_extra;
			select * from docapvlink;   -- seq_docapvlink
			select * from doccert;
			select * from docprilink;
			select * from docspclink;
		 */
		select count(1) into v_noOfRec from doctor where doccode = i_doccode_new;
		IF v_noOfRec > 0 THEN
			o_errmsg := 'Doctor code: ' || i_doccode_new || ' already exist';
		ELSE
			
			INSERT INTO doctor (
			    doccode,    docfname,    docgname,    doccname,    docidno,    docsex,    spccode,    docsts,    doctype,    docpct_i,    docpct_o,    docpct_d,    docadd1,    docadd2,    docadd3,    dochtel,    docotel,    docptel,    doctslot,    docquali,    doctdate,    docsdate,    dochomadd1,    dochomadd2,    dochomadd3,    docoffadd1,    docoffadd2,    docoffadd3,    doccsholy,    docmtel,    docemail,    docfaxno,    dochomadd4,    docadd4,    docoffadd4,    docpicklist,    usrid,    docqualify,    docbdate,    rptto,    isdoctor,    tittle,    isotsurgeon,    isotanesthetist,    showprofile,    dayinstruction,    inpinstruction,    oupinstruction,    payinstruction,    brno,    docremark,    cpsdate,    apldate,    mpscdate,    sldate,    isotendoscopist,    chkprcpriv,    docinsurcomp,    oppedate,    receivepromo,    receivepromobyfax,    oppsdate,    clinsdate,    hkmclicno,    ispostschedule,    company,    mstrdoccode,    ehruid
			)
			SELECT
			    i_doccode_new,    docfname,    docgname,    doccname,    docidno,    docsex,    spccode,    docsts,    doctype,    docpct_i,    docpct_o,    docpct_d,    docadd1,    docadd2,    docadd3,    dochtel,    docotel,    docptel,    doctslot,    docquali,    doctdate,    docsdate,    dochomadd1,    dochomadd2,    dochomadd3,    docoffadd1,    docoffadd2,    docoffadd3,    doccsholy,    docmtel,    docemail,    docfaxno,    dochomadd4,    docadd4,    docoffadd4,    docpicklist,    usrid,    docqualify,    docbdate,    rptto,    isdoctor,    tittle,    isotsurgeon,    isotanesthetist,    showprofile,    dayinstruction,    inpinstruction,    oupinstruction,    payinstruction,    brno,    docremark,    cpsdate,    apldate,    mpscdate,    sldate,    isotendoscopist,    chkprcpriv,    docinsurcomp,    oppedate,    receivepromo,    receivepromobyfax,    oppsdate,    clinsdate,    hkmclicno,    ispostschedule,    company,    mstrdoccode,    ehruid
			FROM
			    doctor
			where doccode = i_doccode_old;
			
			
			INSERT INTO doctor_extra (
			    doccode,    smdinstruction,    doc_created_date,    doc_created_user,    smstel,    smstel2,    smstype,    cts_archive_file_id,    pbo_remark,    stodeclaration,    sendrisemail,    sendrisemail_moddt,    doc_updated_date,    doc_updated_user,    hkmano,    mpsno
			)
			SELECT 
			    i_doccode_new,    smdinstruction,    doc_created_date,    doc_created_user,    smstel,    smstel2,    smstype,    cts_archive_file_id,    pbo_remark,    stodeclaration,    sendrisemail,    sendrisemail_moddt,    doc_updated_date,    doc_updated_user,    hkmano,    mpsno
			FROM
			    doctor_extra
			where doccode = i_doccode_old;
			
			
			INSERT INTO docapvlink (
			    dalid,doccode,cmtname,actno,apvdate
			)    
			SELECT 
			    seq_docapvlink.nextval,i_doccode_new,cmtname,actno,apvdate
			FROM
			    docapvlink
			where doccode = i_doccode_old;
			
			
			INSERT INTO doccert (
			    doccode,    ecert1,    ecert2,    ecert3,    ecert4,    ecert5,    ecert6,    ecert7,    ecert8,    ecert9,    ecert10,    ccert1,    ccert2,    ccert3,    ccert4,    ccert5,    ccert6,    ccert7,    ccert8,    ccert9,    ccert10
			)
			SELECT 
			    i_doccode_new,    ecert1,    ecert2,    ecert3,    ecert4,    ecert5,    ecert6,    ecert7,    ecert8,    ecert9,    ecert10,    ccert1,    ccert2,    ccert3,    ccert4,    ccert5,    ccert6,    ccert7,    ccert8,    ccert9,    ccert10
			FROM
			    doccert
			where doccode = i_doccode_old;
			       
			       
			
			
			INSERT INTO docprilink (
			    dplid,doccode,pricode,dplsdate,dpltdate
			)
			SELECT 
			    seq_docprilink.nextval,i_doccode_new,pricode,dplsdate,dpltdate
			FROM
			    docprilink
			where doccode = i_doccode_old;
			
			
			INSERT INTO docspclink (
			    dslid,doccode,spccode,isofficial
			)
			SELECT 
			    seq_docspclink.nextval,i_doccode_new,spccode,isofficial
			FROM
			    docspclink
			where doccode = i_doccode_old;
			
			o_errcode := 1;
			o_errmsg := 'Clone doctor code from ' || i_doccode_old || ' to ' || i_doccode_new || ' success';
		END IF;
	ELSIF i_action = 'ACTIVE' THEN
		UPDATE doctor SET docsts = -1 WHERE doccode = i_doccode_old AND docsts = 0;
		UPDATE doctor_extra SET doc_updated_date = sysdate, doc_updated_user = 'SYSTEM' WHERE doccode = i_doccode_old;
		
		o_errcode := 2;
		o_errmsg := 'Set doctor code: ' || i_doccode_old || ' activated';		
	ELSIF i_action = 'INACTIVE' THEN
		UPDATE doctor SET docsts = 0 WHERE doccode = i_doccode_old AND docsts = -1;
		UPDATE doctor_extra SET doc_updated_date = sysdate, doc_updated_user = 'SYSTEM' WHERE doccode = i_doccode_old;
		
		o_errcode := 3;
		o_errmsg := 'Set doctor code: ' || i_doccode_old || ' inactive success';
	END IF;
    
	RETURN o_errcode;
EXCEPTION
WHEN OTHERS THEN
	o_errmsg := SQLERRM;
	ROLLBACK;

	RETURN o_errcode;
END NHS_UTL_CLONE_DOCCODE;
/
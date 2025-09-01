create or replace
FUNCTION "NHS_ACT_OTSLTSLIP" (
  V_ACTION              IN VARCHAR2,
  V_PATNO				IN VARCHAR2,
  V_PATTYPE				IN VARCHAR2,
  V_REGDATE				IN VARCHAR2,	-- dd/mm/yyyy
  V_preSlipNum			IN VARCHAR2,
  V_selSlipNum			IN VARCHAR2,
  V_lOTA_Id				IN VARCHAR2,
  V_STAGE				IN VARCHAR2,
  V_USERID				IN VARCHAR2,
  O_ERRMSG  			OUT VARCHAR2
)
return number
as
	o_errcode  		number;
	v_noOfRec  		number;
	v_CursorType 	TYPES.CURSOR_TYPE;
	v_sCurSlipNum	VARCHAR2(15);
	v_sCurRegdate	VARCHAR2(20);
	v_sCurRegmddate	VARCHAR2(20);
	v_sCurDoccode	VARCHAR2(100);
	V_OTAOSDATE		DATE;
	V_PreSeqNo		NUMBER(22);
	V_NewSeqNo		NUMBER(22);
begin
  O_ERRCODE := 0;
  O_ERRMSG  := 'OK';
  V_NOOFREC := 0;
  
	V_Cursortype := NHS_LIS_OTSLTSLIPSEARCH(V_Patno, V_Pattype, V_Regdate);
	  LOOP
	    FETCH v_CursorType INTO
	      v_sCurSlipNum,
	      V_Scurregdate,
	      V_Scurregmddate,
	      V_Scurdoccode;
	      
	      V_NOOFREC:= v_CursorType%ROWCOUNT;
	    Exit When V_Cursortype%Notfound;
	  End Loop;
	  
  	IF V_selSlipNum IS NOT NULL THEN
		v_sCurSlipNum := V_selSlipNum;
	END IF;
	
	IF V_STAGE IS NULL OR V_STAGE = '0' THEN  
	  IF V_NOOFREC = 0 THEN
		O_ERRMSG := 'No available slip number!';
		RETURN -100;
	  END IF;
	  
	  IF V_NOOFREC > 1 THEN
		RETURN -200;
		-- display OTSltSlipDisplay StartForm
	  END IF;
	 END IF;
	 
	IF V_STAGE IS NULL OR V_STAGE = '0' OR V_STAGE = '2' THEN  
		------------
		-- preSaveSlipNo
		------------
		IF V_preSlipNum is not null AND V_preSlipNum <> v_sCurSlipNum THEN
			o_ERRMSG := v_sCurSlipNum;
			RETURN -300;
			-- show inform PBO dialog
		END IF;
	END IF;
	

	---------
	-- save
	---------
  	select count(1) into v_noOfRec from OT_APP where OTAID = V_lOTA_Id;
  	IF v_noOfRec > 0 THEN
  		select OTAOSDATE into V_OTAOSDATE from OT_APP where OTAID = V_lOTA_Id;
  	END IF;
  
  	select count(1) into v_noOfRec from sliptx where slpno= V_preSlipNum and stnseq=(select max(stnseq) from sliptx where slpno=V_preSlipNum);
  	IF v_noOfRec > 0 THEN
  		select STNSEQ into V_PreSeqNo from sliptx where slpno= V_preSlipNum and stnseq=(select max(stnseq) from sliptx where slpno=V_preSlipNum);
  	END IF;
  	
  	select count(1) into v_noOfRec from sliptx where slpno= v_sCurSlipNum and stnseq=(select max(stnseq) from sliptx where slpno=v_sCurSlipNum);
    IF v_noOfRec > 0 THEN
  		select STNSEQ into V_NewSeqNo from sliptx where slpno= v_sCurSlipNum and stnseq=(select max(stnseq) from sliptx where slpno=v_sCurSlipNum);
  	END IF;
  	
  	-----------
  	-- postOTLog
  	-----------
  	IF V_preSlipNum is not null AND V_preSlipNum <> v_sCurSlipNum THEN
  		INSERT INTO OT_LOG_SLIP_AUD (
  			AUDID,
  			ADMUSERID,
  			ADMDATE,
  			PRESLPNO,
  			NEWSLPNO,
  			PRESEQNO,
  			NEWSEQNO,
  			PATNO
  		) VALUES (
  			SEQ_OT_LOG_SLIP_AUD.NEXTVAL,
  			V_USERID,
  			SYSDATE,
  			V_preSlipNum,
  			v_sCurSlipNum,
  			V_PreSeqNo,
  			V_NewSeqNo,
  			V_PATNO
  		);
  	END IF;
  		
  	O_ERRMSG := v_sCurSlipNum;

  	RETURN O_ERRCODE;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	o_ERRMSG := SQLERRM || o_ERRMSG;
	RETURN -1;
END NHS_ACT_OTSLTSLIP;
/
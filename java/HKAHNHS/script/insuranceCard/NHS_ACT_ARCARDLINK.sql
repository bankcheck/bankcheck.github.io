create or replace FUNCTION "NHS_ACT_ARCARDLINK"
(	V_ACTION VARCHAR2,
	V_ACTID ARCARD_EXCLUSIONS.ACTID%TYPE, 
  V_ARCCODE ARCARDTYPE.ARCCODE%TYPE, 
	V_ACTREGRMKIP ARCARDTYPE.ACTREGRMKIP%TYPE,  
	V_ACTREGRMKOP ARCARDTYPE.ACTREGRMKOP%TYPE,
	V_ACTPAYRMKIP ARCARDTYPE.ACTPAYRMKIP%TYPE,
	V_ACTPAYRMKOP ARCARDTYPE.ACTPAYRMKOP%TYPE,
	V_REGRMKIPURL ARCARDTYPE.REGRMKIPURL%TYPE,
	V_REGRMKOPURL ARCARDTYPE.REGRMKOPURL%TYPE,
  V_ACTCODE ARCARDTYPE.ACTCODE%TYPE,
  V_ACTDESC ARCARDTYPE.ACTDESC%TYPE,
	V_COLOUR1 ARCARDTYPE.COLOUR1%TYPE,
	V_COLOUR2 ARCARDTYPE.COLOUR2%TYPE,
	V_IPEXCLUSION ARCARDTERM.EXCLUSION%TYPE,
	V_OPEXCLUSION ARCARDTERM.EXCLUSION%TYPE,
	V_IPVOUCHER ARCARDTERM.VOUCHER%TYPE,
	V_OPVOUCHER ARCARDTERM.VOUCHER%TYPE,
	V_IPCLAIMFORM ARCARDTERM.CLAIM_FORM%TYPE,
	V_OPCLAIMFORM ARCARDTERM.CLAIM_FORM%TYPE,
	V_IPNAMELIST ARCARDTERM.NAME_LIST%TYPE,
	V_OPNAMELIST ARCARDTERM.NAME_LIST%TYPE,
	V_IPPREAUTHFORM ARCARDTERM.PRE_AUTHORISE_FORM%TYPE,
	V_OPPREAUTHFORM ARCARDTERM.PRE_AUTHORISE_FORM%TYPE,
	V_IPPREAUTHMEMO ARCARDTERM.PRE_AUTHORISATION_MEMO%TYPE,
	V_OPPREAUTHMEMO ARCARDTERM.PRE_AUTHORISATION_MEMO%TYPE,
	V_IPCONTACTRMK ARCARDTERM.REMARKS%TYPE,
	V_OPCONTACTRMK ARCARDTERM.REMARKS%TYPE,
	V_IPCONTACTDETAILS ARCARDTERM.CONTACT_DETAILS%TYPE,
	V_OPCONTACTDETAILS ARCARDTERM.CONTACT_DETAILS%TYPE,
	V_IPCONTACTPHONE ARCARDTERM.CONTACT_PHONE%TYPE,
	V_OPCONTACTPHONE ARCARDTERM.CONTACT_PHONE%TYPE,
	V_IPCONTACTFAX ARCARDTERM.FAX%TYPE,
	V_OPCONTACTFAX ARCARDTERM.FAX%TYPE,
	V_IPBILLREMARKS ARCARDTERM.BILLREMARKS%TYPE,
	V_OPBILLREMARKS ARCARDTERM.BILLREMARKS%TYPE,
	V_EBILLING VARCHAR2,
	V_SENDORGINV VARCHAR2,
	V_SAMPLEINV ARCARDTYPE.SAMPLEINV%TYPE,
	V_IPEXCLUSIONRMK ARCARDTERM.EXCLUSIONREMARKS%TYPE,
	V_OPEXCLUSIONRMK ARCARDTERM.EXCLUSIONREMARKS%TYPE,
	V_IPCONTACTEMAIL ARCARDTERM.CONTACT_EMAIL%TYPE,
	V_OPCONTACTEMAIL ARCARDTERM.CONTACT_EMAIL%TYPE,
  V_ARCARDSDATE VARCHAR2,
	V_ARCARDEDATE VARCHAR2,
  V_ACTACTIVE VARCHAR2,
  V_UPLOADTOPORTAL VARCHAR2,
  V_BILLINGOTHER VARCHAR2,
  V_IPPOLICYSAMPLE VARCHAR2,
  V_OPPOLICYSAMPLE VARCHAR2,
	V_HEALTHTEXT COVERAGE.HEALTHTEXT%TYPE,
	V_IMMUNIZATIONTEXT COVERAGE.IMMUNIZATIONTEXT%TYPE,
	V_PRENATALTEXT COVERAGE.PRENATALTEXT%TYPE,
	V_COVERATE COVERAGE.COVERATE%TYPE,
	V_WBTEXT COVERAGE.WBTEXT%TYPE,
	V_IPOFC_HOUR ARCARDTERM.OFC_HOUR%TYPE,
  V_OPOFC_HOUR ARCARDTERM.OFC_HOUR%TYPE,  
  V_IPACKNOWLEDGE_FORM ARCARDTERM.ACKNOWLEDGE_FORM%TYPE,  
  V_IPDTL_PROCEDURES ARCARDTERM.DTL_PROCEDURES%TYPE,  
  V_OPDTL_PROCEDURES ARCARDTERM.DTL_PROCEDURES%TYPE,    
  	o_errmsg OUT VARCHAR2
)
	RETURN NUMBER
AS
  O_ERRCODE NUMBER;
  IDCOUNT NUMBER := 0;
  V_CNT_COVERAGE NUMBER := 0;
  V_CNT_ARCARDTERM_IN NUMBER := 0;
  V_CNT_ARCARDTERM_OUT NUMBER := 0;
  V_NEWACTID ARCARD_EXCLUSIONS.ACTID%TYPE;
  V_ARCARDSDATE1 DATE;
  V_ARCARDEDATE1 DATE;  
  V_CARDID ACTID_CARDID_MAPPING.CARDID%TYPE;
  i NUMBER;
BEGIN
	o_errcode := 0;
	O_ERRMSG := 'OK';
  
	IF TRIM(V_ARCARDSDATE) = '' THEN
		V_ARCARDSDATE1:= NULL;
	ELSE
		V_ARCARDSDATE1 := TO_DATE(V_ARCARDSDATE,'dd/MM/yyyy');
	END IF;  
	
	IF TRIM(V_ARCARDEDATE) = '' THEN
		V_ARCARDEDATE1:= NULL;
	ELSE
		V_ARCARDEDATE1 := TO_DATE(V_ARCARDEDATE,'dd/MM/yyyy');
	END IF;
	
	IF V_ACTION = 'ADD' THEN
    V_NEWACTID := SEQ_ARCARDTYPE.NEXTVAL;
    V_CARDID := V_NEWACTID;

		INSERT INTO ARCARDTYPE (
        ACTID,
        ARCCODE,
        ACTCODE,
        ACTDESC,
        ACTREGRMKIP,
        ACTREGRMKOP,
        ACTPAYRMKIP,
        ACTPAYRMKOP,
        REGRMKIPURL,
        REGRMKOPURL,
        ACTACTIVE,
				COLOUR1,
				COLOUR2,
				EBILLING,
				SENDORGINV, 
				SAMPLEINV,
				ARCARDSDATE,
				ARCARDEDATE,
				UPLOADTOPORTAL,
				BILLINGOTHER
    ) VALUES (
				V_NEWACTID,
        V_ARCCODE,
        V_ACTCODE,
        V_ACTDESC,        
				V_ACTREGRMKIP,
				V_ACTREGRMKOP,
				V_ACTPAYRMKIP,
				V_ACTPAYRMKOP,
				V_REGRMKIPURL,
				V_REGRMKOPURL,
				V_ACTACTIVE,
				V_COLOUR1,
				V_COLOUR2,
				TO_NUMBER(V_EBILLING),
				TO_NUMBER(V_SENDORGINV), 
				V_SAMPLEINV,
				V_ARCARDSDATE1,
				V_ARCARDEDATE1,
				V_UPLOADTOPORTAL,
				V_BILLINGOTHER  
		  );  

		INSERT INTO ARCARDTERM (  	
                CARDID,
                TYPE,
                CONTACT_DETAILS,
                CONTACT_PHONE,
                FAX,
                OFC_HOUR,
                TIME_LIMIT,
                LIMIT,
                PRE_AUTHOURISE,
                GUARANTEE,
                ACKNOWLEDGE,
                NAME_LIST,
                EXCLUSION,
                VOUCHER,
                TERMS,
                ALERT,
                REMARKS,
                LASTDATE,
                LASTMODIFY,
                PRE_AUTHORISE_FORM,
                CLAIM_FORM,
                PRE_AUTHORISATION,
                PRE_AUTHORISATION_MEMO,
                ACTID,
                BILLREMARKS,
                EXCLUSIONREMARKS,
                CONTACT_EMAIL,
                POLICYSAMPLE,
                ACKNOWLEDGE_FORM,
                DTL_PROCEDURES
    ) VALUES (
                V_CARDID,
                'In',
                V_IPCONTACTDETAILS,
                V_IPCONTACTPHONE,
                V_IPCONTACTFAX,
                V_IPOFC_HOUR,
                NULL,
                0,
                0,
                0,
                0,
                V_IPNAMELIST,
                V_IPEXCLUSION,
                V_IPVOUCHER,
                NULL,
                NULL,
                V_IPCONTACTRMK,
                NULL,
                NULL,
                V_IPPREAUTHFORM,
                V_IPCLAIMFORM,
                0,
                V_IPPREAUTHMEMO,
                V_NEWACTID,
                V_IPBILLREMARKS,
                V_IPEXCLUSIONRMK,
                V_IPCONTACTEMAIL,
                V_IPPOLICYSAMPLE,
                V_IPACKNOWLEDGE_FORM,
                V_IPDTL_PROCEDURES                
        );
        
		INSERT INTO ARCARDTERM(  	
                CARDID,
                TYPE,
                CONTACT_DETAILS,
                CONTACT_PHONE,
                FAX,
                OFC_HOUR,
                TIME_LIMIT,
                LIMIT,
                PRE_AUTHOURISE,
                GUARANTEE,
                ACKNOWLEDGE,
                NAME_LIST,
                EXCLUSION,
                VOUCHER,
                TERMS,
                ALERT,
                REMARKS,
                LASTDATE,
                LASTMODIFY,
                PRE_AUTHORISE_FORM,
                CLAIM_FORM,
                PRE_AUTHORISATION,
                PRE_AUTHORISATION_MEMO,
                ACTID,
                BILLREMARKS,
                EXCLUSIONREMARKS,
                CONTACT_EMAIL,
                POLICYSAMPLE,
                DTL_PROCEDURES
        ) VALUES (
                V_CARDID,
                'Out',
                V_OPCONTACTDETAILS,
                V_OPCONTACTPHONE,
                V_OPCONTACTFAX,
                V_OPOFC_HOUR,
                NULL,
                0,
                0,
                0,
                0,
                V_OPNAMELIST,
                V_OPEXCLUSION,
                V_OPVOUCHER,
                NULL,
                NULL,
                V_OPCONTACTRMK,
                NULL,
                NULL,
                V_OPPREAUTHFORM,
                V_OPCLAIMFORM,
                0,
                V_OPPREAUTHMEMO,
                V_NEWACTID,
                V_OPBILLREMARKS,
                V_OPEXCLUSIONRMK,
                V_OPCONTACTEMAIL,
                V_OPPOLICYSAMPLE,
                V_OPDTL_PROCEDURES
        ); 
        
        
        INSERT INTO ACTID_CARDID_MAPPING (
                ACTID,
                ARCCODE,
                CARDID
        ) VALUES (
                V_NEWACTID,
                V_ARCCODE,        
                V_CARDID
        );
        
        
        INSERT INTO COVERAGE (
                CARDID,
                HEALTHTEXT,
                IMMUNIZATIONTEXT,
                PRENATALTEXT,
                COVERATE,
                WBTEXT,
                ACTID
        ) VALUES (
                V_CARDID,
                V_HEALTHTEXT,
                V_IMMUNIZATIONTEXT,
                V_PRENATALTEXT,
                V_COVERATE,
                V_WBTEXT,
                V_NEWACTID
        );       
	ELSIF V_ACTION = 'MOD' THEN
    BEGIN
      SELECT CARDID 
      INTO V_CARDID
      FROM ACTID_CARDID_MAPPING 
      WHERE ACTID = V_ACTID;
  
    EXCEPTION  
    WHEN OTHERS THEN
        V_CARDID := V_ACTID;
    
        INSERT INTO ACTID_CARDID_MAPPING (
                ACTID,
                ARCCODE,
                CARDID
        ) VALUES (
                V_ACTID,
                V_ARCCODE,        
                V_CARDID
        );     
    END;   
    
      UPDATE ARCARDTYPE
	  	SET ACTDESC = V_ACTDESC,
      ACTREGRMKIP = V_ACTREGRMKIP,
			ACTREGRMKOP = V_ACTREGRMKOP,
			ACTPAYRMKIP = V_ACTPAYRMKIP,
			ACTPAYRMKOP = V_ACTPAYRMKOP,
			REGRMKIPURL = V_REGRMKIPURL,
			REGRMKOPURL = V_REGRMKOPURL,
			COLOUR1 = V_COLOUR1,
			COLOUR2 = V_COLOUR2,
			EBILLING = TO_NUMBER(V_EBILLING),
			SENDORGINV = TO_NUMBER(V_SENDORGINV), 
			SAMPLEINV = V_SAMPLEINV,
			ARCARDSDATE = V_ARCARDSDATE1,
			ARCARDEDATE = V_ARCARDEDATE1,
			ACTACTIVE = V_ACTACTIVE,
			UPLOADTOPORTAL = V_UPLOADTOPORTAL,
			BILLINGOTHER = V_BILLINGOTHER,
      ACTCODE = V_ACTCODE
    WHERE ACTID = V_ACTID;  
  
-- IN-PATIENT RECORD
    SELECT COUNT(1)
    INTO V_CNT_ARCARDTERM_IN
    FROM ARCARDTERM 
    WHERE ACTID = V_ACTID
    AND TYPE = 'In';  
DBMS_OUTPUT.PUT_LINE('[V_CNT_ARCARDTERM_IN]:'||V_CNT_ARCARDTERM_IN||';[ARCARDTERM][In][V_CARDID]:'||V_CARDID);  
    IF V_CNT_ARCARDTERM_IN = 0 THEN
  		INSERT INTO ARCARDTERM (  	
                CARDID,
                TYPE,
                CONTACT_DETAILS,
                CONTACT_PHONE,
                FAX,
                OFC_HOUR,
                TIME_LIMIT,
                LIMIT,
                PRE_AUTHOURISE,
                GUARANTEE,
                ACKNOWLEDGE,
                NAME_LIST,
                EXCLUSION,
                VOUCHER,
                TERMS,
                ALERT,
                REMARKS,
                LASTDATE,
                LASTMODIFY,
                PRE_AUTHORISE_FORM,
                CLAIM_FORM,
                PRE_AUTHORISATION,
                PRE_AUTHORISATION_MEMO,
                ACTID,
                BILLREMARKS,
                EXCLUSIONREMARKS,
                CONTACT_EMAIL,
                POLICYSAMPLE,
                ACKNOWLEDGE_FORM
    ) VALUES (
                V_CARDID,
                'In',
                V_IPCONTACTDETAILS,
                V_IPCONTACTPHONE,
                V_IPCONTACTFAX,
                V_IPOFC_HOUR,
                NULL,
                0,
                0,
                0,
                0,
                V_IPNAMELIST,
                V_IPEXCLUSION,
                V_IPVOUCHER,
                NULL,
                NULL,
                V_IPCONTACTRMK,
                NULL,
                NULL,
                V_IPPREAUTHFORM,
                V_IPCLAIMFORM,
                0,
                V_IPPREAUTHMEMO,
                V_ACTID,
                V_IPBILLREMARKS,
                V_IPEXCLUSIONRMK,
                V_IPCONTACTEMAIL,
                V_IPPOLICYSAMPLE,
                V_IPACKNOWLEDGE_FORM
        );
  DBMS_OUTPUT.PUT_LINE('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM||';[SQL%ROWCOUNT]:'||SQL%ROWCOUNT);        
    ELSE
      UPDATE ARCARDTERM
      SET 	EXCLUSION= V_IPEXCLUSION,
            VOUCHER = V_IPVOUCHER,
            CLAIM_FORM = V_IPCLAIMFORM,
        --	ACKNOWLEDGE_FORM = V_IPACKNOWFORM,
            NAME_LIST = V_IPNAMELIST,
            PRE_AUTHORISE_FORM = V_IPPREAUTHFORM,
            PRE_AUTHORISATION_MEMO = V_IPPREAUTHMEMO,
            REMARKS = V_IPCONTACTRMK,
            CONTACT_DETAILS = V_IPCONTACTDETAILS,
            CONTACT_PHONE = V_IPCONTACTPHONE,
            FAX = V_IPCONTACTFAX,
            BILLREMARKS = V_IPBILLREMARKS,
            EXCLUSIONREMARKS = V_IPEXCLUSIONRMK,
            CONTACT_EMAIL = V_IPCONTACTEMAIL,
            POLICYSAMPLE = V_IPPOLICYSAMPLE,
            OFC_HOUR = V_IPOFC_HOUR,
            ACKNOWLEDGE_FORM = V_IPACKNOWLEDGE_FORM,
            DTL_PROCEDURES = V_IPDTL_PROCEDURES
        WHERE ACTID = V_ACTID
        AND TYPE = 'In';     
    END IF;

-- OUT-PATIENT RECORD 
    SELECT COUNT(1)
    INTO V_CNT_ARCARDTERM_OUT
    FROM ARCARDTERM 
    WHERE ACTID = V_ACTID
    AND TYPE = 'Out';
    
    IF V_CNT_ARCARDTERM_OUT = 0 THEN
      INSERT INTO ARCARDTERM(  	
                  CARDID,
                  TYPE,
                  CONTACT_DETAILS,
                  CONTACT_PHONE,
                  FAX,
                  OFC_HOUR,
                  TIME_LIMIT,
                  LIMIT,
                  PRE_AUTHOURISE,
                  GUARANTEE,
                  ACKNOWLEDGE,
                  NAME_LIST,
                  EXCLUSION,
                  VOUCHER,
                  TERMS,
                  ALERT,
                  REMARKS,
                  LASTDATE,
                  LASTMODIFY,
                  PRE_AUTHORISE_FORM,
                  CLAIM_FORM,
                  PRE_AUTHORISATION,
                  PRE_AUTHORISATION_MEMO,
                  ACTID,
                  BILLREMARKS,
                  EXCLUSIONREMARKS,
                  CONTACT_EMAIL,
                  POLICYSAMPLE
          ) VALUES (
                  V_CARDID,
                  'Out',
                  V_OPCONTACTDETAILS,
                  V_OPCONTACTPHONE,
                  V_OPCONTACTFAX,
                  V_OPOFC_HOUR,
                  NULL,
                  0,
                  0,
                  0,
                  0,
                  V_OPNAMELIST,
                  V_OPEXCLUSION,
                  V_OPVOUCHER,
                  NULL,
                  NULL,
                  V_OPCONTACTRMK,
                  NULL,
                  NULL,
                  V_OPPREAUTHFORM,
                  V_OPCLAIMFORM,
                  0,
                  V_OPPREAUTHMEMO,
                  V_ACTID,
                  V_OPBILLREMARKS,
                  V_OPEXCLUSIONRMK,
                  V_OPCONTACTEMAIL,
                  V_OPPOLICYSAMPLE
          );
    ELSE 
      UPDATE ARCARDTERM
      SET 	EXCLUSION = V_OPEXCLUSION,
            VOUCHER = V_OPVOUCHER,
            CLAIM_FORM = V_OPCLAIMFORM,
        --	ACKNOWLEDGE_FORM = V_OPACKNOWFORM,
            NAME_LIST = V_OPNAMELIST,
            PRE_AUTHORISE_FORM = V_OPPREAUTHFORM,
            PRE_AUTHORISATION_MEMO = V_OPPREAUTHMEMO,
            REMARKS = V_OPCONTACTRMK,
            CONTACT_DETAILS = V_OPCONTACTDETAILS,
            CONTACT_PHONE = V_OPCONTACTPHONE,
            FAX = V_OPCONTACTFAX,
            BILLREMARKS = V_OPBILLREMARKS,
            EXCLUSIONREMARKS = V_OPEXCLUSIONRMK,
            CONTACT_EMAIL = V_OPCONTACTEMAIL,
            POLICYSAMPLE = V_OPPOLICYSAMPLE,
            OFC_HOUR = V_OPOFC_HOUR,
            DTL_PROCEDURES = V_OPDTL_PROCEDURES
      WHERE ACTID = V_ACTID
      AND TYPE = 'Out';     
  END IF;
  
  SELECT COUNT(1)
  INTO V_CNT_COVERAGE
  FROM COVERAGE 
  WHERE ACTID = V_ACTID;
  
  IF V_CNT_COVERAGE = 0 THEN
    INSERT INTO COVERAGE (
            CARDID,
            HEALTHTEXT,
            IMMUNIZATIONTEXT,
            PRENATALTEXT,
            COVERATE,
            WBTEXT,
            ACTID
    ) VALUES (
            V_CARDID,
            V_HEALTHTEXT,
            V_IMMUNIZATIONTEXT,
            V_PRENATALTEXT,
            V_COVERATE,
            V_WBTEXT,
            V_ACTID
    );      
  ELSE
		UPDATE COVERAGE
		SET HEALTHTEXT = V_HEALTHTEXT,
	    	IMMUNIZATIONTEXT = V_IMMUNIZATIONTEXT,
	    	PRENATALTEXT = V_PRENATALTEXT,
	    	COVERATE = V_COVERATE,
	    	WBTEXT = V_WBTEXT
    WHERE ACTID = V_ACTID;       
  END IF;  
  
ELSIF V_ACTION = 'DEL' THEN
  DELETE FROM ACTID_CARDID_MAPPING 
	WHERE ACTID = V_ACTID;
      
	DELETE FROM ARCARDTYPE
  WHERE ACTID = V_ACTID;        
      
	DELETE ARCARDTERM
  WHERE ACTID = V_ACTID
  AND TYPE IN ('In','Out');       
      
	DELETE COVERAGE
  WHERE CARDID = V_CARDID;      
END IF;
      
  COMMIT;
  o_errmsg := 'OK - '||';[V_NEWACTID]:'||V_NEWACTID||';';
  RETURN O_ERRCODE;
EXCEPTION  
WHEN OTHERS THEN
ROLLBACK;
  o_errmsg := 'An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM||';[V_NEWACTID]:'||V_NEWACTID||';';
  DBMS_OUTPUT.PUT_LINE('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
  RETURN -1;
END NHS_ACT_ARCARDLINK;
/
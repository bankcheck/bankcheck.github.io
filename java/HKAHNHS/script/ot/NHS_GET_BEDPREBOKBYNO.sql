create or replace FUNCTION "NHS_GET_BEDPREBOKBYNO"
(v_pbpid IN bedprebok.pbpid%TYPE)
RETURN
TYPES.cursor_type
AS
OUTCUR TYPES.cursor_type;
v_PBMID NUMBER;
v_PBSNO VARCHAR2(20);
v_PBSID VARCHAR2(10);
v_PBPKGCODE VARCHAR2(10);
V_PBPKGCODE2 BEDPREBOK_EXTRA.PBPKGCODE2%TYPE;
V_Festid FIN_EST_HOSP.FESTID%Type;
V_BE FIN_EST_HOSP.OSB_BE%TYPE;
v_Count NUMBER;

BEGIN

	SELECT COUNT(1) INTO v_Count FROM BEDPREBOK_EXTRA WHERE PBPID = v_PBPID;
		IF v_COUNT = 1 THEN
		SELECT PBMID, PBSNO,PBSID,PBPKGCODE, PBPKGCODE2
		INTO   v_PBMID, v_PBSNO, v_PBSID, v_PBPKGCODE, V_PBPKGCODE2
		FROM   BEDPREBOK_EXTRA
		WHERE  PBPID = v_PBPID;
		END IF;
	
	SELECT COUNT(1) INTO v_Count FROM Fin_Est_Hosp WHERE PBPID = v_PBPID;
		IF v_COUNT = 1 THEN  
		Select Osb_Be, FESTID Into V_Be,V_Festid
		From Fin_Est_Hosp Fe
		Where Fe.Pbpid = V_Pbpid;
		END IF;
		
     OPEN OUTCUR FOR
          SELECT B.PBPID,
          		TO_CHAR(B.bpbhdate,'DD/MM/YYYY hh24:mi'),
          		B.DOCCODE,
              B.fordelivery,
          		B.ISMAINLAND,
          		B.ACMCODE,
          		B.wrdcode,
          		B.BPBRMK,
          		B.cablabrmk,
          		B.OTREMARK,
          		B.BEDCODE,
          		B.eststaylen,
          		B.ARCCODE,
          		B.POLICY,
              B.COPAYTYP,
          		B.COPAYAMT,
          		B.VOUCHER,
          		TO_CHAR(B.CVREDATE,'DD/MM/YYYY'),
          		B.ARLMTAMT,
          		B.ISDOCTOR,
              B.ISSPECIAL,
              B.ISHOSPITAL,
              B.ISOTHER,
              B.ISREFUSED,
              B.REFUSEREASON,
              B.REFUSEDUSERID,
              TO_CHAR(B.REFUSEDDATE,'DD/MM/YYYY'),
              B.ACTIVATEDUSERID,
              TO_CHAR(B.ACTIVATEDDATE,'DD/MM/YYYY'),
              B.PATNO,
              B.PATFNAME,
              B.PATGNAME,
              B.PATIDNO,
              B.PATKHTEL,
              B.BPBCNAME,
              B.PATPAGER,
              TO_CHAR(P.PATBDATE, 'DD/MM/YYYY'),
              B.SEX,
              v_PBMID,
              v_PBSID,
              v_PBSNO,
              v_PBPKGCODE,
              V_Festid,
              V_Be,
              V_PBPKGCODE2
	       FROM BEDPREBOK B, PATIENT P
	       WHERE B.PBPID = V_PBPID
         AND B.PATNO = P.PATNO(+);
     RETURN OUTCUR;
END NHS_GET_BEDPREBOKBYNO;
/
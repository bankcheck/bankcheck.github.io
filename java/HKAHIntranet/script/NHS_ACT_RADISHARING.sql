create or replace
Function Nhs_Act_Radisharing
(
   R_Action  In Varchar2,
  R_Actiondetail  In Varchar2,
  R_Accession_No  In Varchar2,
  R_Patno  In Varchar2,
  R_Hkid  In Varchar2,
  R_Pname  In Varchar2,
  R_Dob  In Varchar2,
  R_Sex  In Varchar2,
  R_Modifieduser  In Varchar2,
  R_Sitecode In Varchar2,
  R_status In Varchar2,
  O_Errmsg		Out Varchar2
)
Return Number As
  o_errcode	NUMBER;
Begin
  O_Errmsg := 'OK';
  o_errcode := 0;

   If (R_Action = 'MOD')Then
       If(R_Actiondetail ='SendSuccess')Then
            If(R_Sitecode ='HKAH')Then
                Update Systemlog@Hka_Radi
                Set Msg_Trans_Type = 'D',
                Sl_Status = R_Status,
                Sl_Modified_Date = Sysdate,
                SL_MODIFIED_USER = R_Modifieduser
                Where Accession_No = R_Accession_No
                And Pat_Patno = R_Patno
                And  Upper(Pat_Name) = Upper(R_Pname)
                And Pat_Dob = To_Timestamp(R_Dob,'yyyy-mm-dd HH24:MI:SS,FF3');
             ElsIf(R_Sitecode ='TWAH')Then
                   Update Systemlog@TWA_RADI
                  Set Msg_Trans_Type = 'D',
                  Sl_Status = R_Status,
                  Sl_Modified_Date = Sysdate,
                  SL_MODIFIED_USER = R_Modifieduser
                  Where Accession_No = R_Accession_No
                  And Pat_Patno = R_Patno
                  And  Upper(Pat_Name) = Upper(R_Pname)
                  And Pat_Dob = To_Timestamp(R_Dob,'yyyy-mm-dd HH24:MI:SS,FF3');    
            End If; --site
         ElsIf(R_Actiondetail ='updateInfo')Then
             If(R_Sitecode ='HKAH')Then    
                  Update SYSTEMLOG@HKA_RADI
                  Set Pat_Name = Upper(R_Pname),
                         SL_MODIFIED_USER = R_Modifieduser
                  Where Accession_No = R_Accession_No
                  And Pat_Hkid = R_Hkid;
               Elsif(R_Sitecode ='TWAH')Then
                Update SYSTEMLOG@TWA_RADI
                Set Pat_Name = Upper(R_Pname),
                       SL_MODIFIED_USER = R_Modifieduser
                Where Accession_No = R_Accession_No
                And Pat_Hkid = R_Hkid;
              END IF;
       End If;            
   End If;

  COMMIT;

  Return O_Errcode;
Exception
WHEN OTHERS THEN
	O_Errcode := -1;
	o_errmsg := 'Fail to save the Record.';
  
	ROLLBACK;
  return o_errcode;
END NHS_ACT_RADISHARING;
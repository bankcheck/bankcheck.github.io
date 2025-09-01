create or replace
FUNCTION        "NHS_LIS_RADISHARING"                       
  (                                                                             
   V_Patno In Varchar2,                                                         
   V_Hkid In Varchar2,                                                          
   V_Engname In Varchar2,                                                       
   V_Dob In Varchar2,                                                           
   V_Examdate In Varchar2,                                                      
   V_Showall In Varchar2,                                                       
   V_Sex In Varchar2,
   V_Transtype In Varchar2,
   V_siteCode In Varchar2
  )                                                                             
    RETURN types.CURSOR_TYPE                                                    
  AS                                                                            
    Outcur Types.Cursor_Type;                                                   
    site Varchar2(50);
    Sqlstr Varchar2(3000); 
Begin
  If(V_siteCode ='HKAH')Then
    site := 'HKA_RADI';
  End If;
  If(V_siteCode ='TWAH')Then
    Site := 'TWA_RADI';
  End If;  
                                                                              

         If V_Transtype = 'R' Then     
            Sqlstr := 'Select                                                         
             Rs.Sl_Status,                                                      
             RS.Accession_No,                                                   
             RS.Pat_Patno,                                                      
             RS.Pat_Name,                                                       
             RS.Pat_Hkid,                                                       
             RS.Pat_Passport,                                                   
             RS.Pat_Sex,                                                        
             RS.Pat_Dob,                                                        
             RS.Pat_Type,                                                       
             Rs.Exam_Date,                                                      
             Rs.Exam_Type,                                                      
             Rs.Study_Date,                                                     
             Rs.Exam_Report_Desc,                                               
             Rs.Exam_Report_Path,                                               
             Rs.Exam_Image_Desc,
             Rs.Exam_Image_Path FROM SYSTEMLOG@'||site||' RS ';
        ElsIf( V_Transtype = 'D')Then
            Sqlstr := 'Select                                                                                                              
             RS.Accession_No,                                                   
             RS.Pat_Patno,                                                      
             RS.Pat_Name,                                                                                                                                        
             Rs.SL_MODIFIED_DATE,
             Rs.SL_MODIFIED_USER,
             Rs.Exam_Image_Path,
             Rs.Exam_Report_Path,
             RS.Pat_Hkid,
             RS.Pat_Dob FROM SYSTEMLOG@'||site||' RS ';
        Elsif( V_Transtype = 'report')Then
            Sqlstr := 'Select decode(Sl_Status,''S'',''  Case Sent:'',''  Extra Images Sent:''), 
            count(*) as total 
            FROM SYSTEMLOG@'||site||' RS ';          
        end if;
          If V_Transtype = 'R' Then                                                       
            Sqlstr := Sqlstr || ' WHERE Rs.MSG_TRANS_TYPE in(''R'') ';                
          Else                                                                     
            Sqlstr := Sqlstr || ' WHERE Rs.Sl_Status in(''S'',''X'') '; 
          End If;
          IF V_Transtype = 'R' Then 
              If V_Examdate Is Not Null Then                                                
                Sqlstr := Sqlstr || ' AND  Rs.Exam_Date =TO_DATE('''||V_Examdate||''',''dd/mm/yyyy'')';
              End If;                                                                       
              If V_Patno Is Not Null Then                                                   
                Sqlstr := Sqlstr || ' AND  RS.Pat_Patno =''' || V_Patno || ''' ';           
              END IF;                                                                       
              If V_Hkid Is Not Null Then                                                    
                Sqlstr := Sqlstr || ' AND  RS.Pat_Hkid =''' || V_Hkid || ''' ';             
              END IF;                                                                       
              If V_Engname Is Not Null Then                                                 
                Sqlstr := Sqlstr || ' AND  UPPER(RS.Pat_Name) like UPPER(''%' ||  V_Engname || '%'') ';                                                                           
              END IF;                                                                       
              If V_Dob Is Not Null Then                                                     
                Sqlstr := Sqlstr || ' AND  RS.Pat_Dob =TO_DATE('''||V_Dob||''',''dd/mm/yyyy'')';
              End If;                                                                       
             If V_Sex Is Not Null Then                                                      
               Sqlstr := Sqlstr || ' AND  RS.Pat_Sex =''' || V_Sex || '''';                
              End If;
         ElsIf( V_Transtype = 'D')Then
                Sqlstr := Sqlstr || 'AND Rs.SL_MODIFIED_DATE is not null '; 
            If V_Patno Is Not Null Then
              Sqlstr := Sqlstr || 'AND RS.Accession_No like''%' || V_Patno || '%''    '; 
            End If;
               Sqlstr := Sqlstr || ' ORDER BY  Rs.SL_MODIFIED_DATE desc ';
        Elsif( V_Transtype = 'report')Then
                 Sqlstr := Sqlstr || ' AND  To_Char(Rs.Sl_Modified_Date,''dd/mm/yyyy'') = To_Char(Sysdate,''dd/mm/yyyy'') ';
                 Sqlstr := Sqlstr || ' GROUP BY rs.Sl_Status order by rs.Sl_Status';
        End If;

  OPEN OUTCUR FOR SQLSTR;                                                       
 Return Outcur;                                                                 
                                                                                
END NHS_LIS_RADISHARING;
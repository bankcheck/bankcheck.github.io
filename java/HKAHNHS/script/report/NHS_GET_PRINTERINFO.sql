create or replace
FUNCTION "NHS_GET_PRINTERINFO"                       
  (
   V_IP In Varchar2
  )                                                                             
    RETURN types.CURSOR_TYPE                                                    
  AS                                                                            
    Outcur Types.Cursor_Type;    
Begin

 	Open Outcur For
  Select  Printer_Type, Printer_Name  
  From NHS_Printerinfo
  Where Computer_Ip = V_IP ;
  
 Return Outcur;                                                                                                                                                
END NHS_GET_PRINTERINFO ;
/

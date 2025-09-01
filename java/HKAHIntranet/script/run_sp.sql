declare
  out_n NUMBER(10,0) ;
  out_p varchar2(100) ;
begin
  ACT_ROLE('ADD', '999', '2', 'HKAH', out_n, out_p) ;
  dbms_output.put_line( out_p ) ;
end ;
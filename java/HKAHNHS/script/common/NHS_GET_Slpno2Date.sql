create or replace FUNCTION NHS_GET_Slpno2Date
( i_slpNo VARCHAR2 )
RETURN Types.CURSOR_type
AS
	outcur types.cursor_type;
BEGIN
	OPEN outcur for select 
		to_char( 
			to_date( to_char( substr( i_slpno, 1,4 ) ) || '0101','YYYYMMDD' ) + to_number( substr( i_slpno, 5,3) ) -1
			, 'DD/MM/YYYY' ) from dual ;
	return outcur ;
END ;
/
CREATE OR REPLACE FUNCTION "NHS_ACT_BEDRESERVATION"
(
	v_action IN VARCHAR2,
  v_bedcode IN bed.bedcode%TYPE,
	v_remarks IN bed.bedremark%TYPE,
	v_date IN VARCHAR2,
	o_errmsg		 OUT VARCHAR2
)
	RETURN NUMBER
AS
	v_noOfRec NUMBER;
  o_errcode       NUMBER;
BEGIN

	o_errcode := 0;
	o_errmsg := 'OK';

  SELECT count(1) INTO v_noOfRec FROM BED  WHERE bedcode = v_bedcode;
  IF v_action = 'MOD' THEN
     dbms_output.put_line('add11');
    IF v_noOfRec > 0 THEN
    update bed b set
    b.bedremark=v_remarks,
    b.bedrdate=to_date(v_date,'dd/MM/yyyy')
    where b.bedcode=v_bedcode;
    END IF;
  END IF;
	RETURN o_errcode;
END NHS_ACT_BEDRESERVATION;
/

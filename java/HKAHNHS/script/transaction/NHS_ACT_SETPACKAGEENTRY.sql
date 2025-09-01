CREATE OR REPLACE FUNCTION "NHS_ACT_SETPACKAGEENTRY" (
v_action		IN VARCHAR2,
v_ptnid     IN VARCHAR2,
v_ptnsts    IN VARCHAR2,
v_ptndesc   IN VARCHAR2,
o_errmsg		OUT VARCHAR2
)RETURN NUMBER
AS
o_errcode		NUMBER;
 v_noOfRec NUMBER;
BEGIN
  o_errcode := 0;
  o_errmsg := 'OK';
  SELECT count(1) INTO v_noOfRec FROM PkgTx WHERE ptnid = to_number(v_ptnid);

	IF v_action = 'MOD' THEN
    IF v_noOfRec > 0 THEN
       IF v_ptndesc is null THEN
           update PkgTx set ptnsts=v_ptnsts where ptnid = to_number(v_ptnid);
       ELSE
           update PkgTx set ptnsts=v_ptnsts,ptndesc=v_ptndesc where ptnid = to_number(v_ptnid);
       END IF;
    ELSE
      o_errcode := -1;
      o_errmsg := 'Record not exists.';
    END IF;
  END IF;

  RETURN o_errcode;
end NHS_ACT_SetPackageEntry;
/

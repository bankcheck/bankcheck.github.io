create or replace
FUNCTION                "NHS_GET_ARCSLPRLVL"(
	V_ARCCODE IN VARCHAR2,
  v_slpType IN VARCHAR2,
  v_slpRLvl IN VARCHAR2,
  V_DSCODE IN VARCHAR2,
  V_PKGCODE IN VARCHAR2
)
	return varchar2
AS
  v_RLvl VARCHAR2(10);

BEGIN
      V_RLVL := V_SLPRLVL;
      IF (V_ARCCODE ='BUPAI' or V_ARCCODE ='MAI' or V_ARCCODE ='QHCL') and v_slpType ='O' AND V_DSCODE = 'CL'  AND (V_PKGCODE IS NULL) THEN
          V_RLVL := '6';
      Elsif V_Arccode ='TOKIO' And V_Dscode = 'CL'  AND (V_PKGCODE IS NULL) Then
          V_Rlvl := '6';
      ELSIF V_ARCCODE ='BUPAS' AND V_DSCODE ='OR' and v_slpType ='I' AND (V_PKGCODE IS NULL) THEN
          v_RLvl := '6';
      END IF;
     
	RETURN v_RLvl;
END NHS_GET_ARCSLPRLVL;
/
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
      IF GET_CURRENT_STECODE() = 'HKAH' THEN
	      IF (V_ARCCODE ='MAI' OR V_ARCCODE ='QHCL') AND V_SLPTYPE ='O' 
	        AND V_DSCODE = 'CL'  AND (V_PKGCODE IS NULL) THEN
	          V_RLVL := '6';
	      Elsif (V_Arccode ='TOKIO' OR V_Arccode ='BUPAI' OR V_ARCCODE='IHID') And V_Dscode = 'CL'  AND (V_PKGCODE IS NULL) Then
	          V_RLVL := '6';
	      ELSIF V_ARCCODE ='BUPAS' AND V_DSCODE ='CL' AND V_SLPTYPE ='O' AND (V_PKGCODE IS NULL) THEN
	          v_RLvl := '6';          
	      ELSIF V_ARCCODE ='BUPAS' AND V_DSCODE ='OR' and v_slpType ='I' AND (V_PKGCODE IS NULL) THEN
	          v_RLvl := '6';
	      ELSIF V_ARCCODE ='QHCL' AND V_DSCODE ='CS' AND v_slpType ='O' AND (V_PKGCODE IS NULL) THEN
	          v_RLvl := '6';
	      END IF;
     ELSIF GET_CURRENT_STECODE() = 'TWAH' THEN
     	IF (V_ARCCODE ='T1700') AND V_SLPTYPE ='O' 
	        AND (V_DSCODE = 'LM' OR V_DSCODE = 'LB' OR V_DSCODE = 'LF' OR V_DSCODE = 'LC' OR V_DSCODE = 'LH'
	        OR V_DSCODE = 'LS' OR V_DSCODE = 'LU' )  
	        AND (V_PKGCODE IS NULL) THEN
	        V_RLVL := '6';
      END IF;
     END IF;
	RETURN v_RLvl;
END NHS_GET_ARCSLPRLVL;
/
CREATE OR REPLACE FUNCTION "NHS_UTL_LOOKUPGLCODECHGACM" (
	i_TxDate      IN VARCHAR2,
	i_ItemCode    IN VARCHAR2,
	i_BedCode     IN VARCHAR2,
	i_SlpType     IN VARCHAR2,
	i_GlcCode     IN VARCHAR2,
	I_CREDIT      IN BOOLEAN := FALSE,
	i_Cpsid       IN VARCHAR2 := '',
	i_PackageCode IN VARCHAR2 := '',
	i_AcmCode     IN VARCHAR2 := ''
)
	RETURN VARCHAR2
AS
	GLCCODE_NORMAL_LENGTH NUMBER;
	v_AcmCode ACM.ACMCODE%TYPE;
	v_LookupGLCodeChgACM VARCHAR2(10);
	v_stntdate DATE;
BEGIN
	GLCCODE_NORMAL_LENGTH := 4;

	IF i_TxDate IS NOT NULL THEN
		v_stntdate := TO_DATE(i_TxDate, 'DD/MM/YYYY');
	ELSE
		v_stntdate := TRUNC(SYSDATE);
	END IF;

	v_acmcode := NHS_UTL_LookupAcmCode(i_TxDate, i_acmcode, i_itemcode, i_packagecode, i_credit, i_cpsid);

	if i_credit then
		SELECT GlcCode INTO v_LookupGLCodeChgACM
		FROM   CreditChg
		WHERE  ItmCode = i_ItemCode
		AND    itctype = i_SlpType
		AND    Cpsid = i_Cpsid
		AND   (
			(i_packagecode is not null and length(i_packagecode) > 0 and pkgcode = i_packagecode) or
			((i_packagecode is null or length(i_packagecode) <= 0) and pkgcode is null)
		)
		AND   (
			(v_acmcode is not null and length(v_acmcode) > 0 and acmcode = v_acmcode) or
			((v_acmcode is null or length(v_acmcode) <= 0) and (acmcode is null or acmcode = ' '))
		)
		AND   ( cicsdt IS NULL OR cicsdt <= v_stntdate )
		AND   ( cicedt IS NULL OR cicedt >= v_stntdate );
	else
		if i_cpsid is not null and length(i_cpsid) > 0 then
			SELECT /*+ INDEX(I IDX_ITEMCHG_102) */ GlcCode INTO v_LookupGLCodeChgACM
			FROM   ItemChg I
			WHERE  ITMCODE = I_ITEMCODE
			AND    ITCTYPE = I_SLPTYPE
			AND    CPSID = I_CPSID
			AND   (
				(i_packagecode is not null and length(i_packagecode) > 0 and pkgcode = i_packagecode) or
				((i_packagecode is null or length(i_packagecode) <= 0) and pkgcode is null)
			)
			AND   (
				(v_acmcode is not null and length(v_acmcode) > 0 and acmcode = v_acmcode) or
				((v_acmcode is null or length(v_acmcode) <= 0) and (acmcode is null or acmcode = ' '))
			)
			AND   ( itcsdt IS NULL OR itcsdt <= v_stntdate )
			AND   ( itcedt IS NULL OR itcedt >= v_stntdate );
		END IF;
	END IF;

	if v_lookupglcodechgacm is null or length(v_lookupglcodechgacm) <= 0  then
		IF I_CREDIT THEN
			SELECT GlcCode INTO v_LookupGLCodeChgACM
			FROM   CreditChg
			WHERE  ItmCode = i_ItemCode
			AND    itctype = i_SlpType
			AND    Cpsid IS NULL
			AND   (
				(i_packagecode is not null and length(i_packagecode) > 0 and pkgcode = i_packagecode) or
				((i_packagecode is null or length(i_packagecode) <= 0) and pkgcode is null)
			)
			AND   (
				(v_acmcode is not null and length(v_acmcode) > 0 and acmcode = v_acmcode) or
				((v_acmcode is null or length(v_acmcode) <= 0) and (acmcode is null or acmcode = ' '))
			)
			AND   ( cicsdt IS NULL OR cicsdt <= v_stntdate )
			AND   ( cicedt IS NULL OR cicedt >= v_stntdate );
		else
			SELECT /*+ INDEX(I IDX_ITEMCHG_102) */ MAX(GlcCode) INTO v_LookupGLCodeChgACM
			FROM   ItemChg I
			WHERE  ItmCode = i_ItemCode
			AND    itctype = i_SlpType
			AND    cpsid is null
			AND   (
				(i_packagecode is not null and length(i_packagecode) > 0 and pkgcode = i_packagecode) or
				((i_packagecode is null or length(i_packagecode) <= 0) and pkgcode is null)
			)
			AND   (
				(v_acmcode is not null and length(v_acmcode) > 0 and acmcode = v_acmcode) or
				((v_acmcode is null or length(v_acmcode) <= 0) and (acmcode is null or acmcode = ' '))
			)
			AND   ( itcsdt IS NULL OR itcsdt <= v_stntdate )
			AND   ( itcedt IS NULL OR itcedt >= v_stntdate );
		END IF;
	END IF;

	IF LENGTH(v_LookupGLCodeChgACM) <= GLCCODE_NORMAL_LENGTH Then
		v_LookupGLCodeChgACM := SUBSTR(i_GlcCode, 1, 4) || v_LookupGLCodeChgACM;
	END IF;

	return v_LookupGLCodeChgACM;
EXCEPTION
WHEN OTHERS THEN
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);

	RETURN NULL;
END NHS_UTL_LOOKUPGLCODECHGACM;
/

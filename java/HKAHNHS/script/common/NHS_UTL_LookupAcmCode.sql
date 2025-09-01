-- Transaction.bas / LookupAcmCode
CREATE OR REPLACE FUNCTION NHS_UTL_LookupAcmCode (
	p_TxDate  VARCHAR2,
	p_AcmCode VARCHAR2,
	p_ItmCode VARCHAR2,
	p_PkgCode VARCHAR2,
	p_Credit  BOOLEAN default false,
	p_Cpsid   NUMBER
)
	RETURN VARCHAR2
IS
	l_cnt NUMBER(5);
	l_AcmCode CreditChg.AcmCode%TYPE;
	v_stntdate DATE;
	v_errmsg VARCHAR2(1000);
BEGIN
	IF p_AcmCode LIKE 'ZZ%' THEN
		-- bypass AcmCode search
		RETURN p_AcmCode;
	END IF;

	IF p_TxDate IS NOT NULL THEN
		v_stntdate := TO_DATE(p_TxDate, 'DD/MM/YYYY');
	ELSE
		v_stntdate := TRUNC(SYSDATE);
	END IF;

	IF p_Credit THEN
		SELECT MAX(AcmCode) INTO l_AcmCode
		FROM   CreditChg
		WHERE  AcmCode <= p_AcmCode
		AND
		(( p_ItmCode IS NULL AND PkgCode = p_PkgCode ) OR
		 ( p_ItmCode IS NOT NULL AND ItmCode = p_ItmCode
				AND ( ( p_PkgCode IS NULL AND PkgCode IS NULL ) OR ( p_PkgCode IS NOT NULL AND PkgCode = p_PkgCode ) )
				AND ( ( p_Cpsid IS NULL AND Cpsid IS NULL ) OR ( p_Cpsid IS NOT NULL AND Cpsid = p_Cpsid ) )
			)
		)
		AND ( cicsdt IS NULL OR cicsdt <= v_stntdate )
		AND ( cicedt IS NULL OR cicedt >= v_stntdate );

		IF l_AcmCode IS NULL THEN
			SELECT MAX(AcmCode) INTO l_AcmCode
			FROM   CreditChg
			WHERE  AcmCode <= p_AcmCode
			AND
			(( p_ItmCode IS NULL AND PkgCode = p_PkgCode ) OR
			 ( p_ItmCode IS NOT NULL AND ItmCode = p_ItmCode
					AND ( ( p_PkgCode IS NULL AND PkgCode IS NULL ) OR ( p_PkgCode IS NOT NULL AND PkgCode = p_PkgCode ) )
					AND (   Cpsid IS NULL )
				)
			)
			AND ( cicsdt IS NULL OR cicsdt <= v_stntdate )
			AND ( cicedt IS NULL OR cicedt >= v_stntdate );
		END IF;
	ELSE
		SELECT MAX(AcmCode) INTO l_AcmCode
		FROM   ItemChg
		WHERE  AcmCode <= p_AcmCode
		AND
		(( p_ItmCode IS NULL AND PkgCode = p_PkgCode ) OR
		 ( p_ItmCode IS NOT NULL AND ItmCode = p_ItmCode
				AND ( ( p_PkgCode IS NULL AND PkgCode IS NULL ) OR ( p_PkgCode IS NOT NULL AND PkgCode = p_PkgCode ) )
				AND ( ( p_Cpsid IS NULL AND Cpsid IS NULL ) OR ( p_Cpsid IS NOT NULL AND Cpsid = p_Cpsid ) )
			)
		)
		AND ( itcsdt IS NULL OR itcsdt <= v_stntdate )
		AND ( itcedt IS NULL OR itcedt >= v_stntdate );

		IF l_AcmCode IS NULL THEN
			SELECT MAX(AcmCode) INTO l_AcmCode
			FROM   ItemChg
			WHERE  AcmCode <= p_AcmCode
			AND
			(( p_ItmCode IS NULL AND PkgCode = p_PkgCode ) OR
			 ( p_ItmCode IS NOT NULL AND ItmCode = p_ItmCode
					AND ( ( p_PkgCode IS NULL AND PkgCode IS NULL ) OR ( p_PkgCode IS NOT NULL AND PkgCode = p_PkgCode ) )
					AND (   Cpsid IS NULL )
				)
			)
			AND ( itcsdt IS NULL OR itcsdt <= v_stntdate )
			AND ( itcedt IS NULL OR itcedt >= v_stntdate );
		END IF;
	END IF;
	RETURN l_AcmCode;
EXCEPTION
WHEN OTHERS THEN
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);

	RETURN NULL;
END NHS_UTL_LookupAcmCode;
/

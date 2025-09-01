-- Transaction.bas \ LookupPackageCharge
CREATE OR REPLACE function NHS_SYS_LookupPackageCharge (
	p_TxDate  IN VARCHAR2,
	p_PkgCode IN VARCHAR2,  -- Package Code
	p_ItcType IN VARCHAR2,  -- Patient Type
	p_ItmCode IN VARCHAR2,  -- Item Code
	p_AcmCode IN VARCHAR2,  -- AccomodationCode
	p_CpsId   IN NUMBER,
	p_Credit  IN NUMBER := 0 -- 1 = true otherwise false
)
	RETURN Types.cursor_type
IS
	v_stntdate DATE;
	v_Count NUMBER;
	c_out types.cursor_type;
BEGIN
	IF p_TxDate IS NOT NULL THEN
		v_stntdate := TO_DATE(p_TxDate, 'DD/MM/YYYY');
	ELSE
		v_stntdate := TRUNC(SYSDATE);
	END IF;

	IF p_ItcType = 'O' AND p_AcmCode LIKE 'ZZ%' THEN
		SELECT COUNT(1) INTO v_Count
		from
		(
			select c.pkgcode, c.itmcode,  -- key
				c.acmcode, c.Itctype, c.ItcAmt1, c.ItcAmt2,
				i.ItmName , i.ItmCName, i.ItmCat, i.ItmType, nvl(p.pkgrLvl, i.itmrLvl) as itmrlvl
			from  ItemCreditChg c, item i, ItemCreditPkg p
			where c.tab_name = decode( p_Credit, 1, 'CREDITCHG', 'ITEMCHG' )
			and   p.tab_name = decode( p_Credit, 1, 'CREDITPKG', 'PACKAGE' )
			and   c.pkgcode = p_PkgCode and c.itctype = p_ItcType
			and   c.itmcode = i.itmcode
			and   c.pkgcode = p.pkgcode
			and   c.cpsid is null
			and   c.acmcode = p_AcmCode
			and ( p_ItmCode is null or ( i.itmCode = p_ItmCode and CpsId is null ) )
			and ( c.icsdt IS NULL OR c.icsdt <= v_stntdate )
			and ( c.icedt IS NULL OR c.icedt >= v_stntdate )
		) a
		left outer join
		(
			select c.pkgcode, c.itmcode,   -- key
				c.ItcAmt1 as ItcAmt3, c.ItcAmt2 as ItcAmt4, c.cpsid, c.cpspct
			from  ItemCreditChg c
			where c.tab_name = decode( p_Credit, 1, 'CREDITCHG', 'ITEMCHG' )
			and   c.pkgcode = p_PkgCode and c.itctype = p_ItcType
			and (
				( p_CpsId is null and CpsId is null )
				or
				( p_Cpsid is not null and c.cpsid = p_Cpsid ) )
			and   c.acmcode = p_AcmCode
			and ( p_ItmCode is null or ( c.itmCode = p_ItmCode ) )
			and ( c.icsdt IS NULL OR c.icsdt <= v_stntdate )
			and ( c.icedt IS NULL OR c.icedt >= v_stntdate )
		) b on a.pkgcode = b.pkgcode and a.itmcode = b.itmcode;

		IF v_Count > 0 THEN
			OPEN c_out FOR
				select a.itmcode, a.pkgcode, acmcode, Itctype, ItcAmt1, ItcAmt2,
					itcamt3, itcamt4, cpsid, cpspct,
					itmname, itmcname, itmcat, itmtype, itmrlvl
				from
				(
					select c.pkgcode, c.itmcode,  -- key
						c.acmcode, c.Itctype, c.ItcAmt1, c.ItcAmt2,
						i.ItmName , i.ItmCName, i.ItmCat, i.ItmType, nvl(p.pkgrLvl, i.itmrLvl) as itmrlvl
					from  ItemCreditChg c, item i, ItemCreditPkg p
					where c.tab_name = decode( p_Credit, 1, 'CREDITCHG', 'ITEMCHG' )
					and   p.tab_name = decode( p_Credit, 1, 'CREDITPKG', 'PACKAGE' )
					and   c.pkgcode = p_PkgCode and c.itctype = p_ItcType
					and   c.itmcode = i.itmcode
					and   c.pkgcode = p.pkgcode
					and   c.cpsid is null
					and   c.acmcode = p_Acmcode
					and ( p_ItmCode is null or ( i.itmCode = p_ItmCode and CpsId is null ) )
					and ( c.icsdt IS NULL OR c.icsdt <= v_stntdate )
					and ( c.icedt IS NULL OR c.icedt >= v_stntdate )
				) a
				left outer join
				(
					select c.pkgcode, c.itmcode,   -- key
						c.ItcAmt1 as ItcAmt3, c.ItcAmt2 as ItcAmt4, c.cpsid, c.cpspct
					from  ItemCreditChg c
					where c.tab_name = decode( p_Credit, 1, 'CREDITCHG', 'ITEMCHG' )
					and   c.pkgcode = p_PkgCode and c.itctype = p_ItcType
					and (
						( p_CpsId is null and CpsId is null )
						or
						( p_Cpsid is not null and c.cpsid = p_Cpsid ) )
					and   c.acmcode = p_Acmcode
					and ( p_ItmCode is null or ( c.itmCode = p_ItmCode ) )
					and ( c.icsdt IS NULL OR c.icsdt <= v_stntdate )
					and ( c.icedt IS NULL OR c.icedt >= v_stntdate )
				) b on a.pkgcode = b.pkgcode and a.itmcode = b.itmcode
				order by ItmCode ;
		END IF;
	ELSE
		SELECT COUNT(1) INTO v_Count
		from
		(
			select c.pkgcode, c.itmcode,  -- key
				c.acmcode, c.Itctype, c.ItcAmt1, c.ItcAmt2,
				i.ItmName , i.ItmCName, i.ItmCat, i.ItmType, nvl(p.pkgrLvl, i.itmrLvl) as itmrlvl
			from  ItemCreditChg c, item i, ItemCreditPkg p
			where c.tab_name = decode( p_Credit, 1, 'CREDITCHG', 'ITEMCHG' )
			and   p.tab_name = decode( p_Credit, 1, 'CREDITPKG', 'PACKAGE' )
			and   c.pkgcode = p_PkgCode and c.itctype = p_ItcType
			and   c.itmcode = i.itmcode
			and   c.pkgcode = p.pkgcode
			and   c.cpsid is null
			and ( ( p_ItcType != 'I' AND c.acmcode is null )
				or ( c.acmcode || '-' || c.ItmCode in (
					select max(acmcode) || '-' || itmcode
					from   ItemCreditChg
					where  tab_name = decode( p_Credit, 1, 'CREDITCHG', 'ITEMCHG' )
					and    pkgcode = p_PkgCode
					and    acmcode <= p_Acmcode
					and    cpsid is null
					and  ( icsdt IS NULL OR icsdt <= v_stntdate )
					and  ( icedt IS NULL OR icedt >= v_stntdate )
					group by itmcode ) ) )
			and ( p_ItmCode is null or ( i.itmCode = p_ItmCode and CpsId is null ) )
			and ( c.icsdt IS NULL OR c.icsdt <= v_stntdate )
			and ( c.icedt IS NULL OR c.icedt >= v_stntdate )
		) a
		left outer join
		(
			select c.pkgcode, c.itmcode,   -- key
				c.ItcAmt1 as ItcAmt3, c.ItcAmt2 as ItcAmt4, c.cpsid, c.cpspct
			from  ItemCreditChg c
			where c.tab_name = decode( p_Credit, 1, 'CREDITCHG', 'ITEMCHG' )
			and   c.pkgcode = p_PkgCode and c.itctype = p_ItcType
			and (
				( p_CpsId is null and CpsId is null )
				or
				( p_Cpsid is not null and c.cpsid = p_Cpsid ) )
			and ( ( p_ItcType != 'I' AND c.acmcode is null )
				or ( c.acmcode || '-' || c.ItmCode in (
					select max(acmcode) || '-' || itmcode
					from   ItemCreditChg
					where  tab_name = decode( p_Credit, 1, 'CREDITCHG', 'ITEMCHG' )
					and    pkgcode = p_PkgCode
					and    acmcode <= p_Acmcode
					and  ( icsdt IS NULL OR icsdt <= v_stntdate )
					and  ( icedt IS NULL OR icedt >= v_stntdate )
					group by itmcode ) ) )
			and ( p_ItmCode is null or ( c.itmCode = p_ItmCode ) )
			and ( c.icsdt IS NULL OR c.icsdt <= v_stntdate )
			and ( c.icedt IS NULL OR c.icedt >= v_stntdate )
		) b on a.pkgcode = b.pkgcode and a.itmcode = b.itmcode;

		IF v_Count > 0 THEN
			OPEN c_out FOR
				select a.itmcode, a.pkgcode, acmcode, Itctype, ItcAmt1, ItcAmt2,
					itcamt3, itcamt4, cpsid, cpspct,
					itmname, itmcname, itmcat, itmtype, itmrlvl
				from
				(
					select c.pkgcode, c.itmcode,  -- key
						c.acmcode, c.Itctype, c.ItcAmt1, c.ItcAmt2,
						i.ItmName , i.ItmCName, i.ItmCat, i.ItmType, nvl(p.pkgrLvl, i.itmrLvl) as itmrlvl
					from  ItemCreditChg c, item i, ItemCreditPkg p
					where c.tab_name = decode( p_Credit, 1, 'CREDITCHG', 'ITEMCHG' )
					and   p.tab_name = decode( p_Credit, 1, 'CREDITPKG', 'PACKAGE' )
					and   c.pkgcode = p_PkgCode and c.itctype = p_ItcType
					and   c.itmcode = i.itmcode
					and   c.pkgcode = p.pkgcode
					and   c.cpsid is null
					and ( ( p_ItcType != 'I' AND c.acmcode is null )
						or ( c.acmcode || '-' || c.ItmCode in (
							select max(acmcode) || '-' || itmcode
							from   ItemCreditChg
							where  tab_name = decode( p_Credit, 1, 'CREDITCHG', 'ITEMCHG' )
							and    pkgcode = p_PkgCode
							and    acmcode <= p_Acmcode
							and    cpsid is null
							and  ( icsdt IS NULL OR icsdt <= v_stntdate )
							and  ( icedt IS NULL OR icedt >= v_stntdate )
							group by itmcode ) ) )
					and ( p_ItmCode is null or ( i.itmCode = p_ItmCode and CpsId is null ) )
					and ( c.icsdt IS NULL OR c.icsdt <= v_stntdate )
					and ( c.icedt IS NULL OR c.icedt >= v_stntdate )
				) a
				left outer join
				(
					select c.pkgcode, c.itmcode,   -- key
						c.ItcAmt1 as ItcAmt3, c.ItcAmt2 as ItcAmt4, c.cpsid, c.cpspct
					from  ItemCreditChg c
					where c.tab_name = decode( p_Credit, 1, 'CREDITCHG', 'ITEMCHG' )
					and   c.pkgcode = p_PkgCode and c.itctype = p_ItcType
					and (
						( p_CpsId is null and CpsId is null )
						or
						( p_Cpsid is not null and c.cpsid = p_Cpsid ) )
					and ( ( p_ItcType != 'I' AND c.acmcode is null )
						or ( c.acmcode || '-' || c.ItmCode in (
							select max(acmcode) || '-' || itmcode
							from   ItemCreditChg
							where  tab_name = decode( p_Credit, 1, 'CREDITCHG', 'ITEMCHG' )
							and    pkgcode = p_PkgCode
							and    acmcode <= p_Acmcode
							and  ( icsdt IS NULL OR icsdt <= v_stntdate )
							and  ( icedt IS NULL OR icedt >= v_stntdate )
							group by itmcode ) ) )
					and ( p_ItmCode is null or ( c.itmCode = p_ItmCode ) )
					and ( c.icsdt IS NULL OR c.icsdt <= v_stntdate )
					and ( c.icedt IS NULL OR c.icedt >= v_stntdate )
				) b on a.pkgcode = b.pkgcode and a.itmcode = b.itmcode
				order by ItmCode ;
		END IF;
	END IF;

	RETURN c_out ;
END ;
/

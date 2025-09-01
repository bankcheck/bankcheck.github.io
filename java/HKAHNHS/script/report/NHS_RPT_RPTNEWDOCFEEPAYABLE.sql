create or replace
FUNCTION "NHS_RPT_RPTNEWDOCFEEPAYABLE"(
	V_DATEEND 	IN VARCHAR2,
    V_SPHID 	IN VARCHAR2)
RETURN TYPES.CURSOR_TYPE AS
  	OUTCUR TYPES.CURSOR_TYPE;
  
	cp_DATEEND	df_chkpt.DATEEND%TYPE;
	cp_SPHID	df_chkpt.SPHID%TYPE;
	cp_STATUS	df_chkpt.STATUS%TYPE;
	cp_NEXTNO	df_chkpt.NEXTNO%TYPE;
	cp_PCYID	df_chkpt.PCYID%TYPE;
	cp_REPORT	df_chkpt.REPORT%TYPE;
	cp_USRID	df_chkpt.USRID%TYPE;
	cp_MACHINE	df_chkpt.MACHINE%TYPE;
Begin
	If V_DATEEND Is Not Null AND V_SPHID IS NULL Then
	  	cp_DATEEND := NULL;
		cp_SPHID := NULL;
  
		OUTCUR := Nhs_Get_Docfee_Chkpt;
		Fetch OUTCUR Into Cp_Dateend, Cp_Sphid, Cp_Status, Cp_Nextno, Cp_Pcyid, Cp_Report, Cp_Usrid, Cp_Machine;
		close OUTCUR;
	ELSE
	  	Cp_Dateend := TO_DATE(V_DATEEND, 'DD/MM/YYYY');
	  	Cp_SPHID := V_SPHID;
	end if;

  OPEN OUTCUR FOR
  	select
		d.doccode, d.docfname, d.docgname, spd.slptype, 'A' as grp, nvl(spd.ctnctype,decode(spd.spdfamt,null,'CASH','Credit Item')) as method,
		case when spd.crarate is null then To_Char(0, '0.99') else To_Char(Spd.Crarate, '0.99') end crarate, sum(spd.spdcamt) as before_com,
		nvl(Sum(Round(spd.spdcamt * (spd.crarate / 100))), 0) As com
		from slppaydtl spd, doctor d
		where (Cp_SPHID is null or sphid = Cp_SPHID)
		and spd.doccode = d.doccode
		and spdsts in ('N','A','R','U')
		group by d.doccode, d.docfname, d.docgname, spd.slptype, spd.ctnctype,
		nvl(spd.ctnctype,decode(spd.spdfamt,null,'CASH','Credit Item')), spd.crarate
	union all
	--Waive
	select
  		d.doccode, d.docfname, d.docgname, tx.slptype, 'B' as grp, 'Deduction(s)' as method,
  		TO_CHAR(to_number(null), '0.99') as crarate, sum(round(dfx_camt)) as before_com, 0 as com
  		from df_sliptx tx, doctor d
  		where tx.grp = 'W' and tx.doccode = d.doccode
  		group by d.doccode, d.docfname, d.docgname, slptype
	union all
	--Basic Salary
	select
  		d.doccode, d.docfname, d.docgname, 'Z' as slptype, 'C' as grp, 'Basic Sal.' as method,
  		TO_CHAR(to_number(null), '0.99') as crarate, round(s.dbsamt) as before_com, 0 as com
  		from doctor d, docbassal s
  		where d.doccode = s.doccode
  		and (
  		(Cp_Dateend between s.dbssdate and s.dbsedate)
  			or (s.dbssdate is null and s.dbsedate is null)
      	)
    order by docfname, docgname, doccode, slptype, grp
    ;
  
  RETURN OUTCUR;
END NHS_RPT_RPTNEWDOCFEEPAYABLE;
/

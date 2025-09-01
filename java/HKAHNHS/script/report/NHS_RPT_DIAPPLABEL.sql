create or replace Function "NHS_RPT_DIAPPLABEL" (
	v_Patno Varchar2,
	v_RID VARCHAR2
)
	return types.cursor_type
as
	outcur types.cursor_type;
	v_Docname VARCHAR2(100);
	v_Admdate VARCHAR2(100);
	v_Regdateinhr VARCHAR2(100);
	v_Regdatehhmm VARCHAR2(100);
	v_doccode VARCHAR2(10);
	v_Regopcat Varchar2(30);
	v_Regtype REG.REGTYPE%TYPE;
	v_Regdate VARCHAR2(40);
	v_countreg NUMBER;
	v_Regid VARCHAR(10);
	v_Ticketno VARCHAR(20);
--	v_NewTicketNo VARCHAR(20);
Begin
	IF v_RID IS NULL THEN
		Select Regid_C Into v_Regid From Patient Where Patno = v_Patno;
	Else
		v_Regid := v_RID;
	END IF;

	Select Regopcat, To_Char(Regdate,'dd/mm/yyyy'), Doccode, Ticketno,Regtype
	INTO   v_Regopcat, v_Regdate, v_doccode, v_Ticketno,v_Regtype
	FROM   reg where regid = v_Regid;

	IF v_Regopcat IS NOT NULL THEN
		select curreg.ptnum into v_countreg
		from
			(Select Row_Number() Over (Order By Regid Asc)As Ptnum,Regid
			FROM reg where regdate >= to_date(v_Regdate,'dd/mm/yyyy')
			AND regdate < to_date(v_Regdate,'dd/mm/yyyy')+1 and doccode = v_doccode
			AND regsts = 'N' and regopcat= v_Regopcat) curreg
		Where Curreg.Regid = v_Regid;
	END IF;

	SELECT
		D.Docfname||' '||D.Docgname,To_Char(T1.Regdate,'dd/mm/yyyy HH24:MI'), TO_CHAR(T1.Regdate,'HH24:MI'),
		(SELECT to_char(Bkgsdate,'dd/mm/yyyy HH24:MI') From Booking B Where B.Bkgid = bkid)
		INTO v_docname, v_Regdateinhr, v_Regdatehhmm, v_Admdate
	FROM
		(SELECT bkgid AS bkid, Doccode, Regdate
		From Reg
		WHERE Regid = v_RID) T1, Doctor D
	WHERE d.doccode=t1.doccode;

	OPEN outcur FOR
	    select
		GET_REAL_STECODE(), p.patno, p.patfname||' '||p.patgname AS patname,
		P.Patcname, To_Char(P.Patbdate,'dd/mm/yyyy'),
		P.Patsex, V_Docname As Docname,
		Decode(v_Regtype, 'I', v_Regdateinhr,
		Decode(v_Regopcat, 'U', v_Regdateinhr, 'P', v_Regdateinhr, 'W', v_Regdateinhr, v_Regdatehhmm)) As Regdate,
		Decode(v_Regtype, 'I', v_Regdate, v_Admdate) AS admdate, v_Regopcat AS regcat, v_countReg AS regcount,
		v_Ticketno As Ticketno,
		v_Regtype AS regType
	    From Patient P
	    Where p.patno= v_Patno;

	Return Outcur;
end NHS_RPT_DIAPPLABEL;
/

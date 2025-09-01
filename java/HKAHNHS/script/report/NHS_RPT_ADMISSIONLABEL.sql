create or replace FUNCTION "NHS_RPT_ADMISSIONLABEL" (
	v_PATNO VARCHAR2
)
	RETURN TYPES.CURSOR_TYPE
AS
	OUTCUR TYPES.CURSOR_TYPE;
	v_docname VARCHAR2(100);
	v_admdate VARCHAR2(100);
	v_regdateinhr VARCHAR2(100);
	v_regdatehhmm VARCHAR2(100);
	v_doccode VARCHAR2(10);
	v_regopcat VARCHAR2(30);
	v_regdate VARCHAR2(40);
	v_countreg NUMBER;
	v_regid VARCHAR2(10);
	v_ticketNo VARCHAR2(20);
	v_lblrmk VARCHAR2(30);
	v_bkgid NUMBER;
	v_bkadesc VARCHAR2(100);
	v_count NUMBER;
BEGIN
	BEGIN
		SELECT Regid_C INTO v_regid FROM Patient WHERE Patno = v_PATNO;
	EXCEPTION
		WHEN OTHERS THEN
		v_regid := NULL;
	END;

	BEGIN
		SELECT REGOPCAT, TO_CHAR(REGDATE, 'dd/mm/yyyy'), DOCCODE, ticketno, bkgid
		INTO   v_regopcat, v_regdate, v_doccode, v_ticketNo, v_bkgid
		FROM   reg WHERE regid = v_regid;
	EXCEPTION
	WHEN OTHERS THEN
		v_regopcat := NULL;
		v_regdate := NULL;
		v_doccode := NULL;
		v_ticketNo := NULL;
	END;

	BEGIN
		SELECT curreg.ptnum
		INTO v_countreg
		FROM
			(SELECT row_number() over (order by regid asc) as ptnum, regid
			FROM reg where regdate >= TO_DATE(v_regdate, 'dd/mm/yyyy')
			AND regdate < TO_DATE(v_regdate, 'dd/mm/yyyy') + 1 and doccode = v_doccode
			AND regsts = 'N' and regopcat = v_regopcat) curreg
		WHERE curreg.regid = v_regid;
	EXCEPTION
	WHEN OTHERS THEN
		v_countreg := 0;
	END;

	BEGIN
		SELECT
			D.Docfname || ' ' || D.Docgname, TO_CHAR(T1.Regdate, 'dd/mm/yyyy HH24:MI'), TO_CHAR(T1.Regdate, 'HH24:MI'),
			(SELECT TO_CHAR(Bkgsdate, 'dd/mm/yyyy HH24:MI') From Booking B Where B.Bkgid = bkid),
			(SELECT lblrmk from booking_extra be where be.bkgid = bkid)
		INTO v_docname, v_regdateinhr, v_regdatehhmm, v_admdate, v_lblrmk
		FROM
			(SELECT bkgid AS bkid, Doccode, Regdate
			FROM Reg
			WHERE Regid =(Select Regid_C From Patient Where Patno = v_PATNO)) T1, Doctor D
		WHERE d.doccode = t1.doccode;
	EXCEPTION
	WHEN OTHERS THEN
		v_docname := NULL;
		v_regdateinhr := NULL;
		v_regdatehhmm := NULL;
		v_admdate := NULL;
		v_lblrmk := NULL;
	END;

	IF v_bkgid IS NOT NULL THEN
		BEGIN
			SELECT a.bkadesc INTO v_bkadesc FROM BOOKING b, BOOKINGALERT a
			WHERE  b.bkgid = v_bkgid
			AND    b.bkgalert = a.bkaid
			AND   (a.BKAQUOTAD = -1 OR a.BKAQUOTAM = -1 OR a.BKAQUOTAY = -1);

			IF v_bkadesc IS NOT NULL THEN
				v_count := instr(v_bkadesc, '(', 1, 1);
				IF v_count > 0 THEN
					v_bkadesc := substr(v_bkadesc, 1, v_count - 1);
				END IF;
			END IF;
		EXCEPTION
		WHEN OTHERS THEN
			v_bkadesc := NULL;
		END;
	END IF;

	OPEN OUTCUR FOR
		select
			decode(UPPER(GET_REAL_STECODE()), 'HKAH', 'HKAH - SR', 'TWAH', 'HKAH - TW', UPPER(GET_REAL_STECODE())) AS stecode, p.patno, p.patfname || ' ' || p.patgname AS patname,
			P.Patcname, TO_CHAR(P.Patbdate, 'dd/mm/yyyy'),
			P.Patsex, v_docname AS Docname,
			decode(v_regopcat, 'U', v_Regdateinhr, 'P', v_Regdateinhr, 'W', v_Regdateinhr, v_regdatehhmm) AS Regdate,
			v_admdate AS admdate, v_regopcat AS regcat, v_countReg AS regcount,
			v_ticketNo AS ticketno,
			v_bkadesc || ' ' || v_lblrmk AS lblrmk
		From  Patient P
		Where p.patno = v_PATNO;

	RETURN OUTCUR;
END NHS_RPT_ADMISSIONLABEL;
/

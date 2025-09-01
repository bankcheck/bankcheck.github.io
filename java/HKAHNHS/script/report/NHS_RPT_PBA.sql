CREATE OR REPLACE FUNCTION "NHS_RPT_PBA" (
	v_PATNO VARCHAR2,
	v_Nooflbl VARCHAR2
)
	RETURN TYPES.CURSOR_TYPE
AS
	OUTCUR TYPES.CURSOR_TYPE;
	v_docname VARCHAR2(100);
	v_admdate VARCHAR2(100);
	v_Regdateinhr VARCHAR2(100);
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
		SELECT drname, regdateinhr, regdatehhmm, admdate, lblrmk
		INTO v_docname, v_Regdateinhr, v_regdatehhmm, v_admdate, v_lblrmk
		FROM
			(SELECT
				D.Docfname || ' ' || D.Docgname AS drname, TO_CHAR(T1.Regdate, 'dd/mm/yyyy HH24:MI') AS regdateinhr,
				TO_CHAR(T1.Regdate,'HH24:MI') AS regdatehhmm, T1.bkid
				FROM
				(SELECT bkgid AS bkid,Doccode, Regdate FROM Reg
				WHERE Regid = (SELECT Regid_C FROM Patient WHERE Patno = v_PATNO)) T1, Doctor D
				WHERE d.doccode = t1.doccode) T2,
				(SELECT b.bkgid, TO_CHAR(b.Bkgsdate, 'dd/mm/yyyy HH24:MI') AS admdate, be.lblrmk
				FROM Booking B, booking_extra be WHERE b.bkgid = be.bkgid(+)) T3
		WHERE T2.bkid = t3.bkgid(+);
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
			AND   (a.BKAQUOTAD = -1 OR a.BKAQUOTAM = -1 OR a.BKAQUOTAY = -1 OR a.bkaid IN ('61', '62'));

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
		SELECT
			decode(UPPER(GET_REAL_STECODE()),'HKAH','HKAH - SR',UPPER(GET_REAL_STECODE())), p.patno, p.patfname || ' ' || p.patgname AS patname,
			P.Patcname, TO_CHAR(P.Patbdate, 'dd/mm/yyyy'),
			P.Patsex, v_Docname AS Docname,
			decode(v_regopcat, 'U', v_Regdateinhr, 'P', v_Regdateinhr, 'W', v_Regdateinhr, v_regdatehhmm) AS Regdate,
			v_admdate AS admdate, v_regopcat AS regcat, v_countReg AS regcount,
			v_ticketNo AS ticketno,
			v_lblrmk || ' ' || v_bkadesc AS lblrmk
		FROM
			Patient P
		Left Join
			(SELECT 1 FROM Dual Connect By Level <= v_Nooflbl) On 1 = 1
		WHERE
			p.patno = v_PATNO;
	return OUTCUR;
END NHS_RPT_PBA;
/

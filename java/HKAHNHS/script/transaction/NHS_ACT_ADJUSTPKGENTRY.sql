CREATE OR REPLACE FUNCTION "NHS_ACT_ADJUSTPKGENTRY" (
	v_action IN VARCHAR2,
	v_slno   IN VARCHAR2,
	v_ptnid  IN VARCHAR2,
	v_amount IN VARCHAR2,
	v_desc   IN VARCHAR2,
	v_cdate  IN VARCHAR2,
	v_tdate  IN VARCHAR2,
	v_usrid  IN VARCHAR2,
	o_errmsg OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER;
	rs_pkgtx  pkgtx%ROWTYPE;
	v_noOfRec NUMBER;
	v_ptnid1  NUMBER;
	v_ptnseq NUMBER;
BEGIN
	SELECT COUNT(1) INTO v_noOfRec FROM pkgtx WHERE ptnid = TO_NUMBER(v_ptnid);
	IF v_action='MOD' THEN
		IF v_noOfRec = 0 THEN
			o_errcode := -1;
			o_errmsg := 'No record found.';
		ELSE
			SELECT * INTO rs_pkgtx FROM pkgtx WHERE ptnid = TO_NUMBER(v_ptnid);
			--pkgtx ptnid
			SELECT seq_pkgtx.NEXTVAL INTO v_ptnid1 FROM DUAL;
			rs_pkgtx.PTNID := v_ptnid1;

			--desc (ck. 20121127)
			IF v_desc IS NULL OR TRIM(v_desc)='' THEN
				--rs_pkgtx.ptndesc := v_ptnseq;
				rs_pkgtx.ptndesc := rs_pkgtx.ptnseq;
			ELSE
				--rs_pkgtx.ptndesc := v_desc || ' ' || v_ptnseq;
				rs_pkgtx.ptndesc := v_desc || ' ' || rs_pkgtx.ptnseq;
			END IF;

			--pkgtx ptnseq
			UPDATE slip SET slppseq = slppseq + 1 WHERE slpno = v_slno;
			SELECT slppseq - 1 INTO v_ptnseq FROM slip WHERE slpno = v_slno;

			rs_pkgtx.ptnseq := v_ptnseq;
			rs_pkgtx.ptnbamt := TO_NUMBER(v_amount);

			-- tx,cr date
			IF v_cdate IS NULL OR TRIM(v_cdate) = '' THEN
				rs_pkgtx.ptncdate := SYSDATE;
			ELSE
				rs_pkgtx.ptncdate := TO_DATE(v_cdate,'dd/mm/yyyy');
			END IF;

			IF v_tdate IS NULL OR TRIM(v_tdate) = '' THEN
				rs_pkgtx.ptntdate := SYSDATE;
			ELSE
				rs_pkgtx.ptntdate := TO_DATE(v_tdate,'dd/mm/yyyy');
			END IF;

			--status
			rs_pkgtx.ptnsts := 'A';
			rs_pkgtx.ptndIFlag:=null;

			-- insert start
			INSERT INTO pkgtx (
				PTNID, PTNSEQ, PTNSTS, PKGCODE, ITMCODE,
				PTNOAMT, PTNBAMT, DOCCODE, ACMCODE, GLCCODE,
				USRID, PTNTDATE, PTNCDATE, PTNRLVL, SLPNO,
				PTNDESC, DSCCODE, ptncpsflag, unit, ptndIFlag,
				irefno
			) VALUES (
				rs_pkgtx.PTNID, rs_pkgtx.PTNSEQ, rs_pkgtx.PTNSTS, rs_pkgtx.PKGCODE, rs_pkgtx.ITMCODE,
				rs_pkgtx.PTNOAMT, rs_pkgtx.PTNBAMT, rs_pkgtx.DOCCODE, rs_pkgtx.ACMCODE, rs_pkgtx.GLCCODE,
				v_usrid, rs_pkgtx.PTNTDATE, rs_pkgtx.PTNCDATE, rs_pkgtx.PTNRLVL, rs_pkgtx.slpno,
				rs_pkgtx.PTNDESC, rs_pkgtx.DSCCODE, rs_pkgtx.ptncpsflag, rs_pkgtx.unit, rs_pkgtx.ptndIFlag,
				rs_pkgtx.irefno);

			o_errcode := 0;
			o_errmsg := 'OK';
		END IF;
	END IF;

	RETURN o_errcode;
END NHS_ACT_ADJUSTPKGENTRY;
/

create or replace FUNCTION Add_Entry(rs_slip    IN SLIP%ROWTYPE,
                                     v_pkgcode  IN VARCHAR2,
                                     v_itmcode  IN VARCHAR2,
                                     v_stat     IN VARCHAR2 := 'N',
                                     v_pkgrlvl  IN NUMBER,
                                     v_doccode  IN VARCHAR2,
                                     v_acmcode  IN VARCHAR2,
                                     v_stntdate IN DATE,
                                     v_amount   IN FLOAT := 0,
                                     v_override IN VARCHAR2 := 'N',
                                     v_ref_no   IN VARCHAR2,
                                     v_cpsid    IN NUMBER,
                                     o_stnid    OUT NUMBER,
                                     o_stnseq   OUT NUMBER,
                                     o_errmsg   OUT VARCHAR2)
    RETURN BOOLEAN AS
    v_stnid      SLIPTX.stnid%TYPE;
    v_slpseq     SLIPTX.stnseq%TYPE;
    v_acmcode2   VARCHAR2(1);
    v_acmcode3   VARCHAR2(1);
    v_acmcode4   ItemChg.AcmCode%TYPE;
--   v_stncpsflag VARCHAR2(1);
    v_pcyid      SLIPTX.pcyid%TYPE;
    rs_item      ITEM%ROWTYPE;
    rs_itemchg   ITEMCHG%ROWTYPE;
    rs_sliptx    SLIPTX%ROWTYPE;
    v_transver   SLIPTX.transver%TYPE;
-- Start SIR_HAT_2008061101, Alex KH Lee, 2008/06/12
    v_bedcode    varchar2(10);
    v_dptcode    varchar2(10);
-- End SIR_HAT_2008061101, Alex KH Lee, 2008/06/12
    v_count      NUMBER;
BEGIN
    -- Start SIR_HAT_2008012501, Alex KH Lee, 2008/04/02
    v_acmcode3 := null;
    -- End SIR_HAT_2008012501, Alex KH Lee, 2008/04/02

    -- dbms_output.put_line ('ADD_ENTRY');
    -- STNID
    SELECT seq_sliptx.NEXTVAL INTO v_stnid FROM dual;
    rs_sliptx.STNID := v_stnid;
    -- STNSEQ
    rs_sliptx.SLPNO := rs_slip.SLPNO;
    UPDATE SLIP SET slpseq = slpseq + 1 WHERE slpno = rs_slip.SLPNO;
    SELECT slpseq - 1 INTO v_slpseq FROM SLIP WHERE slpno = rs_slip.SLPNO;
    rs_sliptx.STNSEQ := v_slpseq;
    -- STNSTS
    rs_sliptx.STNSTS := 'N';
    -- GET_ACMCODE
    IF rs_slip.SLPTYPE = 'I' THEN
        -- modified by Ricky So, to ignore the passed in v_acmcode
        --v_acmcode2 := Get_Acmcode(v_acmcode,v_itmcode,v_pkgcode,NULL);
        BEGIN

-- Start SIR_HAT_2008061101, Alex KH Lee, 2008/06/12
            SELECT inpat.acmcode, inpat.bedcode
            INTO v_acmcode3, v_bedcode
            FROM inpat
            WHERE inpid IN
                  (SELECT inpid FROM reg WHERE regid = rs_slip.regid);
--            SELECT inpat.acmcode
--            INTO v_acmcode3
--            FROM inpat
--            WHERE inpid IN
--                  (SELECT inpid FROM reg WHERE regid = rs_slip.regid);
-- End SIR_HAT_2008061101, Alex KH Lee, 2008/06/12

            IF SQL%ROWCOUNT = 1 THEN
               v_acmcode2 := Get_Acmcode(v_acmcode3,
                                         v_itmcode,
                                         v_pkgcode,
                                         NULL);
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN

-- Start SIR_HAT_2008061101, Alex KH Lee, 2008/06/12
               begin
                    v_acmcode2 := NULL;
                    v_bedcode := null;
               end;
--                v_acmcode2 := NULL;
-- End SIR_HAT_2008061101, Alex KH Lee, 2008/06/12

        END;
    ELSE
        v_acmcode2 := NULL;
    END IF;
    -- PKGCODE
    rs_sliptx.PKGCODE := v_pkgcode;
    rs_sliptx.ITMCODE := v_itmcode;
    SELECT * INTO rs_item FROM ITEM WHERE itmcode = v_itmcode;

    SELECT *
    INTO rs_itemchg
    FROM ITEMCHG
    WHERE itmcode = v_itmcode AND
          itctype = rs_slip.SLPTYPE AND
          NVL(pkgcode, ' ') = NVL(v_pkgcode, ' ') AND
          NVL(acmcode, ' ') = NVL(v_acmcode2, ' ') AND
          cpsid IS NULL;

    -- ITMTYPE
    rs_sliptx.ITMTYPE := rs_item.ITMTYPE;
    -- STNDISC
    rs_sliptx.STNDISC := 0;
    IF rs_item.ITMTYPE = 'H' THEN
        rs_sliptx.STNDISC := rs_slip.SLPHDISC;
    END IF;
    IF rs_item.ITMTYPE = 'D' THEN
        rs_sliptx.STNDISC := rs_slip.SLPDDISC;
    END IF;
    IF rs_item.ITMTYPE = 'S' THEN
        rs_sliptx.STNDISC := rs_slip.SLPSDISC;
    END IF;
    -- STNOAMT, STNBAMT
    IF v_stat = 'Y' THEN
        rs_sliptx.STNOAMT    := rs_itemchg.ITCAMT2;
        rs_sliptx.STNBAMT    := rs_itemchg.ITCAMT2;
        rs_sliptx.STNCPSFLAG := 'S'; -- Normal Stat
    ELSE
        rs_sliptx.STNOAMT    := rs_itemchg.ITCAMT1;
        rs_sliptx.STNBAMT    := rs_itemchg.ITCAMT1;
        rs_sliptx.STNCPSFLAG := NULL; -- Normal
    END IF;
    -- GLCCODE
    rs_sliptx.GLCCODE := rs_itemchg.GLCCODE;

-- Start SIR_HAT_2008061101, Alex KH Lee, 2008/06/12
    IF rs_slip.SLPTYPE = 'I' and length(rs_itemchg.glccode) <=4 THEN
        BEGIN
            SELECT trim(c.dptcode)
              INTO v_dptcode
              FROM bed a inner join
                   room b on a.romcode=b.romcode inner join
                   ward c on b.wrdcode=c.wrdcode
             WHERE a.bedcode = v_bedcode;
            IF SQL%ROWCOUNT = 1 THEN
                 rs_sliptx.GLCCODE := v_dptcode || rs_itemchg.GLCCODE;
            END IF;
            EXCEPTION
            WHEN NO_DATA_FOUND THEN
               v_dptcode := NULL;
        END;
    END IF;
-- End SIR_HAT_2008061101, Alex KH Lee, 2008/06/12

    IF v_cpsid IS NOT NULL THEN
        BEGIN
            -- remarked by Ricky to ignore the acmcode passed in
            -- v_acmcode2 := Get_Acmcode(v_acmcode,v_itmcode,v_pkgcode,v_cpsid);
            SELECT inpat.acmcode
            INTO v_acmcode3
            FROM inpat
            WHERE inpid IN
                  (SELECT inpid FROM reg WHERE regid = rs_slip.regid);
            IF SQL%ROWCOUNT = 1 THEN
               v_acmcode2 := Get_Acmcode(v_acmcode3,
                                         v_itmcode,
                                         v_pkgcode,
                                         v_cpsid);
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_acmcode2 := v_acmcode2;
        END;
        BEGIN
            SELECT *
            INTO rs_itemchg
            FROM ITEMCHG
            WHERE itmcode = v_itmcode AND
                  NVL(pkgcode, ' ') = NVL(v_pkgcode, ' ') AND
                  NVL(acmcode, ' ') = NVL(v_acmcode2, ' ') AND
                  itctype = rs_slip.SLPTYPE AND
                  cpsid = v_cpsid;
            IF SQL%ROWCOUNT = 1 THEN
                IF rs_itemchg.CPSPCT IS NULL THEN
                    IF v_stat = 'Y' THEN
                        rs_sliptx.STNBAMT    := rs_itemchg.ITCAMT2;
                        rs_sliptx.STNCPSFLAG := 'T'; -- CPS Stat Fix
                    ELSE
                        rs_sliptx.STNBAMT    := rs_itemchg.ITCAMT1;
                        rs_sliptx.STNCPSFLAG := 'F'; -- CPS Fix
                    END IF;
                ELSE
                    rs_sliptx.STNDISC := rs_itemchg.CPSPCT;
                    IF v_stat = 'Y' THEN
                        rs_sliptx.STNCPSFLAG := 'U'; -- CPS Stat %
                    ELSE
                        rs_sliptx.STNCPSFLAG := 'P'; -- CPS %
                    END IF;
                END IF;
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                dbms_output.put_line('NO CPS FOUND.');
        END;
    END IF;

    -- special handle for urgent care
    IF rs_slip.SLPTYPE = 'O' THEN
        v_acmcode4 := 'ZZ' || rs_slip.RegOPCat;
        v_count := 0;
        IF v_cpsid IS NOT NULL THEN
            SELECT COUNT(1) INTO v_count
                  FROM ITEMCHG
                 WHERE itmcode = v_itmcode AND
                       NVL(pkgcode, ' ') = NVL(v_pkgcode, ' ') AND
                       NVL(acmcode, ' ') = NVL(v_acmcode4, ' ') AND
                       itctype = rs_slip.SLPTYPE AND
                       cpsid = v_cpsid;
            IF v_count = 1 THEN
                rs_sliptx.STNDISC := 0;
                BEGIN
                    SELECT *
                      INTO rs_itemchg
                      FROM ITEMCHG
                     WHERE itmcode = v_itmcode AND
                           NVL(pkgcode, ' ') = NVL(v_pkgcode, ' ') AND
                           NVL(acmcode, ' ') = NVL(v_acmcode4, ' ') AND
                           itctype = rs_slip.SLPTYPE AND
                           cpsid = v_cpsid;
                    IF SQL%ROWCOUNT = 1 THEN
                        IF rs_itemchg.CPSPCT IS NULL THEN
                            IF v_stat = 'Y' THEN
                                rs_sliptx.STNBAMT    := rs_itemchg.ITCAMT2;
                                rs_sliptx.STNCPSFLAG := 'T'; -- CPS Stat Fix
                            ELSE
                                rs_sliptx.STNBAMT    := rs_itemchg.ITCAMT1;
                                rs_sliptx.STNCPSFLAG := 'F'; -- CPS Fix
                            END IF;
                        ELSE
                            rs_sliptx.STNDISC := rs_itemchg.CPSPCT;
                            IF v_stat = 'Y' THEN
                                rs_sliptx.STNCPSFLAG := 'U'; -- CPS Stat %
                            ELSE
                                rs_sliptx.STNCPSFLAG := 'P'; -- CPS %
                            END IF;
                        END IF;
                    END IF;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        dbms_output.put_line('NO CPS FOUND.');
                END;
            END IF;
        END IF;

        IF v_count = 0 THEN
            SELECT COUNT(1) INTO v_count
                  FROM ITEMCHG
                 WHERE itmcode = v_itmcode AND
                       NVL(pkgcode, ' ') = NVL(v_pkgcode, ' ') AND
                       NVL(acmcode, ' ') = NVL(v_acmcode4, ' ') AND
                       itctype = rs_slip.SLPTYPE AND
                       cpsid IS NULL;
            IF v_count = 1 THEN
                rs_sliptx.STNDISC := 0;
                BEGIN
                    SELECT *
                      INTO rs_itemchg
                      FROM ITEMCHG
                     WHERE itmcode = v_itmcode AND
                           NVL(pkgcode, ' ') = NVL(v_pkgcode, ' ') AND
                           NVL(acmcode, ' ') = NVL(v_acmcode4, ' ') AND
                           itctype = rs_slip.SLPTYPE AND
                           cpsid IS NULL;
                    IF SQL%ROWCOUNT = 1 THEN
                        IF v_stat = 'Y' THEN
                            rs_sliptx.STNBAMT    := rs_itemchg.ITCAMT2;
                            rs_sliptx.STNCPSFLAG := 'S'; -- Normal Stat
                        ELSE
                            rs_sliptx.STNBAMT    := rs_itemchg.ITCAMT1;
                            rs_sliptx.STNCPSFLAG := NULL; -- Normal
                        END IF;
                    END IF;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        dbms_output.put_line('NO CPS FOUND.');
                END;
            END IF;
        END IF;
    END IF;

    -- STNBAMT
    IF rs_sliptx.STNCPSFLAG IS NULL OR
       rs_sliptx.STNCPSFLAG IN ('S', 'U', 'P') THEN
        IF v_override = 'Y' THEN
            rs_sliptx.STNBAMT := v_amount;
        END IF;
    END IF;

    -- STNNAMT
    rs_sliptx.STNNAMT := ROUND(rs_sliptx.STNBAMT *
                               (1 - rs_sliptx.STNDISC / 100));
    -- DOCCODE
    -- modified by Ricky So on 2005.11.11
    --rs_sliptx.DOCCODE = v_doccode;
    rs_sliptx.DOCCODE := rs_slip.doccode;

    -- ACMCODE
    -- Start SIR_HAT_2008012501, Alex KH Lee, 2008/04/02
    rs_sliptx.ACMCODE := v_acmcode3;
    --rs_sliptx.ACMCODE := v_acmcode2;
    -- End SIR_HAT_2008012501, Alex KH Lee, 2008/04/02

    -- USRID
    rs_sliptx.USRID := Get_Current_Usrid();
    -- STNTDATE
    rs_sliptx.STNTDATE := v_stntdate;
    -- STNCDATE
    rs_sliptx.STNCDATE := SYSDATE;
    -- STNDESC
    rs_sliptx.STNDESC := rs_item.ITMNAME;
    IF rs_item.ITMCNAME IS NOT NULL THEN
        rs_sliptx.STNDESC := rs_sliptx.STNDESC || ' ' || rs_item.ITMCNAME;
    END IF;
    IF v_ref_no IS NOT NULL THEN
        rs_sliptx.STNDESC := rs_sliptx.STNDESC || ' - ' || v_ref_no;
    END IF;
    -- STNRLVL
    IF v_pkgrlvl IS NULL THEN
        rs_sliptx.STNRLVL := rs_item.ITMRLVL;
    ELSE
        rs_sliptx.STNRLVL := v_pkgrlvl;
    END IF;
    -- STNTYPE
    rs_sliptx.STNTYPE := 'D';
    -- DSCCODE
    rs_sliptx.DSCCODE := rs_item.DSCCODE;
    -- PCYID
    BEGIN
        ---start Modified on 2005/09/20
        --     SELECT s.pcyid INTO v_pcyid
        --     FROM SLIP s, ITEMSCM i
        --     WHERE
        --     s.slpno = rs_slip.SLPNO
        --     AND s.slptype = i.itctype
        --     AND s.pcyid = i.pcyid
        --     AND itmcode = v_itmcode;
        SELECT s.pcyid
        INTO v_pcyid
        FROM SLIP s, CMCITM CD, CMCFORM CF
        WHERE s.slpno = rs_slip.SLPNO AND
              s.slptype = CD.itctype AND
              s.pcyid = CD.pcyid AND
              CD.itmcode = v_itmcode AND
              CD.APPCONTR = CF.CID AND
              (v_stntdate between cd.eff_dt_frm and nvl(cd.eff_dt_to, to_date('31/12/2999', 'dd/mm/yyyy')));
         --end Modified on 2005/09/20
        IF SQL%ROWCOUNT = 1 THEN
            rs_sliptx.PCYID := v_pcyid;
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            BEGIN
                SELECT s.pcyid
                INTO v_pcyid
                FROM SLIP s, CMCFORM CF, CMCDPS CP, ITEM i
                WHERE s.slpno = rs_slip.SLPNO AND
                      s.slptype = CP.itctype AND
                      s.pcyid = CP.pcyid AND
                      i.itmcode = v_itmcode AND
                      i.dsccode = CP.dsccode AND
                      CP.APPCONTR = CF.CID AND
                      (v_stntdate between cp.eff_dt_frm and nvl(cp.eff_dt_to, to_date('31/12/2999', 'dd/mm/yyyy')));
                IF SQL%ROWCOUNT = 1 THEN
                    rs_sliptx.PCYID := v_pcyid;
                END IF;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    rs_sliptx.PCYID := NULL;
                    dbms_output.put_line('NO PCYID.');
            END;
    END;
    -- transver
    BEGIN
        SELECT MAX(param1)
        INTO   v_transver
        FROM   sysparam
        WHERE  upper(parcde) = 'MULLANGVER';

        rs_sliptx.transver := v_transver ;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
             rs_sliptx.transver := NULL;
    END;

    -- Insert SQL
    INSERT INTO SLIPTX
        (STNID,
         SLPNO,
         STNSEQ,
         STNSTS,
         PKGCODE,
         ITMCODE,
         ITMTYPE,
         STNDISC,
         STNOAMT,
         STNBAMT,
         STNNAMT,
         DOCCODE,
         ACMCODE,
         GLCCODE,
         USRID,
         STNTDATE,
         STNCDATE,
         STNADOC,
         STNDESC,
         STNRLVL,
         STNTYPE,
         STNXREF,
         DSCCODE,
         DIXREF,
         STNDIDOC,
         STNCPSFLAG,
         PCYID,
         TRANSVER,
         STNDESC1,
         unit)
    VALUES
        (rs_sliptx.STNID,
         rs_sliptx.SLPNO,
         rs_sliptx.STNSEQ,
         rs_sliptx.STNSTS,
         rs_sliptx.PKGCODE,
         rs_sliptx.ITMCODE,
         rs_sliptx.ITMTYPE,
         rs_sliptx.STNDISC,
         rs_sliptx.STNOAMT,
         rs_sliptx.STNBAMT,
         rs_sliptx.STNNAMT,
         rs_sliptx.DOCCODE,
         rs_sliptx.ACMCODE,
         rs_sliptx.GLCCODE,
         rs_sliptx.USRID,
         rs_sliptx.STNTDATE,
         rs_sliptx.STNCDATE,
         NULL,
         rs_sliptx.STNDESC,
         rs_sliptx.STNRLVL,
         rs_sliptx.STNTYPE,
         NULL,
         rs_sliptx.DSCCODE,
         rs_sliptx.STNID,
         NULL,
         rs_sliptx.STNCPSFLAG,
         rs_sliptx.PCYID,
         rs_sliptx.transver,
         NULL,
         1);

    o_stnid  := rs_sliptx.STNID;
    o_stnseq := rs_sliptx.STNSEQ;
    RETURN TRUE;
EXCEPTION
    WHEN OTHERS THEN
        o_errmsg := SQLERRM;
        RETURN FALSE;
END;
/

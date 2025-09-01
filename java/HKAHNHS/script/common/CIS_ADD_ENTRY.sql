create or replace function CIS_ADD_ENTRY
-- ******************************COPYRIGHT NOTICE*******************************
-- All rights reserved.  This material is confidential and proprietary to Excel
-- Technology International (Hong Kong) Limited and no part of this material
-- should be reproduced, published in any form by any means, electronic or
-- mechanical including photocopy or any information storage or retrieval system
-- nor should the material be disclosed to third parties without the express
-- written authorization of Excel Technology International (Hong Kong) Limited.

-- ****************************PROGRAM DESCRIPTION*******************************
-- Program Name   : CIS_ADD_ENTRY
-- Nature         : Application
-- Description    : Interface Program for Adding Slip Transaction
-- Creation Date  : 2008/06/23
-- Creator        : Alex KH Lee
-- ****************************MODIFICATION HISTORY******************************
-- Modify Date    : 2008/12/24
-- Modifier       : DaiZhaoBing
-- CR / SIR No.   : SIR_HAT_2008121101
-- Description    : Add Param: Unit, iRefNo
-- ****************************MODIFICATION HISTORY******************************
-- Modify Date    : 2009/07/09
-- Modifier       : ck
-- Description    : bug-fix, Assign docCode
-- ****************************MODIFICATION HISTORY******************************
-- Modify Date    : 2019/05/03
-- Modifier       : Johnny Ho
-- Description    : Add Urgent Care Logic
-- ******************************************************************************
    (
    rs_slip   IN  slip % rowtype,  v_pkgcode  IN  VARCHAR2, v_itmcode IN  VARCHAR2,
    v_stat    IN  VARCHAR2 := 'N', v_pkgrlvl  IN  NUMBER,   v_doccode IN  VARCHAR2,
    v_acmcode IN  VARCHAR2,        v_stntdate IN  DATE,     v_amount  IN  FLOAT := 0,
    v_qty     IN  INTEGER := 1,    v_override IN  VARCHAR2 := 'N',
    v_ref_no  IN  VARCHAR2,        v_cpsid    IN  NUMBER,
    o_stnid   OUT NUMBER,          o_stnseq   OUT NUMBER,   o_errmsg  OUT VARCHAR2
    ) return boolean is

    v_stnid      SLIPTX.stnid%TYPE;
    v_slpseq     SLIPTX.stnseq%TYPE;
    v_acmcode2   VARCHAR2(1);
    v_acmcode3   VARCHAR2(1);
    v_acmcode4   ItemChg.AcmCode%TYPE;
    v_pcyid      SLIPTX.pcyid%TYPE;
    rs_item      ITEM%ROWTYPE;
    rs_itemchg   ITEMCHG%ROWTYPE;
    rs_sliptx    SLIPTX%ROWTYPE;
    v_transver   SLIPTX.transver%TYPE;
    v_bedcode    varchar2(10);
    v_dptcode    varchar2(10);
    v_count      NUMBER;
begin
    v_acmcode3 := null;

--dbms_output.put_line ('Start ADD_ENTRY');

-- Comment: Get STNID
    SELECT seq_sliptx.NEXTVAL INTO v_stnid FROM dual;
    rs_sliptx.STNID := v_stnid;

-- Comment: Assign SlipTx.SlipNo and SlipTx.STNSEQ
    rs_sliptx.SLPNO := rs_slip.SLPNO;
    UPDATE SLIP SET slpseq = slpseq + 1 WHERE slpno = rs_slip.SLPNO;
    SELECT slpseq - 1 INTO v_slpseq FROM SLIP WHERE slpno = rs_slip.SLPNO;
    rs_sliptx.STNSEQ := v_slpseq;

-- Comment: Assign SlipTx.STNSTS
    rs_sliptx.STNSTS := 'N';

-- Comment: Get ACMCODE
    IF rs_slip.SLPTYPE = 'I' THEN
        BEGIN
            SELECT inpat.acmcode, inpat.bedcode
              INTO v_acmcode3, v_bedcode
              FROM inpat
             WHERE inpid IN
                   (SELECT inpid FROM reg WHERE regid = rs_slip.regid);

            IF SQL%ROWCOUNT = 1 THEN
-- Comment: Get ACMCODE Using Function Get_AcmCode
               v_acmcode2 := Get_Acmcode(v_acmcode3,
                                         v_itmcode,
                                         v_pkgcode,
                                         NULL);
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
               begin
                   v_acmcode2 := NULL;
                   v_bedcode := null;
               end;
        END;
    ELSE
        v_acmcode2 := NULL;
    END IF;

-- Comment: Assign SlipTx.PKGCODE and SlipTx.ITMCODE
    rs_sliptx.PKGCODE := v_pkgcode;
    rs_sliptx.ITMCODE := v_itmcode;
    SELECT * INTO rs_item FROM ITEM WHERE itmcode = v_itmcode;

    SELECT *
      INTO rs_itemchg
      FROM ITEMCHG
     WHERE itmcode = v_itmcode
       AND itctype = rs_slip.SLPTYPE
       AND NVL(pkgcode, ' ') = NVL(v_pkgcode, ' ')
       AND NVL(acmcode, ' ') = NVL(v_acmcode2, ' ')
       AND cpsid IS NULL;

-- Comment: Assign SlipTx.ITMTYPE
    rs_sliptx.ITMTYPE := rs_item.ITMTYPE;

-- Comment: Assign SlipTx.STNDISC
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

-- Comment: Assign SlipTx.STNOAMT and SlipTx.STNBAMT
    IF v_stat = 'Y' THEN
        rs_sliptx.STNOAMT    := rs_itemchg.ITCAMT2;
        rs_sliptx.STNBAMT    := rs_itemchg.ITCAMT2;
        rs_sliptx.STNCPSFLAG := 'S'; -- Normal Stat
    ELSE
        rs_sliptx.STNOAMT    := rs_itemchg.ITCAMT1;
        rs_sliptx.STNBAMT    := rs_itemchg.ITCAMT1;
        rs_sliptx.STNCPSFLAG := NULL; -- Normal
    END IF;

-- Comment: Assign SlipTx.GLCCODE
    rs_sliptx.GLCCODE := rs_itemchg.GLCCODE;

-- Comment: Build the Complete GLCCODE
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

    IF v_cpsid IS NOT NULL THEN
        BEGIN
            SELECT inpat.acmcode
              INTO v_acmcode3
              FROM inpat
             WHERE inpid IN
                   (SELECT inpid FROM reg WHERE regid = rs_slip.regid);
            IF SQL%ROWCOUNT = 1 THEN
-- Comment: Get ACMCODE Using Function Get_AcmCode
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

-- Comment: Assign SlipTx.STNBAMT
    IF rs_sliptx.STNCPSFLAG IS NULL OR
       rs_sliptx.STNCPSFLAG IN ('S', 'U', 'P') THEN
        IF v_override = 'Y' THEN
            rs_sliptx.STNBAMT := v_amount;
        END IF;
    END IF;

-- Comment: Assign SlipTx.STNNAMT
    rs_sliptx.STNNAMT := ROUND(rs_sliptx.STNBAMT *
                               (1 - rs_sliptx.STNDISC / 100));

-- Comment: Assign SlipTx.DOCCODE
--[20090709] ck. assign doc code
  --rs_sliptx.DOCCODE := rs_slip.doccode;
    rs_sliptx.DOCCODE := v_doccode; -- rs_slip.doccode;
--[20090709] end

-- Comment: Assign SlipTx.ACMCODE
    rs_sliptx.ACMCODE := v_acmcode3;

-- Comment: Assign SlipTx.USRID
    rs_sliptx.USRID := Get_Current_Usrid();

-- Comment: Assign SlipTx.STNTDATE
    rs_sliptx.STNTDATE := v_stntdate;

-- Comment: Assign SlipTx.STNCDATE
    rs_sliptx.STNCDATE := SYSDATE;

-- Comment: Assign SlipTx.STNDESC
    rs_sliptx.STNDESC := rs_item.ITMNAME;
    IF rs_item.ITMCNAME IS NOT NULL THEN
        rs_sliptx.STNDESC := rs_sliptx.STNDESC || ' ' || rs_item.ITMCNAME;
    END IF;

-- Start SIR_HAT_2008121101, DaiZhaoBing, 2008/12/24
/*  IF v_ref_no IS NOT NULL THEN
        rs_sliptx.STNDESC := rs_sliptx.STNDESC || ' - ' || v_ref_no;
    END IF;
*/
-- End SIR_HAT_2008121101, DaiZhaoBing, 2008/12/24

-- Comment: Assign SlipTx.STNRLVL
    IF v_pkgrlvl IS NULL THEN
        rs_sliptx.STNRLVL := rs_item.ITMRLVL;
    ELSE
        rs_sliptx.STNRLVL := v_pkgrlvl;
    END IF;

-- Comment: Assign SlipTx.STNTYPE
    rs_sliptx.STNTYPE := 'D';

-- Comment: Assign SlipTx.DSCCODE
    rs_sliptx.DSCCODE := rs_item.DSCCODE;

-- Comment: Assign SlipTx.PCYID
    BEGIN
        SELECT s.pcyid
          INTO v_pcyid
          FROM SLIP s, CMCITM CD, CMCFORM CF
         WHERE s.slpno = rs_slip.SLPNO
           AND s.slptype = CD.itctype
           AND s.pcyid = CD.pcyid
           AND CD.itmcode = v_itmcode
           AND CD.APPCONTR = CF.CID
           AND (v_stntdate between cd.eff_dt_frm and
                                   nvl(cd.eff_dt_to, to_date('31/12/2999', 'dd/mm/yyyy')));
        IF SQL%ROWCOUNT = 1 THEN
            rs_sliptx.PCYID := v_pcyid;
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            BEGIN
                SELECT s.pcyid
                  INTO v_pcyid
                  FROM SLIP s, CMCFORM CF, CMCDPS CP, ITEM i
                 WHERE s.slpno = rs_slip.SLPNO
                   AND s.slptype = CP.itctype
                   AND s.pcyid = CP.pcyid
                   AND i.itmcode = v_itmcode
                   AND i.dsccode = CP.dsccode
                   AND CP.APPCONTR = CF.CID
                   AND (v_stntdate between cp.eff_dt_frm and
                                           nvl(cp.eff_dt_to, to_date('31/12/2999', 'dd/mm/yyyy')));
                IF SQL%ROWCOUNT = 1 THEN
                    rs_sliptx.PCYID := v_pcyid;
                END IF;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    rs_sliptx.PCYID := NULL;
                    dbms_output.put_line('NO PCYID.');
            END;
    END;

-- Comment: Assign SlipTx.transver
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

-- Comment: if v_qty > 1 then re-assign SlipTx.STNDESC
-- Start SIR_HAT_2008121101, DaiZhaoBing, 2008/12/24
--  if v_qty > 1 then
--        rs_sliptx.stndesc := rs_sliptx.stndesc || ' X ' || v_qty;
--  end if;
-- End SIR_HAT_2008121101, DaiZhaoBing, 2008/12/24

-- Comment: SQL Insert Record into SlipTx
-- Start SIR_HAT_2008121101, DaiZhaoBing, 2008/12/24
    INSERT INTO sliptx
          (stnid,                slpno,             stnseq,             stnsts,
           pkgcode,              itmcode,           itmtype,            stndisc,
           stnoamt,                                 stnbamt,
           stnnamt,                                 doccode,            acmcode,
           glccode,              usrid,             stntdate,           stncdate,
           stnadoc,              stndesc,           stnrlvl,            stntype,
           stnxref,              dsccode,           dixref,             stndidoc,
           stncpsflag,           pcyid,             transver,           stndesc1,
           unit,                 irefno)
    VALUES(rs_sliptx.stnid,      rs_sliptx.slpno,   rs_sliptx.stnseq,   rs_sliptx.stnsts,
           rs_sliptx.pkgcode,    rs_sliptx.itmcode, rs_sliptx.itmtype,  rs_sliptx.stndisc,
           rs_sliptx.stnoamt * v_qty,               rs_sliptx.stnbamt * v_qty,
           rs_sliptx.stnnamt * v_qty,               rs_sliptx.doccode,  rs_sliptx.acmcode,
           rs_sliptx.glccode,    rs_sliptx.usrid,   rs_sliptx.stntdate, rs_sliptx.stncdate,
           NULL,                 rs_sliptx.stndesc, rs_sliptx.stnrlvl,  rs_sliptx.stntype,
           NULL,                 rs_sliptx.dsccode, rs_sliptx.stnid,    NULL,
           rs_sliptx.stncpsflag, rs_sliptx.pcyid,   rs_sliptx.transver, NULL,
           v_qty,                v_ref_no);

/*    INSERT INTO sliptx
          (stnid,                slpno,             stnseq,             stnsts,
           pkgcode,              itmcode,           itmtype,            stndisc,
           stnoamt,                                 stnbamt,
           stnnamt,                                 doccode,            acmcode,
           glccode,              usrid,             stntdate,           stncdate,
           stnadoc,              stndesc,           stnrlvl,            stntype,
           stnxref,              dsccode,           dixref,             stndidoc,
           stncpsflag,           pcyid,             transver,           stndesc1,
           unit)
    VALUES(rs_sliptx.stnid,      rs_sliptx.slpno,   rs_sliptx.stnseq,   rs_sliptx.stnsts,
           rs_sliptx.pkgcode,    rs_sliptx.itmcode, rs_sliptx.itmtype,  rs_sliptx.stndisc,
           rs_sliptx.stnoamt * v_qty,               rs_sliptx.stnbamt * v_qty,
           rs_sliptx.stnnamt * v_qty,               rs_sliptx.doccode,  rs_sliptx.acmcode,
           rs_sliptx.glccode,    rs_sliptx.usrid,   rs_sliptx.stntdate, rs_sliptx.stncdate,
           NULL,                 rs_sliptx.stndesc, rs_sliptx.stnrlvl,  rs_sliptx.stntype,
           NULL,                 rs_sliptx.dsccode, rs_sliptx.stnid,    NULL,
           rs_sliptx.stncpsflag, rs_sliptx.pcyid,   rs_sliptx.transver, NULL,
           v_qty);
*/
-- End SIR_HAT_2008121101, DaiZhaoBing, 2008/12/24

-- Comment: Assign Output Variables o_stnid and o_stnseq
    o_stnid := rs_sliptx.stnid;
    o_stnseq := rs_sliptx.stnseq;
    RETURN TRUE;

EXCEPTION
    WHEN others THEN
        o_errmsg := sqlerrm;
    RETURN FALSE;
end;
/

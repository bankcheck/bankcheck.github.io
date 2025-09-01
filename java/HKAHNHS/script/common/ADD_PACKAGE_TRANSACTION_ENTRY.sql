create or replace function ADD_PACKAGE_TRANSACTION_ENTRY
-- ******************************COPYRIGHT NOTICE*******************************
-- All rights reserved.  This material is confidential and proprietary to Excel
-- Technology International (Hong Kong) Limited and no part of this material
-- should be reproduced, published in any form by any means, electronic or
-- mechanical including photocopy or any information storage or retrieval system
-- nor should the material be disclosed to third parties without the express
-- written authorization of Excel Technology International (Hong Kong) Limited.

-- ****************************PROGRAM DESCRIPTION*******************************
-- Program Name   : ADD_PACKAGE_TRANSACTION_ENTRY
-- Nature         : Application
-- Description    : Interface Program for Adding Package Transaction
-- Creation Date  :
-- Creator        :
-- ****************************MODIFICATION HISTORY******************************
-- Modify Date    : 2008/12/24
-- Modifier       : DaiZhaoBing
-- CR / SIR No.   : SIR_HAT_2008121101
-- Description    : Add Param: Unit, iRefNo
-- ******************************************************************************
( v_slpno     in VARCHAR2,
  v_pkgcode   in varchar2,
  v_itmcode   in varchar2,
  v_oAmount   in float := 0,
  v_bAmount   in float := 0,
  v_doccode   in varchar2,
  v_acmcode   in varchar2,
  v_glccode   in varchar2,
  v_ptntdate  in date,
  v_ptnrlvl   in number,
  v_diflag    in number,
  v_chkrate   in varchar2 := 'Y',  -- 'Y': Check rate; 'N': Not check rate

-- Start SIR_HAT_2008121101, DaiZhaoBing, 2008/12/24
  v_unit      in number:=1,
  v_irefno    in varchar2:=null
-- End SIR_HAT_2008121101, DaiZhaoBing, 2008/12/24

/*  v_stat      in varchar2 := 'Y', -- Enhancement_01: 'Y'/ 'N'
  v_otp2      in varchar2 := 'Y'  -- Otp2: 'Y' / 'N'*/
)
return boolean as
  rs_slip        slip%rowtype;
  rs_item        item%rowtype;
  rs_pkgtx       pkgtx%rowtype;

  v_ptnid        pkgtx.ptnid%type;
  v_ptnseq       pkgtx.ptnseq%type;
begin
  dbms_output.put_line ('Function:Package Transaction Entry Start.');

  -- PTNID
  select seq_pkgtx.nextval into v_ptnid from dual;
  rs_pkgtx.PTNID := v_ptnid;

  -- PTNSEQ
  update slip set slppseq = slppseq + 1 where slpno = v_SLPNO;
  select slppseq-1 into v_ptnseq from slip where slpno = v_SLPNO;
  rs_pkgtx.PTNSEQ := v_ptnseq;

  -- SLPNO
  rs_pkgtx.SLPNO := v_SLPNO;

  -- PTNSTS
  rs_pkgtx.PTNSTS := 'N';

  select * into rs_slip from slip where slpno = v_slpno;
  select * into rs_item from item where itmcode = v_itmcode;

  -- pkgcode
  rs_pkgtx.PKGCODE := v_pkgcode;

  -- itmcode
  rs_pkgtx.itmCODE := v_itmcode;

  -- amount
  rs_pkgtx.ptnoamt := v_oamount;
  rs_pkgtx.ptnbamt := v_bamount;

  -- GLCCODE
  rs_pkgtx.GLCCODE := v_GLCCODE;

  -- DOCCODE
  rs_pkgtx.DOCCODE := v_doccode;

  -- ACMCODE
  rs_pkgtx.ACMCODE := v_acmcode;

  -- USRID
  rs_pkgtx.USRID := GET_CURRENT_USRID();

  -- PTNTDATE
  rs_pkgtx.PTNTDATE := v_ptntdate;

  -- STNCDATE
  rs_pkgtx.PTNCDATE := sysdate;

  -- STNDESC
  rs_pkgtx.PTNDESC := rs_item.ITMNAME;

  -- PTNRLVL
  rs_pkgtx.PTNRLVL := v_ptnRLVL;

  -- DSCCODE
  rs_pkgtx.DSCCODE := rs_item.DSCCODE;

  -- Stat
/*  if v_stat = 'Y' then*/
  if v_chkrate = 'Y' then
     rs_pkgtx.ptnbamt := v_oAmount;
     rs_pkgtx.ptncpsflag := null;
  else
     rs_pkgtx.ptnbamt := v_bAmount;
     rs_pkgtx.ptncpsflag := 'S';
  end if;

  rs_pkgtx.acmcode := v_acmcode;
/*  else
\*    if v_chkrate = 'Y' then
      rs_pkgtx.ptnbamt := v_oAmount;
    else*\
      rs_pkgtx.ptnbamt := v_bAmount;
\*    end if;*\
  end if;*/

/*  if v_otp2 = 'Y' then*/

-- Start SIR_HAT_2008121101, DaiZhaoBing, 2008/12/24
/*  rs_pkgtx.unit := 1;*/
  rs_pkgtx.unit := nvl(v_unit,1);
-- End SIR_HAT_2008121101, DaiZhaoBing, 2008/12/24

/*  else
    rs_pkgtx.unit := null;
  end if;*/

  -- ptndiflag
  rs_pkgtx.ptndiflag := v_diflag;

-- Start add, DaiZhaoBing, 2008/12/24
  -- irefno
  rs_pkgtx.irefno := v_irefno;
-- End add, DaiZhaoBing, 2008/12/24

  --##CK.20090420##
  if v_unit > 1 then
     -- rs_pkgtx.PTNDESC := rs_pkgtx.PTNDESC || ' X ' || v_unit;
        rs_pkgtx.PTNOAMT := rs_pkgtx.PTNOAMT * v_unit;
        rs_pkgtx.PTNBAMT := rs_pkgtx.PTNbAMT * v_unit;
  end if;
  --##CK.20090420.

  -- Add package transaction entry
-- Start SIR_HAT_2008121101, DaiZhaoBing, 2008/12/24
/*  insert into pkgtx (PTNID, PTNSEQ, PTNSTS, PKGCODE, ITMCODE,
                     PTNOAMT, PTNBAMT, DOCCODE, ACMCODE, GLCCODE,
                     USRID, PTNTDATE, PTNCDATE, PTNRLVL, SLPNO,
                     PTNDESC, DSCCODE, ptncpsflag, unit, ptndiflag)
             values (rs_pkgtx.PTNID, rs_pkgtx.PTNSEQ, rs_pkgtx.PTNSTS, rs_pkgtx.PKGCODE, rs_pkgtx.ITMCODE,
                     rs_pkgtx.PTNOAMT, rs_pkgtx.PTNBAMT, rs_pkgtx.DOCCODE, rs_pkgtx.ACMCODE, rs_pkgtx.GLCCODE,
                     rs_pkgtx.USRID, rs_pkgtx.PTNTDATE, rs_pkgtx.PTNCDATE, rs_pkgtx.PTNRLVL, v_SLPNO,
                     rs_pkgtx.PTNDESC, rs_pkgtx.DSCCODE, rs_pkgtx.ptncpsflag, rs_pkgtx.unit, rs_pkgtx.ptndiflag);*/

  insert into pkgtx (PTNID, PTNSEQ, PTNSTS, PKGCODE, ITMCODE,
                     PTNOAMT, PTNBAMT, DOCCODE, ACMCODE, GLCCODE,
                     USRID, PTNTDATE, PTNCDATE, PTNRLVL, SLPNO,
                     PTNDESC, DSCCODE, ptncpsflag, unit, ptndiflag,
                     irefno)
             values (rs_pkgtx.PTNID, rs_pkgtx.PTNSEQ, rs_pkgtx.PTNSTS, rs_pkgtx.PKGCODE, rs_pkgtx.ITMCODE,
                     rs_pkgtx.PTNOAMT, rs_pkgtx.PTNBAMT, rs_pkgtx.DOCCODE, rs_pkgtx.ACMCODE, rs_pkgtx.GLCCODE,
                     rs_pkgtx.USRID, rs_pkgtx.PTNTDATE, rs_pkgtx.PTNCDATE, rs_pkgtx.PTNRLVL, v_SLPNO,
                     rs_pkgtx.PTNDESC, rs_pkgtx.DSCCODE, rs_pkgtx.ptncpsflag, rs_pkgtx.unit, rs_pkgtx.ptndiflag,
                     rs_pkgtx.irefno);
-- End SIR_HAT_2008121101, DaiZhaoBing, 2008/12/24
  dbms_output.put_line ('Function:Package Transaction Entry End.');
  return true;
exception
  when others then
       dbms_output.put_line (sqlerrm);
       return false;
end;
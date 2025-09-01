create or replace function ADD_PACKAGE_ENTRY
( rs_slip     in slip%rowtype,
  v_pkgcode   in varchar2,
  v_itmcode   in varchar2,
  v_stat      in varchar2 := 'N',
  v_pkgrlvl   in number,
  v_doccode   in varchar2,
  v_acmcode   in varchar2,
  v_ptntdate  in date,
  v_amount    in float := 0,
  v_override  in varchar2 := 'N',
  v_ref_no    in varchar2,
  v_cpsid     in number,

  o_ptnid     out number,
  o_ptnseq    out number,
  o_errmsg    out varchar2
)
  return boolean as

  v_ptnid      pkgtx.ptnid%type;
  v_ptnseq     pkgtx.ptnseq%type;

  v_acmcode2   pkgtx.acmcode%type;

  rs_item        item%rowtype;
  rs_itemchg     itemchg%rowtype;
  rs_pkgtx       pkgtx%rowtype;

begin

  -- dbms_output.put_line ('ADD_PACKAGE_ENTRY');

  -- PTNID
  select seq_pkgtx.nextval into v_ptnid from dual;
  rs_pkgtx.PTNID := v_ptnid;

  -- PTNSEQ
  rs_pkgtx.SLPNO := rs_slip.SLPNO;
  update slip set slppseq = slppseq + 1 where slpno = rs_slip.SLPNO;
  select slppseq-1 into v_ptnseq from slip where slpno = rs_slip.SLPNO;
  rs_pkgtx.PTNSEQ := v_ptnseq;

  -- PTNSTS
  rs_pkgtx.PTNSTS := 'N';

  -- GET_ACMCODE
  if rs_slip.SLPTYPE = 'I' then
    v_acmcode2 := GET_ACMCODE(v_acmcode,v_itmcode,v_pkgcode,null);
  else
    v_acmcode2 := null;
  end if;

  -- PKGCODE
  rs_pkgtx.PKGCODE := v_pkgcode;
  rs_pkgtx.ITMCODE := v_itmcode;

  select * into rs_item from item where itmcode = v_itmcode;

  select * into rs_itemchg from itemchg where itmcode = v_itmcode
    and nvl(pkgcode,' ') = nvl(v_pkgcode,' ') and nvl(acmcode,' ') = nvl(v_acmcode2,' ') and cpsid is null;

  -- STNOAMT, STNBAMT
  if v_stat = 'Y' then
    rs_pkgtx.PTNOAMT := rs_itemchg.ITCAMT2;
    rs_pkgtx.PTNBAMT := rs_itemchg.ITCAMT2;
  else
    rs_pkgtx.PTNOAMT := rs_itemchg.ITCAMT1;
    rs_pkgtx.PTNBAMT := rs_itemchg.ITCAMT1;
  end if;

  -- GLCCODE
  rs_pkgtx.GLCCODE := rs_itemchg.GLCCODE;

  if v_cpsid is not null then
    begin
      v_acmcode2 := GET_ACMCODE(v_acmcode,v_itmcode,v_pkgcode,v_cpsid);

      select * into rs_itemchg from itemchg where itmcode = v_itmcode
        and nvl(pkgcode,' ') = nvl(v_pkgcode,' ') and nvl(acmcode,' ') = nvl(v_acmcode2,' ') and cpsid = v_cpsid;
      if SQL%ROWCOUNT = 1 then
        if rs_itemchg.CPSPCT is null then
          if v_stat = 'Y' then
            rs_pkgtx.PTNBAMT := rs_itemchg.ITCAMT2;
          else
            rs_pkgtx.PTNBAMT := rs_itemchg.ITCAMT1;
          end if;
        end if;
      end if;
    exception
      when NO_DATA_FOUND then
        dbms_output.put_line ('NO CPS FOUND.');
    end;
  end if;

  -- PTNBAMT
  if v_override = 'Y' then
    rs_pkgtx.PTNBAMT := v_amount;
  end if;

  -- DOCCODE
  rs_pkgtx.DOCCODE := v_doccode;

  -- ACMCODE
  rs_pkgtx.ACMCODE := v_acmcode2;

  -- USRID
  rs_pkgtx.USRID := GET_CURRENT_USRID();

  -- PTNTDATE
  rs_pkgtx.PTNTDATE := v_ptntdate;

  -- STNCDATE
  rs_pkgtx.PTNCDATE := sysdate;

  -- STNDESC
  rs_pkgtx.PTNDESC := rs_item.ITMNAME;

  -- PTNRLVL
  if v_pkgrlvl is null then
    rs_pkgtx.PTNRLVL := rs_item.ITMRLVL;
  else
    rs_pkgtx.PTNRLVL := v_pkgrlvl;
  end if;

  -- DSCCODE
  rs_pkgtx.DSCCODE := rs_item.DSCCODE;

  insert into pkgtx (PTNID,PTNSEQ,PTNSTS,PKGCODE,ITMCODE,PTNOAMT,PTNBAMT,
                     DOCCODE,ACMCODE,GLCCODE,USRID,PTNTDATE,PTNCDATE,
                     PTNRLVL,SLPNO,PTNDESC,DSCCODE,DIXREF) values
  (rs_pkgtx.PTNID,rs_pkgtx.PTNSEQ,rs_pkgtx.PTNSTS,rs_pkgtx.PKGCODE,rs_pkgtx.ITMCODE,rs_pkgtx.PTNOAMT,rs_pkgtx.PTNBAMT,
   rs_pkgtx.DOCCODE,rs_pkgtx.ACMCODE,rs_pkgtx.GLCCODE,rs_pkgtx.USRID,rs_pkgtx.PTNTDATE,rs_pkgtx.PTNCDATE,
   rs_pkgtx.PTNRLVL,rs_slip.SLPNO,rs_pkgtx.PTNDESC,rs_pkgtx.DSCCODE,null);


  o_ptnid     := rs_pkgtx.PTNID;
  o_ptnseq    := rs_pkgtx.PTNSEQ;

  return true;
exception
  when others then
    o_errmsg    := SQLERRM;
    return false;
end;
/

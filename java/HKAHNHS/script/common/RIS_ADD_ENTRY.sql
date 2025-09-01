create or replace procedure RIS_ADD_ENTRY (
  v_slpno varchar2,
  v_doccode varchar2,
  v_readdoc varchar2,
  -- 20130131
  v_orderdate date,
  v_itmcode varchar2,
  v_stat varchar2,
  v_ref_no varchar2,
  v_amt float,
  v_arccode varchar2,
  v_discount float,
  -- v_amt/v_arccode/v_discount
  -- v_stnid_list, v_stnseq_list can handle just one stnid return for add item or a list of stnid for add package
  v_stnid_list out varchar2,
  v_stnseq_list out varchar2,
  v_error_message out varchar2 )
is
  v_pkgitmcode       item.itmcode%type;
  v_pkgrlvl          package.pkgrlvl%type;
  rs_slip            slip%rowtype ;

-- Comment: Define Cursor:Package_Cursor
    cursor package_cursor (v_slptype varchar2, v_pkgcode varchar2) is
        select distinct ic.itmcode
          from itemchg ic, item i
         where ic.pkgcode = v_pkgcode
           and ic.itctype = v_slptype
           and ic.cpsid is null
           and ic.itmcode = i.itmcode
         order by 1;

  v_isvalid          boolean ;
  v_cpsid            conpceset.cpsid%type ;

  e_dup_sliptx_item         exception ;
  e_invalid_slip            exception ;
  e_is_not_active_slip      exception ;
  e_invalid_itmpkgcode      exception ;
  e_addentry_error          exception ;
  e_invalid_overridePkg     exception ;
  e_discount_conflict_cpsid exception ;

  -- "v_isPkg" is renamed from "entrylist(v_i).s_ip" in procedure ORD_ADD_REMOVE_BILL_CHARGE
--  v_isPkg varchar2(1) := 'N' ;
  v_isPkg varchar2(1) := 'Y' ;
  v_override varchar2(1) := 'N' ;

  o_stnoamt float ;
  o_stnbamt float ;
  o_stnnamt float ;
  o_stndisc float ;
  o_errmsg varchar2(500) ;

  v_stnid sliptx.stnid%type ;
  v_stnseq sliptx.stnseq%type ;

  l_item_cnt number(5) ;
begin

  -- version 20130201 : no need to check
  --select count(1) into l_item_cnt
  --  from sliptx t
  -- where t.slpno = v_slpno
  --   and ( t.itmcode = v_itmcode or exists ( select 1 from itemchg i where i.pkgcode = v_itmcode and i.itmcode = t.itmcode ) )
  --   and ( t.stnsts = 'N' and t.irefno is null ) ;
  --if l_item_cnt > 0 then
  --   v_error_message := 'duplicate pending items in slip : ' || v_slpno ;
  --	 raise e_dup_sliptx_item ;
  --end if ;

-- check override amt
  if v_amt is not null and v_amt != 0 then
     v_override := 'Y' ;
  end if ;

-- Comment: Retrieve Slip Info

  begin
    select * into rs_slip from slip where slpno = v_slpno ;
  exception when others then
     v_error_message := 'Slip no: ' || v_slpno || ' not exists.' ;
     raise e_invalid_slip ;
  end ;

-- ??? : by pass original logic
--  if rs_slip.slpsts <> 'A' then
--     v_error_message := 'Slip : ' || v_slpno || ' is not active slip.' ;
--     raise e_is_not_active_slip ;
--  end if ;

-- Comment: Retrieve CPS
    if v_arccode is null then
       begin
         select cpsid into v_cpsid from slip s, arcode a where s.arccode = a.arccode and s.slpno = v_slpno;
       exception
         when NO_DATA_FOUND then
           dbms_output.put_line ('SLIP NO CPS');
         when others then
           v_error_message := SQLERRM;
       end;
	else
       begin
         select cpsid into v_cpsid from arcode a where a.arccode = v_arccode ;
       exception
         when NO_DATA_FOUND then
           dbms_output.put_line ('Given AR Code is invalid');
         when others then
           v_error_message := SQLERRM;
       end;
	end if ;
    if v_cpsid is not null and not ( v_discount is null or v_discount = 0 ) then
       raise e_discount_conflict_cpsid ;
	end if ;

-- Comment: Validate Item Code
-- the checking sequence of previous version is : frist = is_valid_itmcode, second = is_valid_pkgcode
-- the checking sequence of final version is : frist = is_valid_pkgcode, second = is_valid_itmcode
  v_isvalid := IS_VALID_PKGCODE(rs_slip.SLPTYPE, v_itmcode,'');
  if not v_isvalid then
     v_isvalid := IS_VALID_ITMCODE (rs_slip.SLPTYPE, v_itmcode, null, '');
     if v_isvalid then
		v_isPkg := 'N';
     else
        v_error_message := 'Invalid Item or Package Code: ' || v_itmcode;
        raise e_invalid_itmpkgcode ;
     end if;
  end if;

  if v_isPkg = 'Y' and v_override = 'Y' then
	 v_error_message := 'Amount cannot be overrided in Package ' ;
	 raise e_invalid_overridePkg ;
  end if ;

  if v_isPkg = 'Y' then
     dbms_output.put_line( 'Add Package: ' || v_itmcode ) ;
     select pkgrlvl into v_pkgrlvl from package where pkgcode = v_itmcode ;
     open package_cursor (rs_slip.SLPTYPE, v_itmcode) ;
     loop
       fetch package_cursor into v_pkgitmcode ;
       exit when package_cursor%NOTFOUND ;
       dbms_output.put_line ('      Item: ' || v_pkgitmcode) ;
       -- stat = 'N', acmcode = null, stntdate = sysdate

	   if not ( v_discount is null or v_discount = 0 ) then
          v_isvalid := ADD_ENTRY_W_DISC ( rs_slip, v_itmcode, v_pkgitmcode, v_stat, v_pkgrlvl, v_doccode,
                                       null, v_orderdate, v_amt, 1, v_override, null /*v_ref_no*/, v_cpsid, v_discount, 'Y',
                                       v_stnid, v_stnseq, v_error_message ) ;
       else
          v_isvalid := ADD_ENTRY ( rs_slip, v_itmcode, v_pkgitmcode, v_stat, v_pkgrlvl, v_doccode,
                                       null, v_orderdate, v_amt, v_override, null /*v_ref_no*/, v_cpsid,
                                       v_stnid, v_stnseq, v_error_message ) ;
	   end if ;

       -- original add_entry will add the value of "v_ref_no" on the tail of "stndesc" column
	   -- so we need to manualy update the "irefno" column
       -- update sliptx set irefno = v_ref_no where stnsts = 'N' and slpno = v_slpno and stnid = v_stnid ;
	   -- version 20130131
       --update sliptx set irefno = v_ref_no, usrid = 'IPACS' where stnsts = 'N' and slpno = v_slpno and stnid = v_stnid ;
	   -- version 20130226 : because add_entry will take the doccode from slip instead of from v_doccode, so need to overwrite once more
       update sliptx set irefno = v_ref_no, usrid = 'IPACS', doccode = v_doccode where stnsts = 'N' and slpno = v_slpno and stnid = v_stnid ;

       if v_readdoc is not null then
         update sliptx set irefno = v_ref_no, usrid = 'IPACS', doccode = v_readdoc where stnsts = 'N' and slpno = v_slpno and stnid = v_stnid and itmcode like '%931';
       end if;

       if not v_isvalid then
          v_error_message := 'ris_add_entry <add package> error: ' || v_error_message ;
          raise e_addentry_error ;
       end if ;
	   select decode( v_stnid_list, null, to_char(v_stnid), v_stnid_list || ',' || to_char(v_stnid) ) into v_stnid_list from dual ;
	   select decode( v_stnseq_list, null, to_char(v_stnseq), v_stnseq_list || ',' || to_char(v_stnseq) ) into v_stnseq_list from dual ;
     end loop ;
     close package_cursor ;
  else
     dbms_output.put_line ('Add Item:' || v_itmcode) ;
     -- stat = 'N', acmcode = null, stntdate = sysdate

     if not ( v_discount is null or v_discount = 0 ) then
        v_isvalid := ADD_ENTRY_W_DISC ( rs_slip, null, v_itmcode, v_stat, null, v_doccode,
                                    null, v_orderdate, v_amt, 1, v_override, null /*v_ref_no*/, v_cpsid, v_discount, 'Y',
                                    v_stnid, v_stnseq, v_error_message ) ;
     else
        v_isvalid := ADD_ENTRY ( rs_slip, null, v_itmcode, v_stat, null, v_doccode,
                                    null, v_orderdate, v_amt, v_override, null /*v_ref_no*/, v_cpsid,
                                    v_stnid, v_stnseq, v_error_message) ;
	 end if ;

     -- original add_entry will add the value of "v_ref_no" on the tail of "stndesc" column
	 -- so we need to manualy update the "irefno" column
	 -- version 20130131
     --update sliptx set irefno = v_ref_no, usrid = 'IPACS' where stnsts = 'N' and slpno = v_slpno and stnid = v_stnid ;
     -- version 20130226 : because add_entry will take the doccode from slip instead of from v_doccode, so need to overwrite once more
     update sliptx set irefno = v_ref_no, usrid = 'IPACS', doccode = v_doccode where stnsts = 'N' and slpno = v_slpno and stnid = v_stnid ;

     if not v_isvalid then
        v_error_message := 'ris_add_entry <add entry> error: ' || v_error_message;
        raise e_addentry_error ;
     end if ;
	 select decode( v_stnid_list, null, to_char(v_stnid), v_stnid_list || ',' || to_char(v_stnid) ) into v_stnid_list from dual ;
	 select decode( v_stnseq_list, null, to_char(v_stnseq), v_stnseq_list || ',' || to_char(v_stnseq) ) into v_stnseq_list from dual ;
  end if ;
  v_isvalid := UPDATE_SLIP (v_slpno) ;
exception
    when e_dup_sliptx_item then
        dbms_output.put_line ( v_error_message ) ;
    when e_invalid_slip then
        dbms_output.put_line ( v_error_message ) ;
    when e_is_not_active_slip then
        dbms_output.put_line ( v_error_message ) ;
    when e_invalid_itmpkgcode then
	      v_error_message := 'e_invalid_itmpkgcode' ;
        dbms_output.put_line ( v_error_message ) ;
    when e_addentry_error then
        dbms_output.put_line ( v_error_message ) ;
    when e_invalid_overridePkg then
	      v_error_message := 'e_invalid_overridePkg' ;
        dbms_output.put_line ( v_error_message ) ;
	  when e_discount_conflict_cpsid then
	      v_error_message := 'e_discount_conflict_cpsid, discount = ' || to_char(v_discount) ;
        dbms_output.put_line ( v_error_message ) ;
    when others then
        v_error_message := '(ris_add_entry) : err code. : ' || SQLCODE || ', err msg. : ' || SQLERRM ;
        dbms_output.put_line ( v_error_message ) ;
end;
/

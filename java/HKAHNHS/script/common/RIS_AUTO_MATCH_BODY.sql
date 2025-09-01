create or replace procedure ris_auto_match_body (
  p_accessno   in varchar2, -- Accession Number
--  p_log_date   in date,
  p_logno      in number,
  p_patno      in varchar2, -- Patient ID
  p_orderdate  in date,     -- Order Create Date
  p_doccode    in varchar2, -- Primary Physican Code
  p_readdoc    in varchar2, -- Reading Physican Code
  p_examcode   in varchar2, -- Exam Code, i.e. Package Code in Hats
  p_examname   in varchar2, -- Exam Description
-- need to be added by ris : begin
-- extra
  p_billcode1  in varchar2,
  p_billcode2  in varchar2,
  p_billcode3  in varchar2,
  p_billcode4  in varchar2,
-- version : 20121024
  p_billcode5  in varchar2,
  p_billcode6  in varchar2,
-- version : 20121024
-- end
  p_arccode    in varchar2, -- AR Code (Discount Code) , if p_arccode have value then p_discount should not have value
  p_discount   in number,    -- Discount (Percentage), if p_discount have value then p_arccode should not have value
-- version : 20130123
  p_pattype    in varchar2

)
is
  l_count number;
  l_hat_itmcode ris_rtn_itmcode.hat_itmcode%type ;
--  l_outstand_items boolean := null ;
  l_outstand_items number(1) ;
  l_excess_items boolean := false ;
--  l_auto_match boolean := false ;
  l_recent_slip boolean := false ;
  l_arccode slip.arccode%type := null ;
-- discount is always used when execute ris_add_entry
--  l_discount float := null ;
  l_slpno slip.slpno%type ;
  l_slpadoc slip.slpadoc%type ;
  l_slptype slip.slptype%type ;
  l_inpddate inpat.inpddate%type ;
  l_return_stnid sliptx.stnid%type ;
  l_stnid sliptx.stnid%type ;
  l_stnseq sliptx.stnseq%type ;

  l_valid_days number(3) ;

  l_stnid_list varchar2(500) ;
  l_stnseq_list varchar2(500) ;

  l_msg varchar2(500) ;
  l_ris_rtn_code varchar2(10) ;
  l_ris_rtn_msg varchar2(200) ;
  l_meta_billing_cnt number(3) ;
  l_tmp_num number(6) ;

  l_next number(3) ;
  l_next_stnid sliptx.stnid%type ;
  l_xrgsc number(1) ;

  l_doccode doctor.doccode%type ;
  l_readdoc doctor.doccode%type ;

  l_error_code      ris_auto_match_log.error_code%type ;
  l_error_message   ris_auto_match_log.error_message%type ;
  l_action_code     ris_auto_match_log.action_code%type ;
  l_action_message  ris_auto_match_log.action_message%type ;

  l_locked            boolean := FALSE ;

  e_general exception ;
  e_lock exception ;

  l_lookup_slptype    varchar2(5) ;

  l_act_slip_cnt number(5) := 0 ;
  l_slpno_by_doc slip.slpno%type ;
  -- 20140214
  l_slpsts varchar2(1) ;

  cursor c_act_slip is select s.*
  	  from slip s left outer join reg r on r.regid = s.regid and r.regsts = 'N' left outer join inpat i on i.inpid = r.inpid
	  where s.patno = p_patno and s.slptype = l_lookup_slptype
      and ( s.slpsts = 'A'
            or ( s.slpsts = 'C' and exists ( select 1 from sliptx tx where tx.slpno = s.slpno
--										         and ( tx.itmcode = p_examcode or tx.pkgcode = p_examcode )
-- version : 20130130
										         and ( tx.itmcode = p_examcode or tx.itmcode in ( select distinct itmcode from itemchg where pkgcode = p_examcode ) )
                                                 and ( tx.stnsts in ( 'A', 'N' ) and tx.irefno is null and SYSDATE - to_date(substr(tx.slpno, 1,7),'YYYYDDD') < 90 ) ) )
									)
--	  and (    ( s.slptype in ( 'O', 'D' ) and sysdate - ( to_date(to_char(substr(s.slpno, 1,4))||'0101','YYYYMMDD') + to_number(substr(s.slpno, 5,3)) ) <= 2 )
--	  and (    ( s.slptype in ( 'O', 'D' ) ) /* 20130322 */
	  and (    ( s.slptype in ( 'O', 'D' ) and ( l_doccode is null or s.doccode = l_doccode) ) /* 20180803 */
			or ( s.slptype = 'I' and i.inpddate is null )
		  ) order by s.slpsts, s.slpno desc ;

  procedure log is
    begin
	  insert into ris_auto_match_log ( accessno, patno, orderdate, doccode, examcode, examname, billcode1, billcode2, billcode3, billcode4, billcode5, billcode6, arccode, discount, log_date, error_code, error_message, action_code, action_message )
	  values ( p_accessno, p_patno, p_orderdate, l_doccode, p_examcode, p_examname, p_billcode1, p_billcode2, p_billcode3, p_billcode4, p_billcode5, p_billcode6, p_arccode, p_discount, sysdate, l_error_code, l_error_message, l_action_code, l_action_message ) ;
	  l_locked := recordunlock( 'Slip', l_slpno ) ;

	-- test only
	-- insert into ris_auto_match_log ( examcode ) values ( 'test1' ) ;
	end ;

  function lock_slip return boolean is
    begin
      l_locked := recordlock( 'Slip', l_slpno, l_error_message ) ;
      if l_locked then
         -- commit ;
		 return true ;
      else
	     l_error_code := '98' ;
	     l_error_message := 'Cannot lock slip#' || l_slpno || ', ' || l_error_message ;
         p_add_tellog2( 'RIS', l_slpno, p_examcode, null, 'Auto match ( from RIS to HATS ) failed, ' || l_error_message, 1, 'RIS#'||p_accessno, null, l_slpno ) ;
	     --raise e_general ;
		 return false ;
      end if ;
	end ;

begin

  if upper(p_arccode) = 'MANUAL' then
	 raise e_general ;
  end if ;

  -- 20130131 : if pattype is not in 'I/D/O', count pattype as 'O'
  if p_pattype is null then
	 l_error_code := '00' ;
	 l_error_message := 'patient type not defined' ;
	 raise e_general ;
  elsif p_pattype in ( 'I', 'O', 'D' ) then
     l_lookup_slptype := p_pattype ;
  elsif p_pattype in ( 'N' ) then -- for 'N' : External
     l_lookup_slptype := 'O' ;
  elsif p_pattype in ( 'H' ) then -- for 'H' : Health Assessment
     l_lookup_slptype := 'O' ;
  else
	 l_error_code := '00' ;
	 l_error_message := 'invalid patient type' ;
	 raise e_general ;
  end if ;

  select ris_get_match_itmcode( p_examcode ) into l_hat_itmcode from dual ;
  if l_hat_itmcode is null then
	 l_error_code := '01' ;
	 l_error_message := 'mapping itmcode in ris_rtn_itmcode table not found' ;
	 raise e_general ;
  end if ;

  -- version : 20130130 : if invalid doccode, use default doccode according to item's dsccode : e.g. HA Case use refer. doctor
  -- version : 20181019 : if inactive doctor, use default doccode
--  if not is_valid_doccode( p_doccode ) then

  l_doccode := 'DI' ;
  select count(1) into l_count from doctor where doccode = p_doccode and docsts = -1;
  if l_count = 1 then
     l_doccode := p_doccode ;
  end if ;

  l_readdoc := null;
  if p_readdoc is not null then
    select count(1) into l_count from doctor where doccode = p_readdoc and docsts = -1;
    if l_count = 1 then
       l_readdoc := p_readdoc ;
    end if ;
  end if ;

  /*
  begin
--    select s1.slpno, s1.slptype, s1.slpadoc into l_slpno, l_slptype, l_slpadoc
--  	  from slip s1 where s1.patno = p_patno and s1.slpsts = 'A' ;
       -- and not exists ( select 1 from sliptx t where t.slpno = s1.slpno and substr( t.irefno, 1, 3 ) = 'RIS' ) ;

	-- version : 20121130
    --select s.slpno, s.slptype into l_slpno, l_slptype
  	--  from slip s left outer join reg r on r.regid = s.regid left outer join inpat i on i.inpid = r.inpid
	--  where s.patno = p_patno
    --  and ( s.slpsts = 'A'
    --        or ( s.slpsts = 'C' and exists ( select 1 from sliptx tx where tx.slpno = s.slpno
	--									         and ( tx.itmcode = p_examcode or tx.pkgcode = p_examcode )
    --                                             and ( tx.irefno is null ) ) )
	--								)
	--    and ( ( s.slptype in ( 'O', 'D' ) and sysdate - ( to_date(to_char(substr(s.slpno, 1,4))||'0101','YYYYMMDD') + to_number(substr(s.slpno, 5,3)) ) <= 2 )
	--		or ( s.slptype = 'I' and i.inpddate is null )
	--	  ) ;

    -- version : 20130123
    select s.slpno, s.slptype into l_slpno, l_slptype
  	  from slip s left outer join reg r on r.regid = s.regid and r.regsts = 'N' left outer join inpat i on i.inpid = r.inpid
	  where s.patno = p_patno and s.slptype = l_lookup_slptype
      and ( s.slpsts = 'A'
            or ( s.slpsts = 'C' and exists ( select 1 from sliptx tx where tx.slpno = s.slpno
--										         and ( tx.itmcode = p_examcode or tx.pkgcode = p_examcode )
-- version : 20130130
										         and ( tx.itmcode = p_examcode or tx.itmcode in ( select distinct itmcode from itemchg where pkgcode = p_examcode ) )
                                                 and ( tx.stnsts in ( 'A', 'N' ) and tx.irefno is null and tx.stntdate >= to_date('20130129','YYYYMMDD') ) ) )
									)
	  and (    ( s.slptype in ( 'O', 'D' ) and sysdate - ( to_date(to_char(substr(s.slpno, 1,4))||'0101','YYYYMMDD') + to_number(substr(s.slpno, 5,3)) ) <= 2 )
			or ( s.slptype = 'I' and i.inpddate is null )
		  ) ;


  exception
    when too_many_rows then

	  -- --begin
	  -- -- * this part is optional to the original spec just for more chance to made auto match, so we can comment it : begin
	  --
      --  select s1.slpno, s1.slptype, s1.slpadoc into l_slpno, l_slptype, l_slpadoc
  	  --    from slip s1 where s1.patno = p_patno and s1.slpsts = 'A'
      --    and s1.slptype = ( select v.patient_location from spectra.study@ris s
      --                  	  join spectra.visitstudy@ris vs on vs.study_key = s.study_key
	  --					  join spectra.visit@ris v on v.visit_key = vs.visit_key where s.access_no = p_accessno )
	  --	  and s1.doccode = l_doccode
	  --	  -- and exists ( select 1 from reg r where r.regid = s1.regid and r.slpno = s1.slpno and r.regdate between p_orderdate-1 and p_orderdate+1 )
	  --	  ;
	  --
	  -- -- * end
	  -- exception when others then

	  -- original : begin
	  l_error_code := '02' ;
	  l_error_message := 'more than one active slips exist' ;
	  raise e_general ;
	  -- original : end

	  -- end ;
	when no_data_found then
	  -- null ; -- no active slip exist ;

	  -- begin : changes 2012_10_09
	  -- following logic is added after 09 oct 2012 meeting with danny :
	  -- more reality is when the case pbo charge the patient first before do the exam, the slip will be closed immediately after the charge, so we need to search the closed slip also

	  -- begin : handled by new version : 20121130
	  --begin
	  --  select s1.slpno, s1.slptype, s1.slpadoc into l_slpno, l_slptype, l_slpadoc
  	  --    from slip s1 where s1.patno = p_patno and s1.slpsts = 'C'
      --     and exists ( select 1 from sliptx tx where tx.slpno = s1.slpno and ( tx.itmcode = p_examcode or tx.pkgcode = p_examcode )
      --                     and ( irefno is null or tx.irefno not like 'RIS#%' ) )
	  --     and sysdate - ( to_date(to_char(substr(s1.slpno, 1,4))||'0101','YYYYMMDD') + to_number(substr(s1.slpno, 5,3))) = 1 ;
	  --exception
	  --  when no_data_found then
	  --    null ; -- no active slip exist ;
	  --when too_many_rows then
	  --    l_error_code := '02' ;
	  --    l_error_message := 'more than one active slips exist' ;
	  --    raise e_general ;
	  --end ;

	  -- version : 20121130
	  null ;
      -- version : 20130123
	  if l_lookup_slptype = 'I' then
	     l_error_code := '13' ;
	     l_error_message := 'no active in-patient slip exist or the slip is discharged' ;
	     raise e_general ;
      end if ;
	  -- end
	  -- end ;

  end ;
  */

  for r in c_act_slip loop
    if l_act_slip_cnt = 0 then
       l_slpno := r.slpno ;
	end if ;
	--if r.doccode = p_doccode then
    -- 20160425 : don't overwrite l_slpno_by_doc, old version : order by slpno, to overwrite l_slpno_by_doc by last slpno
    if r.doccode = l_doccode and l_slpno_by_doc is null then
	     l_slpno_by_doc := r.slpno ;
	end if ;
    l_act_slip_cnt := l_act_slip_cnt + 1 ;
  end loop ;
  if l_act_slip_cnt = 0 then
    if l_lookup_slptype = 'I' then
	  l_error_code := '13' ;
      l_error_message := 'no active in-patient slip exist or the slip is discharged' ;
      raise e_general ;
    end if ;
  elsif l_act_slip_cnt > 1 then
     if l_slpno_by_doc is null then
       if l_lookup_slptype = 'I' then
         -- use last existing slip , 20151120 : just for hkah
         null ;
       else
	     l_error_code := '02' ;
	     l_error_message := 'more than one active slips exist, but none with exact doctor' ;
	     raise e_general ;
      end if ;
    else
	  l_slpno := l_slpno_by_doc ;
	end if ;
  end if ;
  -- following logic is just for HKAH : cannot allow different doctor code
  -- 20150723 : begin
  if l_lookup_slptype != 'I' and l_act_slip_cnt > 0 and l_doccode != 'DI' and l_slpno_by_doc is null then
     /*
     l_error_code := '16' ;
	   l_error_message := 'active slip found, but not with exact doctor' ;
	   raise e_general ;
     */
     -- 20151029 : create non-inpatient slip instead of display error-message
     l_slpno := null ;
  end if ;
  -- 20150723 : end

  begin
     select slpsts into l_slpsts from slip where slpno = l_slpno ;
  exception when others then
	 null ;
  end ;

  -- outstanding sliptx
  begin

    --select s1.slpno, s1.slptype into l_slpno, l_slptype
  	--  from slip s1 where s1.patno = p_patno and s1.slpsts = 'A'
	--   and exists ( select 1 from slip s join sliptx t on s.slpno = t.slpno /* join reg r on r.slpno = s.slpno */
	--                  join item i on t.itmcode = i.itmcode join excat e on e.ecccode = i.dsccode
	--			where s.slpno = s1.slpno and s.patno = p_patno and ( t.pkgcode = p_examcode or t.itmcode = p_examcode ) and s.slpsts = 'A' and t.stnsts in ( 'A', 'N' ) )
    --   and not exists ( select 1 from sliptx t where t.slpno = s1.slpno and substr( t.irefno, 1, 3 ) = 'RIS' ) ;
	--l_outstand_items := true ;

	-- 2012_10_09 : now need to search closed sliptx also */
	select 1 into l_outstand_items
	  from sliptx t join item i on t.itmcode = i.itmcode join excat e on e.ecccode = i.dsccode
	 where t.slpno = l_slpno
--	   and ( t.pkgcode = p_examcode or t.itmcode = p_examcode )
-- version : 20130130
	   and ( t.itmcode = p_examcode or t.itmcode in ( select distinct itmcode from itemchg where pkgcode = p_examcode ) )
       and t.stnsts in ( 'A', 'N' )
	   and t.irefno is null
 	   and t.stntdate >= to_date('20130129','YYYYMMDD')
	   and rownum = 1 ;

  exception
    --when too_many_rows then
	--  l_error_code := '02' ;
	--  l_error_message := 'more than one active slips exist' ;
	--  raise e_general ;
	when no_data_found then
	  l_outstand_items := 0 ;
    when others then
	  l_error_code := '99'  ;
	  l_error_message := 'sql error, ' || sqlcode || ' : ' || sqlerrm ;
	  raise e_general ;
  end ;

  -- begin : handled by new version : 20121130
  /*
  if l_slptype = 'I' then
     begin
       select inpddate into l_inpddate from slip s join reg r on r.regid = s.regid join inpat i on i.inpid = r.inpid where s.slpno = l_slpno ;
	 exception when others then
	   null ;
	 end ;
	 if l_inpddate is not null then -- patient is discharged
	    l_error_code := '03' ;
	    l_error_message := 'patient is discharged' ;
	    raise e_general ;
	 end if ;
  end if ;
  */
  -- end

  if l_outstand_items = 1 then
     -- establish link
     l_locked := recordlock( 'Slip', l_slpno, l_error_message ) ;
     if l_locked then
	    commit ;
		null ;
	 else
	    rollback ;
	    raise e_lock ;
	 end if ;

     -- version : 20130123
	 if l_lookup_slptype = 'O' then  -- created more then 3 months ( 90 days )
	    l_valid_days := 90 ;
	 elsif l_lookup_slptype = 'D' then  -- created more then 2 days
	    l_valid_days := 2 ;
     elsif l_lookup_slptype = 'I' then  -- old version : suppose this situation will not occur, version 20130131 : in-patient will be in hosp for a long time, so don't check the valid days
	 	-- l_valid_days := 1 ;
		l_valid_days := null ;
	 else
	    l_error_code := '03.1' ;
	    l_error_message := 'unexpected slip type : "' || l_lookup_slptype || '" for outstanding slip "' || l_slpno || '" occur' ;
	    raise e_general ;
	 end if ;

	 --if sysdate - ( to_date(to_char(substr(l_slpno, 1,4))||'0101','YYYYMMDD') + to_number(substr(l_slpno, 5,3))) >= l_valid_days then
	 if l_lookup_slptype != 'I' and sysdate - to_date(substr(l_slpno, 1,7),'YYYYDDD') >= l_valid_days then
	    l_error_code := '04'  ;
	    l_error_message := 'oustanding slip created more than ' || l_valid_days || ' days' ;
	    raise e_general ;
	 else -- valid days

		-- for r in ( select -- count(1) cnt, decode( count(1), 1, max( s.slpno ), null ) slpno_one, decode( count(1), 1, max( t.stnid ), null ) stnid_one,
		--			  t.stnid stnid_one, t.pkgcode, t.itmcode
		--			--from slip s join sliptx t on s.slpno = t.slpno join item i on i.dptcode in ( '240-','340-','280-' ) and t.itmcode = i.itmcode
		--			 from slip s join sliptx t on s.slpno = t.slpno /* join reg r on r.slpno = s.slpno */ join item i on t.itmcode = i.itmcode join excat e on e.ecccode = i.dsccode
		--			where s.patno = p_patno and ( t.pkgcode = p_examcode or t.itmcode = p_examcode ) and s.slpsts = 'A' and t.stnsts in ( 'A', 'N' ) and t.irefno is null
		--	        --and (sysdate - t.stncdate)*24 <= 24 -- stncdate = capture date
		--			  and (sysdate - t.stncdate)*24 <= 10000 -- stncdate = capture date
		--			group by t.stnid, t.pkgcode, t.itmcode )

		for r in ( select t.stnid stnid_one, t.pkgcode, t.itmcode, decode(t.itmcode,l_hat_itmcode,0,-1) xrgsc from slip s join sliptx t on s.slpno = t.slpno join item i on t.itmcode = i.itmcode join excat e on e.ecccode = i.dsccode
		            where s.patno = p_patno
--					  and ( t.itmcode = p_examcode or t.pkgcode = p_examcode )
-- version : 20130130
					  and ( t.itmcode = p_examcode or t.itmcode in ( select distinct itmcode from itemchg where pkgcode = p_examcode ) )
					/* and s.slpsts = 'A' and t.stnsts in ( 'A', 'N' ) */ /* changes 2012_10_09 : now need to search closed sliptx also */
					  and t.irefno is null
					  and s.slpno = l_slpno
					  and t.stnsts in ( 'A', 'N' )
					  and t.stntdate >= to_date('20130129','YYYYMMDD')
					group by t.stnid, t.pkgcode, t.itmcode )
		 loop
		  --l_outstand_items := true ;
		  --if r.cnt = 1 then
-- following line no used
--	if r.pkgcode = p_examcode or r.itmcode = p_examcode then
			   -- action : auto match
			   -- ingorn the arccode and discount come from RIS

			   -- recordlock : but need to know all slip need to be updated first because recordlock need to use commit, so it is more complex than say
			   -- 20121212 : set stndiflag = null : for payroll need this flag null
			   --update sliptx set irefno = 'RIS#'||p_accessno, stndiflag = null where slpno = l_slpno and stnid = r.stnid_one /* and stnsts = 'N' */ /* changes 2012_10_09 : now need to search closed sliptx also */  ;
			   -- 20130131 : update stntdate
			   --update sliptx set stntdate = p_orderdate, irefno = 'RIS#'||p_accessno, stndiflag = null where slpno = l_slpno and stnid = r.stnid_one /* and stnsts = 'N' */ /* changes 2012_10_09 : now need to search closed sliptx also */  ;
			   update sliptx set irefno = 'RIS#'||p_accessno, stndiflag = null where slpno = l_slpno and stnid = r.stnid_one /* and stnsts = 'N' */ /* changes 2012_10_09 : now need to search closed sliptx also */  ;
			   if p_readdoc is not null then
			      update sliptx set doccode = p_readdoc where irefno = 'RIS#'||p_accessno and slpno = l_slpno and stnid = r.stnid_one and itmcode like '%931';
			   end if;

               --insert into xreg ( xrgid, slpno, stnid, xjbno, xrgdate, xrgsc, xrgsts, usrid )
               --  values ( seq_xreg.nextval, l_slpno, r.stnid_one, 'ris:auto', p_orderdate, decode(r.itmcode,l_hat_itmcode,0,-1), 'N', 'automatch' ) ;
			   ris_add_xreg ( l_slpno, r.stnid_one, p_orderdate, r.xrgsc ) ;

			   -- recordunlock
			   --if l_slpno is not null and l_slpno != r.slpno_one then
			   --   l_error_code := '03' ;
			   --   l_error_message := 'duplicate slpno' ;
			   --   raise e_general ;
			   --else
			   --   l_slpno := r.slpno_one ;
			   --end if ;

			   -- l_auto_match := true ;
			   -- dbms_output.put_line( 'check point : r.itmcode = l_hat_itmcode : ' || r.itmcode || ',' || l_hat_itmcode ) ;
			   if r.itmcode = l_hat_itmcode then
				  -- suppose one itmcode exist in one package, more than one itmcode exist will be considered as error
				  if l_return_stnid is null then
					 l_return_stnid := r.stnid_one ;
					 dbms_output.put_line( 'l_return_stind : ' || l_return_stnid ) ;
				  else
					 l_error_code := '05' ;
					 --l_error_message := 'duplicate return itmcode found for the package' ;
					 l_error_message := 'more than one (main exam) found in sliptx' ;
					 raise e_general ;
				  end if ;
			   end if ;

--	end if ;
			--else
			--   -- action : manual process
			--   l_error_code := '03' ;
			--   l_error_message := 'more than one slip no. with same available item' ;
			--   -- l_excess_items := true ;
			--   -- l_auto_match := false ;
			--   -- rollback ;
			--   exit ;
			--end if ;
		 end loop ;

		 if l_return_stnid is null then
			l_error_code := '06' ;
			l_error_message := 'return stnid cannot not be null' ;
			-- stop at here, why l_return_stnid is null
			raise e_general ;
		 else
			l_action_code := 'upd_sliptx' ;
			l_action_message := 'update sliptx for matched items in the given package code' ;
		 end if ;

	 end if ;
  -- no outstanding items
  else
	 -- Just take the first record of below query by place an "exit" at the end in the loop
	 --for r2 in ( select s1.* from slip s1 where s1.patno = p_patno and s1.slpsts = 'A'
	 --              and not exists ( select 1 from slip s join sliptx t on s.slpno = t.slpno /* join reg r on r.slpno = s.slpno */
	 --                                 join item i on t.itmcode = i.itmcode join excat e on e.ecccode = i.dsccode
	 --			                     where s.slpno = s1.slpno and s.patno = p_patno and ( t.pkgcode = p_examcode or t.itmcode = p_examcode ) and s.slpsts = 'A' and t.stnsts in ( 'A', 'N' ) )
	 --				and not exists ( select 1 from sliptx t where t.slpno = s1.slpno and substr( t.irefno, 1, 3 ) = 'RIS' )
	 --            order by s1.slpadoc desc ) loop
	 --	if sysdate - r2.slpadoc <= 2 then -- today or yesterday before
	 --	   l_recent_slip := true ;
	 --	   l_slpno := r2.slpno ;
	 --
	 --	   --if r2.arccode is null then
	 --	   --   l_arccode := p_arccode ;
	 --	   --else
	 --	   --   l_arccode := r2.arccode ;
	 --	   --end if ;
	 --	end if ;
	 --   -- do it once
	 --   exit ;
	 --end loop ;
	 --if l_recent_slip = true then -- (1) slip created day before yesterday or (2) No active out-patient slip exist

	 -- if slip created on today or yesterday
	 --if l_slpno is not null and sysdate - nvl(l_slpadoc,sysdate) <= 2 then : slpadoc is just for doctor payroll date

	 if p_pattype = 'H' then
	    l_error_code := '15' ;
		l_error_message := 'waiting health assessment slip entrys ' ;
		raise e_general ;
	 end if ;

   -- version : 20130201, 20140519 : [ or l_slpsts != 'A' ]
	 if l_lookup_slptype = 'I' and ( l_slpno is null or l_slpsts != 'A' ) then
	    l_error_code := '14' ;
		l_error_message := 'no active slip for inpatient' ;
		raise e_general ;
	 end if ;
     -- version : 20130123
	 if l_lookup_slptype = 'D' and ( l_slpno is null or not ( sysdate - ( to_date(to_char(substr(l_slpno, 1,4))||'0101','YYYYMMDD') + to_number(substr(l_slpno, 5,3)) -1 ) <= 2 ) ) then
		l_error_code := '07' ;
		l_error_message := 'day case with no active slip or active slip is created before yesterday' ;
		raise e_general ;
	 end if ;

	 -- if l_slpno is not null then
	 -- 20130322
	 if l_slpno is not null and ( l_lookup_slptype = 'I' or sysdate - ( to_date(to_char(substr(l_slpno, 1,4))||'0101','YYYYMMDD') + to_number(substr(l_slpno, 5,3)) -1 ) <= 2 ) then
		dbms_output.put_line( 'recent_slip : slpno : ' || l_slpno ) ;
		-- ignore the arcode and discount come from RIS
		l_locked := recordlock( 'Slip', l_slpno, l_error_message ) ;
		if l_locked then
	       commit ;
		   null ;
		else
		   rollback ;
	       raise e_lock ;
		end if ;
	    l_action_code := 'upd_slip_ins_sliptx' ;
		l_action_message := 'update slip and insert new sliptx for the given package code' ;
	 else -- no active slip or active slip is created before yesterday
	    --if l_slptype = 'D' then


		create_slip( l_doccode, p_patno, null, null, l_slpno, l_msg ) ;
		-- begin : ???, also do we need to update ther arccode in ris_add_entry
		-- update slip set arccode = p_arccode where slpno = l_slpno ;
		-- version : 20130131
		update slip set arccode = p_arccode, usrid = 'IPACS' where slpno = l_slpno ;
		-- end
		dbms_output.put_line( 'creare_slip : slpno : ' || l_slpno ) ;
		if l_msg is null then
		   -- cannot do recordlock, otherwise the data will be committed and cannot rollback
		   --l_locked := recordlock( 'Slip', l_slpno, l_error_message ) ;
		   --if l_locked then
		   --   commit ;
		   --   dbms_output.put_line( 'debug : commited to recordlock' ) ;
		   --else
	       --   rollback ;
		   --   raise e_lock ;
		   --end if ;
		   null ;
		else
	       l_error_code := '08' ;
		   l_error_message := 'cannot create slip : ' || l_msg ;
		   raise e_general ;
		end if ;

		-- use the arcode and discount come from RIS only for this case
		l_arccode := p_arccode ;
		-- 20130222 : always use p_discount
		--l_discount := p_discount ;

	    l_action_code := 'ins_slip_ins_sliptx' ;
		l_action_message := 'insert new slip and insert new sliptx for the given package code' ;
	 end if ;
	 -- because p_examcode is package, ris_add_entry will create items included in the package

	    ris_add_entry (
	      l_slpno,
	      l_doccode,
	      l_readdoc,
		  p_orderdate,
	      p_examcode,
	      'N',
	      'RIS#'||p_accessno,
	      null, -- amt should be 0 because this itmcode is package
	      l_arccode,
		  -- 20130222
		  p_discount,
	      l_stnid_list,
	      l_stnseq_list,
	      l_msg ) ;
	      if l_msg is not null then
	         l_error_code := '09' ;
	         l_error_message := 'error when add entry : ' || l_msg ;
	         raise e_general ;
	      else
             l_next := 1 ;
             loop
	           l_next_stnid := ris_get_token( l_stnid_list, l_next ) ;
		       if l_next_stnid is null then
		          exit ;
		       end if ;
		       begin
		         select decode(itmcode,l_hat_itmcode,0,-1) into l_xrgsc from sliptx where slpno = l_slpno and stnid = l_next_stnid ;
		       exception when others then
		         l_xrgsc := 1 ;  -- this issue must to be follow
		       end ;
               --insert into xreg ( xrgid, slpno, stnid, xjbno, xrgdate, xrgsc, xrgsts, usrid )
               --values ( seq_xreg.nextval, l_slpno, l_code, 'ris:auto', p_orderdate, l_xrgsc, 'N', 'automatch' ) ;
	           ris_add_xreg ( l_slpno, l_next_stnid, p_orderdate, l_xrgsc ) ;

		       l_next := l_next + 1 ;
             end loop ;
	      end if ;
	      dbms_output.put_line( 'ris_add_entry : stnid : ' || l_stnid_list ) ;
	      begin
	        select stnid into l_return_stnid from sliptx where slpno = l_slpno and instr( l_stnid_list, stnid ) > 0 and itmcode = l_hat_itmcode ;
	      exception when others then
	        null ;
	      end ;
  end if ;
  -- if l_auto_match or ( not l_outstand_items ) then
  --                                                          in fact, p_discount = amount

  -- 20140214 : begin
  if l_slpsts = 'C' and p_billcode2 || p_billcode3 || p_billcode4 || p_billcode5 || p_billcode6 is not null then
     l_error_code := '17' ;
     l_error_message := 'attempt to add sur-charge but the slip is closed' ;
     raise e_general ;
  end if ;
  -- 20140214 : end

  if p_billcode2 is not null then
     l_stnid_list := null ;
     l_stnseq_list := null ;
	 ris_add_entry ( l_slpno, l_doccode, l_readdoc, p_orderdate, p_billcode2, 'N', 'RIS#'||p_accessno, null, l_arccode, p_discount, l_stnid_list, l_stnseq_list, l_msg ) ;
	 dbms_output.put_line( 'ris_add_entry (billcode2) : stnid : ' || l_stnid ) ;
	if l_msg is not null then
	   l_error_code := '10' ;
	   l_error_message := 'error with bill code 2 : ' || l_msg ;
	   raise e_general ;
	else
       --insert into xreg ( xrgid, slpno, stnid, xjbno, xrgdate, xrgsc, xrgsts, usrid )
       --  values ( seq_xreg.nextval, l_slpno, l_stnid, 'ris:auto', p_orderdate, -1, 'N', 'automatch' ) ;
       l_next := 1 ;
       loop
         l_next_stnid := ris_get_token( l_stnid_list, l_next ) ;
		 if l_next_stnid is null then
		    exit ;
		 else
	        ris_add_xreg ( l_slpno, l_next_stnid, p_orderdate, -1 ) ;
		    l_next := l_next + 1 ;
		 end if ;
       end loop ;
	end if ;
  end if ;
  if p_billcode3 is not null then
     l_stnid_list := null ;
     l_stnseq_list := null ;
	 ris_add_entry ( l_slpno, l_doccode, l_readdoc, p_orderdate, p_billcode3, 'N', 'RIS#'||p_accessno, null, l_arccode, p_discount, l_stnid_list, l_stnseq_list, l_msg ) ;
	 dbms_output.put_line( 'ris_add_entry (billcode3) : stnid : ' || l_stnid ) ;
	if l_msg is not null then
	   l_error_code := '11' ;
	   l_error_message := 'error with bill code 3 : ' || l_msg ;
	   raise e_general ;
	else
       --insert into xreg ( xrgid, slpno, stnid, xjbno, xrgdate, xrgsc, xrgsts, usrid )
       --  values ( seq_xreg.nextval, l_slpno, l_stnid, 'ris:auto', p_orderdate, -1, 'N', 'automatch' ) ;
       l_next := 1 ;
       loop
         l_next_stnid := ris_get_token( l_stnid_list, l_next ) ;
		 if l_next_stnid is null then
		    exit ;
		 else
	        ris_add_xreg ( l_slpno, l_next_stnid, p_orderdate, -1 ) ;
		    l_next := l_next + 1 ;
		 end if ;
       end loop ;
	end if ;
  end if ;
  if p_billcode4 is not null then
     l_stnid_list := null ;
     l_stnseq_list := null ;
	 ris_add_entry ( l_slpno, l_doccode, l_readdoc, p_orderdate, p_billcode4, 'N', 'RIS#'||p_accessno, null, l_arccode, p_discount, l_stnid_list, l_stnseq_list, l_msg ) ;
	 dbms_output.put_line( 'ris_add_entry (billcode4): stnid : ' || l_stnid ) ;
	if l_msg is not null then
	   l_error_code := '12' ;
	   l_error_message := 'error with bill code 4 : ' || l_msg ;
	   raise e_general ;
	else
       --insert into xreg ( xrgid, slpno, stnid, xjbno, xrgdate, xrgsc, xrgsts, usrid )
       --  values ( seq_xreg.nextval, l_slpno, l_stnid, 'ris:auto', p_orderdate, -1, 'N', 'automatch' ) ;
       l_next := 1 ;
       loop
         l_next_stnid := ris_get_token( l_stnid_list, l_next ) ;
		 if l_next_stnid is null then
		    exit ;
		 else
	        ris_add_xreg ( l_slpno, l_next_stnid, p_orderdate, -1 ) ;
		    l_next := l_next + 1 ;
		 end if ;
       end loop ;
	end if ;
  end if ;
-- version : 20121024
  if p_billcode5 is not null then
     l_stnid_list := null ;
     l_stnseq_list := null ;
	 ris_add_entry ( l_slpno, l_doccode, l_readdoc, p_orderdate, p_billcode5, 'N', 'RIS#'||p_accessno, null, l_arccode, p_discount, l_stnid_list, l_stnseq_list, l_msg ) ;
	 dbms_output.put_line( 'ris_add_entry (billcode5): stnid : ' || l_stnid ) ;
	if l_msg is not null then
	   l_error_code := '12' ;
	   l_error_message := 'error with bill code 5 : ' || l_msg ;
	   raise e_general ;
	else
       --insert into xreg ( xrgid, slpno, stnid, xjbno, xrgdate, xrgsc, xrgsts, usrid )
       --  values ( seq_xreg.nextval, l_slpno, l_stnid, 'ris:auto', p_orderdate, -1, 'N', 'automatch' ) ;
       l_next := 1 ;
       loop
         l_next_stnid := ris_get_token( l_stnid_list, l_next ) ;
		 if l_next_stnid is null then
		    exit ;
		 else
	        ris_add_xreg ( l_slpno, l_next_stnid, p_orderdate, -1 ) ;
		    l_next := l_next + 1 ;
		 end if ;
       end loop ;
	end if ;
  end if ;
  if p_billcode6 is not null then
     l_stnid_list := null ;
     l_stnseq_list := null ;
	 ris_add_entry ( l_slpno, l_doccode, l_readdoc, p_orderdate, p_billcode6, 'N', 'RIS#'||p_accessno, null, l_arccode, p_discount, l_stnid_list, l_stnseq_list, l_msg ) ;
	 dbms_output.put_line( 'ris_add_entry (billcode6): stnid : ' || l_stnid ) ;
	if l_msg is not null then
	   l_error_code := '12' ;
	   l_error_message := 'error with bill code 6 : ' || l_msg ;
	   raise e_general ;
	else
       --insert into xreg ( xrgid, slpno, stnid, xjbno, xrgdate, xrgsc, xrgsts, usrid )
       --  values ( seq_xreg.nextval, l_slpno, l_stnid, 'ris:auto', p_orderdate, -1, 'N', 'automatch' ) ;
       l_next := 1 ;
       loop
         l_next_stnid := ris_get_token( l_stnid_list, l_next ) ;
		 if l_next_stnid is null then
		    exit ;
		 else
	        ris_add_xreg ( l_slpno, l_next_stnid, p_orderdate, -1 ) ;
		    l_next := l_next + 1 ;
		 end if ;
       end loop ;
	end if ;
  end if ;
-- version : 20121024

  -- l_ris_rtn_code : like error code
  --p_his_update_stnid_test( p_accessno, l_slpno, l_return_stnid, l_ris_rtn_code, l_ris_rtn_msg ) ;
  select count(1) into l_meta_billing_cnt from spectra.meta_billing@ris where ris_accession_no = p_accessno ;

  spectra.p_his_update_stnid@ris( p_accessno, l_slpno, l_return_stnid, l_ris_rtn_code, l_ris_rtn_msg ) ;

  --log() ;
  update ris_auto_match_log set status = 'MATCHED', error_code = l_error_code, error_message = l_error_message, action_code = l_action_code, action_message = l_action_message || ', slpno : ' || l_slpno || ', stnid : ' || l_return_stnid || ', meta_bill_cnt : ' || to_char(l_meta_billing_cnt),
    slpno = l_slpno, stnid = l_return_stnid
   where accessno = p_accessno and status = 'LOG' and logno = p_logno ; -- ( select min(log_date) from ris_auto_match_log where accessno = p_accessno and status = 'LOG' ) ;
  l_locked := recordunlock( 'Slip', l_slpno ) ;
  commit ;

exception
  when e_general then
    rollback ;
    --log() ;
    --commit ;
	update ris_auto_match_log set status = 'FAILED', error_code = l_error_code, error_message = l_error_message,
      slpno = l_slpno, stnid = l_return_stnid
     where accessno = p_accessno and status = 'LOG' and logno = p_logno ; -- ( select min(log_date) from ris_auto_match_log where accessno = p_accessno and status = 'LOG' ) ;
	 -- 20130109 : check have locked the record before unlock
	if l_locked then
	   l_locked := recordunlock( 'Slip', l_slpno ) ;
	end if ;
	commit ;
  when e_lock then
    rollback ;
    l_error_code := '98' ;
    l_error_message := 'Cannot lock slip#' || l_slpno || ', ' || l_error_message ;
	update ris_auto_match_log set status = 'FAILED', error_code = l_error_code, error_message = l_error_message,
      slpno = l_slpno, stnid = l_return_stnid
     where accessno = p_accessno and status = 'LOG' and logno = p_logno ; -- ( select min(log_date) from ris_auto_match_log where accessno = p_accessno and status = 'LOG' ) ;

	-- 20130208 begin
	-- stop at here : wait for clear how to add tellog
    -- p_add_tellog2( 'RIS', l_slpno, p_examcode, null, 'Auto match ( from RIS to HATS ) failed, ' || l_error_message, 1, 'RIS#'||p_accessno, null, l_slpno ) ;
	-- 20130208 end

    --log() ;
    --commit ;
	-- below is an error : becasue e_lock exception mean u cannot lock the record, so don't unlock the record that another user locked
	--l_locked := recordunlock( 'Slip', l_slpno ) ;
	commit ;

  when others then
    rollback ;
	l_error_code := '99' ;
	l_error_message := 'sql error, ' || sqlcode || ' : ' || sqlerrm ;
	update ris_auto_match_log set status = 'FAILED', error_code = l_error_code, error_message = l_error_message,
      slpno = l_slpno, stnid = l_return_stnid
     where accessno = p_accessno and status = 'LOG' and logno = p_logno ; --( select min(log_date) from ris_auto_match_log where accessno = p_accessno and status = 'LOG' ) ;
    --log() ;
    --commit ;
	 -- 20130109 : check have locked the record before unlock
	if l_locked then
	   l_locked := recordunlock( 'Slip', l_slpno ) ;
	end if ;
	commit ;
end ;
/

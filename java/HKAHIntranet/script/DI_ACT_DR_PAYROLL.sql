create or replace
PROCEDURE DI_ACT_DR_PAYROLL 
(
  v_action in varchar2,
  v_startdt in date,
  v_enddt in date,
  v_rptdrcode_in in varchar2,
  vi_actualrun in varchar2,
  v_userid in varchar2,
  o_ret out number
)
as
  v_actualrun_log varchar2(1);
  fail_pre_gen_report exception;
  fail_gen_rpt_data exception;
begin
  o_ret := 0;
  
  if v_action = 'PRE_GEN_RPT' then
    /* prepare temp record */
    o_ret := hkah.di_utl_pre_gen_report@iweb(v_enddt);
    if o_ret < 0 then
      raise fail_pre_gen_report;
    end if;
  end if;
  
  if v_action = 'GEN_RPT' then
    /* prepare temp record */
    o_ret := hkah.di_utl_pre_gen_report@iweb(v_enddt);
    if o_ret < 0 then
      raise fail_pre_gen_report;
    end if;
    
  	/* remove all month-end trial data */
    if vi_actualrun = 'Y' then
  		delete from docincome2@iweb where actualrun = 'N';
  	end if;
  	
  	/* generate report data */
    HKAH.DI_PAYROLL@iweb(V_STARTDT, V_ENDDT, V_RPTDRCODE_IN, VI_ACTUALRUN, o_ret);
  	if o_ret >= 0 then
  		/* audit log */
  		if vi_actualrun = 'Y' then
  			v_actualrun_log := 'A';
  		else 
  			v_actualrun_log := 'T';
  		end if;
  		
		insert into 
			di_print_history@iweb(report_id,print_date,print_user,actual_trial,from_date,to_date)
		values 
			('XD5', sysdate, v_userid, v_actualrun_log, v_startdt, v_enddt);
  	else 
  		raise fail_gen_rpt_data;
  	end if;
  	
  end if;
    
  if v_action = 'RM_TRAIL_DATA' then
  	/* remove all month-end trial data */
  	delete from docincome2@iweb where actualrun = 'N';
  	o_ret := 3000;
  end if;
  
exception
  when fail_pre_gen_report then
    dbms_output.put_line('Fail to pre-generate report.');
    o_ret := -2001;
  when fail_gen_rpt_data then
    dbms_output.put_line('Fail generate report data.');
    /* return o_ret from DI_PAYROLL */
  when others then
    dbms_output.put_line('DI_ACT_DR_PAYROLL: ' || SQLCODE || SQLERRM);
    rollback;
    o_ret := -9999;
END DI_ACT_DR_PAYROLL;
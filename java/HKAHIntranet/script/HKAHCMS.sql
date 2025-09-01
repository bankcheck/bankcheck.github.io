create or replace
FUNCTION        "CMS_LIS_WAITINGQUEUE" 
(
  v_doctor_id in varchar2,
  v_arrive_time in varchar2,
  v_book_time in varchar2,
  v_reg_type in varchar2
)
return
TYPES.cursor_type
AS
outcur types.cursor_type;
l_count integer;
begin
     open outcur for
      ------------------
      -- edited for portal
      ------------------

      select 
        null as regid,
        (select patidno from patient@iweb pat  where pat.patno = booking.patno) as patidno, 
        --(select doccode from schedule@iweb where schedule.schid = booking.schid) as doccode,  
        (select docfname || ' ' || docgname from schedule@iweb, doctor@iweb where schedule.schid = booking.schid  and schedule.doccode = doctor.doccode) as docname,
        --'N' as regopcat, 
        patno, 
        bkgpname as patname,  
        bkgpcname as patcname,  
        (select patsex from patient@iweb pat  where pat.patno = booking.patno) as gender,
        (select DECODE(SIGN(TO_NUMBER(TO_CHAR(SYSDATE,'MM'))-TO_NUMBER(TO_CHAR(P.PATBDATE,'MM'))), -1, 
          (to_number(to_char(sysdate,'YYYY'))-to_number(to_char(p.patbdate,'YYYY'))-1)||'yr '|| 
          (12-(TO_NUMBER(TO_CHAR(P.PATBDATE,'MM'))-TO_NUMBER(TO_CHAR(SYSDATE,'MM'))))||'mths', 
          0, (to_number(to_char(sysdate,'YYYY'))-to_number(to_char(p.patbdate,'YYYY')))||'yr ', 
          1, (to_number(to_char(sysdate,'YYYY'))-to_number(to_char(p.patbdate,'YYYY')))||'yr '|| 
          (to_number(to_char(sysdate,'MM'))-to_number(to_char(p.patbdate,'MM')))||'mths')
         from patient@iweb p where p.patno = booking.patno) as age,
         
        (select r.regdate from reg@iweb r where booking.bkgid = r.bkgid) as arrive_time,
        bkgsdate as appt_time,  
        
      
        'O' as regtype,
        null as visit_type, 
        null as ticketno,
        'Waiting',
        ''
        
        --null as regdate,  
         
        --null as regid,  
         
        
        --null as note_sts,  
        --null as end_date, 
        --null as regsts,  
        --bkgid,
        --bkgsts,  
        --0 as nx_note_done,  
        --0 as dr_cslted_sts,  
        --0 as dr_cslting_sts,  
        --0 as dr_calling_sts,  
        --0 as nx_cslted_sts,  
        --0 as nx_cslting_sts,  
        --0 as nx_calling_sts,  
        --' ' as c_visible 
      from booking@iweb booking  
      where 
        bkgsts <> 'F'  and 
        booking.bkgsdate >= to_date('20120307', 'yyyymmdd')  and 
        booking.bkgsdate < 1+to_date('20120307', 'yyyymmdd')  
      
      UNION
      
      select 
        regid,
        (select patidno from patient@iweb pat where pat.patno = qry_reg.patno) as patidno,
        --doccode,
        (select docfname || ' ' || docgname from doctor@iweb doc where doc.doccode = qry_reg.doccode) docname,
        --regopcat, 
        patno,
        (select nvl(patfname, ' ') || ' ' || nvl(patgname, ' ') from patient@iweb pat where pat.patno = qry_reg.patno) as patname,
        (select patcname from patient@iweb pat where pat.patno = qry_reg.patno) as patcname,
        (select patsex from patient@iweb pat where pat.patno = qry_reg.patno) as gender,
        (select DECODE(SIGN(TO_NUMBER(TO_CHAR(SYSDATE,'MM'))-TO_NUMBER(TO_CHAR(P.PATBDATE,'MM'))), -1, 
          (to_number(to_char(sysdate,'YYYY'))-to_number(to_char(p.patbdate,'YYYY'))-1)||'yr '|| 
          (12-(TO_NUMBER(TO_CHAR(P.PATBDATE,'MM'))-TO_NUMBER(TO_CHAR(SYSDATE,'MM'))))||'mths', 
          0, (to_number(to_char(sysdate,'YYYY'))-to_number(to_char(p.patbdate,'YYYY')))||'yr ', 
          1, (to_number(to_char(sysdate,'YYYY'))-to_number(to_char(p.patbdate,'YYYY')))||'yr '|| 
          (to_number(to_char(sysdate,'MM'))-to_number(to_char(p.patbdate,'MM')))||'mths')
         from patient@iweb p where p.patno = qry_reg.patno) as age,
        
        regdate as arrive_time,
        (select bkgsdate from booking@iweb booking where booking.bkgid = qry_reg.bkgid) as appt_time,  
        
        regtype,
        (select pkgname from package@iweb pkg where pkg.pkgcode = qry_reg.pkgcode) as visit_type,
        case when (regopcat='N') then '' when (regopcat is null) then '' else regopcat end || ticketno as ticketno,
        'Waiting',
        ''
        --regdate,
        --regid,
        
        
        --(select note_sts from opd_docnote@cis note where note.regid = qry_reg.regid) as note_sts,
        --(select update_date from opd_docnote@cis note where note.regid = qry_reg.regid) as end_date,
        --regsts,
        --bkgid,
        --(select bkgsts from booking@iweb booking where booking.bkgid = qry_reg.bkgid) as bkgsts,
        --((select count(*) from opd_nx_note@cis notes where notes.regid = qry_reg.regid) + (select count(*) from opd_nx_note_rmk@cis rmk where rmk.regid = qry_reg.regid) ) as nx_note_done,
        --(select count(*) from pat_activity_log@cis plog where plog.regid = qry_reg.regid and action = 'DR_CSLT' and endtime is not null) as dr_cslted_sts,
        --(select count(*) from pat_activity_log@cis plog 
        -- where 
        --  plog.regid = qry_reg.regid and 
        --  action = 'DR_CSLT' and 
        --  (endtime is null) and 
        --  (log_sts = 'A' or log_sts is null)
        --) as dr_cslting_sts,
        --(select count(*) from pat_activity_log@cis plog where plog.regid = qry_reg.regid and action = 'DR_CALL' and (endtime is null) and (log_sts = 'A' or log_sts is null)) as dr_calling_sts,
        --(select count(*) from pat_activity_log@cis plog where plog.regid = qry_reg.regid and action = 'NX_CSLT' and endtime is not null) as nx_cslted_sts,
        --(select count(*) from pat_activity_log@cis plog where plog.regid = qry_reg.regid and action = 'NX_CSLT' and (endtime is null) and (log_sts = 'A' or log_sts is null)) as nx_cslting_sts,
        --(select count(*) from pat_activity_log@cis plog where plog.regid = qry_reg.regid and action = 'NX_CALL' and (endtime is null) and (log_sts = 'A' or log_sts is null)) as nx_calling_sts,
        --' ' as c_visible
      FROM QRY_REG@cis
      where 
        1 = 1 and 
        qry_reg.regdate >= to_date('20120307', 'yyyymmdd')  and 
        qry_reg.regdate < 1+to_date('20120307', 'yyyymmdd')  and 
        qry_reg.regtype = 'O';

    return outcur;
end CMS_LIS_WAITINGQUEUE;



create or replace
FUNCTION        "CMS_ACT_WAITINGQUEUE" 
  (
    p_action		in varchar2,
    p_sub_action		in varchar2,
    p_id		    in varchar2,
    o_errmsg    out varchar2
  )
return number
as
  o_errcode number;
  v_noofrec number;
  v_id number;
  v_status_id number;
  v_book_time date;
begin
       commit; 
   execute immediate 'ALTER SESSION CLOSE database link cms';
     
  o_errcode := 0;
  o_errmsg := 'OK';
  v_id := to_number(p_id);

  select count(1) into v_noofrec from waiting_queue_hats where id = to_number(p_id);
  if p_action = 'ADD' then
    o_errcode := -1;
    o_errmsg := 'Function is under development.';
	elsif p_action = 'MOD' then
    if v_noofrec > 0 then
      if p_sub_action = 'CANCEL' then
        select status_id, book_time into v_status_id, v_book_time from waiting_queue_hats where id = v_id;
        if v_status_id = 2 and v_book_time is not null then 
          update waiting_queue_hats@cms
          set
            status_id     = 1,
            last_updated = sysdate,
            updated_by = ''
          where	id = v_id;
        elsif v_status_id in (1, 2) then
          update waiting_queue_hats
          set
            status_id     = 7,
            last_updated = sysdate,
            updated_by = ''
          where	id = v_id;
        else 
          o_errcode := -1;
          o_errmsg := 'The queue is not in Waiting or Booked status.';
        end if;  
      end if;
    else
      o_errcode := -1;
      o_errmsg := 'Fail to update due to record not exist.';
    end if;
	elsif p_action = 'DEL' then
    o_errcode := -1;
    o_errmsg := 'Function is under development.';
  end if;
  
  commit;
  return o_errcode;
end CMS_ACT_WAITINGQUEUE;



create or replace
FUNCTION        "CMS_LIS_INPLIST" 
(
  v_pat_info in varchar2,
  v_doctor_id in varchar2,
  v_ward in varchar2,
  v_bed in varchar2,
  v_admdate_fm in varchar2,
  v_admdate_to in varchar2,
  v_dischdate_fm in varchar2,
  v_dischdate_to in varchar2,  
  v_status in varchar2
)
return
TYPES.cursor_type
AS
  outcur types.cursor_type;
  l_count integer;
  l_pat_info varchar2(1000);
  l_ward varchar2(20);
  l_bed varchar2(20);
  sqlstr varchar2(2000);
begin

  l_pat_info := upper(v_pat_info);
  l_ward := upper(v_ward);
  l_bed := upper(v_bed); 
   
   /*
      select 
      i.inpid,
      p.patno,
      p.patfname || case when p.patgname is null then '' else ' ' || p.patgname end,
      p.patcname,
      f_age_in_char@cis(p.patbdate),
      p.patsex,
      w.wrdname,
      b.bedcode,
      ac.acmname,
      to_char(r.regdate, 'dd/mm/yyyy') adm_date,
      to_char(i.inpddate, 'dd/mm/yyyy') disch_date,
      nvl(da.docfname, '') || ' ' || nvl(da.docgname, '') adm_doc,
      nvl(dt.docfname, '') || ' ' || nvl(dt.docgname, '') treat_doc,
      b.extphone
    from patient@iweb p 
      inner join reg@iweb r on p.patno = r.patno
      inner join inpat@iweb i on r.inpid = i.inpid
      left join bed@iweb b on i.bedcode = b.bedcode
      left join room@iweb rm on b.romcode = rm.romcode
      left join ward@iweb w on rm.wrdcode = w.wrdcode
      left join acm@iweb ac on i.acmcode = ac.acmcode      
      left join doctor@iweb da on i.doccode_a = da.doccode    
      left join doctor@iweb dt on r.doccode = dt.doccode 
    where
    (
      (v_status = 'C' and r.regsts = 'N' and i.inpddate is null)	-- (status = Current)
      or 
      (v_status = 'D' and r.regsts = 'N' and i.inpddate is not null)
    )
    (upper(p.patno) like '%' || l_pat_info || '%'
        or upper(p.patfname) like '%' || l_pat_info || '%'
        or upper(p.patgname) like '%' || l_pat_info || '%'
        or upper(p.patcname) like '%' || l_pat_info || '%'
        --or upper(p.patidno) like '%' || l_pat_info || '%'
        or to_char(p.patbdate, 'dd/mm/yyyy') = l_pat_info
        --or upper(p.pathtel) like '%' || l_pat_info || '%'
        --or upper(p.patotel) like '%' || l_pat_info || '%'
        --or upper(p.patpager) like '%' || l_pat_info || '%'
        --or upper(p.patfaxno) like '%' || l_pat_info || '%'
    )
    and (da.doccode = v_doctor_id or dt.doccode = v_doctor_id)
    and
    (upper(w.wrdcode) = ''' || l_ward || '''
        or upper(w.wrdname) like ''%'' || ''' || l_ward || ''' || ''%''
    )
    and 
    (upper(b.bedcode) like '%' || l_bed || '%'
        --or upper(b.beddesc) like '%' || l_bed || '%'
    )   
    and (v_admdate_fm is null or (v_admdate_fm is not null and trunc(r.regdate) >= to_date(v_admdate_fm, 'dd/mm/yyyy')))
    and (v_admdate_to is null or (v_admdate_to is not null and trunc(r.regdate) <= to_date(v_admdate_to, 'dd/mm/yyyy')))
    and (v_dischdate_fm is null or (v_dischdate_fm is not null and trunc(i.inpddate) >= to_date(v_dischdate_fm, 'dd/mm/yyyy')))
    and (v_dischdate_to is null or (v_dischdate_to is not null and trunc(i.inpddate) <= to_date(v_dischdate_to, 'dd/mm/yyyy')))    
    order by r.regdate desc;
   
   */
   
   
	sqlstr:='select
      i.inpid,
      p.patidno,
      to_char(p.patbdate, ''dd/MM/yyyy''),
      p.patfname,
      p.patgname,
      p.patno,
      p.patfname || case when p.patgname is null then '''' else '' '' || p.patgname end,
      p.patcname,
      f_age_in_char@cis(p.patbdate),
      p.patsex,
      w.wrdname,
      b.bedcode,
      ac.acmname,
      to_char(r.regdate, ''dd/mm/yyyy hh24:mi:ss'') adm_date,
      to_char(i.inpddate, ''dd/mm/yyyy hh24:mi:ss'') disch_date,
      nvl(da.docfname, '''') || '' '' || nvl(da.docgname, '''') adm_doc,
      nvl(dt.docfname, '''') || '' '' || nvl(dt.docgname, '''') treat_doc,
      b.extphone
    from patient@iweb p 
      inner join reg@iweb r on p.patno = r.patno
      inner join inpat@iweb i on r.inpid = i.inpid
      left join bed@iweb b on i.bedcode = b.bedcode
      left join room@iweb rm on b.romcode = rm.romcode
      left join ward@iweb w on rm.wrdcode = w.wrdcode
      left join acm@iweb ac on i.acmcode = ac.acmcode      
      left join doctor@iweb da on i.doccode_a = da.doccode    
      left join doctor@iweb dt on r.doccode = dt.doccode 
    where 
  ';
 
  if v_status = 'C' then
    sqlstr:=sqlstr||' r.regsts = ''N'' and i.inpddate is null';
  elsif v_status = 'D' then
    sqlstr:=sqlstr||' r.regsts = ''N'' and i.inpddate is not null';
  else 
    sqlstr:=sqlstr||' r.regsts = ''N''';
	end if;
  
  if l_pat_info is not null then
    sqlstr:=sqlstr||' 
    and 
    (upper(p.patno) like ''%'' || ''' || l_pat_info || ''' || ''%''
        or upper(p.patfname) like ''%'' || ''' || l_pat_info || ''' || ''%''
        or upper(p.patgname) like ''%'' || ''' || l_pat_info || ''' || ''%''
        or upper(p.patcname) like ''%'' || ''' || l_pat_info || ''' || ''%''
        or to_char(p.patbdate, ''dd/mm/yyyy'') = ''' || l_pat_info || '''
    )';
  end if;
  
  if v_doctor_id is not null then
    sqlstr:=sqlstr||' 
    and (da.doccode =  ''' || v_doctor_id || ''' or dt.doccode = ''' || v_doctor_id || ''')
    ';
  end if;
  
  if l_ward is not null then
    sqlstr:=sqlstr||' 
    and
    (upper(w.wrdcode) = ''' || l_ward || '''
        or upper(w.wrdname) like ''%'' || ''' || l_ward || ''' || ''%''
    )
    ';
  end if;

  if l_bed is not null then
    sqlstr:=sqlstr||' 
    and 
    (upper(b.bedcode) like ''%'' || ''' || l_bed || ''' || ''%'') 
    ';
  end if;
  
  if v_admdate_fm is not null then  
    sqlstr:=sqlstr||' 
    and trunc(r.regdate) >= to_date(''' || v_admdate_fm || ''', ''dd/mm/yyyy'')
    ';
  end if;
  
  if v_admdate_to is not null then  
    sqlstr:=sqlstr||' 
    and trunc(r.regdate) <= to_date(''' || v_admdate_to || ''', ''dd/mm/yyyy'')
    ';
  end if;
  
  if v_dischdate_fm is not null then  
    sqlstr:=sqlstr||' 
    and trunc(i.inpddate) >= to_date(''' || v_dischdate_fm || ''', ''dd/mm/yyyy'')
    ';
  end if;
  
  if v_dischdate_to is not null then  
    sqlstr:=sqlstr||' 
    and trunc(i.inpddate) <= to_date(''' || v_dischdate_to || ''', ''dd/mm/yyyy'')
    ';
  end if;
  
  sqlstr:=sqlstr||' order by r.regdate desc';

 -- dbms_output.put_line('sql:'||sqlstr);

  OPEN outcur FOR sqlstr;
  return outcur;
end "CMS_LIS_INPLIST";



create or replace
FUNCTION        "CMS_LIS_USER" 
(
  v_type in varchar2,
  v_doctor_id in varchar2,
  v_uni_search in varchar2
)
return
TYPES.cursor_type
AS
outcur types.cursor_type;
begin
     open outcur for
      select
        id,
        --active,
        cname,
        --date_created,
        --EMAIL,
        --last_updated,
        --medical_council_reg_no,
        --mobile,
        name,
        --PASSWORD_HASH,
        --tel,
        title
        --USER_PROFILE_ID
      from user_hats@cms
      where 
        --id = v_doctor_id or v_doctor_id is null
        --and 
        --username like 'doctor.10%'
        (upper(username) like '%' || upper(v_uni_search) || '%'
          or upper(cname) like '%' || upper(v_uni_search) || '%'
          or upper(name) like '%' || upper(v_uni_search) || '%'
        )
        and active = 1
      order by name, cname;
     return outcur;
end CMS_LIS_USER;


create or replace
FUNCTION        "CMS_LIS_CLASSIFICATION" 
(
  v_type in varchar2,
  v_code in varchar2,
  v_uni_search in varchar2
)
return
TYPES.cursor_type
AS
outcur types.cursor_type;
begin
     open outcur for
      select
        id,
        CODE,
        description
      --from classification@cms
      from temp_cms_classification
      where
        (upper(code) like '%' || upper(v_uni_search) || '%'
          or upper(DESCRIPTION) like '%' || upper(v_uni_search) || '%'
        )
        and active = 1
        and is_public = 1
      order by code;

     return outcur;
end CMS_LIS_CLASSIFICATION;


create or replace
FUNCTION CMS_CMB_WARD
  RETURN types.cursor_type
as
  outcur types.cursor_type;
BEGIN
  open outcur for
      SELECT wrdcode, wrdname
      FROM WARD@IWEB
      --WHERE ROWNUM < 100
      ORDER BY wrdcode;
   RETURN OUTCUR;
END CMS_CMB_WARD;


create or replace
FUNCTION        "CMS_CMB_DOCTOR" 
(
  v_doc_info in varchar2
)
return
TYPES.cursor_type
as
  outcur types.cursor_type;
  l_doc_info varchar2(1000);
  sqlstr varchar2(2000);
begin

  l_doc_info := upper(v_doc_info);
  
	sqlstr:='
    select
      doccode,
      docfname,
      docgname
    from doctor@iweb      
  ';

  if l_doc_info is not null then
    sqlstr:=sqlstr||' 
      where 
      (upper(doccode) like ''%'' || ''' || l_doc_info || ''' || ''%''
          or upper(docfname) like ''%'' || ''' || l_doc_info || ''' || ''%''
          or upper(docgname) like ''%'' || ''' || l_doc_info || ''' || ''%''
      )
    ';
  end if;
  
  sqlstr:=sqlstr||' order by docfname, docgname, doccode'; 
  
  OPEN outcur FOR sqlstr;
  return outcur;
end CMS_CMB_DOCTOR;


create or replace
function cms_cmb_bed
(
  v_bedsts in varchar2
)
  RETURN types.cursor_type
as
  outcur types.cursor_type;
  l_bedsts varchar2(1);
begin
  l_bedsts := upper(v_bedsts);
  OPEN OUTCUR FOR
      SELECT BEDCODE, BEDDESC
      from bed@iweb
      WHERE  (l_bedsts is not null and BEDSTS = l_bedsts)
      ORDER BY BEDCODE ;
   RETURN OUTCUR;
END cms_cmb_bed;
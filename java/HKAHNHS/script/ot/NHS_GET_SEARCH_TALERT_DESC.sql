create or replace
function NHS_GET_SEARCH_TALERT_DESC
(
   v_patnum in varchar2,
   v_emailAddrs in varchar2
)
return types.cursor_type as
  outcur types.cursor_type;
  v_altid alert.altid%type;
  v_altcode alert.altcode%type;
  v_altdesc alert.altdesc%TYPE;
  v_emailAddrs_temp varchar2(2000);
  v_addr varchar2(200);
  v_altdesc_str varchar2(2000);
  v_patfname patient.patfname%type;
  v_patgname patient.patgname%type;
begin
  v_altdesc_str := '';
  v_emailaddrs_temp := v_emailaddrs;

  while v_emailaddrs_temp is not null
  loop
    if instr(v_emailaddrs_temp,',') = 0 then
      v_addr := trim(substr(v_emailaddrs_temp,0, length(v_emailaddrs_temp)));
      v_emailAddrs_temp := '';
    else
	    v_addr := trim(substr(v_emailaddrs_temp,0, instr(v_emailaddrs_temp,',')-1));
      v_emailaddrs_temp := substr(v_emailaddrs_temp, instr(v_emailaddrs_temp,',')+1);
    end if;
  end loop;

  select patfname, patgname into v_patfname, v_patgname from patient where patno = v_patnum;

  open outcur for
    select '', v_patfname, v_patgname from dual;
  return outcur;
end NHS_GET_SEARCH_TALERT_DESC;
/
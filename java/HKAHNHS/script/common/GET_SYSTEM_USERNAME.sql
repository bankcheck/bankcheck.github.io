CREATE OR REPLACE FUNCTION "GET_SYSTEM_USERNAME" (in_system varchar2, in_userid varchar2)
  RETURN VARCHAR2
AS
  vi_exist integer;
  vs_exist_sql varchar2(1000);
  vs_name VARCHAR2(1000);
BEGIN
  if lower(in_system) = 'cis' or lower(in_system) = 'ais' then
--    select user_name into vs_name from ah_sys_user
--    where trim(upper(user_id)) = trim(upper(in_userid));
    vs_name := 'user';
  end if;

  if lower(in_system) = 'hat' then
    begin
--       select docfname || ' ' || docgname into vs_name
--       from hat_doctor where upper(doccode) = upper(substr(in_userid, 3, length(in_userid) - 2));
      vs_name := 'doctor';
       EXCEPTION WHEN OTHERS THEN vs_name := '';
    end;

   if vs_name is null or length(trim(vs_name)) = 0 then
--     select USRNAME into vs_name
--     from hat_usr where upper(USRID) = trim(upper(in_userid));
      vs_name := 'nobody';
   end if;
  end if;

  if lower(in_system) = 'phar' then
    begin
      select count(*) into vi_exist from all_db_links where UPPER(DB_LINK) like UPPER('phar%');
      EXCEPTION WHEN OTHERS THEN vi_exist := 0;
    end;

    if vi_exist > 0 then
      vs_exist_sql :=  'select user_name from phar_users' ||
        ' where upper(user_id) = trim(upper(''' || in_userid || '''))';
      EXECUTE IMMEDIATE vs_exist_sql into vs_name;
    end if;
  end if;

RETURN vs_name;

EXCEPTION
    WHEN OTHERS THEN
       vs_name := in_userid;
        RETURN vs_name;
END;
/



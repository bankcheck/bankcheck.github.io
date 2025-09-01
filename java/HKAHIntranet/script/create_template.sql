alter table
  <table_name>
add (
  <module_prefix>_CREATED_DATE DATE default SYSDATE,  
  <module_prefix>_CREATED_USER VARCHAR2(30 BYTE) default 'SYSTEM',
  <module_prefix>_MODIFIED_DATE DATE default SYSDATE,
  <module_prefix>_MODIFIED_USER VARCHAR2(30 BYTE) default 'SYSTEM',
  <module_prefix>_ENABLED NUMBER default 1
);
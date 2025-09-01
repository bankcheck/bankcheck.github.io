create or replace function "NHS_LIS_ITEMCHARGE"
(v_itemcode in item.itmcode%TYPE,
 v_itemtype in item.itmtype%TYPE,
 v_userdept in varchar2
)
return types.cursor_type as
outcur types.cursor_type;
sqlbuf varchar2(500);
begin 
	sqlbuf := 'Select
            '' '',
             ITMCODE,
             ITMNAME,
             ITMTYPE,
             ITMRLVL,
             DSCCode,
             DptCode from Item
             where itmcat<>''C'' 
             ';
       if v_itemcode is not null then
       	sqlbuf := sqlbuf || ' AND itmcode=''' || v_itemcode || '''';
       end if;
       if v_itemtype is not null then
        	sqlbuf := sqlbuf || ' AND itmtype=''' || v_itemtype || '''';
       end if;
      if v_userdept is not null then 
      	sqlbuf := sqlbuf || ' AND DptCode=''' || v_userdept || '''';
      end if;
        sqlbuf := sqlbuf || ' order by ItmCode';
      open outcur for	sqlbuf;
      return outcur;
end NHS_LIS_ITEMCHARGE;
/

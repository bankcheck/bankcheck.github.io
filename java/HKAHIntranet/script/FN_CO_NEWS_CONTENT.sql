create or replace
FUNCTION FN_CO_NEWS_CONTENT (
as_news_id varchar2)
Return Clob As 
ls_content_c clob;
li_count integer;
BEGIN
  li_count  := 0;
  for r in (select SUBSTR(co_content , 0, 900) co_content2, co_content from CO_NEWS_content where co_news_category = 'renov.upd' and co_news_id = as_news_id)
  loop
    ls_content_c := ls_content_c || r.co_content;
    li_count := li_count + 1;
  end loop;  
  RETURN ls_content_c;
END FN_CO_NEWS_CONTENT;
/
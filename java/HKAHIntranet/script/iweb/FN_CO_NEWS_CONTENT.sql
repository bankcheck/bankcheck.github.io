create or replace
FUNCTION FN_CO_NEWS_CONTENT (
as_news_id varchar2)
RETURN clob AS 
ls_content varchar2(32000);
li_count integer;
BEGIN
  li_count  := 0;
  for r in (select SUBSTR(co_content , 0, 900) co_content2, co_content from CO_NEWS_content where co_news_category = 'renov.upd' and co_news_id = as_news_id)
  loop
    --ls_content := ls_content || r.co_content;
    ls_content := ls_content || r.co_content;
    li_count := li_count + 1;
  end loop;  
  RETURN ls_content;
  --RETURN to_char(li_count);
END FN_CO_NEWS_CONTENT;
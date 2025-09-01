DROP TYPE SPA_pay_tab;
DROP TYPE SPA_pay_obj;
DROP TYPE SPA_chg_tab;
DROP TYPE SPA_chg_obj;
DROP TYPE SPA_pay_chg_row;
DROP TYPE SPA_pay_chg_col;

create or replace TYPE SPA_pay_obj IS object ( key VARCHAR2(50), stntype varchar2(1), itmcode varchar2(10), stndesc varchar2(80), stnxref number(22), stncdate date, payref number(22), arccode varchar2(5), stnnamt float(126), pay_amt float(126), pay_order number(5) ) ;
/
create or replace TYPE SPA_pay_tab is table of SPA_pay_obj ;
/
create or replace TYPE SPA_chg_obj IS object ( stnid number(22), pkgcode varchar2(10), itmcode varchar2(10), stndesc varchar2(80), doccode varchar2(10), stncdate date, stnnamt float(126), pcyid number(22) ) ;
/
create or replace TYPE SPA_chg_tab is table of SPA_chg_obj ;
/
create or replace TYPE SPA_pay_chg_col is table of NUMBER(12,4) ;
/
create or replace TYPE SPA_pay_chg_row is table of SPA_pay_chg_col ;
/

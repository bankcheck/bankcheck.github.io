ALTER TABLE CE_APPROVED_TRANS
 DROP PRIMARY KEY CASCADE;
DROP TABLE CE_APPROVED_TRANS CASCADE CONSTRAINTS;

CREATE TABLE CE_APPROVED_TRANS
(
 CE_APPROVED_TRANS_ID NUMBER(*,0) NOT NULL ENABLE,
 CE_SITE_CODE VARCHAR2(10 BYTE) NOT NULL ENABLE,
 CE_APPROVED_DATE DATE NOT NULL,
 CE_STAFF_ID VARCHAR2(10 BYTE) NOT NULL,
 CE_CATEGORY VARCHAR2(1 BYTE) DEFAULT 'O',  --[N]using,[O]ther,[A]uxiliary
 CE_DEPT_NAME VARCHAR2(30 BYTE) NOT NULL,
 CE_AMOUNT NUMBER(*,2) NOT NULL,
 CE_HOURS NUMBER(*,2) NOT NULL,
 CE_ACTION_NO VARCHAR2(10 BYTE) NOT NULL,
 CE_ATTENDING_DATE VARCHAR2(30 BYTE) NOT NULL,
 CE_COURSE_NAME VARCHAR2(200 BYTE) NOT NULL,
 CE_HR_REMARK VARCHAR2(200 BYTE) NULL,
 CE_CLAIMEDMoney NUMBER(*,0) DEFAULT 0,  -- 0,1
 CE_CLAIMEDHours NUMBER(*,0) DEFAULT 0,  -- 0,1
 CE_usedHours NUMBER(*,2) DEFAULT 0,
 CE_usedMoney NUMBER(*,2) DEFAULT 0,
 CE_CREATED_DATE DATE DEFAULT SYSDATE,
 CE_CREATED_USER VARCHAR2(30 BYTE) DEFAULT 'SYSTEM',
 CE_MODIFIED_DATE DATE DEFAULT SYSDATE,
 CE_MODIFIED_USER VARCHAR2(30 BYTE) DEFAULT 'SYSTEM',
 CE_ENABLED NUMBER(*,0) DEFAULT 1,
 PRIMARY KEY (CE_APPROVED_TRANS_ID)
);
ALTER TABLE CE_APPROVED_TRANS ADD (
 CONSTRAINT CE_APPROVED_TRANS_R01
 FOREIGN KEY (CE_SITE_CODE, CE_STAFF_ID)
 REFERENCES CO_STAFFS (CO_SITE_CODE, CO_STAFF_ID));
 
--alter table ce_approved_trans add(CE_CLAIMEDHours NUMBER(*,0) DEFAULT 0);
--alter table ce_approved_trans add(CE_CLAIMEDMoney NUMBER(*,0) DEFAULT 0);
--alter table ce_approved_trans drop column  CE_CLAIMED ;
--alter table ce_approved_trans add(CE_usedHours NUMBER(*,2) DEFAULT 0);
--alter table ce_approved_trans add(CE_usedMoney NUMBER(*,2) DEFAULT 0);



update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=1;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=2;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=3;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=4;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=5;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=6;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=7;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=8;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=9;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=10;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=11;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=12;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=13;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=14;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=15;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=16;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=17;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=18;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=19;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=20;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=21;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=22;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=23;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=24;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=25;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=26;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=27;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=28;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=29;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=30;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=31;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=32;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=33;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=34;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=35;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=36;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=37;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=38;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=39;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=40;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=41;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=42;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=43;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=44;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=45;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=46;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=47;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=48;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=49;
update ce_approved_trans set CE_ENABLED=0, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=50;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=51;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=52;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=53;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=54;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=55;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=56;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=57;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=58;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=59;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=60;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=61;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=62;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=63;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=64;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=65;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=66;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=67;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=68;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=69;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=70;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=71;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=72;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=73;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=74;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=75;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=76;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=77;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=78;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=79;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=80;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=81;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=82;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=83;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=84;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=85;
update ce_approved_trans set CE_ENABLED=0, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=86;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=87;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=88;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=89;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=90;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=91;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=92;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=93;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=94;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=95;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=96;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=97;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=98;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=99;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=100;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=101;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=102;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=103;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=104;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=105;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=106;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=107;
update ce_approved_trans set CE_ENABLED=0, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=108;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=109;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=110;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=111;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=112;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=113;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=114;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=115;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=116;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=117;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=118;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=119;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=120;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=121;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=122;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=123;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=124;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=125;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=126;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=127;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=128;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=129;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=130;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=131;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=132;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=133;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=134;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=135;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=136;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=137;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=138;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=139;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=140;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=141;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=142;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=143;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=144;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=145;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=146;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=147;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=148;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=149;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=150;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=151;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=152;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=153;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=154;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=155;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=156;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=157;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=158;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=159;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=160;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=161;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=162;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=163;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=164;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=165;
update ce_approved_trans set CE_ENABLED=0, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=166;
update ce_approved_trans set CE_ENABLED=0, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=167;
update ce_approved_trans set CE_ENABLED=0, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=168;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=169;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=170;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=171;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=172;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=173;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=174;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=175;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=176;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=177;
update ce_approved_trans set CE_ENABLED=0, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=178;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=179;
update ce_approved_trans set CE_ENABLED=0, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=180;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=181;
update ce_approved_trans set CE_ENABLED=0, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=182;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=183;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=184;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=185;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=186;
update ce_approved_trans set CE_ENABLED=0, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=187;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=188;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=189;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=190;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=191;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=192;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=193;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=194;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=195;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=196;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=197;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=198;
update ce_approved_trans set CE_ENABLED=0, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=199;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=200;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=201;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=202;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=203;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=204;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=205;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=206;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=207;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=208;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=209;
update ce_approved_trans set CE_ENABLED=0, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=210;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=211;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=212;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=213;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=214;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=215;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=216;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=217;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=218;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=219;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=220;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=221;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=222;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=223;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=224;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=225;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=226;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=1   where  CE_APPROVED_TRANS_ID=227;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=228;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=229;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=230;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=231;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=1 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=232;
update ce_approved_trans set CE_ENABLED=1, CE_CLAIMEDMoney=0 ,CE_CLAIMEDHours=0   where  CE_APPROVED_TRANS_ID=233;
 
 
update ce_approved_trans set ce_usedHours=2 where  CE_APPROVED_TRANS_ID=79;
update ce_approved_trans set ce_usedHours=4 where  CE_APPROVED_TRANS_ID=21;
update ce_approved_trans set ce_usedHours=4 , ce_usedmoney=400 where  CE_APPROVED_TRANS_ID=204;
update ce_approved_trans set ce_usedHours=4.5 where  CE_APPROVED_TRANS_ID=24;
update ce_approved_trans set ce_usedHours=8 where  CE_APPROVED_TRANS_ID=184;
update ce_approved_trans set ce_usedHours=8 where  CE_APPROVED_TRANS_ID=185;
update ce_approved_trans set ce_usedHours=8 where  CE_APPROVED_TRANS_ID=200;
update ce_approved_trans set ce_usedHours=11 where  CE_APPROVED_TRANS_ID=175;
update ce_approved_trans set ce_usedHours=16 where  CE_APPROVED_TRANS_ID=47;
update ce_approved_trans set ce_usedHours=16 where  CE_APPROVED_TRANS_ID=81;
update ce_approved_trans set ce_usedHours=17 where  CE_APPROVED_TRANS_ID=53;
update ce_approved_trans set ce_usedHours=20.5 where  CE_APPROVED_TRANS_ID=62;
update ce_approved_trans set ce_usedHours=22 where  CE_APPROVED_TRANS_ID=82;
update ce_approved_trans set ce_usedHours=44 where  CE_APPROVED_TRANS_ID=27;
 
ALTER TABLE CO_USERS
 DROP PRIMARY KEY CASCADE;
DROP TABLE CO_USERS CASCADE CONSTRAINTS;

CREATE TABLE CO_USERS
(
 CO_SITE_CODE VARCHAR2(10 BYTE) NOT NULL ENABLE,
 CO_USERNAME VARCHAR2(30 BYTE) NOT NULL,
 CO_GROUP_ID VARCHAR2(30 BYTE) NOT NULL ENABLE,
 CO_PASSWORD VARCHAR2(30 BYTE),
 CO_LASTNAME VARCHAR2(30 BYTE),
 CO_FIRSTNAME VARCHAR2(60 BYTE),
 CO_STREET VARCHAR2(100 BYTE),
 CO_POSTALCODE VARCHAR2(10 BYTE),
 CO_CITY VARCHAR2(30 BYTE),
 CO_COUNTRY VARCHAR2(30 BYTE),
 CO_LANGUAGE VARCHAR2(10 BYTE),
 CO_EMAIL VARCHAR2(255 BYTE),
 CO_TELEPHONE VARCHAR2(30 BYTE),
 CO_STAFF_YN VARCHAR2(1 BYTE) DEFAULT 'Y',
 CO_STAFF_ID VARCHAR2(10 BYTE) NULL,
 CO_REMARK_1 VARCHAR2(50 BYTE) NULL,
 CO_REMARK_2 VARCHAR2(50 BYTE) NULL,
 CO_REMARK_3 VARCHAR2(50 BYTE) NULL,
 CO_CREATED_DATE DATE DEFAULT SYSDATE,
 CO_CREATED_USER VARCHAR2(30 BYTE) DEFAULT 'SYSTEM',
 CO_MODIFIED_DATE DATE DEFAULT SYSDATE,
 CO_MODIFIED_USER VARCHAR2(30 BYTE) DEFAULT 'SYSTEM',
 CO_ENABLED NUMBER(*,0) DEFAULT 1,
 PRIMARY KEY (CO_USERNAME)
);
ALTER TABLE CO_USERS ADD (
 CONSTRAINT CO_USERS_R01
 FOREIGN KEY (CO_GROUP_ID)
 REFERENCES CO_GROUPS (CO_GROUP_ID));

INSERT INTO CO_USERS (CO_SITE_CODE, CO_USERNAME, CO_GROUP_ID, CO_PASSWORD, CO_FIRSTNAME, CO_LASTNAME, CO_STAFF_ID, CO_STAFF_YN, CO_EMAIL) VALUES ('hkah', 'admin', 'admin', 'QAQEPCPNQE', 'admin', 'user', '', 'Y', '');

update co_users set co_group_id='manager', co_email='frank.yeung@hkah.org.hk' where co_staff_id='3603';
update co_users set co_group_id='manager', co_email='kim.ng@hkah.org.hk' where co_staff_id='4006';
update co_users set co_group_id='manager', co_email='alfred.choo@hkah.org.hk' where co_staff_id='3940';
update co_users set co_group_id='manager', co_email='alex.lan@hkah.org.hk' where co_staff_id='9992';
update co_users set co_group_id='manager', co_email='linda.leung@hkah.org.hk' where co_staff_id='3723';
update co_users set co_group_id='manager', co_email='camille.ho@hkah.org.hk' where co_staff_id='3830';
update co_users set co_group_id='manager', co_email='roger.li@hkah.org.hk' where co_staff_id='3992';
update co_users set co_group_id='manager', co_email='stanley.leung@hkah.org.hk' where co_staff_id='9999';
update co_users set co_group_id='manager', co_email='wendy.lo@hkah.org.hk' where co_staff_id='3880';
update co_users set co_group_id='manager', co_email='mri@hkah.org.hk' where co_staff_id='1422';
update co_users set co_group_id='manager', co_email='chiwing.wong@hkah.org.hk' where co_staff_id='2944';
update co_users set co_group_id='manager', co_email='gloria.tong@hkah.org.hk' where co_staff_id='1040';
update co_users set co_group_id='manager', co_email='beatrice.lam@hkah.org.hk' where co_staff_id='3043';
update co_users set co_group_id='manager', co_email='iris.chuah@hkah.org.hk' where co_staff_id='4104';
update co_users set co_group_id='manager', co_email='kko@hkah.org.hk' where co_staff_id='2899';
update co_users set co_group_id='manager', co_email='melvin.choi@hkah.org.hk' where co_staff_id='3722';
update co_users set co_group_id='manager', co_email='mary.chu@hkah.org.hk' where co_staff_id='3761';
update co_users set co_group_id='manager', co_email='johnny.ho@hkah.org.hk' where co_staff_id='4123';
update co_users set co_group_id='manager', co_email='manyee.wong@hkah.org.hk' where co_staff_id='1900';
update co_users set co_group_id='manager', co_email='alan.siu@hkah.org.hk' where co_staff_id='3927';
update co_users set co_group_id='manager', co_email='brenda_mak@hkah.org.hk' where co_staff_id='3229';
update co_users set co_group_id='manager', co_email='jessica.chan@hkah.org.hk' where co_staff_id='3789';
update co_users set co_group_id='manager', co_email='rachel.yeung@hkah.org.hk' where co_staff_id='3784';
update co_users set co_group_id='manager', co_email='chiwing.wong@hkah.org.hk' where co_staff_id='1001';
update co_users set co_group_id='manager', co_email='flora.law@hkah.org.hk' where co_staff_id='3724';
update co_users set co_group_id='manager', co_email='ginny.poon@hkah.org.hk' where co_staff_id='2383';
update co_users set co_group_id='manager', co_email='rajwinder.kaur@hkah.org.hk' where co_staff_id='3242';
update co_users set co_group_id='manager', co_email='angela.chan@hkah.org.hk' where co_staff_id='2670';
update co_users set co_group_id='manager', co_email='clara.leung@hkah.org.hk' where co_staff_id='1029';
update co_users set co_group_id='manager', co_email='barbara.lam@hkah.org.hk' where co_staff_id='1028';
update co_users set co_group_id='manager', co_email='gladys.ho@hkah.org.hk' where co_staff_id='2686';
update co_users set co_group_id='manager', co_email='patrick.leung@hkah.org.hk' where co_staff_id='2126';
update co_users set co_group_id='manager', co_email='rehab@hkah.org.hk' where co_staff_id='2155';
update co_users set co_group_id='manager', co_email='maintdir@hkah.org.hk' where co_staff_id='2648';
update co_users set co_group_id='manager', co_email='terry.tam@hkah.org.hk' where co_staff_id='3883';
update co_users set co_group_id='manager', co_email='bernice@hkah.org.hk' where co_staff_id='1156';

-- guest
INSERT INTO CO_USERS 
(CO_SITE_CODE, CO_USERNAME, CO_GROUP_ID, CO_PASSWORD, CO_FIRSTNAME, CO_LASTNAME, CO_STAFF_ID, CO_STAFF_YN, CO_EMAIL) 
VALUES ('hkah', 'kathy.perno', 'guest', 'TATGSMTCTNSL', 'Kathy', 'PERNO', '', 'N', 'Kathleen.Perno@ahss.org');

INSERT INTO CO_USERS  
(CO_SITE_CODE, CO_USERNAME, CO_GROUP_ID, CO_PASSWORD, CO_FIRSTNAME, CO_LASTNAME, CO_STAFF_ID, CO_STAFF_YN, CO_EMAIL) 
VALUES ('hkah', 'mack.rucker', 'guest', 'TATGSMTCTNSL', 'Mack', 'Rucker', '', 'N', '');
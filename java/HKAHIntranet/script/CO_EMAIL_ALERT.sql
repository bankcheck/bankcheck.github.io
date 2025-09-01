ALTER TABLE CO_EMAIL_ALERT
 DROP PRIMARY KEY CASCADE;
DROP TABLE CO_EMAIL_ALERT CASCADE CONSTRAINTS;

CREATE TABLE CO_EMAIL_ALERT
(
 CO_SITE_CODE VARCHAR2(10 BYTE) NOT NULL ENABLE,
 CO_MODULE_CODE VARCHAR2(20 BYTE) NOT NULL ENABLE,	-- education, lmc
 CO_ACTION VARCHAR2(10 BYTE), -- from, to, cc
 CO_EMAIL VARCHAR2(255 BYTE),
 CO_CREATED_DATE DATE DEFAULT SYSDATE,
 CO_CREATED_USER VARCHAR2(30 BYTE) DEFAULT 'SYSTEM',
 CO_MODIFIED_DATE DATE DEFAULT SYSDATE,
 CO_MODIFIED_USER VARCHAR2(30 BYTE) DEFAULT 'SYSTEM',
 CO_ENABLED NUMBER(*,0) DEFAULT 1,
 PRIMARY KEY (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL)
);
ALTER TABLE CO_EMAIL_ALERT ADD (
 CONSTRAINT CO_EMAIL_ALERT_R01
 FOREIGN KEY (CO_SITE_CODE)
 REFERENCES CO_SITE (CO_SITE_CODE));

CREATE INDEX CO_EMAIL_ALERT_IDX1
ON CO_EMAIL_ALERT(CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION);

-- Billing Agreement
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'billing.agreement', 'from', 'alert@hkah.org.hk');
--INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'billing.agreement', 'to', 'jessica.chan@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'billing.agreement', 'to', 'isabelle.leung@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'billing.agreement', 'to', 'Becky_Yau@hkah.org.hk');
--INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'billing.agreement', 'to', 'neville.hui@hkah.org.hk');
--INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'billing.agreement', 'to', 'mei.fung@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'billing.agreement', 'to', 'cathy.ng@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'billing.agreement', 'to', 'christine.chow@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'billing.agreement', 'to', 'brenda_mak@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'billing.agreement', 'bcc', 'cherry.wong@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'billing.agreement', 'bcc', 'ricky.leung@hkah.org.hk');

-- OB
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.acknowledge', 'from', 'rachel.yeung@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.acknowledge', 'to', 'susan.wang@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.acknowledge', 'cc', 'rachel.yeung@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.acknowledge', 'cc', 'nari.wan@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.acknowledge', 'bcc', 'johnny.ho@hkah.org.hk');

INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ob-0', 'from', 'susan.wang@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ob-0', 'to', 'rachel.yeung@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ob-0', 'cc', 'sally.leung@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ob-0', 'cc', 'susan.wang@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ob-0', 'cc', 'nari.wan@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ob-0', 'bcc', 'johnny.ho@hkah.org.hk');

INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ob-1', 'from', 'rachel.yeung@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ob-1', 'to', 'registration@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ob-1', 'cc', 'brenda_mak@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ob-1', 'cc', 'angela.chan@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ob-1', 'cc', 'Becky_Yau@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ob-1', 'cc', 'isabelle.leung@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ob-1', 'cc', 'michelle.tse@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ob-1', 'cc', 'rachel.yeung@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ob-1', 'bcc', 'johnny.ho@hkah.org.hk');

INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ob-2', 'from', 'registration@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ob-2', 'to', 'susan.wang@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ob-2', 'cc', 'rachel.yeung@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ob-2', 'cc', 'brenda_mak@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ob-2', 'cc', 'angela.chan@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ob-2', 'cc', 'Becky_Yau@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ob-2', 'cc', 'isabelle.leung@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ob-2', 'cc', 'michelle.tse@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ob-2', 'cc', 'registration@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ob-2', 'cc', 'nari.wan@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ob-2', 'bcc', 'johnny.ho@hkah.org.hk');

INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ob-3', 'from', 'susan.wang@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ob-3', 'to', 'angela.chan@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ob-3', 'to', 'Becky_Yau@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ob-3', 'to', 'isabelle.leung@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ob-3', 'to', 'michelle.tse@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ob-3', 'to', 'registration@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ob-3', 'cc', 'susan.wang@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ob-3', 'cc', 'nari.wan@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ob-3', 'bcc', 'johnny.ho@hkah.org.hk');

INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ob-4', 'from', 'michelle.tse@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ob-4', 'to', 'susan.wang@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ob-4', 'cc', 'rachel.yeung@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ob-4', 'cc', 'brenda_mak@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ob-4', 'cc', 'angela.chan@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ob-4', 'cc', 'Becky_Yau@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ob-4', 'cc', 'isabelle.leung@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ob-4', 'cc', 'clara.leung.tse@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ob-4', 'cc', 'claudia.tai.tse@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ob-4', 'cc', 'kathy.ng@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ob-4', 'cc', 'michelle.tse@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ob-4', 'cc', 'nari.wan@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ob-4', 'bcc', 'johnny.ho@hkah.org.hk');

INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ob-5', 'from', 'susan.wang@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ob-5', 'to', 'angela.chan@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ob-5', 'to', 'Becky_Yau@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ob-5', 'to', 'isabelle.leung@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ob-5', 'to', 'clara.leung.tse@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ob-5', 'to', 'claudia.tai.tse@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ob-5', 'cc', 'kathy.ng@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ob-5', 'cc', 'susan.wang@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ob-5', 'cc', 'nari.wan@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ob-5', 'bcc', 'johnny.ho@hkah.org.hk');

-- Surgical
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.surgical-0', 'from', 'susan.wang@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.surgical-0', 'to', 'rachel.yeung@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.surgical-0', 'to', 'sally.leung@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.surgical-0', 'cc', 'susan.wang@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.surgical-0', 'cc', 'nari.wan@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.surgical-0', 'bcc', 'johnny.ho@hkah.org.hk');

INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.surgical-1', 'from', 'rachel.yeung@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.surgical-1', 'to', 'registration@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.surgical-1', 'cc', 'brenda_mak@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.surgical-1', 'cc', 'clara.leung@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.surgical-1', 'cc', 'Becky_Yau@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.surgical-1', 'cc', 'isabelle.leung@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.surgical-1', 'cc', 'susan.wang@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.surgical-1', 'cc', 'nari.wan@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.surgical-1', 'bcc', 'johnny.ho@hkah.org.hk');

INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.surgical-2', 'from', 'alert@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.surgical-2', 'to', 'susan.wang@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.surgical-2', 'cc', 'rachel.yeung@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.surgical-2', 'cc', 'brenda_mak@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.surgical-2', 'cc', 'clara.leung@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.surgical-2', 'cc', 'Becky_Yau@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.surgical-2', 'cc', 'isabelle.leung@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.surgical-2', 'cc', 'nari.wan@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.surgical-2', 'bcc', 'johnny.ho@hkah.org.hk');

INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.surgical-3', 'from', 'susan.wang@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.surgical-3', 'to', 'clara.leung@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.surgical-3', 'to', 'Becky_Yau@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.surgical-3', 'to', 'isabelle.leung@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.surgical-3', 'cc', 'susan.wang@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.surgical-3', 'cc', 'nari.wan@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.surgical-3', 'bcc', 'johnny.ho@hkah.org.hk');

INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.surgical-4', 'from', 'alert@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.surgical-4', 'to', 'susan.wang@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.surgical-4', 'cc', 'rachel.yeung@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.surgical-4', 'cc', 'brenda_mak@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.surgical-4', 'cc', 'clara.leung@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.surgical-4', 'cc', 'Becky_Yau@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.surgical-4', 'cc', 'isabelle.leung@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.surgical-4', 'cc', 'nari.wan@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.surgical-4', 'bcc', 'johnny.ho@hkah.org.hk');

INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.surgical-5', 'from', 'susan.wang@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.surgical-5', 'to', 'clara.leung@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.surgical-5', 'to', 'Becky_Yau@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.surgical-5', 'to', 'isabelle.leung@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.surgical-5', 'cc', 'susan.wang@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.surgical-5', 'cc', 'nari.wan@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.surgical-5', 'bcc', 'johnny.ho@hkah.org.hk');

-- Health Assessment
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ha-0', 'from', 'susan.wang@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ha-0', 'to', 'rachel.yeung@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ha-0', 'to', 'sally.leung@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ha-0', 'cc', 'susan.wang@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ha-0', 'cc', 'nari.wan@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ha-0', 'bcc', 'johnny.ho@hkah.org.hk');

INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ha-1', 'from', 'rachel.yeung@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ha-1', 'to', 'registration@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ha-1', 'cc', 'brenda_mak@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ha-1', 'cc', 'barbara.lam@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ha-1', 'cc', 'Becky_Yau@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ha-1', 'cc', 'isabelle.leung@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ha-1', 'cc', 'susan.wang@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ha-1', 'cc', 'nari.wan@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ha-1', 'bcc', 'johnny.ho@hkah.org.hk');

INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ha-2', 'from', 'alert@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ha-2', 'to', 'susan.wang@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ha-2', 'cc', 'rachel.yeung@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ha-2', 'cc', 'brenda_mak@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ha-2', 'cc', 'barbara.lam@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ha-2', 'cc', 'Becky_Yau@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ha-2', 'cc', 'isabelle.leung@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ha-2', 'cc', 'nari.wan@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ha-2', 'bcc', 'johnny.ho@hkah.org.hk');

INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ha-3', 'from', 'susan.wang@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ha-3', 'to', 'barbara.lam@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ha-3', 'to', 'Becky_Yau@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ha-3', 'to', 'isabelle.leung@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ha-3', 'cc', 'susan.wang@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ha-3', 'cc', 'nari.wan@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ha-3', 'bcc', 'johnny.ho@hkah.org.hk');

INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ha-4', 'from', 'alert@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ha-4', 'to', 'susan.wang@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ha-4', 'cc', 'rachel.yeung@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ha-4', 'cc', 'brenda_mak@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ha-4', 'cc', 'barbara.lam@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ha-4', 'cc', 'Becky_Yau@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ha-4', 'cc', 'isabelle.leung@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ha-4', 'cc', 'nari.wan@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ha-4', 'bcc', 'johnny.ho@hkah.org.hk');

INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ha-5', 'from', 'susan.wang@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ha-5', 'to', 'barbara.lam@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ha-5', 'to', 'Becky_Yau@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ha-5', 'to', 'isabelle.leung@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ha-5', 'cc', 'susan.wang@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ha-5', 'cc', 'nari.wan@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.ha-5', 'bcc', 'johnny.ho@hkah.org.hk');

-- Cardiac
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.cardiac-0', 'from', 'susan.wang@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.cardiac-0', 'to', 'rachel.yeung@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.cardiac-0', 'to', 'sally.leung@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.cardiac-0', 'cc', 'susan.wang@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.cardiac-0', 'cc', 'nari.wan@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.cardiac-0', 'bcc', 'johnny.ho@hkah.org.hk');

INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.cardiac-1', 'from', 'rachel.yeung@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.cardiac-1', 'to', 'registration@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.cardiac-1', 'cc', 'brenda_mak@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.cardiac-1', 'cc', 'cynthia.littlebury@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.cardiac-1', 'cc', 'Becky_Yau@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.cardiac-1', 'cc', 'isabelle.leung@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.cardiac-1', 'cc', 'susan.wang@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.cardiac-1', 'cc', 'nari.wan@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.cardiac-1', 'bcc', 'johnny.ho@hkah.org.hk');

INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.cardiac-2', 'from', 'alert@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.cardiac-2', 'to', 'susan.wang@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.cardiac-2', 'cc', 'rachel.yeung@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.cardiac-2', 'cc', 'brenda_mak@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.cardiac-2', 'cc', 'cynthia.littlebury@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.cardiac-2', 'cc', 'Becky_Yau@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.cardiac-2', 'cc', 'isabelle.leung@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.cardiac-2', 'cc', 'nari.wan@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.cardiac-2', 'bcc', 'johnny.ho@hkah.org.hk');

INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.cardiac-3', 'from', 'susan.wang@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.cardiac-3', 'to', 'cynthia.littlebury@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.cardiac-3', 'to', 'Becky_Yau@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.cardiac-3', 'to', 'isabelle.leung@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.cardiac-3', 'cc', 'susan.wang@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.cardiac-3', 'cc', 'nari.wan@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.cardiac-3', 'bcc', 'johnny.ho@hkah.org.hk');

INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.cardiac-4', 'from', 'alert@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.cardiac-4', 'to', 'susan.wang@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.cardiac-4', 'cc', 'rachel.yeung@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.cardiac-4', 'cc', 'brenda_mak@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.cardiac-4', 'cc', 'cynthia.littlebury@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.cardiac-4', 'cc', 'Becky_Yau@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.cardiac-4', 'cc', 'isabelle.leung@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.cardiac-4', 'cc', 'nari.wan@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.cardiac-4', 'bcc', 'johnny.ho@hkah.org.hk');

INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.cardiac-5', 'from', 'susan.wang@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.cardiac-5', 'to', 'cynthia.littlebury@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.cardiac-5', 'to', 'Becky_Yau@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.cardiac-5', 'to', 'isabelle.leung@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.cardiac-5', 'cc', 'susan.wang@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.cardiac-5', 'cc', 'nari.wan@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.cardiac-5', 'bcc', 'johnny.ho@hkah.org.hk');

-- Oncology
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.oncology-0', 'from', 'susan.wang@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.oncology-0', 'to', 'rachel.yeung@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.oncology-0', 'to', 'sally.leung@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.oncology-0', 'cc', 'susan.wang@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.oncology-0', 'cc', 'nari.wan@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.oncology-0', 'bcc', 'johnny.ho@hkah.org.hk');

INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.oncology-1', 'from', 'rachel.yeung@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.oncology-1', 'to', 'registration@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.oncology-1', 'cc', 'brenda_mak@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.oncology-1', 'cc', 'mri@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.oncology-1', 'cc', 'Becky_Yau@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.oncology-1', 'cc', 'isabelle.leung@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.oncology-1', 'cc', 'susan.wang@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.oncology-1', 'cc', 'nari.wan@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.oncology-1', 'bcc', 'johnny.ho@hkah.org.hk');

INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.oncology-2', 'from', 'alert@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.oncology-2', 'to', 'susan.wang@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.oncology-2', 'cc', 'rachel.yeung@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.oncology-2', 'cc', 'brenda_mak@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.oncology-2', 'cc', 'mri@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.oncology-2', 'cc', 'Becky_Yau@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.oncology-2', 'cc', 'isabelle.leung@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.oncology-2', 'cc', 'nari.wan@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.oncology-2', 'bcc', 'johnny.ho@hkah.org.hk');

INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.oncology-3', 'from', 'susan.wang@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.oncology-3', 'to', 'mri@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.oncology-3', 'to', 'Becky_Yau@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.oncology-3', 'to', 'isabelle.leung@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.oncology-3', 'cc', 'susan.wang@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.oncology-3', 'cc', 'nari.wan@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.oncology-3', 'bcc', 'johnny.ho@hkah.org.hk');

INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.oncology-4', 'from', 'alert@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.oncology-4', 'to', 'susan.wang@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.oncology-4', 'cc', 'rachel.yeung@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.oncology-4', 'cc', 'brenda_mak@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.oncology-4', 'cc', 'mri@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.oncology-4', 'cc', 'Becky_Yau@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.oncology-4', 'cc', 'isabelle.leung@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.oncology-4', 'cc', 'nari.wan@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.oncology-4', 'bcc', 'johnny.ho@hkah.org.hk');

INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.oncology-5', 'from', 'susan.wang@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.oncology-5', 'to', 'mri@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.oncology-5', 'to', 'Becky_Yau@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.oncology-5', 'to', 'isabelle.leung@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.oncology-5', 'cc', 'susan.wang@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.oncology-5', 'cc', 'nari.wan@ghcchina.com');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'ghc.oncology-5', 'bcc', 'johnny.ho@hkah.org.hk');

INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'admin', 'from', 'alert@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'admin', 'to', 'johnny.ho@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'admin', 'to', 'cherry.wong@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'admin', 'to', 'ricky.leung@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'admin', 'to', 'andrew.lau@hkah.org.hk');

INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'osb.discharge', 'from', 'alert@hkah.org.hk');
INSERT INTO CO_EMAIL_ALERT (CO_SITE_CODE, CO_MODULE_CODE, CO_ACTION, CO_EMAIL) VALUES ('hkah', 'osb.discharge', 'to', 'booking-team@hkah.org.hk');
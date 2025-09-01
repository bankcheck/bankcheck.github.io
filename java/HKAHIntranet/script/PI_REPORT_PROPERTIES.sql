DROP TABLE PI_REPORT_PROPERTIES CASCADE CONSTRAINTS;

CREATE TABLE PI_REPORT_PROPERTIES
(
    PI_SITE_CODE  VARCHAR2(10 BYTE),
    PI_PROP_TYPE  VARCHAR2(50 BYTE),
    PI_PROP_KEY   VARCHAR2(50 BYTE),
    PI_PROP_VALUE VARCHAR2(50 BYTE),
    PI_ORDER      NUMBER,
    PI_FREETEXT   NUMBER(*,0) DEFAULT 0,
    PI_ENABLED    NUMBER(*,0) DEFAULT 1
);

alter table PI_REPORT_PROPERTIES add (
 CONSTRAINT PI_REPORT_PROPERTIES_R01
 FOREIGN KEY (PI_SITE_CODE)
 REFERENCES CO_SITE (CO_SITE_CODE));
  
 insert into PI_REPORT_PROPERTIES
(PI_SITE_CODE,PI_PROP_TYPE, PI_PROP_VALUE, PI_ORDER)
values
('hkah', 'place_of_occurrence' , 'CCIC', 1);
 insert into PI_REPORT_PROPERTIES
(PI_SITE_CODE,PI_PROP_TYPE, PI_PROP_VALUE, PI_ORDER)
values
('hkah', 'place_of_occurrence' , 'Centre', 2);
 insert into PI_REPORT_PROPERTIES
(PI_SITE_CODE,PI_PROP_TYPE, PI_PROP_VALUE, PI_ORDER)
values
('hkah', 'place_of_occurrence' , 'DI-1/F', 3);
 insert into PI_REPORT_PROPERTIES
(PI_SITE_CODE,PI_PROP_TYPE, PI_PROP_VALUE, PI_ORDER)
values
('hkah', 'place_of_occurrence' , 'DI-MRI', 4);
 insert into PI_REPORT_PROPERTIES
(PI_SITE_CODE,PI_PROP_TYPE, PI_PROP_VALUE, PI_ORDER)
values
('hkah', 'place_of_occurrence' , 'Dental', 5);
 insert into PI_REPORT_PROPERTIES
(PI_SITE_CODE,PI_PROP_TYPE, PI_PROP_VALUE, PI_ORDER)
values
('hkah', 'place_of_occurrence' , 'Lab', 6);
 insert into PI_REPORT_PROPERTIES
(PI_SITE_CODE,PI_PROP_TYPE, PI_PROP_VALUE, PI_ORDER)
values
('hkah', 'place_of_occurrence' , 'Medical', 7);
 insert into PI_REPORT_PROPERTIES
(PI_SITE_CODE,PI_PROP_TYPE, PI_PROP_VALUE, PI_ORDER)
values
('hkah', 'place_of_occurrence' , 'OB-ICU', 8);
 insert into PI_REPORT_PROPERTIES
(PI_SITE_CODE,PI_PROP_TYPE, PI_PROP_VALUE, PI_ORDER)
values
('hkah', 'place_of_occurrence' , 'OPD', 9);
 insert into PI_REPORT_PROPERTIES
(PI_SITE_CODE,PI_PROP_TYPE, PI_PROP_VALUE, PI_ORDER)
values
('hkah', 'place_of_occurrence' , 'OR/Endo/CSR', 10);
 insert into PI_REPORT_PROPERTIES
(PI_SITE_CODE,PI_PROP_TYPE, PI_PROP_VALUE, PI_ORDER)
values
('hkah', 'place_of_occurrence' , 'Oncology', 11);
 insert into PI_REPORT_PROPERTIES
(PI_SITE_CODE,PI_PROP_TYPE, PI_PROP_VALUE, PI_ORDER, PI_FREETEXT)
values
('hkah', 'place_of_occurrence' , 'Others', 12 , 1);
 insert into PI_REPORT_PROPERTIES
(PI_SITE_CODE,PI_PROP_TYPE, PI_PROP_VALUE, PI_ORDER)
values
('hkah', 'place_of_occurrence' , 'PBO', 13);
 insert into PI_REPORT_PROPERTIES
(PI_SITE_CODE,PI_PROP_TYPE, PI_PROP_VALUE, PI_ORDER)
values
('hkah', 'place_of_occurrence' , 'PED', 14);
 insert into PI_REPORT_PROPERTIES
(PI_SITE_CODE,PI_PROP_TYPE, PI_PROP_VALUE, PI_ORDER)
values
('hkah', 'place_of_occurrence' , 'Pharmacy', 15);
 insert into PI_REPORT_PROPERTIES
(PI_SITE_CODE,PI_PROP_TYPE, PI_PROP_VALUE, PI_ORDER)
values
('hkah', 'place_of_occurrence' , 'Rehab', 16);
 insert into PI_REPORT_PROPERTIES
(PI_SITE_CODE,PI_PROP_TYPE, PI_PROP_VALUE, PI_ORDER)
values
('hkah', 'place_of_occurrence' , 'Surgical', 17);

COMMIT;

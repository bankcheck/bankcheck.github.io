ALTER TABLE EE_ELEARNING_QUESTION
 DROP PRIMARY KEY CASCADE;
DROP TABLE EE_ELEARNING_QUESTION CASCADE CONSTRAINTS;

CREATE TABLE EE_ELEARNING_QUESTION
(
 EE_SITE_CODE VARCHAR2(10 BYTE) NOT NULL ENABLE,
 EE_ELEARNING_ID NUMBER(*,0) NOT NULL ENABLE,
 EE_ELEARNING_QID NUMBER(*,0) NOT NULL ENABLE,
 EE_QUESTION VARCHAR2(1000 BYTE),
 EE_CREATED_DATE DATE DEFAULT SYSDATE,
 EE_CREATED_USER VARCHAR2(30 BYTE) DEFAULT 'SYSTEM',
 EE_MODIFIED_DATE DATE DEFAULT SYSDATE,
 EE_MODIFIED_USER VARCHAR2(30 BYTE) DEFAULT 'SYSTEM',
 EE_ENABLED NUMBER(*,0) DEFAULT 1,
 PRIMARY KEY (EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID)
);
ALTER TABLE EE_ELEARNING_QUESTION ADD (
 CONSTRAINT EE_ELEARNING_QUESTION_R01
 FOREIGN KEY (EE_SITE_CODE, EE_ELEARNING_ID)
 REFERENCES EE_ELEARNING (EE_SITE_CODE, EE_ELEARNING_ID));
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 1, 01, 'Alcohol scrubbing is at least as effective as hand washing and can save time.');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 1, 02, 'It is not necessary to wash hands before and after a procedure if gloves are used.');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 1, 03, 'Unused sharps may be disposed in regular trash bags if properly labeled.');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 1, 04, 'Needles should never be recapped.');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 1, 05, 'Sterilization aims at killing all pathogenic microorganisms without affecting the commensals.');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 1, 06, 'Mask and eyewear must be worn before entering the room of a patient under contact isolation.');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 1, 07, 'The hair must all be covered up when wearing PPE.');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 1, 08, 'You must wash your hands before and after wearing PPE.');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 1, 09, 'Wearing a surgical mask is not enough to prevent air-borne infections.');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 1, 10, 'All body fluids must be treated as if they are infectious and direct skin contact must be avoided.');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 1, 11, 'In which of the following situations can hand washing can be exempted? Choose one answer.');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 1, 12, 'Which of the following statements is true? Choose one answer.');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 1, 13, 'Which of the followings is the single most important piece of equipment if you need to take care of a patient suspected of tuberculosis? Choose one answer.');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 1, 14, 'In which of the following situations is hand washing not exempted? Choose one answer.');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 1, 15, 'In which of the following situations can hand washing can be exempted? Choose one answer.');

INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 2, 1, 'Cerebrum includes, frontal, parietal, temporal and cerebellum.');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 2, 2, 'Conditions causing decreased consciousness includes<br>-	Alcohol or drug intoxication<br>-	Arrhythmia<br>-	Hypoxia<br>-	Diabetic Coma');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 2, 3, 'The 5 levels of consciousness include<br>-	confusion<br>-	drowsiness<br>-	stupor<br>-	moderate and deep coma');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 2, 4, 'Unilateral pupil dilatation, reactive not brisk to light means the patient may have herniation of temporal lobe.');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 2, 5, 'Common complication for comatose patients includes, aspiration pneumonia, vomiting, bedsores, contractures and infections.');

INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 3, 1, '10% of fall result in death');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 3, 2, 'Causes of fall include<br>-	Aging changes<br>-	Environment<br>-	Certain medication<br>-	Chronic diseases');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 3, 3, 'The 4 ''A'' s to prevent patient falls include:<br>-	Assessment<br>-	Alert<br>-	Action	 -Prevent<br>-	Audit');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 3, 4, 'Immediate actions to take when patient falls is to quickly without assessment return patient to bed');

INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 4, 01, 'The storage area shall be free of');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 4, 02, 'All items shall be stored above the floor level by at least _____inches, from walls by at least _____inches and from ceiling fixture by at least _____inches, and protected from directed sunlight.');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 4, 03, 'Temperature within the storage area should range from _____ with a relative humidity ranging from _____');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 4, 04, 'Access to the sterile storage areas shall be clearly defined and shall be restricted to those who');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 4, 05, 'Materials used to pack items for sterilizing will not necessarily provide a complete barrier against contamination.');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 4, 06, 'It is essential that the following of the storage area are given the highest priority.');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 4, 07, 'All batch information shall be marked');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 4, 08, 'According to AORN, all commercially prepared item contains an expiration date, that date was honored even HK Adventist has adopted event-related sterility.');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 4, 09, 'Factors which influence shelf-life are event-related and include the following except');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 4, 10, 'A package shall be considered nonconforming, i.e. non-sterile and not suitable for use when ¡V<br>(a)	it is incorrectly wrapped<br>(b)	it is damaged crushed, bended, compressed or punctured or opened<br>(c)	it is wet after the sterilizing cycle or comes into contact with a wet surface<br>(d)	it is placed or dropped on a dirty surface, e.g. floor or sink area<br>(e)	it has no indication of having been through a sterilizing process');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 4, 11, 'Factors which compromise sterile stock are as follows except<br>(a)	incorrect cleaning procedures in the storage areas<br>(b)	moisture and condensation<br>(c)	incorrect temperature<br>(d)	excessive exposure to sunlight and other sources of ultraviolet light<br>(e)	vermin and insects<br>(f)	inappropriate packaging materials<br>(g)	incomplete sealing<br>(h)	different sterilization methods ¡V Steam, Sterrad, ETO etc<br>(i)	sharp objects or rough handling which may cause damage to packaging materials<br>(j)	incorrect handling during transport');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 4, 12, 'Sterile stock stored in drawers with latest date should be placed at the _____.<br>Sterile stock stored on shelves with latest date should be placed on the _____.');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 4, 13, 'Any item that has been sterilized over _____, it is the responsibility of the user to consider whether it should be kept sterile on shelf or removed it from the inventory.');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 4, 14, 'Any item which is easily degradable e.g. latex tubing should be assessed:');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 4, 15, 'Routine sterility check should perform half-yearly as back-up support to the practice of _____.');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 4, 16, 'Packages do not need expiration dates if an event-related standard is used. However, content is easily degradable, such as rubber, require an expiration date.');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 4, 17, 'An advantage of an event-related shelf-life standard is:');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 4, 18, 'Under event-related shelf-life standard, staff must advocate ¡§first in first out¡¨ on all sterile supplies.');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 4, 19, 'Shelf-life depends upon:');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 4, 20, 'When implementing event-related standards it ____ necessary to reprocess packaged items in storage according to the time-related expiration dates.');

INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 5, 1, 'Why are gas bottles always sealed? ¬°¤°»ò®ð¾ê­n±K«Ê¡H');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 5, 2, 'Cylinder valve must be free from oil and greases. ®ð»Ö¤£¯àªg¤Wªo¯×');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 5, 3, 'Valve should be closed even in empty cylinder. ªÅ¾ê®ð»Ö¤]­nÃö³¬');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 5, 4, 'We can use any apparatus with any gas cylinders. ¥ô¦ó»ö¾¹¾A¦X¥ô¦ó®ð¾ê');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 5, 5, 'When leakage is heard then we should use tape to plug the leakage. Å¥¨ìº|®ðÁn­µ­n¥Î½¦¯È°ô¶ëº|®ð');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 5, 6, 'When there is a fire, I should close cylinder valve and remove cylinder. ·í¤õÄµµo¥Í¡A§Ú¥i¥HÃö³¬®ð»Ö¤Î·h²¾®ð¾ê');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 5, 7, 'We should store the cylinders from heat, flame or spark. Àx¦s®ð¾êÀ³»·Â÷¼ö·½¡A©ö¿U©Î¤õ·½');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 5, 8, 'We can roll the LGC by holding its ring. ¥i¥H±ÛÂà¤èªk²¾°Ê¤p«¬²GºA®ñ®ð¬û');

INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 6, 01, 'The patient with a total hip replacement gets out of bed on their affected side.');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 6, 02, 'The patient with a total hip replacement bends the affected hip to more than 90¢X.');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 6, 03, 'After having a total hip replacement, the patient is asked to sit with their legs crossed.');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 6, 04, 'The patient is asked to sit on a low chair after a total hip replacement operation.');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 6, 05, 'After having a total hip replacement, the patient is asked to transfer from the edge of the bed to a chair placed on their unaffected side.');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 6, 06, 'The back of the bed is elevated when moving a patient up the bed.');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 6, 07, 'The patient is moved up the bed on the count of three.');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 6, 08, 'Where should we put our hands on to support during transferring a patient from bed to chair?');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 6, 09, 'What is the proper way to stand up from sitting position?');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 6, 10, 'Which of the following is not one of the steps for Bed ¡V Chair transfer?');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 6, 11, 'What is inappropriate in Bed ¡V Chair transfer?');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 6, 12, 'Which of the following statement is true for Bed ¡V Chair transfer?');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 6, 13, 'Which side of the patient should we stand on during Bed ¡V Chair transfer in case of one staff only?');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 6, 14, 'What type of patients that we should use the hoist?');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 6, 15, 'How many staff do we recommend to operate the hoist?');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 6, 16, 'Should we lock the hoist before hooking the sling onto it?');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 6, 17, 'Which side should the tag of the sling of the hoist face?');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 6, 18, 'Should we put an incontinence pad between the sling and the patient?');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 6, 19, 'While using hoist to lift up the patient, the second operator should help to support patient¡¦s _______');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 6, 20, 'Should we keep the sling underneath the patient after using the hoist?');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 6, 21, 'Should the sling of the hoist be crossed under patient¡¦s legs?');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 6, 22, 'Which of the following are the general principles of manual handling?');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 6, 23, 'Which is not the potential injury if wrong methods are being used during manual handling?');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 6, 24, 'What is/ are considered as the good posture for the nursing staff during manual handling?');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 6, 25, 'How many natural curves are present in a healthy/ normal person?');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 6, 26, 'Which segment of the spines is the most susceptible for an occupational hazard manual handling?');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 6, 27, 'Explanation to patients is needed before any transfer.');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 6, 28, '________ can be used for assisting patient to move to the edge of the bed.');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 6, 29, 'We proceed to transfer the patient even he/she feels dizziness.');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 6, 30, 'The head of the bed is raised to assist patient sitting up.');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 6, 31, 'For bed to chair transfer, wheelchair is put at the good side of the patient.');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 6, 32, '¡¥Easy Move¡¦ sliding board can transfer a patient from');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 6, 33, 'You can use the ¡¥Easy Move¡¦ sliding board to lift a patient.');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 6, 34, 'When using the ¡¥Easy Move¡¦ to transfer a patient, which of the following must be kept in the board?');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 6, 35, 'When a patient slide down to the foot of the bed, which of the following equipment can assist you to move the patient up in the bed?');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 6, 36, 'When you need someone to assist you in moving a patient, which of the following people you can ask?');

INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 7, 01, 'When lifting heavy objects, which of the following is the best method? ·h¹B­«ª«®É¡AÀ³¨Ì±q¤U¦C­þ¤@¶µ°µªk¤~¥¿½T?');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 7, 02, 'When lifting heavy objects, which of the following is the best way to reduce work injuries? ·h¹B­«ª«®É¡A¤U¦C­þ¤@¶µ¬O³Ì¦nªº¤èªk¥H´î¤Ö¤u¶Ë·N¥~¡H');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 7, 03, 'When performing MHO risk assessment, should consider the work task, the load, the working environment, and which of the followings? ·í¶i¦æÅé¤O³B²z¾Þ§@­·ÀIµû¦ô®É¡A¥²¶·¹ï¤u§@©Ê½è¡B­t²üª«¡B¤u§@Àô¹Ò¡B©M¤U¦C­þ¤@¶µ§@¥X¦Ò¼{¡H');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 7, 04, 'Which of the followings is not the consideration of MHO? ¥H¤U­þ¤@¶µ¤£¬OÅé¤O³B²z¾Þ§@®É¹ï­t²üª«À³¦³ªº¦Ò¼{¡C');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 7, 05, 'Highlight the way that the risk of injury from manual handling can be reduced. «ü¥X¬Æ»ò¤èªk¯à±qÅé¤O³B²z¾Þ§@¤¤´î§C¤u¶Ëªº­·ÀI¡C');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 7, 06, 'Which of the followings is important and correct in manual handling? ¥H¤U­þ¤@¶µ¬O¥¿½T¤H¤O´£Á|ªº­nÂI¡H');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 7, 07, 'What is the distance between the Computer User (Staff) and the Screen? ¿ì¤½«Ç¹q¸£­ûªº²´·úÀ³Â÷¶}¿Ã¥ú¹õ¦h¤Ö¡H');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 7, 08, 'How many castors are appropriate for a computer chair? ¤@±i¹q¸£´ÈÀ³¨ã³Æ¦h¤Ö­Ó¸}½ü¥H¨DÃ­©T¡H');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 7, 09, 'Which of the following can prevent neck pain from prolong typing due to looking down for long time? ¥H¤U­þ¤@¶µ¥iÁ×§K¥´¦r®Éªø®É¶¡««¤UÀY±æ¤å¥ó³y¦¨ªºÀVµh¡H');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 7, 10, 'A suitable chair ¤@±iµÎ¾A®y´È:');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 7, 11, 'The employer should make the assessment to reduce the risk of injury from manual handling. ¹µ¥D­n¬°­û¤u°µÅé¤O³B²z¾Þ§@ªºµû¦ô¥H´î§C¤u¶Ëªº­·ÀI¡C');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 7, 12, 'Which part of the body will suffer the most during inappropriate lifting? ¤£¾A·íªº©ïÁ|¤èªk·|¥O¨­Åé¨º¤@³¡¦ì¾D¨ü³Ì¤j·l¶Ë¡H');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 7, 13, 'What problems are there to look for when making an assessment? ±qµû¦ô¤¤»Ý­n§ä¥X¥H¤U¨Æ¶µ¡H');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 7, 14, 'Training is an important part of reducing the risk of manual handling injuries. °V½m¬O´î§CÅé¤O³B²z¾Þ§@¤u¶Ë­·ÀIªº¥D­n³¡¥÷¡C');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 7, 15, 'Which is the proper way to avoid back injury during lifting? ¨º¤@­Ó¬O¾A·íªº©ïÁ|¤èªk¥H¨¾¤î­I³¡¨ü¶Ë¡H');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 7, 16, 'The Occupational Safety and Health Ordinance covers the Manual Handling Operations. Â¾·~¦w¥þ¤Î°·±d±ø¨Ò¥]§tÅé¤O³B²z¾Þ§@¦u«h¡C');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 7, 17, 'When to perform a risk assessment on Display Screen Equipment? ¦ó®É¶·­n§@¥XÅã¥Ü«Ì¹õ³]³Æ­·ÀIµû¦ô¡H');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 7, 18, 'Which of the following can prevent neck pain from prolong typing due to looking down for long time? ¥H¤U­þ¤@¶µ¥iÁ×§K¥´¦r®Éªø®É¶¡««¤UÀY±æ¤å¥ó³y¦¨ªºÀVµh¡H');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 7, 19, 'A suitable chair ¤@±iµÎ¾A®y´È:');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 7, 20, 'Incorrect manual handling operations involving : ¤£¥¿½T¦a¶i¦æÅé¤O³B²z¾Þ§@¥]¬A:');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 7, 21, 'If task involves holding loads at a distance from the body trunk, the best protective  measures are : ­Y¸Ó¤u§@¯A¤Î¾Þ±±»·Â÷¨­Åéªºª«¥ó¡A³Ì¦³®Äªº¤èªk¬O :');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 7, 22, 'In order to avoid stooping posture and to reduce the bending movements, which of the followings is not correct? ¬°¤FÁ×§KÅs¨­ªº«º¶Õ¤Î´î¤Ö©}¦±ªº°Ê§@¡A¤U¦C­þ¤@¶µ¤èªk¤£¥¿½T?');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 7, 23, 'Which of the followings can solve the problems of excessive carrying distances? ¤U¦C­þ¤@¶µ¤èªk¥i¥H¸Ñ¨M¹Lªøªº¹B¸ü¶ZÂ÷¤Þ­Pªº°ÝÃD?');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 7, 24, 'Handling of heavy loads can be made easier by : °Ñ¦Ò¥H¤U¤èªk¥i»´©ö¦a³B²z­«ªº­t²üª« :');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 7, 25, 'Which of the followings is correct? ¤U¦C­þ¤@¶µ¥¿½T?');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 7, 26, 'Employees should wear special protective clothing to reduce risk of injury during MHO, which of the followings is correct? ¹µ­û»Ý¬ïµÛ¯S®í«OÅ@¦çª«´î¤ÖÅé¤O³B²z¾Þ§@®É¨ü¶Ë¡A¤U¦C­þ¤@¶µ¥¿½T?');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 7, 27, 'Repeated awkward postures refer to the performance of repetitive tasks with the following postures : ­«ÂÐªº¤£¨}«º¶Õ¬O«üºû«ù¦b¥H¤Uªº«º¶Õ­«ÂÐ¤u§@:');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 7, 28, 'Repeated awkward postures refer to the performance of repetitive tasks with the following postures : ­«ÂÐªº¤£¨}«º¶Õ¬O«üºû«ù¦b¥H¤Uªº«º¶Õ­«ÂÐ¤u§@:');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 7, 29, 'Incorrect manual handling operations involving : ¤£¥¿½T¦a¶i¦æÅé¤O³B²z¾Þ§@¥]¬A:');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 7, 30, 'The definition of Display Screen Equipment is Åã¥Ü«Ì¹õ³]³Æªº©w¸q¬O:');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 7, 31, 'Common discomforts associated with the use of DSE including: ¨Ï¥ÎÅã¥Ü«Ì¹õ³]³Æ±`¨£ªº¤£¾A±¡ªp¥]¬A:');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 7, 32, 'Visual fatigue associated with the use of DSE, can be caused by : ¦]¨Ï¥ÎÅã¥Ü«Ì¹õ³]³Æ¤Þ­P²´·ú¯h³Òªº­ì¦]:');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 7, 33, 'The main features of a DSE workstation design including: ¦Xªþ¦w¥þ³]­pªºÅã¥Ü«Ì¹õ³]³Æ¤u§@¶¡¥]¬A');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 7, 34, 'Work surface of a DES workstation should Åã¥Ü«Ì¹õ³]³Æ¤u§@¶¡?­±À³¸Ó:');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 7, 35, 'A suitable chair for DES workstation should be Åã¥Ü«Ì¹õ³]³Æ¤u§@¶¡ªº®y´ÈÀ³¸Ó:');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 7, 36, 'To avoid reflections and glare from the screen of DSE, which of the followings is correct Á×§KÅã¥Ü«Ì¹õ¤Ï¥ú¤Î¯t¥ú¡A¤U¦C­þ¤@¶µ¥¿½T¡H');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 7, 37, 'The mouse of a DSE should be positioned Åã¥Ü«Ì¹õ·Æ¹«Â\©ñ¦ì¸mÀ³¸Ó:');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 7, 38, 'Which of the followings is a proper sitting posture ¥H¤U­þ¤@¶µ¬O¥¿½T§¤«º?');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 7, 39, 'Display Screen Equipment setting should beÅã¥Ü«Ì¹õÀ³¸Ó :');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 7, 40, 'Keyboard setting should be Áä½L³]­pÀ³¸Ó :');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 7, 41, 'Mouse setting should be ·Æ¹«³]­pÀ³¸Ó :');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 7, 42, 'Which of the followings is not applied under the Occupational Safety and Health (Display Screen Equipment) Regulation ¥H¤U­þ¤@¶µ¤£¬OÂ¾·~¦w¥þ¤Î°·±d(Åã¥Ü«Ì¹õ³]³Æ)³W¨Ò©Ò³WºÞªº¤u§@¶¡?');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 7, 43, 'Which of the followings will cause injury while caring a patient ·í·Ó®Æ¯f¤H®É¥H¤U­þ¤@¶µ·|¾É­P¨ü¶Ë?');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 7, 44, 'To avoid twisting the body trunk in MHO, which of the followings is correct ¥H¤U­þ¤@¶µ¤èªk¥i¥HÁ×§KÅé¤O³B²z¾Þ§@®É§á°Ê¨­Åé¡H');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 7, 45, 'Which of the following sentences is NOT preventing injuries in MHO¥H¤U­þ¤@¥y¤£¬O¨¾¤îÅé¤O³B²z¾Þ§@®É¨ü¶Ë¡H');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 7, 46, 'To avoid reaching upward in MHO, which of the following methods is appropriate Á×§KÅé¤O³B²z¾Þ§@®É¦V¤W¦ù®i¡A¥H¤U­þ¤@¶µ¤èªk¾A¦X¡H');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 7, 47, 'Which of the followings can help in reducing excessive lifting in MHO ¥H¤U­þ¤@¶µ¤èªk¥i´î¤ÖÅé¤O³B²z¾Þ§@®É¹L¶q²¾°Ê­t²üª«¡H');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 7, 48, 'To prevent excessive carrying distances in MHO, which of the followings is correct Á×§KÅé¤O³B²z¾Þ§@®É¹Lªøªº¹B¸ü¶ZÂ÷¡A¥H¤U­þ¤@¶µ¥¿½T¡H');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 7, 49, 'Which part of the body will suffer the most during inappropriate lifting? ¤£¾A·íªº©ïÁ|¤èªk·|¥O¨­Åé¨º¤@³¡¦ì¾D¨ü³Ì¤j·l¶Ë¡H');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 7, 50, 'Which of the followings is incorrect manual handling operations ? ¥H¤U­þ¤@¶µ¬O¤£¥¿½T¦a¶i¦æÅé¤O³B²z¾Þ§@?');

INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 8, 01, 'Three factors that must be present for fire to start are ¦³3 ­Ó¦]¯À·|¾É­P¤õ¨a-®ñ(ªÅ®ð)¡B¿U®Æ¤Î  _____________________.');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 8, 02, 'The correct order of using the extinguisher is : ¥¿½T¨Ï¥Î·À¤õ¾¹ªº¥¿½Tµ{§Ç¬O:<br>a.	Remove pin ²¾¶}§O°w<br>b.	Hold the handle (far side)´¤µÛÂ÷¨­Åé¸û»·¤â¬`<br>c.	Extinguish (4-6 feet) º¶·À (4-6¤Ø)<br>d.	Choose the correct extinguisher ¿ï¾Ü¥¿½Tªº·À¤õ¾¹');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 8, 03, 'For Class A, (classification of fire) which of the following material is burning:');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 8, 04, 'For Class B, (classification of fire) which of the following material is burning:');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 8, 05, 'For Class C, (classification of fire) which of the following material is burning:');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 8, 06, 'Which of the following extinguisher should be used to extinguish Electrical appliances fire');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 8, 07, 'Which of the following extinguisher should be used to extinguish wood, fabrics and combustible material¡¦s fire');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 8, 08, 'Which of the following extinguisher should be used to extinguish oil, fats, spirits, grease and such substances¡¦ fire');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 8, 09, 'During a fire, casualties that need immediate life saving care should be color-coded as which of the following color :');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 8, 10, 'During a fire, casualties that need advanced medical treatment but are not life threatened should be color-coded as which of the following color');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 8, 11, 'During a fire, casualties that have minor injury (so that delay of medical treatment will not adversely affect prognosis) should be color-coded as which of the following color');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 8, 12, 'During a fire, casualties that arrive dead or die at HKAH should be color-coded as which of the following color');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 8, 13, 'What do you do if there is a fire in your work area? ·í¤õ¨aµo¥Í¦b§A¤u§@ªº½d³ò®É¡A§A·|¦p¦ó³B²z?');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 8, 14, 'All employees should participate in the yearly hospital-wide Fire Drills to assure that the Fire/Safety emergency procedures are well implemented ©Ò¦³­û¤uÀ³°Ñ»P¨C¦~ªº¥þ°|ªº¤õÄµºt²ß¡A¥h½T«O¤õ¨aÀ³ÅÜµ{§Ç¯à¦b¥¿½T±¡ªp¤U¶i¦æ');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 8, 15, 'In case of fire, you should  ¦b¤õ¨aµo¥Í®É¡AÀ³«O«ù');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 8, 16, 'Unless specified, the location of Assembly Point in case of disaster is: °£«D¯S§O«ü©w¡A¨«Á×¨aÃø¤§¶°¦X¦aÂI¬°¡G');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 8, 17, 'All corridor and stairways: ¥þ³¡¨«´Y¤Î¼Ó±è¥²¶·¡G');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 8, 18, 'Unless specified, the Command Centre is located at: °£«D¯S§O«ü©w¡A±Ï¨a«ü´§¤¤¤ßªº¦aÂI¬O¦b¡G');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 8, 19, 'The one who is responsible for coordinating and providing medical treatment of disaster casualties is: ­t³d¨ó½Õ¤Î´£¨ÑÂåÀøµ¹¨aÃø¦º¶ËªÌªº¤H¬O¡G');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 8, 20, 'Working with House Administrative Supervisor, the one who is responsible for staffing need during disaster is: »P¦æ¬FÅ@²z¸g²z¦X§@´£¨Ñ±Ï¨a¤u§@¤H­ûªº­t³d¤H¬O¡G');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 8, 21, 'At the Assembly Point, you should: ¦b¶°¦X¦aÂI¡A§A¥²¶·¡G');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 8, 22, 'When Information Desk Staff calls for Code Black, it means there is');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 8, 23, 'Code Yellow represents which of the following disasters:');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 8, 24, 'Code White represents which of the following disasters:');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 8, 25, 'RACE stands for which of the following:');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 8, 26, 'During a disaster, the casualties that need immediate life saving care should be sent to');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 8, 27, 'During a disaster, the casualties that have minor injury and need only minor treatment are sent to');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 8, 28, 'Smoking is allowed in');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 8, 29, 'The fire doors must be');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 8, 30, 'Fire devices include which one of the following');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 8, 31, 'In case of fire, the first thing you must do is to');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 8, 32, 'The standard locations where fire devices can be found in HKAH is');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 8, 33, 'All departments should have their own ¡§Departmental Disaster Manual¡¨ to efficiently operate in Disaster event so that injury and lost can be minimized.');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 8, 34, 'It is safe for you to extinguish the fire only when');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 8, 35, 'When a mattress is involved in a fire, you should');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 8, 36, 'When someone is making a bomb threat over the phone, you should');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 8, 37, 'If you find a suspicious package without any notification, you should');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 8, 38, 'Which one of the following is true when using a fire blanket');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 8, 39, 'Which one of the following is not true about the Fire Breakglass panel');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 8, 40, 'Which of the following are included in staff Fire Safety Disaster training?');

INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 9, 01, 'What to do when meeting a customer for the first time:');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 9, 02, 'We lose customers because  (chose the best answer)');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 9, 03, 'Sense people¡¦s need before they ask and never take action');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 9, 04, 'Customers judge their experience by the way they are treated as a person');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 9, 05, 'Reputation is EVERYTHING');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 9, 06, 'A customer is an interruption to our work');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 9, 07, 'A staff¡¦s attitude does not matter much in the workplace');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 9, 08, 'Customer Satisfaction is do it right the first time we serve our customers');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 9, 09, 'We can win back customers even when they complain');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 9, 10, 'Your attitude will determine your altitude');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 9, 11, 'We do the same things more consistently especially under pressure and only sometimes');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 9, 12, 'SHARE focuses on whole person health');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 9, 13, 'S in SHARE stands for');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 9, 14, 'H in SHARE stands for');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 9, 15, 'E in SHARE stands for');
--iv therapy
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 14, 01, 'What is the percentage of body fluid in total body mass');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 14, 02, 'The movement of body fluid and electrolyte is affected by');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 14, 03, 'What are the contraindication(s) for venipunture');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 14, 04, 'What is the suitable size of the IV catheter for TRAUMA patients');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 14, 05, 'Where is the recommended site for peripheral venous cannulation when patient is');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 14, 06, 'Lactated Ringer’s Solution is a/an_________solution');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 14, 07, 'The most important thing you should do before the IV insertion for all patients is');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 14, 08, 'The tourniquet can be applied_________inches above the punctured site in order to have');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 14, 09, 'Complications of the intravenous therapy are');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 14, 10, 'The composition of body fluid include(s)');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 14, 11, 'For pediatric and neonates,________of intravenous catheter is recommended for use.');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 14, 12, '5% Dextrose in water is a/an_________solution');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 14, 13, '__________precaution is adopted during IV insertion');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 14, 14, 'When you choosing an IV site, you should');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 14, 15, 'You need to administer 200mL of 0.9% sodium chloride over 1 hour. You have 500ml solution of 0.9% sodium chloride on hand. Your administration set is 20gtt/mL. How many gtt/min will you administered?');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 14, 16, 'A nurse recognize the patient is under dehydration which is evidenced by dry and sticky mucous membrane, poor skin turgor, low urine output and which of the following');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 14, 17, 'The fluid load status of the patient can be assessed by');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 14, 18, 'The two main electrolytes in intracellular and extracellular space are');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 14, 19, 'Which of the following is/are the optimal vein condition?');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 14, 20, 'The ratio of intracellular to extracellular fluid is:');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 14, 21, 'Which of the following statement is CORRECT to describe the function of Chloride?');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 14, 22, 'Scalp veins are highly recommended for intravenous therapy for pediatric patients under any circumstances.');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 14, 23, 'Intraosseous cannulation is an alternative for unsuccessful peripheral venous access after 3 attempts or 90 seconds for child is under 6 years of age.');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 14, 24, 'Fluid and electrolytes in the body are static');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 14, 25, 'Intravenous is the only route for administration of medications in pediatric patients. ');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 14, 26, 'The normal range for the serum Sodium(Na) level is 135-145mEq/L.');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 14, 27, 'The level of potassium is higher in the intracellular than extracellular space.');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 14, 28, 'Phlebitis or inflammation of the vein is recognized as a warm, red area surrounding the insertion site of the catheter.');
INSERT INTO EE_ELEARNING_QUESTION(EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_QUESTION) VALUES ('hkah', 14, 29, 'Insertion of central venous line is an aseptic procedure.');



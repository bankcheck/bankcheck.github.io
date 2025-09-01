CREATE OR REPLACE FUNCTION "NHS_GEN_CHECKDIGIT" (
	v_patno IN VARCHAR2
)
	RETURN VARCHAR2
AS
	TYPE keyisNumType IS TABLE OF VARCHAR2(10) INDEX BY VARCHAR2(10);
	TYPE keyisCharType IS TABLE OF VARCHAR2(10) INDEX BY VARCHAR(10);
	keyisNum keyisNumType;
	keyisChar keyisCharType;
	a NUMBER;
	b NUMBER;
	checkdigit varchar(10);
	calPatNo number;
	iCount number;
	tempPatNo varchar(10);
begin
	b := 10;
	FOR a in 0 .. 9 LOOP
		keyisNum(TO_CHAR(a)) := TO_CHAR(a);
	END LOOP;
	FOR a in 65 .. 90 LOOP
		keyisNum(TO_CHAR(b)) := CHR(a);
		b := b + 1;
	END LOOP;

	keyIsNum('36') := '-';
	keyIsNum('37') := '.';
	keyIsNum('38') := ' ';
	keyIsNum('39') := '$';
	keyIsNum('40') := '/';
	keyIsNum('41') := '+';
	keyIsNum('42') := '%';

	FOR a in 0 .. 9 LOOP
		keyisChar(TO_CHAR(a)) := TO_CHAR(a);
	END LOOP;
	b := 10;
	FOR a in 65 .. 90 LOOP
		keyisChar(CHR(a)) := TO_CHAR(b);
		b := b + 1;
	END LOOP;

	keyIsChar('-') := '36';
	keyIsChar('.') := '37';
	keyIsChar(' ') := '38';
	keyIsChar('$') := '39';
	keyIsChar('/') := '40';
	keyIsChar('+') := '41';
	keyIsChar('%') := '42';

	iCount := 0;
	for a in 1 ..Length(v_patno) LOOP
		iCount := iCount + TO_NUMBER(keyIsChar(SUBSTR(v_patno, a, 1)));
	END LOOP;

	return keyIsNum(TO_CHAR(MOD(iCount, 43)));
end NHS_GEN_CHECKDIGIT;
/

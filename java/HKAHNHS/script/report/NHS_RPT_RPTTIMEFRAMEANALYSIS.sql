CREATE OR REPLACE FUNCTION NHS_RPT_RPTTIMEFRAMEANALYSIS (
	v_startdate VARCHAR2,
	v_enddate VARCHAR2
)
	RETURN Types.cursor_type
AS
	outcur types.cursor_type;
BEGIN
	OPEN outcur FOR
		select regid,OPType,regdate,
			decode(sign(to_number(regdate)-899),-1,0,decode(sign(to_number(regdate)-1300),-1,1,0))CountSEC1,
			decode(sign(to_number(regdate)-1299),-1,0,decode(sign(to_number(regdate)-1700),-1,1,0))CountSEC2,
			decode(sign(to_number(regdate)-1699),-1,0,decode(sign(to_number(regdate)-2100),-1,1,0))CountSEC3,
			decode(sign(to_number(regdate)-2099),-1,decode(sign(to_number(regdate)-900),-1,1,0),decode(sign(to_number(regdate)-2400),-1,1,0)) CountSEC4,
			decode(Sign(to_number(regdate)-899)-Sign(to_number(regdate)- 1300),2,'09:00-12:59',
			decode(Sign(to_number(regdate)-1299)-Sign(to_number(regdate)- 1700),2,'13:00-16:59',
			decode(Sign(to_number(regdate)-1699)-Sign(to_number(regdate)- 2100),2,'17:00-20:59',
			decode(Sign(to_number(regdate)-2099)-Sign(to_number(regdate)- 2400),2,'21:00-8:59',
			decode(Sign(to_number(regdate)-900),-1,'21:00-8:59','Unknown section'))))) GroupSEC,
			decode(Sign(to_number(regdate)-899)-Sign(to_number(regdate)- 1300),2,1,
			decode(Sign(to_number(regdate)-1299)-Sign(to_number(regdate)- 1700),2,2,
			decode(Sign(to_number(regdate)-1699)-Sign(to_number(regdate)- 2100),2,3,
			decode(Sign(to_number(regdate)-2099)-Sign(to_number(regdate)- 2400),2,4,
			decode(Sign(to_number(regdate)-900),-1,4,5))))) GroupSEC2,
			Decode(spccode,'GP','GP','SP') GroupDocSpec
		from
			(SELECT
			       r.regid,
			       decode(r.regopcat, 'N', 'Normal', 'U' , 'Urgent-Care', 'P' , 'Priority', 'W', 'Walk-In', r.regopcat) as OPType,
			       to_char(r.regdate, 'HH24MI') as regdate,
			       d.spccode
			FROM
			       reg r,
			       doctor d
			WHERE  r.regdate>= to_date(v_startdate, 'dd/mm/yyyy')
			and    r.regdate< to_date(v_enddate, 'dd/mm/yyyy') + 1
			and    r.regtype= 'O'
			and    r.regsts= 'N'
			and    r.doccode= d.doccode) order by  OPType, GroupSEC,GroupDocSpec ;
RETURN OUTCUR;
END NHS_RPT_RPTTIMEFRAMEANALYSIS;
/

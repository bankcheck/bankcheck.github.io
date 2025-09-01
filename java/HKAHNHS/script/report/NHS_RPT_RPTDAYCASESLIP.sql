CREATE OR REPLACE FUNCTION NHS_RPT_RPTDAYCASESLIP (
	v_EndDate VARCHAR2,
	v_SteCode VARCHAR2,
	v_otp2  VARCHAR2
)
	RETURN Types.cursor_type
AS
	outcur types.cursor_type;
BEGIN
	DELETE FROM diosliptemp;

	insert into diosliptemp
	select st.slpno, SUM(stnnamt) as netamt , 'N'
	From   sliptx st
	Where (stncdate is null or stncdate >= to_date(v_EndDate, 'DD/MM/YYYY') + 1)
	and    stnsts in ('N','A')
	GROUP BY st.slpno
	having sum(stnnamt) <> 0;

	IF v_otp2 = 1 THEN
		OPEN outcur FOR
			select
				sit.stename, s.doccode, s.slpno, s.patno, to_char(r.regdate, 'dd/mm/yyyy') regdate,
				decode(s.slpfname, null, p.patfname || ' ' || p.patgname, s.slpfname || ' ' || s.slpgname) as patname,
				round(((slppamt + slpdamt + slpcamt - nvl(st.netamt, 0)) / (abs(slppamt+slpdamt+slpcamt - nvl(st.netamt, 0)) + 1))) as G,
				(slppamt + slpdamt + slpcamt - nvl(st.netamt, 0)) as amount, max(s.slpRemark) as slpRemark, slpsts
			from
				slip s, (
					select st.slpno, SUM(stnnamt) as netamt , 'N'
					From sliptx st
					Where
					(stncdate is null or stncdate >= to_date(v_EndDate,'DD/MM/YYYY') + 1)
					and stnsts in ('N','A')
					group by st.slpno
					having sum(stnnamt) <> 0 )st, reg r, patient p, site sit
			where r.regtype = 'D'
			and   s.slptype = 'D'
			and   s.slpno   = st.slpno (+)
			and   s.regid = r.regid (+)
			and   s.stecode = v_SteCode
			and   s.patno   = p.patno (+)
			and   s.stecode   = sit.stecode
			group by
				round((slppamt+slpdamt+slpcamt - nvl(st.netamt,0)) / (abs(slppamt+slpdamt+slpcamt - nvl(st.netamt,0))+1)),
				(slppamt+slpdamt+slpcamt - nvl(st.netamt,0)),
				s.slpno, s.doccode, r.regdate, p.patfname || ' ' || p.patgname, sit.stename, s.patno,
				s.slpfname, s.slpgname, slpsts
			HAVING NOT ((s.slpsts = 'C' OR s.slpsts = 'R') AND (slppamt + slpdamt + slpcamt - nvl(st.netamt,0)) = 0)
			order by 7 desc;
	ELSE
		OPEN outcur FOR
			select
				sit.stename, s.doccode, s.slpno, s.patno, to_char(r.regdate, 'dd/mm/yyyy') regdate,
				decode(s.slpfname,null,p.patfname || ' ' || p.patgname, s.slpfname||' '||s.slpgname) as patname,
				round(((slppamt + slpdamt + slpcamt - nvl(st.netamt, 0)) / (abs(slppamt + slpdamt + slpcamt - nvl(st.netamt, 0)) + 1))) as G,
				(slppamt + slpdamt + slpcamt - nvl(st.netamt, 0)) as amount, '' as slpRemark, slpsts
			from
				slip s, (
				select st.slpno, SUM(stnnamt) as netamt , 'N'
				From   sliptx st
				Where (stncdate is null or stncdate >= to_date(v_EndDate, 'DD/MM/YYYY') + 1)
				and    stnsts in ('N','A')
				group by st.slpno
				having sum(stnnamt) <> 0 )st, reg r, patient p, site sit
			where r.regtype = 'D'
			and   s.slptype = 'D'
			and   s.slpno   = st.slpno (+)
			and   s.regid   = r.regid (+)
			and   s.stecode = v_SteCode
			and   s.patno   = p.patno (+)
			and   s.stecode = sit.stecode
			group by
				round((slppamt + slpdamt + slpcamt - nvl(st.netamt, 0)) / (abs(slppamt + slpdamt + slpcamt - nvl(st.netamt, 0)) + 1)),
				(slppamt + slpdamt + slpcamt - nvl(st.netamt, 0)),
				s.slpno, s.doccode, r.regdate, p.patfname || ' ' || p.patgname, sit.stename, s.patno,
				s.slpfname, s.slpgname, slpsts
			HAVING NOT ((s.slpsts = 'C' OR s.slpsts = 'R') AND (slppamt+slpdamt+slpcamt - nvl(st.netamt,0)) = 0)
			order by 7 desc;
	END IF;
	RETURN outcur;
END NHS_RPT_RPTDAYCASESLIP;
/

CREATE VIEW STAFF_NURSE AS select cs1.co_staff_id 
from co_staffs cs1 
where 
co_enabled = 1
and co_department_code in ('120', '360', '220', '365', '362', '110', '100', '130', '330', '140', '780', '370', '200', '320', '770' );

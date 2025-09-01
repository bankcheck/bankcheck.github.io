CREATE VIEW STAFF_NURSE AS 
select cs1.co_staff_id 
from co_staffs cs1 
where co_department_code in ( 'U400', 'U100', 'U300', 'U200', 'CCIC', 'HEMO', 'OR', 'OPD', 'NUAD', 'IC' );
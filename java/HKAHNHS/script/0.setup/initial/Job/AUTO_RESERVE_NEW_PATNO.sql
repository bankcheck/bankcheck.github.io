BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
            job_name => '"HKAH"."AUTO_RESERVE_NEW_PATNO"',
            job_type => 'STORED_PROCEDURE',
            job_action => 'HKAH.NHS_UTL_RESERVE_NEW_PATNO',
            number_of_arguments => 0,
            start_date => NULL,
            repeat_interval => 'FREQ=HOURLY;BYMINUTE=3;BYSECOND=0',
            end_date => NULL,
            enabled => FALSE,
            auto_drop => FALSE,
            comments => 'AUTO_RESERVE_NEW_PATNO');

         
     
 
    DBMS_SCHEDULER.SET_ATTRIBUTE( 
             name => '"HKAH"."AUTO_RESERVE_NEW_PATNO"', 
             attribute => 'logging_level', value => DBMS_SCHEDULER.LOGGING_RUNS);
      
  
    
    DBMS_SCHEDULER.enable(
             name => '"HKAH"."AUTO_RESERVE_NEW_PATNO"');
END;

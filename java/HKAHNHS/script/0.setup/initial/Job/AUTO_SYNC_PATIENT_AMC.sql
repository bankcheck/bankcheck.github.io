-- run at master site (HKAH-SR) only
BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
            job_name => '"HKAH"."AUTO_SYNC_PATIENT_AMC"',
            job_type => 'STORED_PROCEDURE',
            job_action => 'HKAH.NHS_UTL_SYNC_PATIENT_AMC',
            number_of_arguments => 0,
            start_date => NULL,
            repeat_interval => 'FREQ=MINUTELY;BYMINUTE=2,7,12,17,22,27,32,37,42,47,52,57',
            end_date => NULL,
            enabled => FALSE,
            auto_drop => FALSE,
            comments => 'AUTO_SYNC_PATIENT_AMC');

         
     
 
    DBMS_SCHEDULER.SET_ATTRIBUTE( 
             name => '"HKAH"."AUTO_SYNC_PATIENT_AMC"', 
             attribute => 'logging_level', value => DBMS_SCHEDULER.LOGGING_RUNS);
      
  
    
    DBMS_SCHEDULER.enable(
             name => '"HKAH"."AUTO_SYNC_PATIENT_AMC"');
END;

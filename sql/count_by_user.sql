with vw as (SELECT
  user_email,job_id,
  query,
  job.state,
  DATETIME(TIMESTAMP_TRUNC(job.creation_time, HOUR), "America/Los_Angeles") AS creation_time,
  max(round(TIMESTAMP_DIFF(ifnull(end_time,current_timestamp()),ifnull(start_time,creation_time),SECOND)/60,3)) over (partition by user_email) as max_query_execution_time_min,
  round(TIMESTAMP_DIFF(ifnull(end_time,current_timestamp()),ifnull(start_time,creation_time),SECOND)/60,3) query_execution_time_min,
  count(query) over (partition by user_email) query_count_by_user_in_24hr
FROM
  `region-us`.INFORMATION_SCHEMA.JOBS job
WHERE
  creation_time BETWEEN TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 1 DAY )
  AND CURRENT_TIMESTAMP()
  )
  select  user_email,query_count_by_user_in_24hr,max_query_execution_time_min,  array(select as struct   query,creation_time,state,query_execution_time_min    from vw v2 where v2.user_email=v1.user_email ) as queries   from vw v1  
 group by 1,2,3
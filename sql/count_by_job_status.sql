WITH
  vw AS (
  SELECT
    job_id,
    query,
    job.state,
    job.total_slot_ms/(1000 * 60 * 60) slots_consumed_by_query,
    EXTRACT(HOUR
    FROM
      DATETIME(job.creation_time, "America/Los_Angeles")) AS run_hour,
    EXTRACT(DATE
    FROM
      DATETIME(job.creation_time, "America/Los_Angeles")) AS run_date,
    MAX(job.total_slot_ms/(1000 * 60 * 60)) OVER (PARTITION BY state) higest_slots_consumed_by_query,
    MAX(ROUND(TIMESTAMP_DIFF(IFNULL(end_time,CURRENT_TIMESTAMP()),IFNULL(start_time,creation_time),SECOND)/60,3) ) OVER (PARTITION BY state) AS max_query_execution_time_min,
    ROUND(TIMESTAMP_DIFF(IFNULL(end_time,CURRENT_TIMESTAMP()),IFNULL(start_time,creation_time),SECOND)/60,3) query_execution_time_min,
    COUNT(state) OVER (PARTITION BY state) count_by_query_state
  FROM
    `region-us`.INFORMATION_SCHEMA.JOBS job
  WHERE
    creation_time BETWEEN TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 6 hour )
    AND CURRENT_TIMESTAMP()
    AND job_type = 'QUERY' )
SELECT
  state,
  count_by_query_state,
  max_query_execution_time_min,
  higest_slots_consumed_by_query,
  ARRAY(
  SELECT
    AS STRUCT job_id,query,run_hour,run_date,query_execution_time_min,slots_consumed_by_query
  FROM
    vw v2
  WHERE
    v2.state=v1.state ) AS queries
FROM
  vw v1
WHERE
  state='RUNNING'
GROUP BY
  1,
  2,
  3,
  4
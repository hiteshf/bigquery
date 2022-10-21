Ref : All these SQLs are built upon Bigquery INFORMATION_SCHEMA.To learn more visit [Google Cloud](https://cloud.google.com/bigquery/docs/information-schema-jobs).
# bigquery
Contains SQLs I use regurlary to check bigquery job stats.

- sql\count_by_user.sql : Shows information about number of queries for each user under the project along with time of longest query executed in last 24hrs 
- sql\count_by_job_status.sql : Show similar information as above query however this one gives stats by job status. 
    - This query gives you how many pending/running/pending jobs hourly
    - with state='RUNNING' where clause, it shows time of longest running query in minutes along with higest slots consumed slots by any query so far.
    - with state='PENDING' where claues, it shows pending queries with time of longest waiting query in minutes.

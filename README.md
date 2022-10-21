Ref : All these SQLs are built upon Bigquery INFORMATION_SCHEMA.To learn more visit [Google Cloud](https://cloud.google.com/bigquery/docs/information-schema-jobs).
# bigquery
Contains SQLs I use regurlary to check bigquery job stats.

- sql\count_by_user.sql : Shows information about number of queries for each user under the project along with time of longest query executed in last 24hrs 
- sql\count_by_job_status.sql : Show similar information as above query however this one gives stats by job status. This is really useful to check and find out if there are very high number of queries running or pending during any hour of the day.
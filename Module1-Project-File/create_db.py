import duckdb

con = duckdb.connect("sgJobData.db")

con.sql(
    "CREATE TABLE sg_job_data AS SELECT * FROM read_csv_auto('/home/user/Downloads/leads_env/SGJobData.csv', HEADER=TRUE);"
)
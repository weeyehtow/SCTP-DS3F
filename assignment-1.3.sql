/*Scenario:

You have been hired by a local community library to digitize their catalog. They currently use a paper notebook. They need a database to track Books, Members, and Loans (who borrowed what).

Requirements:

    Books Table: Needs a title, author, and a unique ISBN (13 characters).
    Members Table: Needs a name, email, and join date. Email must be unique.
    Loans Table: Tracks which member borrowed which book and when.
        Constraint: You cannot loan a book that doesn't exist.
        Constraint: You cannot loan to a member who doesn't exist.
        Constraint: The 'return_date' can be null (meaning they haven't returned it yet), but the 'loan_date' is required.

Task:

Write the SQL DDL statements to create these three tables in a new schema called library.*/
CREATE SCHEMA library


/* Case Study 2: The "Marketing Dump" (Data Ingestion)

Scenario:

The marketing team has sent you a raw CSV file named leads_raw.csv containing potential customer data collected from a web form. The file is messy and unstructured.

Task:

    Create a Staging Table: Create a table called marketing_leads in the public schema. Since the source data is messy, be generous with your data types (use VARCHAR for almost everything to prevent import errors).
    Import Data: Write the COPY command to load the CSV data into your table.
    Create a View: Create a view called valid_leads that filters out rows where the contact_info does NOT contain an '@' symbol (excluding phone numbers).
*/

CREATE TABLE marketing_leads (
    id INTEGER,
    full_name VARCHAR,
    contact_info VARCHAR,
    signup_date DATE);
    
COPY marketing_leads FROM 'https://raw.githubusercontent.com/weeyehtow/6m-data-1.3-sql-basic-ddl/main/data/leads_raw.csv' (allow_quoted_nulls);

CREATE VIEW invalid_leads AS SELECT --renamed as invalid_lead to better reflect task requirments
    id,
    full_name, 
    contact_info AS ContactDetails,--rename field header as ContactDetails
    signup_date
FROM marketing_leads    
WHERE contact_info NOT LIKE '%@%'; --filters out records containing @ in contact_info field
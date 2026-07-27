/*
LOAD_BRONZE

PURPOSE: Loading data into the tables

WARNING: I have load the data into the tables using IMPORT data option from pgadmin. 
		 So if you want to insert new data, first you must truncate the old data, before take a backup for old data.

NOTE: Since i have imported data using IMPORT option, I'm just checking the data quality here
*/

/*truncate table bronze.crm_cust_info;
copy bronze.crm_cust_info(cst_id, cst_key, cst_firstname, cst_lastname, cst_marital_status, cst_gndr, cst_create_date)
from 'C:\Users\Santhosh Kumar\Financial Analysis\Data_analysis_projects\Bar_data_warehouse\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
delimiter ','
csv header;*/

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
show search_path;

---------------
--source CRM
---------------
select *
from bronze.crm_cust_info; ----total rows = 18494

select count(*)
from bronze.crm_cust_info;

select *
from bronze.crm_prd_info; ----total rows= 397

select *
from bronze.crm_sales_details; ----total rows= 60398

---------------
--source ERP
---------------
select *
from bronze.erp_cust_az12; ----total rows = 18484

select *
from bronze.erp_loc_a101;-----Total rows: 18484

select *
from bronze.erp_px_cat_g1v2;-----Total rows: 37

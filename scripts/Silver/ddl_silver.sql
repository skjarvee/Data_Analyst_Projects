show search_path; ---to check the schema in use

set search_path to silver, broze; ---to set the schema in use but only for the current session

alter role postgres set search_path to silver, broze; ---set the schema in use permanently

/*

===========================================================================================

Silver Layer : DDL script

Purpose: 
1. Create table for silver layer with same column as tables in bronze layer.
2. Adjust the coulmn according to the data transformation done before loading the data.

Warning:
1. Check if the table already exist, if does then replace it or ingore it

===========================================================================================

*/

--------------------
--CRM Source table
---------------------

--------------------------------------
-- customer information table
--------------------------------------

---drop the table if exists
drop table if exists silver.crm_cust_info;
---create silver.crm_cust_info table
create table if not exists silver.crm_cust_info (
		cst_id				int,
		cst_key				varchar(50),
		cst_firstname		varchar(50),
		cst_lastname		varchar(50),
		cst_marital_status	varchar(50),
		cst_gndr			varchar(50),
		cst_create_date 	date,
		dwh_created_at timestamp default current_timestamp
);


--------------------------------------
-- product information table
--------------------------------------

---drop the table if exists
drop table if exists silver.crm_prd_info;
---create silver.crm_prd_info table
create table if not exists silver.crm_prd_info(
		prd_id			int,
		prd_key			varchar(50),
		cat_key         varchar(50),
		prd_nm			varchar(100),
		prd_cost		int,
		prd_line		varchar(50),
		prd_start_dt	date,
		prd_end_dt 		date,
		dwh_created_at timestamp default current_timestamp
);


--------------------------------------
-- sales details table
--------------------------------------

---drop the table if exists
drop table if exists silver.crm_sales_details;
---create silver.crm_sales_details table
create table if not exists silver.crm_sales_details(

		sls_ord_num		varchar(50),
		sls_prd_key		varchar(50),
		sls_cust_id		int,
		sls_order_dt	date,
		sls_ship_dt		date,
		sls_due_dt		date,
		sls_sales		int,
		sls_quantity	int,
		sls_price 		int,
		dwh_created_at timestamp default current_timestamp
);


--------------------------------------
--More customer information table(include birthday date, gender)
--------------------------------------

---drop the table if exists
drop table if exists silver.erp_cust_az12;
---create silver.erp_cust_az12 table
create table if not exists silver.erp_cust_az12(
		cid 	varchar(50),
		bdate 	date,
		gen 	varchar(50),
		dwh_created_at timestamp default current_timestamp
);

--------------------------------------
-- customer location table
--------------------------------------

---drop the table if exists
drop table if exists silver.erp_loc_a101;
---create silver.erp_loc_a101 table
create table if not exists silver.erp_loc_a101(
		cid varchar(50),
		cntry varchar(50),
		dwh_created_at timestamp default current_timestamp
);

--------------------------------------
-- product category info table
--------------------------------------

---drop the table if exists
drop table if exists silver.erp_px_cat_g1v2;
---create silver.erp_px_cat_g1v2 table
create table if not exists silver.erp_px_cat_g1v2(

		id varchar(50),
		cat varchar(50),
		subcat varchar(50),
		maintenance varchar(50),
		dwh_created_at timestamp default current_timestamp
);

---just to check all th columns are correctly created
select *
from silver.crm_prd_info

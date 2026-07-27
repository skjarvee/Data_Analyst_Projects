-- bar_data_warehouse;

show search_path; ---check the schema
--------------------

set search_path to broze , retail_2; --fix the schema for this session

alter role postgres set search_path to  broze , retail_2; ---fix the schema permanently 

/*-------------------------------------------------
---------------------------------------------------
BRONZE LAYER:

Purpose: Creating table in the brone layer. we get table from different source

Warning: If the table already exist, it will be replace by new table. Take a backup if you want.

---------------------------------------------------
--------------------------------------------------- */
do $$

begin

create table if not exists bronze.crm_cust_info(

		cst_id				int,
		cst_key				varchar(30),
		cst_firstname		varchar(50),
		cst_lastname		varchar(50),
		cst_marital_status	varchar(10),
		cst_gndr			varchar(50),
		cst_create_date 	date

);

create table if not exists bronze.crm_prd_info(

		prd_id			int,
		prd_key			varchar(30),
		prd_nm			varchar(100),
		prd_cost		int,
		prd_line		varchar(10),
		prd_start_dt	date,
		prd_end_dt 		date

);

create table if not exists bronze.crm_sales_details(

		sls_ord_num		varchar(30),
		sls_prd_key		varchar(30),
		sls_cust_id		int,
		sls_order_dt	int,
		sls_ship_dt		int,
		sls_due_dt		int,
		sls_sales		int,
		sls_quantity	int,
		sls_price 		int

);

create table if not exists bronze.erp_cust_az12(
		cid 	varchar(50),
		bdate 	date,
		gen 	varchar(50)

);

create table if not exists bronze.erp_px_cat_g1v2(
		id varchar(50),
		cat varchar(50),
		subcat varchar(50),
		maintenance varchar(50)
);

create table if not exists bronze.erp_loc_a101(
		cid varchar(50),
		cntry varchar(50)
);

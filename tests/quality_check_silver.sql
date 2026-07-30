/* 
=============================================================
Quality Check for Silver layer
=============================================================
Purpose:
This script checks the data quality, data consistency for the silver layer
These are the checks
  - Nulls 


Note:
1. Do these quality checks after loading data into silver layer
2. if you find any data quality issue, fix it right away

=============================================================
*/


SELECT * FROM bronze.crm_cust_info
LIMIT 100

SELECT * FROM bronze.crm_prd_info
LIMIT 100

SELECT * FROM bronze.crm_sales_details
LIMIT 100

SELECT * FROM bronze.erp_cust_az12
LIMIT 100

SELECT * FROM bronze.erp_loc_a101
LIMIT 100

SELECT * FROM bronze.erp_px_cat_g1v2
LIMIT 100

-- ================================================
-- Checking bronze.crm_cust_info table
-- ================================================

-- Checking for NUll & Duplicates in primary key
-- Expectation: No results
SELECT * FROM silver.crm_cust_info

SELECT * FROM bronze.crm_sales_details

SELECT * FROM bronze.erp_cust_az12

SELECT * FROM bronze.erp_loc_a101

-- >> primary key
select cst_id, count(*)
from silver.crm_cust_info
group by cst_id
having count(*)>1 or cst_id is null

-- Checking from unwanted space & proper wording style
--same space check for other string column
-- expectation: no result

---3rd column
select cst_lastname, trim(cst_lastname),cst_lastname
from silver.crm_cust_info
where cst_lastname != trim(cst_lastname) or cst_lastname is null

--5th col
select cst_gndr, trim(cst_gndr)
from silver.crm_cust_info
where cst_gndr != trim(cst_gndr)

-- Check for data standardization & consistency in low gardinal columns

select distinct cst_marital_status
from silver.crm_cust_info

select distinct cst_gndr
from silver.crm_cust_info

-- checking date range & inconsistent date

select *
from silver.crm_cust_info
where length(cst_create_date::text) !=10

-- ================================================
-- Checking bronze.crm_prd_info table
-- ================================================

select * from bronze.crm_prd_info

SELECT * FROM bronze.erp_px_cat_g1v2 -- prd category info

SELECT * FROM bronze.crm_sales_details

--- check for Null values and duplicates in primary key column
select *
from(select *, count(*) over(partition by prd_key) cn
from bronze.crm_prd_info)
where cn >1

-- Unwanted space
select *
from bronze.crm_prd_info
where prd_nm != trim(prd_nm)

-- checking for null
select *
from bronze.crm_prd_info
where prd_cost is null

--checking for data standardisation and consistency
select distinct prd_line
from bronze.crm_prd_info
where prd_line 

-- checking date range and consistency
select *
from bronze.crm_prd_info
where   prd_start_dt is null

-- ================================================
-- Checking bronze.crm_sales_details
-- ================================================

SELECT * FROM silver.crm_sales_details

--checking duplicate & Nulls in primary columns
select *
from(select *, count(*) over(partition by sls_cust_id) cn
from silver.crm_sales_details)
where sls_cust_id = 0

--unwanted space
select sls_prd_key
from silver.crm_sales_details
where sls_prd_key != trim(sls_prd_key)

--checking for invaild date
select *
from silver.crm_sales_details
where length(sls_order_dt::text) != 10

-- integer column data intergiration check

select *
from silver.crm_sales_details
where sls_price is null or sls_price <=0

-- ================================================
-- Checking bronze.erp_cust_az12
-- ================================================

SELECT * FROM bronze.erp_cust_az12

SELECT * FROM bronze.crm_cust_info

-- Checking Null and duplicate for primary key
select *
from(SELECT *, count(*) over(partition by cid) cn FROM silver.erp_cust_az12)
where cn >1 or cid is null

--unwanted space
select *, trim(gen)
from silver.erp_cust_az12
where gen != trim(gen)

--Check invalid date
select *
from silver.erp_cust_az12
where bdate>'2027-01-01'::date or bdate is null 

--checking data standardisation and consistency
select distinct gen
from silver.erp_cust_az12

-- ================================================
-- Checking bronze.erp_loc_a101
-- ================================================

SELECT * FROM bronze.erp_loc_a101

SELECT * FROM bronze.crm_cust_info

---checking the NULLs and duplicates in primary column
select *
from(SELECT *, count(*) over(partition by cid) cn FROM silver.erp_loc_a101)
where cn >1 or cid is null

-- Unwanted space
select *, trim(cntry) 
from silver.erp_loc_a101
where cntry != trim(cntry)

-- Data standardisation and consistency

select distinct cntry
from silver.erp_loc_a101

-- ================================================
-- Checking bronze.erp_loc_a101
-- ================================================

SELECT * FROM bronze.erp_px_cat_g1v2
SELECT * FROM silver.crm_prd_info

-- checking NUlls & Duplicated in primary key
select *
from(select *, count(*) over(partition by id) cn from silver.erp_px_cat_g1v2)
where cn>1

--unwanted space
select *
from silver.erp_px_cat_g1v2
where cat != trim(cat)
--where trim(id) not in (select cat_key from silver.crm_prd_info)--checking the relationship

--data standardisation and consistency
select distinct cat
from silver.erp_px_cat_g1v2
order by cat


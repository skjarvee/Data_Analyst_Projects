--show search_path;

/*
======================================================
Gold Layer: Views & Model
======================================================

Purpose:
--------
Creating starschema model
Creating view for each dimension table and fact table


Warning:
--------
new view will be created and it will replace the old view, so take backup if important

======================================================
*/


begin;--using transaction factions
--========================================
-- dim_customers view
--========================================

--drop view if exists gold.dim_customers cascade;

create or replace view gold.dim_customers as
select 
		row_number() over(order by c.cst_id) customer_key,
		c.cst_id customer_id,
		c.cst_key customer_number,
		c.cst_firstname first_name,
		c.cst_lastname last_name,
		case when c.cst_gndr ='n\a' then bc.gen
			 else c.cst_gndr end gender,
		cl.cntry country,
		c.cst_marital_status marital_status,
		bc.bdate birth_date,
		c.cst_create_date create_date
		
from silver.crm_cust_info c left join silver.erp_cust_az12 bc on c.cst_key = bc.cid
							left join silver.erp_loc_a101 cl on c.cst_key = cl.cid;

--checking the view

--select * from gold.dim_customers

--========================================
-- dim_products view
--========================================

--drop view if exists gold.dim_products cascade;

create or replace view gold.dim_products as
select 
		row_number() over(order by p.prd_start_dt,p.prd_id) product_key,
		p.prd_id product_id,
		p.prd_key product_number,
		p.prd_nm product_name,
		p.cat_key category_id,
		coalesce(ct.cat,'n\a') category,
		coalesce(ct.subcat,'n\a') subcategory,
		coalesce(ct.maintenance,'n\a') maintenance,
		p.prd_cost cost,
		p.prd_line product_line,
		p.prd_start_dt start_date
		
from silver.crm_prd_info p left join silver.erp_px_cat_g1v2 ct on p.cat_key = ct.id
where p.prd_end_dt is null;

--checking  gold._dim_products

--select * from gold.dim_products;

--========================================
-- fact_sales view
--========================================

--drop view if exists gold.fact_sales;

create or replace view gold.fact_sales as
select 
		sls_ord_num order_number,
		p.product_key,
		c.customer_key,
		sls_order_dt order_date,
		sls_ship_dt ship_date,
		sls_due_dt due_date,
		sls_sales total_sales,
		sls_quantity quantity,
		sls_price price
		
from silver.crm_sales_details s
		left join dim_customers c on s.sls_cust_id = c.customer_id
		left join dim_products p on s.sls_prd_key = p.product_number;
		
--checking fact_sales
--select * from fact_sales

commit;
--============================================================

--ROLLBACK;

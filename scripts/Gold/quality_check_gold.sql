show search_path;

/*
=============================================
Quality check for gold layer
=============================================

Purpose:
--------

Check the data integrationa and relationship integrity.



=============================================
*/


--==========================================
--Quality check for gold.dim_customers
--==========================================
select * from silver.crm_cust_info;

select * from silver.erp_cust_az12;

select * from silver.erp_loc_a101;
--==========================================
--Data drived from two columns & null check & distinct value
select distinct gender
from(select 
		c.cst_gndr,
		bc.gen,
		case when c.cst_gndr ='n\a' then bc.gen
				else c.cst_gndr end gender
		
from silver.crm_cust_info c left join silver.erp_cust_az12 bc on c.cst_key = bc.cid)
where gender is null;

--relationship check for three tables
select 
		c.cst_id customer_id,
		c.cst_key customer_number,
		c.cst_firstname first_name,
		c.cst_lastname last_name,
		c.cst_marital_status marital_status,
		c.cst_create_date create_date,
		bc.bdate birth_date,
		case when c.cst_gndr ='n\a' then bc.gen
			 else c.cst_gndr end gender,
		cl.cntry country,
		count(*) over(partition by c.cst_key) cn
from silver.crm_cust_info c left join silver.erp_cust_az12 bc on c.cst_key = bc.cid
							left join silver.erp_loc_a101 cl on c.cst_key = cl.cid
where bc.cid is null or cl.cid is null ;

--duplicate check

select *
from (select 
		c.cst_id customer_id,
		c.cst_key customer_number,
		c.cst_firstname first_name,
		c.cst_lastname last_name,
		c.cst_marital_status marital_status,
		c.cst_create_date create_date,
		bc.bdate birth_date,
		case when c.cst_gndr ='n\a' then bc.gen
			 else c.cst_gndr end gender,
		cl.cntry country,
		count(*) over(partition by c.cst_key) cn
from silver.crm_cust_info c left join silver.erp_cust_az12 bc on c.cst_key = bc.cid
							left join silver.erp_loc_a101 cl on c.cst_key = cl.cid)
where cn>1;


--dim_customer
select * from(select *,count(*) over(partition by customer_key) cn from gold.dim_customers) where cn >1--checking duplicates

select distinct marital_status from gold.dim_customers --checking data consistency

--==========================================
--Quality check for gold.dim_products
--==========================================

select * from silver.crm_prd_info;

select * from silver.erp_px_cat_g1v2;

--relationship check
select 
		p.prd_id product_id,
		p.prd_key product_number,
		p.prd_nm product_name,
		p.cat_key category_id,
		ct.cat category,
		ct.subcat subcategory,
		p.prd_cost cost,
		p.prd_line product_line,
		ct.maintenance,
		p.prd_start_dt start_date,
		p.prd_end_dt end_date		
from silver.crm_prd_info p left join silver.erp_px_cat_g1v2 ct on p.cat_key = ct.id
where ct.id is null;

--duplicate check
select product_id,count(*)
from(select 
		p.prd_id product_id,
		p.prd_key product_number,
		p.prd_nm product_name,
		p.cat_key category_id,
		coalesce(ct.cat,'n\a') category,
		coalesce(ct.subcat,'n\a') subcategory,
		p.prd_cost cost,
		p.prd_line product_line,
		coalesce(ct.maintenance, 'n\a') maintenance,
		p.prd_start_dt start_date,
		p.prd_end_dt end_date		
from silver.crm_prd_info p left join silver.erp_px_cat_g1v2 ct on p.cat_key = ct.id)
group by product_id
having count(*)>1;

---checking gol.dim_products

select product_key,count(*) from gold.dim_products group by product_key having count(*)>1---checking duplicates

select distinct subcategory from gold.dim_products;

--==========================================
--Quality check for gold.fact_sales
--==========================================

--checking relationaship between fact and dim tables

select * 
from fact_sales s left join dim_products p on s.product_key = p.product_key
				  left join dim_customers c on s.customer_key = c.customer_key
where s.customer_key is null

--==========================================================================


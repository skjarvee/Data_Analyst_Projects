
/*
=====================================================================
Silver Layer: Stored Procedure for Inserting Data into the tables
=====================================================================
Source: Loaded data from bronze layer.

Purpose: 
-------
1. clean, transform and load the data into silver layer
2. Check the data quality before loading into the silver layer and after loading into the silver layer
3. created stored procedure for inserting data cause we'll be frequently running this insert operation.

Warning:
--------
1.Each time when you insert the data into the table first trunccate the table then insert it. that how query is build.
2. Have a back up for old data before truncating the table.

Parameters:
-----------
    None. 
	  This stored procedure does not accept any parameters or return any values.

Execution:
----------
call silver.load_silver;

=====================================================================
*/

call silver.load_silver();

create or replace procedure silver.load_silver ()

language plpgsql
as
$$

declare 
		start_time timestamp; 
		end_time timestamp; 
		batch_start_time timestamp; 
		batch_end_time timestamp;

begin

			raise notice '===================================';
			raise notice 'Loading Data into Silver Layer	';
			raise notice '===================================';
			raise notice '  ' ;
			
			raise notice '===================================';
			raise notice '	Loading CRM Files		';
			raise notice '===================================';
			raise notice '  ' ;
			batch_start_time := current_timestamp;
			
			start_time := current_timestamp;
			raise notice '=======================================';
			raise notice 'Insert data into silver.crm_cust_info';
			raise notice '=======================================';
			raise notice '   ';
			
			raise notice '>> Truncating the data: silver.crm_cust_info';
			truncate table silver.crm_cust_info;
			
			raise notice '>> Inserting data into: silver.crm_cust_info';
			insert into silver.crm_cust_info
			(
					cst_id,
					cst_key,
					cst_firstname,
					cst_lastname,
					cst_marital_status,
					cst_gndr,
					cst_create_date
			)
			
			select
					cst_id, 
					trim(cst_key) cst_key,
					initcap(trim(cst_firstname)) cst_firstname,
					initcap(trim(cst_lastname)) cst_lastname,
					case when upper(trim(cst_marital_status)) = 'M' then 'Married'
						 when upper(trim(cst_marital_status)) = 'S' then 'Single'
						 else 'n\a' end cst_marital_status,
					case when upper(trim(cst_gndr)) = 'M' then 'Male'
						 when upper(trim(cst_gndr)) = 'F' then 'Female'
						 else 'n\a'  end cst_gndr,
					cst_create_date
			from (select 
				 *,
				 row_number() over(partition by cst_id order by cst_create_date desc) rn
			from bronze.crm_cust_info) t
			where rn=1 and cst_id is not null;
			
			--checking the table
			--select * from silver.crm_cust_info;
			end_time := current_timestamp;
			
			raise notice ' Load Duration: % ', (end_time - start_time);
			raise notice '   ';
			
			start_time := current_timestamp;
			raise notice '=====================================';
			raise notice 'Insert data into silver.crm_prd_info';
			raise notice '=====================================';
			raise notice '   ';
			
			raise notice '>> Truncating the data: silver.crm_prd_info';
			truncate table silver.crm_prd_info;
			
			raise notice '>> Inserting data into: silver.crm_prd_info';
			insert into silver.crm_prd_info
			(		prd_id,
					prd_key,
					cat_key,
					prd_nm,
					prd_cost,
					prd_line,
					prd_start_dt,
					prd_end_dt
			)
			select 
					prd_id,
					trim(substring(prd_key,7,length(prd_key))) prd_key,
					trim (replace(substring(prd_key,1,5),'-','_')) cat_key,
					prd_nm,
					coalesce(prd_cost,0) prd_cost,
					case upper(trim(prd_line)) 
						 when 'M' then 'Mountain'
						 when 'R' then 'Road'
						 when 'S' then 'Other Sales' 
						 when 'T' then 'Touring' 
						 else 'n\a' end	prd_line,
					prd_start_dt,
					lead(prd_start_dt) over(partition by prd_key order by prd_start_dt) -1 prd_end_dt
			from bronze.crm_prd_info;
			
			--checking the table
			--select * from silver.crm_prd_info;
			end_time := current_timestamp;
			
			raise notice ' Load Duration: % ', (end_time - start_time);
			raise notice '   ';
			
			start_time := current_timestamp;
			raise notice '===========================================';
			raise notice 'Insert data into silver.crm_sales_details';
			raise notice '===========================================';
			raise notice '   ';
			
			raise notice '>> Truncating the data: silver.crm_sales_details';
			truncate table silver.crm_sales_details;
			
			raise notice '>> Inserting data into: silver.crm_sales_details';
			insert into silver.crm_sales_details (
					sls_ord_num,
					sls_prd_key,
					sls_cust_id,
					sls_order_dt,
					sls_ship_dt,
					sls_due_dt,
					sls_sales,
					sls_quantity,
					sls_price
			
			)
			
			select 
					sls_ord_num,
					sls_prd_key,
					sls_cust_id,
					case when sls_order_dt = 0 or length(sls_order_dt::text) !=8  then null 
						 else cast(sls_order_dt::text as date) end sls_order_dt,
					case when sls_ship_dt = 0 or length(sls_ship_dt::text) !=8  then null 
						 else cast(sls_ship_dt::text as date) end sls_ship_dt,
					case when sls_due_dt = 0 or length(sls_due_dt::text) !=8  then null 
						 else cast(sls_due_dt::text as date) end sls_due_dt,
					case when sls_sales is null or sls_sales <=0 or sls_sales != sls_quantity*abs(sls_price)
						 then sls_quantity * abs(sls_price) 
						 else sls_sales end sls_sales,
					sls_quantity,
					case when sls_price is null or sls_price <=0
						 then  sls_sales / nullif(sls_quantity,0)
						 else sls_price end  sls_price
			from bronze.crm_sales_details;
			
			--checking the table
			--select * from silver.crm_sales_details;
			end_time := current_timestamp;
			
			raise notice ' Load Duration: % ', (end_time - start_time);
			raise notice '   ';
			
			start_time := current_timestamp;
			raise notice '===================================';
			raise notice '	Loading ERM Files		';
			raise notice '===================================';
			raise notice '   ';
			
			raise notice '===========================================';
			raise notice 'Insert data into silver.erp_cust_az12';
			raise notice '===========================================';
			raise notice '   ';
			
			raise notice '>> Truncating the data: silver.erp_cust_az12';
			truncate table silver.erp_cust_az12;
			
			raise notice '>> Inserting data into: silver.erp_cust_az12';
			insert into silver.erp_cust_az12 (
					cid,
					bdate,
					gen
			)
			select 
				 	case when cid like '%NAS%' then substring(cid,4,length(cid)) 
						 else (cid) end cid,
					case when bdate > current_date then null
					else bdate end bdate,
					case when trim(gen) in ('M', 'Male') then 'Male'
					 	 when trim(gen) in ('F', 'Female') then 'Female'
						  else 'n\a'  end gen
			from bronze.erp_cust_az12;
			
			--checking the table
			--select * from silver.erp_cust_az12;
			end_time := current_timestamp;
			
			raise notice ' Load Duration: % ', (end_time - start_time);
			raise notice '   ';
			
			start_time := current_timestamp;
			raise notice '===========================================';
			raise notice 'Insert data into silver.erp_loc_a101';
			raise notice '===========================================';
			
			raise notice '   ';
			
			raise notice '>> Truncating the data: silver.erp_loc_a101';
			truncate table silver.erp_loc_a101;
			
			raise notice '>> Inserting data into: silver.erp_loc_a101';
			insert into silver.erp_loc_a101(
				cid,
				cntry
			)
			select 
					replace (trim(cid),'-','') cid,
					case when trim(cntry) in ('US','USA') then 'United States'
						 when trim(cntry) in ('DE') then 'Germany'
						 when trim(cntry) is null or trim(cntry) = '' then 'n\a' 
						 else trim(cntry) end cntry
			from bronze.erp_loc_a101;
			
			--checking the table
			--select * from silver.erp_loc_a101;
			end_time := current_timestamp;
			
			raise notice ' Load Duration: % ', (end_time - start_time);
			raise notice '   ';
			
			start_time := current_timestamp;
			raise notice '===========================================';
			raise notice 'Insert data into silver.erp_px_cat_g1v2';
			raise notice '===========================================';
			
			raise notice '   ';
			
			raise notice '>> Truncating the data: silver.erp_px_cat_g1v2';
			truncate table silver.erp_px_cat_g1v2;
			
			raise notice '>> Inserting data into: silver.erp_px_cat_g1v2';
			insert into silver.erp_px_cat_g1v2(
				id,
				cat,
				subcat,
				maintenance
			)
			select 
					id,
					cat,
					subcat,
					maintenance
			from bronze.erp_px_cat_g1v2;
			
			--checking the table
			--select * from silver.erp_px_cat_g1v2;
			end_time := current_timestamp;
			
			raise notice ' Load Duration: % ', (end_time - start_time);

			raise notice '===================================';
			raise notice '	Data Loading Completed		';
			raise notice '===================================';
			
			batch_end_time := current_timestamp;
			
			raise notice ' ';
			raise notice ' Load time for the whole session:';
			raise notice ' Session Start time: % ',batch_start_time;
			raise notice ' Session end time: % ', batch_end_time;
			raise notice ' Total duration to load data: % ', (batch_end_time - batch_start_time);
			
			 Exception
			 	when others then
				raise notice ' Error occured while loading the data';
				raise notice 'Error Message: %', SQLERRM;
end;
$$;

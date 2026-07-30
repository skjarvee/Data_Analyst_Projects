# Data_Warehousing_&_Analyst_Projects #1
Projects for data analysis

First creating a data warehouse to store the data for the analysis.
I'm going to create three layer for this data warehouse. 

  1.Bronze Layer : This layer contains raw datasets from the source.
  
  2.Silver Layer : This layer will get the data from the broze layer and clean data by removing duplicate, null handling, etc. ETL process in this layer.
  
  3.Gold Layer   : Get data from silver layer after the ETL process is done. In this layer , i will do modeling, normalization, standardisatio and make the data ready for analysis.

==============================================================================

Broze Layer:
 1. Created the database and schemas for the project.
 
 2. created tables and loaded data into tables.
 
 I got the data fromm two source. each source has three table. So i have created 6 tables and loaded data into each table and checked the data row counts by comparing with source csv file.
 
 I didn't use any code to load data, since i use pgadmin, its hard to create the script for loading the data in posgtres. so i have used IMPORT option in pgadmin.
 
==============================================================================

Silver Layer:

  Loaded the cleaned and transformed data into silver layer.
  ETL process is done in this layer.
  
    Fixed data issue like :
        - Nulls & Duplicates
        - Data Normalization & Standardisation
        - Unwanted Space fixed
        - Invaild Date
        - Data Consistency
        - Fixed Data Types

      

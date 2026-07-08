/*
------------------------------------------------------------------
Creating Database and Schemas
------------------------------------------------------------------
Scripts Purpose:
  
      This script is for creating the Database and 3 schemas in it for 3 layers.

Warning:
  	  Before creating a database check whether it already exist. it will replace the old database with new one. you will lose the old one.
      have a backup for the old database if its also important.

------------------------------------------------------------------
------------------------------------------------------------------
*/

--- creating database

  create or replace database bar_data_house;

--- creating schemas for 3 layers

create schema bronze;

create schema silver;

create schema gold;

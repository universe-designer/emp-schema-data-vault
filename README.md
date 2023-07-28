# emp-schema-data-vault
This project shows how the famous scott emp sample tables would be designed in data vault

scott.sql - The scott schema with sample data. Please obey the deviant copyright of this file.

ddl-stage.sql - Table definitions for staging tables

ddl-core.sql - Table definitions for core tables

datavault.sql - PL/SQL Package Header

datavault-body.sql- PL/SQL Package Body. Contains hashkey functions and procedures to load the data vault tables.

control.sql - PL/SQL anonymous block to run load procedures

scott-user-updates.sql - DML statements do simulate data change in source tables.

select.sql - Select statements to recreate source tables and to show historic versions of the data. 

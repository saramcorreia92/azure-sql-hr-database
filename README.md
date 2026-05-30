# azure-sql-hr-database
Cloud HR database built on Microsoft Azure SQL — AZ-104 portfolio project
# Azure SQL HR Database

## Project overview
A cloud-hosted HR employee database built on Microsoft Azure SQL, simulating a real-world enterprise data migration from spreadsheets to a centralised, secure database system.

## Business scenario
A growing organisation needed to replace manual HR spreadsheets with a secure, centralised database. As the cloud administrator, I provisioned the Azure infrastructure, designed the relational schema, implemented role-based access controls, and created automated onboarding procedures.

## Technologies used
- Microsoft Azure (SQL Server, SQL Database, Storage Account)
- SQL Server Management Studio (SSMS)
- T-SQL (stored procedures, joins, aggregations, audit logging)
- Azure Firewall rules and network security
- Contained database users (Azure SQL security model)

## Architecture
- **Resource Group:** rg-hr-database-project (UK South)
- **Azure SQL Server:** sqlhrsc (Central US)
- **Database:** HRDatabase — Basic tier (5 DTUs, cost-optimised)
- **Tables:** Employees, Departments, Roles, Salaries, AuditLog
- **Security:** IP firewall allowlist, least-privilege read-only user, contained database authentication

## Features demonstrated
- Azure resource provisioning via the portal
- Relational database design with normalisation and foreign keys
- T-SQL: SELECT, JOIN, GROUP BY, aggregations
- Stored procedure: automated employee onboarding with audit logging
- Role-based access: admin vs read-only analyst accounts
- Firewall configuration and network security rules
- Azure contained database users (vs traditional server logins)

## Key SQL files
| File | Description |
|---|---|
| 01_create_tables.sql | Schema creation — all 5 tables with relationships |
| 02_insert_data.sql | Sample HR data — 5 departments, 6 roles, 7 employees |
| 03_queries.sql | Business queries — directory, salary analytics, recent hires |
| 04_stored_procedures.sql | sp_OnboardEmployee — automated onboarding with audit trail |

## Notes
- SQL Server deployed to Central US due to free trial regional availability 

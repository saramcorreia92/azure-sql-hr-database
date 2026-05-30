# Architecture & Design Decisions

## Overview
This document explains the technical decisions made during the design 
and deployment of the Azure HR Database project.

---

## Azure Infrastructure

### Resource Group
- **Name:** rg-hr-database-project
- **Region:** UK South
- Resource groups are logical containers — they can hold resources 
  from any region. Used for cost tracking and lifecycle management.

### SQL Server
- **Name:** sqlhrsc
- **Region:** Central US
- Deployed to Central US due to free trial regional capacity 
  restrictions on UK regions. This is standard practice when 
  preferred regions are at capacity — database behaviour is 
  identical regardless of region.

### SQL Database
- **Name:** HRDatabase
- **Tier:** Basic (5 DTUs, 2GB storage)
- Basic tier chosen to minimise cost during development. In a 
  production environment this would be scaled to Standard or 
  Premium tier based on concurrent user requirements.

---

## Database Design

### Normalisation
The schema is designed to Third Normal Form (3NF):
- Employee personal data is separated from salary data
- Departments and Roles are separate reference tables
- No data duplication across tables

### Why Salaries is a separate table
Salary data is highly sensitive. Keeping it in a separate table 
allows granular access control — the hr_analyst user can query 
employee and department data without ever seeing salary figures.

It also allows salary history to be preserved. When an employee 
receives a raise, the old record gets an EndDate and a new record 
is inserted — full history is maintained.

### AuditLog table
Every INSERT, UPDATE and DELETE triggered by stored procedures 
writes a record to AuditLog. This provides:
- Compliance trail for HR data changes
- Accountability — records who changed what and when
- Forensic capability if data is disputed

---

## Security Design

### Firewall rules
Azure SQL Server blocks all connections by default. Only the 
administrator IP address is explicitly allowed. This follows the 
principle of least privilege at the network level.

### Contained database users
Azure SQL uses contained database users rather than server-level 
logins. This means:
- Users exist entirely within the database
- No server-level credentials required
- More portable and more secure than traditional logins

### Role-based access
| User | Access | Reason |
|---|---|---|
| hradmin | Full admin | Database owner |
| hr_analyst | SELECT on Employees, Departments, Roles only | Read-only reporting — no access to Salaries or AuditLog |

---

## Stored Procedures

### Why stored procedures?
- Encapsulate business logic in the database layer
- Prevent partial updates — all steps succeed or none do
- Automatically write to AuditLog on every operation
- Reduce risk of SQL injection vs raw queries

### Procedure summary
| Procedure | Purpose |
|---|---|
| sp_OnboardEmployee | Creates employee, salary record, and audit entry |
| sp_OffboardEmployee | Marks inactive, closes salary, logs departure |
| sp_UpdateSalary | Preserves salary history, logs old and new values |

---

## Cost Management
| Resource | Tier | Estimated cost |
|---|---|---|
| Azure SQL Database | Basic (5 DTU) | ~£4/month |
| Storage Account (audit logs) | LRS | ~£0.50/month |
| SQL Server | Free | £0 |
| **Total** | | **~£4.50/month** |

Free trial credit: £148 — well within budget even for extended use.

---

## Lessons Learned
- UK South region unavailable on free trial — Central US used instead
- Azure SQL requires contained database users, not server-level logins
- Microsoft.Insights provider must be registered before audit log 
  storage can be configured — one-time setup per subscription
- Resource group region does not need to match resource region

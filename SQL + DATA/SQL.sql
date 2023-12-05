USE MASTER
GO
IF DB_ID ('STAGE') IS NOT NULL
	DROP DATABASE STAGE
GO
CREATE DATABASE STAGE
GO

IF DB_ID ('METADATA') IS NOT NULL
	DROP DATABASE METADATA
GO
CREATE DATABASE METADATA
GO

IF DB_ID ('NDS') IS NOT NULL
	DROP DATABASE NDS
GO
CREATE DATABASE NDS
GO

USE METADATA
GO

CREATE TABLE DATA_FLOW
(
	TABLE_NAME VARCHAR(100),
	CET DATETIME,
	LSET DATETIME

	CONSTRAINT PK_DF PRIMARY KEY (TABLE_NAME)
)

INSERT INTO DATA_FLOW VALUES 
('supermarket_sales', NULL, '01/01/1970'),
('product', NULL, '01/01/1970'),
('ProductLine', NULL, '01/01/1970'),
('city', NULL, '01/01/1970')
GO

USE STAGE
GO
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[supermarket_sales_STAGE]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
  DROP TABLE [dbo].[supermarket_sales_STAGE]
GO
CREATE TABLE [supermarket_sales_STAGE] (
    [Invoice ID] nvarchar(255),
    [Branch] nvarchar(255),
    [Customer type] nvarchar(255),
    [Gender] nvarchar(255),
    [ProductID] nvarchar(255),
    [Quantity] float,
    [Tax 5%] float,
    [Total] float,
    [Date] datetime,
    [Time] datetime,
    [Payment] nvarchar(255),
    [cogs] float,
    [gross margin percentage] float,
    [gross income] float,
    [Rating] float
)
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[product_STAGE]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
  DROP TABLE [dbo].[product_STAGE]
GO
CREATE TABLE [product_STAGE] (
    [ProductID] nvarchar(255),
    [Unit price] float,
    [ProductLine] nvarchar(255),
	[UpdateDate] datetime
)
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[ProductLine_STAGE]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
  DROP TABLE [dbo].[ProductLine_STAGE]
GO
CREATE TABLE [ProductLine_STAGE] (
    [Product line] nvarchar(255),
    [ProductLineID] nvarchar(255),
    [UpdateDate] datetime
)
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[city_STAGE]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
  DROP TABLE [dbo].[city_STAGE]
GO
CREATE TABLE [city_STAGE] (
    [Branch] nvarchar(255),
    [City] nvarchar(255),
    [UpdateDate] datetime
)
GO

USE NDS
GO
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[city_NDS]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
  DROP TABLE [dbo].[city_NDS]
GO
CREATE TABLE [city_NDS] (
	[C_SK] int IDENTITY(1,1) NOT NULL,
    [Branch] nvarchar(255) NOT NULL,
    [City] nvarchar(255),
	[CreateDate] datetime,
    [UpdateDate] datetime
)
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[ProductLine_NDS]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
  DROP TABLE [dbo].[ProductLine_NDS]
GO
CREATE TABLE [ProductLine_NDS] (
	[PL_SK] int IDENTITY(1,1) NOT NULL,
    [Product line] nvarchar(255) NOT NULL,
    [ProductLineID] nvarchar(255),
	[CreateDate] datetime,
    [UpdateDate] datetime
)
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[product_NDS]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
  DROP TABLE [dbo].[product_NDS]
GO
CREATE TABLE [product_NDS] (
	[P_SK] int IDENTITY(1,1) NOT NULL,
    [ProductID] nvarchar(255) NOT NULL,
    [Unit price] float,
    [ProductLine] nvarchar(255),
	[CreateDate] datetime,
	[UpdateDate] datetime
)
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[supermarket_sales_NDS]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
  DROP TABLE [dbo].[supermarket_sales_NDS]
GO
CREATE TABLE [supermarket_sales_NDS] (
	[SS_SK] int IDENTITY(1,1) NOT NULL,
    [Invoice ID] nvarchar(255) NOT NULL,
    [Branch] nvarchar(255),
    [Customer type] nvarchar(255),
    [Gender] nvarchar(255),
    [ProductID] nvarchar(255),
    [Quantity] float,
    [Tax 5%] float,
    [Total] float,
    [CreateDate] datetime,
	[UpdateDate] datetime,
    [Payment] nvarchar(255),
    [cogs] float,
    [Rating] float
)
GO

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

IF DB_ID ('DDS') IS NOT NULL
	DROP DATABASE DDS
GO
CREATE DATABASE DDS
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

USE DDS
GO
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[Dim_City]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
  DROP TABLE [dbo].Dim_City
GO
CREATE TABLE Dim_City (
	C_SK int NOT NULL,
    Branch nvarchar(255) NOT NULL,
    City nvarchar(255),
	[Status] int
)
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[Dim_ProductLine]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
  DROP TABLE [dbo].Dim_ProductLine
GO
CREATE TABLE Dim_ProductLine (
	PL_SK int NOT NULL,
    [Product line] nvarchar(255),
    [ProductLineID] nvarchar(255),
	[Status] int
)
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[Dim_Product]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
  DROP TABLE [dbo].Dim_Product
GO
CREATE TABLE Dim_Product (
	P_SK int NOT NULL,
    [ProductID] nvarchar(255) NOT NULL,
    [Unit price] float,
    [ProductLine] nvarchar(255),
	[Status] int
)
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[Dim_Time]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
  DROP TABLE [dbo].Dim_Time
GO
CREATE TABLE Dim_Time (
  TimeID int IDENTITY(1, 1) NOT NULL,
  Gio int,
  Ngay int,
  Thang int,
  Nam int,
  [Status] int
)
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[Fact_supermarket_sales]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
  DROP TABLE [dbo].Fact_supermarket_sales
GO
CREATE TABLE Fact_supermarket_sales (
	SS_SK int NOT NULL,
    [Invoice ID] nvarchar(255) NOT NULL,
    [Branch] nvarchar(255) NOT NULL,
	[ProductID] nvarchar(255) NOT NULL,
	[TimeID] int NOT NULL,
    [Customer type] nvarchar(255),
    [Gender] nvarchar(255),
    [Quantity] float,
    [Tax 5%] float,
    [Total] float,
    [Payment] nvarchar(255),
    [cogs] float,
    [Rating] float,
	[Status] int
)
GO

ALTER TABLE Dim_City
ADD CONSTRAINT PK_DC PRIMARY KEY (C_SK)
GO
ALTER TABLE Dim_City
ADD CONSTRAINT UQ_C UNIQUE (Branch)
GO
ALTER TABLE Dim_ProductLine
ADD CONSTRAINT PK_DPL PRIMARY KEY (PL_SK)
GO
ALTER TABLE Dim_ProductLine
ADD CONSTRAINT UQ_PL UNIQUE ([ProductLineID])
GO
ALTER TABLE Dim_Product
ADD CONSTRAINT PK_DP PRIMARY KEY (P_SK)
GO
ALTER TABLE Dim_Product
ADD CONSTRAINT UQ_P UNIQUE ([ProductID])
GO
ALTER TABLE Dim_Product
ADD CONSTRAINT FK_P_PL
FOREIGN KEY ([ProductLine])
REFERENCES Dim_ProductLine([ProductLineID])
GO
ALTER TABLE Dim_Time
ADD CONSTRAINT PK_DT PRIMARY KEY (TimeID)
GO
ALTER TABLE Fact_supermarket_sales
ADD CONSTRAINT PK_FSS PRIMARY KEY (SS_SK)
GO
ALTER TABLE Fact_supermarket_sales
ADD CONSTRAINT FK_SS_C
FOREIGN KEY ([Branch])
REFERENCES Dim_City(Branch);
GO
ALTER TABLE Fact_supermarket_sales
ADD CONSTRAINT FK_SS_P
FOREIGN KEY ([ProductID])
REFERENCES Dim_Product([ProductID]);
GO
ALTER TABLE Fact_supermarket_sales
ADD CONSTRAINT FK_SS_PL
FOREIGN KEY ([TimeID])
REFERENCES Dim_Time(TimeID);
GO

USE METADATA

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DATA_FLOW_NDS]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
  DROP TABLE [dbo].DATA_FLOW_NDS
GO
CREATE TABLE DATA_FLOW_NDS
(
	TABLE_NAME VARCHAR(100),
	CET DATETIME,
	LSET DATETIME

	CONSTRAINT PK_DFNDS PRIMARY KEY (TABLE_NAME)
)

INSERT INTO DATA_FLOW_NDS VALUES 
('supermarket_sales_NDS', NULL, '01/01/1970'),
('product_NDS', NULL, '01/01/1970'),
('ProductLine_NDS', NULL, '01/01/1970'),
('city_NDS', NULL, '01/01/1970')
GO

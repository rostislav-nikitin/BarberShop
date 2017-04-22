CREATE DATABASE [Barbershop]
GO

USE [Barbershop]
GO

CREATE TABLE [dbo].[PersonType]
(
	[PersonTypeId]	INT				NOT NULL IDENTITY(1, 1),
	[Alias]			VARCHAR(255)	NOT NULL,

	CONSTRAINT [PK_PersonType] PRIMARY KEY ([PersonTypeId]),
)
GO

CREATE UNIQUE NONCLUSTERED INDEX [UX_PersonType_Alias] 
	ON [dbo].[PersonType] ([Alias])
	INCLUDE ([PersonTypeId])
GO

CREATE TABLE [dbo].[Person]
(
	[PersonId]		INT					NOT NULL	IDENTITY(1, 1),
	[PersonTypeId]	INT					NOT NULL,
	[FirstName]		NVARCHAR(128)		NOT NULL,
	[LastName]		NVARCHAR(128)		NOT NULL,
	[PhoneNumber]	NVARCHAR(255)		NULL,
	[Email]			NVARCHAR(255)		NULL,

	CONSTRAINT [PK_Person] PRIMARY KEY ([PersonId]),
	CONSTRAINT [FK_Person_PersonType] FOREIGN KEY ([PersonTypeId]) REFERENCES [dbo].[PersonType] ([PersonTypeId])
)
GO

CREATE TABLE [dbo].[Barbershop]
(
	[BarbershopId]		INT	NOT NULL	IDENTITY(1, 1),
	[Alias]				VARCHAR(255)	NOT NULL,
	[Name]				NVARCHAR(255)	NOT NULL,
	[PhoneNumber]		NVARCHAR(255)	NOT NULL,
	[Email]				NVARCHAR(255)	NOT NULL,
	[AdministratorId]	INT				NOT NULL,

	CONSTRAINT [PK_Barbershop] PRIMARY KEY ([BarbershopId]),
	CONSTRAINT [FK_Barbershop_Administrator] FOREIGN KEY ([AdministratorId]) REFERENCES [dbo].[Person] ([PersonId])
)
GO

CREATE UNIQUE NONCLUSTERED INDEX [UX_Barbershop_Alias]
	ON [dbo].[Barbershop] ([Alias])
	INCLUDE ([BarbershopId])
GO

CREATE TABLE [dbo].[ScheduleLineType]
(
	[ScheduleLineTypeId]	INT				NOT NULL	IDENTITY(1, 1),
	[Alias]					VARCHAR(255)	NOT NULL,
	[Name]					NVARCHAR(255)	NOT NULL,

	CONSTRAINT [PK_SchedultLineType] PRIMARY KEY ([ScheduleLineTypeId])
)
GO

CREATE UNIQUE NONCLUSTERED INDEX [UX_ScheduleLineType_Alias]
	ON [dbo].[ScheduleLineType] ([Alias])
	INCLUDE ([ScheduleLineTypeId], [Name])
GO

CREATE TABLE [dbo].[ScheduleLine]
(
	[ScheduleLineId]		INT			NOT NULL	IDENTITY(1, 1),
	[ScheduleLineTypeId]	INT			NOT NULL,
	[EmployeeId]			INT			NOT NULL,
	[CustomerId]			INT			NULL,
	[From]					DATETIME2	NOT NULL,
	[To]					DATETIME2	NOT NULL,

	CONSTRAINT [PK_ShceduleLine] PRIMARY KEY ([ScheduleLineId]),
	CONSTRAINT [FK_SchedultLine_SchedultLineType] FOREIGN KEY ([ScheduleLineTypeId]) REFERENCES [dbo].[ScheduleLineType] ([ScheduleLineTypeId]),
	CONSTRAINT [FK_ScheduleLine_Employee] FOREIGN KEY ([EmployeeId]) REFERENCES [dbo].[Person] ([PersonId]),
	CONSTRAINT [FK_AppointmentLine_Customer] FOREIGN KEY ([CustomerId]) REFERENCES [dbo].[Person] ([PersonId])
)
GO

CREATE TABLE [dbo].[ServiceType]
(
	[ServiceTypeId]	INT				NOT NULL	IDENTITY(1, 1),
	[Alias]			VARCHAR(255)	NOT NULL,
	[Name]			NVARCHAR(255)	NOT NULL,
	[Price]			MONEY			NOT NULL	DEFAULT(0.0),
	[Duration]		INT				NOT NULL	DEFAULT(15)

	CONSTRAINT [PK_ServiceType] PRIMARY KEY ([ServiceTypeId])
)
GO

CREATE UNIQUE NONCLUSTERED INDEX [UX_ServiceType_Alias]
	ON [dbo].[ServiceType] ([Alias])
	INCLUDE ([ServiceTypeId], [Name], [Price])
GO

CREATE TABLE [dbo].[EmployeeServiceType]
(
	[EmployeeServiceTypeId]	INT	NOT NULL	IDENTITY(1, 1),
	[EmployeeId]			INT NOT NULL,
	[ServiceTypeId]			INT NOT NULL,

	CONSTRAINT [PK_EmployeeServiceType] PRIMARY KEY ([EmployeeServiceTypeId]),
	CONSTRAINT [FK_EmployeeServiceType_Employee] FOREIGN KEY ([EmployeeId]) REFERENCES [dbo].[Person] ([PersonId]),
	CONSTRAINT [FK_EmployeeServiceType_SeviceType] FOREIGN KEY ([ServiceTypeId]) REFERENCES [dbo].[ServiceType] ([ServiceTypeId])
)
GO

CREATE TABLE [dbo].[ScheduleLineServiceType]
(
	[ScheduleLineServiceTypeId]	INT	NOT NULL	IDENTITY(1, 1),
	[ScheduleLineId]			INT	NOT NULL,
	[ServiceTypeId]				INT NOT NULL,

	CONSTRAINT [PK_ServiceLineServiceType] PRIMARY KEY ([ScheduleLineServiceTypeId]),
	CONSTRAINT [FK_ScheduleLineServiceType_ScheduleLine] FOREIGN KEY ([ScheduleLineId]) REFERENCES [dbo].[ScheduleLine] ([ScheduleLineId]),
	CONSTRAINT [FK_SchedultLineServiceType_ServiceType] FOREIGN KEY ([ServiceTypeId]) REFERENCES [dbo].[ServiceType] ([ServiceTypeId])
)
GO
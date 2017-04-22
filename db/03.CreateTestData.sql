-- Insert employees
INSERT INTO [dbo].[Person]
		([PersonTypeId], [FirstName], [LastName], [PhoneNumber], [Email])
	VALUES 
		((SELECT TOP 1 [PersonTypeId] FROM [dbo].[PersonType] WHERE [Alias] = 'administrator'), 
			'Админ', 'Админов', '+380 56 111 1111', 'info@barbershop.dp.ua'),
		((SELECT TOP 1 [PersonTypeId] FROM [dbo].[PersonType] WHERE [Alias] = 'barber'),
			'Людмила', 'Петрова', '+380 56 111 1112', 'ludmila.petrova@barbershop.dp.ua'),
		((SELECT TOP 1 [PersonTypeId] FROM [dbo].[PersonType] WHERE [Alias] = 'barber'), 
			'Ирина', 'Иванова', '+380 56 111 1113', 'irina.ivanova@barbershop.dp.ua'),
		((SELECT TOP 1 [PersonTypeId] FROM [dbo].[PersonType] WHERE [Alias] = 'barber'), 
			'София', 'Иванченко', '+380 56 111 1114', 'sofia.ivanchenko@barbershop.dp.ua'),
		((SELECT TOP 1 [PersonTypeId] FROM [dbo].[PersonType] WHERE [Alias] = 'manicurist'), 
			'Жанна', 'Сидорова', '+380 56 111 1115', 'jane.sidorova@barbershop.dp.ua')

-- Insert employee services
	INSERT INTO [dbo].[EmployeeServiceType]
			([EmployeeId], [ServiceTypeId])
		SELECT [p].[PersonId], [st].[ServiceTypeId]
			FROM [dbo].[Person] AS [p]
				INNER JOIN [dbo].[PersonType] AS [pt] ON [pt].[PersonTypeId] = [p].[PersonTypeId]
				INNER JOIN [dbo].[ServiceType] AS [st] ON 
					(
						([st].[Alias] = 'haircut' AND [pt].[Alias] = 'barber')
						OR ([st].[Alias] = 'manicur' AND [pt].[Alias] = 'manicurist')
						OR ([st].[Alias] = 'pedicur' AND [pt].[Alias] = 'manicurist')
					)

-- Insert customers
INSERT INTO [dbo].[Person]
		([PersonTypeId], [FirstName], [LastName], [PhoneNumber], [Email])
	VALUES 
		((SELECT TOP 1 [PersonTypeId] FROM [dbo].[PersonType] WHERE [Alias] = 'customer'), 
			'Николай', 'Сергеев', '+380 56 222 2222', 'nikolai.sergeev@mail.dp.ua'),
		((SELECT TOP 1 [PersonTypeId] FROM [dbo].[PersonType] WHERE [Alias] = 'customer'),
			'Дмитрий', 'Андреев', '+380 56 333 3333', 'dmitri.andreev@mail.dp.ua'),
		((SELECT TOP 1 [PersonTypeId] FROM [dbo].[PersonType] WHERE [Alias] = 'customer'),
			'Анна', 'Дмитриева', '+380 56 444 4444', 'anna.dmitrieva@mail.dp.ua')

-- Insert barbershop
INSERT INTO [dbo].[Barbershop]
		([Alias], [Name], [PhoneNumber], [Email], [AdministratorId])
	VALUES ('barber-at-sverdlova', 'Парикмахерская на Свердлова', '+380 56 111 1110', 'info@barbershop.dp.ua', 
		(SELECT TOP 1 [PersonId] FROM [dbo].[Person] WHERE [PersonTypeId] = 
			(SELECT TOP 1 [PersonTypeId] FROM [dbo].[PersonType] WHERE [Alias] = 'administrator')))

-- Insert schedule lines for today for all employees
--DELETE FROM [dbo].[ScheduleLine]
INSERT INTO [dbo].[ScheduleLine]
		([ScheduleLineTypeId], [EmployeeId], [From], [To])
	SELECT 
			(SELECT TOP 1 [ScheduleLineTypeId] FROM [dbo].[ScheduleLineType] WHERE [Alias] = 'employee-schedule-line') AS [SchedultLineTypeId], 
			[p].[PersonId], 
			[seg].[From], 
			[seg].[To]
		FROM [dbo].[Person] AS [p]
			INNER JOIN (SELECT DATETIME2FROMPARTS (Year(GetDate()), Month(GetDate()), Day(GetDate()), 09, 00, 00, 00, 00) AS [From],
							DATETIME2FROMPARTS (Year(GetDate()), Month(GetDate()), Day(GetDate()), 13, 00, 00, 00, 00) AS [To]) AS [seg] ON (1=1)

		WHERE [p].[PersonTypeId] IN
			(SELECT [PersonTypeId] FROM [dbo].[PersonType] WHERE [Alias] = 'barber' OR [Alias] = 'manicurist')

INSERT INTO [dbo].[ScheduleLine]
		([ScheduleLineTypeId], [EmployeeId], [From], [To])
	SELECT 
			(SELECT TOP 1 [ScheduleLineTypeId] FROM [dbo].[ScheduleLineType] WHERE [Alias] = 'employee-schedule-line') AS [SchedultLineTypeId], 
			[p].[PersonId], 
			[seg].[From], 
			[seg].[To]
		FROM [dbo].[Person] AS [p]
			INNER JOIN (SELECT DATETIME2FROMPARTS (Year(GetDate()), Month(GetDate()), Day(GetDate()), 14, 00, 00, 00, 00) AS [From],
							DATETIME2FROMPARTS (Year(GetDate()), Month(GetDate()), Day(GetDate()), 20, 00, 00, 00, 00) AS [To]) AS [seg] ON (1=1)

		WHERE [p].[PersonTypeId] IN
			(SELECT [PersonTypeId] FROM [dbo].[PersonType] WHERE [Alias] = 'barber' OR [Alias] = 'manicurist')


-- Insert schedule lines (appointments) for today for all employees and customers
;WITH [Customers] AS
(
	SELECT [PersonId] AS [CustomerId]
		FROM [dbo].[Person] AS [p]
			INNER JOIN [dbo].[PersonType] AS [pt] ON [pt].[PersonTypeId] = [p].[PersonTypeId]
		WHERE [pt].[Alias] = 'customer'
), [Employees] AS
(
	SELECT [PersonId] AS [EmployeeId]
		FROM [dbo].[Person] AS [p]
			INNER JOIN [dbo].[PersonType] AS [pt] ON [pt].[PersonTypeId] = [p].[PersonTypeId]
		WHERE [pt].[Alias] IN ('barber', 'manicurist')
), [CustomersNumbered] AS
(
	SELECT 
			[CustomerId], 
			Row_Number() OVER (ORDER BY [CustomerId]) AS [RowNumber]
		FROM [Customers]
), [EmployeesNumbered] AS
(
	SELECT
			[EmployeeId],
			Row_Number() OVER (ORDER BY [EmployeeId]) AS [RowNumber]
		FROM
			[Employees]
), [Appointments] AS
(
	SELECT [cn].[CustomerId], [en].[EmployeeId], 
		(SELECT TOP 1 [st].[Duration]
			FROM [dbo].[ServiceType] AS [st]
				INNER JOIN [dbo].[EmployeeServiceType] AS [est] ON [est].[ServiceTypeId] = [st].[ServiceTypeId]
			WHERE [est].[EmployeeId] = [en].[EmployeeId]) AS [Duration],
		(SELECT TOP 1 [ScheduleLineTypeId]
			FROM [dbo].[ScheduleLineType]
			WHERE [Alias] = 'appointment') AS [ScheduleLineTypeId],
		(SELECT TOP 1 [From]
			FROM [dbo].[ScheduleLine] 
			WHERE [EmployeeId] = [en].[EmployeeId]
				AND [ScheduleLineTypeId] = (
					SELECT TOP 1 [ScheduleLineTypeId] 
						FROM [dbo].[ScheduleLineType] 
						WHERE [Alias] = 'employee-schedule-line')) AS [From]
		FROM [CustomersNumbered] AS [cn]
			INNER JOIN [EmployeesNumbered] AS [en] ON [en].[RowNumber] = [cn].[RowNumber]
)

INSERT INTO [dbo].[ScheduleLine]
		([ScheduleLineTypeId], [EmployeeId], [CustomerId], [From], [To])
	SELECT
			[ScheduleLineTypeId], [EmployeeId], [CustomerId], [From], DateAdd(MINUTE, [Duration], [From])
		FROM [Appointments]


-- Insert schedule lines (appointments) services for today for all employees and customers
INSERT INTO [dbo].[ScheduleLineServiceType]
		([ScheduleLineId], [ServiceTypeId])
	SELECT
			[sl].[ScheduleLineId],
			(SELECT TOP 1 [ServiceTypeId]
				FROM [dbo].[EmployeeServiceType] AS [est]
				WHERE [est].[EmployeeId] = [sl].[EmployeeId])
		FROM [dbo].[ScheduleLine] AS [sl]
		WHERE [sl].[ScheduleLineTypeId] IN 
			(SELECT [ScheduleLineTypeId] FROM [dbo].[ScheduleLineType] WHERE [Alias] = 'appointment')
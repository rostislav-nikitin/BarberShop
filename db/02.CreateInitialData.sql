-- Initialize person types
INSERT INTO [dbo].[PersonType]
	([Alias])
	VALUES ('administrator'), ('barber'), ('manicurist'), ('customer')

-- Initialize shcedule line types
INSERT INTO [dbo].[ScheduleLineType]
		([Alias], [Name])
	VALUES ('employee-schedule-line','Расписание'), ('appointment', 'Бронь')

-- Initialize service types
INSERT INTO [dbo].[ServiceType]
	([Alias], [Name], [Price], [Duration])
	VALUES ('haircut', 'Стрижка', 120.00, 60), ('manicur', 'Маникюр', 80.00, 120), ('pedicur', 'Педикюр', 110.00, 45)
-- Initialize person types
INSERT INTO [dbo].[PersonType]
	([Alias])
	VALUES ('administrator'), ('barber'), ('manicurist'), ('customer')

-- Initialize shcedule line types
INSERT INTO [dbo].[ScheduleLineType]
		([Alias], [Name])
	VALUES ('employee-schedule-line','����������'), ('appointment', '�����')

-- Initialize service types
INSERT INTO [dbo].[ServiceType]
	([Alias], [Name], [Price], [Duration])
	VALUES ('haircut', '�������', 120.00, 60), ('manicur', '�������', 80.00, 120), ('pedicur', '�������', 110.00, 45)
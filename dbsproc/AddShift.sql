USE [DogShelterDataBase]
GO

/****** Object:  StoredProcedure [dbo].[AddShift]    Script Date: 5/12/2022 10:34:01 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AddShift]
(
	@StartTime varchar(10) = null,
	@Span decimal(2,1),
	@Date varchar(10) = null,
	@TODO varchar(500) = null,
	@Note varchar(500) = null
)
AS
BEGIN

	if (@Span is null)
	BEGIN
		RAISERROR('Please Specify span', 14, 2);
		RETURN 2;
	END

	DECLARE @convDate Date
	DECLARE @convTime time(0)

	if (@date is null)
	BEGIN
		SET @convDate = convert(date, GETDATE())
	END
	else 
	BEGIN
		SET @convDate = Try_Convert(Date, @date)
	END

	if (@StartTime is null)
	BEGIN 
		SET @convTime = convert(time(0), convert(varchar(5), (convert(time(0), GETDATE()))))
	END
	else
	BEGIN
		SET @convTime = Try_Convert(time(0), @StartTime)
	END


	if (@convDate is null) 
	BEGIN
		RAISERROR('Invalid date', 14, 85);
		RETURN 85;
	END

	if (@convTime is null) 
	BEGIN
		RAISERROR('Invalid time', 14, 86);
		RETURN 86;
	END

	if (exists (SELECT * FROM [Shift] WHERE StartTime = @convTime and [Date] = @convDate))
	BEGIN
		RAISERROR('shift already exists',14, 3);
		RETURN 3;
	END


	INSERT INTO [Shift]
	(StartTime, Span, [Date], TODO, Note)
	Values(@convTime, @Span, @convDate, @todo, @note)

	SELECT * FROM [ShiftFormatted] WHERE ID = @@IDENTITY

	RETURN 0;

END

GO



USE [DogShelterDataBase]
GO

/****** Object:  StoredProcedure [dbo].[UpdateShift]    Script Date: 5/12/2022 10:24:49 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[UpdateShift]
(
	@ID int,
	@StartTime varchar(10) = null,
	@Span decimal(2,1), 
	@Date varchar(10) = null,
	@TODO varchar(500) = null,
	@Note varchar(500) = null
)
AS
BEGIN
	if (@ID is null or not exists(SELECT * FROM [Shift] WHERE ID = @ID))
	BEGIN
		RAISERROR('invalid shift id', 14, 97);
		RETURN 97;
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


	UPDATE [Shift]
	SET StartTime = @convTime, Span = @Span, [Date] = @convDate, TODO = @todo, Note = @note
	WHERE ID = @ID

	SELECT * FROM [Shift] WHERE ID = @ID
	RETURN 0;

END

GO



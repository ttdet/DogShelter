USE [DogShelterDataBase]
GO

/****** Object:  StoredProcedure [dbo].[AddBRLog]    Script Date: 5/12/2022 10:35:35 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[AddBRLog]
(
	--exactly one of name and id has to be provided
	@dName varchar(50), 
	@dID int,
	@time varchar(10) = null,
	@date varchar(10) = null,
	@type varchar(30) = null, 
	@Note varchar(200) = null
)
AS
BEGIN

	if (@date is null)
	BEGIN
		SET @date = convert(date, GETDATE())
	END

	if (@time is null)
	BEGIN
		SET @time = convert(time(0), GETDATE())
	END

	if(@dID is null and @dName is null)
	BEGIN
		RAISERROR('dog info needed', 14, 1);
		
		RETURN 1;
	END

	if (@type is null) 
	BEGIN
		RAISERROR('entry description needed', 14, 25);
		
		RETURN 25;
	END

	if (@dID is not null and @dName is not null)
	BEGIN
		RAISERROR('Only one of dog ID and dog name needed', 14, 3);
		
		RETURN 3;
	END

	--ID value to make the final insertion
	DECLARE @dbDogID int = null;

	--dName is provided. dID is null
	if (@dName is not null)
	BEGIN
		--No dog with given name
		if (not exists(SELECT * FROM Dog WHERE [name] = @dName))
		BEGIN
			RAISERROR('dog does not exist', 14, 5);
			
			RETURN 5;
		END
		--More than one dog with the given name
		else if (not exists(SELECT [Name] FROM Dog WHERE [name] = @dName GROUP BY [name] HAVING count(*) = 1))
		BEGIN
			RAISERROR('there is more than one dog with the given name.', 14, 6);
			
			RETURN 6;
		END
		--The dog name is valid
		else
		BEGIN
			SET @dbDogID = (SELECT ID FROM Dog WHERE [Name] = @dName)
		END
	END

	--Dog ID is provided. Name is null.
	else if (@dID is not null)
	BEGIN
		if(not exists(SELECT * FROM Dog WHERE ID = @dID))
		BEGIN
			RAISERROR('the given dog ID does not exist.', 14, 7);
			
			RETURN 7;
		END
		else 
		BEGIN
			SET @dbDogID = @dID
		END
	END

	if (exists(SELECT * FROM BRLog WHERE DogID = @dbDogID and [Date] = @date and [Time] = @time))
	BEGIN
		RAISERROR('The record already exists', 14, 27);
		
		RETURN 27;
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

	if (@time is null)
	BEGIN 
		SET @convTime = convert(time(0), GETDATE())
	END
	else
	BEGIN
		SET @convTime = Try_Convert(time(0), @time)
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

	IF @convDate > GETDATE()
	BEGIN
		RAISERROR('Cannot add bathroom log from the future', 14, 8);
		RETURN 8;
	END


	INSERT INTO BRLog
	(DogID, [Time], [Date], [Type], [Note])
	Values(@dbDogID, @convTime, @convDate, @type, @Note)
	
	--SELECT BRLog.ID AS ID, Dog.ID AS DogID,
	--		FORMAT(CONVERT(datetime, [Time]), 'hh\:mm tt') AS [Time],
	--		FORMAT([Date], 'MM/dd/yyyy') AS [Date],
	--		[Type], Note, [Name]
	--FROM BRLog
	--JOIN Dog ON BRLog.DogID = Dog.ID
	--WHERE BRLog.ID = @@IDENTITY

	SELECT * FROM BRLogDetailFormatted WHERE BRLogDetailFormatted.ID = @@IDENTITY
	
	RETURN 0;

END

GO



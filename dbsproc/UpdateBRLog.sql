USE [DogShelterDataBase]
GO

/****** Object:  StoredProcedure [dbo].[UpdateBRLog]    Script Date: 5/12/2022 10:27:03 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[UpdateBRLog]
(
	--exactly one of name and id has to be provided
	@ID int,
	@dName varchar(50), 
	@dID int,
	@time time(0) = null,
	@date date = null,
	@type varchar(30), 
	@Note varchar(200) = null
)
AS
BEGIN
	if (@ID is null or not exists (SELECT * FROM BRLog WHERE ID = @ID))
	BEGIN
		RAISERROR('invalid bathroom log id', 14, 96);
		RETURN 96;
	END

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


	UPDATE BRLog
	SET DogID = @dbDogID, [Time] = @time, [Date] = @date, [Type] = @type, Note = @Note
	WHERE ID = @ID
	RETURN 0;

END

GO



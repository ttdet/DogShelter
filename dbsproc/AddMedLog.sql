USE [DogShelterDataBase]
GO
/****** Object:  StoredProcedure [dbo].[AddMedLog]    Script Date: 5/13/2022 5:47:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER   PROCEDURE [dbo].[AddMedLog]
(
	--exactly one of name and id has to be provided
	@dName varchar(50) = null, 
	@dID int, 
	----For Volunteer, accepted parameter forms are : FirstName || LastName || FirstName and LastName || ID
	@vfn varchar(50) = null, --volunteer first name
	@vln varchar(50) = null, --volunteer last name
	@vID int, --volunteer id
	@mName varchar(50) = null,
	@mID int,
	@date varchar(10) = null, 
	@time varchar(10) = null,
	@amount decimal(4,1) = null,
	@Note varchar(100) = null
)
AS
BEGIN
	
	if(@vID = -1)
	BEGIN
		RAISERROR('invalid volunteer', 14, 26);
		RETURN 26;
	END
	if(@dID is null and @dName is null)
	BEGIN
		RAISERROR('dog info needed', 14, 1);
		RETURN 1;
	END

	if (@mID is null and @mName is null)
	BEGIN
		RAISERROR('med info needed', 14, 2);
		RETURN 2;
	END

	if (@vfn is null and @vln is null and @vID is null)
	BEGIN
		RAISERROR('volunteer info needed', 14, 13);
		RETURN 13;
	END

	if (@dID is not null and @dName is not null)
	BEGIN
		RAISERROR('Only one of dog ID and dog name needed', 14, 3);
		RETURN 3;
	END

	if (@mID is not null and @mName is not null)
	BEGIN 
		RAISERROR('Only one of med ID and med name needed', 14, 4);
		RETURN 4;
	END

	if ((@vfn is not null or @vln is not null) and @vID is not null)
	BEGIN
		RAISERROR('Only one of volunteer ID and volunteer full name is needed', 14, 13);
		RETURN 13;
	END

	IF @amount IS NULL
	BEGIN
		RAISERROR('Must provide an amount', 14, 15);
		RETURN 15;
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

	--ID value to make the final insertion
	DECLARE @dbMedID int = null;

	--mName is provided. mID is null
	if (@mName is not null)
	BEGIN
		--No med with given name
		if (not exists(SELECT * FROM Medicine WHERE [name] = @mName))
		BEGIN
			RAISERROR('med name does not exist', 14, 8);
			RETURN 8;
		END
		--More than one med with the given name
		else if (not exists(SELECT [Name] FROM Medicine WHERE [name] = @mName GROUP BY [name] HAVING count(*) = 1))
		BEGIN
			RAISERROR('there is more than one med with the given name.', 14, 9);
			RETURN 9;
		END
		--The med name is valid
		else
		BEGIN
			SET @dbMedID = (SELECT ID FROM Medicine WHERE [Name] = @mName)
		END
	END

	--med ID is provided. Name is null.
	else if (@mID is not null)
	BEGIN
		if(not exists(SELECT * FROM Medicine WHERE ID = @mID))
		BEGIN
			RAISERROR('the given med ID does not exist.', 14, 10);
			RETURN 10;
		END
		else 
		BEGIN
			SET @dbMedID = @mID
		END
	END

	DECLARE @dbVID int = null;

	if(@vID is null)
	BEGIN
		--first name provided
		if (@vfn is not null and @vln is null)
		BEGIN
			if (not exists(SELECT * FROM Volunteer WHERE FirstName = @vfn))
			BEGIN
				RAISERROR('volunteer does not exist', 14, 20);
				RETURN 20;
			END
			--More than one volunteer with the given first name
			else if (not exists(SELECT FirstName FROM Volunteer WHERE FirstName = @vfn GROUP BY FirstName HAVING count(*) = 1))
			BEGIN
				RAISERROR('there is more than one volunteer with the given first name.', 14, 21);
				RETURN 21;
			END
			--The first name is valid
			else
			BEGIN
				SET @dbVID = (SELECT ID FROM Volunteer WHERE FirstName = @vfn)
			END
		END
		--last name provided
		else if (@vfn is null and @vln is not null)
		BEGIN
			if (not exists(SELECT * FROM Volunteer WHERE LastName = @vln))
			BEGIN
				RAISERROR('volunteer does not exist', 14, 22);
				RETURN 22;
			END
			--More than one volunteer with the given last name
			else if (not exists(SELECT LastName FROM Volunteer WHERE LastName = @vln GROUP BY LastName HAVING count(*) = 1))
			BEGIN
				RAISERROR('there is more than one volunteer with the given last name.', 14, 23);
				RETURN 23;
			END
			--The last name is valid
			else
			BEGIN
				SET @dbVID = (SELECT ID FROM Volunteer WHERE LastName = @vln)
			END
		END
		--full name provided
		else
		BEGIN
			if (not exists(SELECT * FROM Volunteer WHERE FirstName = @vfn and LastName = @vln))
			BEGIN
				RAISERROR('volunteer does not exist', 14, 24);
				RETURN 24;
			END
			--More than one volunteer with the given first name
			else if (not exists(SELECT FirstName FROM Volunteer WHERE FirstName = @vfn and LastName = @vln GROUP BY FirstName, LastName HAVING count(*) = 1))
			BEGIN
				RAISERROR('there is more than one volunteer with the given full name.', 14, 21);
				RETURN 25;
			END
			--The first name is valid
			else
			BEGIN
				SET @dbVID = (SELECT ID FROM Volunteer WHERE FirstName = @vfn and LastName = @vln)
			END
		END
	END

	--VID provided, no name
	else if (@vID is not null)
		BEGIN
			if(not exists(SELECT * FROM Volunteer WHERE ID = @vID))
			BEGIN
				RAISERROR('the given volunteer ID does not exist.', 14, 26);
				RETURN 26;
			END
			else 
			BEGIN
				SET @dbVID = @vID
			END
		END

	DECLARE @oldStock decimal(4,1)
	SET @oldStock = (SELECT Stock FROM Medicine WHERE ID = @dbMedID)

	if (@amount > @oldStock)
	BEGIN
		RAISERROR('medicine out of stock', 14, 67);
		RETURN 67;
	END

	if (exists(SELECT * FROM MedLog WHERE DogID = @dbDogID and MedID = @dbMedID and VolunteerID = @dbVID and [Date] = @date and [Time] = @time))
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
		SET @convTime = convert(time(0), convert(varchar(5), (convert(time(0), GETDATE()))))
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
		RAISERROR('Cannot add bathroom log from the future', 14, 87);
		RETURN 87;
	END


	INSERT INTO MedLog
	(DogID, VolunteerID, medID, [Date], [Time], Amount, Note)
	Values(@dbDogID, @dbVID, @dbMedID, @convDate, @convTime, @amount, @Note)

	UPDATE Medicine
	SET Stock = @oldStock - @amount
	WHERE ID = @dbMedID

	SELECT * FROM MedLogDetailFormatted WHERE ID = @@IDENTITY

	RETURN 0;

END

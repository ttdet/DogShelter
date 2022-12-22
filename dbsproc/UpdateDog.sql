USE [DogShelterDataBase]
GO

/****** Object:  StoredProcedure [dbo].[UpdateDog]    Script Date: 5/12/2022 10:26:51 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   PROCEDURE [dbo].[UpdateDog]
	(@ID int,
	@Name varchar(50),
	@WeightInlbs int = null,
	@hasBeenSpayed bit = null,
	@DOB varchar(10) = null,
	@Sex varchar(20) = null,
	@Breed varchar(50) = null,
	@Information varchar(500) = null,
	@GeneralInstruction varchar(500) = null,
	@FeedInstruction varchar(500) = null
)
AS
BEGIN
	--Validates parameters
	IF (@ID is null)
	BEGIN
		RAISERROR('DogID provided is null', 14, 1);
		RETURN 1
	END
	if (@name is null)
	BEGIN
		RAISERROR('dog name cannot be null', 14, 3);
		RETURN 3;
	END
	IF (NOT EXISTS (SELECT * FROM [Dog] WHERE [ID] = @ID))
	BEGIN
		RAISERROR('Provided DogID does not exist.', 14, 2);
		RETURN 2
	END

	DECLARE @convDate date = null
	if (@DOB is not null)
	BEGIN
		SET @convDate = TRY_CONVERT(date, @DOB);
		if (@convDate is null)
		BEGIN
			RAISERROR('invalid dob', 14, 55);
			RETURN 55;
		END
	END

	

	UPDATE [Dog]
	SET [Name] = @Name, [WeightInlbs] = @WeightInlbs, [hasBeenSpayed] = @hasBeenSpayed, 
		[DateOfBirth] = @convDate, [Sex] = @Sex, [Breed] = @breed, 
		[Information] = @Information, [GeneralInstruction] = @GeneralInstruction, 
		[FeedInstruction] = @FeedInstruction
	WHERE ([ID] = @ID)
	RETURN 0;


	
END
GO



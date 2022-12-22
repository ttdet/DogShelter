USE [DogShelterDataBase]
GO

/****** Object:  StoredProcedure [dbo].[AddDog]    Script Date: 5/12/2022 10:35:26 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AddDog]
(	
	@name varchar(50),
	@WeightInLbs int = null,
	@HasBeenSpayed bit = null,
	@DOB varchar(10) = null,
	@Sex varchar(20) = null,
	@Breed varchar(50) = null,
	@information varchar(500) = null,
	@GeneralInstruction varchar(500) = null,
	@FeedInstruction varchar(500) = null
)
AS
BEGIN

	IF(@name is null)
	BEGIN
		RAISERROR('name cannot be null', 14, 1);
		RETURN 1;
	END

	IF(@WeightInLbs is not null and @WeightInLbs <= 0)
	BEGIN
		RAISERROR('weight must be positive', 14, 2);
		RETURN 2;
	END

	IF(@Sex is not null and @Sex != 'male' and @Sex != 'female')
	BEGIN
		RAISERROR('sex must be either male or female', 14, 3);
		RETURN 3;
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


	INSERT INTO Dog
	([name], [weightinlbs], hasbeenspayed, dateofbirth, sex, breed, information, generalinstruction, feedinstruction)
	Values(@name, @WeightInLbs, @HasBeenSpayed, @convDate, @Sex, @Breed, @information, @GeneralInstruction, @FeedInstruction)

	SELECT * FROM Dog WHERE Dog.ID = @@IDENTITY

	RETURN 0;

END
GO



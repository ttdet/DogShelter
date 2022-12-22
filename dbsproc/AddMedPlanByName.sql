USE [DogShelterDataBase]
GO

/****** Object:  StoredProcedure [dbo].[AddMedPlanByName]    Script Date: 5/16/2022 7:57:37 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AddMedPlanByName]
(
	--exactly one of name and id has to be provided
	@dName varchar(50), --dog id
	@mName varchar(50),
	@startDate date = null, 
	@endDate date = null,
	@DR varchar(20) = null,
	@SI varchar(200) = null
)
AS
BEGIN

	if (@startDate is null)
	BEGIN
		SET @startDate = convert(date, GETDATE())
	END

	if(@dName is null)
	BEGIN
		RAISERROR('Dog name is required', 14, 1);
		RETURN 1;
	END

	if (@mName is null)
	BEGIN
		RAISERROR('Medication name is required', 14, 2);
		RETURN 2;
	END

	IF(@endDate IS NOT NULL AND @endDate < @startDate)
	BEGIN
		RAISERROR('endDate cannot be before startDate', 14, 3)
		RETURN 3;
	END

	--Dog ID is provided. Name is null.
	if(not exists(SELECT * FROM Dog WHERE [Name] = @dName))
	BEGIN
		RAISERROR('the given dog name does not exist.', 14, 7);
		RETURN 7;
	END

	if (exists(SELECT [Name] FROM Dog WHERE [Name] = @dName GROUP BY [Name] HAVING COUNT(*) > 1))
	BEGIN
		RAISERROR('more than one dog with the given name.', 14, 8);
		RETURN 8;
	END

	--med ID is provided. Name is null.
	if(not exists(SELECT * FROM Medicine WHERE Name = @mName))
	BEGIN
		RAISERROR('the given med name does not exist.', 14, 10);
		RETURN 10;
	END

	if (exists(SELECT [Name] FROM Medicine WHERE [Name] = @dName GROUP BY [Name] HAVING COUNT(*) > 1))
	BEGIN
		RAISERROR('more than one med with the given name.', 14, 8);
		RETURN 8;
	END

	DECLARE @dID int;
	DECLARE @mID int;

	SET @dID = (SELECT ID FROM Dog WHERE [Name] = @dName)
	SET @mID = (SELECT ID FROM Medicine WHERE [Name] = @mID)

	if (exists (SELECT * FROM MedPlan WHERE DogID = @dID and MedID = @mID and StartDate = @startDate))
	BEGIN
		RAISERROR('record already exists', 14, 50);
		RETURN 50;
	END

	INSERT INTO MedPlan(DogID, MedID, StartDate, EndDate, DosageRegime, SpecialInstruction)
	VALUES(@dID, @mID, @startDate, @endDate, @DR, @SI)

	SELECT *
	FROM MedPlanDetailFormatted
	WHERE MedPlanID = @@IDENTITY

	RETURN 0;

END
GO



USE [DogShelterDataBase]
GO

/****** Object:  StoredProcedure [dbo].[AddMedPlan]    Script Date: 5/12/2022 10:34:19 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AddMedPlan]
(
	--exactly one of name and id has to be provided
	@dID int, --dog id
	@mID int, --med id
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

	if(@dID is null)
	BEGIN
		RAISERROR('Dog ID is required', 14, 1);
		RETURN 1;
	END

	if (@mID is null)
	BEGIN
		RAISERROR('Medication ID is required', 14, 2);
		RETURN 2;
	END

	IF(@endDate IS NOT NULL AND @endDate < @startDate)
	BEGIN
		RAISERROR('endDate cannot be before startDate', 14, 3)
		RETURN 3;
	END

	--Dog ID is provided. Name is null.
	if(not exists(SELECT * FROM Dog WHERE ID = @dID))
	BEGIN
		RAISERROR('the given dog ID does not exist.', 14, 7);
		RETURN 7;
	END

	--med ID is provided. Name is null.
	if(not exists(SELECT * FROM Medicine WHERE ID = @mID))
	BEGIN
		RAISERROR('the given med ID does not exist.', 14, 10);
		RETURN 10;
	END

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



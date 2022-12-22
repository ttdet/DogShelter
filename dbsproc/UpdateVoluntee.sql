USE [DogShelterDataBase]
GO

/****** Object:  StoredProcedure [dbo].[UpdateVolunteer]    Script Date: 5/12/2022 10:23:57 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   PROCEDURE [dbo].[UpdateVolunteer]
(
	@ID int,
	@FirstName varchar(50),
	@LastName varchar(50),
	@DOB varchar(10) = null, 
	@Sex varchar(20) = null,
	@MemberSince varchar(10) = null,
	@CanGiveMed bit,
	@ServicesEndOn varchar(10) = null
)
AS
BEGIN

	IF (@ID is null or not exists(SELECT * FROM Volunteer WHERE ID = @ID))
	BEGIN
		RAISERROR('invalid volunteer ID', 14, 1);
		RETURN 1
	END
	if (@FirstName is null or @LastName is null) 
	BEGIN
		RAISERROR('name cannot be null.', 14, 1);
		
		RETURN 1;
	END

	if (@CanGiveMed is null) 
	BEGIN
		RAISERROR('medic permission cannot be null.', 14, 2);
		
		RETURN 2;
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

	DECLARE @convMS date = null
	if (@MemberSince is not null)
	BEGIN
		SET @convMS = TRY_CONVERT(date, @MemberSince);
		if (@convMS is null)
		BEGIN
			RAISERROR('invalid dates', 14, 55);
			RETURN 55;
		END
	END

	DECLARE @convSEO date = null
	if (@ServicesEndOn is not null)
	BEGIN
		SET @convSEO = TRY_CONVERT(date, @ServicesEndOn);
		if (@convSEO is null)
		BEGIN
			RAISERROR('invalid dates', 14, 55);
			RETURN 55;
		END
	END

	UPDATE Volunteer
	SET FirstName = @FirstName, LastName = @LastName, DateOfBirth = @convDate, 
		Sex = @sex, MemberSince = @convMS, CanGiveMed = @canGiveMed, 
		ServicesEndOn = @convSEO
	WHERE ID = @ID
	RETURN 0;

END
GO



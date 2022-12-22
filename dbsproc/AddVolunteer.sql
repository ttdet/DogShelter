USE [DogShelterDataBase]
GO

/****** Object:  StoredProcedure [dbo].[AddVolunteer]    Script Date: 5/12/2022 10:33:52 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[AddVolunteer]
(
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

	DECLARE @convDOB date = null
	if (@DOB is not null)
	BEGIN
		SET @convDOB = TRY_CONVERT(date, @DOB);
		if (@convDOB is null)
		BEGIN
			RAISERROR('invalid dates', 14, 55);
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


	INSERT INTO Volunteer
	(FirstName, LastName, DateOfBirth, Sex, MemberSince, CanGiveMed, ServicesEndOn)
	Values(@FirstName, @LastName, @convDOB, @Sex, @convMS, @CanGiveMed, @convSEO)
	
	SELECT * FROM Volunteer WHERE Volunteer.ID = @@IDENTITY

	RETURN 0;

END
GO



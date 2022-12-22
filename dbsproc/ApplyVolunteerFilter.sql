USE [DogShelterDataBase]
GO

/****** Object:  StoredProcedure [dbo].[ApplyDogFilter]    Script Date: 5/12/2022 10:35:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [dbo].[ApplyVolunteerFilter]
(
	@FirstName varchar(50) = null,
	@LastName varchar(50) = null,
	@CanGiveMed bit = null
)
AS
BEGIN
	DECLARE @temp TABLE ( [ID] [int] NOT NULL,
	[FirstName] [varchar](50) NOT NULL,
	[LastName] [varchar](50) NOT NULL,
	[DateOfBirth] [date] NULL,
	Sex varchar(20) NULL,
	MemberSince date NULL,
	Age int NULL,
	CanGiveMed bit NULL,
	ServicesEndOn date NULL);
	INSERT INTO @temp 
	(ID, FirstName, LastName, DateOfBirth, Sex, MemberSince, Age, CanGiveMed, ServicesEndOn)
	SELECT * FROM Volunteer
	--if (@Sex is null)
	--BEGIN
	--	RAISERROR('must declare sex', 14, 1);
	--	RETURN 1;
	--END
	if (@FirstName is not null) 
	BEGIN
		DELETE FROM @temp 
		WHERE [FirstName] <> @FirstName
	END
	if (@LastName is not null) 
	BEGIN
		DELETE FROM @temp 
		WHERE [LastName] <> @LastName
	END
	if (@CanGiveMed is not null) 
	BEGIN
		DELETE FROM @temp 
		WHERE [CanGiveMed] <> @CanGiveMed
	END

	SELECT * FROM @temp
	RETURN 0;

END
GO



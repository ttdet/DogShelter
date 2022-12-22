USE [DogShelterDataBase]
GO

/****** Object:  StoredProcedure [dbo].[SearchVolunteerByID]    Script Date: 5/12/2022 10:27:26 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SearchVolunteerByID]
(
	@ID int = null
)
AS
BEGIN
	IF (@ID is null)
	BEGIN
		SELECT * FROM VolunteerFullName JOIN Volunteer ON VolunteerFullName.ID = Volunteer.ID ORDER BY [Name] ASC;
		RETURN 0;
	END
	ELSE
	BEGIN
		SELECT *
		FROM VolunteerFullName 
		JOIN Volunteer ON VolunteerFullName.ID = Volunteer.ID
		WHERE Volunteer.ID = @ID
		ORDER BY [Name] ASC;

		RETURN 0;
	END

END
GO



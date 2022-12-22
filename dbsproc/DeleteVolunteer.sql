USE [DogShelterDataBase]
GO

/****** Object:  StoredProcedure [dbo].[DeleteVolunteer]    Script Date: 5/12/2022 10:31:08 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[DeleteVolunteer]
	(@VolunteerID [int])
AS
BEGIN
	--Validates parameters
	IF (@VolunteerID is null)
	BEGIN
		RAISERROR('VolunteerID provided is null', 14, 1);
		RETURN 1
	END
	IF (NOT EXISTS (SELECT * FROM [Volunteer] WHERE [ID] = @VolunteerID))
	BEGIN
		RAISERROR('Provided VolunteerID does not exist.', 14, 1);
		RETURN 2
	END

	DELETE [Volunteer]
	WHERE ( [ID] = @VolunteerID)
END
GO



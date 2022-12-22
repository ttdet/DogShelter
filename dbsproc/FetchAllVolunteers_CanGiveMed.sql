USE [DogShelterDataBase]
GO

/****** Object:  StoredProcedure [dbo].[FetchAllVolunteers_CanGiveMeds]    Script Date: 5/12/2022 10:30:53 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Grant Giles
-- Create date: 5/11/2022
-- Description:	Fetch all volunteers that can give meds to dogs
-- =============================================
CREATE PROCEDURE [dbo].[FetchAllVolunteers_CanGiveMeds]
AS
BEGIN
	SELECT * FROM VolunteerFullName
	JOIN Volunteer ON VolunteerFullName.ID = Volunteer.ID
	WHERE CanGiveMed = 1
END
GO



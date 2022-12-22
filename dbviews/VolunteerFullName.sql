USE [DogShelterDataBase]
GO

/****** Object:  View [dbo].[VolunteerFullName]    Script Date: 5/12/2022 10:37:45 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VolunteerFullName]
AS
SELECT dbo.formatName(v.FirstName, v.LastName) as Name, v.ID as ID
FROM Volunteer as v
GO



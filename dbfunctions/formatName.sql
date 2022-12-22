USE [DogShelterDataBase]
GO

/****** Object:  UserDefinedFunction [dbo].[formatName]    Script Date: 5/12/2022 10:38:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*
CREATE MedLogByName
AS
SELECT d.[name] as dog, v.[name] as volunteer, m.[name] as med, 
	[Date], [Time], Amount, Note
FROM Dog d 
JOIN MedLog on d.ID = MedLog.DogID
JOIN Volunteer v on MedLog.VolunteerID = v.ID
*/

CREATE function [dbo].[formatName]
(
	@FirstName nvarchar(50),
	@LastName nvarchar(50)
)
RETURNS nvarchar(100)
AS
BEGIN
	RETURN @FirstName + ' ' + @LastName
END
GO



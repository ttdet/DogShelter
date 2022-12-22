USE [DogShelterDataBase]
GO

/****** Object:  View [dbo].[BRLogDetailFormatted]    Script Date: 5/12/2022 10:36:14 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[BRLogDetailFormatted]
AS
SELECT BR.ID, d.[name] as DogName, d.ID as DogID, [Type], [Note],
FORMAT(CONVERT(datetime, br.[Time]), 'hh\:mm tt') AS [Time],
		FORMAT(br.[Date], 'MM/dd/yyyy') AS [Date]
FROM BRLog as BR 
JOIN Dog d on BR.DogID = d.ID


GO



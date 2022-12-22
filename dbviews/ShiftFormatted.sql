USE [DogShelterDataBase]
GO

/****** Object:  View [dbo].[ShiftFormatted]    Script Date: 5/12/2022 10:37:37 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[ShiftFormatted]
AS
SELECT ID, FORMAT(CONVERT(datetime, [StartTime]), 'hh\:mm tt') AS [StartTime],
		FORMAT([Date], 'MM/dd/yyyy') AS [Date], Span, TODO, Note
FROM [Shift]
GO



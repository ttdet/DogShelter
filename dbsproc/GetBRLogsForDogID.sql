USE [DogShelterDataBase]
GO

/****** Object:  StoredProcedure [dbo].[GetBRLogsForDogID]    Script Date: 5/12/2022 10:30:39 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Grant Giles
-- Create date: 4/27/2022
-- Description:	Get all bathroom logs for a given dog ID
-- =============================================
CREATE PROCEDURE [dbo].[GetBRLogsForDogID] (
	@dID int
)
AS
BEGIN

	IF (@dID IS NULL)
	BEGIN
		RAISERROR('dID cannot be null', 14, 1)
		RETURN 1;
	END

	SELECT BRLog.ID AS ID, Dog.ID AS DogID,
			FORMAT(CONVERT(datetime, [Time]), 'hh\:mm tt') AS [Time],
			FORMAT([Date], 'MM/dd/yyyy') AS [Date],
			[Type], Note, [Name]
	FROM BRLog
	JOIN Dog ON BRLog.DogID = Dog.ID
	WHERE BRLog.DogID = @dID
	ORDER BY [Date] DESC, [Time] DESC

	RETURN 0

END
GO



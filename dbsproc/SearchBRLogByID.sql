USE [DogShelterDataBase]
GO

/****** Object:  StoredProcedure [dbo].[SearchBRLogByID]    Script Date: 5/12/2022 10:29:58 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Grant Giles
-- Create date: 4/28/2022
-- Description:	Get the bathroom log with the given ID
-- =============================================
CREATE PROCEDURE [dbo].[SearchBRLogByID] (
	@id int
)
AS
BEGIN
IF @id IS NULL
BEGIN
	RAISERROR('Must supply an id', 14, 1)
	RETURN 1
END

SELECT BRLog.ID AS ID, Dog.ID AS DogID, [Time], [Date], [Type], Note, [Name]
FROM BRLog
JOIN Dog ON BRLog.DogID = Dog.ID
WHERE BRLog.ID = @id

RETURN 0
END
GO



USE [DogShelterDataBase]
GO

/****** Object:  StoredProcedure [dbo].[GetMedPlansForDogID]    Script Date: 5/12/2022 10:30:22 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Grant Giles
-- Create date: 5/09/2022
-- Description:	Get all med plans for a given dog ID
-- =============================================
CREATE   PROCEDURE [dbo].[GetMedPlansForDogID] (
	@DogID int
)
AS
BEGIN
IF @DogID IS NULL
BEGIN
	RAISERROR('Must supply an id', 14, 1)
	RETURN 1
END

SELECT *
FROM [MedPlanDetailFormatted]
WHERE MedPlanDetailFormatted.DogID = @DogID

RETURN 0
END
GO



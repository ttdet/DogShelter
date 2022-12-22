USE [DogShelterDataBase]
GO

/****** Object:  StoredProcedure [dbo].[SearchMealLogByDogID]    Script Date: 5/12/2022 10:28:49 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SearchMealLogByDogID]
(
	@DogID int = null
)
AS
BEGIN
	IF (@DogID is null)
	BEGIN
		SELECT * FROM MealLogDetailFormatted ORDER BY [Date] DESC, [TIME] ASC
		RETURN 0;
	END
	ELSE
	BEGIN
		SELECT * FROM MealLogDetailFormatted WHERE DogID = @DogID ORDER BY [Date] DESC, [TIME] ASC
		RETURN 0;
	END
END
GO



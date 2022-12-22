USE [DogShelterDataBase]
GO

/****** Object:  StoredProcedure [dbo].[SearchMealLogByID]    Script Date: 5/12/2022 10:28:37 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SearchMealLogByID]
(
	@ID int = null
)
AS
BEGIN
	IF (@ID is null)
	BEGIN
		SELECT * FROM MealLogDetailFormatted ORDER BY [Date] DESC, [Time] ASC;
		RETURN 0;
	END
	ELSE
	BEGIN
		SELECT * FROM MealLogDetailFormatted WHERE ID = @ID ORDER BY [Date] DESC, [Time] ASC;
		RETURN 0;
	END

END
GO



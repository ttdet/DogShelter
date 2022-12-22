USE [DogShelterDataBase]
GO

/****** Object:  StoredProcedure [dbo].[DeleteFood]    Script Date: 5/12/2022 10:32:40 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[DeleteFood]
	(@FoodID [int])
AS
BEGIN
	--Validates parameters
	IF (@FoodID is null)
	BEGIN
		RAISERROR('FoodID provided is null', 14, 1);
		RETURN 1
	END
	IF (NOT EXISTS (SELECT * FROM [Food] WHERE [ID] = @FoodID))
	BEGIN
		RAISERROR('Provided FoodID does not exist.', 14, 1);
		RETURN 2
	END

	DELETE [Food]
	WHERE ( [ID] = @FoodID)
END
GO



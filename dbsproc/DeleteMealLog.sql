USE [DogShelterDataBase]
GO

/****** Object:  StoredProcedure [dbo].[DeleteMealLog]    Script Date: 5/12/2022 10:32:11 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[DeleteMealLog]
( @MealLogID int )
AS 
BEGIN
	if (@MealLogID is null)
	BEGIN
		RAISERROR('meal log id cannot be null', 14, 1);
		RETURN 1;
	END

	if (not exists(SELECT * FROM MealLog WHERE MealLogID = @MealLogID))
	BEGIN
		RAISERROR('Meal log does not exist', 14, 2);
		RETURN 2;
	END

	DECLARE @amt decimal(4,1)
	SET @amt = (SELECT Amount FROM MealLog WHERE MealLogId = @MealLogID)
	DECLARE @foodID int
	SET @foodID = (SELECT FoodID from MealLog WHERE MealLogId = @MealLogID)
	DECLARE @oldStock decimal(4,1)
	SET @oldStock = (SELECT Stock FROM Food WHERE ID = @foodID)
	UPDATE Food
	SET Stock = @oldStock + @amt
	WHERE ID = @foodID

	DELETE FROM MealLog
	WHERE MealLogID = @MealLogID

	RETURN 0
END
GO



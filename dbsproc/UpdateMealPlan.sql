USE [DogShelterDataBase]
GO

/****** Object:  StoredProcedure [dbo].[UpdateMealPlan]    Script Date: 5/12/2022 10:25:41 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[UpdateMealPlan]
	(@FoodPlanID int,
	@DogID int,
	@FoodID int,
	@Amount int = null,
	@SpecialInstruction varchar(200) = null
	)
AS
BEGIN
	--Validates parameters
	if (@FoodPlanID is null or NOT EXISTS (SELECT * FROM [FoodPlan] WHERE [ID] = @FoodPlanID))
	BEGIN
		RAISERROR('invalid meal plan ID.', 14, 1);
		RETURN 1
	END

	if (@FoodID is null or not exists(SELECT * FROM Food WHERE ID = @FoodID))
	BEGIN
		RAISERROR('invalid food id.', 14, 3);
		RETURN 3;
	END

	if (@DogID is null or not exists(SELECT * FROM Dog WHERE ID = @DogID))
	BEGIN
		RAISERROR('invalid dog id.', 14, 4);
		RETURN 4;
	END



	
	UPDATE [FoodPlan]
	SET [Amount] = @Amount, [SpecialInstruction] = @SpecialInstruction, FoodID = @FoodID, DogID = @DogID
	WHERE ([ID] = @FoodPlanID)


END
GO



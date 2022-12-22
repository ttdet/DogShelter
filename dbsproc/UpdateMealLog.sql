USE [DogShelterDataBase]
GO

/****** Object:  StoredProcedure [dbo].[UpdateMealLog]    Script Date: 5/12/2022 10:26:05 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[UpdateMealLog]
(
	--exactly one of name and id has to be provided
	@MealLogID int, 
	@dName varchar(50),  --dog name
	@dId int, -- dog id
	@fName varchar(50), --food name
	@fId int, --food id
	@date varchar(10) = null, --will be converted later
	@time varchar(10) = null, --will be converted later
	@amount varchar(10) = null,
	@Note varchar(100) = null
)
AS

BEGIN
	if (@MealLogID is null or not exists(SELECT * FROM MealLog WHERE MealLogId = @MealLogID))
	BEGIN
		RAISERROR('invalid meal log id', 14, 99);
		RETURN 99;
	END

	if(@dID is null and @dName is null)
	BEGIN
		RAISERROR('dog info needed', 14, 1);
		
		RETURN 1;
	END

	if (@fID is null and @fName is null)
	BEGIN
		RAISERROR('food info needed', 14, 2);
		
		RETURN 2;
	END

	if (@dID is not null and @dName is not null)
	BEGIN
		RAISERROR('Only one of dog ID and dog name needed', 14, 3);
		
		RETURN 3;
	END

	if (@fID is not null and @fName is not null)
	BEGIN 
		RAISERROR('Only one of food ID and food name needed', 14, 4);
		
		RETURN 4;
	END

	--ID value to make the final insertion
	DECLARE @dbDogID int = null;

	--dName is provided. dID is null
	if (@dName is not null)
	BEGIN
		--No dog with given name
		if (not exists(SELECT * FROM Dog WHERE [name] = @dName))
		BEGIN
			RAISERROR('dog does not exist', 14, 5);
			
			RETURN 5;
		END
		--More than one dog with the given name
		else if (not exists(SELECT [Name] FROM Dog WHERE [name] = @dName GROUP BY [name] HAVING count(*) = 1))
		BEGIN
			RAISERROR('there is more than one dog with the given name.', 14, 6);
			
			RETURN 6;
		END
		--The dog name is valid
		else
		BEGIN
			SET @dbDogID = (SELECT ID FROM Dog WHERE [Name] = @dName)
		END
	END


	--Dog Id is provided. Name is null.
	else if (@dId is not null)
	BEGIN
		if(not exists(SELECT * FROM Dog WHERE ID = @dId))
		BEGIN
			RAISERROR('the given dog ID does not exist.', 14, 7);
			
			RETURN 7;
		END
		else 
		BEGIN
			SET @dbDogID = @dId
		END
	END

	--ID value to make the final insertion
	DECLARE @newFoodID int = null;

	--fName is provided. fID is null
	if (@fName is not null)
	BEGIN
		--No food with given name
		if (not exists(SELECT * FROM Food WHERE [name] = @fName))
		BEGIN
			RAISERROR('food name does not exist', 14, 8);
			
			RETURN 8;
		END
		--More than one food with the given name
		else if (not exists(SELECT [Name] FROM Food WHERE [name] = @fName GROUP BY [name] HAVING count(*) = 1))
		BEGIN
			RAISERROR('there is more than one food with the given name.', 14, 9);
			
			RETURN 9;
		END
		--The food name is valid
		else
		BEGIN
			SET @newFoodID = (SELECT ID FROM food WHERE [Name] = @fName)
		END
	END


	--Food Id is provided. Name is null.
	else if (@fId is not null)
	BEGIN
		if(not exists(SELECT * FROM Food WHERE ID = @fId))
		BEGIN
			RAISERROR('the given food ID does not exist.', 14, 10);
			
			RETURN 10;
		END
		else 
		BEGIN
			SET @newFoodID = @fId
		END
	END

	DECLARE @convDate Date
	DECLARE @convTime time(0)

	if (@date is null)
	BEGIN
		SET @convDate = convert(date, GETDATE())
	END
	else 
	BEGIN
		SET @convDate = Try_Convert(Date, @date)
	END

	if (@time is null)
	BEGIN 
		SET @convTime = convert(time(0), convert(varchar(5), (convert(time(0), GETDATE()))))
	END
	else
	BEGIN
		SET @convTime = Try_Convert(time(0), @time)
	END


	if (@convDate is null) 
	BEGIN
		RAISERROR('Invalid date', 14, 85);
		RETURN 85;
	END

	if (@convTime is null) 
	BEGIN
		RAISERROR('Invalid time', 14, 86);
		RETURN 86;
	END

	DECLARE @oldAmt decimal(4,1)
	SET @oldAmt = (SELECT Amount FROM MealLog WHERE MealLogID = @MealLogID)

	DECLARE @newStock decimal(4,1)
	DECLARE @newFoodCurrStock decimal(4,1)
	DECLARE @oldFoodID int
	DECLARE @oldFoodCurrStock decimal(4,1)
	SET @oldFoodID = (SELECT FoodID FROM MealLog WHERE MealLogID = @MealLogID)
	SET @oldFoodCurrStock = (SELECT stock FROM Food WHERE ID = @oldFoodID)
	SET @newFoodCurrStock = (SELECT stock FROM Food WHERE ID = @newFoodID)
	
	if (@oldFoodID = @newFoodID) 
	BEGIN
		SET @newStock = @newFoodCurrStock + @oldAmt - @amount

		if (@newStock < 0) 
		BEGIN
			RAISERROR('Not enough item in stock', 14, 67);
			RETURN 67;
		END

		UPDATE Food SET Stock = @newStock WHERE ID = @newFoodID
	END
	ELSE 
	BEGIN
		SET @newStock = @newFoodCurrStock - @amount

		if (@newStock < 0) 
		BEGIN
			RAISERROR('Not enough item in stock', 14, 67);
			RETURN 67;
		END

		UPDATE Food SET Stock = @oldFoodCurrStock + @oldAmt WHERE ID = @oldFoodID
		UPDATE Food SET Stock = @newFoodCurrStock - @amount WHERE ID = @newFoodID
	END
		

	UPDATE MealLog
	SET DogID = @dbDogID, FoodID = @newFoodID, [Date] = @convDate, [Time] = @convTime, Amount = @amount, Note = @Note
	WHERE MealLogID = @MealLogID


	RETURN 0;

END
GO



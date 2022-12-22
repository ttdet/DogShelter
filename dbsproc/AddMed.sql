USE [DogShelterDataBase]
GO

/****** Object:  StoredProcedure [dbo].[AddMed]    Script Date: 5/12/2022 10:34:42 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[AddMed]
(
	@name varchar(50),
	@direction varchar(500) = null,
	@neededFor varchar(200) = null,
	@boughtFrom varchar(50) = null,
	@stock decimal(4,1) = 0
)
AS 
BEGIN
	if (@name is null) 
	BEGIN
		RAISERROR('name cannot be null.', 14, 1);
		
		RETURN 1;
	END

	if (@stock is not null and @stock < 0)
	BEGIN 
		RAISERROR('stock must not be negative.', 14, 2);
		
		RETURN 2;
	END

	INSERT INTO Medicine
	([Name], Directions, neededFor, boughtFrom, Stock)
	Values(@name, @direction, @neededFor, @boughtFrom, @stock)

	SELECT * FROM [Medicine] WHERE ID = @@IDENTITY;
	RETURN 0;

END
	
GO



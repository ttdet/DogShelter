USE [DogShelterDataBase]
GO

/****** Object:  StoredProcedure [dbo].[UpdateMed]    Script Date: 5/12/2022 10:25:31 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[UpdateMed]
	(
	@ID int,
	@name varchar(50),
	@directions varchar(500) = null,
	@neededFor varchar(200) = null,
	@boughtFrom varchar(50) = null,
	@stock int = 0
	)
AS
BEGIN

	if (@ID is null or not exists(SELECT * FROM Medicine WHERE ID = @ID)) 
	BEGIN
		RAISERROR('invalid ID', 14, 1);
		RETURN 1;
	END

	if (@name is null)
	BEGIN
		RAISERROR('invalid name', 14, 2);
		RETURN 2;
	END

	
	UPDATE Medicine
	SET [Name] = @Name, Directions = @directions, neededFor = @neededFor, BoughtFrom = @boughtFrom, Stock = @stock
	WHERE ID = @ID
	RETURN 0;

END
GO



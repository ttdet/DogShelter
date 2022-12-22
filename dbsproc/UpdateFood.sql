USE [DogShelterDataBase]
GO

/****** Object:  StoredProcedure [dbo].[UpdateFood]    Script Date: 5/12/2022 10:26:37 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   PROCEDURE [dbo].[UpdateFood] 
(
	@ID int,
	@name nvarchar(50),
	@Instructions nvarchar(500) = null,
	@boughtFrom nvarchar(50) = null,
	@Stock decimal(4,1) = 0
)
AS 
BEGIN
	if (@ID is null or not exists(SELECT * FROM Food WHERE ID = @ID))
	BEGIN
		RAISERROR('invalid food id', 14, 98);
		RETURN 98;
	END
		
	IF(@name is null)
	BEGIN
		RAISERROR('name cannot be null', 14, 1);
		
		RETURN 1;
	END

	IF(@Stock is not null and @stock < 0)
	BEGIN
		RAISERROR('stock must not be negative', 14, 2);
		
		RETURN 2;
	END

	UPDATE Food
	SET [Name] = @name, Instructions = @Instructions, boughtFrom = @boughtFrom, Stock = @Stock
	WHERE ID = @ID
	RETURN 0;

END

GO



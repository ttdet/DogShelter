USE [DogShelterDataBase]
GO

/****** Object:  StoredProcedure [dbo].[AddFood]    Script Date: 5/12/2022 10:35:14 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   PROCEDURE [dbo].[AddFood] 
(
	@name nvarchar(50),
	@Instructions nvarchar(500) = null,
	@boughtFrom nvarchar(50) = null,
	@Stock decimal(4,1) = 0
)
AS 
BEGIN
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

	INSERT INTO Food
	(Name, Instructions, boughtFrom, Stock)
	Values(@name, @Instructions, @boughtFrom, @Stock)

	SELECT * FROM [Food] WHERE ID = @@IDENTITY;

	RETURN 0;
END

GO



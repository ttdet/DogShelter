USE [DogShelterDataBase]
GO

/****** Object:  StoredProcedure [dbo].[SearchFoodByID]    Script Date: 5/12/2022 10:29:16 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SearchFoodByID]
(
	@ID int = null
)
AS
BEGIN
	IF (@ID is null)
	BEGIN
		SELECT * FROM Food ORDER BY [Name] ASC;
		RETURN 0;
	END
	ELSE
	BEGIN
		SELECT * FROM Food WHERE ID = @ID
		RETURN 0;
	END

END
GO



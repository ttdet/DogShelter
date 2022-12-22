USE [DogShelterDataBase]
GO

/****** Object:  StoredProcedure [dbo].[SearchDogByID]    Script Date: 5/12/2022 10:29:41 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SearchDogByID]
(
	@ID int = null
)
AS 
BEGIN
	IF (@ID is null)
	BEGIN
		SELECT * FROM Dog;
		RETURN 0;
	END
	ELSE
	BEGIN
		SELECT * FROM Dog WHERE ID = @ID
		RETURN 0;
	END
END
GO



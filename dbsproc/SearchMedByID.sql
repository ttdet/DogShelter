USE [DogShelterDataBase]
GO

/****** Object:  StoredProcedure [dbo].[SearchMedByID]    Script Date: 5/12/2022 10:28:22 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SearchMedByID]
(
	@ID int = null
)
AS
BEGIN
	IF (@ID is null)
	BEGIN
		SELECT * FROM Medicine ORDER BY [Name] ASC;
		RETURN 0;
	END
	ELSE
	BEGIN
		SELECT * FROM Medicine WHERE ID = @ID ORDER BY [Name] ASC;
		RETURN 0;
	END

END
GO



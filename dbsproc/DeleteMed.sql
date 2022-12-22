USE [DogShelterDataBase]
GO

/****** Object:  StoredProcedure [dbo].[DeleteMed]    Script Date: 5/12/2022 10:32:01 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[DeleteMed]
	(@MedID [int])
AS
BEGIN
	--Validates parameters
	IF (@MedID is null)
	BEGIN
		RAISERROR('MedID provided is null', 14, 1);
		RETURN 1
	END
	IF (NOT EXISTS (SELECT * FROM [Medicine] WHERE [ID] = @MedID))
	BEGIN
		RAISERROR('Provided MedID does not exist.', 14, 1);
		RETURN 2
	END

	DELETE [Medicine]
	WHERE ( [ID] = @MedID)
END
GO



USE [DogShelterDataBase]
GO

/****** Object:  StoredProcedure [dbo].[DeleteDog]    Script Date: 5/12/2022 10:32:49 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[DeleteDog]
	(@DogID [int])
AS
BEGIN
	--Validates parameters
	IF (@DogID is null)
	BEGIN
		RAISERROR('DogID provided is null', 14, 1);
		RETURN 1
	END
	IF (NOT EXISTS (SELECT * FROM [Dog] WHERE [ID] = @DogID))
	BEGIN
		RAISERROR('Provided DogID does not exist.', 14, 1);
		RETURN 2
	END

	DELETE FROM [Dog]
	WHERE ( [ID] = @DogID)
END
GO



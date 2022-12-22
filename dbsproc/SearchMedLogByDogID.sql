USE [DogShelterDataBase]
GO

/****** Object:  StoredProcedure [dbo].[SearchMedLogByDogID]    Script Date: 5/12/2022 10:28:01 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SearchMedLogByDogID]
(
	@DogID int = null
)
AS
BEGIN
	IF (@DogID is null)
	BEGIN
		SELECT * FROM MedLogDetailFormatted ORDER BY [Date] DESC, [TIME] ASC
		RETURN 0;
	END
	ELSE
	BEGIN
		SELECT * FROM MedLogDetailFormatted WHERE DogID = @DogID 
		RETURN 0;
	END
END
GO



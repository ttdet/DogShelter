USE [DogShelterDataBase]
GO

/****** Object:  StoredProcedure [dbo].[SearchMedLogByID]    Script Date: 5/12/2022 10:27:49 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SearchMedLogByID]
(
	@ID int = null
)
AS
BEGIN
	IF (@ID is null)
	BEGIN
		SELECT * FROM MedLogDetailFormatted ORDER BY [Date] DESC, [TIME] ASC
		RETURN 0;
	END
	ELSE
	BEGIN
		SELECT * FROM MedLogDetailFormatted WHERE ID = @ID 
		RETURN 0;
	END
END
GO



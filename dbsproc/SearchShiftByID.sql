USE [DogShelterDataBase]
GO

/****** Object:  StoredProcedure [dbo].[SearchShiftByID]    Script Date: 5/12/2022 10:27:38 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SearchShiftByID]
(
	@ID int = null
)
AS
BEGIN
	IF (@ID is null)
	BEGIN
		SELECT * FROM ShiftFormatted ORDER BY [Date] DESC, [StartTime] ASC;
		RETURN 0;
	END
	ELSE
	BEGIN
		SELECT * FROM ShiftFormatted WHERE ID = @ID ORDER BY [Date] DESC, [StartTime] ASC;
		RETURN 0;
	END

END
GO



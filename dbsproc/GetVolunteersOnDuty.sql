USE [DogShelterDataBase]
GO

/****** Object:  StoredProcedure [dbo].[GetVolunteersOnDuty]    Script Date: 5/12/2022 10:30:11 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetVolunteersOnDuty]
(
	@ID int = null
)
AS
BEGIN
	IF (@ID is null)
	BEGIN
		SELECT * FROM OnDutyDetailFormatted ORDER BY [Date] DESC, [StartTime] ASC;
		RETURN 0;
	END
	ELSE
	BEGIN
		SELECT * FROM OnDutyDetailFormatted WHERE ShiftID = @ID;
		RETURN 0;
	END

END
GO



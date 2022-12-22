USE [DogShelterDataBase]
GO

/****** Object:  StoredProcedure [dbo].[DeleteShift]    Script Date: 5/12/2022 10:31:21 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[DeleteShift]
	(@ShiftID [int])
AS
BEGIN
	--Validates parameters
	IF (@ShiftID is null)
	BEGIN
		RAISERROR('VolunteerID provided is null', 14, 1);
		RETURN 1
	END
	IF (NOT EXISTS (SELECT * FROM [Shift] WHERE [ID] = @ShiftID))
	BEGIN
		RAISERROR('Provided ShiftID does not exist.', 14, 1);
		RETURN 2
	END

	DELETE [Shift]
	WHERE ( [ID] = @ShiftID)
END
GO



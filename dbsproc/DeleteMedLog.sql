USE [DogShelterDataBase]
GO

/****** Object:  StoredProcedure [dbo].[DeleteMedLog]    Script Date: 5/12/2022 10:31:51 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE     PROCEDURE [dbo].[DeleteMedLog]
( @MedLogID int )
AS 
BEGIN
	if (@MedLogID is null)
	BEGIN
		RAISERROR('med log id cannot be null', 14, 1);
		RETURN 1;
	END

	if (not exists(SELECT * FROM MedLog WHERE MedLogID = @MedLogID))
	BEGIN
		RAISERROR('Med log does not exist', 14, 2);
		RETURN 2;
	END

	DECLARE @amt decimal(4,1)
	SET @amt = (SELECT Amount FROM MedLog WHERE MedLogId = @MedLogID)
	DECLARE @medID int
	SET @medID = (SELECT MedID from MedLog WHERE MedLogId = @MedLogID)
	DECLARE @oldStock decimal(4,1)
	SET @oldStock = (SELECT Stock FROM Medicine WHERE ID = @medID)
	UPDATE Medicine
	SET Stock = @oldStock + @amt
	WHERE ID = @medID

	DELETE FROM MedLog
	WHERE MedLogID = @MedLogID

	RETURN 0
END
GO



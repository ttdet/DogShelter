USE [DogShelterDataBase]
GO

/****** Object:  Trigger [dbo].[OneShiftLeader]    Script Date: 5/12/2022 10:39:10 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[OneShiftLeader] ON [dbo].[OnDuty]
AFTER INSERT, UPDATE
AS
BEGIN
	
	--more than one leader for some shift
	if (exists(SELECT ShiftID FROM Inserted WHERE isShiftLeader = 1 GROUP BY [ShiftID], [isShiftLeader] HAVING Count(*) > 1))
	BEGIN
		RAISERROR('One shift can only have one leader', 14, 11);
		ROLLBACK TRANSACTION
	END

	
	UPDATE OnDuty
	SET isShiftLeader = 0
	FROM OnDuty o JOIN Inserted i on o.ShiftID = i.ShiftID and i.OnDutyID <> o.OnDutyID
	WHERE i.isShiftLeader = 1



END
GO

ALTER TABLE [dbo].[OnDuty] ENABLE TRIGGER [OneShiftLeader]
GO



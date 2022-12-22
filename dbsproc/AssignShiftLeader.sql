USE [DogShelterDataBase]
GO

/****** Object:  StoredProcedure [dbo].[assignShiftLeader]    Script Date: 5/12/2022 10:33:32 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[assignShiftLeader]
(
	@OnDutyID int
)
AS
BEGIN

	if (@OnDutyID is null)
	BEGIN
		RAISERROR('Record ID cannot be null', 14, 1);
		RETURN 1;
	END

	if (not exists(SELECT * FROM OnDuty WHERE OnDutyID = @OnDutyID))
	BEGIN
		RAISERROR('Record not found', 14, 2);
		RETURN 2;
	END

	UPDATE OnDuty
	SET isShiftLeader = 1
	WHERE OnDutyID = @OnDutyID

	RETURN 0;

END
GO



USE [DogShelterDataBase]
GO

/****** Object:  StoredProcedure [dbo].[UpdateOnDuty]    Script Date: 5/12/2022 10:24:59 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[UpdateOnDuty]
(
	--For Volunteer, accepted parameter forms are : FirstName || LastName || FirstName and LastName || ID
	--For Shift, Accepted parameter forms are:  shiftID || ShiftDate || ShiftStartTime and ShiftDate
	@OnDutyID int,
	@isLeader bit
)
AS 
BEGIN
	
	IF (@OnDutyID is null)
	BEGIN
		RAISERROR('OnDutyID invalid', 14, 2);
		RETURN 2;
	END


	IF (@isLeader is null)
	BEGIN
		RAISERROR('please specify if the volunteer is leader or not', 14, 8);
		RETURN 8;
	END

	if (not exists(SELECT * FROM OnDuty WHERE OnDutyID = @OnDutyID))
	BEGIN
		RAISERROR('record does not exist', 14, 7);
		RETURN 7;
	END



	UPDATE OnDuty
	SET isShiftLeader = @isLeader
	WHERE OnDutyID = @OnDutyID

	SELECT * FROM OnDuty WHERE OnDutyID = @OnDutyID
	RETURN 0;



END

GO



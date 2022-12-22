USE [DogShelterDataBase]
GO

/****** Object:  StoredProcedure [dbo].[DeleteOnDuty]    Script Date: 5/12/2022 10:31:30 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[DeleteOnDuty]
	(
	@OnDutyID int
	)
AS
BEGIN
	--Validates parameters
	IF (@OnDutyID is null)
	BEGIN
		RAISERROR('ID provided is null', 14, 1);
		RETURN 1
	END

	IF (NOT EXISTS (SELECT * FROM [OnDuty] WHERE OnDutyID = @OnDutyID))
	BEGIN
		RAISERROR('No matching record found', 14, 2);
		RETURN 2;
	END

	DELETE [OnDuty]
	WHERE ( OnDutyID = @OnDutyID )
END
GO



USE [DogShelterDataBase]
GO

/****** Object:  StoredProcedure [dbo].[DeleteMedPlan]    Script Date: 5/12/2022 10:31:39 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[DeleteMedPlan]
	(@MedPlanID [int])
AS
BEGIN
	--Validates parameters
	IF (@MedPlanID is null)
	BEGIN
		RAISERROR('MedPlanID provided is null', 14, 1);
		RETURN 1
	END
	IF (NOT EXISTS (SELECT * FROM [MedPlan] WHERE [MedPlanID] = @MedPlanID))
	BEGIN
		RAISERROR('Provided MedPlanID does not exist.', 14, 1);
		RETURN 2
	END

	DELETE FROM [MedPlan]
	WHERE ( [MedPlanID] = @MedPlanID)
END
GO



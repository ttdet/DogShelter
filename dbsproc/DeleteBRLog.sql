USE [DogShelterDataBase]
GO

/****** Object:  StoredProcedure [dbo].[DeleteBRLog]    Script Date: 5/12/2022 10:33:00 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[DeleteBRLog]
(
	@ID int
)
AS
BEGIN
	if (@ID is null or not exists(SELECT * FROM BRLog WHERE ID = @ID))
	BEGIN
		RAISERROR('invalid bathroom log id', 14, 1);
		RETURN 1;
	END
	
	DELETE FROM BRLog
	WHERE ID = @ID
	RETURN 0;
END
GO



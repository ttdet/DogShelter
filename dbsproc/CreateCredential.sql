USE [DogShelterDataBase]
GO

/****** Object:  StoredProcedure [dbo].[CreateCredential]    Script Date: 5/12/2022 10:33:20 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CreateCredential]
(
	@username varchar(8),
	@encPW varchar(100),
	@key varchar(32)
) 
AS
BEGIN
	if (@username is null or @encPW is null or @key is null) 
	BEGIN
		RAISERROR('parameters cannot be null', 14, 1);
		RETURN 1;
	END

	if (exists (SELECT * FROM [Login] WHERE username = @username))
	BEGIN
		RAISERROR('username already exists', 14, 2);
		RETURN 2;
	END

	INSERT INTO [Login]
	VALUES(@username, @encPW, @key)
	RETURN 0;
END
GO



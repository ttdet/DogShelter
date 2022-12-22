USE [DogShelterDataBase]
GO

/****** Object:  StoredProcedure [dbo].[ApplyDogFilter]    Script Date: 5/12/2022 10:35:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ApplyDogFilter]
(
	@Sex varchar(20),
	@Breed varchar(50) = null,
	@MinAge int = null,
	@MaxAge int = null
)
AS
BEGIN
	DECLARE @temp TABLE ( [ID] [int] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[WeightInlbs] [int] NULL,
	[hasBeenSpayed] [bit] NULL,
	[DateOfBirth] [date] NULL,
	[Sex] [varchar](20) NULL,
	[Breed] [varchar](50) NULL,
	[Information] [varchar](500) NULL,
	[GeneralInstruction] [varchar](500) NULL,
	[Age] int,
	[FeedInstruction] [varchar](500) NULL);
	INSERT INTO @temp 
	(ID, [Name], WeightInlbs, hasBeenSpayed, DateOfBirth, Sex, Breed, Information, GeneralInstruction, Age, FeedInstruction)
	SELECT * FROM Dog
	if (@Sex is null)
	BEGIN
		RAISERROR('must declare sex', 14, 1);
		RETURN 1;
	END
	if (@Breed is not null) 
	BEGIN
		DELETE FROM @temp 
		WHERE Breed <> @Breed
	END

	if (@MinAge is not null)
	BEGIN
		DELETE FROM @temp
		WHERE Age < @MinAge
	END

	if (@MaxAge is not null)
	BEGIN	
		DELETE FROM @temp
		WHERE Age > @MaxAge
	END

	DELETE FROM @temp WHERE Sex <> @Sex
	
	SELECT * FROM @temp
	RETURN 0;

END
GO



USE [DogShelterDataBase]
GO

/****** Object:  StoredProcedure [dbo].[AddOnDuty]    Script Date: 5/12/2022 10:34:09 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[AddOnDuty]
(
	--For Volunteer, accepted parameter forms are : FirstName || LastName || FirstName and LastName || ID
	--For Shift, Accepted parameter forms are:  shiftID || ShiftDate || ShiftStartTime and ShiftDate
	@vfn varchar(50), --volunteer first name
	@vln varchar(50), --volunteer last name
	@vID int, --volunteer ID
	@sID int,	--shift ID
	@isLeader bit = 0
)
AS 
BEGIN

	if (not exists(SELECT * FROM [Shift] WHERE ID = @sID))
	BEGIN
		RAISERROR('shift does not exist', 14, 2);
		RETURN 2;
	END

	if (@vfn is null and @vln is null and @vID is null)
	BEGIN
		RAISERROR('volunteer info needed', 14, 13);
		
		RETURN 13;
	END
	
	if ((@vfn is not null or @vln is not null) and @vID is not null)
	BEGIN
		RAISERROR('Only one of volunteer ID and volunteer name is needed', 14, 14);
		
		RETURN 14;
	END

	DECLARE @dbVID int = null;

	if(@vID is null)
	BEGIN
		--first name provided
		if (@vfn is not null and @vln is null)
		BEGIN
			if (not exists(SELECT * FROM Volunteer WHERE FirstName = @vfn))
			BEGIN
				RAISERROR('volunteer does not exist', 14, 20);
		
				RETURN 20;
			END
			--More than one volunteer with the given first name
			else if (not exists(SELECT FirstName FROM Volunteer WHERE FirstName = @vfn GROUP BY FirstName HAVING count(*) = 1))
			BEGIN
				RAISERROR('there is more than one volunteer with the given first name.', 14, 21);
		
				RETURN 21;
			END
			--The first name is valid
			else
			BEGIN
				SET @dbVID = (SELECT ID FROM Volunteer WHERE FirstName = @vfn)
			END
		END
		--last name provided
		else if (@vfn is null and @vln is not null)
		BEGIN
			if (not exists(SELECT * FROM Volunteer WHERE LastName = @vln))
			BEGIN
				RAISERROR('volunteer does not exist', 14, 22);
		
				RETURN 22;
			END
			--More than one volunteer with the given last name
			else if (not exists(SELECT LastName FROM Volunteer WHERE LastName = @vln GROUP BY LastName HAVING count(*) = 1))
			BEGIN
				RAISERROR('there is more than one volunteer with the given last name.', 14, 23);
		
				RETURN 23;
			END
			--The last name is valid
			else
			BEGIN
				SET @dbVID = (SELECT ID FROM Volunteer WHERE LastName = @vln)
			END
		END
		--full name provided
		else
		BEGIN
			if (not exists(SELECT * FROM Volunteer WHERE FirstName = @vfn and LastName = @vln))
			BEGIN
				RAISERROR('volunteer does not exist', 14, 24);
		
				RETURN 24;
			END
			--More than one volunteer with the given full name
			else if (not exists(SELECT FirstName FROM Volunteer WHERE FirstName = @vfn and LastName = @vln GROUP BY FirstName, LastName HAVING count(*) = 1))
			BEGIN
				RAISERROR('there is more than one volunteer with the given full name.', 14, 25);
		
				RETURN 25;
			END
			--The full name is valid
			else
			BEGIN
				SET @dbVID = (SELECT ID FROM Volunteer WHERE FirstName = @vfn and LastName = @vln)
			END
		END
	END

	--VID provided, no name
	else if (@vID is not null)
	BEGIN
		if(not exists(SELECT * FROM Volunteer WHERE ID = @vID))
		BEGIN
			RAISERROR('the given volunteer ID does not exist.', 14, 26);
		
			RETURN 26;
		END
		else 
		BEGIN
			SET @dbVID = @vID
		END
	END

	if (exists (SELECT * FROM OnDuty WHERE VolunteerID = @dbVID and ShiftID = @sID ))
	BEGIN	
		RAISERROR('The record already exists', 14, 95);
		RETURN 95;
	END

	--forcibly make the volunteer shift leader
	if (not exists (SELECT * FROM OnDuty WHERE isShiftLeader = 1 and ShiftID = @sID) and @isLeader = 0)
	BEGIN
		INSERT INTO OnDuty
		(VolunteerID, ShiftID, isShiftLeader)
		Values(@dbVID, @sID, 1)

		SELECT * FROM OnDutyDetailFormatted WHERE ID = @@IDENTITY
		RETURN 99;
	END

	if (@isLeader = 1)
	BEGIN	
		UPDATE OnDuty
		SET isShiftLeader = 0
		WHERE ShiftID = @sID
	END

	INSERT INTO OnDuty
	(VolunteerID, ShiftID, isShiftLeader)
	Values(@dbVID, @sID, @isLeader)

	SELECT * FROM OnDutyDetailFormatted WHERE ID = @@IDENTITY
	
	RETURN 0;



END

GO



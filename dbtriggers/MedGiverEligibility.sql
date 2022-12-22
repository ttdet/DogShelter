CREATE TRIGGER MedGiverEligibility
ON MedLog
AFTER INSERT, UPDATE
AS
BEGIN
	IF (EXISTS (SELECT * FROM Inserted i 
				JOIN Volunteer v on i.VolunteerID = v.ID
				WHERE v.CanGiveMed = 0))
	BEGIN
		RAISERROR('Only volunteers who can give med can be added to the med log', 14, 1);
		ROLLBACK TRANSACTION
	END
END 
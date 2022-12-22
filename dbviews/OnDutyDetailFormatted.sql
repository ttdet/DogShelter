USE [DogShelterDataBase]
GO

/****** Object:  View [dbo].[OnDutyDetailFormatted]    Script Date: 5/12/2022 10:37:26 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[OnDutyDetailFormatted]
AS 
SELECT [OnDuty].OnDutyID as ID,
	dbo.[formatName](v.[Firstname], v.[LastName]) as VolunteerName, v.ID as VolunteerID,
	FORMAT(dbo.Shift.Date, 'MM/dd/yyyy') AS [Date], 
	FORMAT(CONVERT(datetime, dbo.[Shift].[StartTime]), 'hh\:mm tt') AS [StartTime], [Shift].Span, 
	[Shift].ID as ShiftID, isShiftLeader
FROM Volunteer v 
JOIN OnDuty on v.ID = OnDuty.VolunteerID
JOIN [Shift] on Onduty.ShiftID = [Shift].ID

GO



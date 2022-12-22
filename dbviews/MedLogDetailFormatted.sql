USE [DogShelterDataBase]
GO

/****** Object:  View [dbo].[MedLogDetailFormatted]    Script Date: 5/12/2022 10:36:59 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[MedLogDetailFormatted]
AS
SELECT dbo.MedLog.MedLogID as ID, d.Name AS DogName, d.ID as DogID, 
			dbo.formatName(v.FirstName, v.LastName) AS VolunteerName, v.ID as VolunteerID,
			m.Name AS MedName, m.ID as MedID,
            dbo.MedLog.Amount, dbo.MedLog.Note,
			FORMAT(CONVERT(datetime, dbo.MedLog.[Time]), 'hh\:mm tt') AS [Time],
			FORMAT(dbo.MedLog.[Date], 'MM/dd/yyyy') AS [Date]
FROM   dbo.Dog AS d INNER JOIN
             dbo.MedLog ON d.ID = dbo.MedLog.DogID INNER JOIN
             dbo.Volunteer AS v ON dbo.MedLog.VolunteerID = v.ID INNER JOIN
             dbo.Medicine AS m ON dbo.MedLog.MedID = m.ID
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "d"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 185
               Right = 281
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "MedLog"
            Begin Extent = 
               Top = 189
               Left = 48
               Bottom = 367
               Right = 257
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "v"
            Begin Extent = 
               Top = 371
               Left = 48
               Bottom = 549
               Right = 257
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "m"
            Begin Extent = 
               Top = 553
               Left = 48
               Bottom = 731
               Right = 257
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1176
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1356
         SortOrder = 1416
         GroupBy = 1350
         Filter = 1356
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'MedLogDetailFormatted'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'MedLogDetailFormatted'
GO



CREATE DATABASE [${DBNAME}]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'${DBNAME}_dat', FILENAME = N'D:\Database\MSSQL15.MSSQLSERVER\MSSQL\DATA\${DBNAME}_dat.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'${DBNAME}_log', FILENAME = N'D:\Database\MSSQL15.MSSQLSERVER\MSSQL\DATA\${DBNAME}_log.ldf' , SIZE = 73728KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [${DBNAME}] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [${DBNAME}].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [${DBNAME}] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [${DBNAME}] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [${DBNAME}] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [${DBNAME}] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [${DBNAME}] SET ARITHABORT OFF 
GO
ALTER DATABASE [${DBNAME}] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [${DBNAME}] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [${DBNAME}] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [${DBNAME}] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [${DBNAME}] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [${DBNAME}] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [${DBNAME}] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [${DBNAME}] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [${DBNAME}] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [${DBNAME}] SET  ENABLE_BROKER 
GO
ALTER DATABASE [${DBNAME}] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [${DBNAME}] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [${DBNAME}] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [${DBNAME}] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [${DBNAME}] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [${DBNAME}] SET RECOVERY FULL 
GO
ALTER DATABASE [${DBNAME}] SET  MULTI_USER 
GO
ALTER DATABASE [${DBNAME}] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [${DBNAME}] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [${DBNAME}] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [${DBNAME}] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [${DBNAME}] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'${DBNAME}', N'ON'
GO
ALTER DATABASE [${DBNAME}] SET QUERY_STORE = OFF
GO

USE [${DBNAME}]
GO

CREATE USER [regularV] FOR LOGIN [nonMedicVolunteer] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [regularV]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [regularV]
GO
GRANT EXEC TO [regularV]
GO
/****** Object:  UserDefinedFunction [dbo].[formatName]    Script Date: 5/18/2022 1:48:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
CREATE MedLogByName
AS
SELECT d.[name] as dog, v.[name] as volunteer, m.[name] as med, 
	[Date], [Time], Amount, Note
FROM Dog d 
JOIN MedLog on d.ID = MedLog.DogID
JOIN Volunteer v on MedLog.VolunteerID = v.ID
*/

CREATE function [dbo].[formatName]
(
	@FirstName nvarchar(50),
	@LastName nvarchar(50)
)
RETURNS nvarchar(100)
AS
BEGIN
	RETURN @FirstName + ' ' + @LastName
END
GO
/****** Object:  Table [dbo].[Dog]    Script Date: 5/18/2022 1:48:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Dog](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[WeightInlbs] [int] NULL,
	[hasBeenSpayed] [bit] NULL,
	[DateOfBirth] [date] NULL,
	[Sex] [varchar](20) NULL,
	[Breed] [varchar](50) NULL,
	[Information] [varchar](500) NULL,
	[GeneralInstruction] [varchar](500) NULL,
	[Age]  AS (datediff(month,[DateOfBirth],getdate())/(12)),
	[FeedInstruction] [varchar](500) NULL,
 CONSTRAINT [PK__DOG__3214EC27E5A39F4A] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_search_dog]    Script Date: 5/18/2022 1:48:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fn_search_dog] (@name_search nvarchar(50))
RETURNS table
AS
RETURN (
	SELECT *
	FROM Dog
	WHERE CHARINDEX(@name_search, Dog.Name) != 0
)
GO
/****** Object:  Table [dbo].[Volunteer]    Script Date: 5/18/2022 1:48:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Volunteer](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [varchar](50) NOT NULL,
	[LastName] [varchar](50) NOT NULL,
	[DateOfBirth] [date] NULL,
	[Sex] [varchar](20) NULL,
	[MemberSince] [date] NULL,
	[Age]  AS (datediff(month,[DateOfBirth],getdate())/(12)),
	[CanGiveMed] [bit] NOT NULL,
	[ServicesEndOn] [date] NULL,
 CONSTRAINT [PK__Voluntee__3214EC273CFA6103] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_search_volunteer]    Script Date: 5/18/2022 1:48:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[fn_search_volunteer] (@name_search nvarchar(50))
RETURNS table
AS
RETURN (
	SELECT *
	FROM Volunteer
	WHERE CHARINDEX(@name_search, Volunteer.FirstName) != 0 OR CHARINDEX(@name_search, Volunteer.LastName) != 0
)
GO
/****** Object:  Table [dbo].[MealLog]    Script Date: 5/18/2022 1:48:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MealLog](
	[MealLogID] [int] IDENTITY(1,1) NOT NULL,
	[DogID] [int] NOT NULL,
	[FoodID] [int] NOT NULL,
	[Date] [date] NOT NULL,
	[Time] [time](0) NOT NULL,
	[Amount] [decimal](4, 1) NOT NULL,
	[Note] [varchar](100) NULL,
 CONSTRAINT [PK_MealLog] PRIMARY KEY CLUSTERED 
(
	[MealLogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [MealLogCheckUnique] UNIQUE NONCLUSTERED 
(
	[DogID] ASC,
	[FoodID] ASC,
	[Date] ASC,
	[Time] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Food]    Script Date: 5/18/2022 1:48:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Food](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Instructions] [varchar](500) NULL,
	[boughtFrom] [varchar](50) NULL,
	[Stock] [decimal](4, 1) NULL,
	[UnitPerStock] [varchar](10) NULL,
 CONSTRAINT [PK__Food__3214EC27751B97A4] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[MealLogDetailFormatted]    Script Date: 5/18/2022 1:48:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[MealLogDetailFormatted]
AS
SELECT m.MealLogID as ID, d.ID as DogID, d.Name AS DogName, 
		f.ID as FoodID, f.Name AS FoodName, 
		FORMAT(CONVERT(datetime, m.[Time]), 'hh\:mm tt') AS [Time],
		FORMAT(m.[Date], 'MM/dd/yyyy') AS [Date],
		m.Note, m.Amount
FROM   dbo.Dog AS d INNER JOIN
             dbo.MealLog m ON d.ID = m.DogID INNER JOIN
             dbo.Food AS f ON f.ID = m.FoodID
GO
/****** Object:  Table [dbo].[Medicine]    Script Date: 5/18/2022 1:48:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Medicine](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Directions] [varchar](500) NULL,
	[NeededFor] [varchar](200) NULL,
	[BoughtFrom] [varchar](50) NULL,
	[Stock] [decimal](4, 1) NULL,
	[UnitPerStock] [varchar](10) NULL,
 CONSTRAINT [PK__Medicine__3214EC275C01E319] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MedLog]    Script Date: 5/18/2022 1:48:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MedLog](
	[MedLogID] [int] IDENTITY(1,1) NOT NULL,
	[DogID] [int] NOT NULL,
	[VolunteerID] [int] NOT NULL,
	[MedID] [int] NOT NULL,
	[Date] [date] NOT NULL,
	[Time] [time](0) NOT NULL,
	[Amount] [varchar](10) NULL,
	[Note] [varchar](100) NULL,
 CONSTRAINT [PK__MedLog__8F2CCEEB9162EF3D] PRIMARY KEY CLUSTERED 
(
	[MedLogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [MedLogCheckUnique] UNIQUE NONCLUSTERED 
(
	[DogID] ASC,
	[MedID] ASC,
	[Date] ASC,
	[Time] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[MedLogDetailFormatted]    Script Date: 5/18/2022 1:48:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[MedLogDetailFormatted]
AS
SELECT dbo.MedLog.MedLogID as ID, d.Name AS DogName, d.ID as DogID, 
			dbo.formatName(v.FirstName, v.LastName) AS VolunteerName, v.ID as VolunteerID,
			m.Name AS MedName, m.ID as MedID,
            dbo.MedLog.Amount, dbo.MedLog.Note, m.UnitPerStock,
			FORMAT(CONVERT(datetime, dbo.MedLog.[Time]), 'hh\:mm tt') AS [Time],
			FORMAT(dbo.MedLog.[Date], 'MM/dd/yyyy') AS [Date]
FROM   dbo.Dog AS d INNER JOIN
             dbo.MedLog ON d.ID = dbo.MedLog.DogID INNER JOIN
             dbo.Volunteer AS v ON dbo.MedLog.VolunteerID = v.ID INNER JOIN
             dbo.Medicine AS m ON dbo.MedLog.MedID = m.ID
GO
/****** Object:  Table [dbo].[MedPlan]    Script Date: 5/18/2022 1:48:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MedPlan](
	[MedPlanID] [int] IDENTITY(1,1) NOT NULL,
	[DogID] [int] NOT NULL,
	[MedID] [int] NOT NULL,
	[StartDate] [date] NOT NULL,
	[EndDate] [date] NULL,
	[DosageRegime] [varchar](100) NULL,
	[SpecialInstruction] [varchar](200) NULL,
 CONSTRAINT [PK__MedPlan__CE0D08F6023BE743] PRIMARY KEY CLUSTERED 
(
	[MedPlanID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [MedPlanCheckUnique] UNIQUE NONCLUSTERED 
(
	[DogID] ASC,
	[MedID] ASC,
	[StartDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[MedPlanDetailFormatted]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE   VIEW [dbo].[MedPlanDetailFormatted]
AS
SELECT dbo.MedPlan.MedPlanID as MedPlanID, 
	d.Name AS DogName, d.ID as DogID, 
	m.Name AS MedName, m.ID as MedID, 
	FORMAT(dbo.MedPlan.StartDate, 'MM/dd/yyyy') AS [StartDate],
	FORMAT(dbo.MedPlan.EndDate, 'MM/dd/yyyy') AS [EndDate],
	dbo.MedPlan.DosageRegime, 
    dbo.MedPlan.SpecialInstruction
FROM   dbo.Dog AS d INNER JOIN
             dbo.MedPlan ON d.ID = dbo.MedPlan.DogID INNER JOIN
             dbo.Medicine AS m ON dbo.MedPlan.MedID = m.ID
GO
/****** Object:  Table [dbo].[OnDuty]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OnDuty](
	[OnDutyID] [int] IDENTITY(1,1) NOT NULL,
	[VolunteerID] [int] NOT NULL,
	[ShiftID] [int] NOT NULL,
	[isShiftLeader] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[OnDutyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Shift]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Shift](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[StartTime] [time](0) NOT NULL,
	[Span] [decimal](2, 1) NOT NULL,
	[Date] [date] NOT NULL,
	[TODO] [varchar](500) NULL,
	[Note] [varchar](500) NULL,
 CONSTRAINT [PK__shift__3214EC27DC29A43E] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [Check_shift_unique] UNIQUE NONCLUSTERED 
(
	[Date] ASC,
	[StartTime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [Shift_ck_uniq] UNIQUE NONCLUSTERED 
(
	[StartTime] ASC,
	[Date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[OnDutyDetailFormatted]    Script Date: 5/18/2022 1:48:58 AM ******/
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
/****** Object:  Table [dbo].[BRLog]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BRLog](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DogID] [int] NOT NULL,
	[Time] [time](0) NOT NULL,
	[Date] [date] NOT NULL,
	[Type] [varchar](30) NOT NULL,
	[Note] [varchar](200) NULL,
 CONSTRAINT [PK__BLog__3214EC2793FE3C3A] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[BRLogDetailFormatted]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[BRLogDetailFormatted]
AS
SELECT BR.ID, d.[name] as DogName, d.ID as DogID, [Type], [Note],
FORMAT(CONVERT(datetime, br.[Time]), 'hh\:mm tt') AS [Time],
		FORMAT(br.[Date], 'MM/dd/yyyy') AS [Date]
FROM BRLog as BR 
JOIN Dog d on BR.DogID = d.ID


GO
/****** Object:  View [dbo].[ShiftFormatted]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ShiftFormatted]
AS
SELECT ID, FORMAT(CONVERT(datetime, [StartTime]), 'hh\:mm tt') AS [StartTime],
		FORMAT([Date], 'MM/dd/yyyy') AS [Date], Span, TODO, Note
FROM [Shift]
GO
/****** Object:  View [dbo].[VolunteerFullName]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VolunteerFullName]
AS
SELECT dbo.formatName(v.FirstName, v.LastName) as Name, v.ID as ID
FROM Volunteer as v
GO
/****** Object:  Table [dbo].[Login]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Login](
	[Username] [varchar](8) NOT NULL,
	[EncPW] [varchar](100) NOT NULL,
	[Key] [varchar](32) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Food] ADD  CONSTRAINT [DF_FoodStock]  DEFAULT ((0)) FOR [Stock]
GO
ALTER TABLE [dbo].[Medicine] ADD  CONSTRAINT [DF_MedStock]  DEFAULT ((0)) FOR [Stock]
GO
ALTER TABLE [dbo].[Volunteer] ADD  CONSTRAINT [DF_Volunteer_CanGiveMed]  DEFAULT ((0)) FOR [CanGiveMed]
GO
ALTER TABLE [dbo].[BRLog]  WITH CHECK ADD  CONSTRAINT [FK__BLog__DogID__5BE2A6F2] FOREIGN KEY([DogID])
REFERENCES [dbo].[Dog] ([ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[BRLog] CHECK CONSTRAINT [FK__BLog__DogID__5BE2A6F2]
GO
ALTER TABLE [dbo].[MealLog]  WITH CHECK ADD  CONSTRAINT [FK__Eats__DogID__5165187F] FOREIGN KEY([DogID])
REFERENCES [dbo].[Dog] ([ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[MealLog] CHECK CONSTRAINT [FK__Eats__DogID__5165187F]
GO
ALTER TABLE [dbo].[MealLog]  WITH CHECK ADD  CONSTRAINT [FK__Eats__FoodID__534D60F1] FOREIGN KEY([FoodID])
REFERENCES [dbo].[Food] ([ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[MealLog] CHECK CONSTRAINT [FK__Eats__FoodID__534D60F1]
GO
ALTER TABLE [dbo].[MedLog]  WITH CHECK ADD  CONSTRAINT [FK__MedLog__DogID__7D439ABD] FOREIGN KEY([DogID])
REFERENCES [dbo].[Dog] ([ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[MedLog] CHECK CONSTRAINT [FK__MedLog__DogID__7D439ABD]
GO
ALTER TABLE [dbo].[MedLog]  WITH CHECK ADD  CONSTRAINT [FK__MedLog__MedID__7F2BE32F] FOREIGN KEY([MedID])
REFERENCES [dbo].[Medicine] ([ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[MedLog] CHECK CONSTRAINT [FK__MedLog__MedID__7F2BE32F]
GO
ALTER TABLE [dbo].[MedLog]  WITH CHECK ADD  CONSTRAINT [FK__MedLog__Voluntee__7E37BEF6] FOREIGN KEY([VolunteerID])
REFERENCES [dbo].[Volunteer] ([ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[MedLog] CHECK CONSTRAINT [FK__MedLog__Voluntee__7E37BEF6]
GO
ALTER TABLE [dbo].[MedPlan]  WITH CHECK ADD  CONSTRAINT [FK__MedPlan__DogID__71D1E811] FOREIGN KEY([DogID])
REFERENCES [dbo].[Dog] ([ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[MedPlan] CHECK CONSTRAINT [FK__MedPlan__DogID__71D1E811]
GO
ALTER TABLE [dbo].[MedPlan]  WITH CHECK ADD  CONSTRAINT [FK__MedPlan__MedID__72C60C4A] FOREIGN KEY([MedID])
REFERENCES [dbo].[Medicine] ([ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[MedPlan] CHECK CONSTRAINT [FK__MedPlan__MedID__72C60C4A]
GO
ALTER TABLE [dbo].[OnDuty]  WITH CHECK ADD  CONSTRAINT [FK__OnDuty__ShiftID__18B6AB08] FOREIGN KEY([ShiftID])
REFERENCES [dbo].[Shift] ([ID])
GO
ALTER TABLE [dbo].[OnDuty] CHECK CONSTRAINT [FK__OnDuty__ShiftID__18B6AB08]
GO
ALTER TABLE [dbo].[OnDuty]  WITH CHECK ADD FOREIGN KEY([VolunteerID])
REFERENCES [dbo].[Volunteer] ([ID])
GO
ALTER TABLE [dbo].[BRLog]  WITH CHECK ADD  CONSTRAINT [CHK_BRLogType] CHECK  (([Type]='both' OR [Type]='defecation' OR [Type]='urination'))
GO
ALTER TABLE [dbo].[BRLog] CHECK CONSTRAINT [CHK_BRLogType]
GO
ALTER TABLE [dbo].[Dog]  WITH CHECK ADD  CONSTRAINT [Dog_DOB_Check] CHECK  (([DateOfBirth]<getdate()))
GO
ALTER TABLE [dbo].[Dog] CHECK CONSTRAINT [Dog_DOB_Check]
GO
ALTER TABLE [dbo].[Dog]  WITH CHECK ADD  CONSTRAINT [Dog_Sex_Check] CHECK  (([sex]='male' OR [sex]='female'))
GO
ALTER TABLE [dbo].[Dog] CHECK CONSTRAINT [Dog_Sex_Check]
GO
ALTER TABLE [dbo].[Dog]  WITH CHECK ADD  CONSTRAINT [Dog_Weight_Check] CHECK  (([WeightInlbs]>(0)))
GO
ALTER TABLE [dbo].[Dog] CHECK CONSTRAINT [Dog_Weight_Check]
GO
ALTER TABLE [dbo].[Food]  WITH CHECK ADD  CONSTRAINT [Pos_FoodStock] CHECK  (([Stock]>=(0)))
GO
ALTER TABLE [dbo].[Food] CHECK CONSTRAINT [Pos_FoodStock]
GO
ALTER TABLE [dbo].[Medicine]  WITH CHECK ADD  CONSTRAINT [PosMedStock] CHECK  (([Stock]>=(0)))
GO
ALTER TABLE [dbo].[Medicine] CHECK CONSTRAINT [PosMedStock]
GO
ALTER TABLE [dbo].[Volunteer]  WITH CHECK ADD  CONSTRAINT [Volunteer_DOB_Check] CHECK  (([DateOfBirth]<getdate()))
GO
ALTER TABLE [dbo].[Volunteer] CHECK CONSTRAINT [Volunteer_DOB_Check]
GO
/****** Object:  StoredProcedure [dbo].[AddBRLog]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[AddBRLog]
(
	--exactly one of name and id has to be provided
	@dName varchar(50) = null, 
	@dID int = null,
	@time varchar(10) = null,
	@date varchar(10) = null,
	@type varchar(30) = null, 
	@Note varchar(200) = null
)
AS
BEGIN

	if (@date is null)
	BEGIN
		SET @date = convert(date, GETDATE())
	END

	if (@time is null)
	BEGIN
		SET @time = convert(time(0), GETDATE())
	END

	if(@dID is null and @dName is null)
	BEGIN
		RAISERROR('dog info needed', 14, 1);
		
		RETURN 1;
	END

	if (@type is null) 
	BEGIN
		RAISERROR('entry description needed', 14, 25);
		
		RETURN 25;
	END

	if (@dID is not null and @dName is not null)
	BEGIN
		RAISERROR('Only one of dog ID and dog name needed', 14, 3);
		
		RETURN 3;
	END

	--ID value to make the final insertion
	DECLARE @dbDogID int = null;

	--dName is provided. dID is null
	if (@dName is not null)
	BEGIN
		--No dog with given name
		if (not exists(SELECT * FROM Dog WHERE [name] = @dName))
		BEGIN
			RAISERROR('dog does not exist', 14, 5);
			
			RETURN 5;
		END
		--More than one dog with the given name
		else if (not exists(SELECT [Name] FROM Dog WHERE [name] = @dName GROUP BY [name] HAVING count(*) = 1))
		BEGIN
			RAISERROR('there is more than one dog with the given name.', 14, 6);
			
			RETURN 6;
		END
		--The dog name is valid
		else
		BEGIN
			SET @dbDogID = (SELECT ID FROM Dog WHERE [Name] = @dName)
		END
	END

	--Dog ID is provided. Name is null.
	else if (@dID is not null)
	BEGIN
		if(not exists(SELECT * FROM Dog WHERE ID = @dID))
		BEGIN
			RAISERROR('the given dog ID does not exist.', 14, 7);
			
			RETURN 7;
		END
		else 
		BEGIN
			SET @dbDogID = @dID
		END
	END

	if (exists(SELECT * FROM BRLog WHERE DogID = @dbDogID and [Date] = @date and [Time] = @time))
	BEGIN
		RAISERROR('The record already exists', 14, 27);
		
		RETURN 27;
	END


	DECLARE @convDate Date
	DECLARE @convTime time(0)

	if (@date is null)
	BEGIN
		SET @convDate = convert(date, GETDATE())
	END
	else 
	BEGIN
		SET @convDate = Try_Convert(Date, @date)
	END

	if (@time is null)
	BEGIN 
		SET @convTime = convert(time(0), GETDATE())
	END
	else
	BEGIN
		SET @convTime = Try_Convert(time(0), @time)
	END

	if (@convDate is null) 
	BEGIN
		RAISERROR('Invalid date', 14, 85);
		RETURN 85;
	END

	if (@convTime is null) 
	BEGIN
		RAISERROR('Invalid time', 14, 86);
		RETURN 86;
	END

	IF @convDate > GETDATE()
	BEGIN
		RAISERROR('Cannot add bathroom log from the future', 14, 8);
		RETURN 8;
	END


	INSERT INTO BRLog
	(DogID, [Time], [Date], [Type], [Note])
	Values(@dbDogID, @convTime, @convDate, @type, @Note)
	
	--SELECT BRLog.ID AS ID, Dog.ID AS DogID,
	--		FORMAT(CONVERT(datetime, [Time]), 'hh\:mm tt') AS [Time],
	--		FORMAT([Date], 'MM/dd/yyyy') AS [Date],
	--		[Type], Note, [Name]
	--FROM BRLog
	--JOIN Dog ON BRLog.DogID = Dog.ID
	--WHERE BRLog.ID = @@IDENTITY

	SELECT * FROM BRLogDetailFormatted WHERE BRLogDetailFormatted.ID = @@IDENTITY
	
	RETURN 0;

END

GO
/****** Object:  StoredProcedure [dbo].[AddDog]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddDog]
(	
	@name varchar(50),
	@WeightInLbs int = null,
	@HasBeenSpayed bit = null,
	@DOB varchar(10) = null,
	@Sex varchar(20) = null,
	@Breed varchar(50) = null,
	@information varchar(500) = null,
	@GeneralInstruction varchar(500) = null,
	@FeedInstruction varchar(500) = null
)
AS
BEGIN

	IF(@name is null)
	BEGIN
		RAISERROR('name cannot be null', 14, 1);
		RETURN 1;
	END

	IF(@WeightInLbs is not null and @WeightInLbs <= 0)
	BEGIN
		RAISERROR('weight must be positive', 14, 2);
		RETURN 2;
	END

	IF(@Sex is not null and @Sex != 'male' and @Sex != 'female')
	BEGIN
		RAISERROR('sex must be either male or female', 14, 3);
		RETURN 3;
	END

	DECLARE @convDate date = null
	if (@DOB is not null)
	BEGIN
		SET @convDate = TRY_CONVERT(date, @DOB);
		if (@convDate is null)
		BEGIN
			RAISERROR('invalid dob', 14, 55);
			RETURN 55;
		END
	END

	IF @convDate > GETDATE()
	BEGIN
		RAISERROR('Dog cannot be born in the future', 14, 56);
		RETURN 56;
	END


	INSERT INTO Dog
	([name], [weightinlbs], hasbeenspayed, dateofbirth, sex, breed, information, generalinstruction, feedinstruction)
	Values(@name, @WeightInLbs, @HasBeenSpayed, @convDate, @Sex, @Breed, @information, @GeneralInstruction, @FeedInstruction)

	SELECT * FROM Dog WHERE Dog.ID = @@IDENTITY

	RETURN 0;

END
GO
/****** Object:  StoredProcedure [dbo].[AddFood]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[AddFood] 
(
	@name nvarchar(50),
	@Instructions nvarchar(500) = null,
	@boughtFrom nvarchar(50) = null,
	@Stock decimal(4,1) = 0,
	@UnitPerStock varchar(10) = null
)
AS 
BEGIN
	IF(@name is null)
	BEGIN
		RAISERROR('name cannot be null', 14, 1);
		
		RETURN 1;
	END

	IF(@Stock is not null and @stock < 0)
	BEGIN
		RAISERROR('stock must not be negative', 14, 2);
		
		RETURN 2;
	END

	INSERT INTO Food
	([Name], Instructions, boughtFrom, Stock, UnitPerStock)
	Values(@name, @Instructions, @boughtFrom, @Stock, @UnitPerStock)

	SELECT * FROM [Food] WHERE ID = @@IDENTITY;

	RETURN 0;
END

GO
/****** Object:  StoredProcedure [dbo].[AddMealLog]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddMealLog]
(
	--exactly one of name and id has to be provided
	@dName varchar(50) = null,  --dog name
	@dId int = null, -- dog id
	@fName varchar(50) = null, --food name
	@fId int = null, --food id
	@date varchar(10) = null,
	@time varchar(10) = null,
	@amount decimal(4,1),
	@Note varchar(100) = null
)
AS

BEGIN
	if (@date is null)
	BEGIN
		SET @date = convert(date, GETDATE())
	END

	if (@time is null)
	BEGIN 
		SET @time = convert(time(0), convert(varchar(5), (convert(time(0), GETDATE()))))
	END

	if (@amount is null)
	BEGIN 
		RAISERROR('amount cannot be null', 14, 66);
		RETURN 66;
	END

	if(@dID is null and @dName is null)
	BEGIN
		RAISERROR('dog info needed', 14, 1);
		
		RETURN 1;
	END

	if (@fID is null and @fName is null)
	BEGIN
		RAISERROR('food info needed', 14, 2);
		
		RETURN 2;
	END

	if (@dID is not null and @dName is not null)
	BEGIN
		RAISERROR('Only one of dog ID and dog name needed', 14, 3);
		
		RETURN 3;
	END

	if (@fID is not null and @fName is not null)
	BEGIN 
		RAISERROR('Only one of food ID and food name needed', 14, 4);
		
		RETURN 4;
	END

	--ID value to make the final insertion
	DECLARE @dbDogID int = null;

	--dName is provided. dID is null
	if (@dName is not null)
	BEGIN
		--No dog with given name
		if (not exists(SELECT * FROM Dog WHERE [name] = @dName))
		BEGIN
			RAISERROR('dog name does not exist', 14, 5);
			
			RETURN 5;
		END
		--More than one dog with the given name
		else if (not exists(SELECT [Name] FROM Dog WHERE [name] = @dName GROUP BY [name] HAVING count(*) = 1))
		BEGIN
			RAISERROR('there is more than one dog with the given name.', 14, 6);
			
			RETURN 6;
		END
		--The dog name is valid
		else
		BEGIN
			SET @dbDogID = (SELECT ID FROM Dog WHERE [Name] = @dName)
		END
	END


	--Dog Id is provided. Name is null.
	else if (@dId is not null)
	BEGIN
		if(not exists(SELECT * FROM Dog WHERE ID = @dId))
		BEGIN
			RAISERROR('the given dog ID does not exist.', 14, 7);
			
			RETURN 7;
		END
		else 
		BEGIN
			SET @dbDogID = @dId
		END
	END

	--ID value to make the final insertion
	DECLARE @dbFoodID int = null;

	--fName is provided. fID is null
	if (@fName is not null)
	BEGIN
		--No food with given name
		if (not exists(SELECT * FROM Food WHERE [name] = @fName))
		BEGIN
			RAISERROR('food name does not exist', 14, 8);
			
			RETURN 8;
		END
		--More than one food with the given name
		else if (not exists(SELECT [Name] FROM Food WHERE [name] = @fName GROUP BY [name] HAVING count(*) = 1))
		BEGIN
			RAISERROR('there is more than one food with the given name.', 14, 9);
			
			RETURN 9;
		END
		--The food name is valid
		else
		BEGIN
			SET @dbfoodID = (SELECT ID FROM food WHERE [Name] = @fName)
		END
	END


	--Food Id is provided. Name is null.
	else if (@fId is not null)
	BEGIN
		if(not exists(SELECT * FROM Food WHERE ID = @fId))
		BEGIN
			RAISERROR('the given food ID does not exist.', 14, 10);
			
			RETURN 10;
		END
		else 
		BEGIN
			SET @dbFoodID = @fId
		END
	END

	DECLARE @oldStock decimal(4,1)
	SET @oldStock = (SELECT Stock FROM Food WHERE ID = @dbFoodID)

	if (@amount > @oldStock)
	BEGIN
		RAISERROR('food out of stock', 14, 67);
		RETURN 67;
	END

	if (exists(SELECT * FROM MealLog WHERE DogID = @dbDogID and FoodID = @dbFoodID and [Date] = @date and [Time] = @time))
	BEGIN
		RAISERROR('The record already exists', 14, 13);
		
		RETURN 13;
	END

	DECLARE @convDate Date
	DECLARE @convTime time(0)

	if (@date is null)
	BEGIN
		SET @convDate = convert(date, GETDATE())
	END
	else 
	BEGIN
		SET @convDate = Try_Convert(Date, @date)
	END

	if (@time is null)
	BEGIN 
		SET @convTime = convert(time(0), GETDATE())
	END
	else
	BEGIN
		SET @convTime = Try_Convert(time(0), @time)
	END


	if (@convDate is null) 
	BEGIN
		RAISERROR('Invalid date', 14, 85);
		RETURN 85;
	END

	if (@convTime is null) 
	BEGIN
		RAISERROR('Invalid time', 14, 86);
		RETURN 86;
	END

	IF @convDate > GETDATE()
	BEGIN
		RAISERROR('Cannot add meal log from the future', 14, 87);
		RETURN 87;
	END

	INSERT INTO MealLog
	(DogID, FoodID, [Date], [Time], Amount, Note)
	Values(@dbDogID, @dbFoodID, @convDate, @convTime, @amount, @Note)

	UPDATE Food
	SET Stock = @oldStock - @amount
	WHERE ID = @dbFoodID

	SELECT * FROM MealLogDetailFormatted WHERE ID = @@IDENTITY
	
	
	RETURN 0;

END
GO
/****** Object:  StoredProcedure [dbo].[AddMed]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AddMed]
(
	@name varchar(50),
	@direction varchar(500) = null,
	@neededFor varchar(200) = null,
	@boughtFrom varchar(50) = null,
	@stock decimal(4,1) = 0,
	@UnitPerStock varchar(10) = null
)
AS 
BEGIN
	if (@name is null) 
	BEGIN
		RAISERROR('name cannot be null.', 14, 1);
		
		RETURN 1;
	END

	if (@stock is not null and @stock < 0)
	BEGIN 
		RAISERROR('stock must not be negative.', 14, 2);
		
		RETURN 2;
	END

	INSERT INTO Medicine
	([Name], Directions, neededFor, boughtFrom, Stock, UnitPerStock)
	Values(@name, @direction, @neededFor, @boughtFrom, @stock, @UnitPerStock)

	SELECT * FROM [Medicine] WHERE ID = @@IDENTITY;
	RETURN 0;

END
	
GO
/****** Object:  StoredProcedure [dbo].[AddMedLog]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[AddMedLog]
(
	--exactly one of name and id has to be provided
	@dName varchar(50) = null, 
	@dID int = null, 
	----For Volunteer, accepted parameter forms are : FirstName || LastName || FirstName and LastName || ID
	@vfn varchar(50) = null, --volunteer first name
	@vln varchar(50) = null, --volunteer last name
	@vID int = null, --volunteer id
	@mName varchar(50) = null,
	@mID int = null,
	@date varchar(10) = null, 
	@time varchar(10) = null,
	@amount decimal(4,1) = null,
	@Note varchar(100) = null
)
AS
BEGIN

	if(@dID is null and @dName is null)
	BEGIN
		RAISERROR('dog info needed', 14, 1);
		RETURN 1;
	END

	if (@mID is null and @mName is null)
	BEGIN
		RAISERROR('med info needed', 14, 2);
		RETURN 2;
	END

	if (@vfn is null and @vln is null and @vID is null)
	BEGIN
		RAISERROR('volunteer info needed', 14, 13);
		RETURN 13;
	END

	if (@dID is not null and @dName is not null)
	BEGIN
		RAISERROR('Only one of dog ID and dog name needed', 14, 3);
		RETURN 3;
	END

	if (@mID is not null and @mName is not null)
	BEGIN 
		RAISERROR('Only one of med ID and med name needed', 14, 4);
		RETURN 4;
	END

	if ((@vfn is not null or @vln is not null) and @vID is not null)
	BEGIN
		RAISERROR('Only one of volunteer ID and volunteer full name is needed', 14, 13);
		RETURN 13;
	END

	IF @amount IS NULL
	BEGIN
		RAISERROR('Must provide an amount', 14, 15);
		RETURN 15;
	END

	--ID value to make the final insertion
	DECLARE @dbDogID int = null;

	--dName is provided. dID is null
	if (@dName is not null)
	BEGIN
		--No dog with given name
		if (not exists(SELECT * FROM Dog WHERE [name] = @dName))
		BEGIN
			RAISERROR('dog does not exist', 14, 5);
			RETURN 5;
		END
		--More than one dog with the given name
		else if (not exists(SELECT [Name] FROM Dog WHERE [name] = @dName GROUP BY [name] HAVING count(*) = 1))
		BEGIN
			RAISERROR('there is more than one dog with the given name.', 14, 6);
			RETURN 6;
		END
		--The dog name is valid
		else
		BEGIN
			SET @dbDogID = (SELECT ID FROM Dog WHERE [Name] = @dName)
		END
	END


	--Dog ID is provided. Name is null.
	else if (@dID is not null)
	BEGIN
		if(not exists(SELECT * FROM Dog WHERE ID = @dID))
		BEGIN
			RAISERROR('the given dog ID does not exist.', 14, 7);
			RETURN 7;
		END
		else 
		BEGIN
			SET @dbDogID = @dID
		END
	END

	--ID value to make the final insertion
	DECLARE @dbMedID int = null;

	--mName is provided. mID is null
	if (@mName is not null)
	BEGIN
		--No med with given name
		if (not exists(SELECT * FROM Medicine WHERE [name] = @mName))
		BEGIN
			RAISERROR('med name does not exist', 14, 8);
			RETURN 8;
		END
		--More than one med with the given name
		else if (not exists(SELECT [Name] FROM Medicine WHERE [name] = @mName GROUP BY [name] HAVING count(*) = 1))
		BEGIN
			RAISERROR('there is more than one med with the given name.', 14, 9);
			RETURN 9;
		END
		--The med name is valid
		else
		BEGIN
			SET @dbMedID = (SELECT ID FROM Medicine WHERE [Name] = @mName)
		END
	END

	--med ID is provided. Name is null.
	else if (@mID is not null)
	BEGIN
		if(not exists(SELECT * FROM Medicine WHERE ID = @mID))
		BEGIN
			RAISERROR('the given med ID does not exist.', 14, 10);
			RETURN 10;
		END
		else 
		BEGIN
			SET @dbMedID = @mID
		END
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
			--More than one volunteer with the given first name
			else if (not exists(SELECT FirstName FROM Volunteer WHERE FirstName = @vfn and LastName = @vln GROUP BY FirstName, LastName HAVING count(*) = 1))
			BEGIN
				RAISERROR('there is more than one volunteer with the given full name.', 14, 21);
				RETURN 25;
			END
			--The first name is valid
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

	DECLARE @oldStock decimal(4,1)
	SET @oldStock = (SELECT Stock FROM Medicine WHERE ID = @dbMedID)

	if (@amount > @oldStock)
	BEGIN
		RAISERROR('medicine out of stock', 14, 67);
		RETURN 67;
	END

	if (exists(SELECT * FROM MedLog WHERE DogID = @dbDogID and MedID = @dbMedID and VolunteerID = @dbVID and [Date] = @date and [Time] = @time))
	BEGIN
		RAISERROR('The record already exists', 14, 27);
		RETURN 27;
	END

	DECLARE @convDate Date
	DECLARE @convTime time(0)

	if (@date is null)
	BEGIN
		SET @convDate = convert(date, GETDATE())
	END
	else 
	BEGIN
		SET @convDate = Try_Convert(Date, @date)
	END

	if (@time is null)
	BEGIN 
		SET @convTime = convert(time(0), convert(varchar(5), (convert(time(0), GETDATE()))))
	END
	else
	BEGIN
		SET @convTime = Try_Convert(time(0), @time)
	END


	if (@convDate is null) 
	BEGIN
		RAISERROR('Invalid date', 14, 85);
		RETURN 85;
	END

	if (@convTime is null) 
	BEGIN
		RAISERROR('Invalid time', 14, 86);
		RETURN 86;
	END

	IF @convDate > GETDATE()
	BEGIN
		RAISERROR('Cannot add medication log from the future', 14, 87);
		RETURN 87;
	END


	INSERT INTO MedLog
	(DogID, VolunteerID, medID, [Date], [Time], Amount, Note)
	Values(@dbDogID, @dbVID, @dbMedID, @convDate, @convTime, @amount, @Note)

	UPDATE Medicine
	SET Stock = @oldStock - @amount
	WHERE ID = @dbMedID

	SELECT * FROM MedLogDetailFormatted WHERE ID = @@IDENTITY

	RETURN 0;

END
GO
/****** Object:  StoredProcedure [dbo].[AddMedPlan]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddMedPlan]
(
	--exactly one of name and id has to be provided
	@dID int, --dog id
	@mID int, --med id
	@startDate date = null, 
	@endDate date = null,
	@DR varchar(100) = null,
	@SI varchar(200) = null
)
AS
BEGIN

	if (@startDate is null)
	BEGIN
		SET @startDate = convert(date, GETDATE())
	END

	if(@dID is null)
	BEGIN
		RAISERROR('Dog ID is required', 14, 1);
		RETURN 1;
	END

	if (@mID is null)
	BEGIN
		RAISERROR('Medication ID is required', 14, 2);
		RETURN 2;
	END

	IF(@endDate IS NOT NULL AND @endDate < @startDate)
	BEGIN
		RAISERROR('endDate cannot be before startDate', 14, 3)
		RETURN 3;
	END

	--Dog ID is provided. Name is null.
	if(not exists(SELECT * FROM Dog WHERE ID = @dID))
	BEGIN
		RAISERROR('the given dog ID does not exist.', 14, 7);
		RETURN 7;
	END

	--med ID is provided. Name is null.
	if(not exists(SELECT * FROM Medicine WHERE ID = @mID))
	BEGIN
		RAISERROR('the given med ID does not exist.', 14, 10);
		RETURN 10;
	END

	if (exists (SELECT * FROM MedPlan WHERE DogID = @dID and MedID = @mID and StartDate = @startDate))
	BEGIN
		RAISERROR('record already exists', 14, 50);
		RETURN 50;
	END

	INSERT INTO MedPlan(DogID, MedID, StartDate, EndDate, DosageRegime, SpecialInstruction)
	VALUES(@dID, @mID, @startDate, @endDate, @DR, @SI)

	SELECT *
	FROM MedPlanDetailFormatted
	WHERE MedPlanID = @@IDENTITY

	RETURN 0;

END
GO
/****** Object:  StoredProcedure [dbo].[AddMedPlanByName]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddMedPlanByName]
(
	--exactly one of name and id has to be provided
	@dName varchar(50), --dog id
	@mName varchar(50),
	@startDate date = null, 
	@endDate date = null,
	@DR varchar(100) = null,
	@SI varchar(200) = null
)
AS
BEGIN

	if (@startDate is null)
	BEGIN
		SET @startDate = convert(date, GETDATE())
	END

	if(@dName is null)
	BEGIN
		RAISERROR('Dog name is required', 14, 1);
		RETURN 1;
	END

	if (@mName is null)
	BEGIN
		RAISERROR('Medication name is required', 14, 2);
		RETURN 2;
	END

	IF(@endDate IS NOT NULL AND @endDate < @startDate)
	BEGIN
		RAISERROR('endDate cannot be before startDate', 14, 3)
		RETURN 3;
	END

	--Dog ID is provided. Name is null.
	if(not exists(SELECT * FROM Dog WHERE [Name] = @dName))
	BEGIN
		RAISERROR('the given dog name does not exist.', 14, 7);
		RETURN 7;
	END

	if (exists(SELECT [Name] FROM Dog WHERE [Name] = @dName GROUP BY [Name] HAVING COUNT(*) > 1))
	BEGIN
		RAISERROR('more than one dog with the given name.', 14, 8);
		RETURN 8;
	END

	--med ID is provided. Name is null.
	if(not exists(SELECT * FROM Medicine WHERE Name = @mName))
	BEGIN
		RAISERROR('the given med name does not exist.', 14, 10);
		RETURN 10;
	END

	if (exists(SELECT [Name] FROM Medicine WHERE [Name] = @dName GROUP BY [Name] HAVING COUNT(*) > 1))
	BEGIN
		RAISERROR('more than one med with the given name.', 14, 8);
		RETURN 8;
	END

	DECLARE @dID int;
	DECLARE @mID int;

	SET @dID = (SELECT ID FROM Dog WHERE [Name] = @dName)
	SET @mID = (SELECT ID FROM Medicine WHERE [Name] = @mName)

	if (exists (SELECT * FROM MedPlan WHERE DogID = @dID and MedID = @mID and StartDate = @startDate))
	BEGIN
		RAISERROR('record already exists', 14, 50);
		RETURN 50;
	END

	INSERT INTO MedPlan(DogID, MedID, StartDate, EndDate, DosageRegime, SpecialInstruction)
	VALUES(@dID, @mID, @startDate, @endDate, @DR, @SI)

	SELECT *
	FROM MedPlanDetailFormatted
	WHERE MedPlanID = @@IDENTITY

	RETURN 0;

END
GO
/****** Object:  StoredProcedure [dbo].[AddOnDuty]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AddOnDuty]
(
	--For Volunteer, accepted parameter forms are : FirstName || LastName || FirstName and LastName || ID
	--For Shift, Accepted parameter forms are:  shiftID || ShiftDate || ShiftStartTime and ShiftDate
	@vfn varchar(50) = null, --volunteer first name
	@vln varchar(50) = null, --volunteer last name
	@vID int = null, --volunteer ID
	@sID int = null,	--shift ID
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
/****** Object:  StoredProcedure [dbo].[AddShift]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddShift]
(
	@StartTime varchar(10) = null,
	@Span decimal(2,1),
	@Date varchar(10) = null,
	@TODO varchar(500) = null,
	@Note varchar(500) = null
)
AS
BEGIN

	if (@Span is null)
	BEGIN
		RAISERROR('Please Specify span', 14, 2);
		RETURN 2;
	END

	DECLARE @convDate Date
	DECLARE @convTime time(0)

	if (@date is null)
	BEGIN
		SET @convDate = convert(date, GETDATE())
	END
	else 
	BEGIN
		SET @convDate = Try_Convert(Date, @date)
	END

	if (@StartTime is null)
	BEGIN 
		SET @convTime = convert(time(0), convert(varchar(5), (convert(time(0), GETDATE()))))
	END
	else
	BEGIN
		SET @convTime = Try_Convert(time(0), @StartTime)
	END


	if (@convDate is null) 
	BEGIN
		RAISERROR('Invalid date', 14, 85);
		RETURN 85;
	END

	if (@convTime is null) 
	BEGIN
		RAISERROR('Invalid time', 14, 86);
		RETURN 86;
	END

	if (exists (SELECT * FROM [Shift] WHERE StartTime = @convTime and [Date] = @convDate))
	BEGIN
		RAISERROR('shift already exists',14, 3);
		RETURN 3;
	END


	INSERT INTO [Shift]
	(StartTime, Span, [Date], TODO, Note)
	Values(@convTime, @Span, @convDate, @todo, @note)

	SELECT * FROM [ShiftFormatted] WHERE ID = @@IDENTITY

	RETURN 0;

END

GO
/****** Object:  StoredProcedure [dbo].[AddVolunteer]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[AddVolunteer]
(
	@FirstName varchar(50),
	@LastName varchar(50),
	@DOB varchar(10) = null, 
	@Sex varchar(20) = null,
	@MemberSince varchar(10) = null,
	@CanGiveMed bit,
	@ServicesEndOn varchar(10) = null
)
AS
BEGIN
	
	if (@FirstName is null or @LastName is null) 
	BEGIN
		RAISERROR('name cannot be null.', 14, 1);
		
		RETURN 1;
	END

	if (@CanGiveMed is null) 
	BEGIN
		RAISERROR('medic permission cannot be null.', 14, 2);
		
		RETURN 2;
	END

	DECLARE @convDOB date = null
	if (@DOB is not null)
	BEGIN
		SET @convDOB = TRY_CONVERT(date, @DOB);
		if (@convDOB is null)
		BEGIN
			RAISERROR('invalid date of birth', 14, 55);
			RETURN 55;
		END
	END

	DECLARE @convMS date = null
	if (@MemberSince is not null)
	BEGIN
		SET @convMS = TRY_CONVERT(date, @MemberSince);
		if (@convMS is null)
		BEGIN
			RAISERROR('invalid member since date', 14, 56);
			RETURN 56;
		END
	END

	DECLARE @convSEO date = null
	if (@ServicesEndOn is not null)
	BEGIN
		SET @convSEO = TRY_CONVERT(date, @ServicesEndOn);
		if (@convSEO is null)
		BEGIN
			RAISERROR('invalid services end on date', 14, 57);
			RETURN 57;
		END
	END

	IF @convDOB > GETDATE()
	BEGIN
		RAISERROR('You cannot be born in the future', 14, 58);
		RETURN 58;
	END

	IF @convMS > GETDATE()
	BEGIN
		RAISERROR('Cannot be a member since a future date', 14, 59);
		RETURN 59;
	END

	INSERT INTO Volunteer
	(FirstName, LastName, DateOfBirth, Sex, MemberSince, CanGiveMed, ServicesEndOn)
	Values(@FirstName, @LastName, @convDOB, @Sex, @convMS, @CanGiveMed, @convSEO)
	
	SELECT * FROM Volunteer WHERE Volunteer.ID = @@IDENTITY

	RETURN 0;

END
GO
/****** Object:  StoredProcedure [dbo].[ApplyBRLogFilter]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ApplyBRLogFilter]
(
	@DogID int,
	@StartDate varchar(10) = null,
	@EndDate varchar(10) = null

)
AS
BEGIN
	if (@DogID is null) 
	BEGIN
		RAISERROR('dog id needed', 14, 1);
		RETURN 1;
	END

	DECLARE @startDateConv date = null
	DECLARE @endDateConv date = null

	if (@StartDate is not null)
	BEGIN
		SET @startDateConv = Try_Convert(Date, @StartDate)
	END

	if (@EndDate is not null)
	BEGIN
		SET @endDateConv = Try_Convert(Date, @EndDate)
	END

	if (@startDateConv is null and @endDateConv is null)
	BEGIN
		SELECT * FROM BRLogDetailFormatted
		WHERE DogID = @DogID
		ORDER BY [Date] DESC, [Time] ASC

		RETURN 0;
	END
	else if (@startDateConv is null)
	BEGIN
		SELECT * FROM BRLogDetailFormatted
		WHERE [Date] <= @endDateConv AND DogID = @DogID
		ORDER BY [Date] DESC, [Time] ASC

		RETURN 0;
	END
	else if (@endDateConv is null)
	BEGIN
		SELECT * FROM BRLogDetailFormatted
		WHERE [Date] >= @startDateConv AND DogID = @DogID
		ORDER BY [Date] DESC, [Time] ASC

		RETURN 0;
	END
	else
	BEGIN
		SELECT * FROM BRLogDetailFormatted
		WHERE [Date] >= @startDateConv AND [Date] <= @endDateConv AND DogID = @DogID
		ORDER BY [Date] DESC, [Time] ASC
		
		RETURN 0;
	END
END
GO

/****** Object:  StoredProcedure [dbo].[ApplyDogFilter]    Script Date: 5/19/2022 9:00:48 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ApplyDogFilter]
(
	@Name varchar(50) = null,
	@Sex varchar(20) = null,
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
	--if (@Sex is null)
	--BEGIN
	--	RAISERROR('must declare sex', 14, 1);
	--	RETURN 1;
	--END
	if (@Name is not null)
	BEGIN
		DELETE FROM @temp
		WHERE [Name] <> @Name OR [Name] IS NULL
	END

	if (@Breed is not null) 
	BEGIN
		DELETE FROM @temp 
		WHERE Breed <> @Breed OR Breed IS NULL
	END

	if (@MinAge is not null)
	BEGIN
		DELETE FROM @temp
		WHERE Age < @MinAge OR Age IS NULL
	END

	if (@MaxAge is not null)
	BEGIN	
		DELETE FROM @temp
		WHERE Age > @MaxAge OR Age IS NULL
	END

	IF @Sex IS NOT NULL
		DELETE FROM @temp WHERE Sex <> @Sex OR Sex IS NULL
	
	SELECT * FROM @temp
	RETURN 0;

END
GO
/****** Object:  StoredProcedure [dbo].[ApplyMealLogFilter]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ApplyMealLogFilter]
(
	@DogID int,
	@StartDate varchar(10) = null,
	@EndDate varchar(10) = null

)
AS
BEGIN
	if (@DogID is null) 
	BEGIN
		RAISERROR('dog id needed', 14, 1);
		RETURN 1;
	END

	DECLARE @startDateConv date = null
	DECLARE @endDateConv date = null

	if (@StartDate is not null)
	BEGIN
		SET @startDateConv = Try_Convert(Date, @StartDate)
	END

	if (@EndDate is not null)
	BEGIN
		SET @endDateConv = Try_Convert(Date, @EndDate)
	END

	if (@startDateConv is null and @endDateConv is null)
	BEGIN
		SELECT * FROM MealLogDetailFormatted
		WHERE DogID = @DogID
		ORDER BY [Date] DESC, [Time] ASC

		RETURN 0;
	END
	else if (@startDateConv is null)
	BEGIN
		SELECT * FROM MealLogDetailFormatted
		WHERE [Date] <= @endDateConv AND DogID = @DogID
		ORDER BY [Date] DESC, [Time] ASC

		RETURN 0;
	END
	else if (@endDateConv is null)
	BEGIN
		SELECT * FROM MealLogDetailFormatted
		WHERE [Date] >= @startDateConv AND DogID = @DogID
		ORDER BY [Date] DESC, [Time] ASC

		RETURN 0;
	END
	else
	BEGIN
		SELECT * FROM MealLogDetailFormatted
		WHERE [Date] >= @startDateConv AND [Date] <= @endDateConv AND DogID = @DogID
		ORDER BY [Date] DESC, [Time] ASC
		
		RETURN 0;
	END
END
GO
/****** Object:  StoredProcedure [dbo].[ApplyMedLogFilter]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[ApplyMedLogFilter]
(
	@DogID int,
	@StartDate varchar(10) = null,
	@EndDate varchar(10) = null

)
AS
BEGIN
	if (@DogID is null) 
	BEGIN
		RAISERROR('dog id needed', 14, 1);
		RETURN 1;
	END

	DECLARE @startDateConv date = null
	DECLARE @endDateConv date = null

	if (@StartDate is not null)
	BEGIN
		SET @startDateConv = Try_Convert(Date, @StartDate)
	END

	if (@EndDate is not null)
	BEGIN
		SET @endDateConv = Try_Convert(Date, @EndDate)
	END

	if (@startDateConv is null and @endDateConv is null)
	BEGIN
		SELECT * FROM MedLogDetailFormatted
		WHERE DogID = @DogID
		ORDER BY [Date] DESC, [Time] ASC

		RETURN 0;
	END
	else if (@startDateConv is null)
	BEGIN
		SELECT * FROM MedLogDetailFormatted
		WHERE [Date] <= @endDateConv AND DogID = @DogID
		ORDER BY [Date] DESC, [Time] ASC

		RETURN 0;
	END
	else if (@endDateConv is null)
	BEGIN
		SELECT * FROM MedLogDetailFormatted
		WHERE [Date] >= @startDateConv AND DogID = @DogID
		ORDER BY [Date] DESC, [Time] ASC

		RETURN 0;
	END
	else
	BEGIN
		SELECT * FROM MedLogDetailFormatted
		WHERE [Date] >= @startDateConv AND [Date] <= @endDateConv AND DogID = @DogID
		ORDER BY [Date] DESC, [Time] ASC
		
		RETURN 0;
	END
END
GO
/****** Object:  StoredProcedure [dbo].[ApplyVolunteerFilter]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[ApplyVolunteerFilter]
(
	@FirstName varchar(50) = null,
	@LastName varchar(50) = null,
	@CanGiveMed bit = null
)
AS
BEGIN
	DECLARE @temp TABLE ( [ID] [int] NOT NULL,
	[FirstName] [varchar](50) NOT NULL,
	[LastName] [varchar](50) NOT NULL,
	[DateOfBirth] [date] NULL,
	Sex varchar(20) NULL,
	MemberSince date NULL,
	Age int NULL,
	CanGiveMed bit NULL,
	ServicesEndOn date NULL);
	INSERT INTO @temp 
	(ID, FirstName, LastName, DateOfBirth, Sex, MemberSince, Age, CanGiveMed, ServicesEndOn)
	SELECT * FROM Volunteer
	--if (@Sex is null)
	--BEGIN
	--	RAISERROR('must declare sex', 14, 1);
	--	RETURN 1;
	--END
	if (@FirstName is not null) 
	BEGIN
		DELETE FROM @temp 
		WHERE [FirstName] <> @FirstName OR FirstName IS NULL
	END
	if (@LastName is not null) 
	BEGIN
		DELETE FROM @temp 
		WHERE [LastName] <> @LastName OR LastName IS NULL
	END
	if (@CanGiveMed is not null) 
	BEGIN
		DELETE FROM @temp 
		WHERE [CanGiveMed] <> @CanGiveMed OR CanGiveMed IS NULL
	END

	SELECT * FROM @temp
	RETURN 0;

END
GO
/****** Object:  StoredProcedure [dbo].[AssignShiftLeader]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AssignShiftLeader]
(
	@OnDutyID int
)
AS
BEGIN

	if (@OnDutyID is null)
	BEGIN
		RAISERROR('Record ID cannot be null', 14, 1);
		RETURN 1;
	END

	if (not exists(SELECT * FROM OnDuty WHERE OnDutyID = @OnDutyID))
	BEGIN
		RAISERROR('Record not found', 14, 2);
		RETURN 2;
	END

	UPDATE OnDuty
	SET isShiftLeader = 1
	WHERE OnDutyID = @OnDutyID

	RETURN 0;

END
GO
/****** Object:  StoredProcedure [dbo].[CreateCredential]    Script Date: 5/18/2022 1:48:58 AM ******/
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
/****** Object:  StoredProcedure [dbo].[DeleteBRLog]    Script Date: 5/18/2022 1:48:58 AM ******/
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
/****** Object:  StoredProcedure [dbo].[DeleteDog]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteDog]
	(@DogID [int])
AS
BEGIN
	--Validates parameters
	IF (@DogID is null)
	BEGIN
		RAISERROR('DogID provided is null', 14, 1);
		RETURN 1
	END
	IF (NOT EXISTS (SELECT * FROM [Dog] WHERE [ID] = @DogID))
	BEGIN
		RAISERROR('Provided DogID does not exist.', 14, 1);
		RETURN 2
	END

	DELETE FROM [Dog]
	WHERE ( [ID] = @DogID)
END
GO
/****** Object:  StoredProcedure [dbo].[DeleteFood]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteFood]
	(@FoodID [int])
AS
BEGIN
	--Validates parameters
	IF (@FoodID is null)
	BEGIN
		RAISERROR('FoodID provided is null', 14, 1);
		RETURN 1
	END
	IF (NOT EXISTS (SELECT * FROM [Food] WHERE [ID] = @FoodID))
	BEGIN
		RAISERROR('Provided FoodID does not exist.', 14, 1);
		RETURN 2
	END

	DELETE [Food]
	WHERE ( [ID] = @FoodID)
END
GO
/****** Object:  StoredProcedure [dbo].[DeleteMealLog]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[DeleteMealLog]
( @MealLogID int )
AS 
BEGIN
	if (@MealLogID is null)
	BEGIN
		RAISERROR('meal log id cannot be null', 14, 1);
		RETURN 1;
	END

	if (not exists(SELECT * FROM MealLog WHERE MealLogID = @MealLogID))
	BEGIN
		RAISERROR('Meal log does not exist', 14, 2);
		RETURN 2;
	END

	DECLARE @amt decimal(4,1)
	SET @amt = (SELECT Amount FROM MealLog WHERE MealLogId = @MealLogID)
	DECLARE @foodID int
	SET @foodID = (SELECT FoodID from MealLog WHERE MealLogId = @MealLogID)
	DECLARE @oldStock decimal(4,1)
	SET @oldStock = (SELECT Stock FROM Food WHERE ID = @foodID)
	UPDATE Food
	SET Stock = @oldStock + @amt
	WHERE ID = @foodID

	DELETE FROM MealLog
	WHERE MealLogID = @MealLogID

	RETURN 0
END
GO
/****** Object:  StoredProcedure [dbo].[DeleteMed]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteMed]
	(@MedID [int])
AS
BEGIN
	--Validates parameters
	IF (@MedID is null)
	BEGIN
		RAISERROR('MedID provided is null', 14, 1);
		RETURN 1
	END
	IF (NOT EXISTS (SELECT * FROM [Medicine] WHERE [ID] = @MedID))
	BEGIN
		RAISERROR('Provided MedID does not exist.', 14, 1);
		RETURN 2
	END

	DELETE [Medicine]
	WHERE ( [ID] = @MedID)
END
GO
/****** Object:  StoredProcedure [dbo].[DeleteMedLog]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     PROCEDURE [dbo].[DeleteMedLog]
( @MedLogID int )
AS 
BEGIN
	if (@MedLogID is null)
	BEGIN
		RAISERROR('med log id cannot be null', 14, 1);
		RETURN 1;
	END

	if (not exists(SELECT * FROM MedLog WHERE MedLogID = @MedLogID))
	BEGIN
		RAISERROR('Med log does not exist', 14, 2);
		RETURN 2;
	END

	DECLARE @amt decimal(4,1)
	SET @amt = (SELECT Amount FROM MedLog WHERE MedLogId = @MedLogID)
	DECLARE @medID int
	SET @medID = (SELECT MedID from MedLog WHERE MedLogId = @MedLogID)
	DECLARE @oldStock decimal(4,1)
	SET @oldStock = (SELECT Stock FROM Medicine WHERE ID = @medID)
	UPDATE Medicine
	SET Stock = @oldStock + @amt
	WHERE ID = @medID

	DELETE FROM MedLog
	WHERE MedLogID = @MedLogID

	RETURN 0
END
GO
/****** Object:  StoredProcedure [dbo].[DeleteMedPlan]    Script Date: 5/18/2022 1:48:58 AM ******/
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
/****** Object:  StoredProcedure [dbo].[DeleteOnDuty]    Script Date: 5/18/2022 1:48:58 AM ******/
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
/****** Object:  StoredProcedure [dbo].[DeleteShift]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteShift]
	(@ShiftID [int])
AS
BEGIN
	--Validates parameters
	IF (@ShiftID is null)
	BEGIN
		RAISERROR('VolunteerID provided is null', 14, 1);
		RETURN 1
	END
	IF (NOT EXISTS (SELECT * FROM [Shift] WHERE [ID] = @ShiftID))
	BEGIN
		RAISERROR('Provided ShiftID does not exist.', 14, 1);
		RETURN 2
	END

	DELETE OnDuty
	WHERE OnDuty.ShiftID = @ShiftID

	DELETE [Shift]
	WHERE ( [ID] = @ShiftID)

	RETURN 0;
END
GO
/****** Object:  StoredProcedure [dbo].[DeleteVolunteer]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteVolunteer]
	(@VolunteerID [int])
AS
BEGIN
	--Validates parameters
	IF (@VolunteerID is null)
	BEGIN
		RAISERROR('VolunteerID provided is null', 14, 1);
		RETURN 1
	END
	IF (NOT EXISTS (SELECT * FROM [Volunteer] WHERE [ID] = @VolunteerID))
	BEGIN
		RAISERROR('Provided VolunteerID does not exist.', 14, 1);
		RETURN 2
	END

	DELETE [OnDuty]
	WHERE OnDuty.VolunteerID = @VolunteerID

	DELETE [Volunteer]
	WHERE ( [ID] = @VolunteerID)
END
GO
/****** Object:  StoredProcedure [dbo].[FetchAllVolunteers_CanGiveMeds]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Grant Giles
-- Create date: 5/11/2022
-- Description:	Fetch all volunteers that can give meds to dogs
-- =============================================
CREATE PROCEDURE [dbo].[FetchAllVolunteers_CanGiveMeds]
AS
BEGIN
	SELECT * FROM VolunteerFullName
	JOIN Volunteer ON VolunteerFullName.ID = Volunteer.ID
	WHERE CanGiveMed = 1
END
GO
/****** Object:  StoredProcedure [dbo].[GetBRLogsForDogID]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Grant Giles
-- Create date: 4/27/2022
-- Description:	Get all bathroom logs for a given dog ID
-- =============================================
CREATE PROCEDURE [dbo].[GetBRLogsForDogID] (
	@dID int
)
AS
BEGIN

	IF (@dID IS NULL)
	BEGIN
		RAISERROR('dID cannot be null', 14, 1)
		RETURN 1;
	END

	SELECT BRLog.ID AS ID, Dog.ID AS DogID,
			FORMAT(CONVERT(datetime, [Time]), 'hh\:mm tt') AS [Time],
			FORMAT([Date], 'MM/dd/yyyy') AS [Date],
			[Type], Note, [Name]
	FROM BRLog
	JOIN Dog ON BRLog.DogID = Dog.ID
	WHERE BRLog.DogID = @dID
	ORDER BY [Date] DESC, [Time] DESC

	RETURN 0

END
GO
/****** Object:  StoredProcedure [dbo].[GetLoginCredential]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetLoginCredential]
(
	@username varchar(8)
)
AS
BEGIN
	IF(@username is null)
	BEGIN
		RAISERROR('username cannot be null', 14, 1);
		RETURN 1;
	END

	SELECT * FROM [Login] WHERE Username = @username
	return 0;
END
GO
/****** Object:  StoredProcedure [dbo].[GetMedPlansForDogID]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Grant Giles
-- Create date: 5/09/2022
-- Description:	Get all med plans for a given dog ID
-- =============================================
CREATE   PROCEDURE [dbo].[GetMedPlansForDogID] (
	@DogID int
)
AS
BEGIN
IF @DogID IS NULL
BEGIN
	RAISERROR('Must supply an id', 14, 1)
	RETURN 1
END

SELECT *
FROM [MedPlanDetailFormatted]
WHERE MedPlanDetailFormatted.DogID = @DogID

RETURN 0
END
GO
/****** Object:  StoredProcedure [dbo].[GetVolunteersOnDuty]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetVolunteersOnDuty]
(
	@ID int = null
)
AS
BEGIN
	IF (@ID is null)
	BEGIN
		SELECT * FROM OnDutyDetailFormatted ORDER BY [Date] DESC, [StartTime] ASC;
		RETURN 0;
	END
	ELSE
	BEGIN
		SELECT * FROM OnDutyDetailFormatted WHERE ShiftID = @ID;
		RETURN 0;
	END

END
GO
/****** Object:  StoredProcedure [dbo].[SearchBRLogByDogID]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Grant Giles
-- Create date: 4/27/2022
-- Description:	Get all bathroom logs for a given dog ID
-- =============================================
CREATE   PROCEDURE [dbo].[SearchBRLogByDogID] (
	@id int
)
AS
BEGIN

	IF (@id IS NULL)
	BEGIN
		RAISERROR('dID cannot be null', 14, 1)
		RETURN 1;
	END

	SELECT * FROM [BRLogDetailFormatted]
	WHERE DogID = @id
	ORDER BY [Date] DESC, [Time] DESC

	RETURN 0

END
GO
/****** Object:  StoredProcedure [dbo].[SearchBRLogByID]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Grant Giles
-- Create date: 4/28/2022
-- Description:	Get the bathroom log with the given ID
-- =============================================
CREATE PROCEDURE [dbo].[SearchBRLogByID] (
	@id int
)
AS
BEGIN
IF @id IS NULL
BEGIN
	RAISERROR('Must supply an id', 14, 1)
	RETURN 1
END

SELECT *
FROM BRLogDetailFormatted
WHERE ID = @id

RETURN 0
END
GO
/****** Object:  StoredProcedure [dbo].[SearchDogByID]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SearchDogByID]
(
	@ID int = null
)
AS 
BEGIN
	IF (@ID is null)
	BEGIN
		SELECT ID, [Name], WeightInlbs, hasBeenSpayed, FORMAT(DateOfBirth, 'MM/dd/yyyy') AS [DateOfBirth], Sex, Breed, Information, GeneralInstruction, Age, FeedInstruction
		FROM Dog;
		RETURN 0;
	END
	ELSE
	BEGIN
		SELECT ID, [Name], WeightInlbs, hasBeenSpayed, FORMAT(DateOfBirth, 'MM/dd/yyyy') AS [DateOfBirth], Sex, Breed, Information, GeneralInstruction, Age, FeedInstruction
		FROM Dog WHERE ID = @ID
		RETURN 0;
	END
END
GO
/****** Object:  StoredProcedure [dbo].[SearchDogByName]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SearchDogByName] (
	@name_search nvarchar(50) = null
)
AS
BEGIN
IF @name_search IS NULL OR @name_search = ''
BEGIN
	SELECT *
	FROM Dog 
	ORDER BY [Name] ASC
END
ELSE
BEGIN
	SELECT *
	FROM Dog
	WHERE CHARINDEX(LOWER(@name_search), LOWER(Dog.Name)) != 0
	ORDER BY [Name] ASC
END

RETURN 0
END
GO
/****** Object:  StoredProcedure [dbo].[SearchFoodByID]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SearchFoodByID]
(
	@ID int = null
)
AS
BEGIN
	IF (@ID is null)
	BEGIN
		SELECT * FROM Food ORDER BY [Name] ASC;
		RETURN 0;
	END
	ELSE
	BEGIN
		SELECT * FROM Food WHERE ID = @ID
		RETURN 0;
	END

END
GO
/****** Object:  StoredProcedure [dbo].[SearchFoodByName]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SearchFoodByName]
(
	@Name int = null
)
AS
BEGIN
	IF (@Name is null)
	BEGIN
		SELECT * FROM Food ORDER BY [Name] ASC;
		RETURN 0;
	END
	ELSE
	BEGIN
		SELECT * FROM Food WHERE [Name] = @Name ORDER BY [Name] ASC;
		RETURN 0;
	END

END
GO
/****** Object:  StoredProcedure [dbo].[SearchMealLogByDogID]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SearchMealLogByDogID]
(
	@DogID int = null
)
AS
BEGIN
	IF (@DogID is null)
	BEGIN
		SELECT * FROM MealLogDetailFormatted ORDER BY [Date] DESC, [TIME] ASC
		RETURN 0;
	END
	ELSE
	BEGIN
		SELECT * FROM MealLogDetailFormatted WHERE DogID = @DogID ORDER BY [Date] DESC, [TIME] ASC
		RETURN 0;
	END
END
GO
/****** Object:  StoredProcedure [dbo].[SearchMealLogByID]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SearchMealLogByID]
(
	@ID int = null
)
AS
BEGIN
	IF (@ID is null)
	BEGIN
		SELECT * FROM MealLogDetailFormatted ORDER BY [Date] DESC, [Time] ASC;
		RETURN 0;
	END
	ELSE
	BEGIN
		SELECT * FROM MealLogDetailFormatted WHERE ID = @ID ORDER BY [Date] DESC, [Time] ASC;
		RETURN 0;
	END

END
GO
/****** Object:  StoredProcedure [dbo].[SearchMedByID]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SearchMedByID]
(
	@ID int = null
)
AS
BEGIN
	IF (@ID is null)
	BEGIN
		SELECT * FROM Medicine ORDER BY [Name] ASC;
		RETURN 0;
	END
	ELSE
	BEGIN
		SELECT * FROM Medicine WHERE ID = @ID ORDER BY [Name] ASC;
		RETURN 0;
	END

END
GO
/****** Object:  StoredProcedure [dbo].[SearchMedByName]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Grant Giles
-- Create date: 5/09/2022
-- Description:	Search medications for the given med name
-- =============================================
CREATE PROCEDURE [dbo].[SearchMedByName] (
	@NameSearch varchar(50)
)
AS
BEGIN

IF @NameSearch IS NULL OR @NameSearch = ''
BEGIN
	SELECT *
	FROM Medicine 
	ORDER BY [Name] ASC
END
ELSE
BEGIN
	SELECT *
	FROM Medicine
	WHERE CHARINDEX(LOWER(@NameSearch), LOWER(Medicine.[Name])) != 0
	ORDER BY [Name] ASC
END

RETURN 0
END
GO
/****** Object:  StoredProcedure [dbo].[SearchMedLogByDogID]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SearchMedLogByDogID]
(
	@DogID int = null
)
AS
BEGIN
	IF (@DogID is null)
	BEGIN
		SELECT * FROM MedLogDetailFormatted ORDER BY [Date] DESC, [TIME] ASC
		RETURN 0;
	END
	ELSE
	BEGIN
		SELECT * FROM MedLogDetailFormatted WHERE DogID = @DogID 
		RETURN 0;
	END
END
GO
/****** Object:  StoredProcedure [dbo].[SearchMedLogByID]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SearchMedLogByID]
(
	@ID int = null
)
AS
BEGIN
	IF (@ID is null)
	BEGIN
		SELECT * FROM MedLogDetailFormatted ORDER BY [Date] DESC, [TIME] ASC
		RETURN 0;
	END
	ELSE
	BEGIN
		SELECT * FROM MedLogDetailFormatted WHERE ID = @ID 
		RETURN 0;
	END
END
GO
/****** Object:  StoredProcedure [dbo].[SearchMedPlanByID]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Grant Giles
-- Create date: 5/09/2022
-- Description:	Get all med plans for a given dog ID
-- =============================================
CREATE   PROCEDURE [dbo].[SearchMedPlanByID] (
	@id int
)
AS
BEGIN
IF @id IS NULL
BEGIN
	RAISERROR('Must supply an id', 14, 1)
	RETURN 1
END

SELECT *
FROM [MedPlanDetailFormatted]
WHERE MedPlanID = @id

RETURN 0
END
GO
/****** Object:  StoredProcedure [dbo].[SearchMedPlansByID]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Grant Giles
-- Create date: 5/09/2022
-- Description:	Get all med plans for a given dog ID
-- =============================================
CREATE PROCEDURE [dbo].[SearchMedPlansByID] (
	@id int
)
AS
BEGIN
IF @id IS NULL
BEGIN
	RAISERROR('Must supply an id', 14, 1)
	RETURN 1
END

SELECT *
FROM [MedPlanDetailFormatted]
WHERE MedPlanID = @id

RETURN 0
END
GO
/****** Object:  StoredProcedure [dbo].[SearchShiftByID]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SearchShiftByID]
(
	@ID int = null
)
AS
BEGIN
	IF (@ID is null)
	BEGIN
		SELECT * FROM ShiftFormatted ORDER BY [Date] DESC, [StartTime] ASC;
		RETURN 0;
	END
	ELSE
	BEGIN
		SELECT * FROM ShiftFormatted WHERE ID = @ID ORDER BY [Date] DESC, [StartTime] ASC;
		RETURN 0;
	END

END
GO
/****** Object:  StoredProcedure [dbo].[SearchVolunteerByID]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SearchVolunteerByID]
(
	@ID int = null
)
AS
BEGIN
	IF (@ID is null)
	BEGIN
		SELECT Volunteer.ID, [Name], FirstName, LastName, FORMAT(DateOfBirth, 'MM/dd/yyyy') AS [DateOfBirth], Sex, FORMAT(MemberSince, 'MM/dd/yyyy') AS MemberSince, Age, CanGiveMed, FORMAT(ServicesEndOn, 'MM/dd/yyyy') AS ServicesEndOn
		FROM VolunteerFullName JOIN Volunteer ON VolunteerFullName.ID = Volunteer.ID ORDER BY [Name] ASC;
		RETURN 0;
	END
	ELSE
	BEGIN
		SELECT Volunteer.ID, [Name], FirstName, LastName, FORMAT(DateOfBirth, 'MM/dd/yyyy') AS [DateOfBirth], Sex, FORMAT(MemberSince, 'MM/dd/yyyy') AS MemberSince, Age, CanGiveMed, FORMAT(ServicesEndOn, 'MM/dd/yyyy') AS ServicesEndOn
		FROM VolunteerFullName 
		JOIN Volunteer ON VolunteerFullName.ID = Volunteer.ID
		WHERE Volunteer.ID = @ID
		ORDER BY [Name] ASC;

		RETURN 0;
	END

END
GO
/****** Object:  StoredProcedure [dbo].[SearchVolunteerByName]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[SearchVolunteerByName] (
	@name_search nvarchar(50) = null
)
AS
BEGIN
IF @name_search IS NULL OR @name_search = ''
BEGIN
	SELECT Volunteer.ID, FirstName, LastName, FORMAT(DateOfBirth, 'MM/dd/yyyy') AS [DateOfBirth], Sex, FORMAT(MemberSince, 'MM/dd/yyyy') AS MemberSince, Age, CanGiveMed, FORMAT(ServicesEndOn, 'MM/dd/yyyy') AS ServicesEndOn
	FROM Volunteer
	ORDER BY [LastName] ASC
END
ELSE
BEGIN
	SELECT *
	FROM Volunteer
	WHERE CHARINDEX(LOWER(@name_search), LOWER(Volunteer.LastName)) != 0
	ORDER BY [LastName] ASC
END

RETURN 0
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateBRLog]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateBRLog]
(
	--exactly one of name and id has to be provided
	@ID int = null,
	@dName varchar(50) = null, 
	@dID int = null,
	@time varchar(10) = null,
	@date varchar(10) = null,
	@type varchar(30) = null, 
	@Note varchar(200) = null
)
AS
BEGIN
	if (@ID is null or not exists (SELECT * FROM BRLog WHERE ID = @ID))
	BEGIN
		RAISERROR('invalid bathroom log id', 14, 96);
		RETURN 96;
	END

	if(@dID is null and @dName is null)
	BEGIN
		RAISERROR('dog info needed', 14, 1);
		
		RETURN 1;
	END

	if (@type is null) 
	BEGIN
		RAISERROR('entry description needed', 14, 25);
		
		RETURN 25;
	END

	if (@dID is not null and @dName is not null)
	BEGIN
		RAISERROR('Only one of dog ID and dog name needed', 14, 3);
		
		RETURN 3;
	END

	--ID value to make the final insertion
	DECLARE @dbDogID int = null;

	--dName is provided. dID is null
	if (@dName is not null)
	BEGIN
		--No dog with given name
		if (not exists(SELECT * FROM Dog WHERE [name] = @dName))
		BEGIN
			RAISERROR('dog does not exist', 14, 5);
			
			RETURN 5;
		END
		--More than one dog with the given name
		else if (not exists(SELECT [Name] FROM Dog WHERE [name] = @dName GROUP BY [name] HAVING count(*) = 1))
		BEGIN
			RAISERROR('there is more than one dog with the given name.', 14, 6);
			
			RETURN 6;
		END
		--The dog name is valid
		else
		BEGIN
			SET @dbDogID = (SELECT ID FROM Dog WHERE [Name] = @dName)
		END
	END

	--Dog ID is provided. Name is null.
	else if (@dID is not null)
	BEGIN
		if(not exists(SELECT * FROM Dog WHERE ID = @dID))
		BEGIN
			RAISERROR('the given dog ID does not exist.', 14, 7);
			
			RETURN 7;
		END
		else 
		BEGIN
			SET @dbDogID = @dID
		END
	END

	DECLARE @convDate Date
	DECLARE @convTime time(0)

	if (@date is null)
	BEGIN
		SET @convDate = convert(date, GETDATE())
	END
	else 
	BEGIN
		SET @convDate = Try_Convert(Date, @date)
	END

	if (@time is null)
	BEGIN 
		SET @convTime = convert(time(0), GETDATE())
	END
	else
	BEGIN
		SET @convTime = Try_Convert(time(0), @time)
	END

	if (@convDate is null) 
	BEGIN
		RAISERROR('Invalid date', 14, 85);
		RETURN 85;
	END

	if (@convTime is null) 
	BEGIN
		RAISERROR('Invalid time', 14, 86);
		RETURN 86;
	END

	IF @convDate > GETDATE()
	BEGIN
		RAISERROR('Cannot put bathroom log from the future', 14, 8);
		RETURN 8;
	END


	UPDATE BRLog
	SET DogID = @dbDogID, [Time] = @convTime, [Date] = @convDate, [Type] = @type, Note = @Note
	WHERE ID = @ID
	RETURN 0;

	SELECT * FROM BRLogDetailFormatted WHERE BRLogDetailFormatted.ID = @ID

END

GO
/****** Object:  StoredProcedure [dbo].[UpdateDog]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[UpdateDog]
	(@ID int,
	@Name varchar(50),
	@WeightInlbs int = null,
	@hasBeenSpayed bit = null,
	@DOB varchar(10) = null,
	@Sex varchar(20) = null,
	@Breed varchar(50) = null,
	@Information varchar(500) = null,
	@GeneralInstruction varchar(500) = null,
	@FeedInstruction varchar(500) = null
)
AS
BEGIN
	--Validates parameters
	IF (@ID is null)
	BEGIN
		RAISERROR('DogID provided is null', 14, 1);
		RETURN 1
	END
	if (@name is null)
	BEGIN
		RAISERROR('dog name cannot be null', 14, 3);
		RETURN 3;
	END
	IF (NOT EXISTS (SELECT * FROM [Dog] WHERE [ID] = @ID))
	BEGIN
		RAISERROR('Provided DogID does not exist.', 14, 2);
		RETURN 2
	END

	DECLARE @convDate date = null
	if (@DOB is not null)
	BEGIN
		SET @convDate = TRY_CONVERT(date, @DOB);
		if (@convDate is null)
		BEGIN
			RAISERROR('invalid dob', 14, 55);
			RETURN 55;
		END
	END

	IF @convDate > GETDATE()
	BEGIN
		RAISERROR('Dog cannot be born in the future', 14, 56);
		RETURN 56;
	END

	

	UPDATE [Dog]
	SET [Name] = @Name, [WeightInlbs] = @WeightInlbs, [hasBeenSpayed] = @hasBeenSpayed, 
		[DateOfBirth] = @convDate, [Sex] = @Sex, [Breed] = @breed, 
		[Information] = @Information, [GeneralInstruction] = @GeneralInstruction, 
		[FeedInstruction] = @FeedInstruction
	WHERE ([ID] = @ID)
	RETURN 0;


	
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateFood]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[UpdateFood] 
(
	@ID int,
	@name nvarchar(50),
	@Instructions nvarchar(500) = null,
	@boughtFrom nvarchar(50) = null,
	@Stock decimal(4,1) = 0,
	@UnitPerStock varchar(10) = null
)
AS 
BEGIN
	if (@ID is null or not exists(SELECT * FROM Food WHERE ID = @ID))
	BEGIN
		RAISERROR('invalid food id', 14, 98);
		RETURN 98;
	END
		
	IF(@name is null)
	BEGIN
		RAISERROR('name cannot be null', 14, 1);
		
		RETURN 1;
	END

	IF(@Stock is not null and @stock < 0)
	BEGIN
		RAISERROR('stock must not be negative', 14, 2);
		
		RETURN 2;
	END

	UPDATE Food
	SET [Name] = @name, Instructions = @Instructions, boughtFrom = @boughtFrom, Stock = @Stock, UnitPerStock = @UnitPerStock
	WHERE ID = @ID
	RETURN 0;

END

GO
/****** Object:  StoredProcedure [dbo].[UpdateMealLog]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateMealLog]
(
	--exactly one of name and id has to be provided
	@MealLogID int, 
	@dName varchar(50),  --dog name
	@dId int, -- dog id
	@fName varchar(50), --food name
	@fId int, --food id
	@date varchar(10) = null, --will be converted later
	@time varchar(10) = null, --will be converted later
	@amount varchar(10) = null,
	@Note varchar(100) = null
)
AS

BEGIN
	if (@MealLogID is null or not exists(SELECT * FROM MealLog WHERE MealLogId = @MealLogID))
	BEGIN
		RAISERROR('invalid meal log id', 14, 99);
		RETURN 99;
	END

	if(@dID is null and @dName is null)
	BEGIN
		RAISERROR('dog info needed', 14, 1);
		
		RETURN 1;
	END

	if (@fID is null and @fName is null)
	BEGIN
		RAISERROR('food info needed', 14, 2);
		
		RETURN 2;
	END

	if (@dID is not null and @dName is not null)
	BEGIN
		RAISERROR('Only one of dog ID and dog name needed', 14, 3);
		
		RETURN 3;
	END

	if (@fID is not null and @fName is not null)
	BEGIN 
		RAISERROR('Only one of food ID and food name needed', 14, 4);
		
		RETURN 4;
	END

	--ID value to make the final insertion
	DECLARE @dbDogID int = null;

	--dName is provided. dID is null
	if (@dName is not null)
	BEGIN
		--No dog with given name
		if (not exists(SELECT * FROM Dog WHERE [name] = @dName))
		BEGIN
			RAISERROR('dog does not exist', 14, 5);
			
			RETURN 5;
		END
		--More than one dog with the given name
		else if (not exists(SELECT [Name] FROM Dog WHERE [name] = @dName GROUP BY [name] HAVING count(*) = 1))
		BEGIN
			RAISERROR('there is more than one dog with the given name.', 14, 6);
			
			RETURN 6;
		END
		--The dog name is valid
		else
		BEGIN
			SET @dbDogID = (SELECT ID FROM Dog WHERE [Name] = @dName)
		END
	END


	--Dog Id is provided. Name is null.
	else if (@dId is not null)
	BEGIN
		if(not exists(SELECT * FROM Dog WHERE ID = @dId))
		BEGIN
			RAISERROR('the given dog ID does not exist.', 14, 7);
			
			RETURN 7;
		END
		else 
		BEGIN
			SET @dbDogID = @dId
		END
	END

	--ID value to make the final insertion
	DECLARE @newFoodID int = null;

	--fName is provided. fID is null
	if (@fName is not null)
	BEGIN
		--No food with given name
		if (not exists(SELECT * FROM Food WHERE [name] = @fName))
		BEGIN
			RAISERROR('food name does not exist', 14, 8);
			
			RETURN 8;
		END
		--More than one food with the given name
		else if (not exists(SELECT [Name] FROM Food WHERE [name] = @fName GROUP BY [name] HAVING count(*) = 1))
		BEGIN
			RAISERROR('there is more than one food with the given name.', 14, 9);
			
			RETURN 9;
		END
		--The food name is valid
		else
		BEGIN
			SET @newFoodID = (SELECT ID FROM food WHERE [Name] = @fName)
		END
	END


	--Food Id is provided. Name is null.
	else if (@fId is not null)
	BEGIN
		if(not exists(SELECT * FROM Food WHERE ID = @fId))
		BEGIN
			RAISERROR('the given food ID does not exist.', 14, 10);
			
			RETURN 10;
		END
		else 
		BEGIN
			SET @newFoodID = @fId
		END
	END

	DECLARE @convDate Date
	DECLARE @convTime time(0)

	if (@date is null)
	BEGIN
		SET @convDate = convert(date, GETDATE())
	END
	else 
	BEGIN
		SET @convDate = Try_Convert(Date, @date)
	END

	if (@time is null)
	BEGIN 
		SET @convTime = convert(time(0), convert(varchar(5), (convert(time(0), GETDATE()))))
	END
	else
	BEGIN
		SET @convTime = Try_Convert(time(0), @time)
	END


	if (@convDate is null) 
	BEGIN
		RAISERROR('Invalid date', 14, 85);
		RETURN 85;
	END

	if (@convTime is null) 
	BEGIN
		RAISERROR('Invalid time', 14, 86);
		RETURN 86;
	END

	IF @convDate > GETDATE()
	BEGIN
		RAISERROR('Cannot put meal log from the future', 14, 87);
		RETURN 87;
	END

	DECLARE @oldAmt decimal(4,1)
	SET @oldAmt = (SELECT Amount FROM MealLog WHERE MealLogID = @MealLogID)

	DECLARE @newStock decimal(4,1)
	DECLARE @newFoodCurrStock decimal(4,1)
	DECLARE @oldFoodID int
	DECLARE @oldFoodCurrStock decimal(4,1)
	SET @oldFoodID = (SELECT FoodID FROM MealLog WHERE MealLogID = @MealLogID)
	SET @oldFoodCurrStock = (SELECT stock FROM Food WHERE ID = @oldFoodID)
	SET @newFoodCurrStock = (SELECT stock FROM Food WHERE ID = @newFoodID)
	
	if (@oldFoodID = @newFoodID) 
	BEGIN
		SET @newStock = @newFoodCurrStock + @oldAmt - @amount

		if (@newStock < 0) 
		BEGIN
			RAISERROR('Not enough item in stock', 14, 67);
			RETURN 67;
		END

		UPDATE Food SET Stock = @newStock WHERE ID = @newFoodID
	END
	ELSE 
	BEGIN
		SET @newStock = @newFoodCurrStock - @amount

		if (@newStock < 0) 
		BEGIN
			RAISERROR('Not enough item in stock', 14, 67);
			RETURN 67;
		END

		UPDATE Food SET Stock = @oldFoodCurrStock + @oldAmt WHERE ID = @oldFoodID
		UPDATE Food SET Stock = @newFoodCurrStock - @amount WHERE ID = @newFoodID
	END
		

	UPDATE MealLog
	SET DogID = @dbDogID, FoodID = @newFoodID, [Date] = @convDate, [Time] = @convTime, Amount = @amount, Note = @Note
	WHERE MealLogID = @MealLogID


	RETURN 0;

END
GO
/****** Object:  StoredProcedure [dbo].[UpdateMed]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateMed]
	(
	@ID int,
	@name varchar(50),
	@directions varchar(500) = null,
	@neededFor varchar(200) = null,
	@boughtFrom varchar(50) = null,
	@stock int = 0,
	@UnitPerStock varchar(10) = null
	)
AS
BEGIN

	if (@ID is null or not exists(SELECT * FROM Medicine WHERE ID = @ID)) 
	BEGIN
		RAISERROR('invalid ID', 14, 1);
		RETURN 1;
	END

	if (@name is null)
	BEGIN
		RAISERROR('invalid name', 14, 2);
		RETURN 2;
	END

	
	UPDATE Medicine
	SET [Name] = @Name, Directions = @directions, neededFor = @neededFor, BoughtFrom = @boughtFrom, Stock = @stock, UnitPerStock = @UnitPerStock
	WHERE ID = @ID
	RETURN 0;

END
GO
/****** Object:  StoredProcedure [dbo].[UpdateMedLog]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[UpdateMedLog]
(
	--exactly one of name and id has to be provided
	@MedLogID int,
	@dName varchar(50) = null, 
	@dID int, 
	----For Volunteer, accepted parameter forms are : FirstName || LastName || FirstName and LastName || ID
	@vfn varchar(50) = null, --volunteer first name
	@vln varchar(50) = null, --volunteer last name
	@vID int, --volunteer id
	@mName varchar(50) = null,
	@mID int,
	@date varchar(10) = null, 
	@time varchar(10) = null,
	@amount varchar(10) = null,
	@Note varchar(100) = null
)
AS
BEGIN
	
	if (@MedLogID is null or not exists(SELECT * FROM MedLog WHERE MedLogID = @MedLogID))
	BEGIN
		RAISERROR('invalid med log id', 14, 99);
		RETURN 99;
	END

	if(@dID is null and @dName is null)
	BEGIN
		RAISERROR('dog info needed', 14, 1);
		RETURN 1;
	END

	if (@mID is null and @mName is null)
	BEGIN
		RAISERROR('med info needed', 14, 2);
		RETURN 2;
	END

	if (@vfn is null and @vln is null and @vID is null)
	BEGIN
		RAISERROR('volunteer info needed', 14, 13);
		RETURN 13;
	END

	if (@dID is not null and @dName is not null)
	BEGIN
		RAISERROR('Only one of dog ID and dog name needed', 14, 3);
		RETURN 3;
	END

	if (@mID is not null and @mName is not null)
	BEGIN 
		RAISERROR('Only one of med ID and med name needed', 14, 4);
		RETURN 4;
	END

	if ((@vfn is not null or @vln is not null) and @vID is not null)
	BEGIN
		RAISERROR('Only one of volunteer ID and volunteer full name is needed', 14, 13);
		RETURN 13;
	END

	--ID value to make the final insertion
	DECLARE @dbDogID int = null;

	--dName is provided. dID is null
	if (@dName is not null)
	BEGIN
		--No dog with given name
		if (not exists(SELECT * FROM Dog WHERE [name] = @dName))
		BEGIN
			RAISERROR('dog does not exist', 14, 5);
			RETURN 5;
		END
		--More than one dog with the given name
		else if (not exists(SELECT [Name] FROM Dog WHERE [name] = @dName GROUP BY [name] HAVING count(*) = 1))
		BEGIN
			RAISERROR('there is more than one dog with the given name.', 14, 6);
			RETURN 6;
		END
		--The dog name is valid
		else
		BEGIN
			SET @dbDogID = (SELECT ID FROM Dog WHERE [Name] = @dName)
		END
	END


	--Dog ID is provided. Name is null.
	else if (@dID is not null)
	BEGIN
		if(not exists(SELECT * FROM Dog WHERE ID = @dID))
		BEGIN
			RAISERROR('the given dog ID does not exist.', 14, 7);
			RETURN 7;
		END
		else 
		BEGIN
			SET @dbDogID = @dID
		END
	END

	--ID value to make the final insertion
	DECLARE @newMedID int = null;

	--mName is provided. mID is null
	if (@mName is not null)
	BEGIN
		--No med with given name
		if (not exists(SELECT * FROM Medicine WHERE [name] = @mName))
		BEGIN
			RAISERROR('med name does not exist', 14, 8);
			RETURN 8;
		END
		--More than one med with the given name
		else if (not exists(SELECT [Name] FROM Medicine WHERE [name] = @mName GROUP BY [name] HAVING count(*) = 1))
		BEGIN
			RAISERROR('there is more than one med with the given name.', 14, 9);
			RETURN 9;
		END
		--The med name is valid
		else
		BEGIN
			SET @newMedID = (SELECT ID FROM Medicine WHERE [Name] = @mName)
		END
	END

	--med ID is provided. Name is null.
	else if (@mID is not null)
	BEGIN
		if(not exists(SELECT * FROM Medicine WHERE ID = @mID))
		BEGIN
			RAISERROR('the given med ID does not exist.', 14, 10);
			RETURN 10;
		END
		else 
		BEGIN
			SET @newMedID = @mID
		END
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
			--More than one volunteer with the given first name
			else if (not exists(SELECT FirstName FROM Volunteer WHERE FirstName = @vfn and LastName = @vln GROUP BY FirstName, LastName HAVING count(*) = 1))
			BEGIN
				RAISERROR('there is more than one volunteer with the given full name.', 14, 21);
				RETURN 25;
			END
			--The first name is valid
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

	DECLARE @convDate Date
	DECLARE @convTime time(0)

	if (@date is null)
	BEGIN
		SET @convDate = convert(date, GETDATE())
	END
	else 
	BEGIN
		SET @convDate = Try_Convert(Date, @date)
	END

	if (@time is null)
	BEGIN 
		SET @convTime = convert(time(0), convert(varchar(5), (convert(time(0), GETDATE()))))
	END
	else
	BEGIN
		SET @convTime = Try_Convert(time(0), @time)
	END


	if (@convDate is null) 
	BEGIN
		RAISERROR('Invalid date', 14, 85);
		RETURN 85;
	END

	if (@convTime is null) 
	BEGIN
		RAISERROR('Invalid time', 14, 86);
		RETURN 86;
	END

	IF @convDate > GETDATE()
	BEGIN
		RAISERROR('Cannot put medication log from the future', 14, 87);
		RETURN 87;
	END

	DECLARE @oldAmt decimal(4,1)
	SET @oldAmt = (SELECT Amount FROM MedLog WHERE MedLogID = @MedLogID)

	DECLARE @newStock decimal(4,1)
	DECLARE @newMedCurrStock decimal(4,1)
	DECLARE @oldMedID int
	DECLARE @oldMedCurrStock decimal(4,1)
	SET @oldMedID = (SELECT MedID FROM MedLog WHERE MedLogID = @MedLogID)
	SET @oldMedCurrStock = (SELECT stock FROM Medicine WHERE ID = @oldMedID)
	SET @newMedCurrStock = (SELECT stock FROM Medicine WHERE ID = @newMedID)
	
	if (@oldMedID = @newMedID) 
	BEGIN
		SET @newStock = @newMedCurrStock + @oldAmt - @amount

		if (@newStock < 0) 
		BEGIN
			RAISERROR('Not enough item in stock', 14, 67);
			RETURN 67;
		END

		UPDATE Medicine SET Stock = @newStock WHERE ID = @newMedID
	END
	ELSE 
	BEGIN
		SET @newStock = @newMedCurrStock - @amount

		if (@newStock < 0) 
		BEGIN
			RAISERROR('Not enough item in stock', 14, 67);
			RETURN 67;
		END

		UPDATE Medicine SET Stock = @oldMedCurrStock + @oldAmt WHERE ID = @oldMedID
		UPDATE Medicine SET Stock = @newMedCurrStock - @amount WHERE ID = @newMedID
	END

	UPDATE MedLog
	SET DogID = @dbDogID, VolunteerID = @dbVID, MedID = @newMedID,
		[Date] = @convDate, [Time] = @convTime, Amount = @amount, Note = @Note
	WHERE MedLogID = @MedLogID
	RETURN 0;

END
GO
/****** Object:  StoredProcedure [dbo].[UpdateMedPlan]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateMedPlan]
(
	--exactly one of name and id has to be provided
	@MedPlanID int,
	@dID int, --dog id
	@mID int, --med id
	@startDate date = null, 
	@endDate date = null,
	@DR varchar(100) = null,
	@SI varchar(200) = null
)
AS
BEGIN
	
	if (@MedPlanID is null or not exists(SELECT * FROM MedPlan WHERE MedPlanID = @MedPlanID))
	BEGIN
		RAISERROR('invalid med plan id', 14, 40);
		RETURN 40;
	END

	if (@startDate is null)
	BEGIN
		SET @startDate = convert(date, GETDATE())
	END

	IF(@endDate < @startDate)
	BEGIN
		RAISERROR('endDate cannot be before startDate', 14, 3);
		RETURN 3;
	END

	if(@dID is null)
	BEGIN
		RAISERROR('dog info needed', 14, 1);
		RETURN 1;
	END

	if (@mID is null)
	BEGIN
		RAISERROR('med info needed', 14, 2);
		RETURN 2;
	END

	--Dog ID is provided. Name is null.
	if(not exists(SELECT * FROM Dog WHERE ID = @dID))
	BEGIN
		RAISERROR('the given dog ID does not exist.', 14, 7);
		RETURN 7;
	END

	if(not exists(SELECT * FROM Medicine WHERE ID = @mID))
	BEGIN
		RAISERROR('the given med ID does not exist.', 14, 10);
		RETURN 10;
	END

	Update MedPlan
	SET DogID = @dID, medID = @mID, StartDate = @startDate, EndDate = @endDate, DosageRegime = @DR, SpecialInstruction = @SI
	WHERE MedPlanID = @MedPlanID

	SELECT *
	FROM MedPlanDetailFormatted
	WHERE MedPlanID = @MedPlanID

	RETURN 0;

END
GO
/****** Object:  StoredProcedure [dbo].[UpdateOnDuty]    Script Date: 5/18/2022 1:48:58 AM ******/
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
/****** Object:  StoredProcedure [dbo].[UpdateShift]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateShift]
(
	@ID int,
	@StartTime varchar(10) = null,
	@Span decimal(2,1), 
	@Date varchar(10) = null,
	@TODO varchar(500) = null,
	@Note varchar(500) = null
)
AS
BEGIN
	if (@ID is null or not exists(SELECT * FROM [Shift] WHERE ID = @ID))
	BEGIN
		RAISERROR('invalid shift id', 14, 97);
		RETURN 97;
	END

	DECLARE @convDate Date
	DECLARE @convTime time(0)

	if (@date is null)
	BEGIN
		SET @convDate = convert(date, GETDATE())
	END
	else 
	BEGIN
		SET @convDate = Try_Convert(Date, @date)
	END

	if (@StartTime is null)
	BEGIN 
		SET @convTime = convert(time(0), convert(varchar(5), (convert(time(0), GETDATE()))))
	END
	else
	BEGIN
		SET @convTime = Try_Convert(time(0), @StartTime)
	END


	if (@convDate is null) 
	BEGIN
		RAISERROR('Invalid date', 14, 85);
		RETURN 85;
	END

	if (@convTime is null) 
	BEGIN
		RAISERROR('Invalid time', 14, 86);
		RETURN 86;
	END


	UPDATE [Shift]
	SET StartTime = @convTime, Span = @Span, [Date] = @convDate, TODO = @todo, Note = @note
	WHERE ID = @ID

	SELECT * FROM [Shift] WHERE ID = @ID
	RETURN 0;

END

/****** Object:  Trigger [dbo].[MedGiverEligibility]    Script Date: 5/19/2022 8:53:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[MedGiverEligibility]
ON [dbo].[MedLog]
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
GO

ALTER TABLE [dbo].[MedLog] ENABLE TRIGGER [MedGiverEligibility]
GO


/****** Object:  Trigger [dbo].[OneShiftLeader]    Script Date: 5/19/2022 8:53:35 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE TRIGGER [dbo].[OneShiftLeader] ON [dbo].[OnDuty]
AFTER INSERT, UPDATE
AS
BEGIN
	
	--more than one leader for some shift
	if (exists(SELECT ShiftID FROM Inserted WHERE isShiftLeader = 1 GROUP BY [ShiftID], [isShiftLeader] HAVING Count(*) > 1))
	BEGIN
		RAISERROR('One shift can only have one leader', 14, 11);
		ROLLBACK TRANSACTION
	END

	
	UPDATE OnDuty
	SET isShiftLeader = 0
	FROM OnDuty o JOIN Inserted i on o.ShiftID = i.ShiftID and i.OnDutyID <> o.OnDutyID
	WHERE i.isShiftLeader = 1



END
GO

ALTER TABLE [dbo].[OnDuty] ENABLE TRIGGER [OneShiftLeader]
GO


GO
/****** Object:  StoredProcedure [dbo].[UpdateVolunteer]    Script Date: 5/18/2022 1:48:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[UpdateVolunteer]
(
	@ID int,
	@FirstName varchar(50),
	@LastName varchar(50),
	@DOB varchar(10) = null, 
	@Sex varchar(20) = null,
	@MemberSince varchar(10) = null,
	@CanGiveMed bit,
	@ServicesEndOn varchar(10) = null
)
AS
BEGIN

	IF (@ID is null or not exists(SELECT * FROM Volunteer WHERE ID = @ID))
	BEGIN
		RAISERROR('invalid volunteer ID', 14, 1);
		RETURN 1
	END
	
	if (@FirstName is null or @LastName is null) 
	BEGIN
		RAISERROR('name cannot be null.', 14, 1);
		
		RETURN 1;
	END

	if (@CanGiveMed is null) 
	BEGIN
		RAISERROR('medic permission cannot be null.', 14, 2);
		
		RETURN 2;
	END

	DECLARE @convDate date = null
	if (@DOB is not null)
	BEGIN
		SET @convDate = TRY_CONVERT(date, @DOB);
		if (@convDate is null)
		BEGIN
			RAISERROR('invalid dob', 14, 55);
			RETURN 55;
		END
	END

	DECLARE @convMS date = null
	if (@MemberSince is not null)
	BEGIN
		SET @convMS = TRY_CONVERT(date, @MemberSince);
		if (@convMS is null)
		BEGIN
			RAISERROR('invalid member since date', 14, 56);
			RETURN 56;
		END
	END

	DECLARE @convSEO date = null
	if (@ServicesEndOn is not null)
	BEGIN
		SET @convSEO = TRY_CONVERT(date, @ServicesEndOn);
		if (@convSEO is null)
		BEGIN
			RAISERROR('invalid services end on date', 14, 57);
			RETURN 57;
		END
	END

	IF @convDate > GETDATE()
	BEGIN
		RAISERROR('You cannot be born in the future', 14, 58);
		RETURN 58;
	END

	IF @convMS > GETDATE()
	BEGIN
		RAISERROR('Cannot be a member since a future date', 14, 59);
		RETURN 59;
	END

	UPDATE Volunteer
	SET FirstName = @FirstName, LastName = @LastName, DateOfBirth = @convDate, 
		Sex = @sex, MemberSince = @convMS, CanGiveMed = @canGiveMed, 
		ServicesEndOn = @convSEO
	WHERE ID = @ID
	RETURN 0;

	SELECT * FROM Volunteer WHERE Volunteer.ID = @ID

END
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
         Top = -120
         Left = 0
      End
      Begin Tables = 
         Begin Table = "f"
            Begin Extent = 
               Top = 371
               Left = 48
               Bottom = 549
               Right = 257
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 185
               Right = 281
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "MealLog"
            Begin Extent = 
               Top = 189
               Left = 48
               Bottom = 367
               Right = 257
            End
            DisplayFlags = 280
            TopColumn = 3
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
         Column = 1896
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'MealLogDetailFormatted'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'MealLogDetailFormatted'
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
            TopColumn = 0
         End
         Begin Table = "MedPlan"
            Begin Extent = 
               Top = 189
               Left = 48
               Bottom = 367
               Right = 275
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "m"
            Begin Extent = 
               Top = 371
               Left = 48
               Bottom = 549
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
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'MedPlanDetailFormatted'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'MedPlanDetailFormatted'
GO
ALTER DATABASE [${DBNAME}] SET  READ_WRITE 
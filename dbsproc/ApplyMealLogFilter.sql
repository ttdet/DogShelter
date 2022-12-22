CREATE PROCEDURE ApplyMealLogFilter
(
	@DogID int,
	@StartDate date null,
	@EndDate date null

)
AS
BEGIN
	if (@DogID is null) 
	BEGIN
		RAISERROR('dog id needed', 14, 1);
		RETURN 1;
	END
	if (@StartDate is null and @EndDate is null)
	BEGIN
		SELECT * FROM MealLogDetailFormatted ORDER BY [Date] DESC, [Time] ASC
		RETURN 0;
	END
	else if (@StartDate is null)
	BEGIN
		SELECT * FROM MealLogDetailFormatted WHERE [Date] <= @EndDate ORDER BY [Date] DESC, [Time] ASC
		RETURN 0;
	END
	else 
	BEGIN
		SELECT * FROM MealLogDetailFormatted WHERE [Date] >= @StartDate ORDER BY [Date] DESC, [Time] ASC
		RETURN 0;
	END
END
USE DDS
GO

CREATE OR ALTER PROCEDURE InsertTime
AS
BEGIN
	DECLARE @MAX DATETIME= (SELECT MAX(CreateDate) FROM NDS.DBO.supermarket_sales_NDS)
	DECLARE @MIN DATETIME= (SELECT MIN(CreateDate) FROM NDS.DBO.supermarket_sales_NDS)
	DECLARE @Y INT = CAST(YEAR(@MIN) AS INT)
	DECLARE @M INT = 1
	DECLARE @D INT = 1
	DECLARE @H INT = 1
	WHILE @Y <= CAST(YEAR(@MAX) AS INT)
	BEGIN
		SET @M = 1
		WHILE @M < 13
		BEGIN
			SET @D = 1
			IF @M IN (1,3,5,7,8,10,12)
			BEGIN
				WHILE @D < 32
				BEGIN
					SET @H = 1
					WHILE @H < 25
					BEGIN
						INSERT INTO DBO.Dim_Time (Gio, Ngay, Thang, Nam) VALUES (@H, @D, @M, @Y)
						SET @H = @H + 1
					END
					SET @D = @D + 1
				END
			END
			IF @M IN (4,6,9,11)
			BEGIN
				WHILE @D < 31
				BEGIN
					SET @H = 1
					WHILE @H < 25
					BEGIN
						INSERT INTO DBO.Dim_Time (Gio, Ngay, Thang, Nam) VALUES (@H, @D, @M, @Y)
						SET @H = @H + 1
					END
					SET @D = @D + 1
				END
			END
			IF @M IN (2) AND @Y % 4 = 0
			BEGIN
				WHILE @D < 30
				BEGIN
					SET @H = 1
					WHILE @H < 25
					BEGIN
						INSERT INTO DBO.Dim_Time (Gio, Ngay, Thang, Nam) VALUES (@H, @D, @M, @Y)
						SET @H = @H + 1
					END
					SET @D = @D + 1
				END
			END
			IF @M IN (2) AND @Y % 4 != 0
			BEGIN
				WHILE @D < 29
				BEGIN
					SET @H = 1
					WHILE @H < 25
					BEGIN
						INSERT INTO DBO.Dim_Time (Gio, Ngay, Thang, Nam) VALUES (@H, @D, @M, @Y)
						SET @H = @H + 1
					END
					SET @D = @D + 1
				END
			END
			SET @M = @M + 1
		END
		SET @Y = @Y + 1
	END
END
GO
DELETE FROM DBO.Dim_Time
EXEC DBO.InsertTime
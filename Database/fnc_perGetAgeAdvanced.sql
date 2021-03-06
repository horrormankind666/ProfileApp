USE [Infinity]
GO
/****** Object:  UserDefinedFunction [dbo].[fnc_perGetAgeAdvanced]    Script Date: 08/04/2015 13:03:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๐๔/๐๘/๒๕๕๘>
-- Description	: <สำหรับแสดงอายุแบบละเอียด>
--  1. fromDate	เป็น VARCHAR	รับค่าวันที่เริ่มต้นรูปแบบ วัน/เดือน/ปี
--  2. toDate	เป็น VARCHAR	รับค่าวันที่สิ้นสุดรูปแบบ วัน/เดือน/ปี
-- =============================================
ALTER FUNCTION [dbo].[fnc_perGetAgeAdvanced]
(
	@fromDate VARCHAR(10) = NULL,
	@toDate VARCHAR(10) = NULL
)
RETURNS @tbl  TABLE 
(
	yy INT,
	mm INT,
	dd INT
)
AS
BEGIN
	DECLARE @yy INT = 0
	DECLARE @mm INT = 0
	DECLARE @dd INT = 0
	DECLARE @startDate DATETIME = CONVERT(DATETIME, @fromDate, 103)
	DECLARE @endDate DATETIME = CONVERT(DATETIME, @toDate, 103)

	IF (@fromDate IS NOT NULL AND LEN(@fromDate) > 0 AND @toDate IS NOT NULL AND LEN(@toDate) > 0 AND ISDATE(@startDate) IS NOT NULL AND ISDATE(@endDate) IS NOT NULL)
	BEGIN
		SELECT	@yy = yy,
				@mm = mm,
				@dd = DATEDIFF(DD, DATEADD(MM, mm, DATEADD(YY, yy, startDate)), endDate)
		FROM	(
					SELECT	mm = (CASE WHEN AnniversaryThisMonth <= endDate THEN
									DATEDIFF(MM, DATEADD(YY, yy, startDate), endDate)
								  ELSE
									DATEDIFF(MM, DATEADD(YY, yy, startDate), endDate) - 1
								  END),
							*
					FROM	(
								SELECT	yy = (CASE WHEN AnniversaryThisYear <= endDate THEN
												DATEDIFF(YY, startDate, endDate)
											  ELSE
												DATEDIFF(YY, startDate, endDate) - 1
											  END),
										*
								FROM	(
											SELECT	AnniversaryThisYear = DATEADD(YY, DATEDIFF(YY, startDate, endDate), startDate),
													AnniversaryThisMonth = DATEADD(MM, DATEDIFF(MM, startDate, endDate), startDate),
													*
											FROM	(
														SELECT	startDate = DATEADD(DD, DATEDIFF(DD, 0, @startDate), 0),
																endDate = DATEADD(DD, DATEDIFF(DD, 0, @endDate), 0)
													) AS a
										) AS b
							) AS c
				) AS d			
	END

	INSERT INTO @tbl(yy, mm, dd)
	SELECT @yy, @mm, @dd
	
	RETURN 
END
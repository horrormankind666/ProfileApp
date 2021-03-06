USE [MUStudent]
GO
/****** Object:  UserDefinedFunction [dbo].[fnc_perParseString]    Script Date: 03/14/2014 16:58:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๑/๑๑/๒๕๕๖>
-- Description	: <สำหรับแบ่งข้อความออกเป็นชุด เพื่อใช้บันทึกข้อมูลครั้งละหลายเรคคอร์ด>
--  1. string		เป็น NVARCHAR	รับค่าข้อความ
--  2. delimiter	เป็น CHAR	รับค่าอักขระที่ใช้แบ่งข้อความ
-- =============================================
ALTER FUNCTION [dbo].[fnc_perParseString]
(	
	@string NVARCHAR(4000) = NULL,
	@delimiter CHAR(1) = NULL
)	
RETURNS @tbl TABLE
(
	stringSlice NVARCHAR(MAX),
	string NVARCHAR(MAX)
)
AS
BEGIN
	SET @string = LTRIM(RTRIM(@string))
	
	DECLARE @i INT = 1
	DECLARE @stringSlice NVARCHAR(MAX) = NULL
	
	SET	@i = CHARINDEX(@delimiter, @string)
	
	IF (@i != 0)
	BEGIN
		SET @stringSlice = SUBSTRING(@string, 1, @i - 1)
		SET @string = SUBSTRING(@string, @i + 1, LEN(@string))
	END
	ELSE
		BEGIN
			SET @stringSlice = @string
			SET @string = NULL
		END				
	
	IF (LEN(@stringSlice) = 0) SET @stringSlice = NULL
	
	SET @stringSlice = LTRIM(RTRIM(@stringSlice))
	SET @string = LTRIM(RTRIM(@string))
	
	INSERT INTO @tbl
	(
		stringSlice,
		string
	)
	VALUES
	(
		@stringSlice,
		@string
	)		
	
	RETURN		
END

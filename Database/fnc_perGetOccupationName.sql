SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<ยุทธภูมิ ตวันนา>
-- Create date: <๐๘/๐๔/๒๕๕๙>
-- Description:	<สำหรับแสดงชื่อของอาชีพตามรหัส>
-- =============================================
CREATE FUNCTION fnc_perGetOccupationName
(
	@id VARCHAR(2) = NULL,
	@lang VARCHAR(2) = NULL
)
RETURNS VARCHAR(255)
AS
BEGIN
	DECLARE @occupationName VARCHAR(255) = NULL

	IF (@lang = 'TH')
	BEGIN
		SET @occupationName = (
								CASE @id
									WHEN '01' THEN 'รับราชการ'
									WHEN '02' THEN 'พนักงาน / ลูกจ้าง ส่วนราชการ'
									WHEN '03' THEN 'พนักงาน / ลูกจ้างเอกชน'
									WHEN '04' THEN 'พนักงานรัฐวิสาหกิจ'
									WHEN '05' THEN 'ธุรกิจส่วนตัว / ค้าขาย / อาชีพอิสระ / แม่บ้าน'
									WHEN '06' THEN 'เกษตรกร / ชาวประมง'				
									WHEN '07' THEN 'องค์การมหาชน'
									WHEN '08' THEN 'รับจ้าง'
									ELSE NULL
								END				
							  )
	END

	IF (@lang = 'EN')
	BEGIN
		SET @occupationName = (
								CASE @id
									WHEN '01' THEN 'Public Servant'
									WHEN '02' THEN 'Staff / Employee Government'
									WHEN '03' THEN 'Staff / Employee in Private Company'
									WHEN '04' THEN 'State Enterprise Employees'
									WHEN '05' THEN 'Independent Business / Family Business / Freelance / Housewife'
									WHEN '06' THEN 'Farmer / Fisherman'				
									WHEN '07' THEN 'Public Organization'
									WHEN '08' THEN 'Hired Hands'
									ELSE NULL
								END				
							  )
	END

	RETURN @occupationName
END
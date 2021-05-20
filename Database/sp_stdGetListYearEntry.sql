SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๒๐/๐๕/๒๕๕๘>
-- Description	: <สำหรับแสดงข้อมูลปีที่เข้าศึกษา>
-- =============================================
CREATE PROCEDURE sp_stdGetListYearEntry
AS
BEGIN
	SET NOCOUNT ON

	SELECT	 yearEntry
	FROM	 stdStudent
	GROUP BY yearEntry
	HAVING	 yearEntry IS NOT NULL
	ORDER BY yearEntry DESC
END
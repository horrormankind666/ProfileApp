SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๘/๐๕/๒๕๕๘>
-- Description	: <สำหรับแสดงข้อมูลความสัมพันธ์ในครอบครัว>
--	1. facultyId	เป็น VARCHAR	รับค่ารหัสคณะ
-- =============================================
CREATE PROCEDURE sp_epfGetListFaculty
(
	@facultyId VARCHAR(MAX) = NULL
)	
AS
BEGIN
	SET NOCOUNT ON

	SELECT	 *
	FROM	 fnc_curGetListFaculty('U0001', '')
	WHERE	 ((1 = (CASE WHEN (@facultyId IS NOT NULL AND LEN(@facultyId) > 0) THEN 0 ELSE 1 END)) OR					 
			  (facultyId = (CASE WHEN (@facultyId IS NOT NULL AND LEN(@facultyId) > 0) THEN @facultyId ELSE facultyId END))) AND
			 (cancelStatus IS NULL)
	ORDER BY facultyId			
END
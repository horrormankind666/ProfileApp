USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_autUserAccessProgram]    Script Date: 05/19/2015 10:38:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๙/๐๕/๒๕๕๘>
-- Description	: <สำหรับแสดงข้อมูลหลักสูตรตามสิทธิ์ผู้ใช้งาน>
--	1. username		เป็น VARCHAR	รับค่าชื่อผู้ใช้งาน
--	2. userlevel	เป็น VARCHAR	รับค่าระดับผู้ใช้งาน
--	3. systemGroup	เป็น VARCHAR	รับค่าชื่อระบบงาน
-- =============================================
ALTER PROCEDURE [dbo].[sp_autUserAccessProgram]
(
	@username VARCHAR(MAX) = NULL,
	@userlevel VARCHAR(MAX) = NULL,
	@systemGroup VARCHAR(MAX) = NULL
)
AS
BEGIN
	SET NOCOUNT ON

	SELECT	*
	FROM	autUserAccessProgram AS autus
	WHERE	(autus.username = @username) AND
			((1 = (CASE WHEN (@userlevel IS NOT NULL AND LEN(@userlevel) > 0) THEN 0 ELSE 1 END)) OR					 
			 (autus.level = (CASE WHEN (@userlevel IS NOT NULL AND LEN(@userlevel) > 0) THEN @userlevel ELSE autus.level END))) AND
			(autus.systemGroup = @systemGroup)
END
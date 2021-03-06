USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_quoGetVerifyIdentity]    Script Date: 11/10/2015 16:09:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๐๙/๑๑/๒๕๕๘>
-- Description	: <สำหรับแสดงข้อมูลการยืนยันตัวตน>
--	1. id				เป็น VARCHAR	รับค่ารหัสผู้ใช้งาน
--	2. acaYear			เป็น VARCHAR	รับค่าปีการศึกษา
--	3. idCard			เป็น NVARCHAR	รับค่าเลขประจำตัวประชาชน
--	4. email			เป็น NVARCHAR	รับค่าชื่ออีเมล์
--	5. verifiedCode		เป็น NVARCHAR	รับค่ารหัสสำหรับการยืนยันตัวตน
-- =============================================
ALTER PROCEDURE [dbo].[sp_quoGetVerifyIdentity]
(
	@id VARCHAR(MAX) = NULL,
	@acaYear VARCHAR(MAX) = NULL,
	@idCard NVARCHAR(MAX) = NULL,
	@email NVARCHAR(MAX) = NULL,
	@verifiedCode NVARCHAR(MAX) = NULL
)
AS
BEGIN
	SET NOCOUNT ON

	SET @id = LTRIM(RTRIM(@id))	
	SET @acaYear = LTRIM(RTRIM(@acaYear))
	SET @idCard = LTRIM(RTRIM(@idCard))
	SET @email = LTRIM(RTRIM(@email))
	SET @verifiedCode = LTRIM(RTRIM(@verifiedCode))

	SELECT	*
	FROM	quoVerifyIdentity AS quovid
	WHERE	(quovid.acaYear = @acaYear) AND
			(quovid.email COLLATE Latin1_General_CS_AS = @email)

	SELECT	*
	FROM	quoVerifyIdentity AS quovid
	WHERE	(
				(1 = (CASE WHEN (@id IS NOT NULL AND LEN(@id) > 0) THEN 0 ELSE 1 END)) OR	
				(quovid.id = @id)
			) AND
			(quovid.acaYear = @acaYear) AND
			(
				(1 = (CASE WHEN (@idCard IS NOT NULL AND LEN(@idCard) > 0) THEN 0 ELSE 1 END)) OR	
				(quovid.idCard COLLATE Latin1_General_CS_AS = @idCard)
			) AND
			(
				(1 = (CASE WHEN (@email IS NOT NULL AND LEN(@email) > 0) THEN 0 ELSE 1 END)) OR	
				(quovid.email COLLATE Latin1_General_CS_AS = @email)
			) AND
			(
				(1 = (CASE WHEN (@verifiedCode IS NOT NULL AND LEN(@verifiedCode) > 0) THEN 0 ELSE 1 END)) OR	
			 	(quovid.verifiedCode COLLATE Latin1_General_CS_AS = @verifiedCode)
			)

	SELECT	*
	FROM	quoVerifyIdentity AS quovid
	WHERE	(quovid.acaYear = @acaYear) AND
			(quovid.idCard COLLATE Latin1_General_CS_AS = @idCard) AND
			(quovid.verifiedStatus = 'Y')
END
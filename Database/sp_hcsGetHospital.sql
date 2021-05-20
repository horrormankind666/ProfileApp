USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_perGetPersonStudentWithAuthenStaff]    Script Date: 12/01/2015 07:59:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๐๑/๑๒/๒๕๕๘>
-- Description	: <สำหรับเรียกดูข้อมูลหน่วยบริการสุขภาพ>
-- Parameter
--  1. id	เป็น VARCHAR	รับค่ารหัสหน่วยบริการสุขภาพ
-- =============================================
CREATE PROCEDURE [dbo].[sp_hcsGetHospital]
(
	@id VARCHAR(15) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	
	SET @id = LTRIM(RTRIM(@id))
	
	SELECT	hcshpt.id,
			hcshpt.thHospitalName AS hospitalNameTH,
			hcshpt.enHospitalName AS hospitalNameEN,
			hcshpt.cancel AS cancelledStatus
	FROM	hcsHospital AS hcshpt
	WHERE	(hcshpt.id = @id)
END
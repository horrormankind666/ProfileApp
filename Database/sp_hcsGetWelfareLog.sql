USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_hcsGetWelfareLog]    Script Date: 05-01-2017 16:57:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๐๕/๐๑/๒๕๖๐>
-- Description	: <สำหรับเรียกดูข้อมูลสิทธิการรักษาพยาบาลของบุคคล>
-- Parameter
--  1. personId	เป็น VARCHAR	รับค่ารหัสบุคคล
-- =============================================
ALTER PROCEDURE [dbo].[sp_hcsGetWelfareLog]
(
	@personId VARCHAR(10) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	
	SET @personId = LTRIM(RTRIM(@personId))
	
	SELECT	hcswfl.perPersonId,
			hcswfl.hcsWelfareId,
			hcswel.nameTH,
			hcswel.nameEN,
			hcswel.forPublicServant,
			hcswel.workedStatus
	FROM	hcsWelfareLog AS hcswfl INNER JOIN
			hcsWelfare AS hcswel ON hcswfl.hcsWelfareId = hcswel.id
	WHERE	(hcswfl.perPersonId = @personId)
END
USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_perGetInstitute]    Script Date: 14-06-2016 09:43:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๔/๐๖/๒๕๕๙>
-- Description	: <สำหรับเรียกดูข้อมูลสถาบัน / โรงเรียน>
-- Parameter
--  1. id	เป็น VARCHAR	รับค่ารหัสสถาบัน / โรงเรียน
-- =============================================
ALTER PROCEDURE [dbo].[sp_perGetInstitute]
(
	@id VARCHAR(10) = NULL
)
AS
BEGIN
	SET NOCOUNT ON

	SET @id = LTRIM(RTRIM(@id))
	
	SELECT	perins.id,
			plcpvn.plcCountryId,
			plccon.isoCountryCodes3Letter, 
			perins.plcProvinceId,
			plcpvn.provinceNameTH,
			plcpvn.provinceNameEN,
			perins.institutelNameTH AS instituteNameTH,
			perins.institutelNameEN AS instituteNameEN,
			perins.cancelledStatus
	FROM	perInstitute AS perins INNER JOIN
			plcProvince AS plcpvn ON perins.plcProvinceId = plcpvn.id INNER JOIN
			plcCountry AS plccon ON plcpvn.plcCountryId = plccon.id
	WHERE	(perins.id = @id)
END

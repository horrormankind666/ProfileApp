USE [Infinity]
GO
/****** Object:  UserDefinedFunction [dbo].[fnc_perGetListAddress]    Script Date: 09/21/2015 07:31:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๔/๐๑/๒๕๕๗>
-- Description	: <สำหรับแสดงข้อมูลที่อยู่ของบุคคล>
--  1. id		เป็น VARCHAR	รับค่ารหัสบุคคล
--  2. idCard 	เป็น NVARCHAR	รับค่าเลขประจำตัวประชาชนหรือเลขหนังสือเดินทาง
--  3. name		เป็น NVARCHAR	รับค่าชื่อ
-- =============================================
ALTER FUNCTION [dbo].[fnc_perGetListAddress]
(	
	@id	VARCHAR(MAX) = NULL,
	@idCard NVARCHAR(MAX) = NULL,
	@name NVARCHAR(MAX) = NULL
)
RETURNS TABLE 
AS
RETURN 
(	
	SELECT	perps.id,
			perps.idCard,
			perps.perTitlePrefixId,
			perps.thTitleFullName,
			perps.thTitleInitials,
			perps.thDescription,
			perps.enTitleFullName,
			perps.enTitleInitials,
			perps.enDescription,				
			perps.firstName,
			perps.middleName,
			perps.lastName,
			perps.enFirstName,
			perps.enMiddleName,
			perps.enLastName,
			'ที่อยู่ตามทะเบียนบ้าน' AS thAddressTypePermanent,
			'PermanentAddress' AS enAddressTypePermanent,
			(
				(CASE WHEN (LEN(LTRIM(RTRIM(perad.villagePermanent))) > 0) THEN ('หมู่บ้าน' + LTRIM(RTRIM(perad.villagePermanent)) + ' ') ELSE '' END) +
				(CASE WHEN (LEN(LTRIM(RTRIM(perad.noPermanent))) > 0) THEN ('บ้านเลขที่ ' + LTRIM(RTRIM(perad.noPermanent)) + ' ') ELSE '' END) +
				(CASE WHEN (LEN(LTRIM(RTRIM(perad.mooPermanent))) > 0) THEN ('หมู่ ' + LTRIM(RTRIM(perad.mooPermanent)) + ' ') ELSE '' END) +
				(CASE WHEN (LEN(LTRIM(RTRIM(perad.soiPermanent))) > 0) THEN ('ซ.' + LTRIM(RTRIM(perad.soiPermanent)) + ' ') ELSE '' END) +
				(CASE WHEN (LEN(LTRIM(RTRIM(perad.roadPermanent))) > 0) THEN ('ถ. ' + LTRIM(RTRIM(perad.roadPermanent)) + ' ') ELSE '' END) +
				(CASE WHEN (LEN(LTRIM(RTRIM(plcsdpma.thSubdistrictName))) > 0) THEN ('ต.' + LTRIM(RTRIM(plcsdpma.thSubdistrictName)) + ' ') ELSE '' END) +
				(CASE WHEN (LEN(LTRIM(RTRIM(plcdipma.thDistrictName))) > 0) THEN ('อ.' + LTRIM(RTRIM(plcdipma.thDistrictName)) + ' ') ELSE '' END) +
				(CASE WHEN (LEN(LTRIM(RTRIM(plcpvpma.provinceNameTH))) > 0) THEN ('จ.' + LTRIM(RTRIM(plcpvpma.provinceNameTH)) + ' ') ELSE '' END) +
				(CASE WHEN (LEN(LTRIM(RTRIM(perad.zipCodePermanent))) > 0) THEN LTRIM(RTRIM(perad.zipCodePermanent)) ELSE '' END)
			) AS addressPermanent,	
			perad.plcCountryIdPermanent, 
			plccopma.countryNameTH AS thCountryNamePermanent,
			plccopma.countryNameEN AS enCountryNamePermanent,
			plccopma.isoCountryCodes2Letter AS isoCountryCodes2LetterPermanent,
			plccopma.isoCountryCodes3Letter AS isoCountryCodes3LetterPermanent,
			perad.villagePermanent,
			perad.noPermanent, 
			perad.mooPermanent,
			perad.soiPermanent,
			perad.roadPermanent,
			perad.plcSubdistrictIdPermanent,
			plcsdpma.thSubdistrictName AS thSubdistrictNamePermanent,
			plcsdpma.enSubdistrictName AS enSubdistrictNamePermanent,
			perad.plcDistrictIdPermanent,
			plcdipma.thDistrictName AS thDistrictNamePermanent,
			plcdipma.enDistrictName AS enDistrictNamePermanent,
			plcdipma.zipCode AS zipCodeDistrictPermanent,
			perad.plcProvinceIdPermanent,
			plcpvpma.provinceNameTH AS thPlaceNamePermanent, 
			plcpvpma.provinceNameEN AS enPlaceNamePermanent,
			plcpvpma.plcCountryId AS plcProvinceCountryIdPermanent,
			perad.zipCodePermanent,
			perad.phoneNumberPermanent,
			perad.mobileNumberPermanent,
			perad.faxNumberPermanent,
			'ที่อยู่ปัจจุบัน' AS thAddressTypeCurrent,
			'Present Address' AS enAddressTypeCurrent,
			(
				(CASE WHEN (LEN(LTRIM(RTRIM(perad.villageCurrent))) > 0) THEN ('หมู่บ้าน' + LTRIM(RTRIM(perad.villageCurrent)) + ' ') ELSE '' END) +
				(CASE WHEN (LEN(LTRIM(RTRIM(perad.noCurrent))) > 0) THEN ('บ้านเลขที่ ' + LTRIM(RTRIM(perad.noCurrent)) + ' ') ELSE '' END) +
				(CASE WHEN (LEN(LTRIM(RTRIM(perad.mooCurrent))) > 0) THEN ('หมู่ ' + LTRIM(RTRIM(perad.mooCurrent)) + ' ') ELSE '' END) +
				(CASE WHEN (LEN(LTRIM(RTRIM(perad.soiCurrent))) > 0) THEN ('ซ.' + LTRIM(RTRIM(perad.soiCurrent)) + ' ') ELSE '' END) +
				(CASE WHEN (LEN(LTRIM(RTRIM(perad.roadCurrent))) > 0) THEN ('ถ. ' + LTRIM(RTRIM(perad.roadCurrent)) + ' ') ELSE '' END) +
				(CASE WHEN (LEN(LTRIM(RTRIM(plcsdcur.thSubdistrictName))) > 0) THEN ('ต.' + LTRIM(RTRIM(plcsdcur.thSubdistrictName)) + ' ') ELSE '' END) +
				(CASE WHEN (LEN(LTRIM(RTRIM(plcdicur.thDistrictName))) > 0) THEN ('อ.' + LTRIM(RTRIM(plcdicur.thDistrictName)) + ' ') ELSE '' END) +
				(CASE WHEN (LEN(LTRIM(RTRIM(plcpvcur.provinceNameTH))) > 0) THEN ('จ.' + LTRIM(RTRIM(plcpvcur.provinceNameEN)) + ' ') ELSE '' END) +
				(CASE WHEN (LEN(LTRIM(RTRIM(perad.zipCodeCurrent))) > 0) THEN LTRIM(RTRIM(perad.zipCodeCurrent)) ELSE '' END)
			) AS addressCurrent,			
			perad.plcCountryIdCurrent, 
			plccocur.countryNameTH AS thCountryNameCurrent,
			plccocur.countryNameEN AS enCountryNameCurrent,
			plccocur.isoCountryCodes2Letter AS isoCountryCodes2LetterCurrent,
			plccocur.isoCountryCodes3Letter AS isoCountryCodes3LetterCurrent,
			perad.villageCurrent,
			perad.noCurrent, 
			perad.mooCurrent,
			perad.soiCurrent,
			perad.roadCurrent,
			perad.plcSubdistrictIdCurrent,
			plcsdcur.thSubdistrictName AS thSubdistrictNameCurrent,
			plcsdcur.enSubdistrictName AS enSubdistrictNameCurrent,
			perad.plcDistrictIdCurrent,
			plcdicur.thDistrictName AS thDistrictNameCurrent,
			plcdicur.enDistrictName AS enDistrictNameCurrent,
			plcdicur.zipCode AS zipCodeDistrictCurrent,
			perad.plcProvinceIdCurrent,
			plcpvcur.provinceNameTH AS thPlaceNameCurrent, 
			plcpvcur.provinceNameEN AS enPlaceNameCurrent,
			plcpvcur.plcCountryId AS plcProvinceCountryIdCurrent,
			perad.zipCodeCurrent,
			perad.phoneNumberCurrent,
			perad.mobileNumberCurrent,
			perad.faxNumberCurrent,
			perad.createDate,
			perad.createBy,
			perad.createIp,
			perad.modifyDate,
			perad.modifyBy,
			perad.modifyIp
	FROM	fnc_perGetListPerson(@id, @idCard, @name) AS perps LEFT JOIN
			perAddress AS perad ON perps.id = perad.perPersonId LEFT JOIN
			plcCountry AS plccopma ON perad.plcCountryIdPermanent = plccopma.id LEFT JOIN
			plcProvince AS plcpvpma ON perad.plcProvinceIdPermanent = plcpvpma.id LEFT JOIN			
			plcDistrict AS plcdipma ON perad.plcDistrictIdPermanent = plcdipma.id LEFT JOIN
			plcSubdistrict AS plcsdpma ON perad.plcSubdistrictIdPermanent = plcsdpma.id LEFT JOIN			
			plcCountry AS plccocur ON perad.plcCountryIdCurrent = plccocur.id LEFT JOIN
			plcProvince AS plcpvcur ON perad.plcProvinceIdCurrent = plcpvcur.id LEFT JOIN
			plcDistrict AS plcdicur ON perad.plcDistrictIdCurrent = plcdicur.id LEFT JOIN
			plcSubdistrict AS plcsdcur ON perad.plcSubdistrictIdCurrent = plcsdcur.id			
)

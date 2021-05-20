USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_udsGetPersonStudent]    Script Date: 05-08-2016 10:43:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๒/๐๖/๒๕๕๘>
-- Description	: <สำหรับเรียกดูข้อมูลของนักศึกษาสำหรับระบบอัพโหลดเอกสารของนักศึกษา>
-- Parameter
--  1. personId	เป็น VARCHAR	รับค่ารหัสบุคคล
-- =============================================
ALTER PROCEDURE [dbo].[sp_udsGetPersonStudent]
(
	@personId VARCHAR(10) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	
	SET @personId = LTRIM(RTRIM(@personId))
		
	SELECT	stdstd.id,
			stdstd.studentId,
			stdstd.studentCode,
			stdstd.idCard,
			stdstd.thTitleFullName AS titlePrefixFullNameTH,
			stdstd.thTitleInitials AS titlePrefixInitialsTH,					
			stdstd.enTitleFullName AS titlePrefixFullNameEN,
			stdstd.enTitleInitials AS titlePrefixInitialsEN,
			stdstd.firstName,
			stdstd.middleName,
			stdstd.lastName,
			stdstd.enFirstName AS firstNameEN,
			stdstd.enMiddleName AS middleNameEN,
			stdstd.enLastName AS lastNameEN,
			stdstd.thGenderFullName AS genderFullNameTH,
			stdstd.thGenderInitials AS genderInitialsTH,
			stdstd.enGenderFullName AS genderFullNameEN,
			stdstd.enGenderInitials AS genderInitialsEN,
			stdstd.birthDate,
			ISNULL(DAY(stdstd.birthDate), NULL) AS birthDateOfDay,
			ISNULL(MONTH(stdstd.birthDate), NULL) AS birthDateOfMonth,
			(CASE WHEN ISNULL(YEAR(stdstd.birthDate), NULL) IS NOT NULL THEN (YEAR(stdstd.birthDate) + 543) ELSE NULL END) AS birthDateOfYear,
			stdstd.thBirthDate AS birthDateTH,
			stdstd.enBirthDate AS birthDateEN,
			stdstd.degree,
			stdstd.degreeLevelNameTH,
			stdstd.degreeLevelNameEN,
			stdstd.facultyCode,
			stdstd.facultyNameTH,
			stdstd.facultyNameEN,
			stdstd.programCode,
			stdstd.programNameTH,
			stdstd.programNameEN,
			stdstd.majorCode,
			stdstd.groupNum,
			stdstd.yearEntry,
			stdstd.perEntranceTypeId,
			stdstd.stdEntranceTypeNameTH,
			stdstd.stdEntranceTypeNameEN,	
			stdstd.stdStatusTypeId,
			stdstd.statusTypeNameTH,
			stdstd.statusTypeNameEN,		
			stdper.countryNameTH,
			stdper.countryNameEN,	
			stdper.isoCountryCodes2Letter,		
			stdper.perNationalityId, 
			stdper.thNationalityName AS nationalityNameTH,
			stdper.enNationalityName AS nationalityNameEN,	
			stdper.isoNationalityName2Letter,
			stdper.perOriginId,
			stdper.thOriginName AS originNameTH,
			stdper.enOriginName AS originNameEN,			
			stdper.perReligionId,
			stdper.thReligionName AS religionNameTH,
			stdper.enReligionName AS religionNameEN,
			stdper.perBloodTypeId,
			stdper.thBloodTypeName AS bloodTypeNameTH,
			stdper.enBloodTypeName AS bloodTypeNameEN,
		 	stdper.perMaritalStatusId,
			stdper.thMaritalStatusName AS maritalStatusNameTH,
			stdper.enMaritalStatusName AS maritalStatusNameEN,			
			stdper.email,
			stdadd.noCurrent,
			stdadd.villageCurrent,
			stdadd.mooCurrent,      
			stdadd.soiCurrent,                            
			stdadd.roadCurrent,
			stdadd.thSubdistrictNameCurrent AS subdistrictNameTHCurrent,
			stdadd.thDistrictNameCurrent AS districtNameTHCurrent,
			stdadd.zipCodeCurrent,
			stdadd.mobileNumberCurrent,
			stdedu.*,
			(CASE WHEN (stdstd.studentCode IS NOT NULL AND LEN(stdstd.studentCode) > 0 AND stdstd.degree IS NOT NULL AND LEN(stdstd.degree) > 0) THEN dbo.fnc_perGetBarcode(stdstd.studentCode, stdstd.degree) ELSE NULL END) AS barcode,
		    ('01/06/' + CONVERT(VARCHAR, YEAR(GETDATE()) + 543)) AS cardIssueDate,
            ('31/07/' + CONVERT(VARCHAR, YEAR(GETDATE()) + 543 + stdstd.studyYear)) AS cardExpiryDate,	
			udsull.*,
			plcpvn.plcCountryId AS instituteCountryIdTranscript,
			plccon.isoCountryCodes3Letter AS instituteCountryCodes3LetterTranscript,
			plccon.countryNameTH AS instituteCountryNameTHTranscript,
			plccon.countryNameEN AS instituteCountryNameENTranscript,
			perins.plcProvinceId AS instituteProvinceIdTranscript,
			plcpvn.provinceNameTH AS instituteProvinceNameTHTranscript,
			plcpvn.provinceNameEN AS instituteProvinceNameENTranscript,
			udsull.perInstituteIdTranscript AS instituteIdTranscript,
			perins.institutelNameTH AS institutelNameTHTranscript,
			perins.institutelNameEN AS institutelNameENTranscript
	FROM	fnc_perGetPersonStudent(@personId) AS stdstd LEFT JOIN	
			fnc_perGetPerson(@personId) AS stdper ON stdstd.id = stdper.id LEFT JOIN
			fnc_perGetAddress(@personId) AS stdadd ON stdstd.id = stdadd.id LEFT JOIN
			fnc_perGetEducation(@personId) AS stdedu ON stdstd.id = stdedu.id LEFT JOIN
			udsUploadLog AS udsull ON stdstd.id = udsull.perPersonId LEFT JOIN
			perInstitute AS perins ON udsull.perInstituteIdTranscript = perins.id LEFT JOIN
			plcProvince AS plcpvn ON perins.plcProvinceId = plcpvn.id LEFT JOIN
			plcCountry AS plccon ON plcpvn.plcCountryId = plccon.id			
END
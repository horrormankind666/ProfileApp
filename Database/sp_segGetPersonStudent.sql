USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_segGetPersonStudent]    Script Date: 31-08-2016 12:03:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๒๖/๐๘/๒๕๕๙>
-- Description	: <สำหรับเรียกดูข้อมูลของนักศึกษาสำหรับระบบคาดว่านักศึกษาจะสำเร็จการศึกษา>
-- Parameter
--  1. personId	เป็น VARCHAR	รับค่ารหัสบุคคล
-- =============================================
ALTER PROCEDURE [dbo].[sp_segGetPersonStudent]
(
	@personId VARCHAR(10) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	
	SET @personId = LTRIM(RTRIM(@personId))

	SELECT	 TOP 1
			 segvlg.id,
			 segvlg.perPersonId,
			 segvlg.validateResult,
			 segvlg.validateDate
	INTO	 #segTemp1
	FROM	 Infinity..segValidateLog AS segvlg
	WHERE	 (segvlg.perPersonId = @personId)
	ORDER BY id DESC
		
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
			stdstd.thBirthDate AS birthDateTH,
			stdstd.enBirthDate AS birthDateEN,
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
			stdstd.studyYear AS programYear,
			stdstd.yearEntry,
			stdstd.class,
			stdstd.perEntranceTypeId,
			stdstd.stdEntranceTypeNameTH,
			stdstd.stdEntranceTypeNameEN,			
			stdstd.stdStatusTypeId,
			stdstd.statusTypeNameTH,
			stdstd.statusTypeNameEN,
			stdstd.statusGroup,
			stdstd.admissionDate,
			stdstd.graduateDate,
			stdstd.folderPictureName,
			stdstd.profilePictureName,
			stdper.perNationalityId, 
			stdper.thNationalityName AS nationalityNameTH,
			stdper.enNationalityName AS nationalityNameEN,			
			stdadd.thCountryNamePermanent AS countryNameTHPermanent,
			stdadd.enCountryNamePermanent AS countryNameENPermanent,
			stdadd.thPlaceNamePermanent AS provinceNameTHPermanent,
			stdadd.enPlaceNamePermanent AS provinceNameENPermanent,
			stdadd.thDistrictNamePermanent AS districtNameTHPermanent,
			stdadd.enDistrictNamePermanent AS districtNameENPermanent,
			stdadd.thSubdistrictNamePermanent AS subdistrictNameTHPermanent,
			stdadd.enSubdistrictNamePermanent AS subdistrictNameENPermanent,
			stdadd.zipCodePermanent,
			stdadd.villagePermanent,
			stdadd.noPermanent,
			stdadd.mooPermanent,
			stdadd.soiPermanent,
			stdadd.roadPermanent,
			stdadd.phoneNumberPermanent,
			stdadd.mobileNumberPermanent,
			stdadd.faxNumberPermanent,
			stdadd.thCountryNameCurrent AS countryNameTHCurrent,
			stdadd.enCountryNameCurrent AS countryNameENCurrent,
			stdadd.thPlaceNameCurrent AS provinceNameTHCurrent,
			stdadd.enPlaceNameCurrent AS provinceNameENCurrent,
			stdadd.thDistrictNameCurrent AS districtNameTHCurrent,
			stdadd.enDistrictNameCurrent AS districtNameENCurrent,
			stdadd.thSubdistrictNameCurrent AS subdistrictNameTHCurrent,
			stdadd.enSubdistrictNameCurrent AS subdistrictNameENCurrent,
			stdadd.zipCodeCurrent,
			stdadd.villageCurrent,
			stdadd.noCurrent,
			stdadd.mooCurrent,
			stdadd.soiCurrent,
			stdadd.roadCurrent,
			stdadd.phoneNumberCurrent,
			stdadd.mobileNumberCurrent,
			stdadd.faxNumberCurrent,			
			segtmp.validateDate,
			segtmp.validateResult,
			(
				CASE segtmp.validateResult
					WHEN 'Y' THEN 'ข้อมูลถูกต้อง'
					WHEN 'N' THEN 'ข้อมูลไม่ถุกต้อง'
				END
			) AS validateResultTH,
			(
				CASE segtmp.validateResult
					WHEN 'Y' THEN 'Correct Information'
					WHEN 'N' THEN 'Incorrect Information'
				END
			) AS validateResultEN
	FROM	fnc_perGetPersonStudent(@personId) AS stdstd LEFT JOIN			
			fnc_perGetPerson(@personId) AS stdper ON stdstd.id = stdper.id LEFT JOIN
			fnc_perGetAddress(@personId) AS stdadd ON stdstd.id = stdadd.id LEFT JOIN
			#segTemp1 AS segtmp ON stdstd.id = segtmp.perPersonId
	WHERE	(stdstd.statusGroup = '00') AND
			(stdstd.class >= stdstd.studyYear)
END
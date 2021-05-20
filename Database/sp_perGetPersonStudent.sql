USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_perGetPersonStudent]    Script Date: 09-08-2016 09:27:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๘/๐๖/๒๕๕๘>
-- Description	: <สำหรับเรียกดูข้อมูลของนักศึกษา>
-- Parameter
--  1. personId		เป็น VARCHAR	รับค่ารหัสบุคคล
-- =============================================
ALTER PROCEDURE [dbo].[sp_perGetPersonStudent]
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
			stdstd.thBirthDate AS birthDateTH,
			stdstd.enBirthDate AS birthDateEN,
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
			stdstd.enGenderInitials AS genderInitialsEN,
			stdstd.degree,
			stdstd.degreeLevelNameTH,
			stdstd.degreeLevelNameEN,
			stdstd.facultyId,
			stdstd.facultyCode,
			stdstd.facultyNameTH,
			stdstd.facultyNameEN,
			stdstd.programId,
			stdstd.programCode,
			stdstd.majorCode,
			stdstd.groupNum,
			stdstd.programNameTH,
			stdstd.programNameEN,
			stdstd.yearEntry,
			stdstd.acaYear,
			stdstd.courseYear,
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
			stdstd.updateReason,
			stdstd.folderPictureName,
			stdstd.profilePictureName,
			(CASE WHEN ISNULL(perrcn.perPerson, 0) = 1 THEN 'Y' ELSE 'N' END) AS studentRecordsPersonalStatus,
			(CASE WHEN ISNULL(perrcn.perAddress, 0) = 1 THEN 'Y' ELSE 'N' END) AS studentRecordsAddressStatus,
			(CASE WHEN ISNULL(perrcn.perAddressPermanent, 0) = 1 THEN 'Y' ELSE 'N' END) AS studentRecordsAddressPermanentStatus,
			(CASE WHEN ISNULL(perrcn.perAddressCurrent, 0) = 1 THEN 'Y' ELSE 'N' END) AS studentRecordsAddressCurrentStatus,
			(CASE WHEN ISNULL(perrcn.perEducation, 0) = 1 THEN 'Y' ELSE 'N' END) AS studentRecordsEducationStatus,
			(CASE WHEN ISNULL(perrcn.perEducationPrimarySchool, 0) = 1 THEN 'Y' ELSE 'N' END) AS studentRecordsEducationPrimarySchoolStatus,
			(CASE WHEN ISNULL(perrcn.perEducationJuniorHighSchool, 0) = 1 THEN 'Y' ELSE 'N' END) AS studentRecordsEducationJuniorHighSchoolStatus,
			(CASE WHEN ISNULL(perrcn.perEducationHighSchool, 0) = 1 THEN 'Y' ELSE 'N' END) AS studentRecordsEducationHighSchoolStatus,
			(CASE WHEN ISNULL(perrcn.perEducationUniversity, 0) = 1 THEN 'Y' ELSE 'N' END) AS studentRecordsEducationUniversityStatus,
			(CASE WHEN ISNULL(perrcn.perEducationAdmissionScores, 0) = 1 THEN 'Y' ELSE 'N' END) AS studentRecordsEducationAdmissionScoresStatus,
			(CASE WHEN ISNULL(perrcn.perActivity, 0) = 1 THEN 'Y' ELSE 'N' END) AS studentRecordsTalentStatus,
			(CASE WHEN ISNULL(perrcn.perHealthy, 0) = 1 THEN 'Y' ELSE 'N' END) AS studentRecordsHealthyStatus,
			(CASE WHEN ISNULL(perrcn.perWork, 0) = 1 THEN 'Y' ELSE 'N' END) AS studentRecordsWorkStatus,
			(CASE WHEN ISNULL(perrcn.perFinancial, 0) = 1 THEN 'Y' ELSE 'N' END) AS studentRecordsFinancialStatus,
			(CASE WHEN (CASE WHEN
							(ISNULL(perrcn.perPersonFather, 0) + ISNULL(perrcn.perAddressFather, 0) + ISNULL(perrcn.perWorkFather, 0) +
							 ISNULL(perrcn.perPersonMother, 0) + ISNULL(perrcn.perAddressMother, 0) + ISNULL(perrcn.perWorkMother, 0) +
							 ISNULL(perrcn.perPersonParent, 0) + ISNULL(perrcn.perAddressParent, 0) + ISNULL(perrcn.perWorkParent, 0)) = 9
						THEN
							1
						ELSE
							0
						END) = 1 THEN 'Y' ELSE 'N'END) studentRecordsFamilyStatus,
			
			(CASE WHEN ISNULL(perrcn.perPersonFather, 0) = 1 THEN 'Y' ELSE 'N' END) AS studentRecordsFamilyFatherPersonalStatus,
			(CASE WHEN ISNULL(perrcn.perPersonMother, 0) = 1 THEN 'Y' ELSE 'N' END) AS studentRecordsFamilyMotherPersonalStatus,
			(CASE WHEN ISNULL(perrcn.perPersonParent, 0) = 1 THEN 'Y' ELSE 'N' END) AS studentRecordsFamilyParentPersonalStatus,
			(CASE WHEN ISNULL(perrcn.perAddressFather, 0) = 1 THEN 'Y' ELSE 'N' END) AS studentRecordsFamilyFatherAddressFatherStatus,
			(CASE WHEN ISNULL(perrcn.perAddressPermanentFather, 0) = 1 THEN 'Y' ELSE 'N' END) AS studentRecordsFamilyFatherAddressPermanentStatus,
			(CASE WHEN ISNULL(perrcn.perAddressCurrentFather, 0) = 1 THEN 'Y' ELSE 'N' END) AS studentRecordsFamilyFatherAddressCurrentStatus,
			(CASE WHEN ISNULL(perrcn.perAddressMother, 0) = 1 THEN 'Y' ELSE 'N' END) AS studentRecordsFamilyMotherAddressStatus,
			(CASE WHEN ISNULL(perrcn.perAddressPermanentMother, 0) = 1 THEN 'Y' ELSE 'N' END) AS studentRecordsFamilyMotherAddressPermanentStatus,
			(CASE WHEN ISNULL(perrcn.perAddressCurrentMother, 0) = 1 THEN 'Y' ELSE 'N' END) AS studentRecordsFamilyMotherAddressCurrentStatus,
			(CASE WHEN ISNULL(perrcn.perAddressParent, 0) = 1 THEN 'Y' ELSE 'N' END) AS studentRecordsFamilyParentAddressStatus,
			(CASE WHEN ISNULL(perrcn.perAddressPermanentParent, 0) = 1 THEN 'Y' ELSE 'N' END) AS studentRecordsFamilyParentAddressPermanentStatus,
			(CASE WHEN ISNULL(perrcn.perAddressCurrentParent, 0) = 1 THEN 'Y' ELSE 'N' END) AS studentRecordsFamilyParentAddressCurrentStatus,
			(CASE WHEN ISNULL(perrcn.perWorkFather, 0) = 1 THEN 'Y' ELSE 'N' END) AS studentRecordsFamilyFatherWorkStatus,
			(CASE WHEN ISNULL(perrcn.perWorkMother, 0) = 1 THEN 'Y' ELSE 'N' END) AS studentRecordsFamilyMotherWorkStatus,
			(CASE WHEN ISNULL(perrcn.perWorkParent, 0) = 1 THEN 'Y' ELSE 'N' END) AS studentRecordsFamilyParentWorkStatus
	FROM	fnc_perGetPersonStudent(@personId) AS stdstd LEFT JOIN
			fnc_perGetListRecordCountPerson(@personId, '') AS perrcn ON stdstd.id = perrcn.id
END
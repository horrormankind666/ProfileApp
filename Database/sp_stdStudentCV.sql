USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_stdStudentCV]    Script Date: 29-08-2016 09:40:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๓/๐๓/๒๕๕๘>
-- Description	: <สำหรับดึงข้อมูลนักศึกษาแล้วสร้างเป็น HTML>
--  1. personId เป็น VARCHAR	รับค่ารหัสบุคคล
-- =============================================
-- [sp_stdGenerateStudentRecordsToHTML] '','','5415001'
-- [sp_stdStudentCV] '2557000683'

ALTER PROCEDURE [dbo].[sp_stdStudentCV]
(
	@personId VARCHAR(15) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	
	DECLARE @personContent NVARCHAR(MAX) = NULL
	DECLARE @recordCount INT = 0
	DECLARE	@strBlank VARCHAR(50) = '----------**********.........0.0000000000000000000??????????'

	IF (OBJECT_ID('tempdb..#tbStudentRecords') IS NOT NULL) DROP TABLE #tbStudentRecords

	IF (@personId IS NOT NULL AND LEN(@personId) > 0)
	BEGIN	
		SET @personId = ISNULL(@personId, '')
		
		BEGIN TRAN
			SELECT	TOP 1					
					stdstd.*,
					peradd.thCountryNamePermanent, peradd.enCountryNamePermanent,
					peradd.thPlaceNamePermanent, peradd.enPlaceNamePermanent,
					peradd.thDistrictNamePermanent, peradd.enDistrictNamePermanent,
					peradd.thSubdistrictNamePermanent, peradd.enSubdistrictNamePermanent,
					peradd.zipCodePermanent,
					peradd.villagePermanent,
					peradd.noPermanent,
					peradd.mooPermanent,
					peradd.soiPermanent,
					peradd.roadPermanent,
					peradd.phoneNumberPermanent,
					peradd.mobileNumberPermanent,
					peradd.faxNumberPermanent,
					peradd.thCountryNameCurrent, peradd.enCountryNameCurrent,
					peradd.thPlaceNameCurrent, peradd.enPlaceNameCurrent,
					peradd.thDistrictNameCurrent, peradd.enDistrictNameCurrent,
					peradd.thSubdistrictNameCurrent, peradd.enSubdistrictNameCurrent,
					peradd.zipCodeCurrent,
					peradd.villageCurrent,
					peradd.noCurrent,
					peradd.mooCurrent,
					peradd.soiCurrent,
					peradd.roadCurrent,
					peradd.phoneNumberCurrent,
					peradd.mobileNumberCurrent,
					peradd.faxNumberCurrent,
					peredu.primarySchoolName,
					peredu.thPrimarySchoolCountryName, peredu.enPrimarySchoolCountryName,
					peredu.thPrimarySchoolPlaceName, peredu.enPrimarySchoolPlaceName,
					peredu.primarySchoolYearAttended, peredu.primarySchoolYearGraduate,
					peredu.primarySchoolGPA,
					peredu.juniorHighSchoolName,
					peredu.thJuniorHighSchoolCountryName, peredu.enJuniorHighSchoolCountryName,
					peredu.thJuniorHighSchoolPlaceName, peredu.enJuniorHighSchoolPlaceName,
					peredu.juniorHighSchoolYearAttended,
					peredu.juniorHighSchoolYearGraduate,
					peredu.juniorHighSchoolGPA,
					peredu.highSchoolName,
					peredu.thHighSchoolCountryName, peredu.enHighSchoolCountryName,
					peredu.thHighSchoolPlaceName, peredu.enHighSchoolPlaceName,
					peredu.highSchoolStudentId,
					peredu.thHighSchoolEducationalMajorName, peredu.enHighSchoolEducationalMajorName,
					peredu.educationalMajorOtherHighSchool,
					peredu.highSchoolYearAttended,
					peredu.highSchoolYearGraduate,
					peredu.highSchoolGPA,
					peredu.thHighSchoolEducationalBackgroundName, peredu.enHighSchoolEducationalBackgroundName,
					peredu.thEducationalBackgroundName AS thMUEducationalBackgroundName, peredu.enEducationalBackgroundName AS enMUEducationalBackgroundName,
					peredu.thGraduateBy, peredu.enGraduateBy, peredu.graduateBySchoolName,
					peredu.thEntranceTime, peredu.enEntranceTime,
					peredu.thStudentIs, peredu.enStudentIs,
					peredu.studentIsUniversity,	peredu.studentIsFaculty, peredu.studentIsProgram,
					peredu.entranceTypeNameTH, peredu.entranceTypeNameEN,
					peredu.admissionRanking,
					peredu.scoreONET01, peredu.thScoreONET01Name, peredu.enScoreONET01Name,
					peredu.scoreONET02, peredu.thScoreONET02Name, peredu.enScoreONET02Name,
					peredu.scoreONET03, peredu.thScoreONET03Name, peredu.enScoreONET03Name,
					peredu.scoreONET04, peredu.thScoreONET04Name, peredu.enScoreONET04Name,
					peredu.scoreONET05, peredu.thScoreONET05Name, peredu.enScoreONET05Name,
					peredu.scoreONET06, peredu.thScoreONET06Name, peredu.enScoreONET06Name,
					peredu.scoreONET07, peredu.thScoreONET07Name, peredu.enScoreONET07Name,
					peredu.scoreONET08, peredu.thScoreONET08Name, peredu.enScoreONET08Name,
					peredu.scoreANET11, peredu.thScoreANET11Name, peredu.enScoreANET11Name,
					peredu.scoreANET12, peredu.thScoreANET12Name, peredu.enScoreANET12Name,
					peredu.scoreANET13, peredu.thScoreANET13Name, peredu.enScoreANET13Name,
					peredu.scoreANET14, peredu.thScoreANET14Name, peredu.enScoreANET14Name,
					peredu.scoreANET15, peredu.thScoreANET15Name, peredu.enScoreANET15Name,
					peredu.scoreGAT85, peredu.thScoreGAT85Name, peredu.enScoreGAT85Name,
					peredu.scorePAT71, peredu.thScorePAT71Name, peredu.enScorePAT71Name,
					peredu.scorePAT72, peredu.thScorePAT72Name, peredu.enScorePAT72Name,
					peredu.scorePAT73, peredu.thScorePAT73Name, peredu.enScorePAT73Name,
					peredu.scorePAT74, peredu.thScorePAT74Name, peredu.enScorePAT74Name,
					peredu.scorePAT75, peredu.thScorePAT75Name, peredu.enScorePAT75Name,
					peredu.scorePAT76, peredu.thScorePAT76Name, peredu.enScorePAT76Name,
					peredu.scorePAT77, peredu.thScorePAT77Name, peredu.enScorePAT77Name,
					peredu.scorePAT78, peredu.thScorePAT78Name, peredu.enScorePAT78Name,
					peredu.scorePAT79, peredu.thScorePAT79Name, peredu.enScorePAT79Name,
					peredu.scorePAT80, peredu.thScorePAT80Name, peredu.enScorePAT80Name,
					peredu.scorePAT81, peredu.thScorePAT81Name, peredu.enScorePAT81Name,
					peredu.scorePAT82, peredu.thScorePAT82Name, peredu.enScorePAT82Name,
					peract.thSportsman, peract.enSportsman, peract.sportsmanDetail,
					peract.thSpecialist, peract.enSpecialist, 
					peract.thSpecialistSport, peract.enSpecialistSport, peract.specialistSportDetail,
					peract.thSpecialistArt, peract.enSpecialistArt, peract.specialistArtDetail,
					peract.thSpecialistTechnical, peract.enSpecialistTechnical, peract.specialistTechnicalDetail,
					peract.thSpecialistOther, peract.enSpecialistOther, peract.specialistOtherDetail,
					peract.activityDetail,
					peract.rewardDetail,
					perhel.bodyMassDetail,
					perhel.intoleranceDetail,
					perhel.diseasesDetail,
					perhel.ailHistoryFamilyDetail,
					perhel.travelAbroadDetail,
					perhel.impairmentsNameTH, perhel.impairmentsNameEn,
					perhel.impairmentsEquipment,
					perwok.thOccupation, perwok.enOccupation,
					perwok.agencyNameTH, perwok.agencyNameEN,
					perwok.agencyOther,
					perwok.workplace,
					perwok.position,
					perwok.telephone,
					perwok.salary,
					perfin.thScholarshipFirstBachelorFrom, perfin.enScholarshipFirstBachelorFrom,
					perfin.scholarshipFirstBachelorName,
					perfin.scholarshipFirstBachelorMoney,
					perfin.thScholarshipBachelorFrom, perfin.enScholarshipBachelorFrom,
					perfin.scholarshipBachelorName,
					perfin.scholarshipBachelorMoney,
					perfin.salary AS workDuringStudySalary,
					perfin.workplace AS workDuringStudyWorkplace,
					perfin.thGotMoneyFrom, perfin.enGotMoneyFrom,
					perfin.gotMoneyFromOther,
					perfin.gotMoneyPerMonth,
					perfin.costPerMonth,
					perperprt.idCardFather,
					perperprt.thTitleFullNameFather, perperprt.enTitleFullNameFather,
					perperprt.thTitleInitialsFather, perperprt.enTitleInitialsFather,
					perperprt.firstNameFather, perperprt.middleNameFather, perperprt.lastNameFather,
					perperprt.enFirstNameFather, perperprt.enMiddleNameFather, perperprt.enLastNameFather,
					perperprt.thAliveFather, perperprt.enAliveFather,
					perperprt.thBirthDateFather, perperprt.enBirthDateFather,
					perperprt.ageFather,
					perperprt.thCountryNameFather, perperprt.enCountryNameFather,
					perperprt.thNationalityNameFather, perperprt.enNationalityNameFather,
					perperprt.thOriginNameFather, perperprt.enOriginNameFather,
					perperprt.thReligionNameFather, perperprt.enReligionNameFather,
					perperprt.thBloodTypeNameFather, perperprt.enBloodTypeNameFather,
					perperprt.thMaritalStatusNameFather, perperprt.enMaritalStatusNameFather,
					perperprt.thEducationalBackgroundNameFather, perperprt.enEducationalBackgroundNameFather,
					perperprt.idCardMother,
					perperprt.thTitleFullNameMother, perperprt.enTitleFullNameMother,
					perperprt.thTitleInitialsMother, perperprt.enTitleInitialsMother,
					perperprt.firstNameMother, perperprt.middleNameMother, perperprt.lastNameMother,
					perperprt.enFirstNameMother, perperprt.enMiddleNameMother, perperprt.enLastNameMother,
					perperprt.thAliveMother, perperprt.enAliveMother,
					perperprt.thBirthDateMother, perperprt.enBirthDateMother,
					perperprt.ageMother,
					perperprt.thCountryNameMother, perperprt.enCountryNameMother,
					perperprt.thNationalityNameMother, perperprt.enNationalityNameMother,
					perperprt.thOriginNameMother, perperprt.enOriginNameMother,
					perperprt.thReligionNameMother, perperprt.enReligionNameMother,
					perperprt.thBloodTypeNameMother, perperprt.enBloodTypeNameMother,
					perperprt.thMaritalStatusNameMother, perperprt.enMaritalStatusNameMother,
					perperprt.thEducationalBackgroundNameMother, perperprt.enEducationalBackgroundNameMother,
					perperprt.relationshipNameTH, perperprt.relationshipNameEN,
					perperprt.idCardParent,
					perperprt.thTitleFullNameParent, perperprt.enTitleFullNameParent,
					perperprt.thTitleInitialsParent, perperprt.enTitleInitialsParent,
					perperprt.firstNameParent, perperprt.middleNameParent, perperprt.lastNameParent,
					perperprt.enFirstNameParent, perperprt.enMiddleNameParent, perperprt.enLastNameParent,
					perperprt.thAliveParent, perperprt.enAliveParent,
					perperprt.thBirthDateParent, perperprt.enBirthDateParent,
					perperprt.ageParent,
					perperprt.thCountryNameParent, perperprt.enCountryNameParent,
					perperprt.thNationalityNameParent, perperprt.enNationalityNameParent,
					perperprt.thOriginNameParent, perperprt.enOriginNameParent,
					perperprt.thReligionNameParent, perperprt.enReligionNameParent,
					perperprt.thBloodTypeNameParent, perperprt.enBloodTypeNameParent,
					perperprt.thMaritalStatusNameParent, perperprt.enMaritalStatusNameParent,
					perperprt.thEducationalBackgroundNameParent, perperprt.enEducationalBackgroundNameParent,							
					peraddprt.thCountryNamePermanentFather, peraddprt.enCountryNamePermanentFather,
					peraddprt.thPlaceNamePermanentFather, peraddprt.enPlaceNamePermanentFather,
					peraddprt.thDistrictNamePermanentFather, peraddprt.enDistrictNamePermanentFather,
					peraddprt.thSubdistrictNamePermanentFather, peraddprt.enSubdistrictNamePermanentFather,
					peraddprt.zipCodePermanentFather,
					peraddprt.villagePermanentFather,
					peraddprt.noPermanentFather,
					peraddprt.mooPermanentFather,
					peraddprt.soiPermanentFather,
					peraddprt.roadPermanentFather,
					peraddprt.phoneNumberPermanentFather,
					peraddprt.mobileNumberPermanentFather,
					peraddprt.faxNumberPermanentFather,
					peraddprt.thCountryNamePermanentMother, peraddprt.enCountryNamePermanentMother,
					peraddprt.thPlaceNamePermanentMother, peraddprt.enPlaceNamePermanentMother,
					peraddprt.thDistrictNamePermanentMother, peraddprt.enDistrictNamePermanentMother,
					peraddprt.thSubdistrictNamePermanentMother, peraddprt.enSubdistrictNamePermanentMother,
					peraddprt.zipCodePermanentMother,
					peraddprt.villagePermanentMother,
					peraddprt.noPermanentMother,
					peraddprt.mooPermanentMother,
					peraddprt.soiPermanentMother,
					peraddprt.roadPermanentMother,
					peraddprt.phoneNumberPermanentMother,
					peraddprt.mobileNumberPermanentMother,
					peraddprt.faxNumberPermanentMother,
					peraddprt.thCountryNamePermanentParent, peraddprt.enCountryNamePermanentParent,
					peraddprt.thPlaceNamePermanentParent, peraddprt.enPlaceNamePermanentParent,
					peraddprt.thDistrictNamePermanentParent, peraddprt.enDistrictNamePermanentParent,
					peraddprt.thSubdistrictNamePermanentParent, peraddprt.enSubdistrictNamePermanentParent,
					peraddprt.zipCodePermanentParent,
					peraddprt.villagePermanentParent,
					peraddprt.noPermanentParent,
					peraddprt.mooPermanentParent,
					peraddprt.soiPermanentParent,
					peraddprt.roadPermanentParent,
					peraddprt.phoneNumberPermanentParent,
					peraddprt.mobileNumberPermanentParent,
					peraddprt.faxNumberPermanentParent,											
					peraddprt.thCountryNameCurrentFather, peraddprt.enCountryNameCurrentFather,
					peraddprt.thPlaceNameCurrentFather, peraddprt.enPlaceNameCurrentFather,
					peraddprt.thDistrictNameCurrentFather, peraddprt.enDistrictNameCurrentFather,
					peraddprt.thSubdistrictNameCurrentFather, peraddprt.enSubdistrictNameCurrentFather,
					peraddprt.zipCodeCurrentFather,
					peraddprt.villageCurrentFather,
					peraddprt.noCurrentFather,
					peraddprt.mooCurrentFather,
					peraddprt.soiCurrentFather,
					peraddprt.roadCurrentFather,
					peraddprt.phoneNumberCurrentFather,
					peraddprt.mobileNumberCurrentFather,
					peraddprt.faxNumberCurrentFather,
					peraddprt.thCountryNameCurrentMother, peraddprt.enCountryNameCurrentMother,
					peraddprt.thPlaceNameCurrentMother, peraddprt.enPlaceNameCurrentMother,
					peraddprt.thDistrictNameCurrentMother, peraddprt.enDistrictNameCurrentMother,
					peraddprt.thSubdistrictNameCurrentMother, peraddprt.enSubdistrictNameCurrentMother,
					peraddprt.zipCodeCurrentMother,
					peraddprt.villageCurrentMother,
					peraddprt.noCurrentMother,
					peraddprt.mooCurrentMother,
					peraddprt.soiCurrentMother,
					peraddprt.roadCurrentMother,
					peraddprt.phoneNumberCurrentMother,
					peraddprt.mobileNumberCurrentMother,
					peraddprt.faxNumberCurrentMother,
					peraddprt.thCountryNameCurrentParent, peraddprt.enCountryNameCurrentParent,
					peraddprt.thPlaceNameCurrentParent, peraddprt.enPlaceNameCurrentParent,
					peraddprt.thDistrictNameCurrentParent, peraddprt.enDistrictNameCurrentParent,
					peraddprt.thSubdistrictNameCurrentParent, peraddprt.enSubdistrictNameCurrentParent,
					peraddprt.zipCodeCurrentParent,
					peraddprt.villageCurrentParent,
					peraddprt.noCurrentParent,
					peraddprt.mooCurrentParent,
					peraddprt.soiCurrentParent,
					peraddprt.roadCurrentParent,
					peraddprt.phoneNumberCurrentParent,
					peraddprt.mobileNumberCurrentParent,
					peraddprt.faxNumberCurrentParent,								
					perwokprt.thOccupationFather, perwokprt.enOccupationFather,
					perwokprt.thAgencyNameFather, perwokprt.enAgencyNameFather,
					perwokprt.agencyOtherFather,
					perwokprt.workplaceFather,
					perwokprt.positionFather,
					perwokprt.telephoneFather,
					perwokprt.salaryFather,
					perwokprt.thOccupationMother, perwokprt.enOccupationMother,
					perwokprt.thAgencyNameMother, perwokprt.enAgencyNameMother,
					perwokprt.agencyOtherMother,
					perwokprt.workplaceMother,
					perwokprt.positionMother,
					perwokprt.telephoneMother,
					perwokprt.salaryMother,
					perwokprt.thOccupationParent, perwokprt.enOccupationParent,
					perwokprt.thAgencyNameParent, perwokprt.enAgencyNameParent,
					perwokprt.agencyOtherParent,
					perwokprt.workplaceParent,
					perwokprt.positionParent,
					perwokprt.telephoneParent,
					perwokprt.salaryParent				
			INTO	#tbStudentRecords
			FROM	fnc_perGetPersonStudent(@personId) AS stdstd LEFT JOIN
					fnc_perGetAddress(@personId) AS peradd ON stdstd.id = peradd.id LEFT JOIN
					fnc_perGetEducation(@personId) AS peredu ON stdstd.id = peredu.id LEFT JOIN
					fnc_perGetActivity(@personId) AS peract ON stdstd.id = peract.id LEFT JOIN
					fnc_perGetHealthy(@personId) AS perhel ON stdstd.id = perhel.id LEFT JOIN
					fnc_perGetWork(@personId) AS perwok ON stdstd.id = perwok.id LEFT JOIN
					fnc_perGetFinancial(@personId) AS perfin ON stdstd.id = perfin.id LEFT JOIN
					fnc_perGetPersonParent(@personId) AS perperprt ON stdstd.id = perperprt.id LEFT JOIN
					fnc_perGetAddressParent(@personId) AS peraddprt ON stdstd.id = peraddprt.id LEFT JOIN
					fnc_perGetWorkParent(@personId) AS perwokprt ON stdstd.id = perwokprt.id
			
			SET @recordCount = (SELECT COUNT(id) FROM #tbStudentRecords)

			IF (@recordCount > 0)
			BEGIN				
				SELECT	(SELECT dbo.fnc_stdGetStudentRecordsToHTML('style', '', '', '', '', '', '', '')) AS formStyle,
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('open', '', '', '', '', '', '', '')) AS formOpen,
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('head', 'ข้อมูลระเบียนประวัตินักศึกษา', 'Student Records', '', '', '', '', '')) AS formHead,
						(
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('contentnocol', '', '', '', '', '', '<div class="avatar-cv profilepicture-cv"><div class="watermark-cv"></div><img class="img-cv" src="http://www.student.mahidol.ac.th/Infinity/Profile/Content/Handler/eProfileStaff/ePFStaffHandler.ashx?action=image2streamnoencode&f=http://intranet.student.mahidol/studentweb/resources/images/' + ISNULL(profilePictureName, '') + '" /></div>', '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'รหัสนักศึกษา', 'Student ID', ISNULL(studentCode, 'XXXXXXX'), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ชื่อ', 'Full Name', (ISNULL(thTitleInitials, ISNULL(thTitleFullName, '')) + ISNULL(firstName, '') + ' ' + ISNULL(middleName, '') + ' ' + ISNULL(lastName, '')), UPPER((ISNULL(enTitleInitials, ISNULL(enTitleFullName, '')) + ISNULL(enFirstName, '') + ' ' + ISNULL(enMiddleName, '') + ' ' + ISNULL(enLastName, ''))))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ระดับการศึกษา', 'Degree Level', ISNULL(degreeLevelNameTH, ''), ISNULL(degreeLevelNameEN, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'คณะ', 'Faculty', ISNULL(facultyNameTH, ''), ISNULL(facultyNameEN, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'หลักสูตร', 'Program', ISNULL(programNameTH, ''), ISNULL(programNameEN, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ปีที่เข้าศึกษา', 'Year Entry', ISNULL(yearEntry, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ชั้นปี', 'Class', ISNULL(class, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ระบบการสอบเข้า', 'Addmission Type', ISNULL(stdEntranceTypeNameTH, ''), ISNULL(stdEntranceTypeNameEN, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'สถานภาพการเป็นนักศึกษา', 'Student Status', ISNULL(statusTypeNameTH, ''), ISNULL(statusTypeNameEN, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'วันที่สำเร็จการศึกษา', 'Graduation Date', ISNULL(CONVERT(VARCHAR(10), graduateDate, 103), ''), ''))
						) AS formStudent,
						(
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('subject', '', '', '01',  'ข้อมูลส่วนตัว', 'Student''s Personal Data', '', '')) +			
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'เลขประจำตัวประชาชน หรือ เลขหนังสือเดินทาง', 'Identification Number or Passport No.', ISNULL(idCard, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ชื่อ', 'Full Name', (ISNULL(thTitleInitials, ISNULL(thTitleFullName, '')) + ISNULL(firstName, '') + ' ' + ISNULL(middleName, '') + ' ' + ISNULL(lastName, '')), (ISNULL(enTitleInitials, ISNULL(enTitleFullName, '')) + ISNULL(enFirstName, '') + ' ' + ISNULL(enMiddleName, '') + ' ' + ISNULL(enLastName, '')))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'เพศ', 'Gender', ISNULL(thGenderFullName, ''), ISNULL(enGenderFullName, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'สถานภาพชีวิต', 'Living Status', ISNULL(thAlive, ''), ISNULL(enAlive, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'วันเดือนปีเกิด', 'Date of Birth', ISNULL(thBirthDate, ''), ISNULL(enBirthDate, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'อายุ ( ปี )', 'Age ( yr )', ISNULL(CONVERT(VARCHAR, age), ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ประเทศบ้านเกิด', 'Country of Birthplace', ISNULL(countryNameTH, ''), ISNULL(countryNameEN, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'สัญชาติ', 'Nationality', ISNULL(thNationalityName, ''), ISNULL(enNationalityName, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'เชื้อชาติ', 'Race', ISNULL(thOriginName, ''), ISNULL(enOriginName, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ศาสนา', 'Religion', ISNULL(thReligionName, ''), ISNULL(enReligionName, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'กรุ๊ปเลือด', 'Blood Group', ISNULL(thBloodTypeName, ''), ISNULL(enBloodTypeName, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'สถานภาพทางการสมรส', 'Marital Status', ISNULL(thMaritalStatusName, ''), ISNULL(enMaritalStatusName, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'วุฒิการศึกษา', 'Educational Background', ISNULL(thEducationalBackgroundName, ''), ISNULL(enEducationalBackgroundName, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'จำนวนพี่น้องทั้งหมด ( รวมตัวเอง ) ( คน )', 'Number of Siblings ( including myself ) ( people )', ISNULL(brotherhoodNumber, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'นักศึกษาเป็นบุตรคนที่', 'Sequence Child', ISNULL(childhoodNumber, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'จำนวนพี่น้องที่กำลังศึกษาอยู่ ( รวมตัวเอง ) ( คน )', 'Number of Siblings Still Studying ( including myself ) ( people )', ISNULL(studyhoodNumber, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'อีเมล์', 'Email Address', ISNULL(email, ''), ''))
						) AS formPersonal,
						(
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('subject', '', '', '02', 'ข้อมูลที่อยู่ตามทะเบียนบ้าน', 'Permanent Address Information', '', '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ประเทศ', 'Country', ISNULL(thCountryNamePermanent, ''), ISNULL(enCountryNamePermanent, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'จังหวัด', 'Province', ISNULL(thPlaceNamePermanent, ''), ISNULL(enPlaceNamePermanent, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'อำเภอ / เขต', 'District / Area', ISNULL(thDistrictNamePermanent, ''), ISNULL(enDistrictNamePermanent, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ตำบล / แขวง', 'Sub-district / Sub-area', ISNULL(thSubdistrictNamePermanent, ''), ISNULL(enSubdistrictNamePermanent, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'รหัสไปรษณีย์', 'ZIP / Postal Code', ISNULL(zipCodePermanent, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'หมู่บ้าน', 'Village', ISNULL(villagePermanent, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'บ้านเลขที่', 'Address Number', ISNULL(noPermanent, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'หมู่ที่', 'Village No.', ISNULL(mooPermanent, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ตรอก / ซอย', 'Lane / Alley', ISNULL(soiPermanent, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ถนน', 'Road', ISNULL(roadPermanent, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'เบอร์โทรศัพท์บ้าน', 'Phone Number', ISNULL(phoneNumberPermanent, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'เบอร์โทรศัพท์มือถือ', 'Mobile Number', ISNULL((CASE WHEN (CHARINDEX(mobileNumberPermanent, @strBlank) = 0) THEN mobileNumberPermanent ELSE '' END), ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'เบอร์แฟกซ์', 'Fax Number', ISNULL(faxNumberPermanent, ''), ''))
						) AS formPermanentAddress,
						(
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('subject', '', '', '03', 'ข้อมูลที่อยู่ปัจจุบันที่ติดต่อได้', 'Current Address Information', '', '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ประเทศ', 'Country', ISNULL(thCountryNameCurrent, ''), ISNULL(enCountryNameCurrent, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'จังหวัด', 'Province', ISNULL(thPlaceNameCurrent, ''), ISNULL(enPlaceNameCurrent, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'อำเภอ / เขต', 'District / Area', ISNULL(thDistrictNameCurrent, ''), ISNULL(enDistrictNameCurrent, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ตำบล / แขวง', 'Sub-district / Sub-area', ISNULL(thSubdistrictNameCurrent, ''), ISNULL(enSubdistrictNameCurrent, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'รหัสไปรษณีย์', 'ZIP / Postal Code', ISNULL(zipCodeCurrent, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'หมู่บ้าน', 'Village', ISNULL(villageCurrent, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'บ้านเลขที่', 'Address Number', ISNULL(noCurrent, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'หมู่ที่', 'Village No.', ISNULL(mooCurrent, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ตรอก / ซอย', 'Lane / Alley', ISNULL(soiCurrent, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ถนน', 'Road', ISNULL(roadCurrent, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'เบอร์โทรศัพท์บ้าน', 'Phone Number', ISNULL(phoneNumberCurrent, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'เบอร์โทรศัพท์มือถือ', 'Mobile Number', ISNULL(mobileNumberCurrent, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'เบอร์แฟกซ์', 'Fax Number', ISNULL(faxNumberCurrent, ''), ''))
						) AS formCurrentAddress,
						(
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('subject', '', '', '04', 'ข้อมูลการศึกษาระดับประถม', 'Primary Educational Information', '', '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ชื่อสถานศึกษาระดับประถม', 'Primary School Name', ISNULL(primarySchoolName, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ประเทศ', 'Country', ISNULL(thPrimarySchoolCountryName, ''), ISNULL(enPrimarySchoolCountryName, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'จังหวัด', 'Province', ISNULL(thPrimarySchoolPlaceName, ''), ISNULL(enPrimarySchoolPlaceName, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ปีที่เข้าศึกษา', 'Year Attended', ISNULL(primarySchoolYearAttended, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ปีที่สำเร็จการศึกษา', 'Year Graduation', ISNULL(primarySchoolYearGraduate, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'เกรดเฉลี่ยสะสม', 'Grade Point Average ( GPA )', ISNULL(primarySchoolGPA, ''), ''))
						) AS formPrimaryEducation,
						(
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('subject', '', '', '05', 'ข้อมูลการศึกษาระดับมัธยมต้น', 'Junior Educational Information', '', '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ชื่อสถานศึกษาระดับมัธยมต้น', 'Junior High School Name', ISNULL(juniorHighSchoolName, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ประเทศ', 'Country', ISNULL(thJuniorHighSchoolCountryName, ''), ISNULL(enJuniorHighSchoolCountryName, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'จังหวัด', 'Province', ISNULL(thJuniorHighSchoolPlaceName, ''), ISNULL(enJuniorHighSchoolPlaceName, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ปีที่เข้าศึกษา', 'Year Attended', ISNULL(juniorHighSchoolYearAttended, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ปีที่สำเร็จการศึกษา', 'Year Graduation', ISNULL(juniorHighSchoolYearGraduate, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'เกรดเฉลี่ยสะสม', 'Grade Point Average ( GPA )', ISNULL(juniorHighSchoolGPA, ''), ''))
						) AS formJuniorEducation,
						(
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('subject', '', '', '06', 'ข้อมูลการศึกษาระดับมัธยมปลาย', 'High School Educational Information', '', '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ชื่อสถานศึกษาระดับมัธยมปลาย', 'High School Name', ISNULL(highSchoolName, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ประเทศ', 'Country', ISNULL(thHighSchoolCountryName, ''), ISNULL(enHighSchoolCountryName, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'จังหวัด', 'Province', ISNULL(thHighSchoolPlaceName, ''), ISNULL(enHighSchoolPlaceName, ''))) +					 
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'เลขประจำตัวนักเรียน', 'Students Identification Number', ISNULL(highSchoolStudentId, ''), '')) +	
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'สายการเรียน', 'Major', ISNULL(thHighSchoolEducationalMajorName, ISNULL(educationalMajorOtherHighSchool, '')), ISNULL(enHighSchoolEducationalMajorName, ''))) +	
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ปีที่เข้าศึกษา', 'Year Attended', ISNULL(highSchoolYearAttended, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ปีที่สำเร็จการศึกษา', 'Year Graduation', ISNULL(highSchoolYearGraduate, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'เกรดเฉลี่ยสะสม', 'Grade Point Average ( GPA )', ISNULL(highSchoolGPA, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'วุฒิการศึกษา', 'Educational Background', ISNULL(thHighSchoolEducationalBackgroundName, ''), ISNULL(enHighSchoolEducationalBackgroundName, '')))
						) AS formHighSchoolEducation,
						(
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('subject', '', '', '07', 'ข้อมูลการศึกษาก่อนที่เข้า ม.มหิดล', 'Prior to Entering MU Information', '', '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'วุฒิการศึกษาขั้นสูงสุดก่อนเข้าม.มหิดล', 'What was Your Highest Education Achieved Before Enrolling to Mahidol University', ISNULL(thMUEducationalBackgroundName, ''), ISNULL(enMUEducationalBackgroundName, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'สำเร็จการศึกษาขั้นสูงสุดโดยวิธี', 'How was the Above Education Achieved', ISNULL(thGraduateBy, ''), ISNULL(enGraduateBy, ''))) +	
						(CASE WHEN (graduateBySchoolName IS NOT NULL) THEN (SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'สถานศึกษาที่สอบเทียบ', 'School Name of Informal Education', ISNULL(graduateBySchoolName, ''), '')) ELSE '' END) +	
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'จำนวนครั้งที่สอบเข้าในระดับมหาวิทยาลัย', 'Number of Entrance Exams Taken', ISNULL(thEntranceTime, ''), ISNULL(enEntranceTime, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'การเข้าเป็นนักศึกษามหาวิทยาลัย', 'Being a University Student', ISNULL(thStudentIs, ''), ISNULL(enStudentIs, ''))) +	
						(CASE WHEN (studentIsUniversity IS NOT NULL) THEN (SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'เคยเป็นนักศึกษามหาวิทยาลัย', 'Former University Student', ISNULL(studentIsUniversity, ''), '')) ELSE '' END) +	
						(CASE WHEN (studentIsFaculty IS NOT NULL) THEN (SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'เคยเป็นนักศึกษาคณะ', 'Former Faculty Student', ISNULL(studentIsFaculty, ''), '')) ELSE '' END) +	
						(CASE WHEN (studentIsProgram IS NOT NULL) THEN (SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'เคยเป็นนักศึกษาหลักสูตร', 'Former Program Student', ISNULL(studentIsProgram, ''), '')) ELSE '' END) +	
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ระบบการสอบเข้า', 'Entrance Examination System', ISNULL(entranceTypeNameTH, ''), ISNULL(entranceTypeNameEN, ''))) +	
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'เลือก ม.มหิดลเป็นอันดับที่', 'Rank Selected Mahidol University', ISNULL(admissionRanking, ''), ''))
						) AS formMUEducational,
						(
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('subject', '', '', '08', 'ข้อมูลการศึกษาคะแนนสอบ', 'Admission Scores Information', '', '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', ('คะแนนสอบ ' + thScoreONET01Name), ('Scores ' + enScoreONET01Name), ISNULL(CONVERT(VARCHAR, CONVERT(MONEY, scoreONET01),1), ''), '')) +	
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', ('คะแนนสอบ ' + thScoreONET02Name), ('Scores ' + enScoreONET02Name), ISNULL(CONVERT(VARCHAR, CONVERT(MONEY, scoreONET02),1), ''), '')) +	
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', ('คะแนนสอบ ' + thScoreONET03Name), ('Scores ' + enScoreONET03Name), ISNULL(CONVERT(VARCHAR, CONVERT(MONEY, scoreONET03),1), ''), '')) +	
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', ('คะแนนสอบ ' + thScoreONET04Name), ('Scores ' + enScoreONET04Name), ISNULL(CONVERT(VARCHAR, CONVERT(MONEY, scoreONET04),1), ''), '')) +	
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', ('คะแนนสอบ ' + thScoreONET05Name), ('Scores ' + enScoreONET05Name), ISNULL(CONVERT(VARCHAR, CONVERT(MONEY, scoreONET05),1), ''), '')) +	
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', ('คะแนนสอบ ' + thScoreONET06Name), ('Scores ' + enScoreONET06Name), ISNULL(CONVERT(VARCHAR, CONVERT(MONEY, scoreONET06),1), ''), '')) +	
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', ('คะแนนสอบ ' + thScoreONET07Name), ('Scores ' + enScoreONET07Name), ISNULL(CONVERT(VARCHAR, CONVERT(MONEY, scoreONET07),1), ''), '')) +	
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', ('คะแนนสอบ ' + thScoreONET08Name), ('Scores ' + enScoreONET08Name), ISNULL(CONVERT(VARCHAR, CONVERT(MONEY, scoreONET08),1), ''), '')) +	
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', ('คะแนนสอบ ' + thScoreANET11Name), ('Scores ' + enScoreANET11Name), ISNULL(CONVERT(VARCHAR, CONVERT(MONEY, scoreANET11),1), ''), '')) +	
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', ('คะแนนสอบ ' + thScoreANET12Name), ('Scores ' + enScoreANET12Name), ISNULL(CONVERT(VARCHAR, CONVERT(MONEY, scoreANET12),1), ''), '')) +	
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', ('คะแนนสอบ ' + thScoreANET13Name), ('Scores ' + enScoreANET13Name), ISNULL(CONVERT(VARCHAR, CONVERT(MONEY, scoreANET13),1), ''), '')) +	
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', ('คะแนนสอบ ' + thScoreANET14Name), ('Scores ' + enScoreANET14Name), ISNULL(CONVERT(VARCHAR, CONVERT(MONEY, scoreANET14),1), ''), '')) +	
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', ('คะแนนสอบ ' + thScoreANET15Name), ('Scores ' + enScoreANET15Name), ISNULL(CONVERT(VARCHAR, CONVERT(MONEY, scoreANET15),1), ''), '')) +	
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', ('คะแนนสอบ ' + thScoreGAT85Name), ('Scores ' + enScoreGAT85Name), ISNULL(CONVERT(VARCHAR, CONVERT(MONEY, scoreGAT85),1), ''), '')) +	
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', ('คะแนนสอบ ' + thScorePAT71Name), ('Scores ' + enScorePAT71Name), ISNULL(CONVERT(VARCHAR, CONVERT(MONEY, scorePAT71),1), ''), '')) +	
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', ('คะแนนสอบ ' + thScorePAT72Name), ('Scores ' + enScorePAT72Name), ISNULL(CONVERT(VARCHAR, CONVERT(MONEY, scorePAT72),1), ''), '')) +	
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', ('คะแนนสอบ ' + thScorePAT73Name), ('Scores ' + enScorePAT73Name), ISNULL(CONVERT(VARCHAR, CONVERT(MONEY, scorePAT73),1), ''), '')) +	
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', ('คะแนนสอบ ' + thScorePAT74Name), ('Scores ' + enScorePAT74Name), ISNULL(CONVERT(VARCHAR, CONVERT(MONEY, scorePAT74),1), ''), '')) +	
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', ('คะแนนสอบ ' + thScorePAT75Name), ('Scores ' + enScorePAT75Name), ISNULL(CONVERT(VARCHAR, CONVERT(MONEY, scorePAT75),1), ''), '')) +	
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', ('คะแนนสอบ ' + thScorePAT76Name), ('Scores ' + enScorePAT76Name), ISNULL(CONVERT(VARCHAR, CONVERT(MONEY, scorePAT76),1), ''), '')) +	
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', ('คะแนนสอบ ' + thScorePAT77Name), ('Scores ' + enScorePAT77Name), ISNULL(CONVERT(VARCHAR, CONVERT(MONEY, scorePAT77),1), ''), '')) +	
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', ('คะแนนสอบ ' + thScorePAT78Name), ('Scores ' + enScorePAT78Name), ISNULL(CONVERT(VARCHAR, CONVERT(MONEY, scorePAT78),1), ''), '')) +	
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', ('คะแนนสอบ ' + thScorePAT79Name), ('Scores ' + enScorePAT79Name), ISNULL(CONVERT(VARCHAR, CONVERT(MONEY, scorePAT79),1), ''), '')) +						 
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', ('คะแนนสอบ ' + thScorePAT80Name), ('Scores ' + enScorePAT80Name), ISNULL(CONVERT(VARCHAR, CONVERT(MONEY, scorePAT80),1), ''), '')) +						 					 
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', ('คะแนนสอบ ' + thScorePAT81Name), ('Scores ' + enScorePAT81Name), ISNULL(CONVERT(VARCHAR, CONVERT(MONEY, scorePAT81),1), ''), '')) +						 					 
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', ('คะแนนสอบ ' + thScorePAT82Name), ('Scores ' + enScorePAT82Name), ISNULL(CONVERT(VARCHAR, CONVERT(MONEY, scorePAT82),1), ''), ''))
						) AS formAdmissionScores,
						(
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('subject', '', '', '09', 'ข้อมูลความสามารถพิเศษ', 'Talent Information', '', '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'เคยเป็นนักกีฬา', 'Sportsman', REPLACE(REPLACE(ISNULL(sportsmanDetail, ''), CHAR(13), ''), CHAR(10), '<br />'), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ความสามารถพิเศษด้านกีฬา', 'Sport Talent', REPLACE(REPLACE(ISNULL(specialistSportDetail, ''), CHAR(13), ''), CHAR(10), '<br />'), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ความสามารถพิเศษด้านศิลปะ', 'Art Talent', REPLACE(REPLACE(ISNULL(specialistArtDetail, ''), CHAR(13), ''), CHAR(10), '<br />'), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ความสามารถพิเศษด้านวิชาการ', 'Academic Talent', REPLACE(REPLACE(ISNULL(specialistTechnicalDetail, ''), CHAR(13), ''), CHAR(10), '<br />'), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ความสามารถพิเศษด้านอื่น ๆ', 'Others Talent', REPLACE(REPLACE(ISNULL(specialistOtherDetail, ''), CHAR(13), ''), CHAR(10), '<br />'), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'เคยร่วมกิจกรรมของโรงเรียน', 'School Activities Involvement', REPLACE(REPLACE(ISNULL(activityDetail, ''), CHAR(13), ''), CHAR(10), '<br />'), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'เคยได้รับทุน / รางวัล', 'Awards', REPLACE(REPLACE(ISNULL(rewardDetail, ''), CHAR(13), ''), CHAR(10), '<br />'), ''))
						) AS formTalent,
						(
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('subject', '', '', '10', 'ข้อมูลสุขภาพ', 'Health Information', '', '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ดัชนีมวลกาย ( น้ำหนัก, ส่วนสูง, ค่าดัชนีมวลกาย, ข้อมูล ณ วันที่ )', 'Body Mass Index ( Weight, Height, BMI, Latest Update )', REPLACE(REPLACE(ISNULL(bodyMassDetail, ''), ':', ', '), ';', '<br />'), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ประวัติการแพ้ยา', 'Drug Allergy History', REPLACE(REPLACE(ISNULL(intoleranceDetail, ''), CHAR(13), ''), CHAR(10), '<br />'), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'โรคประจำตัว', 'Diseases', REPLACE(REPLACE(ISNULL(diseasesDetail, ''), CHAR(13), ''), CHAR(10), '<br />'), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ประวัติการเจ็บป่วยในครอบครัว', 'Family History of Illness', REPLACE(REPLACE(ISNULL(ailHistoryFamilyDetail, ''), CHAR(13), ''), CHAR(10), '<br />'), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'การเดินทางไปต่างประเทศ ( ประเทศ, วันที่เดินทาง )', 'Travel Abroad ( Country, Date of Travel )', REPLACE(REPLACE(REPLACE(ISNULL(travelAbroadDetail, ''), ':', ' : '), ',', ', '), ';', '<br />'), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ความบกพร่องทางสุขภาพ', 'Health Impairments', ISNULL(impairmentsNameTH, ''), ISNULL(impairmentsNameEN, ''))) +	
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'โดยมีอุปกรณ์ที่ใช้สำหรับช่วยเหลือ', 'The Equipment Used for Assistance', ISNULL(impairmentsEquipment, ''), ''))
						) AS formHealth,
						(
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('subject', '', '', '11', 'ข้อมูลการทำงาน', 'Worker Information', '', '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'อาชีพ', 'Occupation', ISNULL(thOccupation, ''), ISNULL(enOccupation, ''))) +	
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ต้นสังกัด', 'Agency', ISNULL(agencyNameTH, ISNULL(agencyOther, '')), ISNULL(agencyNameEN, ''))) +	
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'สถานที่ทำงาน', 'Workplace', ISNULL(workplace, ''), '')) +	
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ตำแหน่ง', 'Position', ISNULL(position, ''), '')) +	
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'โทรศัพท์ที่ทำงาน', 'Workplace Telephone', ISNULL(telephone, ''), '')) +	
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'รายได้เฉลี่ยต่อเดือน ( บาท )', 'Income ( bath )', ISNULL(CONVERT(VARCHAR, CONVERT(MONEY, salary),1), ''), ''))
						) AS formWorker,
						(
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('subject', '', '', '12', 'ข้อมูลการเงิน', 'Finance Information', '', '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ก่อนศึกษาระดับป.ตรีได้รับทุนการศึกษาจาก', 'Prior to University Education Received Scholarship From', ISNULL(thScholarshipFirstBachelorFrom, ''), ISNULL(enScholarshipFirstBachelorFrom, ''))) +	
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ก่อนศึกษาระดับป.ตรีได้รับทุนการศึกษาชื่อ', 'Prior to University Education Received Scholarship Name', ISNULL(scholarshipFirstBachelorName, ''), '')) +	
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ก่อนศึกษาระดับป.ตรีได้รับทุนการศึกษาเป็นจำนวนเงิน ( บาท / ปี )', 'Prior to University Education Received Scholarship Amount ( bath / yr )', ISNULL(CONVERT(VARCHAR, CONVERT(MONEY, scholarshipFirstBachelorMoney),1), ''), '')) +	
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ระหว่างศึกษาระดับป.ตรีได้รับทุนการศึกษาจาก', 'During to University Education Received Scholarship From', ISNULL(thScholarshipBachelorFrom, ''), ISNULL(enScholarshipBachelorFrom, ''))) +	
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ระหว่างศึกษาระดับป.ตรีได้รับทุนการศึกษาชื่อ', 'During to University Education Received Scholarship Name', ISNULL(scholarshipBachelorName, ''), '')) +	
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ระหว่างศึกษาระดับป.ตรีได้รับทุนการศึกษาเป็นจำนวนเงิน ( บาท /  ปี )', 'During to University Education Received Scholarship Amount ( bath / yr )', ISNULL(CONVERT(VARCHAR, CONVERT(MONEY, scholarshipBachelorMoney),1), ''), '')) +	
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ระหว่างศึกษานักศึกษาทำงานมีรายได้ประมาณ ( บาท / เดือน )', 'Income of Work During Study ( bath / month )', ISNULL(CONVERT(VARCHAR, CONVERT(MONEY, workDuringStudySalary),1), ''), '')) +	
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ระหว่างศึกษานักศึกษาทำงานที่', 'Workplace of Work During Study', ISNULL(workDuringStudyWorkplace, ''), '')) +	
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ได้รับการอุปการะเงินค่าใช้จ่ายส่วนใหญ่จาก', 'Financial Support From', ISNULL(thGotMoneyFrom, ISNULL(gotMoneyFromOther, '')), ISNULL(enGotMoneyFrom, ''))) +						 
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ได้รับการอุปการะเงินค่าใช้จ่ายเดือนละ ( บาท / เดือน )', 'Received Monthly Financial Support ( bath / month )', ISNULL(CONVERT(VARCHAR, CONVERT(MONEY, gotMoneyPerMonth),1), ''), '')) +	
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ค่าใช้จ่ายส่วนตัวไม่รวมค่าธรรมเนียมการศึกษา ( บาท / เดือน )', 'Personal Expense Not Including Educational Fees ( bath / month )', ISNULL(CONVERT(VARCHAR, CONVERT(MONEY, costPerMonth),1), ''), ''))
						) AS formFinance,					
						(
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('subject', '', '', '13', 'ข้อมูลส่วนตัวของบิดา', 'Personal Data of Father', '', '')) +
 						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'เลขประจำตัวประชาชน หรือ เลขหนังสือเดินทาง', 'Identification Number or Passport No.', ISNULL(idCardFather, ''), '')) +	
 						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ชื่อ', 'Full Name', (ISNULL(thTitleInitialsFather, ISNULL(thTitleFullNameFather, '')) + ISNULL(firstNameFather, '') + ' ' + ISNULL(middleNameFather, '') + ' ' + ISNULL(lastNameFather, '')), (ISNULL(enTitleInitialsFather, ISNULL(enTitleFullNameFather, '')) + ISNULL(enFirstNameFather, '') + ' ' + ISNULL(enMiddleNameFather, '') + ' ' + ISNULL(enLastNameFather, '')))) +
 						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'สถานภาพชีวิต', 'Living Status', ISNULL(thAliveFather, ''), ISNULL(enAliveFather, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'วันเดือนปีเกิด', 'Date of Birth', ISNULL(thBirthDateFather, ''), ISNULL(enBirthDateFather, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'อายุ ( ปี )', 'Age ( yr )', ISNULL(CONVERT(VARCHAR, ageFather), ''), '')) + 					 
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ประเทศบ้านเกิด', 'Country of Birthplace', ISNULL(thCountryNameFather, ''), ISNULL(enCountryNameFather, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'สัญชาติ', 'Nationality', ISNULL(thNationalityNameFather, ''), ISNULL(enNationalityNameFather, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'เชื้อชาติ', 'Race', ISNULL(thOriginNameFather, ''), ISNULL(enOriginNameFather, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ศาสนา', 'Religion', ISNULL(thReligionNameFather, ''), ISNULL(enReligionNameFather, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'กรุ๊ปเลือด', 'Blood Group', ISNULL(thBloodTypeNameFather, ''), ISNULL(enBloodTypeNameFather, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'สถานภาพทางการสมรส', 'Marital Status', ISNULL(thMaritalStatusNameFather, ''), ISNULL(enMaritalStatusNameFather, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'วุฒิการศึกษา', 'Educational Background', ISNULL(thEducationalBackgroundNameFather, ''), ISNULL(enEducationalBackgroundNameFather, '')))
						) AS formPersonalFather,
						(
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('subject', '', '', '14', 'ข้อมูลที่อยู่ตามทะเบียนบ้านของบิดา', 'Permanent Address Information of Father', '', '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ประเทศ', 'Country', ISNULL(thCountryNamePermanentFather, ''), ISNULL(enCountryNamePermanentFather, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'จังหวัด', 'Province', ISNULL(thPlaceNamePermanentFather, ''), ISNULL(enPlaceNamePermanentFather, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'อำเภอ / เขต', 'District / Area', ISNULL(thDistrictNamePermanentFather, ''), ISNULL(enDistrictNamePermanentFather, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ตำบล / แขวง', 'Sub-district / Sub-area', ISNULL(thSubdistrictNamePermanentFather, ''), ISNULL(enSubdistrictNamePermanentFather, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'รหัสไปรษณีย์', 'ZIP / Postal Code', ISNULL(zipCodePermanentFather, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'หมู่บ้าน', 'Village', ISNULL(villagePermanentFather, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'บ้านเลขที่', 'Address Number', ISNULL(noPermanentFather, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'หมู่ที่', 'Village No.', ISNULL(mooPermanentFather, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ตรอก / ซอย', 'Lane / Alley', ISNULL(soiPermanentFather, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ถนน', 'Road', ISNULL(roadPermanentFather, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'เบอร์โทรศัพท์บ้าน', 'Phone Number', ISNULL(phoneNumberPermanentFather, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'เบอร์โทรศัพท์มือถือ', 'Mobile Number', ISNULL(mobileNumberPermanentFather, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'เบอร์แฟกซ์', 'Fax Number', ISNULL(faxNumberPermanentFather, ''), ''))
						) AS formPermanentAddressFather,
						(
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('subject', '', '', '15', 'ข้อมูลที่อยู่ปัจจุบันที่ติดต่อได้ของบิดา', 'Current Address Information of Father', '', '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ประเทศ', 'Country', ISNULL(thCountryNameCurrentFather, ''), ISNULL(enCountryNameCurrentFather, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'จังหวัด', 'Province', ISNULL(thPlaceNameCurrentFather, ''), ISNULL(enPlaceNameCurrentFather, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'อำเภอ / เขต', 'District / Area', ISNULL(thDistrictNameCurrentFather, ''), ISNULL(enDistrictNameCurrentFather, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ตำบล / แขวง', 'Sub-district / Sub-area', ISNULL(thSubdistrictNameCurrentFather, ''), ISNULL(enSubdistrictNameCurrentFather, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'รหัสไปรษณีย์', 'ZIP / Postal Code', ISNULL(zipCodeCurrentFather, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'หมู่บ้าน', 'Village', ISNULL(villageCurrentFather, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'บ้านเลขที่', 'Address Number', ISNULL(noCurrentFather, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'หมู่ที่', 'Village No.', ISNULL(mooCurrentFather, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ตรอก / ซอย', 'Lane / Alley', ISNULL(soiCurrentFather, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ถนน', 'Road', ISNULL(roadCurrentFather, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'เบอร์โทรศัพท์บ้าน', 'Phone Number', ISNULL(phoneNumberCurrentFather, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'เบอร์โทรศัพท์มือถือ', 'Mobile Number', ISNULL(mobileNumberCurrentFather, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'เบอร์แฟกซ์', 'Fax Number', ISNULL(faxNumberCurrentFather, ''), ''))
						) AS formCurrentAddressFather,
						(
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('subject', '', '', '16', 'ข้อมูลการทำงานของบิดา', 'Worker Information of Father', '', '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'อาชีพ', 'Occupation', ISNULL(thOccupationFather, ''), ISNULL(enOccupationFather, ''))) +	
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ต้นสังกัด', 'Agency', ISNULL(thAgencyNameFather, ISNULL(agencyOtherFather, '')), ISNULL(enAgencyNameFather, ''))) +	
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'สถานที่ทำงาน', 'Workplace', ISNULL(workplaceFather, ''), '')) +	
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ตำแหน่ง', 'Position', ISNULL(positionFather, ''), '')) +	
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'โทรศัพท์ที่ทำงาน', 'Workplace Telephone', ISNULL(telephoneFather, ''), '')) +	
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'รายได้เฉลี่ยต่อเดือน ( บาท )', 'Income ( bath )', ISNULL(CONVERT(VARCHAR, CONVERT(MONEY, salaryFather),1), ''), ''))
						) AS formWorkerFather,
						(
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('subject', '', '', '17', 'ข้อมูลส่วนตัวของมารดา', 'Personal Data of Mother', '', '')) +
 						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'เลขประจำตัวประชาชน หรือ เลขหนังสือเดินทาง', 'Identification Number or Passport No.', ISNULL(idCardMother, ''), '')) +	
 						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ชื่อ', 'Full Name', (ISNULL(thTitleInitialsMother, ISNULL(thTitleFullNameMother, '')) + ISNULL(firstNameMother, '') + ' ' + ISNULL(middleNameMother, '') + ' ' + ISNULL(lastNameMother, '')), (ISNULL(enTitleInitialsMother, ISNULL(enTitleFullNameMother, '')) + ISNULL(enFirstNameMother, '') + ' ' + ISNULL(enMiddleNameMother, '') + ' ' + ISNULL(enLastNameMother, '')))) +
 						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'สถานภาพชีวิต', 'Living Status', ISNULL(thAliveMother, ''), ISNULL(enAliveMother, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'วันเดือนปีเกิด', 'Date of Birth', ISNULL(thBirthDateMother, ''), ISNULL(enBirthDateMother, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'อายุ ( ปี )', 'Age ( yr )', ISNULL(CONVERT(VARCHAR, ageMother), ''), '')) + 					 
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ประเทศบ้านเกิด', 'Country of Birthplace', ISNULL(thCountryNameMother, ''), ISNULL(enCountryNameMother, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'สัญชาติ', 'Nationality', ISNULL(thNationalityNameMother, ''), ISNULL(enNationalityNameMother, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'เชื้อชาติ', 'Race', ISNULL(thOriginNameMother, ''), ISNULL(enOriginNameMother, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ศาสนา', 'Religion', ISNULL(thReligionNameMother, ''), ISNULL(enReligionNameMother, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'กรุ๊ปเลือด', 'Blood Group', ISNULL(thBloodTypeNameMother, ''), ISNULL(enBloodTypeNameMother, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'สถานภาพทางการสมรส', 'Marital Status', ISNULL(thMaritalStatusNameMother, ''), ISNULL(enMaritalStatusNameMother, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'วุฒิการศึกษา', 'Educational Background', ISNULL(thEducationalBackgroundNameMother, ''), ISNULL(enEducationalBackgroundNameMother, '')))
						) AS formPersonalMother,
						(
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('subject', '', '', '18', 'ข้อมูลที่อยู่ตามทะเบียนบ้านของมารดา', 'Permanent Address Information of Mother', '', '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ประเทศ', 'Country', ISNULL(thCountryNamePermanentMother, ''), ISNULL(enCountryNamePermanentMother, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'จังหวัด', 'Province', ISNULL(thPlaceNamePermanentMother, ''), ISNULL(enPlaceNamePermanentMother, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'อำเภอ / เขต', 'District / Area', ISNULL(thDistrictNamePermanentMother, ''), ISNULL(enDistrictNamePermanentMother, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ตำบล / แขวง', 'Sub-district / Sub-area', ISNULL(thSubdistrictNamePermanentMother, ''), ISNULL(enSubdistrictNamePermanentMother, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'รหัสไปรษณีย์', 'ZIP / Postal Code', ISNULL(zipCodePermanentMother, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'หมู่บ้าน', 'Village', ISNULL(villagePermanentMother, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'บ้านเลขที่', 'Address Number', ISNULL(noPermanentMother, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'หมู่ที่', 'Village No.', ISNULL(mooPermanentMother, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ตรอก / ซอย', 'Lane / Alley', ISNULL(soiPermanentMother, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ถนน', 'Road', ISNULL(roadPermanentMother, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'เบอร์โทรศัพท์บ้าน', 'Phone Number', ISNULL(phoneNumberPermanentMother, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'เบอร์โทรศัพท์มือถือ', 'Mobile Number', ISNULL(mobileNumberPermanentMother, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'เบอร์แฟกซ์', 'Fax Number', ISNULL(faxNumberPermanentMother, ''), ''))
						) AS formPermanentAddressMother,
						(
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('subject', '', '', '19', 'ข้อมูลที่อยู่ปัจจุบันที่ติดต่อได้ของมารดา', 'Current Address Information of Mother', '', '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ประเทศ', 'Country', ISNULL(thCountryNameCurrentMother, ''), ISNULL(enCountryNameCurrentMother, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'จังหวัด', 'Province', ISNULL(thPlaceNameCurrentMother, ''), ISNULL(enPlaceNameCurrentMother, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'อำเภอ / เขต', 'District / Area', ISNULL(thDistrictNameCurrentMother, ''), ISNULL(enDistrictNameCurrentMother, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ตำบล / แขวง', 'Sub-district / Sub-area', ISNULL(thSubdistrictNameCurrentMother, ''), ISNULL(enSubdistrictNameCurrentMother, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'รหัสไปรษณีย์', 'ZIP / Postal Code', ISNULL(zipCodeCurrentMother, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'หมู่บ้าน', 'Village', ISNULL(villageCurrentMother, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'บ้านเลขที่', 'Address Number', ISNULL(noCurrentMother, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'หมู่ที่', 'Village No.', ISNULL(mooCurrentMother, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ตรอก / ซอย', 'Lane / Alley', ISNULL(soiCurrentMother, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ถนน', 'Road', ISNULL(roadCurrentMother, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'เบอร์โทรศัพท์บ้าน', 'Phone Number', ISNULL(phoneNumberCurrentMother, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'เบอร์โทรศัพท์มือถือ', 'Mobile Number', ISNULL(mobileNumberCurrentMother, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'เบอร์แฟกซ์', 'Fax Number', ISNULL(faxNumberCurrentMother, ''), ''))
						) AS formCurrentAddressMother,		
						(
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('subject', '', '', '20', 'ข้อมูลการทำงานของมารดา', 'Worker Information of Mother', '', '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'อาชีพ', 'Occupation', ISNULL(thOccupationMother, ''), ISNULL(enOccupationMother, ''))) +	
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ต้นสังกัด', 'Agency', ISNULL(thAgencyNameMother, ISNULL(agencyOtherMother, '')), ISNULL(enAgencyNameMother, ''))) +	
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'สถานที่ทำงาน', 'Workplace', ISNULL(workplaceMother, ''), '')) +	
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ตำแหน่ง', 'Position', ISNULL(positionMother, ''), '')) +	
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'โทรศัพท์ที่ทำงาน', 'Workplace Telephone', ISNULL(telephoneMother, ''), '')) +	
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'รายได้เฉลี่ยต่อเดือน ( บาท )', 'Income ( bath )', ISNULL(CONVERT(VARCHAR, CONVERT(MONEY, salaryMother),1), ''), ''))
						) AS formWorkerMother,		
						(
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('subject', '', '', '21', 'ข้อมูลส่วนตัวของผู้ปกครอง', 'Personal Data of Parent', '', '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ความสัมพันธ์ของผู้ปกครอง', 'Relationship of Parent', ISNULL(relationshipNameTH, ''), ISNULL(relationshipNameEN, ''))) +	
 						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'เลขประจำตัวประชาชน หรือ เลขหนังสือเดินทาง', 'Identification Number or Passport No.', ISNULL(idCardParent, ''), '')) +	
 						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ชื่อ', 'Full Name', (ISNULL(thTitleInitialsParent, ISNULL(thTitleFullNameParent, '')) + ISNULL(firstNameParent, '') + ' ' + ISNULL(middleNameParent, '') + ' ' + ISNULL(lastNameParent, '')), (ISNULL(enTitleInitialsParent, ISNULL(enTitleFullNameParent, '')) + ISNULL(enFirstNameParent, '') + ' ' + ISNULL(enMiddleNameParent, '') + ' ' + ISNULL(enLastNameParent, '')))) +
 						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'สถานภาพชีวิต', 'Living Status', ISNULL(thAliveParent, ''), ISNULL(enAliveParent, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'วันเดือนปีเกิด', 'Date of Birth', ISNULL(thBirthDateParent, ''), ISNULL(enBirthDateParent, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'อายุ ( ปี )', 'Age ( yr )', ISNULL(CONVERT(VARCHAR, ageParent), ''), '')) + 					 
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ประเทศบ้านเกิด', 'Country of Birthplace', ISNULL(thCountryNameParent, ''), ISNULL(enCountryNameParent, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'สัญชาติ', 'Nationality', ISNULL(thNationalityNameParent, ''), ISNULL(enNationalityNameParent, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'เชื้อชาติ', 'Race', ISNULL(thOriginNameParent, ''), ISNULL(enOriginNameParent, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ศาสนา', 'Religion', ISNULL(thReligionNameParent, ''), ISNULL(enReligionNameParent, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'กรุ๊ปเลือด', 'Blood Group', ISNULL(thBloodTypeNameParent, ''), ISNULL(enBloodTypeNameParent, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'สถานภาพทางการสมรส', 'Marital Status', ISNULL(thMaritalStatusNameParent, ''), ISNULL(enMaritalStatusNameParent, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'วุฒิการศึกษา', 'Educational Background', ISNULL(thEducationalBackgroundNameParent, ''), ISNULL(enEducationalBackgroundNameParent, '')))
						) AS formPersonalParent,	
						(
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('subject', '', '', '22', 'ข้อมูลที่อยู่ตามทะเบียนบ้านของผู้ปกครอง', 'Permanent Address Information of Parent', '', '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ความสัมพันธ์ของผู้ปกครอง', 'Relationship of Parent', ISNULL(relationshipNameTH, ''), ISNULL(relationshipNameEN, ''))) +	
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ประเทศ', 'Country', ISNULL(thCountryNamePermanentParent, ''), ISNULL(enCountryNamePermanentParent, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'จังหวัด', 'Province', ISNULL(thPlaceNamePermanentParent, ''), ISNULL(enPlaceNamePermanentParent, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'อำเภอ / เขต', 'District / Area', ISNULL(thDistrictNamePermanentParent, ''), ISNULL(enDistrictNamePermanentParent, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ตำบล / แขวง', 'Sub-district / Sub-area', ISNULL(thSubdistrictNamePermanentParent, ''), ISNULL(enSubdistrictNamePermanentParent, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'รหัสไปรษณีย์', 'ZIP / Postal Code', ISNULL(zipCodePermanentParent, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'หมู่บ้าน', 'Village', ISNULL(villagePermanentParent, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'บ้านเลขที่', 'Address Number', ISNULL(noPermanentParent, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'หมู่ที่', 'Village No.', ISNULL(mooPermanentParent, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ตรอก / ซอย', 'Lane / Alley', ISNULL(soiPermanentParent, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ถนน', 'Road', ISNULL(roadPermanentParent, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'เบอร์โทรศัพท์บ้าน', 'Phone Number', ISNULL(phoneNumberPermanentParent, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'เบอร์โทรศัพท์มือถือ', 'Mobile Number', ISNULL(mobileNumberPermanentParent, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'เบอร์แฟกซ์', 'Fax Number', ISNULL(faxNumberPermanentParent, ''), ''))
						) AS formPermanentAddressParent,					
						(
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('subject', '', '', '23', 'ข้อมูลที่อยู่ปัจจุบันที่ติดต่อได้ของผู้ปกครอง', 'Current Address Information of Parent', '', '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ความสัมพันธ์ของผู้ปกครอง', 'Relationship of Parent', ISNULL(relationshipNameTH, ''), ISNULL(relationshipNameEN, ''))) +	
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ประเทศ', 'Country', ISNULL(thCountryNameCurrentParent, ''), ISNULL(enCountryNameCurrentParent, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'จังหวัด', 'Province', ISNULL(thPlaceNameCurrentParent, ''), ISNULL(enPlaceNameCurrentParent, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'อำเภอ / เขต', 'District / Area', ISNULL(thDistrictNameCurrentParent, ''), ISNULL(enDistrictNameCurrentParent, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ตำบล / แขวง', 'Sub-district / Sub-area', ISNULL(thSubdistrictNameCurrentParent, ''), ISNULL(enSubdistrictNameCurrentParent, ''))) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'รหัสไปรษณีย์', 'ZIP / Postal Code', ISNULL(zipCodeCurrentParent, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'หมู่บ้าน', 'Village', ISNULL(villageCurrentParent, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'บ้านเลขที่', 'Address Number', ISNULL(noCurrentParent, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'หมู่ที่', 'Village No.', ISNULL(mooCurrentParent, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ตรอก / ซอย', 'Lane / Alley', ISNULL(soiCurrentParent, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ถนน', 'Road', ISNULL(roadCurrentParent, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'เบอร์โทรศัพท์บ้าน', 'Phone Number', ISNULL(phoneNumberCurrentParent, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'เบอร์โทรศัพท์มือถือ', 'Mobile Number', ISNULL(mobileNumberCurrentParent, ''), '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'เบอร์แฟกซ์', 'Fax Number', ISNULL(faxNumberCurrentParent, ''), ''))
						) AS formCurrentAddressParent,	
						(
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('subject', '', '', '24', 'ข้อมูลการทำงานของผู้ปกครอง', 'Worker Information of Parent', '', '')) +
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ความสัมพันธ์ของผู้ปกครอง', 'Relationship of Parent', ISNULL(relationshipNameTH, ''), ISNULL(relationshipNameEN, ''))) +	
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'อาชีพ', 'Occupation', ISNULL(thOccupationParent, ''), ISNULL(enOccupationParent, ''))) +	
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ต้นสังกัด', 'Agency', ISNULL(thAgencyNameParent, ISNULL(agencyOtherParent, '')), ISNULL(enAgencyNameParent, ''))) +	
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'สถานที่ทำงาน', 'Workplace', ISNULL(workplaceParent, ''), '')) +	
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'ตำแหน่ง', 'Position', ISNULL(positionParent, ''), '')) +	
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'โทรศัพท์ที่ทำงาน', 'Workplace Telephone', ISNULL(telephoneParent, ''), '')) +	
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('content', '', '', '', 'รายได้เฉลี่ยต่อเดือน ( บาท )', 'Income ( bath )', ISNULL(CONVERT(VARCHAR, CONVERT(MONEY, salaryParent),1), ''), ''))
						) AS formWorkerParent,																																	
						(SELECT dbo.fnc_stdGetStudentRecordsToHTML('close', '', '', '', '', '', '', '')) AS formClose
				FROM	#tbStudentRecords				 
			END			
			ELSE
				SELECT NULL
		COMMIT TRAN				
	END
	ELSE
		SELECT NULL
END

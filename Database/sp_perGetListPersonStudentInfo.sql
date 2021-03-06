USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_perGetListPersonStudentInfo]    Script Date: 5/10/2564 14:21:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๐๓/๐๙/๒๕๖๔>
-- Description	: <>
-- =============================================

ALTER PROCEDURE [dbo].[sp_perGetListPersonStudentInfo]
(
	@tb_personId strucKeyId readonly
)
as
begin
	set concat_null_yields_null off

	create table #tb_studentInfo (
		rowNumber int,
		studentCode varchar(15),
		degreeLevelNameTH nvarchar(50),
		degreeLevelNameEN nvarchar(50),
		facultyNameTH varchar(200),
		facultyNameEN varchar(200),
		programCodeNew varchar(50),
		programNameTH varchar(200),
		programNameEN varchar(200),
		yearEntry varchar(4),
		class tinyint,
		stdEntranceTypeNameTH nvarchar(255),
		stdEntranceTypeNameEN nvarchar(255),
		statusTypeNameTH varchar(100),
		statusTypeNameEN varchar(100),		
		admissionDate datetime,
		graduateDate datetime,
		statusGroup varchar(2),
		updateReason varchar(255),
		barcode varchar(50),
		titleFullNameTH nvarchar(255),
		titleInitialsTH nvarchar(50),
		titleFullNameEN nvarchar(255),
		titleInitialsEN nvarchar(50),
		firstNameTH nvarchar(100),
		middleNameTH nvarchar(100),
		lastNameTH nvarchar(100),
		firstNameEN nvarchar(100),
		middleNameEN nvarchar(100),
		lastNameEN nvarchar(100),
		idCard nvarchar(20),
		genderFullNameTH nvarchar(255),
		genderFullNameEN nvarchar(255),
		birthDateTH varchar(50),
		birthDateEN varchar(50),
		nationalityNameTH nvarchar(255),
		nationalityNameEN nvarchar(255),
		childhoodNumber varchar(10),
		countryNameTHPermanentAddress nvarchar(255),
		countryNameENPermanentAddress nvarchar(255),
		provinceNameTHPermanentAddress nvarchar(255),
		provinceNameENPermanentAddress nvarchar(255),
		districtNameTHPermanentAddress nvarchar(255),
		districtNameENPermanentAddress nvarchar(255),
		subdistrictNameTHPermanentAddress nvarchar(255),
		subdistrictNameENPermanentAddress nvarchar(255),
		zipCodePermanentAddress nvarchar(10),
		villagePermanentAddress nvarchar(255),
		addressNumberPermanentAddress nvarchar(100),
		villageNoPermanentAddress nvarchar(100),
		soiPermanentAddress nvarchar(100),
		roadPermanentAddress nvarchar(255),
		phoneNumberPermanentAddress nvarchar(50),
		mobileNumberPermanentAddress nvarchar(50),
		faxNumberPermanentAddress nvarchar(50),
		countryNameTHCurrentAddress nvarchar(255),
		countryNameENCurrentAddress nvarchar(255),
		provinceNameTHCurrentAddress nvarchar(255),
		provinceNameENCurrentAddress nvarchar(255),
		districtNameTHCurrentAddress nvarchar(255),
		districtNameENCurrentAddress nvarchar(255),
		subdistrictNameTHCurrentAddress nvarchar(255),
		subdistrictNameENCurrentAddress nvarchar(255),
		zipCodeCurrentAddress nvarchar(10),
		villageCurrentAddress nvarchar(255),
		addressNumberCurrentAddress nvarchar(100),
		villageNoCurrentAddress nvarchar(100),
		soiCurrentAddress nvarchar(100),
		roadCurrentAddress nvarchar(255),
		phoneNumberCurrentAddress nvarchar(50),
		mobileNumberCurrentAddress nvarchar(50),
		faxNumberCurrentAddress nvarchar(50),
		instituteNameHighSchool nvarchar(255),
		instituteCountryNameTHHighSchool nvarchar(255),
		instituteCountryNameENHighSchool nvarchar(255),
		instituteProvinceNameTHHighSchool nvarchar(255),
		instituteProvinceNameENHighSchool nvarchar(255),
		studentIDHighSchool nvarchar(20),
		GPAHighSchool varchar(4),
		sportsmanDetail nvarchar(max),
		specialistSportDetail nvarchar(max),
		specialistArtDetail nvarchar(max),
		specialistTechnicalDetail nvarchar(max),
		specialistOtherDetail nvarchar(max),
		activityDetail nvarchar(max),
		rewardDetail nvarchar(max),
		impairmentsNameTH nvarchar(255),
		impairmentsNameEN nvarchar(255),
		impairmentsEquipment nvarchar(255),
		idCardPWD nvarchar(20),
		idCardPWDIssueDateTH varchar(50),
		idCardPWDIssueDateEN varchar(50),
		idCardPWDExpiryDateTH varchar(50),
		idCardPWDExpiryDateEN varchar(50),
		scholarshipFirstBachelorFromTH nvarchar(255),
		scholarshipFirstBachelorFromEN nvarchar(255),
		scholarshipFirstBachelorName nvarchar(255),
		scholarshipFirstBachelorMoney varchar(20),
		scholarshipBachelorFromTH nvarchar(255),
		scholarshipBachelorFromEN nvarchar(255),
		scholarshipBachelorName nvarchar(255),
		scholarshipBachelorMoney varchar(20),
		workDuringStudySalary varchar(20),
		workDuringStudyWorkplace nvarchar(255),
		gotMoneyFromTH nvarchar(255),
		gotMoneyFromEN nvarchar(255),
		gotMoneyFromOther nvarchar(255),
		gotMoneyPerMonth varchar(20),
		costPerMonth varchar(20),
		relationshipNameTH nvarchar(255),
		relationshipNameEN nvarchar(255),
		idCardFather nvarchar(20),
		titleFullNameTHFather nvarchar(255),
		titleInitialsTHFather nvarchar(50),
		titleFullNameENFather nvarchar(255),
		titleInitialsENFather nvarchar(50),
		firstNameTHFather nvarchar(100),
		middleNameTHFather nvarchar(100),
		lastNameTHFather nvarchar(100),
		firstNameENFather nvarchar(100),
		middleNameENFather nvarchar(100),
		lastNameENFather nvarchar(100),
		aliveTHFather nvarchar(50),
		aliveENFather nvarchar(50),
		educationalBackgroundNameTHFather nvarchar(255),
		educationalBackgroundNameENFather nvarchar(255),
		idCardMother nvarchar(20),
		titleFullNameTHMother nvarchar(255),
		titleInitialsTHMother nvarchar(50),
		titleFullNameENMother nvarchar(255),
		titleInitialsENMother nvarchar(50),
		firstNameTHMother nvarchar(100),
		middleNameTHMother nvarchar(100),
		lastNameTHMother nvarchar(100),
		firstNameENMother nvarchar(100),
		middleNameENMother nvarchar(100),
		lastNameENMother nvarchar(100),
		aliveTHMother nvarchar(50),
		aliveENMother nvarchar(50),
		educationalBackgroundNameTHMother nvarchar(255),
		educationalBackgroundNameENMother nvarchar(255),
		idCardParent nvarchar(20),
		titleFullNameTHParent nvarchar(255),
		titleInitialsTHParent nvarchar(50),
		titleFullNameENParent nvarchar(255),
		titleInitialsENParent nvarchar(50),
		firstNameTHParent nvarchar(100),
		middleNameTHParent nvarchar(100),
		lastNameTHParent nvarchar(100),
		firstNameENParent nvarchar(100),
		middleNameENParent nvarchar(100),
		lastNameENParent nvarchar(100),
		aliveTHParent nvarchar(50),
		aliveENParent nvarchar(50),
		educationalBackgroundNameTHParent nvarchar(255),
		educationalBackgroundNameENParent nvarchar(255),
		occupationTHFather nvarchar(255),
		occupationENFather nvarchar(255),
		occupationTHMother nvarchar(255),
		occupationENMother nvarchar(255),
		occupationTHParent nvarchar(255),
		occupationENParent nvarchar(255),
		salaryFather varchar(20),
		salaryMother varchar(20),
		salaryParent varchar(20)
	)

	declare @rowNumber int = 1
	declare @ID nvarchar(20) = null
	
	declare rs cursor for
	select	id
	from	@tb_personId

	open rs
	fetch next from rs into @ID
	while (@@fetch_status = 0)
	begin
		;with 
		tb_Student as
		(
			select	studentCode,
					degreeLevelNameTH,
					degreeLevelNameEN,
					facultyNameTH,
					facultyNameEN,
					((left(programCode, (len(programCode) - 1)) + '/' + right(programCode, 1)) + ' ' + majorCode + ' ' + groupNum) as programCodeNew,
					programNameTH,
					programNameEN,
					yearEntry,
					class,
					stdEntranceTypeNameTH,
					stdEntranceTypeNameEN,
					statusTypeNameTH,
					statusTypeNameEN,
					admissionDate,
					graduateDate,
					statusGroup,
					updateReason,
					(case when (len(isnull(studentCode, '')) > 0 and len(isnull(degree, '')) > 0) then dbo.fnc_perGetBarcode(studentCode, degree) else null end) as barcode
			from	fnc_perGetPersonStudent(@ID)
		),
		tb_Person as
		(
			select	thTitleFullName,
					thTitleInitials,
					enTitleFullName,
					enTitleInitials,
					firstName,
					middleName,
					lastName,
					enFirstName,
					enMiddleName,
					enLastName,
					idCard,
					thGenderFullName,
					enGenderFullName,
					thBirthDate,
					enBirthDate,
					thNationalityName,
					enNationalityName,
					childhoodNumber
			from	fnc_perGetPerson(@ID)
		),
		tb_Address as
		(		
			select	thCountryNamePermanent,
					enCountryNamePermanent,
					thPlaceNamePermanent,
					enPlaceNamePermanent,
					thDistrictNamePermanent,
					enDistrictNamePermanent,
					thSubdistrictNamePermanent,
					enSubdistrictNamePermanent,
					zipCodePermanent,
					villagePermanent,
					noPermanent,
					mooPermanent,
					soiPermanent,
					roadPermanent,
					phoneNumberPermanent,
					mobileNumberPermanent,
					faxNumberPermanent,
					thCountryNameCurrent,
					enCountryNameCurrent,				
					thPlaceNameCurrent,
					enPlaceNameCurrent,
					thDistrictNameCurrent,
					enDistrictNameCurrent,
					thSubdistrictNameCurrent,
					enSubdistrictNameCurrent,
					zipCodeCurrent,
					villageCurrent,
					noCurrent,
					mooCurrent,
					soiCurrent,
					roadCurrent,
					phoneNumberCurrent,
					mobileNumberCurrent,
					faxNumberCurrent
			from	fnc_perGetAddress(@ID)
		),
		tb_Education as
		(	
			select	highSchoolName,
					thHighSchoolCountryName,
					enHighSchoolCountryName,
					thHighSchoolPlaceName,
					enHighSchoolPlaceName,
					highSchoolStudentId,
					highSchoolGPA
			from	fnc_perGetEducation(@ID)
		),
		tb_Activity as
		(		
			select	sportsmanDetail,
					specialistSportDetail,
					specialistArtDetail,
					specialistTechnicalDetail,
					specialistOtherDetail,
					activityDetail,
					rewardDetail
			from	fnc_perGetActivity(@ID)
		),
		tb_Healthy as
		(
			select	impairmentsNameTH,
					impairmentsNameEN,
					impairmentsEquipment,
					idCardPWD,
					thIdCardPWDIssueDate,
					enIdCardPWDIssueDate,
					thIdCardPWDExpiryDate,
					enIdCardPWDExpiryDate
			from	fnc_perGetHealthy(@ID)
		),
		tb_Financial as
		(
			select	thScholarshipFirstBachelorFrom,
					enScholarshipFirstBachelorFrom,
					scholarshipFirstBachelorName,
					scholarshipFirstBachelorMoney,
					thScholarshipBachelorFrom,
					enScholarshipBachelorFrom,
					scholarshipBachelorName,
					scholarshipBachelorMoney,
					salary,
					workplace,
					thGotMoneyFrom,
					enGotMoneyFrom,
					gotMoneyFromOther,
					gotMoneyPerMonth,
					costPerMonth
			from	fnc_perGetFinancial(@ID)
		),
		tb_PersonParent as
		(
			select	relationshipNameTH,
					relationshipNameEN,
					idCardFather,
					thTitleFullNameFather,
					thTitleInitialsFather,
					enTitleFullNameFather,
					enTitleInitialsFather,
					firstNameFather,
					middleNameFather,
					lastNameFather,
					enFirstNameFather,
					enMiddleNameFather,
					enLastNameFather,
					thAliveFather,
					enAliveFather,
					thEducationalBackgroundNameFather,		
					enEducationalBackgroundNameFather,
					idCardMother,
					thTitleFullNameMother,
					thTitleInitialsMother,
					enTitleFullNameMother,
					enTitleInitialsMother,
					firstNameMother,
					middleNameMother,
					lastNameMother,
					enFirstNameMother,
					enMiddleNameMother,
					enLastNameMother,
					thAliveMother,
					enAliveMother,
					thEducationalBackgroundNameMother,
					enEducationalBackgroundNameMother,
					idCardParent,
					thTitleFullNameParent,
					thTitleInitialsParent,
					enTitleFullNameParent,
					enTitleInitialsParent,				
					firstNameParent,
					middleNameParent,
					lastNameParent,
					enFirstNameParent,
					enMiddleNameParent,
					enLastNameParent,
					thAliveParent,
					enAliveParent,
					thEducationalBackgroundNameParent,
					enEducationalBackgroundNameParent
			from	fnc_perGetPersonParent(@ID)
		),
		tb_WorkParent as
		(
			select	thOccupationFather,
					enOccupationFather,
					thOccupationMother,
					enOccupationMother,
					thOccupationParent,
					enOccupationParent,
					salaryFather,
					salaryMother,
					salaryParent
			from	fnc_perGetWorkParent(@ID)
		)

		insert into #tb_studentInfo
		select	@rowNumber,
				*
		from	tb_Student,
				tb_Person,
				tb_Address,
				tb_Education,
				tb_Activity,
				tb_Healthy,
				tb_Financial,
				tb_PersonParent,
				tb_WorkParent

		set @rowNumber = @rowNumber + 1
		fetch next from rs into @ID
	end
	close rs
	deallocate rs

	select	 *
	from	 #tb_studentInfo
	order by studentCode
end
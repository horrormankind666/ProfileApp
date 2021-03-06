USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_perGetPersonStudentInfo]    Script Date: 13/8/2564 12:48:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๓/๐๘/๒๕๖๔>
-- Description	: <สำหรับเรียกดูข้อมูลของนักศึกษา>
-- Parameter
--  1. personId เป็น varchar	รับค่ารหัสบุคคล
-- =============================================
/*
exec sp_perGetPersonStudentInfo 2564000278
*/

ALTER procedure [dbo].[sp_perGetPersonStudentInfo]
(
	@personId varchar(10) = null
)
as
begin
	set concat_null_yields_null off

	set @personId = ltrim(rtrim(isnull(@personId, '')))

	;with 
	tblPerson as
	(
		select	id,
				thTitleFullName,
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
		from	fnc_perGetPerson(@personId)
	),
	tblAddress as
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
		from	fnc_perGetAddress(@personId)
	),
	tblEducation as
	(	
		select	highSchoolName,
				thHighSchoolCountryName,
				enHighSchoolCountryName,
				thHighSchoolPlaceName,
				enHighSchoolPlaceName,
				highSchoolStudentId,
				highSchoolGPA
		from	fnc_perGetEducation(@personId)
	),
	tblActivity as
	(		
		select	sportsmanDetail,
				specialistSportDetail,
				specialistArtDetail,
				specialistTechnicalDetail,
				specialistOtherDetail,
				activityDetail,
				rewardDetail
		from	fnc_perGetActivity(@personId)
	),
	tblHealthy as
	(
		select	impairmentsNameTH,
				impairmentsNameEN,
				impairmentsEquipment,
				idCardPWD,
				thIdCardPWDIssueDate,
				enIdCardPWDIssueDate,
				thIdCardPWDExpiryDate,
				enIdCardPWDExpiryDate
		from	fnc_perGetHealthy(@personId)
	),
	tblFinancial as
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
		from	fnc_perGetFinancial(@personId)
	),
	tblPersonParent as
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
		from	fnc_perGetPersonParent(@personId)
	),
	tblWorkParent as
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
		from	fnc_perGetWorkParent(@personId)
	)
	
	select	*
	from	tblPerson,
			tblAddress,
			tblEducation,
			tblActivity,
			tblHealthy,
			tblFinancial,
			tblPersonParent,
			tblWorkParent
end
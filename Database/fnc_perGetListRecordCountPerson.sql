USE [Infinity]
GO
/****** Object:  UserDefinedFunction [dbo].[fnc_perGetListRecordCountPerson]    Script Date: 04-08-2016 13:33:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๔/๐๕/๒๕๕๘>
-- Description	: <สำหรับเรียกดูข้อมูลจำนวนรายการของนักศึกษา>
-- Parameter
--  1. personId		เป็น VARCHAR	รับค่ารหัสบุคคล
--  2. yearEntry	เป็น VARCHAR	รับค่าปีที่เข้าศึกษา
-- =============================================
ALTER FUNCTION [dbo].[fnc_perGetListRecordCountPerson] 
(	
	@personId VARCHAR(MAX) = NULL,
	@yearEntry VARCHAR(4) = NULL
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT	perpes.id,
			stdstd.yearEntry,
			--ข้อมูลส่วนตัวที่จำเป็น
			(
				CASE WHEN 
					(perpes.id IS NOT NULL AND LEN(perpes.id) > 0) AND
					(perpes.idCard IS NOT NULL AND LEN(perpes.idCard) > 0) AND
					(perpes.perTitlePrefixId IS NOT NULL AND LEN(perpes.perTitlePrefixId) > 0) AND
					(perpes.firstName IS NOT NULL AND LEN(perpes.firstName) > 0) AND
					(perpes.enFirstName IS NOT NULL AND LEN(perpes.enFirstName) > 0) AND
					(perpes.perGenderId IS NOT NULL AND LEN(perpes.perGenderId) > 0) AND
					(perpes.birthDate IS NOT NULL AND LEN(perpes.birthDate) > 0) AND
					(perpes.plcCountryId IS NOT NULL AND LEN(perpes.plcCountryId) > 0) AND
					(perpes.perNationalityId IS NOT NULL AND LEN(perpes.perNationalityId) > 0) AND
					(perpes.perOriginId IS NOT NULL AND LEN(perpes.perOriginId) > 0) AND
					(perpes.perReligionId IS NOT NULL AND LEN(perpes.perReligionId) > 0) AND
					(perpes.perMaritalStatusId IS NOT NULL AND LEN(perpes.perMaritalStatusId) > 0) AND
					(perpes.perEducationalBackgroundId IS NOT NULL AND LEN(perpes.perEducationalBackgroundId) > 0) AND
					(perpes.email IS NOT NULL AND LEN(perpes.email) > 0)
				THEN 
					1		
				ELSE
					0
				END
			) AS perPerson,
			--ข้อมูลที่อยู่ที่จำเป็น
			(
				CASE WHEN
					(peradd.perPersonId IS NOT NULL AND LEN(peradd.perPersonId) > 0) AND
					(peradd.plcCountryIdPermanent IS NOT NULL AND LEN(peradd.plcCountryIdPermanent) > 0) AND
					(peradd.noPermanent IS NOT NULL AND LEN(peradd.noPermanent) > 0) AND
					((peradd.phoneNumberPermanent IS NOT NULL AND LEN(peradd.phoneNumberPermanent) > 0) OR (peradd.mobileNumberPermanent IS NOT NULL AND LEN(peradd.mobileNumberPermanent) > 0)) AND
					(peradd.plcCountryIdCurrent IS NOT NULL AND LEN(peradd.plcCountryIdCurrent) > 0) AND
					(peradd.noCurrent IS NOT NULL AND LEN(peradd.noCurrent) > 0) AND
					((peradd.phoneNumberCurrent IS NOT NULL AND LEN(peradd.phoneNumberCurrent) > 0) OR (peradd.mobileNumberCurrent IS NOT NULL AND LEN(peradd.mobileNumberCurrent) > 0)) 
				THEN
					1
				ELSE
					0					
				END
			) AS perAddress,
			--ข้อมูลที่อยู่ตามทะเบียนบ้านที่จำเป็น
			(
				CASE WHEN
					(peradd.perPersonId IS NOT NULL AND LEN(peradd.perPersonId) > 0) AND
					(peradd.plcCountryIdPermanent IS NOT NULL AND LEN(peradd.plcCountryIdPermanent) > 0) AND
					(peradd.noPermanent IS NOT NULL AND LEN(peradd.noPermanent) > 0) AND
					((peradd.phoneNumberPermanent IS NOT NULL AND LEN(peradd.phoneNumberPermanent) > 0) OR (peradd.mobileNumberPermanent IS NOT NULL AND LEN(peradd.mobileNumberPermanent) > 0))
				THEN
					1
				ELSE
					0					
				END
			) AS perAddressPermanent,
			--ข้อมูลที่อยู่ปัจจุบันที่ติดต่อได้ที่จำเป็น
			(
				CASE WHEN
					(peradd.perPersonId IS NOT NULL AND LEN(peradd.perPersonId) > 0) AND
					(peradd.plcCountryIdCurrent IS NOT NULL AND LEN(peradd.plcCountryIdCurrent) > 0) AND
					(peradd.noCurrent IS NOT NULL AND LEN(peradd.noCurrent) > 0) AND
					((peradd.phoneNumberCurrent IS NOT NULL AND LEN(peradd.phoneNumberCurrent) > 0) OR (peradd.mobileNumberCurrent IS NOT NULL AND LEN(peradd.mobileNumberCurrent) > 0)) 
				THEN
					1
				ELSE
					0					
				END
			) AS perAddressCurrent,
			--ข้อมูลการศึกษาที่จำเป็น
			(
				CASE WHEN 
					(peredu.perPersonId IS NOT NULL AND LEN(peredu.perPersonId) > 0) AND
					(peredu.highSchoolName IS NOT NULL AND LEN(peredu.highSchoolName) > 0) AND
					(peredu.plcCountryIdHighSchool IS NOT NULL AND LEN(peredu.plcCountryIdHighSchool) > 0) AND
					((peredu.perEducationalMajorIdHighSchool IS NOT NULL AND LEN(peredu.perEducationalMajorIdHighSchool) > 0) OR (peredu.educationalMajorOtherHighSchool IS NOT NULL AND LEN(peredu.educationalMajorOtherHighSchool) > 0)) AND
					(peredu.perEducationalBackgroundIdHighSchool IS NOT NULL AND LEN(peredu.perEducationalBackgroundIdHighSchool) > 0) AND
					(peredu.perEducationalBackgroundId IS NOT NULL AND LEN(peredu.perEducationalBackgroundId) > 0) AND
					(peredu.graduateBy IS NOT NULL AND LEN(peredu.graduateBy) > 0) AND
					(peredu.entranceTime IS NOT NULL AND LEN(peredu.entranceTime) > 0) AND
					(peredu.studentIs IS NOT NULL AND LEN(peredu.studentIs) > 0) AND
					(peredu.perEntranceTypeId IS NOT NULL AND LEN(peredu.perEntranceTypeId) > 0)
				THEN
					1
				ELSE
					0
				END
			) AS perEducation,
			--ข้อมูลการศึกษาระดับประถมที่จำเป็น
			1 AS perEducationPrimarySchool,
			--ข้อมูลการศึกษาระดับมัธยมต้นที่จำเป็น
			1 AS perEducationJuniorHighSchool,
			--ข้อมูลการศึกษาระดับมัธยมปลายที่จำเป็น
			(
				CASE WHEN 
					(peredu.perPersonId IS NOT NULL AND LEN(peredu.perPersonId) > 0) AND
					(peredu.highSchoolName IS NOT NULL AND LEN(peredu.highSchoolName) > 0) AND
					(peredu.plcCountryIdHighSchool IS NOT NULL AND LEN(peredu.plcCountryIdHighSchool) > 0) AND
					((peredu.perEducationalMajorIdHighSchool IS NOT NULL AND LEN(peredu.perEducationalMajorIdHighSchool) > 0) OR (peredu.educationalMajorOtherHighSchool IS NOT NULL AND LEN(peredu.educationalMajorOtherHighSchool) > 0)) AND
					(peredu.perEducationalBackgroundIdHighSchool IS NOT NULL AND LEN(peredu.perEducationalBackgroundIdHighSchool) > 0)
				THEN
					1
				ELSE
					0
				END
			) AS perEducationHighSchool,
			--ข้อมูลการศึกษาก่อนที่เข้าม.มหิดลที่จำเป็น
			(
				CASE WHEN 
					(peredu.perPersonId IS NOT NULL AND LEN(peredu.perPersonId) > 0) AND
					(peredu.perEducationalBackgroundId IS NOT NULL AND LEN(peredu.perEducationalBackgroundId) > 0) AND
					(peredu.graduateBy IS NOT NULL AND LEN(peredu.graduateBy) > 0) AND
					(peredu.entranceTime IS NOT NULL AND LEN(peredu.entranceTime) > 0) AND
					(peredu.studentIs IS NOT NULL AND LEN(peredu.studentIs) > 0) AND
					(peredu.perEntranceTypeId IS NOT NULL AND LEN(peredu.perEntranceTypeId) > 0)
				THEN
					1
				ELSE
					0
				END
			) AS perEducationUniversity,
			--ข้อมูลการศึกษาคะแนนสอบที่จำเป็น
			1 AS perEducationAdmissionScores,
			--ข้อมูลความสามารถพิเศษที่จำเป็น
			1 AS perActivity,
			--ข้อมูลสุขภาพที่จำเป็น
			(
				CASE WHEN
					(perhea.perPersonId IS NOT NULL AND LEN(perhea.perPersonId) > 0) AND
					(perhea.bodyMassDetail IS NOT NULL AND LEN(perhea.bodyMassDetail) > 0)
				THEN
					1
				ELSE
					0
				END
			) AS perHealthy,
			--ข้อมูลการทำงานที่จำเป็น
			1 AS perWork,
			--ข้อมูลการเงินที่จำเป็น
			1 AS perFinancial,
			--ข้อมูลส่วนตัวของบิดาที่จำเป็น
			(
				CASE WHEN
					(perpar.id IS NOT NULL AND LEN(perpar.id) > 0) AND
					(perpar.perPersonIdFather IS NOT NULL AND LEN(perpar.perPersonIdFather) > 0) AND
					(perpar.idCardFather IS NOT NULL AND LEN(perpar.idCardFather) > 0) AND
					(perpar.perTitlePrefixIdFather IS NOT NULL AND LEN(perpar.perTitlePrefixIdFather) > 0) AND
					(perpar.firstNameFather IS NOT NULL AND LEN(perpar.firstNameFather) > 0) AND
					(perpar.lastNameFather IS NOT NULL AND LEN(perpar.lastNameFather) > 0) AND
					(perpar.perMaritalStatusIdFather IS NOT NULL AND LEN(perpar.perMaritalStatusIdFather) > 0)
				THEN
					1
				ELSE
					0
				END
			) AS perPersonFather,
			--ข้อมูลส่วนตัวของมารดาที่จำเป็น
			(
				CASE WHEN
					(perpar.id IS NOT NULL AND LEN(perpar.id) > 0) AND
					(perpar.perPersonIdMother IS NOT NULL AND LEN(perpar.perPersonIdMother) > 0) AND
					(perpar.idCardMother IS NOT NULL AND LEN(perpar.idCardMother) > 0) AND
					(perpar.perTitlePrefixIdMother IS NOT NULL AND LEN(perpar.perTitlePrefixIdMother) > 0) AND
					(perpar.firstNameMother IS NOT NULL AND LEN(perpar.firstNameMother) > 0) AND
					(perpar.lastNameMother IS NOT NULL AND LEN(perpar.lastNameMother) > 0) AND
					(perpar.perMaritalStatusIdMother IS NOT NULL AND LEN(perpar.perMaritalStatusIdMother) > 0)
				THEN
					1
				ELSE
					0
				END
			) AS perPersonMother,
			--ข้อมูลส่วนตัวของผู้ปกครองที่จำเป็น
			(
				CASE WHEN
					(perpar.id IS NOT NULL AND LEN(perpar.id) > 0) AND
					(perpar.perPersonIdParent IS NOT NULL AND LEN(perpar.perPersonIdParent) > 0) AND
					(perpar.idCardParent IS NOT NULL AND LEN(perpar.idCardParent) > 0) AND
					(perpar.perTitlePrefixIdParent IS NOT NULL AND LEN(perpar.perTitlePrefixIdParent) > 0) AND
					(perpar.firstNameParent IS NOT NULL AND LEN(perpar.firstNameParent) > 0) AND
					(perpar.lastNameParent IS NOT NULL AND LEN(perpar.lastNameParent) > 0) AND
					(perpar.perMaritalStatusIdParent IS NOT NULL AND LEN(perpar.perMaritalStatusIdParent) > 0)
				THEN
					1
				ELSE
					0
				END
			) AS perPersonParent,
			--ข้อมูลที่อยู่ของบิดาที่จำเป็น
			(
				CASE WHEN
					(perpar.id IS NOT NULL AND LEN(perpar.id) > 0) AND
					(perpar.peraddPersonIdFather IS NOT NULL AND LEN(perpar.peraddPersonIdFather) > 0) AND
					(perpar.plcCountryIdPermanentFather IS NOT NULL AND LEN(perpar.plcCountryIdPermanentFather) > 0) AND
					(perpar.noPermanentFather IS NOT NULL AND LEN(perpar.noPermanentFather) > 0) AND
					((perpar.phoneNumberPermanentFather IS NOT NULL AND LEN(perpar.phoneNumberPermanentFather) > 0) OR (perpar.mobileNumberPermanentFather IS NOT NULL AND LEN(perpar.mobileNumberPermanentFather) > 0)) AND
					(perpar.plcCountryIdCurrentFather IS NOT NULL AND LEN(perpar.plcCountryIdCurrentFather) > 0) AND
					(perpar.noCurrentFather IS NOT NULL AND LEN(perpar.noCurrentFather) > 0) AND
					((perpar.phoneNumberCurrentFather IS NOT NULL AND LEN(perpar.phoneNumberCurrentFather) > 0) OR (perpar.mobileNumberCurrentFather IS NOT NULL AND LEN(perpar.mobileNumberCurrentFather) > 0)) 
				THEN
					1
				ELSE
					0
				END
			) AS perAddressFather,
			--ข้อมูลที่อยู่ตามทะเบียนบ้านของบิดาที่จำเป็น
			(
				CASE WHEN
					(perpar.id IS NOT NULL AND LEN(perpar.id) > 0) AND
					(perpar.peraddPersonIdFather IS NOT NULL AND LEN(perpar.peraddPersonIdFather) > 0) AND
					(perpar.plcCountryIdPermanentFather IS NOT NULL AND LEN(perpar.plcCountryIdPermanentFather) > 0) AND
					(perpar.noPermanentFather IS NOT NULL AND LEN(perpar.noPermanentFather) > 0) AND
					((perpar.phoneNumberPermanentFather IS NOT NULL AND LEN(perpar.phoneNumberPermanentFather) > 0) OR (perpar.mobileNumberPermanentFather IS NOT NULL AND LEN(perpar.mobileNumberPermanentFather) > 0))
				THEN
					1
				ELSE
					0
				END
			) AS perAddressPermanentFather,
			--ข้อมูลที่อยู่ปัจจุบันที่ติดต่อได้ของบิดาที่จำเป็น
			(
				CASE WHEN
					(perpar.id IS NOT NULL AND LEN(perpar.id) > 0) AND
					(perpar.peraddPersonIdFather IS NOT NULL AND LEN(perpar.peraddPersonIdFather) > 0) AND
					(perpar.plcCountryIdCurrentFather IS NOT NULL AND LEN(perpar.plcCountryIdCurrentFather) > 0) AND
					(perpar.noCurrentFather IS NOT NULL AND LEN(perpar.noCurrentFather) > 0) AND
					((perpar.phoneNumberCurrentFather IS NOT NULL AND LEN(perpar.phoneNumberCurrentFather) > 0) OR (perpar.mobileNumberCurrentFather IS NOT NULL AND LEN(perpar.mobileNumberCurrentFather) > 0)) 
				THEN
					1
				ELSE
					0
				END
			) AS perAddressCurrentFather,
			--ข้อมูลที่อยู่ของมารดาที่จำเป็น
			(
				CASE WHEN
					(perpar.id IS NOT NULL AND LEN(perpar.id) > 0) AND
					(perpar.peraddPersonIdMother IS NOT NULL AND LEN(perpar.peraddPersonIdMother) > 0) AND
					(perpar.plcCountryIdPermanentMother IS NOT NULL AND LEN(perpar.plcCountryIdPermanentMother) > 0) AND
					(perpar.noPermanentMother IS NOT NULL AND LEN(perpar.noPermanentMother) > 0) AND
					((perpar.phoneNumberPermanentMother IS NOT NULL AND LEN(perpar.phoneNumberPermanentMother) > 0) OR (perpar.mobileNumberPermanentMother IS NOT NULL AND LEN(perpar.mobileNumberPermanentMother) > 0)) AND
					(perpar.plcCountryIdCurrentMother IS NOT NULL AND LEN(perpar.plcCountryIdCurrentMother) > 0) AND
					(perpar.noCurrentMother IS NOT NULL AND LEN(perpar.noCurrentMother) > 0) AND
					((perpar.phoneNumberCurrentMother IS NOT NULL AND LEN(perpar.phoneNumberCurrentMother) > 0) OR (perpar.mobileNumberCurrentMother IS NOT NULL AND LEN(perpar.mobileNumberCurrentMother) > 0))
				THEN
					1
				ELSE
					0
				END
			) AS perAddressMother,
			--ข้อมูลที่อยู่ตามทะเบียนบ้านของมารดาที่จำเป็น
			(
				CASE WHEN
					(perpar.id IS NOT NULL AND LEN(perpar.id) > 0) AND
					(perpar.peraddPersonIdMother IS NOT NULL AND LEN(perpar.peraddPersonIdMother) > 0) AND
					(perpar.plcCountryIdPermanentMother IS NOT NULL AND LEN(perpar.plcCountryIdPermanentMother) > 0) AND
					(perpar.noPermanentMother IS NOT NULL AND LEN(perpar.noPermanentMother) > 0) AND
					((perpar.phoneNumberPermanentMother IS NOT NULL AND LEN(perpar.phoneNumberPermanentMother) > 0) OR (perpar.mobileNumberPermanentMother IS NOT NULL AND LEN(perpar.mobileNumberPermanentMother) > 0))
				THEN
					1
				ELSE
					0
				END
			) AS perAddressPermanentMother,
			--ข้อมูลที่อยู่ปัจจุบันที่ติดต่อได้ของมารดาที่จำเป็น
			(
				CASE WHEN
					(perpar.id IS NOT NULL AND LEN(perpar.id) > 0) AND
					(perpar.peraddPersonIdMother IS NOT NULL AND LEN(perpar.peraddPersonIdMother) > 0) AND
					(perpar.plcCountryIdCurrentMother IS NOT NULL AND LEN(perpar.plcCountryIdCurrentMother) > 0) AND
					(perpar.noCurrentMother IS NOT NULL AND LEN(perpar.noCurrentMother) > 0) AND
					((perpar.phoneNumberCurrentMother IS NOT NULL AND LEN(perpar.phoneNumberCurrentMother) > 0) OR (perpar.mobileNumberCurrentMother IS NOT NULL AND LEN(perpar.mobileNumberCurrentMother) > 0))
				THEN
					1
				ELSE
					0
				END
			) AS perAddressCurrentMother,
			--ข้อมูลที่อยู่ของผู้ปกครองที่จำเป็น
			(
				CASE WHEN
					(perpar.id IS NOT NULL AND LEN(perpar.id) > 0) AND
					(perpar.peraddPersonIdParent IS NOT NULL AND LEN(perpar.peraddPersonIdParent) > 0) AND
					(perpar.plcCountryIdPermanentParent IS NOT NULL AND LEN(perpar.plcCountryIdPermanentParent) > 0) AND
					(perpar.noPermanentParent IS NOT NULL AND LEN(perpar.noPermanentParent) > 0) AND
					((perpar.phoneNumberPermanentParent IS NOT NULL AND LEN(perpar.phoneNumberPermanentParent) > 0) OR (perpar.mobileNumberPermanentParent IS NOT NULL AND LEN(perpar.mobileNumberPermanentParent) > 0)) AND
					(perpar.plcCountryIdCurrentParent IS NOT NULL AND LEN(perpar.plcCountryIdCurrentParent) > 0) AND
					(perpar.noCurrentParent IS NOT NULL AND LEN(perpar.noCurrentParent) > 0) AND
					((perpar.phoneNumberCurrentParent IS NOT NULL AND LEN(perpar.phoneNumberCurrentParent) > 0) OR (perpar.mobileNumberCurrentParent IS NOT NULL AND LEN(perpar.mobileNumberCurrentParent) > 0))
				THEN
					1
				ELSE
					0
				END
			) AS perAddressParent,
			--ข้อมูลที่อยู่ตามทะเบียนบ้านของผู้ปกครองที่จำเป็น
			(
				CASE WHEN
					(perpar.id IS NOT NULL AND LEN(perpar.id) > 0) AND
					(perpar.peraddPersonIdParent IS NOT NULL AND LEN(perpar.peraddPersonIdParent) > 0) AND
					(perpar.plcCountryIdPermanentParent IS NOT NULL AND LEN(perpar.plcCountryIdPermanentParent) > 0) AND
					(perpar.noPermanentParent IS NOT NULL AND LEN(perpar.noPermanentParent) > 0) AND
					((perpar.phoneNumberPermanentParent IS NOT NULL AND LEN(perpar.phoneNumberPermanentParent) > 0) OR (perpar.mobileNumberPermanentParent IS NOT NULL AND LEN(perpar.mobileNumberPermanentParent) > 0))
				THEN
					1
				ELSE
					0
				END
			) AS perAddressPermanentParent,
			--ข้อมูลที่อยู่ปัจจุบันที่ติดต่อได้ของผู้ปกครองที่จำเป็น
			(
				CASE WHEN
					(perpar.id IS NOT NULL AND LEN(perpar.id) > 0) AND
					(perpar.peraddPersonIdParent IS NOT NULL AND LEN(perpar.peraddPersonIdParent) > 0) AND
					(perpar.plcCountryIdCurrentParent IS NOT NULL AND LEN(perpar.plcCountryIdCurrentParent) > 0) AND
					(perpar.noCurrentParent IS NOT NULL AND LEN(perpar.noCurrentParent) > 0) AND
					((perpar.phoneNumberCurrentParent IS NOT NULL AND LEN(perpar.phoneNumberCurrentParent) > 0) OR (perpar.mobileNumberCurrentParent IS NOT NULL AND LEN(perpar.mobileNumberCurrentParent) > 0))
				THEN
					1
				ELSE
					0
				END
			) AS perAddressCurrentParent,
			--ข้อมูลการทำงานของบิดาที่จำเป็น
			(
				CASE WHEN
					(perpar.id IS NOT NULL AND LEN(perpar.id) > 0) AND
					(perpar.perworPersonIdFather IS NOT NULL AND LEN(perpar.perworPersonIdFather) > 0) AND
					(perpar.occupationFather IS NOT NULL AND LEN(perpar.occupationFather) > 0)
				THEN
					1
				ELSE
					0
				END
			) AS perWorkFather,
			--ข้อมูลการทำงานของมารดาที่จำเป็น
			(
				CASE WHEN
					(perpar.id IS NOT NULL AND LEN(perpar.id) > 0) AND
					(perpar.perworPersonIdMother IS NOT NULL AND LEN(perpar.perworPersonIdMother) > 0) AND
					(perpar.occupationMother IS NOT NULL AND LEN(perpar.occupationMother) > 0)
				THEN
					1
				ELSE
					0
				END
			) AS perWorkMother,
			--ข้อมูลการทำงานของผู้ปกครองที่จำเป็น
			(
				CASE WHEN
					(perpar.id IS NOT NULL AND LEN(perpar.id) > 0) AND
					(perpar.perworPersonIdParent IS NOT NULL AND LEN(perpar.perworPersonIdParent) > 0) AND
					(perpar.occupationParent IS NOT NULL AND LEN(perpar.occupationParent) > 0)
				THEN
					1
				ELSE
					0
				END
			) AS perWorkParent
	FROM	stdStudent AS stdstd LEFT JOIN
			perPerson AS perpes ON stdstd.personId = perpes.id LEFT JOIN
			perAddress AS peradd ON perpes.id = peradd.perPersonId LEFT JOIN
			perEducation AS peredu ON perpes.id = peredu.perPersonId LEFT JOIN
			perActivity AS peract ON perpes.id = peract.perPersonId LEFT JOIN
			perHealthy AS perhea ON perpes.id = perhea.perPersonId LEFT JOIN
			perWork AS perwor ON perpes.id = perwor.perPersonId LEFT JOIN
			perFinancial AS perfin ON perpes.id = perfin.perPersonId LEFT JOIN
			vw_perGetListParent AS perpar ON perpes.id = perpar.id
	WHERE	(1 = (CASE WHEN	(LEN(ISNULL(@personId, '')) > 0) THEN 0 ELSE 1 END) OR perpes.id = @personId) AND
			(1 = (CASE WHEN	(LEN(ISNULL(@yearEntry, '')) > 0) THEN 0 ELSE 1 END) OR stdstd.yearEntry = @yearEntry)
)
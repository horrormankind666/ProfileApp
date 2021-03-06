USE [Infinity]
GO
/****** Object:  UserDefinedFunction [dbo].[fnc_perGetListValidateRecordPerson]    Script Date: 6/10/2564 1:50:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๓๐/๐๕/๒๕๖๒>
-- Description	: <สำหรับแสดงสถานะการบันทึกระเบียนประวัติ>
-- =============================================
ALTER function [dbo].[fnc_perGetListValidateRecordPerson] 
(
)
returns table
as
return
(
	select	a.*,
			(
				case when
					(a.perPerson = 1) and
					(a.perAddress = 1) and
					(a.perEducation = 1) and
					(a.perActivity = 1) and
					(a.perHealthy = 1) and
					(a.perWork = 1) and 
					(a.perFinancial = 1) and
					(a.perPersonFather = 1) and 
					(a.perAddressFather = 1) and 
					(a.perWorkFather = 1) and
					(a.perPersonMother = 1) and 
					(a.perAddressMother = 1) and 
					(a.perWorkMother = 1) and
					(a.perPersonParent = 1) and 
					(a.perAddressParent = 1) and 
					(a.perWorkParent = 1)
				then
					'Y'
				else
					'N'
				end
			) as studentRecordsStatus
	from	(
				select	perpes.id,
						stdstd.yearEntry,
						--ข้อมูลส่วนตัวที่จำเป็น
						(
							case when
								(len(isnull(perpes.id, '')) > 0) and
								(len(isnull(perpes.idCard, '')) > 0) and
								(len(case when (perpes.idCardIssueDate is not null) then convert(varchar, perpes.idCardIssueDate, 103) else '' end) > 0) and
								(len(case when (perpes.idCardExpiryDate is not null) then convert(varchar, perpes.idCardExpiryDate, 103) else '' end) > 0) and
								(len(isnull(perpes.perTitlePrefixId, '')) > 0) and
								(len(isnull(perpes.firstName, '')) > 0) and
								--(len(isnull(perpes.lastName, '')) > 0) and
								(len(isnull(perpes.enFirstName, '')) > 0) and
								--(len(isnull(perpes.enLastName, '')) > 0) and
								(len(isnull(perpes.perGenderId, '')) > 0) and
								(len(case when (perpes.birthDate is not null) then convert(varchar, perpes.birthDate, 103) else '' end) > 0) and
								(len(isnull(perpes.plcCountryId, '')) > 0) and
								(len(isnull(perpes.perNationalityId, '')) > 0) and
								--(len(isnull(perpes.perOriginId, '')) > 0) and
								--(len(isnull(perpes.perReligionId, '')) > 0) and
								(len(isnull(perpes.perMaritalStatusId, '')) > 0) and
								(len(isnull(perpes.perEducationalBackgroundId, '')) > 0) and
								(len(isnull(perpes.email, '')) > 0)
							then
								1		
							else
								0
							end
						) as perPerson,
						--ข้อมูลที่อยู่ที่จำเป็น
						(
							case when
								(len(isnull(peradd.perPersonId, '')) > 0) and
								(len(isnull(peradd.plcCountryIdPermanent, '')) > 0) and
								(len(case when (pernat.isoCountryCodes2Letter = 'TH') then isnull(peradd.plcProvinceIdPermanent, '') else 'pass' end) > 0) and
								(len(case when (pernat.isoCountryCodes2Letter = 'TH') then isnull(peradd.plcDistrictIdPermanent, '') else 'pass' end) > 0) and
								(len(case when (pernat.isoCountryCodes2Letter = 'TH') then isnull(peradd.plcSubdistrictIdPermanent, '') else 'pass' end) > 0) and
								(len(case when (pernat.isoCountryCodes2Letter = 'TH') then isnull(peradd.zipCodePermanent, '') else 'pass' end) > 0) and
								(len(isnull(peradd.noPermanent, '')) > 0) and
								((len(isnull(peradd.phoneNumberPermanent, '')) > 0) or (len(isnull(peradd.mobileNumberPermanent, '')) > 0)) and
								(len(isnull(peradd.plcCountryIdCurrent, '')) > 0) and
								(len(case when (pernat.isoCountryCodes2Letter = 'TH') then isnull(peradd.plcProvinceIdCurrent, '') else 'pass' end) > 0) and
								(len(case when (pernat.isoCountryCodes2Letter = 'TH') then isnull(peradd.plcDistrictIdCurrent, '') else 'pass' end) > 0) and
								(len(case when (pernat.isoCountryCodes2Letter = 'TH') then isnull(peradd.plcSubdistrictIdCurrent, '') else 'pass' end) > 0) and
								(len(case when (pernat.isoCountryCodes2Letter = 'TH') then isnull(peradd.zipCodeCurrent, '') else 'pass' end) > 0) and
								(len(isnull(peradd.noCurrent, '')) > 0) and
								((len(isnull(peradd.phoneNumberCurrent, '')) > 0) or (len(isnull(peradd.mobileNumberCurrent, '')) > 0)) 
							then
								1
							else
								0					
							end
						) as perAddress,
						--ข้อมูลที่อยู่ตามทะเบียนบ้านที่จำเป็น
						(
							case when
								(len(isnull(peradd.perPersonId, '')) > 0) and
								(len(isnull(peradd.plcCountryIdPermanent, '')) > 0) and
								(len(case when (pernat.isoCountryCodes2Letter = 'TH') then isnull(peradd.plcProvinceIdPermanent, '') else 'pass' end) > 0) and
								(len(case when (pernat.isoCountryCodes2Letter = 'TH') then isnull(peradd.plcDistrictIdPermanent, '') else 'pass' end) > 0) and
								(len(case when (pernat.isoCountryCodes2Letter = 'TH') then isnull(peradd.plcSubdistrictIdPermanent, '') else 'pass' end) > 0) and
								(len(case when (pernat.isoCountryCodes2Letter = 'TH') then isnull(peradd.zipCodePermanent, '') else 'pass' end) > 0) and
								(len(isnull(peradd.noPermanent, '')) > 0) and
								((len(isnull(peradd.phoneNumberPermanent, '')) > 0) or (len(isnull(peradd.mobileNumberPermanent, '')) > 0))
							then
								1
							else
								0					
							end
						) as perAddressPermanent,
						--ข้อมูลที่อยู่ปัจจุบันที่ติดต่อได้ที่จำเป็น
						(
							case when
								(len(isnull(peradd.perPersonId, '')) > 0) and
								(len(isnull(peradd.plcCountryIdCurrent, '')) > 0) and
								(len(case when (pernat.isoCountryCodes2Letter = 'TH') then isnull(peradd.plcProvinceIdCurrent, '') else 'pass' end) > 0) and
								(len(case when (pernat.isoCountryCodes2Letter = 'TH') then isnull(peradd.plcDistrictIdCurrent, '') else 'pass' end) > 0) and
								(len(case when (pernat.isoCountryCodes2Letter = 'TH') then isnull(peradd.plcSubdistrictIdCurrent, '') else 'pass' end) > 0) and
								(len(case when (pernat.isoCountryCodes2Letter = 'TH') then isnull(peradd.zipCodeCurrent, '') else 'pass' end) > 0) and
								(len(isnull(peradd.noCurrent, '')) > 0) and
								((len(isnull(peradd.phoneNumberCurrent, '')) > 0) or (len(isnull(peradd.mobileNumberCurrent, '')) > 0)) 
							then
								1
							else
								0					
							end
						) as perAddressCurrent,
						--ข้อมูลการศึกษาที่จำเป็น
						(
							case when
								(len(isnull(peredu.perPersonId, '')) > 0) and
								(len(isnull(peredu.highSchoolName, '')) > 0) and
								(len(isnull(peredu.plcCountryIdHighSchool, '')) > 0) and
								((len(isnull(peredu.perEducationalMajorIdHighSchool, '')) > 0) or (len(isnull(peredu.educationalMajorOtherHighSchool, '')) > 0)) and
								(len(isnull(peredu.perEducationalBackgroundIdHighSchool, '')) > 0) and
								(len(isnull(peredu.perEducationalBackgroundId, '')) > 0) and
								(len(isnull(peredu.graduateBy, '')) > 0) and
								(len(isnull(peredu.entranceTime, '')) > 0) and
								(len(isnull(peredu.studentIs, '')) > 0) and
								(len(isnull(peredu.perEntranceTypeId, '')) > 0)
							then
								1
							else
								0
							end
						) as perEducation,
						--ข้อมูลการศึกษาระดับประถมที่จำเป็น
						1 as perEducationPrimarySchool,
						--ข้อมูลการศึกษาระดับมัธยมต้นที่จำเป็น
						1 as perEducationJuniorHighSchool,
						--ข้อมูลการศึกษาระดับมัธยมปลายที่จำเป็น
						(
							case when
								(len(isnull(peredu.perPersonId, '')) > 0) and
								(len(isnull(peredu.highSchoolName, '')) > 0) and
								(len(isnull(peredu.plcCountryIdHighSchool, '')) > 0) and
								((len(isnull(peredu.perEducationalMajorIdHighSchool, '')) > 0) or (len(isnull(peredu.educationalMajorOtherHighSchool, '')) > 0)) and
								(len(isnull(peredu.perEducationalBackgroundIdHighSchool, '')) > 0)
							then
								1
							else
								0
							end
						) as perEducationHighSchool,
						--ข้อมูลการศึกษาก่อนที่เข้าม.มหิดลที่จำเป็น
						(
							case when
								(len(isnull(peredu.perPersonId, '')) > 0) and
								(len(isnull(peredu.perEducationalBackgroundId, '')) > 0) and
								(len(isnull(peredu.graduateBy, '')) > 0) and
								(len(isnull(peredu.entranceTime, '')) > 0) and
								(len(isnull(peredu.studentIs, '')) > 0) and
								(len(isnull(peredu.perEntranceTypeId, '')) > 0)
							then
								1
							else
								0
							end
						) as perEducationUniversity,
						--ข้อมูลการศึกษาคะแนนสอบที่จำเป็น
						1 as perEducationAdmissionScores,
						--ข้อมูลความสามารถพิเศษที่จำเป็น
						1 as perActivity,
						--ข้อมูลสุขภาพที่จำเป็น
						1 as perHealthy,
						/*
						(
							case when
								(len(isnull(perhea.perPersonId, '')) > 0) and
								(len(isnull(perhea.bodyMassDetail, '')) > 0)
							then
								1
							else
								0
							end
						) as perHealthy,
						*/
						--ข้อมูลการทำงานที่จำเป็น
						1 as perWork,
						--ข้อมูลการเงินที่จำเป็น
						1 as perFinancial,
						--ข้อมูลส่วนตัวของบิดาที่จำเป็น
						(
							case when
								(len(isnull(perpar.id, '')) > 0) and
								(len(isnull(perpar.perPersonIdFather, '')) > 0) and
								((ectprg.programId is not null and len(isnull(perpar.idCardFather, '')) > 0) or ectprg.programId is null) and
								(len(isnull(perpar.perTitlePrefixIdFather, '')) > 0) and
								(len(isnull(perpar.firstNameFather, '')) > 0) and
								(len(isnull(perpar.lastNameFather, '')) > 0) and
								(len(isnull(perpar.perMaritalStatusIdFather, '')) > 0)
							then
								1
							else
								0
							end
						) as perPersonFather,
						--ข้อมูลส่วนตัวของมารดาที่จำเป็น
						(
							case when
								(len(isnull(perpar.id, '')) > 0) and
								(len(isnull(perpar.perPersonIdMother, '')) > 0) and
								((ectprg.programId is not null and len(isnull(perpar.idCardMother, '')) > 0) or ectprg.programId is null) and
								(len(isnull(perpar.perTitlePrefixIdMother, '')) > 0) and
								(len(isnull(perpar.firstNameMother, '')) > 0) and
								(len(isnull(perpar.lastNameMother, '')) > 0) and
								(len(isnull(perpar.perMaritalStatusIdMother, '')) > 0)
							then
								1
							else
								0
							end
						) as perPersonMother,
						--ข้อมูลส่วนตัวของผู้ปกครองที่จำเป็น
						(
							case when
								(len(isnull(perpar.id, '')) > 0) and
								(len(isnull(perpar.perPersonIdParent, '')) > 0) and
								((ectprg.programId is not null and len(isnull(perpar.idCardParent, '')) > 0) or ectprg.programId is null) and
								(len(isnull(perpar.perTitlePrefixIdParent, '')) > 0) and
								(len(isnull(perpar.firstNameParent, '')) > 0) and
								(len(isnull(perpar.lastNameParent, '')) > 0) and
								(len(isnull(perpar.perMaritalStatusIdParent, '')) > 0)
							then
								1
							else
								0
							end
						) as perPersonParent,
						--ข้อมูลที่อยู่ของบิดาที่จำเป็น
						(
							case when
								(len(isnull(perpar.id, '')) > 0) and
								(len(isnull(perpar.peraddPersonIdFather, '')) > 0) and
								(len(isnull(perpar.plcCountryIdPermanentFather, '')) > 0) and
								(len(isnull(perpar.noPermanentFather, '')) > 0) and
								((len(isnull(perpar.phoneNumberPermanentFather, '')) > 0) or (len(isnull(perpar.mobileNumberPermanentFather, '')) > 0)) and
								(len(isnull(perpar.plcCountryIdCurrentFather, '')) > 0) and
								(len(isnull(perpar.noCurrentFather, '')) > 0) and
								((len(isnull(perpar.phoneNumberCurrentFather, '')) > 0) or (len(isnull(perpar.mobileNumberCurrentFather, '')) > 0)) 
							then
								1
							else
								0
							end
						) as perAddressFather,
						--ข้อมูลที่อยู่ตามทะเบียนบ้านของบิดาที่จำเป็น
						(
							case when
								(len(isnull(perpar.id, '')) > 0) and
								(len(isnull(perpar.peraddPersonIdFather, '')) > 0) and
								(len(isnull(perpar.plcCountryIdPermanentFather, '')) > 0) and
								(len(isnull(perpar.noPermanentFather, '')) > 0) and
								((len(isnull(perpar.phoneNumberPermanentFather, '')) > 0) or (len(isnull(perpar.mobileNumberPermanentFather, '')) > 0))
							then
								1
							else
								0
							end
						) as perAddressPermanentFather,
						--ข้อมูลที่อยู่ปัจจุบันที่ติดต่อได้ของบิดาที่จำเป็น
						(
							case when
								(len(isnull(perpar.id, '')) > 0) and
								(len(isnull(perpar.peraddPersonIdFather, '')) > 0) and
								(len(isnull(perpar.plcCountryIdCurrentFather, '')) > 0) and
								(len(isnull(perpar.noCurrentFather, '')) > 0) and
								((len(isnull(perpar.phoneNumberCurrentFather, '')) > 0) or (len(isnull(perpar.mobileNumberCurrentFather, '')) > 0)) 
							then
								1
							else
								0
							end
						) as perAddressCurrentFather,
						--ข้อมูลที่อยู่ของมารดาที่จำเป็น
						(
							case when
								(len(isnull(perpar.id, '')) > 0) and
								(len(isnull(perpar.peraddPersonIdMother, '')) > 0) and
								(len(isnull(perpar.plcCountryIdPermanentMother, '')) > 0) and
								(len(isnull(perpar.noPermanentMother, '')) > 0) and
								((len(isnull(perpar.phoneNumberPermanentMother, '')) > 0) or (len(isnull(perpar.mobileNumberPermanentMother, '')) > 0)) and
								(len(isnull(perpar.plcCountryIdCurrentMother, '')) > 0) and
								(len(isnull(perpar.noCurrentMother, '')) > 0) and
								((len(isnull(perpar.phoneNumberCurrentMother, '')) > 0) or (len(isnull(perpar.mobileNumberCurrentMother, '')) > 0))
							then
								1
							else
								0
							end
						) as perAddressMother,
						--ข้อมูลที่อยู่ตามทะเบียนบ้านของมารดาที่จำเป็น
						(
							case when
								(len(isnull(perpar.id, '')) > 0) and
								(len(isnull(perpar.peraddPersonIdMother, '')) > 0) and
								(len(isnull(perpar.plcCountryIdPermanentMother, '')) > 0) and
								(len(isnull(perpar.noPermanentMother, '')) > 0) and
								((len(isnull(perpar.phoneNumberPermanentMother, '')) > 0) or (len(isnull(perpar.mobileNumberPermanentMother, '')) > 0))
							then
								1
							else
								0
							end
						) as perAddressPermanentMother,
						--ข้อมูลที่อยู่ปัจจุบันที่ติดต่อได้ของมารดาที่จำเป็น
						(
							case when
								(len(isnull(perpar.id, '')) > 0) and
								(len(isnull(perpar.peraddPersonIdMother, '')) > 0) and
								(len(isnull(perpar.plcCountryIdCurrentMother, '')) > 0) and
								(len(isnull(perpar.noCurrentMother, '')) > 0) and
								((len(isnull(perpar.phoneNumberCurrentMother, '')) > 0) or (len(isnull(perpar.mobileNumberCurrentMother, '')) > 0))
							then
								1
							else
								0
							end
						) as perAddressCurrentMother,
						--ข้อมูลที่อยู่ของผู้ปกครองที่จำเป็น
						(
							case when
								(len(isnull(perpar.id, '')) > 0) and
								(len(isnull(perpar.peraddPersonIdParent, '')) > 0) and
								(len(isnull(perpar.plcCountryIdPermanentParent, '')) > 0) and
								(len(isnull(perpar.noPermanentParent, '')) > 0) and
								((len(isnull(perpar.phoneNumberPermanentParent, '')) > 0) or (len(isnull(perpar.mobileNumberPermanentParent, '')) > 0)) and
								(len(isnull(perpar.plcCountryIdCurrentParent, '')) > 0) and
								(len(isnull(perpar.noCurrentParent, '')) > 0) and
								((len(isnull(perpar.phoneNumberCurrentParent, '')) > 0) or (len(isnull(perpar.mobileNumberCurrentParent, '')) > 0))
							then
								1
							else
								0
							end
						) as perAddressParent,
						--ข้อมูลที่อยู่ตามทะเบียนบ้านของผู้ปกครองที่จำเป็น
						(
							case when
								(len(isnull(perpar.id, '')) > 0) and
								(len(isnull(perpar.peraddPersonIdParent, '')) > 0) and
								(len(isnull(perpar.plcCountryIdPermanentParent, '')) > 0) and
								(len(isnull(perpar.noPermanentParent, '')) > 0) and
								((len(isnull(perpar.phoneNumberPermanentParent, '')) > 0) or (len(isnull(perpar.mobileNumberPermanentParent, '')) > 0))
							then
								1
							else
								0
							end
						) as perAddressPermanentParent,
						--ข้อมูลที่อยู่ปัจจุบันที่ติดต่อได้ของผู้ปกครองที่จำเป็น
						(
							case when
								(len(isnull(perpar.id, '')) > 0) and
								(len(isnull(perpar.peraddPersonIdParent, '')) > 0) and
								(len(isnull(perpar.plcCountryIdCurrentParent, '')) > 0) and
								(len(isnull(perpar.noCurrentParent, '')) > 0) and
								((len(isnull(perpar.phoneNumberCurrentParent, '')) > 0) or (len(isnull(perpar.mobileNumberCurrentParent, '')) > 0))
							then
								1
							else
								0
							end
						) as perAddressCurrentParent,
						--ข้อมูลการทำงานของบิดาที่จำเป็น
						(
							case when
								(len(isnull(perpar.id, '')) > 0) and
								(len(isnull(perpar.perworPersonIdFather, '')) > 0) and
								(len(isnull(perpar.occupationFather, '')) > 0)
							then
								1
							else
								0
							end
						) as perWorkFather,
						--ข้อมูลการทำงานของมารดาที่จำเป็น
						(
							case when
								(len(isnull(perpar.id, '')) > 0) and
								(len(isnull(perpar.perworPersonIdMother, '')) > 0) and
								(len(isnull(perpar.occupationMother, '')) > 0)
							then
								1
							else
								0
							end
						) AS perWorkMother,
						--ข้อมูลการทำงานของผู้ปกครองที่จำเป็น
						(
							case when
								(len(isnull(perpar.id, '')) > 0) and
								(len(isnull(perpar.perworPersonIdParent, '')) > 0) and
								(len(isnull(perpar.occupationParent, '')) > 0)
							then
								1
							else
								0
							end
						) as perWorkParent
				from	stdStudent as stdstd with (nolock) left join
						ectProgramContract as ectprg on stdstd.programId = ectprg.programId left join
						perPerson as perpes with (nolock) on stdstd.personId = perpes.id left join
						perNationality as pernat with(nolock) on perpes.perNationalityId = pernat.id left join
						perAddress as peradd with (nolock) on perpes.id = peradd.perPersonId left join
						perEducation as peredu with (nolock) on perpes.id = peredu.perPersonId left join
						perActivity as peract with (nolock) on perpes.id = peract.perPersonId left join
						perHealthy as perhea with (nolock) on perpes.id = perhea.perPersonId left join
						perWork as perwor with (nolock) on perpes.id = perwor.perPersonId left join
						perFinancial as perfin with (nolock) on perpes.id = perfin.perPersonId left join
						fnc_perGetListPersonParent() as perpar on perpes.id = perpar.id
			) as a	
)

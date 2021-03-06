USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_udsGetPersonStudent]    Script Date: 15/7/2564 17:56:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๒/๐๖/๒๕๕๘>
-- Description	: <สำหรับเรียกดูข้อมูลของนักศึกษาสำหรับระบบอัพโหลดเอกสารของนักศึกษา>
-- Parameter
--  1. personId	เป็น varchar	รับค่ารหัสบุคคล
-- =============================================
/*
exec sp_udsGetPersonStudent 2563319776
*/

ALTER procedure [dbo].[sp_udsGetPersonStudent]
(
	@personId varchar(10) = null
)
as
begin
	set concat_null_yields_null off
	
	set @personId = ltrim(rtrim(isnull(@personId, '')))
		
	select	perstd.id,
			perstd.studentId,
			perstd.studentCode,
			perstd.idCard,
			perstd.idCardExpiryDate,			
			perstd.thIdCardExpiryDate as idCardExpiryDateTH,
			perstd.enIdCardExpiryDate as idCardExpiryDateEN,
			perstd.thTitleFullName as titlePrefixFullNameTH,
			perstd.thTitleInitials as titlePrefixInitialsTH,					
			perstd.enTitleFullName as titlePrefixFullNameEN,
			perstd.enTitleInitials as titlePrefixInitialsEN,
			perstd.firstName,
			perstd.middleName,
			perstd.lastName,
			perstd.enFirstName as firstNameEN,
			perstd.enMiddleName as middleNameEN,
			perstd.enLastName as lastNameEN,
			perstd.thGenderFullName as genderFullNameTH,
			perstd.thGenderInitials as genderInitialsTH,
			perstd.enGenderFullName as genderFullNameEN,
			perstd.enGenderInitials as genderInitialsEN,
			perstd.birthDate,
			isnull(day(perstd.birthDate), null) as birthDateOfDay,
			isnull(month(perstd.birthDate), null) as birthDateOfMonth,
			(case when (isnull(year(perstd.birthDate), null) is not null) then (year(perstd.birthDate) + 543) else null end) as birthDateOfYear,
			perstd.thBirthDate as birthDateTH,
			perstd.enBirthDate as birthDateEN,
			perstd.degree,
			perstd.degreeLevelNameTH,
			perstd.degreeLevelNameEN,
			perstd.facultyCode,
			perstd.facultyNameTH,
			perstd.facultyNameEN,
			perstd.programCode,
			perstd.programNameTH,
			perstd.programNameEN,
			perstd.majorCode,
			perstd.groupNum,
			perstd.yearEntry,
			perstd.studyYear,
			perstd.perEntranceTypeId,
			perstd.stdEntranceTypeNameTH,
			perstd.stdEntranceTypeNameEN,	
			perstd.stdStatusTypeId,
			perstd.statusTypeNameTH,
			perstd.statusTypeNameEN,		
			perstd.countryNameTH,
			perstd.countryNameEN,	
			perstd.isoCountryCodes2Letter,		
			perstd.perNationalityId, 
			perstd.thNationalityName as nationalityNameTH,
			perstd.enNationalityName as nationalityNameEN,	
			perstd.isoNationalityName2Letter,
			perstd.perOriginId,
			perstd.thOriginName as originNameTH,
			perstd.enOriginName as originNameEN,			
			perstd.perReligionId,
			perstd.thReligionName as religionNameTH,
			perstd.enReligionName as religionNameEN,
			perstd.perBloodTypeId,
			perstd.thBloodTypeName as bloodTypeNameTH,
			perstd.enBloodTypeName as bloodTypeNameEN,
		 	perstd.perMaritalStatusId,
			perstd.thMaritalStatusName as maritalStatusNameTH,
			perstd.enMaritalStatusName as maritalStatusNameEN,			
			perstd.email,
			perbnk.bankAcc,
			peradd.noPermanent,
			peradd.villagePermanent,
			peradd.mooPermanent,
			peradd.soiPermanent,
			peradd.roadPermanent,
			peradd.thSubdistrictNamePermanent as subdistrictNameTHPermanent,
			peradd.enSubdistrictNamePermanent as subdistrictNameENPermanent,
			peradd.thDistrictNamePermanent as districtNameTHPermanent,
			peradd.enDistrictNamePermanent as districtNameENPermanent,
			peradd.thPlaceNamePermanent as provinceNameTHPermanent,
			peradd.enPlaceNamePermanent as provinceNameENPermanent,
			peradd.zipCodePermanent,
			peradd.isoCountryCodes2LetterPermanent,
			peradd.phoneNumberPermanent,
			(
				case when (len(isnull(peradd.phoneNumberPermanent, '')) > 0) then 
					case when (left(replace(peradd.phoneNumberPermanent, '-', ''), 2) = '02') then '002' else
						case when (left(replace(peradd.phoneNumberPermanent, '-', ''), 3) = '002') then '002' else left(replace(peradd.phoneNumberPermanent, '-', ''), 3) end
					end
				else 
					null
				end
			) as phoneProvinceCode,
			(
				case when (len(isnull(peradd.phoneNumberPermanent, '')) > 0) then 
					case when (left(replace(peradd.phoneNumberPermanent, '-', ''), 2) = '02') then substring(replace(peradd.phoneNumberPermanent, '-', ''), 3, 10) else
						case when (left(replace(peradd.phoneNumberPermanent, '-', ''), 3) = '002') then substring(replace(peradd.phoneNumberPermanent, '-', ''), 4, 10) else substring(replace(peradd.phoneNumberPermanent, '-', ''), 4, 10) end
					end
				else 
					null
				end
			) as phoneNumber,
			peradd.mobileNumberPermanent,
			(case when (len(isnull(peradd.mobileNumberPermanent, '')) > 0) then left(replace(peradd.mobileNumberPermanent, '-', ''), 3) else null end) as mobileCode,
			(case when (len(isnull(peradd.mobileNumberPermanent, '')) > 0) then substring(replace(peradd.mobileNumberPermanent, '-', ''), 4, 10) else null end) as mobileNumber,
			peradd.noCurrent,
			peradd.villageCurrent,
			peradd.mooCurrent,      
			peradd.soiCurrent,                            
			peradd.roadCurrent,
			peradd.thSubdistrictNameCurrent as subdistrictNameTHCurrent,
			peradd.thDistrictNameCurrent as districtNameTHCurrent,
			peradd.thPlaceNameCurrent as provinceNameTHCurrent,
			peradd.zipCodeCurrent,
			peradd.phoneNumberCurrent,
			peradd.mobileNumberCurrent,
			peredu.*,
			(case when (len(isnull(perstd.studentCode, '')) > 0 and len(isnull(perstd.degree, '')) > 0) then dbo.fnc_perGetBarcode(perstd.studentCode, perstd.degree) else null end) as barcode,
			(substring(convert(varchar, getdate(), 103), 1, 6) + convert(varchar, (year(getdate()) + 543))) as cardIssueDate,
			(case when (yearEntry is not null) then ('31/07/' + convert(varchar, convert(int, yearEntry) + perstd.studyYear)) else null end) as cardExpiryDate,
			udsupl.*,
			plcpvn.plcCountryId as instituteCountryIdTranscript,
			plccon.isoCountryCodes3Letter as instituteCountryCodes3LetterTranscript,
			plccon.countryNameTH as instituteCountryNameTHTranscript,
			plccon.countryNameEN as instituteCountryNameENTranscript,
			perins.plcProvinceId as instituteProvinceIdTranscript,
			plcpvn.provinceNameTH as instituteProvinceNameTHTranscript,
			plcpvn.provinceNameEN as instituteProvinceNameENTranscript,
			udsupl.perInstituteIdTranscript as instituteIdTranscript,
			perins.institutelNameTH as institutelNameTHTranscript,
			perins.institutelNameEN as institutelNameENTranscript
	from	fnc_perGetPersonStudent(@personId) as perstd left join
			fnc_perGetAddress(@personId) as peradd on perstd.id = peradd.id left join
			fnc_perGetEducation(@personId) as peredu ON perstd.id = peredu.id left join
			udsUploadLog as udsupl with (nolock) on perstd.id = udsupl.perPersonId left join
			perInstitute as perins with (nolock) on udsupl.perInstituteIdTranscript = perins.id left join
			plcProvince as plcpvn with (nolock) on perins.plcProvinceId = plcpvn.id left join
			plcCountry as plccon with (nolock) on plcpvn.plcCountryId = plccon.id left join
			fnc_perGetListBankAccount() as perbnk on perbnk.perPersonId = perstd.id
end
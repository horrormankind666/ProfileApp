USE [Infinity]
GO
/****** Object:  UserDefinedFunction [dbo].[fnc_perGetAddress]    Script Date: 5/10/2564 21:56:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๘/๐๖/๒๕๕๘>
-- Description	: <สำหรับแสดงข้อมูลที่อยู่ของบุคคล>
-- Parameter
--  1. personId	เป็น varchar	รับค่ารหัสบุคคล
-- =============================================
ALTER function [dbo].[fnc_perGetAddress]
(	
	@personId varchar(10) = null
)
returns table
as
return
(	
	select	perpes.id,
			perpes.idCard,
			perpes.perTitlePrefixId,
			perpes.thTitleFullName,
			perpes.thTitleInitials,
			perpes.thDescription,
			perpes.enTitleFullName,
			perpes.enTitleInitials,
			perpes.enDescription,				
			perpes.firstName,
			perpes.middleName,
			perpes.lastName,
			perpes.enFirstName,
			perpes.enMiddleName,
			perpes.enLastName,
			'ที่อยู่ตามทะเบียนบ้าน' as thAddressTypePermanent,
			'PermanentAddress' as enAddressTypePermanent,
			(
				(case when (len(ltrim(rtrim(isnull(peradd.villagePermanent, '')))) > 0) then ('หมู่บ้าน' + ltrim(rtrim(isnull(peradd.villagePermanent, ''))) + ' ') else '' end) +
				(case when (len(ltrim(rtrim(isnull(peradd.noPermanent, (case when (peradd.perPersonId is null) then isnull(quoadd.quoAddrNo, '') else '' end))))) > 0) then ('บ้านเลขที่ ' + ltrim(rtrim(isnull(peradd.noPermanent, (case when (peradd.perPersonId is null) then isnull(quoadd.quoAddrNo, '') else '' end)))) + ' ') else '' end) +
				(case when (len(ltrim(rtrim(isnull(peradd.mooPermanent, (case when (peradd.perPersonId is null) then isnull(quoadd.quoAddrMoo, '') else '' end))))) > 0) then ('หมู่ ' + ltrim(rtrim(isnull(peradd.mooPermanent, (case when (peradd.perPersonId is null) then isnull(quoadd.quoAddrMoo, '') else '' end)))) + ' ') else '' end) +
				(case when (len(ltrim(rtrim(isnull(peradd.soiPermanent, (case when (peradd.perPersonId is null) then isnull(quoadd.quoAddrSoi, '') else '' end))))) > 0) then ('ซ.' + ltrim(rtrim(isnull(peradd.soiPermanent, (case when (peradd.perPersonId is null) then isnull(quoadd.quoAddrSoi, '') else '' end)))) + ' ') else '' end) +
				(case when (len(ltrim(rtrim(isnull(peradd.roadPermanent, (case when (peradd.perPersonId is null) then isnull(quoadd.quoAddrStreet, '') else '' end))))) > 0) then ('ถ. ' + ltrim(rtrim(isnull(peradd.roadPermanent, (case when (peradd.perPersonId is null) then isnull(quoadd.quoAddrStreet, '') else '' end)))) + ' ') else '' end) +
				(case when (len(ltrim(rtrim(isnull(plcspm.thSubdistrictName, (case when (peradd.perPersonId is null) then isnull(quoadd.quoAddrSubDistrictTh, '') else '' end))))) > 0) then ('ต.' + ltrim(rtrim(isnull(plcspm.thSubdistrictName, (case when (peradd.perPersonId is null) then isnull(quoadd.quoAddrSubDistrictTh, '') else '' end)))) + ' ') else '' end) +
				(case when (len(ltrim(rtrim(isnull(plcdpm.thDistrictName, (case when (peradd.perPersonId is null) then isnull(quoadd.quoAddrDistrictTh, '') else '' end))))) > 0) then ('อ.' + ltrim(rtrim(isnull(plcdpm.thDistrictName, (case when (peradd.perPersonId is null) then isnull(quoadd.quoAddrDistrictTh, '') else '' end)))) + ' ') else '' end) +
				(case when (len(ltrim(rtrim(isnull(plcppm.provinceNameTH, (case when (peradd.perPersonId is null) then isnull(quoadd.quoAddrProvinceTh, '') else '' end))))) > 0) then ('จ.' + ltrim(rtrim(isnull(plcppm.provinceNameTH, (case when (peradd.perPersonId is null) then isnull(quoadd.quoAddrProvinceTh, '') else '' end)))) + ' ') else '' end) +
				(case when (len(ltrim(rtrim(isnull(peradd.zipCodePermanent, (case when (peradd.perPersonId is null) then isnull(quoadd.quoAddrZipCode, '') else '' end))))) > 0) then ltrim(rtrim(isnull(peradd.zipCodePermanent, (case when (peradd.perPersonId is null) then isnull(quoadd.quoAddrZipCode, '') else '' end)))) else '' end)
			) as addressPermanent,	
			(case when (peradd.perPersonId is null) then quoadd.quoAddrCountryId else peradd.plcCountryIdPermanent end) as plcCountryIdPermanent, 
			(case when (peradd.perPersonId is null) then quoadd.quoAddrCountryTh else plccpm.countryNameTH end) as thCountryNamePermanent,
			(case when (peradd.perPersonId is null) then quoadd.quoAddrCountryEn else plccpm.countryNameEN end) as enCountryNamePermanent,
			(case when (peradd.perPersonId is null) then quoadd.quoAddrCountryISO2 else plccpm.isoCountryCodes2Letter end) as isoCountryCodes2LetterPermanent,
			(case when (peradd.perPersonId is null) then quoadd.quoAddrCountryISO3 else plccpm.isoCountryCodes3Letter end) as isoCountryCodes3LetterPermanent,
			peradd.villagePermanent,
			(case when (peradd.perPersonId is null) then quoadd.quoAddrNo else peradd.noPermanent end) as noPermanent, 
			(case when (peradd.perPersonId is null) then quoadd.quoAddrMoo else peradd.mooPermanent end) as mooPermanent,
			(case when (peradd.perPersonId is null) then quoadd.quoAddrSoi else peradd.soiPermanent end) as soiPermanent,
			(case when (peradd.perPersonId is null) then quoadd.quoAddrStreet else peradd.roadPermanent end) as roadPermanent,
			(case when (peradd.perPersonId is null) then quoadd.quoAddrSubDistrictId else peradd.plcSubdistrictIdPermanent end) as plcSubdistrictIdPermanent,
			(case when (peradd.perPersonId is null) then quoadd.quoAddrSubDistrictTh else plcspm.thSubdistrictName end) as thSubdistrictNamePermanent,
			(case when (peradd.perPersonId is null) then quoadd.quoAddrSubDistrictEn else plcspm.enSubdistrictName end) as enSubdistrictNamePermanent,
			(case when (peradd.perPersonId is null) then quoadd.quoAddrDistrictId else peradd.plcDistrictIdPermanent end) as plcDistrictIdPermanent,
			(case when (peradd.perPersonId is null) then quoadd.quoAddrDistrictTh else plcdpm.thDistrictName end) as thDistrictNamePermanent,
			(case when (peradd.perPersonId is null) then quoadd.quoAddrDistrictEn else plcdpm.enDistrictName end) as enDistrictNamePermanent,
			(case when (peradd.perPersonId is null) then quoadd.quoAddrZipCode else plcdpm.zipCode end) as zipCodeDistrictPermanent,
			(case when (peradd.perPersonId is null) then quoadd.quoAddrProvinceId else peradd.plcProvinceIdPermanent end) as plcProvinceIdPermanent,
			(case when (peradd.perPersonId is null) then quoadd.quoAddrProvinceTh else plcppm.provinceNameTH end) as thPlaceNamePermanent, 
			(case when (peradd.perPersonId is null) then quoadd.quoAddrProvinceEn else plcppm.provinceNameEN end) as enPlaceNamePermanent,
			(case when (peradd.perPersonId is null) then quoadd.quoAddrCountryId else plcppm.plcCountryId end) as plcProvinceCountryIdPermanent,
			(case when (peradd.perPersonId is null) then quoadd.quoAddrZipCode else peradd.zipCodePermanent end) as zipCodePermanent,
			(case when (peradd.perPersonId is null) then quoadd.quoAddrTel else peradd.phoneNumberPermanent end) as phoneNumberPermanent,
			(case when (peradd.perPersonId is null) then quoadd.quoAddrMobile else peradd.mobileNumberPermanent end) as mobileNumberPermanent,
			(case when (peradd.perPersonId is null) then quoadd.quoAddrFax else peradd.faxNumberPermanent end) as faxNumberPermanent,			
			'ที่อยู่ปัจจุบัน' as thAddressTypeCurrent,
			'Present Address' as enAddressTypeCurrent,
			(
				(case when (len(ltrim(rtrim(isnull(peradd.villageCurrent, '')))) > 0) then ('หมู่บ้าน' + ltrim(rtrim(isnull(peradd.villageCurrent, ''))) + ' ') else '' end) +
				(case when (len(ltrim(rtrim(isnull(peradd.noCurrent, (case when (peradd.perPersonId is null) then isnull(quoadd.quoAddrNo, '') else '' end))))) > 0) then ('บ้านเลขที่ ' + ltrim(rtrim(isnull(peradd.noCurrent, (case when (peradd.perPersonId is null) then isnull(quoadd.quoAddrNo, '') else '' end)))) + ' ') else '' end) +
				(case when (len(ltrim(rtrim(isnull(peradd.mooCurrent, (case when (peradd.perPersonId is null) then isnull(quoadd.quoAddrMoo, '') else '' end))))) > 0) then ('หมู่ ' + ltrim(rtrim(isnull(peradd.mooCurrent, (case when (peradd.perPersonId is null) then isnull(quoadd.quoAddrMoo, '') else '' end)))) + ' ') else '' end) +
				(case when (len(ltrim(rtrim(isnull(peradd.soiCurrent, (case when (peradd.perPersonId is null) then isnull(quoadd.quoAddrSoi, '') else '' end))))) > 0) then ('ซ.' + ltrim(rtrim(isnull(peradd.soiCurrent, (case when (peradd.perPersonId is null) then isnull(quoadd.quoAddrSoi, '') else '' end)))) + ' ') else '' end) +
				(case when (len(ltrim(rtrim(isnull(peradd.roadCurrent, (case when (peradd.perPersonId is null) then isnull(quoadd.quoAddrStreet, '') else '' end))))) > 0) then ('ถ. ' + ltrim(rtrim(isnull(peradd.roadCurrent, (case when (peradd.perPersonId is null) then isnull(quoadd.quoAddrStreet, '') else '' end)))) + ' ') else '' end) +
				(case when (len(ltrim(rtrim(isnull(plcscr.thSubdistrictName, (case when (peradd.perPersonId is null) then isnull(quoadd.quoAddrSubDistrictTh, '') else '' end))))) > 0) then ('ต.' + ltrim(rtrim(isnull(plcscr.thSubdistrictName, (case when (peradd.perPersonId is null) then isnull(quoadd.quoAddrSubDistrictTh, '') else '' end)))) + ' ') else '' end) +
				(case when (len(ltrim(rtrim(isnull(plcdcr.thDistrictName, (case when (peradd.perPersonId is null) then isnull(quoadd.quoAddrDistrictTh, '') else '' end))))) > 0) then ('อ.' + ltrim(rtrim(isnull(plcdcr.thDistrictName, (case when (peradd.perPersonId is null) then isnull(quoadd.quoAddrDistrictTh, '') else '' end)))) + ' ') else '' end) +
				(case when (len(ltrim(rtrim(isnull(plcpcr.provinceNameTH, (case when (peradd.perPersonId is null) then isnull(quoadd.quoAddrProvinceTh, '') else '' end))))) > 0) then ('จ.' + ltrim(rtrim(isnull(plcpcr.provinceNameTH, (case when (peradd.perPersonId is null) then isnull(quoadd.quoAddrProvinceTh, '') else '' end)))) + ' ') else '' end) +
				(case when (len(ltrim(rtrim(isnull(peradd.zipCodeCurrent, (case when (peradd.perPersonId is null) then isnull(quoadd.quoAddrZipCode, '') else '' end))))) > 0) then ltrim(rtrim(isnull(peradd.zipCodeCurrent, (case when (peradd.perPersonId is null) then isnull(quoadd.quoAddrZipCode, '') else '' end)))) else '' end)
			) as addressCurrent,		
			(case when (peradd.perPersonId is null) then quoadd.quoAddrCountryId else peradd.plcCountryIdCurrent end) as plcCountryIdCurrent, 
			(case when (peradd.perPersonId is null) then quoadd.quoAddrCountryTh else plcccr.countryNameTH end) as thCountryNameCurrent,
			(case when (peradd.perPersonId is null) then quoadd.quoAddrCountryEn else plcccr.countryNameEN end) as enCountryNameCurrent,
			(case when (peradd.perPersonId is null) then quoadd.quoAddrCountryISO2 else plcccr.isoCountryCodes2Letter end) as isoCountryCodes2LetterCurrent,
			(case when (peradd.perPersonId is null) then quoadd.quoAddrCountryISO3 else plcccr.isoCountryCodes3Letter end) as isoCountryCodes3LetterCurrent,
			peradd.villageCurrent,
			(case when (peradd.perPersonId is null) then quoadd.quoAddrNo else peradd.noCurrent end) as noCurrent, 
			(case when (peradd.perPersonId is null) then quoadd.quoAddrMoo else peradd.mooCurrent end) as mooCurrent,
			(case when (peradd.perPersonId is null) then quoadd.quoAddrSoi else peradd.soiCurrent end) as soiCurrent,
			(case when (peradd.perPersonId is null) then quoadd.quoAddrStreet else peradd.roadCurrent end) as roadCurrent,
			(case when (peradd.perPersonId is null) then quoadd.quoAddrSubDistrictId else peradd.plcSubdistrictIdCurrent end) as plcSubdistrictIdCurrent,
			(case when (peradd.perPersonId is null) then quoadd.quoAddrSubDistrictTh else plcscr.thSubdistrictName end) as thSubdistrictNameCurrent,
			(case when (peradd.perPersonId is null) then quoadd.quoAddrSubDistrictEn else plcscr.enSubdistrictName end) as enSubdistrictNameCurrent,
			(case when (peradd.perPersonId is null) then quoadd.quoAddrDistrictId else peradd.plcDistrictIdCurrent end) as plcDistrictIdCurrent,
			(case when (peradd.perPersonId is null) then quoadd.quoAddrDistrictTh else plcdcr.thDistrictName end) as thDistrictNameCurrent,
			(case when (peradd.perPersonId is null) then quoadd.quoAddrDistrictEn else plcdcr.enDistrictName end) as enDistrictNameCurrent,
			(case when (peradd.perPersonId is null) then quoadd.quoAddrZipCode else plcdcr.zipCode end) as zipCodeDistrictCurrent,
			(case when (peradd.perPersonId is null) then quoadd.quoAddrProvinceId else peradd.plcProvinceIdCurrent end) as plcProvinceIdCurrent,
			(case when (peradd.perPersonId is null) then quoadd.quoAddrProvinceTh else plcpcr.provinceNameTH end) as thPlaceNameCurrent, 
			(case when (peradd.perPersonId is null) then quoadd.quoAddrProvinceEn else plcpcr.provinceNameEN end) as enPlaceNameCurrent,
			(case when (peradd.perPersonId is null) then quoadd.quoAddrCountryId else plcpcr.plcCountryId end) as plcProvinceCountryIdCurrent,
			(case when (peradd.perPersonId is null) then quoadd.quoAddrZipCode else peradd.zipCodeCurrent end) as zipCodeCurrent,
			(case when (peradd.perPersonId is null) then quoadd.quoAddrTel else peradd.phoneNumberCurrent end) as phoneNumberCurrent,
			(case when (peradd.perPersonId is null) then quoadd.quoAddrMobile else peradd.mobileNumberCurrent end) as mobileNumberCurrent,
			(case when (peradd.perPersonId is null) then quoadd.quoAddrFax else peradd.faxNumberCurrent end) as faxNumberCurrent,			
			peradd.createDate,
			peradd.createBy,
			peradd.createIp,
			peradd.modifyDate,
			peradd.modifyBy,
			peradd.modifyIp
	from	fnc_perGetPerson(@personId) as perpes left join
			perAddress as peradd with(nolock) on perpes.id = peradd.perPersonId left join
			(
				select	a.id as perPersonId,
						c.personId as quoPersonId,
						e.*
				from	(
							select	id,
									studentCode,
									idCard,		
									yearEntry,
									admissionId
							from	fnc_perGetPersonStudent(@personId)	
						) as a inner join
						stdAdmission as b with(nolock) on a.admissionId = b.id inner join
						quoPerson as c with(nolock) on (b.idCard = c.idCard) and (b.acaYear = c.acaYear) inner join
						(
							select	distinct
									sadId,
									personId,
									acaYear,
									confirmFlag
							from	quoCandidate
							where	(confirmFlag = 'Y')
						) as d on (b.id = d.sadId) and (c.personId = d.personId) inner join
						vw_refQuoAddress as e with(nolock) on (c.personId = e.quoAddrPersonId) and (c.acaYear = e.quoAddrAcaYear)
				where	(e.quoAddrType = '1')
			) as quoadd on peradd.perPersonId = quoadd.perPersonId left join
			plcCountry as plccpm with(nolock) on peradd.plcCountryIdPermanent = plccpm.id left join
			plcProvince as plcppm with(nolock) on peradd.plcProvinceIdPermanent = plcppm.id left join		
			plcDistrict as plcdpm with(nolock) on peradd.plcDistrictIdPermanent = plcdpm.id left join
			plcSubdistrict as plcspm with(nolock) on peradd.plcSubdistrictIdPermanent = plcspm.id left join			
			plcCountry as plcccr with(nolock) on peradd.plcCountryIdCurrent = plcccr.id left join
			plcProvince as plcpcr with(nolock) on peradd.plcProvinceIdCurrent = plcpcr.id left join
			plcDistrict as plcdcr with(nolock) on peradd.plcDistrictIdCurrent = plcdcr.id left join
			plcSubdistrict as plcscr with(nolock) on peradd.plcSubdistrictIdCurrent = plcscr.id			
)

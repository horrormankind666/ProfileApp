USE [Infinity]
GO
/****** Object:  UserDefinedFunction [dbo].[fnc_perGetEducation]    Script Date: 6/10/2564 18:13:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๘/๐๖/๒๕๕๘>
-- Description	: <สำหรับแสดงข้อมูลการศึกษาของบุคคล>
-- Parameter
--  1. personId	เป็น varchar	รับค่ารหัสบุคคล
-- =============================================
ALTER function [dbo].[fnc_perGetEducation]
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
			peredu.plcCountryIdPrimarySchool,
			plccps.countryNameTH as thPrimarySchoolCountryName,
			plccps.countryNameEN as enPrimarySchoolCountryName,
			plccps.isoCountryCodes2Letter as isoPrimarySchoolCountryCodes2Letter, 
			plccps.isoCountryCodes3Letter as isoPrimarySchoolCountryCodes3Letter,
			peredu.plcProvinceIdPrimarySchool,
			plcpps.provinceNameTH as thPrimarySchoolPlaceName,
			plcpps.provinceNameEN as enPrimarySchoolPlaceName, 
			peredu.primarySchoolName,
			peredu.primarySchoolYearAttended,
			peredu.primarySchoolYearGraduate,
			peredu.primarySchoolGPA, 
			peredu.plcCountryIdJuniorHighSchool,
			plccjs.countryNameTH as thJuniorHighSchoolCountryName,
			plccjs.countryNameEN as enJuniorHighSchoolCountryName, 
			plccjs.isoCountryCodes2Letter as isoJuniorHighSchoolCountryCodes2Letter,
			plccjs.isoCountryCodes3Letter as isoJuniorHighSchoolCountryCodes3Letter,
			peredu.plcProvinceIdJuniorHighSchool, 
			plcpjs.provinceNameTH as thJuniorHighSchoolPlaceName,
			plcpjs.provinceNameEN as enJuniorHighSchoolPlaceName,
			peredu.juniorHighSchoolName, 
			peredu.juniorHighSchoolYearAttended,
			peredu.juniorHighSchoolYearGraduate,
			peredu.juniorHighSchoolGPA,
			isnull(peredu.plcCountryIdHighSchool, quoedu.m6CountryId) as plcCountryIdHighSchool, 
			isnull(plcchs.countryNameTH, quoedu.countryNameTH) as thHighSchoolCountryName,
			isnull(plcchs.countryNameEN, quoedu.countryNameEN) as enHighSchoolCountryName,
			isnull(plcchs.isoCountryCodes2Letter, quoedu.isoCountryCodes2Letter) as isoHighSchoolCountryCodes2Letter, 
			isnull(plcchs.isoCountryCodes3Letter, quoedu.isoCountryCodes3Letter) as isoHighSchoolCountryCodes3Letter,
			isnull(peredu.plcProvinceIdHighSchool, quoedu.m6ProvinceId) as plcProvinceIdHighSchool,
			isnull(plcphs.provinceNameTH, quoedu.provinceNameTH) as thHighSchoolPlaceName, 
			isnull(plcphs.provinceNameEN, quoedu.provinceNameEN) as enHighSchoolPlaceName,
			isnull(peredu.highSchoolName, isnull(quoedu.institutelNameTH, quoedu.institutelNameEN)) as highSchoolName,
			peredu.highSchoolStudentId,
			isnull(peredu.perEducationalMajorIdHighSchool, quoedu.eduProgram) as perEducationalMajorIdHighSchool,
			isnull(permhs.thEducationalMajorName, quoedu.thEducationalMajorName) as thHighSchoolEducationalMajorName,
			isnull(permhs.enEducationalMajorName, quoedu.enEducationalMajorName) as enHighSchoolEducationalMajorName,
			isnull(peredu.educationalMajorOtherHighSchool, quoedu.eduProgramOther) as educationalMajorOtherHighSchool, 
			peredu.highSchoolYearAttended,
			peredu.highSchoolYearGraduate,
			isnull(peredu.highSchoolGPA, quoedu.gpax) as highSchoolGPA,
			isnull(peredu.perEducationalBackgroundIdHighSchool, quoedu.eduBackground) as perEducationalBackgroundIdHighSchool,
			isnull(perbhs.thEducationalBackgroundName, quoedu.thEducationalBackgroundName) as thHighSchoolEducationalBackgroundName,
			isnull(perbhs.enEducationalBackgroundName, quoedu.enEducationalBackgroundName) as enHighSchoolEducationalBackgroundName,
			perlhs.thEducationalLevelName as thHighSchoolEducationalLevelName,
			perlhs.enEducationalLevelName as enHighSchoolEducationalLevelName,
			peredu.perEducationalBackgroundId, 
			perebk.thEducationalBackgroundName,
			perebk.enEducationalBackgroundName,          
			perelv.thEducationalLevelName,
			perelv.enEducationalLevelName,
			peredu.graduateBy,
			(
				case peredu.graduateBy
					when '01' then 'สอบปกติ'
					when '02' then 'สอบเทียบ'
					else null
				end
			) as thGraduateBy,
			(
				case peredu.graduateBy
					when '01' then 'High School Education'
					when '02' then 'Non-Formal And Informal Education'
					else null
				end
			) as enGraduateBy,						
			peredu.graduateBySchoolName,
			peredu.entranceTime,
			(
				case peredu.entranceTime
					when '1' then 'ครั้งแรก'
					when '2' then 'ครั้งที่ 2'
					when '3' then 'ครั้งที่ 3'
					when '4' then 'มากกว่า 3 ครั้ง'
					else null
				end
			) as thEntranceTime,
			(
				case peredu.entranceTime
					when '1' then 'First Time'
					when '2' then '2 Times'
					when '3' then '3 Times'
					when '4' then 'More Than 3 Times'
					else null
				end					
			) as enEntranceTime,			
			peredu.studentIs,
			(
				case peredu.studentIs
					when '01' then 'เข้าเป็นนักศึกษามหาวิทยาลัยมหิดลครั้งแรก'
					when '02' then 'เคยเป็นนักศึกษา'
					else null
				end								
			) as thStudentIs,
			(
				case peredu.studentIs
					when '01' then 'First Time To Be A Student In Mahidol University'
					when '02' then 'Was A Student'
					else null
				end
			) as enStudentIs,	
			peredu.studentIsUniversity, 
			peredu.studentIsFaculty,
			peredu.studentIsProgram,
			perstd.perEntranceTypeId as perEntranceTypeId,
			perstd.stdEntranceTypeNameTH as entranceTypeNameTH, 
			perstd.stdEntranceTypeNameEN as entranceTypeNameEN,
			peredu.admissionRanking,
			isnull(peredu.scoreONET01, quoscr.scoreONET1) as scoreONET01,
			('O-NET ภาษาไทย') as thScoreONET01Name,
			('O-NET Thai') as enScoreONET01Name,
			isnull(peredu.scoreONET02, quoscr.scoreONET2) as scoreONET02,
			('O-NET สังคมศึกษา') as thScoreONET02Name,
			('O-NET Social Science') as enScoreONET02Name,
			isnull(peredu.scoreONET03, quoscr.scoreONET3) as scoreONET03, 
			('O-NET ภาษาอังกฤษ') as thScoreONET03Name,
			('O-NET English') as enScoreONET03Name,			
			isnull(peredu.scoreONET04, quoscr.scoreONET4) as scoreONET04,
			('O-NET คณิตศาสตร์') as thScoreONET04Name,
			('O-NET Mathematics') as enScoreONET04Name,			
			isnull(peredu.scoreONET05, quoscr.scoreONET5) as scoreONET05,
			('O-NET วิทยาศาสตร์') as thScoreONET05Name,
			('O-NET Science') as enScoreONET05Name,			
			peredu.scoreONET06,
			('O-NET สุขศึกษาและพลศึกษา') as thScoreONET06Name,
			('O-NET Health Education & Physical Education') as enScoreONET06Name,				
			peredu.scoreONET07,
			('O-NET ศิลปะ') as thScoreONET07Name,
			('O-NET Arts') as enScoreONET07Name,			
			peredu.scoreONET08, 
			('O-NET การงานอาชีพและเทคโนโลยี') as thScoreONET08Name,
			('O-NET Occupation & Teachnology') as enScoreONET08Name,			
			peredu.scoreANET11,
			('A-NET ภาษาไทย 2') as thScoreANET11Name,
			('A-NET Thai 2') as enScoreANET11Name,			
			peredu.scoreANET12,
			('A-NET สังคมศึกษา 2') as thScoreANET12Name,
			('A-NET Social Science 2') as enScoreANET12Name,			
			peredu.scoreANET13,
			('A-NET ภาษาอังกฤษ 3') as thScoreANET13Name,
			('A-NET English 3') as enScoreANET13Name,			
			peredu.scoreANET14,
			('A-NET คณิตศาสตร์ 2') as thScoreANET14Name,
			('A-NET Mathematics 2') as enScoreANET14Name,			
			peredu.scoreANET15, 
			('A-NET วิทยาศาสตร์ 2') as thScoreANET15Name,
			('A-NET Science 2') as enScoreANET15Name,			
			isnull(peredu.scoreGAT85, quoscr.scoreGAT) as scoreGAT85,
			('GAT ความถนัดทั่วไป') as thScoreGAT85Name,
			('GAT Genaral Aptitude Test') as enScoreGAT85Name,
			isnull(peredu.scorePAT71, quoscr.scorePAT1) as scorePAT71,
			('PAT 1 ความถนัดคณิตศาสตร์') as thScorePAT71Name,
			('PAT 1 Aptitude In Mathematics') as enScorePAT71Name,			
			isnull(peredu.scorePAT72, quoscr.scorePAT2) as scorePAT72,
			('PAT 2 ความถนัดวิทยาศาสตร์') as thScorePAT72Name,
			('PAT 2 Aptitude In Science') as enScorePAT72Name,			
			isnull(peredu.scorePAT73, quoscr.scorePAT3) as scorePAT73,
			('PAT 3 ความถนัดวิศวกรรมศาสตร์') as thScorePAT73Name,
			('PAT 3 Aptitude In Engineering') as enScorePAT73Name,			
			isnull(peredu.scorePAT74, quoscr.scorePAT4) as scorePAT74,
			('PAT 4 ความถนัดสถาปัตยกรรมศาสตร์') as thScorePAT74Name,
			('PAT 4 Aptitude In Architecture') as enScorePAT74Name,			
			isnull(peredu.scorePAT75, quoscr.scorePAT5) as scorePAT75,
			('PAT 5 ความถนัดวิชาชีพครู') as thScorePAT75Name,
			('PAT 5 Aptitude In Teaching') as enScorePAT75Name,				
			isnull(peredu.scorePAT76, quoscr.scorePAT6) as scorePAT76,
			('PAT 6 ความถนัดศิลปกรรมศาสตร์') as thScorePAT76Name,
			('PAT 6 Aptitude In Arts') as enScorePAT76Name,			
			peredu.scorePAT77,
			('PAT 7.1 ภาษาฝรั่งเศส') as thScorePAT77Name,
			('PAT 7.1 French Languages') as enScorePAT77Name,			
			peredu.scorePAT78,
			('PAT 7.2 ภาษาเยอรมัน') as thScorePAT78Name,
			('PAT 7.2 Germany Languages') as enScorePAT78Name,				
			peredu.scorePAT79,
			('PAT 7.3 ภาษาญี่ปุ่น') as thScorePAT79Name,
			('PAT 7.3 Japanese Languages') as enScorePAT79Name,			
			peredu.scorePAT80,
			('PAT 7.4 ภาษาจีน') as thScorePAT80Name,
			('PAT 7.4 Chinese Languages') as enScorePAT80Name,			
			peredu.scorePAT81,
			('PAT 7.5 ภาษาอาหรับ') as thScorePAT81Name,
			('PAT 7.5 Arabic Languages') as enScorePAT81Name,			 
			peredu.scorePAT82,
			('PAT 7.6 ภาษาบาลี') as thScorePAT82Name,
			('PAT 7.6 Bali Languages') as enScorePAT82Name,			
			peredu.createBy,
			peredu.createDate,
			peredu.createIp,
			peredu.modifyDate,
			peredu.modifyBy, 
			peredu.modifyIp
	from	fnc_perGetPerson(@personId) as perpes left join
			fnc_perGetPersonStudent(@personId) as perstd on perpes.id = perstd.id left join
			perEducation as peredu with(nolock) on perpes.id = peredu.perPersonId left join
			(
				select	a.id as perPersonId,
						c.personId as quoPersonId,
						b.acaYear,
						(case when (e.scoreOnetThai <> 0.00) then convert(varchar(10), e.scoreOnetThai) else null end) as scoreONET1, --scoreONET01 ภาษาไทย
						(case when (e.scoreOnetSocial <> 0.00) then convert(varchar(10), e.scoreOnetSocial) else null end) as scoreONET2, --scoreONET02 สังคมศึกษา ศาสนา และวัฒนธรรม
						(case when (e.scoreOnetEnglish <> 0.00) then convert(varchar(10), e.scoreOnetEnglish) else null end) as scoreONET3, --scoreONET03 ภาษาอังกฤษ
						(case when (e.scoreOnetMath <> 0.00) then convert(varchar(10), e.scoreOnetMath) else null end) as scoreONET4, --scoreONET04 คณิตศาสตร์
						(case when (e.scoreOnetScience <> 0.00) then convert(varchar(10), e.scoreOnetScience) else null end) as scoreONET5, --scoreONET05 วิทยาศาสตร์
						(case when (e.scoreGAT <> 0.00) then convert(varchar(10), e.scoreGAT) else null end) as scoreGAT,
						(case when (e.scorePatMath <> 0.00) then convert(varchar(10), e.scorePatMath) else null end) as scorePAT1, --scorePAT71 ความถนัดคณิตศาสตร์
						(case when (e.scorePatScience <> 0.00) then convert(varchar(10), e.scorePatScience) else null end) as scorePAT2, --scorePAT72 ความถนัดวิทยาศาสตร์
						(case when (e.scorePatEngineer <> 0.00) then convert(varchar(10), e.scorePatEngineer) else null end) as scorePAT3, --scorePAT73 ความถนัดวิศวกรรมศาสตร์
						(case when (e.scorePatArchitecture <> 0.00) then convert(varchar(10), e.scorePatArchitecture) else null end) as scorePAT4, --scorePAT74 ความถนัดสถาปัตยกรรมศาสตร์,
						(case when (e.scorePatEducation <> 0.00) then convert(varchar(10), e.scorePatEducation) else null end) as scorePAT5, --scorePAT75 ความถนัดวิชาชีพครู
						(case when (e.scorePatArts <> 0.00) then convert(varchar(10), e.scorePatArts) else null end) as scorePAT6  --scorePAT76 ความถนัดศิลปกรรมศาสตร์
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
							where	(approveStatus = 'Y') and
									(transferStatus = 'Y') and
									(confirmFlag = 'Y')
						) as d on (b.id = d.sadId) and (c.personId = d.personId) inner join
						(
							select	applicationId,
									personId,
									acaYear,
									scoreMA as scoreMath,
									scoreM2 as scoreMath2,
									scorePY as scorePhysics,
									scoreCH as scoreChemistry,
									scoreBI as scoreBiology,
									scoreSC as scoreScience, 
									scoreEN as scoreEnglish,
									scoreTH as scoreThai,
									scoreSO as scoreSocial,
									scoreGAT,
									scorePAT1 as scorePatMath,
									scorePAT2 as scorePatScience,
									scorePAT3 as scorePatEngineer, 
									scorePAT4 as scorePatArchitecture,
									scorePAT5 as scorePatEducation,
									scorePAT6 as scorePatArts,
									scorePAT7 as scorePatLanguage,
									scoreONET1 as scoreOnetThai,
									scoreONET2 as scoreOnetSocial, 
									scoreONET3 as scoreOnetEnglish,
									scoreONET4 as scoreOnetMath,
									scoreONET5 as scoreOnetScience
							from    quoCandidate
							where	(approveStatus = 'Y') and
									(transferStatus = 'Y') and
									(confirmFlag = 'Y')
						) as e on (d.personId = e.personId) and (d.acaYear = e.acaYear)
			) as quoscr on	peredu.perPersonId = quoscr.perPersonId left join
			(
				select	a.personId,
						a.acaYear,
						a.m6SchoolId,
						b.institutelNameTH,
						b.institutelNameEN,
						a.m6CountryId,
						c.countryNameTH,
						c.countryNameEN,
						c.isoCountryCodes2Letter,
						c.isoCountryCodes3Letter,
						a.m6ProvinceId,
						d.provinceNameTH,
						d.provinceNameEN,
						a.eduProgram,
						e.thEducationalMajorName,
						e.enEducationalMajorName,
						a.eduProgramOther,
						a.gpax,
						a.eduBackground,
						f.thEducationalBackgroundName,
						f.enEducationalBackgroundName
				from	quoEducation as a with(nolock) left join
						perInstitute as b with(nolock) on a.m6SchoolId = b.schoolId left join
						plcCountry as c with(nolock) on a.m6CountryId = c.id left join
						plcProvince as d with(nolock) on a.m6ProvinceId = d.id and c.id = d.plcCountryId left join
						perEducationalMajor as e with(nolock) on a.eduProgram = e.id left join
						perEducationalBackground as f with(nolock) on a.eduBackground = f.id
			) as quoedu on (quoscr.quoPersonId = quoedu.personId) and (quoscr.acaYear = quoedu.acaYear) left join
			plcCountry as plccps with(nolock) on peredu.plcCountryIdPrimarySchool = plccps.id left join
			plcProvince as plcpps with(nolock) on peredu.plcProvinceIdPrimarySchool = plcpps.id and plccps.id = plcpps.plcCountryId left join
			plcCountry as plccjs with(nolock) on peredu.plcCountryIdJuniorHighSchool = plccjs.id left join
			plcProvince as plcpjs with(nolock) on peredu.plcProvinceIdJuniorHighSchool = plcpjs.id and plccjs.id = plcpjs.plcCountryId left join
			plcCountry as plcchs with(nolock) on peredu.plcCountryIdHighSchool = plcchs.id left join
			plcProvince as plcphs with(nolock) on peredu.plcProvinceIdHighSchool = plcphs.id and plcchs.id = plcphs.plcCountryId left join
			perEducationalMajor as permhs with(nolock) on peredu.perEducationalMajorIdHighSchool = permhs.id left join
			perEducationalBackground as perbhs with(nolock) on peredu.perEducationalBackgroundIdHighSchool = perbhs.id left join
			perEducationalLevel as perlhs with(nolock) on perbhs.perEducationalLevelId = perlhs.id left join
			perEducationalBackground as perebk with(nolock) on peredu.perEducationalBackgroundId = perebk.id left join
			perEducationalLevel as perelv with(nolock) on perebk.perEducationalLevelId = perelv.id left join
			perEntranceType as perent with(nolock) on peredu.perEntranceTypeId = perent.id
)

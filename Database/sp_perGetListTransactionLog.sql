USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_perGetListTransactionLog]    Script Date: 13/5/2564 9:53:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๐๗/๑๐/๒๕๕๙>
-- Description	: <สำหรับเรียกดูข้อมูลของนักศึกษาตามสิทธิ์ผู้ใช้งาน>
-- Parameter
--	1. username		เป็น varchar	รับค่าชื่อผู้ใช้งาน
--	2. userlevel	เป็น varchar	รับค่าระดับผู้ใช้งาน
--	3. systemGroup	เป็น varchar	รับค่าชื่อระบบงาน
--	4. reportName	เป็น varchar	รับค่าชื่อรายงาน
--  5. personId		เป็น varchar	รับค่ารหัสบุคคล
-- =============================================
ALTER procedure [dbo].[sp_perGetListTransactionLog]
(
	@username varchar(255) = null,
	@userlevel varchar(20) = null,
	@systemGroup varchar(50) = null,
	@reportName varchar(100) = null,
	@personId varchar(10) = null
)
as
begin
	set concat_null_yields_null off
	
	set @username = ltrim(rtrim(isnull(@username, '')))
	set @userlevel = ltrim(rtrim(isnull(@userlevel, '')))
	set @systemGroup = ltrim(rtrim(isnull(@systemGroup, '')))
	set @reportName = ltrim(rtrim(isnull(@reportName, '')))
	set @personId = ltrim(rtrim(isnull(@personId, '')))
	
	declare	@userFaculty varchar(15) = null
	declare @userProgram varchar(15) = null
	
	select	@userFaculty = autusr.facultyId,
			@userProgram = autusr.programId
	from	autUserAccessProgram as autusr with (nolock)
	where	(autusr.username = @username) and
			(autusr.level = @userlevel) and
			(autusr.systemGroup = @systemGroup)
	
	set @userFaculty = isnull(@userFaculty, '')
	set @userProgram = isnull(@userProgram, '')			

	select	perpes.id as perPersonId,
			stdstd.studentCode
	into	#perTemp
	from	stdStudent as stdstd with(nolock) inner join
			perPerson as perpes with(nolock) on stdstd.personId = perpes.id
	where	(@userFaculty = 'MU-01' or stdstd.facultyId = @userFaculty) and
			(len(isnull(@userProgram, '')) = 0 or stdstd.programId = @userProgram) and
			(perpes.id = @personId)

	if (@reportName = 'StudentRecords')
	begin
		select	 stdstd.id,
				 pertmp.perPersonId,
				 pertmp.studentCode,
				 stdstd.tempCode,
				 acafac.facultyCode,
				 acaprg.programCode,
				 acaprg.majorCode,
				 acaprg.groupNum,
				 stdstd.programYear,
				 stdstd.yearEntry,
				 stdstd.acaYear,
				 stdstd.courseYear,
				 stdstd.class,
				 stdstd.degree,
				 stddgl.thDegreeLevelName as degreeLevelNameTH,
				 stddgl.enDegreeLevelName as degreeLevelNameEN,
				 stdstd.admissionType as perEntranceTypeId,
				 perent.entranceTypeNameTH,
				 perent.entranceTypeNameEN,
				 stdstd.status,
				 stdstt.nameTh as statusTypeNameTH,
				 stdstt.nameEn as statusTypeNameEN,
				 stdstd.admissionDate,
				 stdstd.graduateDate,
				 stdstd.graduateYear,
				 (
					case stdstd.distinction
						when 1 then 'Y'
						else 'N'
					end
				 ) as distinctionStatus,
				 stdstd.mspJoin,
				 stdstd.mspStartSemester,
				 stdstd.mspStartYear,
				 stdstd.mspEndSemester,
				 stdstd.mspEndYear,
				 stdstd.mspResignDate,
				 stdstd.regisExtra,
				 stdstd.pictureName,
				 stdstd.updateGradDate,
				 stdstd.updateGradBy,
				 stdstd.createdDate as createDate,
				 stdstd.createdBy as createBy,
				 stdstd.updateWhat,
				 (
					case stdstd.updateWhat
						when 'UpdateFacultyProgram' then 'ปรับปรุงคณะและหลักสูตรของนักศึกษา'
						when 'UpdateClassYear'		then 'ปรับปรุงชั้นปีของนักศึกษา'
						when 'UpdateEntranceType'	then 'ปรับปรุงระบบการสอบเข้าของนักศึกษา'
						when 'UpdateStudentStatus'	then 'ปรับปรุงสถานภาพการเป็นนักศึกษาของนักศึกษา'
						when 'UpdateAdmissionDate'	then 'ปรับปรุงวันที่เข้าศึกษาของนักศึกษา'
						when 'UpdateStudentMedicalScholarsProgram' then 'เตรียมข้อมูลโครงการผลิดอาจารย์แพทย์'
						else null
					end
				 ) as updateWhatTH,
				 (
					case stdstd.updateWhat
						when 'UpdateFacultyProgram' then 'Update Faculty and Program of Student'
						when 'UpdateClassYear'		then 'Update Class Year of Student'
						when 'UpdateEntranceType'	then 'Update Admission Type of Student'
						when 'UpdateStudentStatus'	then 'Update Student Status of Student'
						when 'UpdateAdmissionDate'	then 'Update Admission Date of Student'
						when 'UpdateStudentMedicalScholarsProgram' then 'Set Student Medical Scholars Program'
						else null
					end
				 ) as updateWhatEN,
				 stdstd.updateReason,
				 stdstd.modifyDate,
				 stdstd.modifyBy
		from	 #perTemp as pertmp inner join
				 InfinityLog..stdStudentLog as stdstd with (nolock) on pertmp.perPersonId = stdstd.personId left join
				 acaFaculty as acafac with (nolock) on stdstd.facultyId = acafac.id left join
				 acaProgram as acaprg with (nolock) on stdstd.facultyId = acaprg.facultyId and stdstd.programId = acaprg.id left join
				 acaMajor as acamaj with (nolock) on acaprg.majorId = acamaj.id left join
				 stdDegreeLevel as stddgl with (nolock) on stdstd.degree = stddgl.id left join
				 perEntranceType as perent with (nolock) on stdstd.admissionType = perent.id left join
				 stdStatusType as stdstt with (nolock) on stdstd.status = stdstt.id
		order by stdstd.id desc
	end

	if (@reportName = 'PersonRecordsPersonal')
	begin
		select	 perpes.id,
				 pertmp.perPersonId,
				 pertmp.studentCode,
				 perpes.idCard,
				 perpes.perTitlePrefixId,
				 pertip.thTitleFullName as titlePrefixFullNameTH,
				 pertip.thTitleInitials as titlePrefixInitialsTH,
				 pertip.enTitleFullName as titlePrefixFullNameEN,
				 pertip.enTitleInitials as titlePrefixInitialsEN,
				 perpes.firstName,
				 perpes.middleName,
				 perpes.lastName,
				 perpes.enFirstName as firstNameEN,
				 perpes.enMiddleName as middleNameEN,
				 perpes.enLastName as lastNameEN,
				 perpes.perGenderId,
				 pergps.thGenderFullName as genderFullNameTH,
				 pergps.thGenderInitials as genderInitialsTH,
				 pergps.enGenderFullName as genderFullNameEN,
				 pergps.enGenderInitials as genderInitialsEN,
				 perpes.alive,
				 (
					case perpes.alive
						when 'Y' then 'มีชีวิตอยู่'
						when 'N' then 'ถึงแก่กรรม'
						else null
					end				
				 ) as aliveTH,
				 (
					case perpes.alive
						when 'Y' then 'Alive'
						when 'N' then 'Deceased'
						else null
					end				
				 ) as aliveEN,
				 perpes.birthDate,
				 perpes.plcCountryId,
				 plccou.countryNameTH,
				 plccou.countryNameEN,
				 perpes.perNationalityId,
				 pernat.thNationalityName as nationalityNameTH,
				 pernat.enNationalityName as nationalityNameEN,
				 perpes.perOriginId,
				 perorg.thNationalityName as originNameTH,
				 perorg.enNationalityName as originNameEN,
				 perpes.perReligionId,
				 perrlg.thReligionName as religionNameTH,
				 perrlg.enReligionName as religionNameEN,
				 perpes.perBloodTypeId,
				 perbdt.thBloodTypeName as bloodTypeNameTH,
				 perbdt.enBloodTypeName as bloodTypeNameEN,
				 perpes.perMaritalStatusId,
				 permas.thMaritalStatusName as maritalStatusNameTH,
				 permas.enMaritalStatusName as maritalStatusNameEN,
				 perpes.perEducationalBackgroundId,
				 perebk.thEducationalBackgroundName as educationalBackgroundNameTH,
				 perebk.enEducationalBackgroundName as educationalBackgroundNameEN,
				 perpes.email,
				 perpes.brotherhoodNumber, 
				 perpes.childhoodNumber,
				 perpes.studyhoodNumber,
				 perpes.createDate,
				 perpes.createBy,
				 perpes.modifyDate,
				 perpes.modifyBy
		from	 #perTemp as pertmp inner join
				 InfinityLog..perPersonLog as perpes with (nolock) on pertmp.perPersonId = perpes.perPersonId left join
				 perTitlePrefix as pertip with (nolock) on perpes.perTitlePrefixId = pertip.id left join
				 perGender as pergtp with (nolock) on pertip.perGenderId = pergtp.id left join
				 perGender as pergps with (nolock) on perpes.perGenderId = pergps.id left join
				 plcCountry as plccou with (nolock) on perpes.plcCountryId = plccou.id left join
				 perNationality as pernat with (nolock) on perpes.perNationalityId = pernat.id left join
				 perNationality as perorg with (nolock)  on perpes.perOriginId = perorg.id left join
				 perReligion as perrlg with (nolock) on perpes.perReligionId = perrlg.id left join
				 perBloodType as perbdt with (nolock) on perpes.perBloodTypeId = perbdt.id left join
				 perMaritalStatus as permas with (nolock) on perpes.perMaritalStatusId = permas.id left join
				 perEducationalBackground as perebk with (nolock) on perpes.perEducationalBackgroundId = perebk.id
		order by perpes.id desc
	end

	if (@reportName = 'PersonRecordsAddress')
	begin
		select	 peradd.id,
				 pertmp.perPersonId,
				 pertmp.studentCode,
				 'ที่อยู่ตามทะเบียนบ้าน' as addressTypeTHPermanent,
				 'PermanentAddress' as addressTypeENPermanent,
				 peradd.plcCountryIdPermanent, 
				 plccpm.countryNameTH as countryNameTHPermanent,
				 plccpm.countryNameEN as countryNameENPermanent,
				 peradd.villagePermanent,
				 peradd.noPermanent, 
				 peradd.mooPermanent,
				 peradd.soiPermanent,
				 peradd.roadPermanent,
				 peradd.plcSubdistrictIdPermanent,
				 plcspm.thSubdistrictName as subdistrictNameTHPermanent,
				 plcspm.enSubdistrictName as subdistrictNameENPermanent,
				 peradd.plcDistrictIdPermanent,
				 plcdpm.thDistrictName as districtNameTHPermanent,
				 plcdpm.enDistrictName as districtNameENPermanent,
				 peradd.plcProvinceIdPermanent,
				 plcppm.provinceNameTH as provinceNameTHPermanent, 
				 plcppm.provinceNameEN as provinceNameENPermanent,
				 peradd.zipCodePermanent,
				 peradd.phoneNumberPermanent,
				 peradd.mobileNumberPermanent,
				 peradd.faxNumberPermanent,
				 'ที่อยู่ปัจจุบัน' as addressTypeTHCurrent,
				 'Present Address' as addressTypeENCurrent,
				 peradd.plcCountryIdCurrent, 
				 plcccr.countryNameTH as countryNameTHCurrent,
				 plcccr.countryNameEN as countryNameENCurrent,
				 peradd.villageCurrent,
				 peradd.noCurrent, 
				 peradd.mooCurrent,
				 peradd.soiCurrent,
				 peradd.roadCurrent,
				 peradd.plcSubdistrictIdCurrent,
				 plcscr.thSubdistrictName as subdistrictNameTHCurrent,
				 plcscr.enSubdistrictName as subdistrictNameENCurrent,
				 peradd.plcDistrictIdCurrent,
				 plcdcr.thDistrictName as districtNameTHCurrent,
				 plcdcr.enDistrictName as districtNameENCurrent,
				 peradd.plcProvinceIdCurrent,
				 plcpcr.provinceNameTH as provinceNameTHCurrent, 
				 plcpcr.provinceNameEN as provinceNameENCurrent,
				 peradd.zipCodeCurrent,
				 peradd.phoneNumberCurrent,
				 peradd.mobileNumberCurrent,
				 peradd.faxNumberCurrent,
				 peradd.createDate,
				 peradd.createBy,
				 peradd.modifyDate,
				 peradd.modifyBy
		from	 #perTemp as pertmp inner join
				 InfinityLog..perAddressLog as peradd with (nolock) on pertmp.perPersonId = peradd.perPersonId left join
				 plcCountry as plccpm with (nolock) on peradd.plcCountryIdPermanent = plccpm.id left join
				 plcProvince as plcppm with (nolock) on peradd.plcProvinceIdPermanent = plcppm.id left join
				 plcDistrict as plcdpm with (nolock) on peradd.plcDistrictIdPermanent = plcdpm.id left join
				 plcSubdistrict as plcspm with (nolock) on peradd.plcSubdistrictIdPermanent = plcspm.id left join
				 plcCountry as plcccr with (nolock) on peradd.plcCountryIdCurrent = plcccr.id left join
				 plcProvince as plcpcr with (nolock) on peradd.plcProvinceIdCurrent = plcpcr.id left join
				 plcDistrict as plcdcr with (nolock) on peradd.plcDistrictIdCurrent = plcdcr.id left join
				 plcSubdistrict as plcscr with (nolock) on peradd.plcSubdistrictIdCurrent = plcscr.id
		order by peradd.id desc
	end

	if (@reportName = 'PersonRecordsEducation')
	begin
		select	 peredu.id,
				 pertmp.perPersonId,
				 pertmp.studentCode,
				 peredu.primarySchoolName as instituteNamePrimarySchool,
				 peredu.plcCountryIdPrimarySchool,				 
				 plccps.countryNameTH as countryNameTHPrimarySchool,
				 plccps.countryNameEN as countryNameENPrimarySchool,
				 peredu.plcProvinceIdPrimarySchool,
				 plcpps.provinceNameTH as provinceNameTHPrimarySchool,
				 plcpps.provinceNameEN as provinceNameENPrimarySchool, 
				 peredu.primarySchoolYearAttended as yearAttendedPrimarySchool,
				 peredu.primarySchoolYearGraduate as yearGraduatePrimarySchool,
				 peredu.primarySchoolGPA as GPAPrimarySchool, 
				 peredu.juniorHighSchoolName as instituteNameJuniorHighSchool,
				 peredu.plcCountryIdJuniorHighSchool,
				 plccjs.countryNameTH as countryNameTHJuniorHighSchool,
				 plccjs.countryNameEN as countryNameENJuniorHighSchool, 
				 peredu.plcProvinceIdJuniorHighSchool, 
				 plcpjs.provinceNameTH as provinceNameTHJuniorHighSchool,
				 plcpjs.provinceNameEN as provinceNameENJuniorHighSchool,
				 peredu.juniorHighSchoolYearAttended as yearAttendedJuniorHighSchool,
				 peredu.juniorHighSchoolYearGraduate as yearGraduateJuniorHighSchool,
				 peredu.juniorHighSchoolGPA as GPAJuniorHighSchool,
				 peredu.highSchoolName as instituteNameHighSchool,
				 peredu.plcCountryIdHighSchool, 
				 plcchs.countryNameTH as countryNameTHHighSchool,
				 plcchs.countryNameEN as countryNameENHighSchool,
				 peredu.plcProvinceIdHighSchool,
				 plcphs.provinceNameTH as provinceNameTHHighSchool, 
				 plcphs.provinceNameEN as provinceNameENHighSchool,
				 peredu.highSchoolStudentId as studentIdHighSchool,
				 peredu.perEducationalMajorIdHighSchool, 
				 permhs.thEducationalMajorName as educationalMajorNameTHHighSchool,
				 permhs.enEducationalMajorName as educationalMajorNameENHighSchool,
				 peredu.educationalMajorOtherHighSchool, 
				 peredu.highSchoolYearAttended as yearAttendedHighSchool,
				 peredu.highSchoolYearGraduate as yearGraduateHighSchool,
				 peredu.highSchoolGPA as GPAHighSchool,
				 peredu.perEducationalBackgroundIdHighSchool,
				 perbhs.thEducationalBackgroundName as educationalBackgroundNameTHHighSchool,
				 perbhs.enEducationalBackgroundName as educationalBackgroundNameENHighSchool,
				 peredu.perEducationalBackgroundId, 
				 perebk.thEducationalBackgroundName as educationalBackgroundNameTH,
				 perebk.enEducationalBackgroundName as educationalBackgroundNameEN,
				 peredu.graduateBy,
				 (
					case peredu.graduateBy
						when '01' then 'สอบปกติ'
						when '02' then 'สอบเทียบ'
						else null
					end
				 ) as graduateByTH,
				 (
					case peredu.graduateBy
						when '01' then 'High School Education'
						when '02' then 'Non-Formal And Informal Education'
						else null
					end				
				 ) as graduateByEN,
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
				 ) as entranceTimeTH,
				 (
					case peredu.entranceTime
						when '1' then 'First Time'
						when '2' then '2 Times'
						when '3' then '3 Times'
						when '4' then 'More Than 3 Times'
						else null
					end
				 ) as entranceTimeEN,
				 peredu.studentIs,
				 (
					case peredu.studentIs
						when '01' then 'เข้าเป็นนักศึกษามหาวิทยาลัยมหิดลครั้งแรก'
						when '02' then 'เคยเป็นนักศึกษา'
						else null
					end								
				 ) as studentIsTH,
				 (
					case peredu.studentIs
						when '01' then 'First Time To Be A Student In Mahidol University'
						when '02' then 'Was A Student'
						else null
					end				
				 ) as studentIsEN,
				 peredu.studentIsUniversity, 
				 peredu.studentIsFaculty,
				 peredu.studentIsProgram,
				 peredu.perEntranceTypeId,
				 perent.entranceTypeNameTH,
				 perent.entranceTypeNameEN,
				 peredu.admissionRanking,
				 peredu.scoreONET01,
				 ('O-NET ภาษาไทย') as scoreONET01NameTH,
				 ('O-NET Thai') as scoreONET01NameEN,
				 peredu.scoreONET02,
				 ('O-NET สังคมศึกษา') as scoreONET02NameTH,
				 ('O-NET Social Science') as scoreONET02NameEN,
				 peredu.scoreONET03,
				 ('O-NET ภาษาอังกฤษ') as scoreONET03NameTH,
				 ('O-NET English') as scoreONET03NameEN,
				 peredu.scoreONET04,
				 ('O-NET คณิตศาสตร์') as scoreONET04NameTH,
				 ('O-NET Mathematics') as scoreONET04NameEN,
				 peredu.scoreONET05,
				 ('O-NET วิทยาศาสตร์') as scoreONET05NameTH,
				 ('O-NET Science') as scoreONET05NameEN,
				 peredu.scoreONET06,
				 ('O-NET สุขศึกษาและพลศึกษา') as scoreONET06NameTH,
				 ('O-NET Health Education & Physical Education') as scoreONET06NameEN,
				 peredu.scoreONET07,
				 ('O-NET ศิลปะ') as scoreONET07NameTH,
				 ('O-NET Atrs') as scoreONET07NameEN,
				 peredu.scoreONET08,
				 ('O-NET การงานอาชีพและเทคโนโลยี') as scoreONET08NameTH,
				 ('O-NET Occupation & Teachnology') as scoreONET08NameEN,
				 peredu.scoreANET11,
				 ('A-NET ภาษาไทย 2') as scoreANET11NameTH,
				 ('A-NET Thai 2') as scoreANET11NameEN,
				 peredu.scoreANET12,
				 ('A-NET สังคมศึกษา 2') as scoreANET12NameTH,
				 ('A-NET Social Science 2') as scoreANET12NameEN,
				 peredu.scoreANET13,
				 ('A-NET ภาษาอังกฤษ 3') as scoreANET13NameTH,
				 ('A-NET English 3') as scoreANET13NameEN,
				 peredu.scoreANET14,
				 ('A-NET คณิตศาสตร์ 2') as scoreANET14NameTH,
				 ('A-NET Mathematics 2') as scoreANET14NameEN,
				 peredu.scoreANET15,
				 ('A-NET วิทยาศาสตร์ 2') as scoreANET15NameTH,
				 ('A-NET Science 2') as scoreANET15NameEN,
				 peredu.scoreGAT85,
				 ('GAT ความถนัดทั่วไป') as scoreGAT85NameTH,
				 ('GAT Genaral Aptitude Test') as scoreGAT85NameEN,
				 peredu.scorePAT71,
				 ('PAT 1 ความถนัดคณิตศาสตร์') as scorePAT71NameTH,
				 ('PAT 1 Aptitude In Mathematics') as scorePAT71NameEN,
				 peredu.scorePAT72,
				 ('PAT 2 ความถนัดวิทยาศาสตร์') as scorePAT72NameTH,
				 ('PAT 2 Aptitude In Science') as scorePAT72NameEN,
				 peredu.scorePAT73,
				 ('PAT 3 ความถนัดวิศวกรรมศาสตร์') as scorePAT73NameTH,
				 ('PAT 3 Aptitude In Engineering') as scorePAT73NameEN,
				 peredu.scorePAT74,
				 ('PAT 4 ความถนัดสถาปัตยกรรมศาสตร์') as scorePAT74NameTH,
				 ('PAT 4 Aptitude In Architecture') as scorePAT74NameEN,
				 peredu.scorePAT75, 
				 ('PAT 5 ความถนัดวิชาชีพครู') as scorePAT75NameTH,
				 ('PAT 5 Aptitude In Teaching') as scorePAT75NameEN,
				 peredu.scorePAT76,
				 ('PAT 6 ความถนัดศิลปกรรมศาสตร์') as scorePAT76NameTH,
				 ('PAT 6 Aptitude In Arts') as scorePAT76NameEN,
				 peredu.scorePAT77,
				 ('PAT 7 ภาษาฝรั่งเศส') as scorePAT77NameTH,
				 ('PAT 7 French Languages') as scorePAT77NameEN,
				 peredu.scorePAT78,
				 ('PAT 8 ภาษาเยอรมัน') as scorePAT78NameTH,
				 ('PAT 8 Germany Languages') as scorePAT78NameEN,
				 peredu.scorePAT79,
				 ('PAT 9 ภาษาญี่ปุ่น') as scorePAT79NameTH,
				 ('PAT 9 Japanese Languages') as scorePAT79NameEN,
				 peredu.scorePAT80,
				 ('PAT 10 ภาษาจีน') as scorePAT80NameTH,
				 ('PAT 10 Chinese Languages') as scorePAT80NameEN,
				 peredu.scorePAT81,
				 ('PAT 11 ภาษาอาหรับ') as scorePAT81NameTH,
				 ('PAT 11 Arabic Languages') as scorePAT81NameEN,
				 peredu.scorePAT82,
				 ('PAT 12 ภาษาบาลี') as scorePAT82NameTH,
				 ('PAT 12 Bali Languages') as scorePAT82NameEN,
				 peredu.createBy,
				 peredu.createDate,
				 peredu.modifyDate,
				 peredu.modifyBy
		from	 #perTemp as pertmp inner join
				 InfinityLog..perEducationLog as peredu with (nolock) on pertmp.perPersonId = peredu.perPersonId left join
				 plcCountry as plccps with (nolock) on peredu.plcCountryIdPrimarySchool = plccps.id left join
				 plcProvince as plcpps with (nolock) on peredu.plcProvinceIdPrimarySchool = plcpps.id and plccps.id = plcpps.plcCountryId left join
				 plcCountry as plccjs with (nolock) on peredu.plcCountryIdJuniorHighSchool = plccjs.id left join
				 plcProvince as plcpjs with (nolock) on peredu.plcProvinceIdJuniorHighSchool = plcpjs.id and plccjs.id = plcpjs.plcCountryId left join
				 plcCountry as plcchs with (nolock) on peredu.plcCountryIdHighSchool = plcchs.id left join
				 plcProvince as plcphs with (nolock) on peredu.plcProvinceIdHighSchool = plcphs.id and plcchs.id = plcphs.plcCountryId left join
				 perEducationalMajor as permhs with (nolock) on peredu.perEducationalMajorIdHighSchool = permhs.id left join
				 perEducationalBackground as perbhs with (nolock) on peredu.perEducationalBackgroundIdHighSchool = perbhs.id left join
				 perEducationalLevel as perlhs with (nolock) on perbhs.perEducationalLevelId = perlhs.id left join
				 perEducationalBackground as perebk with (nolock) on peredu.perEducationalBackgroundId = perebk.id left join
				 perEducationalLevel as perelv with (nolock) on perebk.perEducationalLevelId = perelv.id left join
				 perEntranceType as perent with (nolock) on peredu.perEntranceTypeId = perent.id
		order by peredu.id desc
	end

	if (@reportName = 'PersonRecordsTalent')
	begin
		select	 peract.id,
				 pertmp.perPersonId,
				 pertmp.studentCode,
				 peract.sportsman as sportsmanStatus,
				 (
					case peract.sportsman
						when 'Y' then 'เคย'
						when 'N' then 'ไม่เคย'
						else null	
					end				
				 ) as sportsmanStatusNameTH,
				 (
					case peract.sportsman
						when 'Y' then 'Ever'
						when 'N' then 'Never'
						else null
					end
				 ) as sportsmanStatusNameEN,
				 peract.sportsmanDetail,
				 peract.specialist as specialistStatus,
				 (
					case peract.specialist
						when 'Y' then 'มี'
						when 'N' then 'ไม่มี'
						else null
					end
				 ) as specialistStatusNameTH,
				 (
					case peract.specialist
						when 'Y' then 'Have'
						when 'N' then 'Without'
						else null
					end
				 ) as specialistStatusNameEN,
				 peract.specialistSport as specialistSportStatus,
				 (
					case peract.specialistSport
						when 'Y' then 'มี'
						when 'N' then 'ไม่มี'
						else null
					end
				 ) as specialistSportStatusNameTH,
				 (
					case peract.specialistSport
						when 'Y' then 'Have'
						when 'N' then 'Without'
						else null
					end
				 ) as specialistSportStatusNameEN,
				 peract.specialistSportDetail,
				 peract.specialistArt as specialistArtStatus,
				 (
					case peract.specialistArt
						when 'Y' then 'มี'
						when 'N' then 'ไม่มี'
						else null
					end
				 ) as specialistArtStatusNameTH,
				 (
					case peract.specialistArt
						when 'Y' then 'Have'
						when 'N' then 'Without'
						else null
					end		
				 ) as specialistArtStatusNameEN,
				 peract.specialistArtDetail,
				 peract.specialistTechnical as specialistTechnicalStatus,
				 (
					case peract.specialistTechnical
						when 'Y' then 'มี'
						when 'N' then 'ไม่มี'
						else null
					end
				 ) as specialistTechnicalStatusNameTH,		
				 (
					case peract.specialistTechnical
						when 'Y' then 'Have'
						when 'N' then 'Without'
						else null
					end
				 ) as specialistTechnicalStatusNameEN,
				 peract.specialistTechnicalDetail,
				 peract.specialistOther as specialistOtherStatus,
				 (
					case peract.specialistOther
						when 'Y' then 'มี'
						when 'N' then 'ไม่มี'
						else null
					end
				 ) as specialistOtherStatusNameTH,		
				 (
					case peract.specialistOther
						when 'Y' then 'Have'
						when 'N' then 'Without'
						else null
					end
				 ) as specialistOtherStatusNameEN,
				 peract.specialistOtherDetail,
				 peract.activity as activityStatus,
				 (
					case peract.activity
						when 'Y' then 'เคย'
						when 'N' then 'ไม่เคย'
						else null
					end
				 ) as activityStatusNameTH,
				 (
					case peract.activity
						when 'Y' then 'Ever'
						when 'N' then 'Never'
						else null
					end
				 ) as activityStatusNameEN,
				 peract.activityDetail,
				 peract.reward as rewardStatus,
				 (
					case peract.reward
						when 'Y' then 'เคย'
						when 'N' then 'ไม่เคย'
						else null
					end
				 ) as rewardStatusNameTH,
				 (
					case peract.reward
						when 'Y' then 'Ever'
						when 'N' then 'Never'
						else null
					end
				 ) as rewardStatusNameEN,
				 peract.rewardDetail,
				 peract.createDate,
				 peract.createBy,
				 peract.modifyDate,
				 peract.modifyBy
		from	 #perTemp as pertmp inner join
				 InfinityLog..perActivityLog as peract with (nolock) on pertmp.perPersonId = peract.perPersonId
		order by peract.id desc
	end

	if (@reportName = 'PersonRecordsHealthy')
	begin
		select	 perhea.id,
				 pertmp.perPersonId,
				 pertmp.studentCode,
				 perhea.bodyMassDetail,
				 perhea.intolerance as intoleranceStatus,
				 (
					case perhea.intolerance
						when 'Y' then 'มี'
						when 'N' then 'ไม่มี'
						else null
					end
				 ) as intoleranceStatusNameTH,
				 (
					case perhea.intolerance
						when 'Y' then 'Have'
						when 'N' then 'Without'
						else null
					end
				 ) as intoleranceStatusNameEN,
				 perhea.intoleranceDetail,
				 perhea.diseases as diseasesStatus,
				 (
					case perhea.diseases
						when 'Y' then 'มี'
						when 'N' then 'ไม่มี'
						else null
					end
				 ) as diseasesStatusNameTH,
				 (
					case perhea.diseases
						when 'Y' then 'Have'
						when 'N' then 'Without'
						else null
					end
				 ) as diseasesStatusNameEN,
				 perhea.diseasesDetail,
				 perhea.ailHistoryFamily as ailHistoryFamilyStatus,
				 (
					case perhea.ailHistoryFamily
						when 'Y' then 'มี'
						when 'N' then 'ไม่มี'
						else null
					end
				 ) as ailHistoryFamilyStatusNameTH,
				 (
					case perhea.ailHistoryFamily
						when 'Y' then 'Have'
						when 'N' then 'Without'
						else null
					end
				 ) as ailHistoryFamilyStatusNameEN,
				 perhea.ailHistoryFamilyDetail,
				 perhea.travelAbroad as travelAbroadStatus,
				 (
					case perhea.travelAbroad
						when 'Y' then 'เคย'
						when 'N' then 'ไม่เคย'
						else null
					end
				 ) as travelAbroadStatusNameTH,
				 (
					case perhea.travelAbroad
						when 'Y' then 'Ever'
						when 'N' then 'Never'
						else null
					end
				 ) as travelAbroadStatusNameEN,
				 perhea.travelAbroadDetail,
				 perhea.impairments as impairmentsStatus,
				 (
					case perhea.impairments
						when 'Y' then 'มี'
						when 'N' then 'ไม่มี'
						else null
					end
				 ) as impairmentsStatusNameTH,
				 (
					case perhea.impairments
						when 'Y' then 'Have'
						when 'N' then 'Without'
						else null
					end
				 ) as impairmentsStatusNameEN,
				 perhea.perImpairmentsId,
				 perimp.impairmentsNameTH,
				 perimp.impairmentsNameEN,
				 perhea.impairmentsEquipment,
				 perhea.createDate,
				 perhea.createBy, 
				 perhea.modifyDate,
				 perhea.modifyBy
		from	 #perTemp as pertmp inner join
				 InfinityLog..perHealthyLog as perhea with (nolock) on pertmp.perPersonId = perhea.perPersonId left join
				 perImpairments as perimp with (nolock) on perhea.perImpairmentsId = perimp.id
		order by perhea.id desc
	end

	if (@reportName = 'PersonRecordsWork')
	begin
		select	 perwor.id,
				 pertmp.perPersonId,
				 pertmp.studentCode,
				 perwor.occupation,
				 dbo.fnc_perGetOccupationName(perwor.occupation, 'TH') as occupationTH,
				 dbo.fnc_perGetOccupationName(perwor.occupation, 'EN') as occupationEN,
				 perwor.perAgencyId,
				 peragc.agencyNameTH,
				 peragc.agencyNameEN,
				 perwor.agencyOther,
				 perwor.workplace,
				 perwor.position,
				 perwor.telephone, 
				 perwor.salary,
				 perwor.createDate,
				 perwor.createBy,
				 perwor.modifyDate,
				 perwor.modifyBy
		from	 #perTemp as pertmp inner join
				 InfinityLog..perWorkLog as perwor with (nolock) on pertmp.perPersonId = perwor.perPersonId left join
				 perAgency as peragc with (nolock) on perwor.perAgencyId = peragc.id
		order by perwor.id desc
	end

	if (@reportName = 'PersonRecordsFinancial')
	begin
		select	 perfin.id,
				 pertmp.perPersonId,
				 pertmp.studentCode,
				 perfin.scholarshipFirstBachelor as scholarshipFirstBachelorStatus,
				 (
					case perfin.scholarshipFirstBachelor
						when 'Y' then 'เคย'
						when 'N' then 'ไม่เคย'
						else null
					end
				 ) as scholarshipFirstBachelorStatusNameTH,
				 (
					case perfin.scholarshipFirstBachelor
						when 'Y' then 'Ever'
						when 'N' then 'Never'
						else null
					end	
				 ) as scholarshipFirstBachelorStatusNameEN,
				 perfin.scholarshipFirstBachelorFrom,
				 (		
					case perfin.scholarshipFirstBachelorFrom
						when '01' then 'กองทุนเงินให้กู้ยืมเพื่อการศึกษา'
						when '02' then 'หน่วยงานภาครัฐ'
						when '03' then 'หน่วยงานภาคเอกชน'
						else null
					end
				 ) as scholarshipFirstBachelorFromTH,
				 (		
					case perfin.scholarshipFirstBachelorFrom
						when '01' then 'Student Loan'
						when '02' then 'Government Agency'
						when '03' then 'Private Agency'
						else null
					end
				 ) as scholarshipFirstBachelorFromEN,
				 perfin.scholarshipFirstBachelorName,
				 perfin.scholarshipFirstBachelorMoney,
				 perfin.scholarshipBachelor as scholarshipBachelorStatus,
				 (
					case perfin.scholarshipBachelor
						when 'Y' then 'เคย'
						when 'N' then 'ไม่เคย'
						else null
					end
				 ) as scholarshipBachelorStatusTH,
				 (
					case perfin.scholarshipBachelor
						when 'Y' then 'Ever'
						when 'N' then 'Never'
						else null
					end
				 ) as scholarshipBachelorStatusEN,
				 perfin.scholarshipBachelorFrom,
				 (
					case perfin.scholarshipBachelorFrom
						when '01' then 'กองทุนเงินให้กู้ยืมเพื่อการศึกษา'
						when '02' then 'หน่วยงานภาครัฐ'
						when '03' then 'หน่วยงานภาคเอกชน'
						else null
					end
				 ) as scholarshipBachelorFromTH,
				 (
					case perfin.scholarshipBachelorFrom
						when '01' then 'Student Loan'
						when '02' then 'Government Agency'
						when '03' then 'Private Agency'
						else null
					end
				 ) as scholarshipBachelorFromEN,
				 perfin.scholarshipBachelorName,
				 perfin.scholarshipBachelorMoney,
				 perfin.worked as workedStatus,
				 (
					case perfin.worked
						when 'Y' then 'ทำ'
						when 'N' then 'ไม่ทำ'
						else null
					end
				 ) as workedStatusNameTH,
				 (
					case perfin.worked
						when 'Y' then 'Work'
						when 'N' then 'Not Work'
						else null
					end
				 ) as workedStatusNameEN,
				 perfin.salary,
				 perfin.workplace, 
				 perfin.gotMoneyFrom,
				 (
					case perfin.gotMoneyFrom
						when '01' then 'บิดา'
						when '02' then 'มารดา'
						when '03' then 'บิดาและมารดา'
						when '04' then 'กู้ยืม'
						when '05' then 'ทำงานด้วยตนเอง'
						when '06' then 'ผู้ปกครอง / ญาติ'
						when '07' then 'ทุนการศึกษา'
						else null
					end
				 ) as gotMoneyFromTH,
				 (
					case perfin.gotMoneyFrom
						when '01' then 'Father'
						when '02' then 'Mother'
						when '03' then 'Father and Mother'
						when '04' then 'Loan'
						when '05' then 'Self Support'
						when '06' then 'Benefactor / Relative'
						when '07' then 'Scholarship'
						else null
					end
				 ) as gotMoneyFromEN,
				 perfin.gotMoneyFromOther,
				 perfin.gotMoneyPerMonth,
				 perfin.costPerMonth,
				 perfin.createDate, 
				 perfin.createBy,
				 perfin.modifyDate,
				 perfin.modifyBy
		from	 #perTemp as pertmp inner join
				 InfinityLog..perFinancialLog as perfin with (nolock) on pertmp.perPersonId = perfin.perPersonId
		order by perfin.id desc
	end

	if (@reportName = 'PersonRecordsFamily')
	begin
		select	 perpar.id,
				 pertmp.perPersonId,
				 pertmp.studentCode,
				 perpar.createDate,
				 perpar.createBy,
				 perpar.modifyDate,
				 perpar.modifyBy
		from	 #perTemp as pertmp inner join
				 InfinityLog..perParentLog as perpar with (nolock) on pertmp.perPersonId = perpar.perPersonId
		order by perpar.id desc
	end
end
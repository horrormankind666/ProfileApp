USE [Infinity]
GO
/****** Object:  UserDefinedFunction [dbo].[fnc_perGetListPersonStudent]    Script Date: 3/7/2564 20:06:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๓๑/๐๕/๒๕๖๒>
-- Description	: <สำหรับแสดงข้อมูลระเบียนประวัติ>
-- =============================================
ALTER function [dbo].[fnc_perGetListPersonStudent] 
(	
)
returns table 
as
return
(
	select	perpes.id,
			stdstd.id as studentId,
			stdstd.studentCode,
			perpes.idCard,
			perpes.perTitlePrefixId,
			pertpl.thTitleFullName as titlePrefixFullNameTH,
			pertpl.thTitleInitials as titlePrefixInitialsTH, 
			pertpl.enTitleFullName as titlePrefixFullNameEN,
			pertpl.enTitleInitials as titlePrefixInitialsEN,
			perpes.firstName, 
			perpes.middleName, 
			perpes.lastName, 
			perpes.enFirstName as firstNameEN, 
			perpes.enMiddleName as middleNameEN, 
			perpes.enLastName as lastNameEN, 
			isnull(perpes.perGenderId, pertpl.perGenderId) as perGenderId,
			isnull(pergps.thGenderFullName, pergtp.thGenderFullName) as genderFullNameTH, 
			isnull(pergps.thGenderInitials, pergtp.thGenderInitials) as genderInitialsTH, 
			isnull(pergps.enGenderFullName, pergtp.enGenderFullName) as genderFullNameEN, 
			isnull(pergps.enGenderInitials, pergtp.enGenderInitials) as genderInitialsEN, 
			perpes.birthDate, 
			(case when (len(isnull(perpes.birthDate, '')) > 0) then (substring(convert(varchar, perpes.birthDate, 103), 1, 6) + convert(varchar, (year(perpes.birthDate) + 543))) else null end) as thBirthDate,
			(case when (len(isnull(perpes.birthDate, '')) > 0) then convert(varchar, perpes.birthDate, 103) else null end) as enBirthDate, 
			(case when (len(isnull(perpes.birthDate, '')) > 0) then (datediff(year, perpes.birthDate, getdate())) else null end) as age,
			perpes.perNationalityId,
			pernat.thNationalityName as nationalityNameTH, 
			pernat.enNationalityName as nationalityNameEN,
			pernat.isoCountryCodes2Letter as isoNationalityName2Letter,
			pernat.isoCountryCodes3Letter as isoNationalityName3Letter,
			perpes.perOriginId,
			perpes.perBloodTypeId, 
			stdstd.facultyId,
			acafac.facultyCode,
			isnull(acafpn.facultyNameTh, acafac.nameTh) as facultyNameTH,
			isnull(acafpn.facultyNameEn, acafac.nameEn) as facultyNameEN,
			--acafac.nameTh as facultyNameTH,
			--acafac.nameEn as facultyNameEN,
			stdstd.programId,
			acaprg.programCode,
			isnull(acafpn.programNameTh, acaprg.nameTh) as programNameTH,
			isnull(acafpn.programNameEn, acaprg.nameEn) as programNameEN,
			--acaprg.nameTh as programNameTH,
			--acaprg.nameEn as programNameEN,
			acaprg.majorCode,
			acaprg.groupNum,
			stdstd.programYear,
			acaprg.studyYear,
			acaprg.cancelStatus as programCancelStatus,
			acaprg.schRefGroup_ICL as schRefGroupId,
			stdstd.yearEntry,
			stdstd.class,
			stdstd.degree, 
			stddgl.thDegreeLevelName as degreeLevelNameTH,
			stddgl.enDegreeLevelName as degreeLevelNameEN,
			stdstd.admissionType as perEntranceTypeId,
			perent.entranceTypeNameTH as stdEntranceTypeNameTH, 
			perent.entranceTypeNameEN as stdEntranceTypeNameEN,
			stdstd.status,
			stdstt.nameTh as statusTypeNameTH,
			stdstt.nameEn as statusTypeNameEN,
			substring(isnull(stdstd.status, ''), 1, 2) as statusStudentGroup, 
			stdstt.[group] as statusGroup,
			stdstd.admissionDate,
			stdstd.graduateDate,
			(case when (len(isnull(stdstd.graduateYear, '')) > 0) then stdstd.graduateYear else (case when (len(isnull(stdstd.graduateDate, '')) > 0) then convert(varchar, year(stdstd.graduateDate) + 543) else null end) end) as yearGraduate,
			stdstd.updateWhat,
			stdstd.updateReason,
			stdstd.distinction,
			(case stdstd.distinction when 1 then 'Y' else 'N' end) as distinctionStatus,
			stdstd.mspJoin,
			stdstd.mspStartSemester,
			stdstd.mspStartYear,
			stdstd.mspEndSemester,
			stdstd.mspEndYear,
			stdstd.mspResignDate,
			stdstd.cancelStatus
	from	stdStudent as stdstd with (nolock) left join
			acaFaculty as acafac with (nolock) on stdstd.facultyId = acafac.id left join
			acaProgram as acaprg with (nolock) on stdstd.facultyId = acaprg.facultyId and stdstd.programId = acaprg.id left join
			acaFacultyAndProgramNewName as acafpn on (stdStd.facultyId = acafpn.facultyId) and (stdstd.programId = acafpn.programId) and (stdstd.yearEntry between acafpn.startYearEntry and acafpn.endYearEntry) left join
			stdDegreeLevel as stddgl with (nolock) on stdstd.degree = stddgl.id left join
			perEntranceType as perent with (nolock) on stdstd.admissionType = perent.id left join
			stdStatusType as stdstt with (nolock) on stdstd.status = stdstt.id inner join
			perPerson as perpes with (nolock) on stdstd.personId = perpes.id left join
			perTitlePrefix as pertpl with (nolock) on perpes.perTitlePrefixId = pertpl.id left join
			perGender as pergtp with (nolock) on pertpl.perGenderId = pergtp.id left join
			perGender as pergps with (nolock) on perpes.perGenderId = pergps.id left join
			perNationality as pernat with (nolock) on perpes.perNationalityId = pernat.id
	where	(stdstd.cancelStatus IS NULL)
)

USE [Infinity]
GO
/****** Object:  UserDefinedFunction [dbo].[fnc_perGetPersonStudent]    Script Date: 5/10/2564 13:20:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๘/๐๖/๒๕๕๘>
-- Description	: <สำหรับเรียกดูข้อมูลของนักศึกษา>
-- Parameter
--  1. personId เป็น varchar	รับค่ารหัสบุคคล
-- =============================================
ALTER function [dbo].[fnc_perGetPersonStudent]
(	
	@personId varchar(10) = null
)
returns table
as
return
(
	select  perpes.*,
			stdstd.id as studentId,
			stdstd.studentCode,
			stdstd.tempCode,
			stdstd.degree,
			stddgl.thDegreeLevelName as degreeLevelNameTH,
			stddgl.enDegreeLevelName as degreeLevelNameEN,
			stdstd.admissionType as perEntranceTypeId,
			perent.idOld as perEntranceTypeIdOld,
			perent.entranceTypeNameTH as stdEntranceTypeNameTH,
			perent.entranceTypeNameEN as stdEntranceTypeNameEN,						
			stdstd.facultyId,
			isnull(acafpn.facultyNameTh, acafac.nameTh) as facultyNameTH,
			isnull(acafpn.facultyNameEn, acafac.nameEn) as facultyNameEN,
			--acafac.nameTh as facultyNameTH,
			--acafac.nameEn as facultyNameEN,
			acafac.facultyCode,
			stdstd.programId,
			isnull(acafpn.programNameTh, acaprg.nameTh) as programNameTH,
			isnull(acafpn.programNameEn, acaprg.nameEn) as programNameEN,
			--acaprg.nameTh as programNameTH,
			--acaprg.nameEn as programNameEN,
			acaprg.programCode,
			acaprg.majorCode,
			acaprg.groupNum,
			acaprg.studyYear,
			acaprg.address as programAddress,
			acaprg.telephone as programTelephone,		
			acaprg.schRefGroup_ICL as schRefGroupId,				
			stdstd.yearEntry,
			stdstd.acaYear,
			stdstd.courseYear,
			stdstd.class,			
			stdstd.admissionDate,		
			stdstd.status as stdStatusTypeId,
			stdstt.nameTh as statusTypeNameTH,
			stdstt.nameEn as statusTypeNameEN,
			stdstt.[group] as statusGroup,
			stdstd.distinction,
			stdstd.graduateYear,
			stdstd.graduateDate,
			stdstd.updateWhat,
			stdstd.updateReason,
			stdstd.admissionId,
			'' as folderPictureName,
			stdstd.pictureName as profilePictureName
	from	stdStudent as stdstd with(nolock) left join
			acaFaculty as acafac with(nolock) on stdstd.facultyId = acafac.id left join
			acaProgram as acaprg with(nolock) on stdstd.facultyId = acaprg.facultyId and stdstd.programId = acaprg.id left join
			acaFacultyAndProgramNewName as acafpn on (stdStd.facultyId = acafpn.facultyId) and (stdstd.programId = acafpn.programId) and (stdstd.yearEntry between acafpn.startYearEntry and acafpn.endYearEntry) left join
			acaMajor as acamaj with(nolock) on acaprg.majorId = acamaj.id left join
			stdDegreeLevel as stddgl with(nolock) on stdstd.degree = stddgl.id left join
			perEntranceType as perent with(nolock) on stdstd.admissionType = perent.id left join
			stdStatusType as stdstt with(nolock) on stdstd.status = stdstt.id inner join
			fnc_perGetPerson(@personId) as perpes on stdstd.personId = perpes.id --left join
			--(select distinct StudentID, FolderName, FileName from MUStudent..SPictureLookup with(nolock)) as stdpic on stdstd.studentCode = stdpic.StudentID
	where	stdstd.cancelStatus is null
)
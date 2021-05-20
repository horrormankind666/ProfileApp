USE [Infinity]
GO
/****** Object:  UserDefinedFunction [dbo].[fnc_perGetPersonStudent]    Script Date: 09-08-2016 09:32:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๘/๐๖/๒๕๕๘>
-- Description	: <สำหรับเรียกดูข้อมูลของนักศึกษา>
-- Parameter
--  1. personId		เป็น VARCHAR	รับค่ารหัสบุคคล
-- =============================================
ALTER FUNCTION [dbo].[fnc_perGetPersonStudent]
(	
	@personId VARCHAR(10) = NULL
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT  perper.*,
			stdstd.id AS studentId,
			stdstd.studentCode,
			stdstd.tempCode,
			stdstd.degree,
			stddgl.thDegreeLevelName AS degreeLevelNameTH,
			stddgl.enDegreeLevelName AS degreeLevelNameEN,
			stdstd.admissionType AS perEntranceTypeId,
			perent.idOld AS perEntranceTypeIdOld,
			perent.entranceTypeNameTH AS stdEntranceTypeNameTH,
			perent.entranceTypeNameEN AS stdEntranceTypeNameEN,						
			stdstd.facultyId,
			acafac.nameTh AS facultyNameTH,
			acafac.nameEn AS facultyNameEN,
			acafac.facultyCode,
			stdstd.programId,
			acaprg.nameTh AS programNameTH,
			acaprg.nameEn AS programNameEN,
			acaprg.programCode,
			acaprg.majorCode,
			acaprg.groupNum,
			acaprg.studyYear,
			acaprg.address AS programAddress,
			acaprg.telephone AS programTelephone,						
			stdstd.yearEntry,
			stdstd.acaYear,
			stdstd.courseYear,
			stdstd.class,			
			stdstd.admissionDate,		
			stdstd.status AS stdStatusTypeId,
			stdstt.nameTh AS statusTypeNameTH,
			stdstt.nameEn AS statusTypeNameEN,
			stdstt.[group] AS statusGroup,
			stdstd.distinction,
			stdstd.graduateYear,
			stdstd.graduateDate,
			stdstd.updateReason,
			'' AS folderPictureName,
			stdstd.pictureName AS profilePictureName
	FROM	stdStudent AS stdstd LEFT JOIN
			acaFaculty AS acafac ON stdstd.facultyId = acafac.id LEFT JOIN
			acaProgram AS acaprg ON stdstd.facultyId = acaprg.facultyId AND stdstd.programId = acaprg.id LEFT JOIN										
			acaMajor AS acamaj ON acaprg.majorId = acamaj.id LEFT JOIN
			stdDegreeLevel AS stddgl ON stdstd.degree = stddgl.id LEFT JOIN
			perEntranceType AS perent ON stdstd.admissionType = perent.id LEFT JOIN
			stdStatusType AS stdstt ON stdstd.status = stdstt.id INNER JOIN
			fnc_perGetPerson(@personId) AS perper ON stdstd.personId = perper.id --LEFT JOIN
			--(SELECT DISTINCT StudentID, FolderName, FileName FROM MUStudent..SPictureLookup) AS stdpic ON stdstd.studentCode = stdpic.StudentID
)
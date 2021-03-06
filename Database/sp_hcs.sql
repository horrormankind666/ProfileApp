USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_hcs]    Script Date: 05/12/2015 08:08:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๖/๑๒/๒๕๕๗>
-- Description	: <สำหรับใช้กับระบบ Health Care Service>
-- Parameter
--  1. orderTable	เป็น INT		รับค่าลำดับคำสั่ง
--  2. studentId	เป็น VARCHAR	รับค่ารหัสนักศึกษา
-- =============================================
ALTER PROCEDURE [dbo].[sp_hcs]
(
	@orderTable INT = NULL,
	@personId VARCHAR(MAX) = NULL,
	@studentId VARCHAR(MAX) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	
	DECLARE @sql VARCHAR(MAX) = ''
	DECLARE @where VARCHAR(MAX) = ''
	DECLARE @studentJoin VARCHAR(MAX) = ''
	
	SET @studentJoin = 'stdStudent AS stdstd LEFT JOIN
						acaFaculty AS acafac1 ON stdstd.facultyId = acafac1.id LEFT JOIN
						acaProgram AS acaprg ON stdstd.facultyId = acaprg.facultyId AND stdstd.programId = acaprg.id LEFT JOIN										
						acaFaculty AS acafac2 ON acaprg.facultyId = acafac2.id LEFT JOIN
						acaMajor AS acamaj ON acaprg.majorId = acamaj.id LEFT JOIN
						stdDegreeLevel AS stddgl ON stdstd.degree = stddgl.id LEFT JOIN
						perEntranceType AS perent ON stdstd.admissionType = perent.id LEFT JOIN
						stdStatusType AS stdstt ON stdstd.status= stdstt.id INNER JOIN'
	
	/*ตรวจสอบนักศึกษา*/
	IF (@orderTable = 1)
	BEGIN
		IF (@personId IS NOT NULL AND LEN(@personId) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where + '(perper.id = "' + @personId + '")'													
		END				

		IF (@studentId IS NOT NULL AND LEN(@studentId) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where + '((stdstd.id = "' + @studentId + '") OR (stdstd.studentCode = "' + @studentId + '"))'		
		END				
		
		IF (@where IS NOT NULL AND LEN(@where) > 0)
			SET @where = ' WHERE ' + @where
					
		SET @sql = 'SELECT	perper.id, stdstd.id AS studentId, stdstd.studentCode
					FROM	' + @studentJoin + ' 
							fnc_perGetListPerson("", "", "") AS perper ON stdstd.personId = perper.id'
							
		SET @sql = @sql + @where
		 
		EXEC (@sql)
		
		SET @sql = 'SELECT	stdstd.id AS studentId, stdstd.studentCode
					FROM	' + @studentJoin + ' 
							fnc_perGetListPerson("", "", "") AS perper ON stdstd.personId = perper.id INNER JOIN		
							hcsProgram AS hcsprg ON acaprg.id = hcsprg.acaProgramId INNER JOIN
							hcsHospital AS hcshpt ON hcsprg.stdHSCHospitalId = hcshpt.id'
							
		SET @sql = @sql + @where
		 
		EXEC (@sql)
	END
	
	/*แสดงข้อมูลนักศึกษา*/
	IF (@orderTable = 2)
	BEGIN		
		IF (@personId IS NOT NULL AND LEN(@personId) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where + '(perper.id = "' + @personId + '")'													
		END				

		IF (@studentId IS NOT NULL AND LEN(@studentId) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where + '((stdstd.id = "' + @studentId + '") OR (stdstd.studentCode = "' + @studentId + '"))'		
		END				

		IF (@where IS NOT NULL AND LEN(@where) > 0)
			SET @where = ' WHERE ' + @where	
	
		SET @sql = 'SELECT	stdstd.id AS studentId, stdstd.studentCode,							
							stdstd.facultyId, acafac1.nameTh AS thFacultyName, acafac1.nameEn AS enFacultyName,
							stdstd.programId, acaprg.nameTh AS thProgramName, acaprg.nameEn AS enProgramName, 
							acaprg.address AS programAddress, acaprg.telephone AS programTelephone,
							hcsprg.stdHSCHospitalId, hcshpt.thHospitalName, hcshpt.enHospitalName,
							perper.*,
							peradd.*,
							perwkparent.*
					FROM	' + @studentJoin + ' 
							fnc_perGetListPerson("", "", "") AS perper ON stdstd.personId = perper.id INNER JOIN		
							hcsProgram AS hcsprg ON acaprg.id = hcsprg.acaProgramId INNER JOIN
							hcsHospital AS hcshpt ON hcsprg.stdHSCHospitalId = hcshpt.id LEFT JOIN
							fnc_perGetListAddress("", "", "") AS peradd ON perper.id = peradd.id LEFT JOIN
							fnc_perGetListWorkParent("", "", "") AS perwkparent ON perper.id = perwkparent.id'
									 
		SET @sql = @sql + @where
										 
		EXEC (@sql)
	END
END
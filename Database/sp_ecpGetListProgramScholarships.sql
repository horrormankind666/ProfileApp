SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๘/๐๑/๒๕๕๙>
-- Description	: <สำหรับแสดงข้อมูลทุนการศึกษาแต่ละหลักสูตร>
--	1. degreeLevel		เป็น VARCHAR	รับค่าระดับปริญญา
--	2. faculty			เป็น VARCHAR	รับค่ารหัสคณะ
--	3. program			เป็น VARCHAR	รับค่าหลักสูตร
--	4. cancelledStatus	เป็น VARCHAR	รับค่าสถานะการยกเลิก
--  5. sortOrderBy		เป็น VARCHAR	รับค่าคอลัมภ์ที่ต้องการเรียงลำดับ
--  6. sortExpression	เป็น VARCHAR	รับค่าวิธีการเรียงลำดับ
-- =============================================
CREATE PROCEDURE [dbo].[sp_ecpGetListProgramScholarships]
(
	@degreeLevel NVARCHAR(2) = NULL,
	@faculty VARCHAR(15) = NULL,
	@program VARCHAR(15) = NULL,	
	@cancelledStatus VARCHAR(1) = NULL,
	@sortOrderBy VARCHAR(255) = NULL,
	@sortExpression VARCHAR(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON

	SET @degreeLevel = LTRIM(RTRIM(@degreeLevel))
	SET @faculty = LTRIM(RTRIM(@faculty))
	SET @program = LTRIM(RTRIM(@program))			
	SET @cancelledStatus = LTRIM(RTRIM(@cancelledStatus))
	SET @sortOrderBy = LTRIM(RTRIM(@sortOrderBy))
	SET @sortExpression = LTRIM(RTRIM(@sortExpression))
	
	DECLARE @sort VARCHAR(255) = ''
	
	SET @sortOrderBy = (CASE WHEN (@sortOrderBy IS NOT NULL) AND (LEN(@sortOrderBy) > 0) THEN @sortOrderBy ELSE 'Program' END)
	SET @sortExpression = (CASE WHEN (@sortExpression IS NOT NULL) AND (LEN(@sortExpression) > 0) THEN @sortExpression ELSE 'Ascending' END)
	SET @sort = (@sortOrderBy + ' ' + @sortExpression)

	SELECT	*
	FROM	(SELECT ROW_NUMBER() OVER(ORDER BY 
						CASE WHEN @sort = 'Degree Level Ascending'			THEN stddlv.priorityDegreeLevel END ASC,
						CASE WHEN @sort = 'Faculty Ascending'				THEN acaprg.facultyId END ASC,
						CASE WHEN @sort = 'Program Ascending'				THEN ecppgs.ecpProgramContractId END ASC,
						CASE WHEN @sort = 'Amount Scholarship Ascending'	THEN ecppgs.amountScholarship END ASC,
						CASE WHEN @sort = 'Cancelled Status Ascending'		THEN ecppgs.cancelledStatus END ASC,
						CASE WHEN @sort = 'Action Date Ascending'			THEN ecppgs.modifyDate END ASC,
						CASE WHEN @sort = 'Action Date Ascending'			THEN ecppgs.createDate END ASC,

						CASE WHEN @sort = 'Degree Level Descending'			THEN stddlv.priorityDegreeLevel END DESC,
						CASE WHEN @sort = 'Faculty Descending'				THEN acaprg.facultyId END DESC,
						CASE WHEN @sort = 'Program Descending'				THEN ecppgs.ecpProgramContractId END DESC,
						CASE WHEN @sort = 'Amount Scholarship Descending'	THEN ecppgs.amountScholarship END DESC,
						CASE WHEN @sort = 'Cancelled Status Descending'		THEN ecppgs.cancelledStatus END DESC,
						CASE WHEN @sort = 'Action Date Descending'			THEN ecppgs.modifyDate END DESC,
						CASE WHEN @sort = 'Action Date Descending'			THEN ecppgs.createDate END DESC
					) AS rowNum,
					acaprg.facultyId,
					acafac.facultyCode,
					acafac.nameTh AS facultyNameTH,
					acafac.nameEn AS facultyNameEN,
					ecppgs.ecpProgramContractId,
					acaprg.programCode,
					acaprg.majorCode,
					acaprg.groupNum,
					acaprg.nameTh AS programNameTH,
					acaprg.nameEn AS programNameEN,
					acaprg.dLevel AS degreeLevel,
					stddlv.thDegreeLevelName AS degreeLevelNameTH,
					stddlv.enDegreeLevelName AS degreeLevelNameEN,
					ecppgs.amountScholarship,
					ecppgs.cancelledStatus,
					ecppgs.createDate,
					ecppgs.modifyDate
			 FROM	Infinity..ecpProgramScholarships AS ecppgs INNER JOIN
					Infinity..ecpProgramContract AS ecppgc ON ecppgs.ecpProgramContractId = ecppgc.acaProgramId INNER JOIN
					Infinity..acaProgram AS acaprg ON ecppgc.acaProgramId = acaprg.id LEFT JOIN
					Infinity..acaFaculty AS acafac ON acaprg.facultyId = acafac.id LEFT JOIN
					Infinity..stdDegreeLevel AS stddlv ON acaprg.dLevel = stddlv.id
			 WHERE	(acaprg.cancelStatus IS NULL) AND
					(ecppgc.cancelledStatus = 'N') AND
					(
						(1 = (CASE WHEN (@degreeLevel IS NOT NULL AND LEN(@degreeLevel) > 0) THEN 0 ELSE 1 END)) OR
						(acaprg.dLevel = @degreeLevel)
					) AND
					(
						(1 = (CASE WHEN (@faculty IS NOT NULL AND LEN(@faculty) > 0 AND @faculty <> 'MU-01') THEN 0 ELSE 1 END)) OR
						(acaprg.facultyId = @faculty)
					) AND
					(
						(1 = (CASE WHEN (@program IS NOT NULL AND LEN(@program) > 0) THEN 0 ELSE 1 END)) OR
						(ecppgs.ecpProgramContractId = @program)
					) AND
					(
						(1 = (CASE WHEN (@cancelledStatus IS NOT NULL AND LEN(@cancelledStatus) > 0) THEN 0 ELSE 1 END)) OR					 						
						(ecppgs.cancelledStatus = @cancelledStatus)
					)) AS ecppgs

	SELECT	COUNT(ecppgs.ecpProgramContractId)
	FROM	Infinity..ecpProgramScholarships AS ecppgs INNER JOIN
			Infinity..ecpProgramContract AS ecppgc ON ecppgs.ecpProgramContractId = ecppgc.acaProgramId INNER JOIN
			Infinity..acaProgram AS acaprg ON ecppgc.acaProgramId = acaprg.id LEFT JOIN
			Infinity..acaFaculty AS acafac ON acaprg.facultyId = acafac.id LEFT JOIN
			Infinity..stdDegreeLevel AS stddlv ON acaprg.dLevel = stddlv.id
	WHERE	(acaprg.cancelStatus IS NULL)
END
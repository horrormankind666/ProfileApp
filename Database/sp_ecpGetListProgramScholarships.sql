SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <�ط����� ��ѹ��>
-- Create date	: <��/��/����>
-- Description	: <����Ѻ�ʴ������ŷع����֡��������ѡ�ٵ�>
--	1. degreeLevel		�� VARCHAR	�Ѻ����дѺ��ԭ��
--	2. faculty			�� VARCHAR	�Ѻ������ʤ��
--	3. program			�� VARCHAR	�Ѻ�����ѡ�ٵ�
--	4. cancelledStatus	�� VARCHAR	�Ѻ���ʶҹС��¡��ԡ
--  5. sortOrderBy		�� VARCHAR	�Ѻ��Ҥ���������ͧ������§�ӴѺ
--  6. sortExpression	�� VARCHAR	�Ѻ����Ըա�����§�ӴѺ
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
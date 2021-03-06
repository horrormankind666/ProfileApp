USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_ecpGetListIndemnityAgreement]    Script Date: 18/1/2559 13:01:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๓/๐๑/๒๕๕๙>
-- Description	: <สำหรับแสดงข้อมูลดอกเบี้ยจากการผิดนัดชำระ>
--	1. keyword			เป็น NVARCHAR	รับค่าคำค้น
--	2. degreeLevel		เป็น VARCHAR	รับค่าระดับปริญญา
--	3. faculty			เป็น VARCHAR	รับค่ารหัสคณะ
--	4. program			เป็น VARCHAR	รับค่าหลักสูตร
--	5. graduation		เป็น VARCHAR	รับค่าการชดใช้ตามสัญญากรณีก่อน / หลังสำเร็จการศึกษา
--	6. formula			เป็น VARCHAR	รับค่ารหัสเงื่อนไขการคิดระยะเวลาตามสัญญาและสูตรคำนวณเงินชดใช้ตามสัญญา
--	7. cancelledStatus	เป็น VARCHAR	รับค่าสถานะการยกเลิก
--  8. sortOrderBy		เป็น VARCHAR	รับค่าคอลัมภ์ที่ต้องการเรียงลำดับ
--  9. sortExpression	เป็น VARCHAR	รับค่าวิธีการเรียงลำดับ
-- =============================================
ALTER PROCEDURE [dbo].[sp_ecpGetListIndemnityAgreement]
(
	@graduation VARCHAR(2) = NULL,
	@degreeLevel NVARCHAR(2) = NULL,
	@faculty VARCHAR(15) = NULL,
	@program VARCHAR(15) = NULL,	
	@formula VARCHAR(2) = NULL,
	@cancelledStatus VARCHAR(1) = NULL,
	@sortOrderBy VARCHAR(255) = NULL,
	@sortExpression VARCHAR(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON

	SET @graduation = LTRIM(RTRIM(@graduation))		
	SET @degreeLevel = LTRIM(RTRIM(@degreeLevel))
	SET @faculty = LTRIM(RTRIM(@faculty))
	SET @program = LTRIM(RTRIM(@program))			
	SET @formula = LTRIM(RTRIM(@formula))		
	SET @cancelledStatus = LTRIM(RTRIM(@cancelledStatus))
	SET @sortOrderBy = LTRIM(RTRIM(@sortOrderBy))
	SET @sortExpression = LTRIM(RTRIM(@sortExpression))
	
	DECLARE @sort VARCHAR(255) = ''
	
	SET @sortOrderBy = (CASE WHEN (@sortOrderBy IS NOT NULL) AND (LEN(@sortOrderBy) > 0) THEN @sortOrderBy ELSE 'Program' END)
	SET @sortExpression = (CASE WHEN (@sortExpression IS NOT NULL) AND (LEN(@sortExpression) > 0) THEN @sortExpression ELSE 'Ascending' END)
	SET @sort = (@sortOrderBy + ' ' + @sortExpression)

	SELECT	*
	FROM	(SELECT ROW_NUMBER() OVER(ORDER BY 
						CASE WHEN @sort = 'Case Graduation Ascending'			THEN ecpida.caseGraduation END ASC,
						CASE WHEN @sort = 'Degree Level Ascending'				THEN stddlv.priorityDegreeLevel END ASC,
						CASE WHEN @sort = 'Faculty Ascending'					THEN acaprg.facultyId END ASC,
						CASE WHEN @sort = 'Program Ascending'					THEN ecpida.ecpProgramContractId END ASC,
						CASE WHEN @sort = 'Amount Cash Ascending'				THEN ecpida.amountCash END ASC,
						CASE WHEN @sort = 'Period Work Ascending'				THEN ecpida.periodWorkAfterGraduation END ASC,
						CASE WHEN @sort = 'How to Calculate Payment Ascending'	THEN ecpida.ecpConditionFormulaCalculationId END ASC,
						CASE WHEN @sort = 'Cancelled Status Ascending'			THEN ecpida.cancelledStatus END ASC,
						CASE WHEN @sort = 'Action Date Ascending'				THEN ecpida.modifyDate END ASC,
						CASE WHEN @sort = 'Action Date Ascending'				THEN ecpida.createDate END ASC,

						CASE WHEN @sort = 'Case Graduation Descending'			THEN ecpida.caseGraduation END DESC,
						CASE WHEN @sort = 'Degree Level Descending'				THEN stddlv.priorityDegreeLevel END DESC,
						CASE WHEN @sort = 'Faculty Descending'					THEN acaprg.facultyId END DESC,
						CASE WHEN @sort = 'Program Descending'					THEN ecpida.ecpProgramContractId END DESC,
						CASE WHEN @sort = 'Amount Cash Descending'				THEN ecpida.amountCash END DESC,
						CASE WHEN @sort = 'Period Work Descending'				THEN ecpida.periodWorkAfterGraduation END DESC,
						CASE WHEN @sort = 'How to Calculate Payment Descending'	THEN ecpida.ecpConditionFormulaCalculationId END DESC,
						CASE WHEN @sort = 'Cancelled Status Descending'			THEN ecpida.cancelledStatus END DESC,
						CASE WHEN @sort = 'Action Date Descending'				THEN ecpida.modifyDate END DESC,
						CASE WHEN @sort = 'Action Date Descending'				THEN ecpida.createDate END DESC
					) AS rowNum,
					(ecpida.ecpProgramContractId + ecpida.caseGraduation) AS id,
					acaprg.facultyId,
					acafac.facultyCode,
					acafac.nameTh AS facultyNameTH,
					acafac.nameEn AS facultyNameEN,
					ecpida.ecpProgramContractId,
					acaprg.programCode,
					acaprg.majorCode,
					acaprg.groupNum,
					acaprg.nameTh AS programNameTH,
					acaprg.nameEn AS programNameEN,
					acaprg.dLevel AS degreeLevel,
					stddlv.thDegreeLevelName AS degreeLevelNameTH,
					stddlv.enDegreeLevelName AS degreeLevelNameEN,
					ecpida.caseGraduation,
					(
						CASE ecpida.caseGraduation
							WHEN 'bf' THEN 'ก่อนสำเร็จการศึกษา'
							WHEN 'af' THEN 'หลังสำเร็จการศึกษา'
							ELSE NULL
						END					
					) AS caseGraduationNameTH,
					(
						CASE ecpida.caseGraduation
							WHEN 'bf' THEN 'Before Graduation'
							WHEN 'af' THEN 'After Graduation'
							ELSE NULL
						END					
					) AS caseGraduationNameEN,
					ecpida.amountCash,
					ecpida.periodWorkAfterGraduation,
					ecpida.ecpConditionFormulaCalculationId,
					('วิธีที่ ' + CONVERT(VARCHAR, ecpcfc.id)) AS conditionFormulaCalculationNameTH,
					('How to ' + CONVERT(VARCHAR, ecpcfc.id)) AS conditionFormulaCalculationNameEN,
					ecpida.cancelledStatus,
					ecpida.createDate,
					ecpida.modifyDate
			 FROM	Infinity..ecpIndemnityAgreement AS ecpida INNER JOIN
					Infinity..ecpProgramContract AS ecppgc ON ecpida.ecpProgramContractId = ecppgc.acaProgramId INNER JOIN
					Infinity..acaProgram AS acaprg ON ecppgc.acaProgramId = acaprg.id LEFT JOIN
					Infinity..acaFaculty AS acafac ON acaprg.facultyId = acafac.id LEFT JOIN
					Infinity..stdDegreeLevel AS stddlv ON acaprg.dLevel = stddlv.id INNER JOIN
					Infinity..ecpConditionFormulaCalculation AS ecpcfc ON ecpida.ecpConditionFormulaCalculationId = ecpcfc.id INNER JOIN
					Infinity..ecpFormulaCalculation AS ecpfcc ON ecpcfc.ecpFormulaCalculationId = ecpfcc.id
			 WHERE	(acaprg.cancelStatus IS NULL) AND
					(ecppgc.cancelledStatus = 'N') AND
					(ecpcfc.cancelledStatus = 'N') AND
					(ecpfcc.cancelledStatus = 'N') AND
					(
						(1 = (CASE WHEN (@graduation IS NOT NULL AND LEN(@graduation) > 0) THEN 0 ELSE 1 END)) OR
						(ecpida.caseGraduation = @graduation)
					) AND
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
						(ecpida.ecpProgramContractId = @program)
					) AND
					(
						(1 = (CASE WHEN (@formula IS NOT NULL AND LEN(@formula) > 0) THEN 0 ELSE 1 END)) OR
						(ecpida.ecpConditionFormulaCalculationId = @formula)
					) AND
					(
						(1 = (CASE WHEN (@cancelledStatus IS NOT NULL AND LEN(@cancelledStatus) > 0) THEN 0 ELSE 1 END)) OR					 						
						(ecpida.cancelledStatus = @cancelledStatus)
					)) AS ecpida

	SELECT	COUNT(ecpida.ecpProgramContractId)
	FROM	Infinity..ecpIndemnityAgreement AS ecpida INNER JOIN
			Infinity..ecpProgramContract AS ecppgc ON ecpida.ecpProgramContractId = ecppgc.acaProgramId INNER JOIN
			Infinity..acaProgram AS acaprg ON ecppgc.acaProgramId = acaprg.id LEFT JOIN
			Infinity..acaFaculty AS acafac ON acaprg.facultyId = acafac.id LEFT JOIN
			Infinity..stdDegreeLevel AS stddlv ON acaprg.dLevel = stddlv.id INNER JOIN
			Infinity..ecpConditionFormulaCalculation AS ecpcfc ON ecpida.ecpConditionFormulaCalculationId = ecpcfc.id INNER JOIN
			Infinity..ecpFormulaCalculation AS ecpfcc ON ecpcfc.ecpFormulaCalculationId = ecpfcc.id
	WHERE	(acaprg.cancelStatus IS NULL)
END
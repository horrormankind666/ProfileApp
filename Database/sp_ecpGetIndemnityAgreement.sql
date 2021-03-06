USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_ecpGetIndemnityAgreement]    Script Date: 18/1/2559 13:00:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๔/๐๑/๒๕๕๙>
-- Description	: <สำหรับแสดงข้อมูลเกณฑ์การชดใช้ตามสัญญา>
--	1. id	เป็น VARCHAR	รับค่ารหัสเกณฑ์การชดใช้ตามสัญญา
-- =============================================
ALTER PROCEDURE [dbo].[sp_ecpGetIndemnityAgreement]
(
	@id VARCHAR(20) = NULL
)
AS
BEGIN
	SET NOCOUNT ON

	SET @id = LTRIM(RTRIM(@id))		

	SELECT	(ecpida.ecpProgramContractId + ecpida.caseGraduation) AS id,
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
			ecpida.cancelledStatus
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
			((ecpida.ecpProgramContractId + ecpida.caseGraduation) = @id)
END
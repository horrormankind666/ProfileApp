USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_ecpGetConditionFormulaCalculation]    Script Date: 14/1/2559 15:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๒/๐๑/๒๕๕๙>
-- Description	: <สำหรับแสดงข้อมูลเงื่อนไขการคิดระยะเวลาตามสัญญาและสูตรคำนวณเงินชดใช้ตามสัญญา>
--  1. id	เป็น VARCHAR	รับค่ารหัสเงื่อนไขการคิดระยะเวลาตามสัญญาและสูตรคำนวณเงินชดใช้ตามสัญญา
-- =============================================
ALTER PROCEDURE [dbo].[sp_ecpGetConditionFormulaCalculation]
(
	@id VARCHAR(2) = NULL
)
AS
BEGIN
	SET NOCOUNT ON

	SET @id = LTRIM(RTRIM(@id))		

	SELECT	ecpcfc.id,
			ecpcfc.conditionCalculation,
			('วิธีที่ ' + CONVERT(VARCHAR, ecpcfc.id)) AS conditionFormulaCalculationNameTH,
			('How to ' + CONVERT(VARCHAR, ecpcfc.id)) AS conditionFormulaCalculationNameEN,
			ecpcfc.ecpFormulaCalculationId,
			ecpfcc.formula AS formulaCalculation,
			('สูตรที่ ' + ecpfcc.formula) AS formulaCalculationNameTH,
			('Formula ' + ecpfcc.formula) AS formulaCalculationNameEN,
			ecpcfc.cancelledStatus
	FROM	Infinity..ecpConditionFormulaCalculation AS ecpcfc INNER JOIN
			Infinity..ecpFormulaCalculation AS ecpfcc ON ecpcfc.ecpFormulaCalculationId = ecpfcc.id
	WHERE	(ecpfcc.cancelledStatus = 'N') AND
			(ecpcfc.id = @id)
END
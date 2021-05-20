SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๑/๐๑/๒๕๕๙>
-- Description	: <สำหรับแสดงข้อมูลสูตรคำนวณเงินชดใช้ตามสัญญา>
--  1. id	เป็น VARCHAR	รับค่ารหัสสูตรคำนวณเงินชดใช้ตามสัญญา
-- =============================================
CREATE PROCEDURE [dbo].[sp_ecpGetFormulaCalculation]
(
	@id VARCHAR(2) = NULL
)
AS
BEGIN
	SET NOCOUNT ON

	SET @id = LTRIM(RTRIM(@id))		

	SELECT	ecpfcc.id,
			ecpfcc.formula AS formulaCalculation,
			('สูตรที่ ' + ecpfcc.formula) AS formulaCalculationNameTH,
			('Formula ' + ecpfcc.formula) AS formulaCalculationNameEN,
			ecpfcc.cancelledStatus
	FROM	Infinity..ecpFormulaCalculation AS ecpfcc
	WHERE	(ecpfcc.id = @id)
END
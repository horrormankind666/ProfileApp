USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_ecpGetListConditionFormulaCalculation]    Script Date: 14/1/2559 7:36:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๑/๐๑/๒๕๕๙>
-- Description	: <สำหรับแสดงข้อมูลเงื่อนไขการคิดระยะเวลาตามสัญญาและสูตรคำนวณเงินชดใช้ตามสัญญา>
--	1. keyword				เป็น NVARCHAR	รับค่าคำค้น
--	2. formula				เป็น VARCHAR	รับค่ารหัสสูตรคำนวณเงินชดใช้ตามสัญญา
--	3. cancelledStatus		เป็น VARCHAR	รับค่าสถานะการยกเลิก
--  4. sortOrderBy			เป็น VARCHAR	รับค่าคอลัมภ์ที่ต้องการเรียงลำดับ
--  5. sortExpression		เป็น VARCHAR	รับค่าวิธีการเรียงลำดับ
-- =============================================
ALTER PROCEDURE [dbo].[sp_ecpGetListConditionFormulaCalculation]
(
	@keyword NVARCHAR(MAX) = NULL,
	@formula VARCHAR(2) = NULL,
	@cancelledStatus VARCHAR(1) = NULL,
	@sortOrderBy VARCHAR(255) = NULL,
	@sortExpression VARCHAR(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON

	SET @keyword = LTRIM(RTRIM(@keyword))
	SET @formula = LTRIM(RTRIM(@formula))
	SET @cancelledStatus = LTRIM(RTRIM(@cancelledStatus))
	SET @sortOrderBy = LTRIM(RTRIM(@sortOrderBy))
	SET @sortExpression = LTRIM(RTRIM(@sortExpression))
	
	DECLARE @sort VARCHAR(255) = ''
	
	SET @sortOrderBy = (CASE WHEN (@sortOrderBy IS NOT NULL) AND (LEN(@sortOrderBy) > 0) THEN @sortOrderBy ELSE 'Condition' END)
	SET @sortExpression = (CASE WHEN (@sortExpression IS NOT NULL) AND (LEN(@sortExpression) > 0) THEN @sortExpression ELSE 'Ascending' END)
	SET @sort = (@sortOrderBy + ' ' + @sortExpression)

	SELECT	*
	FROM	(SELECT ROW_NUMBER() OVER(ORDER BY 
						CASE WHEN @sort = 'Condition Ascending'			THEN ecpcfc.id END ASC,
						CASE WHEN @sort = 'Formula Ascending'			THEN ecpfcc.formula END ASC,
						CASE WHEN @sort = 'Cancelled Status Ascending'	THEN ecpcfc.cancelledStatus END ASC,
						CASE WHEN @sort = 'Action Date Ascending'		THEN ecpcfc.modifyDate END ASC,
						CASE WHEN @sort = 'Action Date Ascending'		THEN ecpcfc.createDate END ASC,

						CASE WHEN @sort = 'Condition Descending'		THEN ecpcfc.id END DESC,
						CASE WHEN @sort = 'Formula Descending'			THEN ecpfcc.formula END DESC,
						CASE WHEN @sort = 'Cancelled Status Descending'	THEN ecpcfc.cancelledStatus END DESC,
						CASE WHEN @sort = 'Action Date Descending'		THEN ecpcfc.modifyDate END DESC,
						CASE WHEN @sort = 'Action Date Descending'		THEN ecpcfc.createDate END DESC
					) AS rowNum,
					ecpcfc.id,
					ecpcfc.conditionCalculation,
					('วิธีที่ ' + CONVERT(VARCHAR, ecpcfc.id)) AS conditionFormulaCalculationNameTH,
					('How to ' + CONVERT(VARCHAR, ecpcfc.id)) AS conditionFormulaCalculationNameEN,
					ecpcfc.ecpFormulaCalculationId,
					ecpfcc.formula AS formulaCalculation,
					('สูตรที่ ' + ecpfcc.formula) AS formulaCalculationNameTH,
					('Formula ' + ecpfcc.formula) AS formulaCalculationNameEN,
					ecpcfc.cancelledStatus,
					ecpcfc.createDate,
					ecpcfc.modifyDate
			 FROM	Infinity..ecpConditionFormulaCalculation AS ecpcfc INNER JOIN
					Infinity..ecpFormulaCalculation AS ecpfcc ON ecpcfc.ecpFormulaCalculationId = ecpfcc.id
			 WHERE	(ecpfcc.cancelledStatus = 'N') AND
					(
						(1 = (CASE WHEN (@keyword IS NOT NULL AND LEN(@keyword) > 0) THEN 0 ELSE 1 END)) OR	
						(ecpcfc.conditionCalculation LIKE ('%' + @keyword + '%'))
					) AND
					(
						(1 = (CASE WHEN (@formula IS NOT NULL AND LEN(@formula) > 0) THEN 0 ELSE 1 END)) OR
						(ecpcfc.ecpFormulaCalculationId = @formula)
					) AND
					(
						(1 = (CASE WHEN (@cancelledStatus IS NOT NULL AND LEN(@cancelledStatus) > 0) THEN 0 ELSE 1 END)) OR					 						
						(ecpcfc.cancelledStatus = @cancelledStatus)
					)) AS ecpcfc

	SELECT	COUNT(ecpcfc.id)
	FROM	Infinity..ecpConditionFormulaCalculation AS ecpcfc INNER JOIN
			Infinity..ecpFormulaCalculation AS ecpfcc ON ecpcfc.ecpFormulaCalculationId = ecpfcc.id
END
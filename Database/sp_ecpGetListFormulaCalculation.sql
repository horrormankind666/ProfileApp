USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_ecpGetListFormulaCalculation]    Script Date: 13/1/2559 13:43:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๑/๐๑/๒๕๕๙>
-- Description	: <สำหรับแสดงข้อมูลสูตรคำนวณเงินชดใช้ตามสัญญา>
--	1. cancelledStatus		เป็น VARCHAR	รับค่าสถานะการยกเลิก
--  2. sortOrderBy			เป็น VARCHAR	รับค่าคอลัมภ์ที่ต้องการเรียงลำดับ
--  3. sortExpression		เป็น VARCHAR	รับค่าวิธีการเรียงลำดับ
-- =============================================
ALTER PROCEDURE [dbo].[sp_ecpGetListFormulaCalculation]
(
	@cancelledStatus VARCHAR(1) = NULL,
	@sortOrderBy VARCHAR(255) = NULL,
	@sortExpression VARCHAR(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON

	SET @cancelledStatus = LTRIM(RTRIM(@cancelledStatus))
	SET @sortOrderBy = LTRIM(RTRIM(@sortOrderBy))
	SET @sortExpression = LTRIM(RTRIM(@sortExpression))
	
	DECLARE @sort VARCHAR(255) = ''
	
	SET @sortOrderBy = (CASE WHEN (@sortOrderBy IS NOT NULL) AND (LEN(@sortOrderBy) > 0) THEN @sortOrderBy ELSE 'Formula' END)
	SET @sortExpression = (CASE WHEN (@sortExpression IS NOT NULL) AND (LEN(@sortExpression) > 0) THEN @sortExpression ELSE 'Ascending' END)
	SET @sort = (@sortOrderBy + ' ' + @sortExpression)

	SELECT	*
	FROM	(SELECT ROW_NUMBER() OVER(ORDER BY 
						CASE WHEN @sort = 'Formula Ascending'			THEN ecpfcc.formula END ASC,
						CASE WHEN @sort = 'Cancelled Status Ascending'	THEN ecpfcc.cancelledStatus END ASC,
						CASE WHEN @sort = 'Action Date Ascending'		THEN ecpfcc.modifyDate END ASC,
						CASE WHEN @sort = 'Action Date Ascending'		THEN ecpfcc.createDate END ASC,

						CASE WHEN @sort = 'Formula Descending'			THEN ecpfcc.formula END DESC,
						CASE WHEN @sort = 'Cancelled Status Descending'	THEN ecpfcc.cancelledStatus END DESC,
						CASE WHEN @sort = 'Action Date Descending'		THEN ecpfcc.modifyDate END DESC,
						CASE WHEN @sort = 'Action Date Descending'		THEN ecpfcc.createDate END DESC
					) AS rowNum,
					ecpfcc.id,
					ecpfcc.formula AS formulaCalculation,
					('สูตรที่ ' + ecpfcc.formula) AS formulaCalculationNameTH,
					('Formula ' + ecpfcc.formula) AS formulaCalculationNameEN,
					ecpfcc.cancelledStatus,
					ecpfcc.createDate,
					ecpfcc.modifyDate
			 FROM	Infinity..ecpFormulaCalculation AS ecpfcc
			 WHERE	(
						(1 = (CASE WHEN (@cancelledStatus IS NOT NULL AND LEN(@cancelledStatus) > 0) THEN 0 ELSE 1 END)) OR					 
						(ecpfcc.cancelledStatus = @cancelledStatus)
					)) AS ecpfcc

	SELECT	COUNT(ecpfcc.id)
	FROM	Infinity..ecpFormulaCalculation AS ecpfcc
END
USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_plcGetListCountry]    Script Date: 04-08-2016 16:29:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๘/๐๕/๒๕๕๘>
-- Description	: <สำหรับแสดงข้อมูลประเทศ>
--	1. keyword			เป็น NVARCHAR	รับค่าคำค้น
--	2. cancelledStatus	เป็น VARCHAR	รับค่าสถานะการยกเลิก
--  3. sortOrderBy		เป็น VARCHAR	รับค่าคอลัมภ์ที่ต้องการเรียงลำดับ
--  4. sortExpression	เป็น VARCHAR	รับค่าวิธีการเรียงลำดับ
-- =============================================
-- example [sp_plcGetListCountry]  '','','','' // odd test

ALTER PROCEDURE [dbo].[sp_plcGetListCountry] 
(
	@keyword NVARCHAR(MAX) = NULL,
	@cancelledStatus VARCHAR(1) = NULL,
	@sortOrderBy VARCHAR(255) = NULL,
	@sortExpression VARCHAR(255) = NULL	
)
AS
BEGIN
	SET NOCOUNT ON

	SET @keyword = LTRIM(RTRIM(@keyword))
	SET @cancelledStatus = LTRIM(RTRIM(@cancelledStatus))
	SET @sortOrderBy = LTRIM(RTRIM(@sortOrderBy))
	SET @sortExpression = LTRIM(RTRIM(@sortExpression))	
	
	DECLARE @sort VARCHAR(255) = ''
	
	SET @sortOrderBy = (CASE WHEN (@sortOrderBy IS NOT NULL) AND (LEN(@sortOrderBy) > 0) THEN @sortOrderBy ELSE 'ID' END)
	SET @sortExpression = (CASE WHEN (@sortExpression IS NOT NULL) AND (LEN(@sortExpression) > 0) THEN @sortExpression ELSE 'Ascending' END)
	SET @sort = (@sortOrderBy + ' ' + @sortExpression)
	
	SELECT	plccon.id,
			plccon.countryNameTH,
			plccon.countryNameEN,
			plccon.isoCountryCodes2Letter,
			plccon.isoCountryCodes3Letter,
			plccon.cancelledStatus,
			plccon.createDate,
			plccon.modifyDate
	INTO	#plcTemp1
	FROM	plcCountry AS plccon
	WHERE	(1 = (CASE WHEN (LEN(ISNULL(@keyword, '')) > 0) THEN 0 ELSE 1 END) OR
				(ISNULL(plccon.id, '') LIKE ('%' + @keyword + '%')) OR
			 	(ISNULL(plccon.countryNameTH, '') LIKE ('%' + @keyword + '%')) OR
			 	(ISNULL(plccon.countryNameEN, '') LIKE ('%' + @keyword + '%')) OR
			 	(ISNULL(plccon.isoCountryCodes2Letter, '') LIKE ('%' + @keyword + '%')) OR
			 	(ISNULL(plccon.isoCountryCodes3Letter, '') LIKE ('%' + @keyword + '%'))) AND
			(1 = (CASE WHEN (LEN(ISNULL(@cancelledStatus, '')) > 0) THEN 0 ELSE 1 END) OR plccon.cancelledStatus = @cancelledStatus)

	SELECT	ROW_NUMBER() OVER(ORDER BY 
				CASE WHEN @sort = 'ID Ascending'				THEN id END ASC,						
				CASE WHEN @sort = 'Full Name ( TH ) Ascending'	THEN countryNameTH END ASC,
				CASE WHEN @sort = 'Full Name ( EN ) Ascending'	THEN countryNameEN END ASC,
				CASE WHEN @sort = 'ISO ALPHA-2 Ascending'		THEN isoCountryCodes2Letter END ASC,
				CASE WHEN @sort = 'ISO ALPHA-3 Ascending'		THEN isoCountryCodes3Letter END ASC,						
				CASE WHEN @sort = 'Cancelled Status Ascending'	THEN cancelledStatus END ASC,
				CASE WHEN @sort = 'Create Date Ascending'		THEN createDate END ASC,
				CASE WHEN @sort = 'Modify Date Ascending'		THEN modifyDate END ASC,
						
				CASE WHEN @sort = 'ID Descending'				THEN id END DESC,						
				CASE WHEN @sort = 'Full Name ( TH ) Descending'	THEN countryNameTH END DESC,
				CASE WHEN @sort = 'Full Name ( EN ) Descending'	THEN countryNameEN END DESC,
				CASE WHEN @sort = 'ISO ALPHA-2 Descending'		THEN isoCountryCodes2Letter END DESC,
				CASE WHEN @sort = 'ISO ALPHA-3 Descending'		THEN isoCountryCodes3Letter END DESC,						
				CASE WHEN @sort = 'Cancelled Status Descending'	THEN cancelledStatus END DESC,
				CASE WHEN @sort = 'Create Date Descending'		THEN createDate END DESC,
				CASE WHEN @sort = 'Modify Date Descending'		THEN modifyDate END DESC
			) AS rowNum,
			*
	FROM	#plcTemp1
END
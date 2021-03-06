USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_perGetListNationality]    Script Date: 04-08-2016 15:28:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๕/๐๕/๒๕๕๘>
-- Description	: <สำหรับแสดงข้อมูลสัญชาติ & เชื้อชาติ>
--	1. keyword			เป็น NVARCHAR	รับค่าคำค้น
--	2. cancelledStatus	เป็น VARCHAR	รับค่าสถานะการยกเลิก
--  3. sortOrderBy		เป็น VARCHAR	รับค่าคอลัมภ์ที่ต้องการเรียงลำดับ
--  4. sortExpression	เป็น VARCHAR	รับค่าวิธีการเรียงลำดับ
-- =============================================
ALTER PROCEDURE [dbo].[sp_perGetListNationality]
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
	
	SELECT	pernat.id,
			pernat.thNationalityName AS nationalityNameTH,
			pernat.enNationalityName AS nationalityNameEN,
			pernat.isoCountryCodes2Letter,
			pernat.isoCountryCodes3Letter,
			pernat.cancel AS cancelledStatus,
			pernat.createDate,
			pernat.modifyDate
	INTO	#perTemp1
	FROM	perNationality AS pernat
	WHERE	(1 = (CASE WHEN (LEN(ISNULL(@keyword, '')) > 0) THEN 0 ELSE 1 END) OR	
				(ISNULL(pernat.id, '') LIKE ('%' + @keyword + '%')) OR
			 	(ISNULL(pernat.thNationalityName, '') LIKE ('%' + @keyword + '%')) OR
			 	(ISNULL(pernat.enNationalityName, '') LIKE ('%' + @keyword + '%')) OR
			 	(ISNULL(pernat.isoCountryCodes2Letter, '') LIKE ('%' + @keyword + '%')) OR
			 	(ISNULL(pernat.isoCountryCodes3Letter, '') LIKE ('%' + @keyword + '%'))) AND
			(1 = (CASE WHEN (LEN(ISNULL(@cancelledStatus, '')) > 0) THEN 0 ELSE 1 END) OR pernat.cancel = @cancelledStatus)

	SELECT	ROW_NUMBER() OVER(ORDER BY
				CASE WHEN @sort = 'ID Ascending'				THEN id END ASC,						
				CASE WHEN @sort = 'Full Name ( TH ) Ascending'	THEN nationalityNameTH END ASC,
				CASE WHEN @sort = 'Full Name ( EN ) Ascending'	THEN nationalityNameEN END ASC,						
				CASE WHEN @sort = 'ISO ALPHA-2 Ascending'		THEN isoCountryCodes2Letter END ASC,
				CASE WHEN @sort = 'ISO ALPHA-3 Ascending'		THEN isoCountryCodes3Letter END ASC,						
				CASE WHEN @sort = 'Cancelled Status Ascending'	THEN cancelledStatus END ASC,
				CASE WHEN @sort = 'Create Date Ascending'		THEN createDate END ASC,
				CASE WHEN @sort = 'Modify Date Ascending'		THEN modifyDate END ASC,
						
				CASE WHEN @sort = 'ID Descending'				THEN id END DESC,						
				CASE WHEN @sort = 'Full Name ( TH ) Descending'	THEN nationalityNameTH END DESC,
				CASE WHEN @sort = 'Full Name ( EN ) Descending'	THEN nationalityNameEN END DESC,						
				CASE WHEN @sort = 'ISO ALPHA-2 Descending'		THEN isoCountryCodes2Letter END DESC,
				CASE WHEN @sort = 'ISO ALPHA-3 Descending'		THEN isoCountryCodes3Letter END DESC,						
				CASE WHEN @sort = 'Cancelled Status Descending'	THEN cancelledStatus END DESC,
				CASE WHEN @sort = 'Create Date Descending'		THEN createDate END DESC,
				CASE WHEN @sort = 'Modify Date Descending'		THEN modifyDate END DESC						
			) AS rowNum,				
			*
	FROM	#perTemp1
END
USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_hcsGetListHospital]    Script Date: 05-08-2016 14:07:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๗/๐๕/๒๕๕๘>
-- Description	: <สำหรับแสดงข้อมูลหน่วยบริการสุขภาพ>
--	1. keyword			เป็น NVARCHAR	รับค่าคำค้น
--	2. cancelledStatus	เป็น VARCHAR	รับค่าสถานะการยกเลิก
--  3. sortOrderBy		เป็น VARCHAR	รับค่าคอลัมภ์ที่ต้องการเรียงลำดับ
--  4. sortExpression	เป็น VARCHAR	รับค่าวิธีการเรียงลำดับ
-- =============================================
ALTER PROCEDURE [dbo].[sp_hcsGetListHospital]
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
	
	SELECT	hcshpt.id,
			hcshpt.thHospitalName AS hospitalNameTH,
			hcshpt.enHospitalName AS hospitalNameEN,
			hcshpt.cancel AS cancelledStatus,
			hcshpt.createDate,
			hcshpt.modifyDate
	INTO	#hcsTemp1
	FROM	hcsHospital AS hcshpt
	WHERE	(1 = (CASE WHEN (LEN(ISNULL(@keyword, '')) > 0) THEN 0 ELSE 1 END) OR
				(ISNULL(hcshpt.id, '') LIKE ('%' + @keyword + '%')) OR
				(ISNULL(hcshpt.thHospitalName, '') LIKE ('%' + @keyword + '%')) OR
				(ISNULL(hcshpt.enHospitalName, '') LIKE ('%' + @keyword + '%'))) AND						
			(1 = (CASE WHEN (LEN(ISNULL(@cancelledStatus, '')) > 0) THEN 0 ELSE 1 END) OR hcshpt.cancel = @cancelledStatus)

	SELECT	ROW_NUMBER() OVER(ORDER BY  
				CASE WHEN @sort = 'ID Ascending'				THEN id END ASC,						
				CASE WHEN @sort = 'Name ( TH ) Ascending'		THEN hospitalNameTH END ASC,
				CASE WHEN @sort = 'Name ( EN ) Ascending'		THEN hospitalNameEN END ASC,						
				CASE WHEN @sort = 'Cancelled Status Ascending'	THEN cancelledStatus END ASC,
				CASE WHEN @sort = 'Create Date Ascending'		THEN createDate END ASC,
				CASE WHEN @sort = 'Modify Date Ascending'		THEN modifyDate END ASC,
						
				CASE WHEN @sort = 'ID Descending'				THEN id END DESC,						
				CASE WHEN @sort = 'Name ( TH ) Descending'		THEN hospitalNameTH END DESC,
				CASE WHEN @sort = 'Name ( EN ) Descending'		THEN hospitalNameEN END DESC,						
				CASE WHEN @sort = 'Cancelled Status Descending'	THEN cancelledStatus END DESC,
				CASE WHEN @sort = 'Create Date Descending'		THEN createDate END DESC,
				CASE WHEN @sort = 'Modify Date Descending'		THEN modifyDate END DESC												
			) AS rowNum,
			*
	FROM	#hcsTemp1
END
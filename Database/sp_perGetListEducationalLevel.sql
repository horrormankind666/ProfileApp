USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_perGetListEducationalLevel]    Script Date: 04-08-2016 16:07:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๕/๐๕/๒๕๕๘>
-- Description	: <สำหรับแสดงข้อมูลระดับการศึกษา>
--	1. keyword			เป็น NVARCHAR	รับค่าคำค้น
--	2. cancelledStatus	เป็น VARCHAR	รับค่าสถานะการยกเลิก
--  3. sortOrderBy		เป็น VARCHAR	รับค่าคอลัมภ์ที่ต้องการเรียงลำดับ
--  4. sortExpression	เป็น VARCHAR	รับค่าวิธีการเรียงลำดับ
-- =============================================
ALTER PROCEDURE [dbo].[sp_perGetListEducationalLevel]
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
	
	DECLARE @sort VARCHAR(MAX) = ''
	
	SET @sortOrderBy = (CASE WHEN (@sortOrderBy IS NOT NULL) AND (LEN(@sortOrderBy) > 0) THEN @sortOrderBy ELSE 'ID' END)
	SET @sortExpression = (CASE WHEN (@sortExpression IS NOT NULL) AND (LEN(@sortExpression) > 0) THEN @sortExpression ELSE 'Ascending' END)
	SET @sort = (@sortOrderBy + ' ' + @sortExpression)

	SELECT	peredl.id,
			peredl.thEducationalLevelName AS educationalLevelNameTH,
			peredl.enEducationalLevelName AS educationalLevelNameEN,
			peredl.cancel AS cancelledStatus,
			peredl.createDate,
			peredl.modifyDate
	INTO	#perTemp1
	FROM	perEducationalLevel AS peredl
	WHERE	(1 = (CASE WHEN (LEN(ISNULL(@keyword, '')) > 0) THEN 0 ELSE 1 END) OR
				(ISNULL(peredl.id, '') LIKE ('%' + @keyword + '%')) OR
			 	(ISNULL(peredl.thEducationalLevelName, '') LIKE ('%' + @keyword + '%')) OR
			 	(ISNULL(peredl.enEducationalLevelName, '') LIKE ('%' + @keyword + '%'))) AND
			(1 = (CASE WHEN (LEN(ISNULL(@cancelledStatus, '')) > 0) THEN 0 ELSE 1 END) OR peredl.cancel = @cancelledStatus)

	SELECT	ROW_NUMBER() OVER(ORDER BY 
				CASE WHEN @sort = 'ID Ascending'				THEN id END ASC,						
				CASE WHEN @sort = 'Full Name ( TH ) Ascending'	THEN educationalLevelNameTH END ASC,
				CASE WHEN @sort = 'Full Name ( EN ) Ascending'	THEN educationalLevelNameEN END ASC,						
				CASE WHEN @sort = 'Cancelled Status Ascending'	THEN cancelledStatus END ASC,
				CASE WHEN @sort = 'Create Date Ascending'		THEN createDate END ASC,
				CASE WHEN @sort = 'Modify Date Ascending'		THEN modifyDate END ASC,
						
				CASE WHEN @sort = 'ID Descending'				THEN id END DESC,
				CASE WHEN @sort = 'Full Name ( TH ) Descending'	THEN educationalLevelNameTH END DESC,
				CASE WHEN @sort = 'Full Name ( EN ) Descending'	THEN educationalLevelNameEN END DESC,
				CASE WHEN @sort = 'Cancelled Status Descending'	THEN cancelledStatus END DESC,
				CASE WHEN @sort = 'Create Date Descending'		THEN createDate END DESC,
				CASE WHEN @sort = 'Modify Date Descending'		THEN modifyDate END DESC
			) AS rowNum,
			*
	FROM	#perTemp1
END
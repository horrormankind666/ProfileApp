USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_perGetListImpairments]    Script Date: 15-06-2016 15:06:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๘/๐๕/๒๕๕๘>
-- Description	: <สำหรับแสดงข้อมูลความบกพร่อง>
--	1. keyword			เป็น NVARCHAR	รับค่าคำค้น
--	2. cancelledStatus	เป็น VARCHAR	รับค่าสถานะการยกเลิก
--  3. sortOrderBy		เป็น VARCHAR	รับค่าคอลัมภ์ที่ต้องการเรียงลำดับ
--  4. sortExpression	เป็น VARCHAR	รับค่าวิธีการเรียงลำดับ
-- =============================================
ALTER PROCEDURE [dbo].[sp_perGetListImpairments]
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
		
	SELECT	perimp.id
	INTO	#perTemp1
	FROM	perImpairments AS perimp

	SELECT	perimp.id,
			perimp.impairmentsNameTH,
			perimp.impairmentsNameEN,
			perimp.cancelledStatus,
			perimp.createDate,
			perimp.modifyDate
	INTO	#perTemp2
	FROM	#perTemp1 AS pertmp INNER JOIN
			perImpairments AS perimp ON pertmp.id = perimp.id 
	WHERE	(
				(1 = (CASE WHEN (@keyword IS NOT NULL AND LEN(@keyword) > 0) THEN 0 ELSE 1 END)) OR	
				(
			 		(perimp.id LIKE ('%' + @keyword + '%')) OR
			 		(perimp.impairmentsNameTH LIKE ('%' + @keyword + '%')) OR
			 		(perimp.impairmentsNameEN LIKE ('%' + @keyword + '%'))
				)
			) AND
			(
				(1 = (CASE WHEN (@cancelledStatus IS NOT NULL AND LEN(@cancelledStatus) > 0) THEN 0 ELSE 1 END)) OR					 
				(perimp.cancelledStatus = @cancelledStatus)
			)

	SELECT	ROW_NUMBER() OVER(ORDER BY 
				CASE WHEN @sort = 'ID Ascending'				THEN id END ASC,			
				CASE WHEN @sort = 'Full Name ( TH ) Ascending'	THEN impairmentsNameTH END ASC,
				CASE WHEN @sort = 'Full Name ( EN ) Ascending'	THEN impairmentsNameEN END ASC,
				CASE WHEN @sort = 'Cancelled Status Ascending'	THEN cancelledStatus END ASC,
				CASE WHEN @sort = 'Create Date Ascending'		THEN createDate END ASC,
				CASE WHEN @sort = 'Modify Date Ascending'		THEN modifyDate END ASC,
						
				CASE WHEN @sort = 'ID Descending'				THEN id END DESC,			
				CASE WHEN @sort = 'Full Name ( TH ) Descending'	THEN impairmentsNameTH END DESC,
				CASE WHEN @sort = 'Full Name ( EN ) Descending'	THEN impairmentsNameEN END DESC,
				CASE WHEN @sort = 'Cancelled Status Descending'	THEN cancelledStatus END DESC,
				CASE WHEN @sort = 'Create Date Descending'		THEN createDate END DESC,
				CASE WHEN @sort = 'Modify Date Descending'		THEN modifyDate END DESC	
			) AS rowNum,
			*
	FROM	#perTemp2
		
	SELECT	COUNT(id)
	FROM	#perTemp1
END
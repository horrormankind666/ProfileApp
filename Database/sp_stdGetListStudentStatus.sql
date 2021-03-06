USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_stdGetListStudentStatus]    Script Date: 04-08-2016 16:22:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๘/๐๕/๒๕๕๘>
-- Description	: <สำหรับแสดงข้อมูลสถานภาพการเป็นนักศึกษา>
--	1. keyword			เป็น NVARCHAR	รับค่าคำค้น
--	2. cancelledStatus	เป็น VARCHAR	รับค่าสถานะการยกเลิก
--  3. sortOrderBy		เป็น VARCHAR	รับค่าคอลัมภ์ที่ต้องการเรียงลำดับ
--  4. sortExpression	เป็น VARCHAR	รับค่าวิธีการเรียงลำดับ
-- =============================================
ALTER PROCEDURE [dbo].[sp_stdGetListStudentStatus]
(
	@keyword NVARCHAR(MAX) = NULL,
	@cancelledStatus VARCHAR(MAX) = NULL,
	@sortOrderBy VARCHAR(MAX) = NULL,
	@sortExpression VARCHAR(MAX) = NULL	
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
	
	SELECT	stdstt.id,
			stdstt.[group] groupSts,
			stdstt.nameTh AS statusTypeNameTH,
			stdstt.nameEn AS statusTypeNameEN,
			stdstt.cancelStatus AS cancelledStatus,
			stdstt.createdDate
	INTO	#stdTemp1
	FROM	stdStatusType AS stdstt
	WHERE	(1 = (CASE WHEN (LEN(ISNULL(@keyword, '')) > 0) THEN 0 ELSE 1 END) OR
				(ISNULL(stdstt.id, '') LIKE ('%' + @keyword + '%')) OR
			 	(ISNULL(stdstt.nameTh, '') LIKE ('%' + @keyword + '%')) OR
			 	(ISNULL(stdstt.nameEn, '') LIKE ('%' + @keyword + '%'))) AND
			(1 = (CASE WHEN (LEN(ISNULL(@cancelledStatus, '')) > 0) THEN 0 ELSE 1 END) OR 
				(stdstt.cancelStatus = (CASE WHEN (LEN(ISNULL(@cancelledStatus, '')) > 0) THEN @cancelledStatus ELSE '' END)))

	SELECT	ROW_NUMBER() OVER(ORDER BY 
				CASE WHEN @sort = 'ID Ascending'				THEN id END ASC,						
				CASE WHEN @sort = 'Full Name ( TH ) Ascending'	THEN statusTypeNameTH END ASC,
				CASE WHEN @sort = 'Full Name ( EN ) Ascending'	THEN statusTypeNameEN END ASC,
				CASE WHEN @sort = 'Cancelled Status Ascending'	THEN cancelledStatus END ASC,
				CASE WHEN @sort = 'Create Date Ascending'		THEN createdDate END ASC,
						
				CASE WHEN @sort = 'ID Descending'				THEN id END DESC,						
				CASE WHEN @sort = 'Full Name ( TH ) Descending'	THEN statusTypeNameTH END DESC,
				CASE WHEN @sort = 'Full Name ( EN ) Descending'	THEN statusTypeNameEN END DESC,
				CASE WHEN @sort = 'Cancelled Status Descending'	THEN cancelledStatus END DESC,
				CASE WHEN @sort = 'Create Date Descending'		THEN createdDate END DESC	
			) AS rowNum,
			*
	FROM	#stdTemp1
END
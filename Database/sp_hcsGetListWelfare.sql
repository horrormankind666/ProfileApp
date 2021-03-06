USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_hcsGetListWelfare]    Script Date: 04-01-2017 14:14:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๐๔/๐๑/๒๕๖๐>
-- Description	: <สำหรับแสดงข้อมูลสิทธิการรักษาพยาบาล>
--	1. keyword			เป็น NVARCHAR	รับค่าคำค้น
--	2. forPublicServant	เป็น VARCHAR	รับค่าสิทธิการรักษาพยาบาลสำหรับข้าราชการ
--	3. workedStatus		เป็น VARCHAR	รับค่าสถานะการทำงานของนักศึกษา
--	4. cancelledStatus	เป็น VARCHAR	รับค่าสถานะการยกเลิก
--  5. sortOrderBy		เป็น VARCHAR	รับค่าคอลัมภ์ที่ต้องการเรียงลำดับ
--  6. sortExpression	เป็น VARCHAR	รับค่าวิธีการเรียงลำดับ
-- =============================================
ALTER PROCEDURE [dbo].[sp_hcsGetListWelfare]
(
	@keyword VARCHAR(255) = NULL,
	@forPublicServant VARCHAR(1) = NULL,
	@workedStatus VARCHAR(1) = NULL,
	@cancelledStatus VARCHAR(1) = NULL,
	@sortOrderBy VARCHAR(50) = NULL,
	@sortExpression VARCHAR(50) = NULL	
)
AS
BEGIN
	SET NOCOUNT ON

	SET @keyword = LTRIM(RTRIM(@keyword))
	SET @forPublicServant = LTRIM(RTRIM(@forPublicServant))
	SET @workedStatus = LTRIM(RTRIM(@workedStatus))
	SET @cancelledStatus = LTRIM(RTRIM(@cancelledStatus))
	SET @sortOrderBy = LTRIM(RTRIM(@sortOrderBy))
	SET @sortExpression = LTRIM(RTRIM(@sortExpression))	
	
	DECLARE @sort VARCHAR(100) = ''
	
	SET @sortOrderBy = (CASE WHEN (@sortOrderBy IS NOT NULL) AND (LEN(@sortOrderBy) > 0) THEN @sortOrderBy ELSE 'ID' END)
	SET @sortExpression = (CASE WHEN (@sortExpression IS NOT NULL) AND (LEN(@sortExpression) > 0) THEN @sortExpression ELSE 'Ascending' END)
	SET @sort = (@sortOrderBy + ' ' + @sortExpression)	
	
	SELECT	hcswel.id,
			hcswel.nameTH,
			hcswel.nameEN,
			hcswel.forPublicServant,
			hcswel.workedStatus,
			hcswel.cancelledStatus,
			hcswel.createDate,
			hcswel.modifyDate
	INTO	#hcsTemp1
	FROM	hcsWelfare AS hcswel
	WHERE	(1 = (CASE WHEN (LEN(ISNULL(@keyword, '')) > 0) THEN 0 ELSE 1 END) OR
				(ISNULL(hcswel.id, '') LIKE ('%' + @keyword + '%')) OR
				(ISNULL(hcswel.nameTH, '') LIKE ('%' + @keyword + '%')) OR
				(ISNULL(hcswel.nameEN, '') LIKE ('%' + @keyword + '%'))) AND
			(1 = (CASE WHEN (LEN(ISNULL(@forPublicServant, '')) > 0) THEN 0 ELSE 1 END) OR hcswel.forPublicServant = @forPublicServant) AND
			(1 = (CASE WHEN (LEN(ISNULL(@workedStatus, '')) > 0) THEN 0 ELSE 1 END) OR hcswel.workedStatus = @workedStatus) AND
			(1 = (CASE WHEN (LEN(ISNULL(@cancelledStatus, '')) > 0) THEN 0 ELSE 1 END) OR hcswel.cancelledStatus = @cancelledStatus)

	SELECT	ROW_NUMBER() OVER(ORDER BY  
				CASE WHEN @sort = 'ID Ascending'					THEN id END ASC,						
				CASE WHEN @sort = 'Name ( TH ) Ascending'			THEN nameTH END ASC,
				CASE WHEN @sort = 'Name ( EN ) Ascending'			THEN nameEN END ASC,
				CASE WHEN @sort = 'For Public Servant Ascending'	THEN forPublicServant END ASC,
				CASE WHEN @sort = 'Worked Status Ascending'			THEN workedStatus END ASC,
				CASE WHEN @sort = 'Cancelled Status Ascending'		THEN cancelledStatus END ASC,
				CASE WHEN @sort = 'Create Date Ascending'			THEN createDate END ASC,
				CASE WHEN @sort = 'Modify Date Ascending'			THEN modifyDate END ASC,
						
				CASE WHEN @sort = 'ID Descending'					THEN id END DESC,						
				CASE WHEN @sort = 'Name ( TH ) Descending'			THEN nameTH END DESC,
				CASE WHEN @sort = 'Name ( EN ) Descending'			THEN nameEN END DESC,
				CASE WHEN @sort = 'For Public Servant Descending'	THEN forPublicServant END ASC,
				CASE WHEN @sort = 'Worked Status Descending'		THEN workedStatus END ASC,
				CASE WHEN @sort = 'Cancelled Status Descending'		THEN cancelledStatus END DESC,
				CASE WHEN @sort = 'Create Date Descending'			THEN createDate END DESC,
				CASE WHEN @sort = 'Modify Date Descending'			THEN modifyDate END DESC												
			) AS rowNum,
			*
	FROM	#hcsTemp1
END
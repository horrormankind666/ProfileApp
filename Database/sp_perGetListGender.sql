USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_perGetListGender]    Script Date: 04-08-2016 15:25:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๕/๐๕/๒๕๕๘>
-- Description	: <สำหรับแสดงข้อมูลเพศ>
--	1. keyword			เป็น NVARCHAR	รับค่าคำค้น
--	2. cancelledStatus	เป็น VARCHAR	รับค่าสถานะการยกเลิก
--  3. sortOrderBy		เป็น VARCHAR	รับค่าคอลัมภ์ที่ต้องการเรียงลำดับ
--  4. sortExpression	เป็น VARCHAR	รับค่าวิธีการเรียงลำดับ
-- =============================================
ALTER PROCEDURE [dbo].[sp_perGetListGender]
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

	SELECT	pergen.id,
			pergen.thGenderFullName AS genderFullNameTH,
			pergen.thGenderInitials AS genderInitialsTH,
			pergen.enGenderFullName AS genderFullNameEN,
			pergen.enGenderInitials AS genderInitialsEN,
			pergen.cancel AS cancelledStatus,
			pergen.createDate,
			pergen.modifyDate
	INTO	#perTemp1
	FROM	perGender AS pergen
	WHERE	(1 = (CASE WHEN (LEN(ISNULL(@keyword, '')) > 0) THEN 0 ELSE 1 END) OR	
				(ISNULL(pergen.id, '') LIKE ('%' + @keyword + '%')) OR
			 	(ISNULL(pergen.thGenderFullName, '') LIKE ('%' + @keyword + '%')) OR
			 	(ISNULL(pergen.thGenderInitials, '') LIKE ('%' + @keyword + '%')) OR
			 	(ISNULL(pergen.enGenderFullName, '') LIKE ('%' + @keyword + '%')) OR
			 	(ISNULL(pergen.enGenderInitials, '') LIKE ('%' + @keyword + '%'))) AND
			(1 = (CASE WHEN (LEN(ISNULL(@cancelledStatus, '')) > 0) THEN 0 ELSE 1 END) OR pergen.cancel = @cancelledStatus)
						 
	SELECT	ROW_NUMBER() OVER(ORDER BY 
				CASE WHEN @sort = 'ID Ascending'				THEN id END ASC,						
				CASE WHEN @sort = 'Full Name ( TH ) Ascending'	THEN genderFullNameTH END ASC,
				CASE WHEN @sort = 'Initials ( TH ) Ascending'	THEN genderInitialsTH END ASC,						
				CASE WHEN @sort = 'Full Name ( EN ) Ascending'	THEN genderFullNameEN END ASC,
				CASE WHEN @sort = 'Initials ( EN ) Ascending'	THEN genderInitialsEN END ASC,						
				CASE WHEN @sort = 'Cancelled Status Ascending'	THEN cancelledStatus END ASC,
				CASE WHEN @sort = 'Create Date Ascending'		THEN createDate END ASC,
				CASE WHEN @sort = 'Modify Date Ascending'		THEN modifyDate END ASC,
						
				CASE WHEN @sort = 'ID Descending'				THEN id END DESC,
				CASE WHEN @sort = 'Full Name ( TH ) Descending'	THEN genderFullNameTH END DESC,
				CASE WHEN @sort = 'Initials ( TH ) Descending'	THEN genderInitialsTH END DESC,
				CASE WHEN @sort = 'Full Name ( EN ) Descending'	THEN genderFullNameEN END DESC,
				CASE WHEN @sort = 'Initials ( EN ) Descending'	THEN genderInitialsEN END DESC,
				CASE WHEN @sort = 'Cancelled Status Descending'	THEN cancelledStatus END DESC,
				CASE WHEN @sort = 'Create Date Descending'		THEN createDate END DESC,
				CASE WHEN @sort = 'Modify Date Descending'		THEN modifyDate END DESC
			) AS rowNum,
			*
	FROM	#perTemp1
END
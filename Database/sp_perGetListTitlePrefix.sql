USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_perGetListTitlePrefix]    Script Date: 04-08-2016 15:17:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๕/๐๕/๒๕๕๘>
-- Description	: <สำหรับแสดงข้อมูลคำนำหน้าชื่อ>
--	1. keyword			เป็น NVARCHAR	รับค่าคำค้น
--  2. gender			เป็น NVARCHAR	รับค่าเพศ
--	3. cancelledStatus	เป็น VARCHAR	รับค่าสถานะการยกเลิก
--  4. sortOrderBy		เป็น VARCHAR	รับค่าคอลัมภ์ที่ต้องการเรียงลำดับ
--  5. sortExpression	เป็น VARCHAR	รับค่าวิธีการเรียงลำดับ
-- =============================================
ALTER PROCEDURE [dbo].[sp_perGetListTitlePrefix]
(
	@keyword NVARCHAR(MAX) = NULL,
	@gender NVARCHAR(2) = NULL,	
	@cancelledStatus VARCHAR(1) = NULL,
	@sortOrderBy VARCHAR(255) = NULL,
	@sortExpression VARCHAR(255) = NULL
)	
AS
BEGIN
	SET NOCOUNT ON
	
	SET @keyword = LTRIM(RTRIM(@keyword))
	SET @gender = LTRIM(RTRIM(@gender))
	SET @cancelledStatus = LTRIM(RTRIM(@cancelledStatus))
	SET @sortOrderBy = LTRIM(RTRIM(@sortOrderBy))
	SET @sortExpression = LTRIM(RTRIM(@sortExpression))	
	
	DECLARE @sort VARCHAR(255) = ''
	
	SET @sortOrderBy = (CASE WHEN (@sortOrderBy IS NOT NULL) AND (LEN(@sortOrderBy) > 0) THEN @sortOrderBy ELSE 'ID' END)
	SET @sortExpression = (CASE WHEN (@sortExpression IS NOT NULL) AND (LEN(@sortExpression) > 0) THEN @sortExpression ELSE 'Ascending' END)
	SET @sort = (@sortOrderBy + ' ' + @sortExpression)

	SELECT	pertpl.id,
			pertpl.thTitleFullName AS titlePrefixFullNameTH,
			pertpl.thTitleInitials AS titlePrefixInitialsTH,
			pertpl.thDescription AS descriptionTH,
			pertpl.enTitleFullName AS titlePrefixFullNameEN,
			pertpl.enTitleInitials AS titlePrefixInitialsEN,
			pertpl.enDescription AS descriptionEN,
			pertpl.perGenderId, 
			pergen.thGenderFullName AS genderFullNameTH,
			pergen.thGenderInitials AS genderInitialsTH,
			pergen.enGenderFullName AS genderFullNameEN,
			pergen.enGenderInitials AS genderInitialsEN,
			pertpl.cancel AS cancelledStatus,
			pertpl.createDate,
			pertpl.modifyDate
	INTO	#pertemp1
	FROM	perTitlePrefix AS pertpl LEFT JOIN
			perGender AS pergen ON pertpl.perGenderId = pergen.id
	WHERE	(1 = (CASE WHEN (LEN(ISNULL(@keyword, '')) > 0) THEN 0 ELSE 1 END) OR	
				(ISNULL(pertpl.id, '') LIKE ('%' + @keyword + '%')) OR
			 	(ISNULL(pertpl.thTitleFullName, '') LIKE ('%' + @keyword + '%')) OR
			 	(ISNULL(pertpl.thTitleInitials, '') LIKE ('%' + @keyword + '%')) OR
			 	(ISNULL(pertpl.thDescription, '') LIKE ('%' + @keyword + '%')) OR
			 	(ISNULL(pertpl.enTitleFullName, '') LIKE ('%' + @keyword + '%')) OR
			 	(ISNULL(pertpl.enTitleInitials, '') LIKE ('%' + @keyword + '%')) OR
			 	(ISNULL(pertpl.enDescription, '') LIKE ('%' + @keyword + '%'))) AND
			(1 = (CASE WHEN (LEN(ISNULL(@gender, '')) > 0) THEN 0 ELSE 1 END) OR
				(pergen.id = @gender) OR
				(pergen.enGenderInitials = @gender) OR
				(pertpl.perGenderId IS NULL)) AND
			(1 = (CASE WHEN (LEN(ISNULL(@cancelledStatus, '')) > 0) THEN 0 ELSE 1 END) OR pertpl.cancel = @cancelledStatus)

	SELECT	ROW_NUMBER() OVER(ORDER BY 
				CASE WHEN @sort = 'ID Ascending'				THEN id END ASC,						
				CASE WHEN @sort = 'Full Name ( TH ) Ascending'	THEN titlePrefixFullNameTH END ASC,
				CASE WHEN @sort = 'Initials ( TH ) Ascending'	THEN titlePrefixInitialsTH END ASC,						
				CASE WHEN @sort = 'Full Name ( EN ) Ascending'	THEN titlePrefixFullNameEN END ASC,
				CASE WHEN @sort = 'Initials ( EN ) Ascending'	THEN titlePrefixInitialsEN END ASC,
				CASE WHEN @sort = 'Gender Ascending'			THEN genderInitialsEN END ASC,
				CASE WHEN @sort = 'Cancelled Status Ascending'	THEN cancelledStatus END ASC,
				CASE WHEN @sort = 'Create Date Ascending'		THEN createDate END ASC,
				CASE WHEN @sort = 'Modify Date Ascending'		THEN modifyDate END ASC,
						
				CASE WHEN @sort = 'ID Descending'				THEN id END DESC,
				CASE WHEN @sort = 'Full Name ( TH ) Descending'	THEN titlePrefixFullNameTH END DESC,
				CASE WHEN @sort = 'Initials ( TH ) Descending'	THEN titlePrefixInitialsTH END DESC,
				CASE WHEN @sort = 'Full Name ( EN ) Descending'	THEN titlePrefixFullNameEN END DESC,
				CASE WHEN @sort = 'Initials ( EN ) Descending'	THEN titlePrefixInitialsEN END DESC,
				CASE WHEN @sort = 'Gender Descending'			THEN genderInitialsEN END DESC,
				CASE WHEN @sort = 'Cancelled Status Descending'	THEN cancelledStatus END DESC,
				CASE WHEN @sort = 'Create Date Descending'		THEN createDate END DESC,
				CASE WHEN @sort = 'Modify Date Descending'		THEN modifyDate END DESC
			) AS rowNum,
			*
	FROM	#perTemp1
END
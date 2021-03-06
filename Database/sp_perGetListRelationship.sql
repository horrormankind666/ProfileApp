USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_perGetListRelationship]    Script Date: 04-08-2016 16:00:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๕/๐๕/๒๕๕๘>
-- Description	: <สำหรับแสดงข้อมูลความสัมพันธ์ในครอบครัว>
--	1. keyword			เป็น NVARCHAR	รับค่าคำค้น
--  2. gender			เป็น NVARCHAR	รับค่าเพศ
--	3. relationship		เป็น VARCHAR	รับค่ารหัสความสัมพันธ์ในครอบครัว
--	4. cancelledStatus	เป็น VARCHAR	รับค่าสถานะการยกเลิก
--  5. sortOrderBy		เป็น VARCHAR	รับค่าคอลัมภ์ที่ต้องการเรียงลำดับ
--  6. sortExpression	เป็น VARCHAR	รับค่าวิธีการเรียงลำดับ
-- =============================================
ALTER PROCEDURE [dbo].[sp_perGetListRelationship]
(
	@keyword NVARCHAR(MAX) = NULL,
	@gender NVARCHAR(2) = NULL,	
	@relationship VARCHAR(MAX) = NULL,
	@cancelledStatus VARCHAR(1) = NULL,
	@sortOrderBy VARCHAR(255) = NULL,
	@sortExpression VARCHAR(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON

	SET @keyword = LTRIM(RTRIM(@keyword))
	SET @gender = LTRIM(RTRIM(@gender))	
	SET @relationship = LTRIM(RTRIM(@relationship))
	SET @cancelledStatus = LTRIM(RTRIM(@cancelledStatus))
	SET @sortOrderBy = LTRIM(RTRIM(@sortOrderBy))
	SET @sortExpression = LTRIM(RTRIM(@sortExpression))	
	
	DECLARE @sort VARCHAR(MAX) = ''
	
	SET @sortOrderBy = (CASE WHEN (@sortOrderBy IS NOT NULL) AND (LEN(@sortOrderBy) > 0) THEN @sortOrderBy ELSE 'ID' END)
	SET @sortExpression = (CASE WHEN (@sortExpression IS NOT NULL) AND (LEN(@sortExpression) > 0) THEN @sortExpression ELSE 'Ascending' END)
	SET @sort = (@sortOrderBy + ' ' + @sortExpression)
	
	SELECT	perrls.id,
			perrls.relationshipNameTH,
			perrls.relationshipNameEN,
			perrls.perGenderId,
			pergen.enGenderInitials AS genderInitialsEN,
			perrls.cancelledStatus,
			perrls.createDate,
			perrls.modifyDate
	INTO	#perTemp1		
	FROM	perRelationship AS perrls LEFT JOIN
			perGender AS pergen ON perrls.perGenderId = pergen.id
	WHERE	(1 = (CASE WHEN (LEN(ISNULL(@keyword, '')) > 0) THEN 0 ELSE 1 END) OR
				(ISNULL(perrls.id, '') LIKE ('%' + @keyword + '%')) OR
			 	(ISNULL(perrls.relationshipNameTH, '') LIKE ('%' + @keyword + '%')) OR
			 	(ISNULL(perrls.relationshipNameEN, '') LIKE ('%' + @keyword + '%'))) AND
			(1 = (CASE WHEN (LEN(ISNULL(@gender, '')) > 0) THEN 0 ELSE 1 END) OR
				(pergen.id = @gender) OR
				(pergen.enGenderInitials = @gender) OR
				(perrls.perGenderId IS NULL)) AND
			(1 = (CASE WHEN (LEN(ISNULL(@relationship, '')) > 0) THEN 0 ELSE 1 END) OR CHARINDEX(perrls.id, @relationship) != 0) AND					  
			(1 = (CASE WHEN (LEN(ISNULL(@cancelledStatus, '')) > 0) THEN 0 ELSE 1 END) OR perrls.cancelledStatus = @cancelledStatus)
	
	SELECT	ROW_NUMBER() OVER(ORDER BY 
				CASE WHEN @sort = 'ID Ascending'				THEN id END ASC,						
				CASE WHEN @sort = 'Full Name ( TH ) Ascending'	THEN relationshipNameTH END ASC,
				CASE WHEN @sort = 'Full Name ( EN ) Ascending'	THEN relationshipNameEN END ASC,
				CASE WHEN @sort = 'Gender Ascending'			THEN genderInitialsEN END ASC,
				CASE WHEN @sort = 'Cancelled Status Ascending'	THEN cancelledStatus END ASC,
				CASE WHEN @sort = 'Create Date Ascending'		THEN createDate END ASC,
				CASE WHEN @sort = 'Modify Date Ascending'		THEN modifyDate END ASC,
						
				CASE WHEN @sort = 'ID Descending'				THEN id END DESC,						
				CASE WHEN @sort = 'Full Name ( TH ) Descending'	THEN relationshipNameTH END DESC,
				CASE WHEN @sort = 'Full Name ( EN ) Descending'	THEN relationshipNameEN END DESC,
				CASE WHEN @sort = 'Gender Descending'			THEN genderInitialsEN END DESC,
				CASE WHEN @sort = 'Cancelled Status Descending'	THEN cancelledStatus END DESC,
				CASE WHEN @sort = 'Create Date Descending'		THEN createDate END DESC,
				CASE WHEN @sort = 'Modify Date Descending'		THEN modifyDate END DESC	
			) AS rowNum,
			*
	FROM	#perTemp1
END
USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_hcsGetListRegistrationForm]    Script Date: 05-08-2016 14:15:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๗/๐๕/๒๕๕๘>
-- Description	: <สำหรับแสดงข้อมูลแบบฟอร์มบริการสุขภาพ>
--	1. keyword			เป็น NVARCHAR	รับค่าคำค้น
--	2. forPublicServant	เป็น VARCHAR	รับค่าแบบฟอร์มสำหรับข้าราชการ
--	3. cancelledStatus	เป็น VARCHAR	รับค่าสถานะการยกเลิก
--  4. sortOrderBy		เป็น VARCHAR	รับค่าคอลัมภ์ที่ต้องการเรียงลำดับ
--  5. sortExpression	เป็น VARCHAR	รับค่าวิธีการเรียงลำดับ
-- =============================================
ALTER PROCEDURE [dbo].[sp_hcsGetListRegistrationForm]
(
	@keyword NVARCHAR(MAX) = NULL,
	@forPublicServant VARCHAR(1) = NULL,
	@cancelledStatus VARCHAR(1) = NULL,
	@sortOrderBy VARCHAR(255) = NULL,
	@sortExpression VARCHAR(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON

	SET @keyword = LTRIM(RTRIM(@keyword))
	SET @forPublicServant = LTRIM(RTRIM(@forPublicServant))
	SET @cancelledStatus = LTRIM(RTRIM(@cancelledStatus))
	SET @sortOrderBy = LTRIM(RTRIM(@sortOrderBy))
	SET @sortExpression = LTRIM(RTRIM(@sortExpression))	
	
	DECLARE @sort VARCHAR(255) = ''
	
	SET @sortOrderBy = (CASE WHEN (@sortOrderBy IS NOT NULL) AND (LEN(@sortOrderBy) > 0) THEN @sortOrderBy ELSE 'Order Form' END)
	SET @sortExpression = (CASE WHEN (@sortExpression IS NOT NULL) AND (LEN(@sortExpression) > 0) THEN @sortExpression ELSE 'Ascending' END)
	SET @sort = (@sortOrderBy + ' ' + @sortExpression)
	
	SELECT	hcsfrm.id,
			hcsfrm.thFormName AS formNameTH,
			hcsfrm.enFormName AS formNameEN,
			hcsfrm.forPublicServant,
			hcsfrm.orderForm,
			hcsfrm.cancel AS cancelledStatus,
			hcsfrm.createDate,
			hcsfrm.modifyDate
	INTO	#hcsTemp1
	FROM	hcsForm AS hcsfrm
	WHERE	(1 = (CASE WHEN (LEN(ISNULL(@keyword, '')) > 0) THEN 0 ELSE 1 END) OR
				(ISNULL(hcsfrm.id, '') LIKE ('%' + @keyword + '%')) OR
				(ISNULL(hcsfrm.thFormName, '') LIKE ('%' + @keyword + '%')) OR
				(ISNULL(hcsfrm.enFormName, '') LIKE ('%' + @keyword + '%'))) AND						
			(1 = (CASE WHEN (LEN(ISNULL(@forPublicServant, '')) > 0) THEN 0 ELSE 1 END) OR hcsfrm.forPublicServant = @forPublicServant) AND					
			(1 = (CASE WHEN (LEN(ISNULL(@cancelledStatus, '')) > 0) THEN 0 ELSE 1 END) OR hcsfrm.cancel = @cancelledStatus)

	SELECT	ROW_NUMBER() OVER(ORDER BY 
				CASE WHEN @sort = 'ID Ascending'					THEN id END ASC,						
				CASE WHEN @sort = 'Name ( TH ) Ascending'			THEN formNameTH END ASC,
				CASE WHEN @sort = 'Name ( EN ) Ascending'			THEN formNameEN END ASC,
				CASE WHEN @sort = 'For Public Servant Ascending'	THEN forPublicServant END ASC,
				CASE WHEN @sort = 'Order Form Ascending'			THEN orderForm END ASC,
				CASE WHEN @sort = 'Cancelled Status Ascending'		THEN cancelledStatus END ASC,
				CASE WHEN @sort = 'Create Date Ascending'			THEN createDate END ASC,
				CASE WHEN @sort = 'Modify Date Ascending'			THEN modifyDate END ASC,
						
				CASE WHEN @sort = 'ID Descending'					THEN id END DESC,						
				CASE WHEN @sort = 'Name ( TH ) Descending'			THEN formNameTH END DESC,
				CASE WHEN @sort = 'Name ( EN ) Descending'			THEN formNameEN END DESC,						
				CASE WHEN @sort = 'For Public Servant Descending'	THEN forPublicServant END DESC,	
				CASE WHEN @sort = 'Order Form Descending'			THEN orderForm END DESC,					
				CASE WHEN @sort = 'Cancelled Status Descending'		THEN cancelledStatus END DESC,
				CASE WHEN @sort = 'Create Date Descending'			THEN createDate END DESC,
				CASE WHEN @sort = 'Modify Date Descending'			THEN modifyDate END DESC												
			) AS rowNum,
			*
	FROM	#hcsTemp1
END
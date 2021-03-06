USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_ecpGetListInterestDefaulted]    Script Date: 13/1/2559 13:49:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๒/๐๑/๒๕๕๙>
-- Description	: <สำหรับแสดงข้อมูลดอกเบี้ยจากการผิดนัดชำระ>
--	1. keyword			เป็น NVARCHAR	รับค่าคำค้น
--	2. cancelledStatus	เป็น VARCHAR	รับค่าสถานะการยกเลิก
--  3. sortOrderBy		เป็น VARCHAR	รับค่าคอลัมภ์ที่ต้องการเรียงลำดับ
--  4. sortExpression	เป็น VARCHAR	รับค่าวิธีการเรียงลำดับ
-- =============================================
ALTER PROCEDURE [dbo].[sp_ecpGetListInterestDefaulted]
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
	
	SET @sortOrderBy = (CASE WHEN (@sortOrderBy IS NOT NULL) AND (LEN(@sortOrderBy) > 0) THEN @sortOrderBy ELSE 'Id' END)
	SET @sortExpression = (CASE WHEN (@sortExpression IS NOT NULL) AND (LEN(@sortExpression) > 0) THEN @sortExpression ELSE 'Ascending' END)
	SET @sort = (@sortOrderBy + ' ' + @sortExpression)

	SELECT	*
	FROM	(SELECT ROW_NUMBER() OVER(ORDER BY 
						CASE WHEN @sort = 'Id Ascending'							THEN ecpitr.id END ASC,
						CASE WHEN @sort = 'Interest in Contract Ascending'			THEN ecpitr.interestInContract END ASC,
						CASE WHEN @sort = 'Interest is not in Contract Ascending'	THEN ecpitr.interestNotInContract END ASC,
						CASE WHEN @sort = 'Cancelled Status Ascending'				THEN ecpitr.cancelledStatus END ASC,
						CASE WHEN @sort = 'Action Date Ascending'					THEN ecpitr.modifyDate END ASC,
						CASE WHEN @sort = 'Action Date Ascending'					THEN ecpitr.createDate END ASC,

						CASE WHEN @sort = 'Id Descending'							THEN ecpitr.id END DESC,
						CASE WHEN @sort = 'Interest in Contract Ascending'			THEN ecpitr.interestInContract END DESC,
						CASE WHEN @sort = 'Interest is not in Contract Ascending'	THEN ecpitr.interestNotInContract END DESC,
						CASE WHEN @sort = 'Cancelled Status Descending'				THEN ecpitr.cancelledStatus END DESC,
						CASE WHEN @sort = 'Action Date Descending'					THEN ecpitr.modifyDate END DESC,
						CASE WHEN @sort = 'Action Date Descending'					THEN ecpitr.createDate END DESC
					) AS rowNum,
					ecpitr.id,
					ecpitr.interestInContract,
					ecpitr.interestNotInContract,
					ecpitr.cancelledStatus,
					ecpitr.createDate,
					ecpitr.modifyDate
			 FROM	Infinity..ecpInterestDefaulted AS ecpitr
			 WHERE	(
						(1 = (CASE WHEN (@keyword IS NOT NULL AND LEN(@keyword) > 0) THEN 0 ELSE 1 END)) OR	
						(ecpitr.interestInContract LIKE ('%' + @keyword + '%')) OR
						(ecpitr.interestNotInContract LIKE ('%' + @keyword + '%'))

					) AND
					(
						(1 = (CASE WHEN (@cancelledStatus IS NOT NULL AND LEN(@cancelledStatus) > 0) THEN 0 ELSE 1 END)) OR					 						
						(ecpitr.cancelledStatus = @cancelledStatus)
					)) AS ecpitr

	SELECT	COUNT(ecpitr.id)
	FROM	Infinity..ecpInterestDefaulted AS ecpitr
END
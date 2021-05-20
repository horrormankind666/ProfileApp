USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_plcGetListDistrict]    Script Date: 04-08-2016 16:35:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๘/๐๕/๒๕๕๘>
-- Description	: <สำหรับแสดงข้อมูลอำเภอ>
--	1. keyword			เป็น NVARCHAR	รับค่าคำค้น
--	2. country			เป็น VARCHAR	รับค่ารหัสประเทศ
--	3. province			เป็น VARCHAR	รับค่ารหัสจังหวัด
--	4. cancelledStatus	เป็น VARCHAR	รับค่าสถานะการยกเลิก
--  5. sortOrderBy		เป็น VARCHAR	รับค่าคอลัมภ์ที่ต้องการเรียงลำดับ
--  6. sortExpression	เป็น VARCHAR	รับค่าวิธีการเรียงลำดับ
-- =============================================
ALTER PROCEDURE [dbo].[sp_plcGetListDistrict]
(
	@keyword NVARCHAR(MAX) = NULL,
	@country VARCHAR(3) = NULL,
	@province VARCHAR(3) = NULL,
	@cancelledStatus VARCHAR(1) = NULL,
	@sortOrderBy VARCHAR(255) = NULL,
	@sortExpression VARCHAR(255) = NULL	
)
AS
BEGIN
	SET NOCOUNT ON

	SET @keyword = LTRIM(RTRIM(@keyword))
	SET @country = LTRIM(RTRIM(@country))
	SET @province = LTRIM(RTRIM(@province))
	SET @cancelledStatus = LTRIM(RTRIM(@cancelledStatus))
	SET @sortOrderBy = LTRIM(RTRIM(@sortOrderBy))
	SET @sortExpression = LTRIM(RTRIM(@sortExpression))	
	
	DECLARE @sort VARCHAR(255) = ''
	
	SET @sortOrderBy = (CASE WHEN (@sortOrderBy IS NOT NULL) AND (LEN(@sortOrderBy) > 0) THEN @sortOrderBy ELSE 'ID' END)
	SET @sortExpression = (CASE WHEN (@sortExpression IS NOT NULL) AND (LEN(@sortExpression) > 0) THEN @sortExpression ELSE 'Ascending' END)
	SET @sort = (@sortOrderBy + ' ' + @sortExpression)

	SELECT	plcdst.id,
			plcpvn.plcCountryId,
			plccon.isoCountryCodes3Letter, 
			plcdst.plcProvinceId,
			plcpvn.provinceNameTH,
			plcpvn.provinceNameEN,
			plcdst.thDistrictName AS districtNameTH,
			plcdst.enDistrictName AS districtNameEN,
			plcdst.zipCode,
			plcdst.cancel AS cancelledStatus,
			plcdst.createDate,
			plcdst.modifyDate
	INTO	#plcTemp1
	FROM	plcDistrict AS plcdst INNER JOIN
			plcProvince AS plcpvn ON plcdst.plcProvinceId = plcpvn.id INNER JOIN
			plcCountry AS plccon ON plcpvn.plcCountryId = plccon.id
	WHERE	(1 = (CASE WHEN (LEN(ISNULL(@keyword, '')) > 0) THEN 0 ELSE 1 END) OR
				(ISNULL(plcdst.id, '') LIKE ('%' + @keyword + '%')) OR
			 	(ISNULL(plcdst.thDistrictName, '') LIKE ('%' + @keyword + '%')) OR
			 	(ISNULL(plcdst.enDistrictName, '') LIKE ('%' + @keyword + '%')) OR
			 	(ISNULL(plcdst.zipCode, '') LIKE ('%' + @keyword + '%'))) AND
			(1 = (CASE WHEN (LEN(ISNULL(@country, '')) > 0) THEN 0 ELSE 1 END) OR plcpvn.plcCountryId = @country) AND
			(1 = (CASE WHEN (LEN(ISNULL(@province, '')) > 0) THEN 0 ELSE 1 END) OR plcdst.plcProvinceId = @province) AND					 
			(1 = (CASE WHEN (LEN(ISNULL(@cancelledStatus, '')) > 0) THEN 0 ELSE 1 END) OR plcdst.cancel = @cancelledStatus)

	SELECT	ROW_NUMBER() OVER(ORDER BY 
				CASE WHEN @sort = 'ID Ascending'					THEN id END ASC,			
				CASE WHEN @sort = 'Country Ascending'				THEN isoCountryCodes3Letter END ASC,
				CASE WHEN @sort = 'Province ( TH ) Ascending'		THEN provinceNameTH END ASC,
				CASE WHEN @sort = 'Full Name ( TH ) Ascending'		THEN districtNameTH END ASC,
				CASE WHEN @sort = 'Province ( EN ) Ascending'		THEN provinceNameEN END ASC,
				CASE WHEN @sort = 'Full Name ( EN ) Ascending'		THEN districtNameEN END ASC,
				CASE WHEN @sort = 'ZIP / Postal Code Ascending'		THEN zipCode END ASC,
				CASE WHEN @sort = 'Cancelled Status Ascending'		THEN cancelledStatus END ASC,
				CASE WHEN @sort = 'Create Date Ascending'			THEN createDate END ASC,
				CASE WHEN @sort = 'Modify Date Ascending'			THEN modifyDate END ASC,
						
				CASE WHEN @sort = 'ID Descending'					THEN id END DESC,			
				CASE WHEN @sort = 'Country Descending'				THEN isoCountryCodes3Letter END DESC,
				CASE WHEN @sort = 'Province ( TH ) Descending'		THEN provinceNameTH END DESC,
				CASE WHEN @sort = 'Full Name ( TH ) Descending'		THEN districtNameTH END DESC,
				CASE WHEN @sort = 'Province ( EN ) Descending'		THEN provinceNameEN END DESC,
				CASE WHEN @sort = 'Full Name ( EN ) Descending'		THEN districtNameEN END DESC,
				CASE WHEN @sort = 'ZIP / Postal Code Descending'	THEN zipCode END DESC,
				CASE WHEN @sort = 'Cancelled Status Descending'		THEN cancelledStatus END DESC,
				CASE WHEN @sort = 'Create Date Descending'			THEN createDate END DESC,
				CASE WHEN @sort = 'Modify Date Descending'			THEN modifyDate END DESC	
			) AS rowNum,
			*
	FROM	#plcTemp1
END
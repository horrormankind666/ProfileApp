USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_udsGetListInstitute]    Script Date: 05-08-2016 13:55:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๐๒/๐๒/๒๕๕๙>
-- Description	: <สำหรับแสดงข้อมูลสถาบัน / โรงเรียนเฉพาะที่มีการส่งระเบียนแสดงผลการเรียนและต้องผ่านการอนุมัติ>
--	1. country			เป็น VARCHAR	รับค่ารหัสประเทศ
--	2. province			เป็น VARCHAR	รับค่ารหัสจังหวัด
--	3. cancelledStatus	เป็น VARCHAR	รับค่าสถานะการยกเลิก
--  4. sortOrderBy		เป็น VARCHAR	รับค่าคอลัมภ์ที่ต้องการเรียงลำดับ
--  5. sortExpression	เป็น VARCHAR	รับค่าวิธีการเรียงลำดับ
-- =============================================
ALTER PROCEDURE [dbo].[sp_udsGetListInstitute]
(
	@country VARCHAR(3) = NULL,
	@province VARCHAR(3) = NULL,
	@cancelledStatus VARCHAR(1) = NULL,
	@sortOrderBy VARCHAR(255) = NULL,
	@sortExpression VARCHAR(255) = NULL	
)
AS
BEGIN
	SET NOCOUNT ON

	SET @country = LTRIM(RTRIM(@country))
	SET @province = LTRIM(RTRIM(@province))
	SET @cancelledStatus = LTRIM(RTRIM(@cancelledStatus))
	SET @sortOrderBy = LTRIM(RTRIM(@sortOrderBy))
	SET @sortExpression = LTRIM(RTRIM(@sortExpression))	
	
	DECLARE @sort VARCHAR(255) = ''

	SET @sortOrderBy = (CASE WHEN (@sortOrderBy IS NOT NULL) AND (LEN(@sortOrderBy) > 0) THEN @sortOrderBy ELSE 'ID' END)
	SET @sortExpression = (CASE WHEN (@sortExpression IS NOT NULL) AND (LEN(@sortExpression) > 0) THEN @sortExpression ELSE 'Ascending' END)
	SET @sort = (@sortOrderBy + ' ' + @sortExpression)

	SELECT 	 perins.id,
			 plcpvn.plcCountryId,
			 plccon.isoCountryCodes3Letter, 
			 perins.plcProvinceId,
			 plcpvn.provinceNameTH,
			 plcpvn.provinceNameEN,
			 perins.institutelNameTH,
			 perins.institutelNameEN,
			 perins.cancelledStatus
	FROM	 udsUploadLog AS udsuds INNER JOIN
			 perInstitute AS perins ON udsuds.perInstituteIdTranscript = perins.id INNER JOIN
			 plcProvince AS plcpvn ON perins.plcProvinceId = plcpvn.id INNER JOIN
			 plcCountry AS plccon ON plcpvn.plcCountryId = plccon.id
	WHERE	 ((udsuds.transcriptfrontsideApprovalStatus + udsuds.transcriptbacksideApprovalStatus) = 'YY') AND 
			 (1 = (CASE WHEN (LEN(ISNULL(@country, '')) > 0) THEN 0 ELSE 1 END) OR plcpvn.plcCountryId = @country) AND
			 (1 = (CASE WHEN (LEN(ISNULL(@province, '')) > 0) THEN 0 ELSE 1 END) OR perins.plcProvinceId = @province) AND
			 (1 = (CASE WHEN (LEN(ISNULL(@cancelledStatus, '')) > 0) THEN 0 ELSE 1 END) OR perins.cancelledStatus = @cancelledStatus)
	GROUP BY perins.id,
			 plcpvn.plcCountryId,
			 plccon.isoCountryCodes3Letter, 
			 perins.plcProvinceId,
			 plcpvn.provinceNameTH,
			 plcpvn.provinceNameEN,
			 perins.institutelNameTH,
			 perins.institutelNameEN,
			 perins.cancelledStatus
	ORDER BY CASE WHEN @sort = 'ID Ascending'					THEN perins.id END ASC,			
			 CASE WHEN @sort = 'Country Ascending'				THEN plccon.isoCountryCodes3Letter END ASC,
			 CASE WHEN @sort = 'Province ( TH ) Ascending'		THEN plcpvn.provinceNameTH END ASC,
			 CASE WHEN @sort = 'Full Name ( TH ) Ascending'		THEN perins.institutelNameTH END ASC,
			 CASE WHEN @sort = 'Province ( EN ) Ascending'		THEN plcpvn.provinceNameEN END ASC,
			 CASE WHEN @sort = 'Full Name ( EN ) Ascending'		THEN perins.institutelNameEN END ASC,
			 CASE WHEN @sort = 'Cancelled Status Ascending'		THEN perins.cancelledStatus END ASC,
			 
			 CASE WHEN @sort = 'ID Descending'					THEN perins.id END DESC,			
			 CASE WHEN @sort = 'Country Descending'				THEN plccon.isoCountryCodes3Letter END DESC,
			 CASE WHEN @sort = 'Province ( TH ) Descending'		THEN plcpvn.provinceNameTH END DESC,
			 CASE WHEN @sort = 'Full Name ( TH ) Descending'	THEN perins.institutelNameTH END DESC,
			 CASE WHEN @sort = 'Province ( EN ) Descending'		THEN plcpvn.provinceNameEN END DESC,
			 CASE WHEN @sort = 'Full Name ( EN ) Descending'	THEN perins.institutelNameEN END DESC,
			 CASE WHEN @sort = 'Cancelled Status Descending'	THEN perins.cancelledStatus END DESC				 
END
USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_udsGetListCountry]    Script Date: 05-08-2016 13:53:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๐๒/๐๒/๒๕๕๙>
-- Description	: <สำหรับแสดงข้อมูลประเทศเฉพาะที่มีการส่งระเบียนแสดงผลการเรียนและต้องผ่านการอนุมัติ>
--	1. cancelledStatus	เป็น VARCHAR	รับค่าสถานะการยกเลิก
--  2. sortOrderBy		เป็น VARCHAR	รับค่าคอลัมภ์ที่ต้องการเรียงลำดับ
--  3. sortExpression	เป็น VARCHAR	รับค่าวิธีการเรียงลำดับ
-- =============================================
ALTER PROCEDURE [dbo].[sp_udsGetListCountry] 
(
	@cancelledStatus VARCHAR(1) = NULL,
	@sortOrderBy VARCHAR(255) = NULL,
	@sortExpression VARCHAR(255) = NULL	
)
AS
BEGIN
	SET NOCOUNT ON

	SET @cancelledStatus = LTRIM(RTRIM(@cancelledStatus))
	SET @sortOrderBy = LTRIM(RTRIM(@sortOrderBy))
	SET @sortExpression = LTRIM(RTRIM(@sortExpression))	
	
	DECLARE @sort VARCHAR(255) = ''
	
	SET @sortOrderBy = (CASE WHEN (@sortOrderBy IS NOT NULL) AND (LEN(@sortOrderBy) > 0) THEN @sortOrderBy ELSE 'ID' END)
	SET @sortExpression = (CASE WHEN (@sortExpression IS NOT NULL) AND (LEN(@sortExpression) > 0) THEN @sortExpression ELSE 'Ascending' END)
	SET @sort = (@sortOrderBy + ' ' + @sortExpression)
	
	SELECT	 plccon.id,
			 plccon.countryNameTH,
			 plccon.countryNameEN,
			 plccon.isoCountryCodes2Letter,
			 plccon.isoCountryCodes3Letter,
			 plccon.cancelledStatus
	FROM	 udsUploadLog AS udsuds INNER JOIN
			 perInstitute AS perins ON udsuds.perInstituteIdTranscript = perins.id INNER JOIN
			 plcProvince AS plcpvn ON perins.plcProvinceId = plcpvn.id INNER JOIN
			 plcCountry AS plccon ON plcpvn.plcCountryId = plccon.id
	WHERE	 ((udsuds.transcriptfrontsideApprovalStatus + udsuds.transcriptbacksideApprovalStatus) = 'YY') AND
			 (1 = (CASE WHEN (LEN(ISNULL(@cancelledStatus, '')) > 0) THEN 0 ELSE 1 END) OR plccon.cancelledStatus = @cancelledStatus)
	GROUP BY plccon.id,
			 plccon.countryNameTH,
			 plccon.countryNameEN,
			 plccon.isoCountryCodes2Letter,
			 plccon.isoCountryCodes3Letter,
			 plccon.cancelledStatus
	ORDER BY CASE WHEN @sort = 'ID Ascending'					THEN plccon.id END ASC,						
			 CASE WHEN @sort = 'Full Name ( TH ) Ascending'		THEN plccon.countryNameTH END ASC,
			 CASE WHEN @sort = 'Full Name ( EN ) Ascending'		THEN plccon.countryNameEN END ASC,
			 CASE WHEN @sort = 'ISO ALPHA-2 Ascending'			THEN plccon.isoCountryCodes2Letter END ASC,
			 CASE WHEN @sort = 'ISO ALPHA-3 Ascending'			THEN plccon.isoCountryCodes3Letter END ASC,						
			 CASE WHEN @sort = 'Cancelled Status Ascending'		THEN plccon.cancelledStatus END ASC,
						
			 CASE WHEN @sort = 'ID Descending'					THEN plccon.id END DESC,						
			 CASE WHEN @sort = 'Full Name ( TH ) Descending'	THEN plccon.countryNameTH END DESC,
			 CASE WHEN @sort = 'Full Name ( EN ) Descending'	THEN plccon.countryNameEN END DESC,
			 CASE WHEN @sort = 'ISO ALPHA-2 Descending'			THEN plccon.isoCountryCodes2Letter END DESC,
			 CASE WHEN @sort = 'ISO ALPHA-3 Descending'			THEN plccon.isoCountryCodes3Letter END DESC,						
			 CASE WHEN @sort = 'Cancelled Status Descending'	THEN plccon.cancelledStatus END DESC
END
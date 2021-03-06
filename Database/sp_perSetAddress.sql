USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_perSetAddress]    Script Date: 11/16/2015 16:16:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๒๘/๑๑/๒๕๕๖>
-- Description	: <สำหรับบันทึกข้อมูลตาราง perAddress ครั้งละ ๑ เรคคอร์ด>
--  1. action						เป็น VARCHAR	รับค่าการกระทำกับฐานข้อมูล
--  2. personId						เป็น VARCHAR	รับค่ารหัสบุคคล
--  3. countryPermanent				เป็น VARCHAR	รับค่ารหัสประเทศของที่อยู่ตามทะเบียนบ้าน
--  4. villagePermanent				เป็น NVARCHAR	รับค่าชื่อหมู่บ้านของที่อยู่ตามทะเบียนบ้าน
--  5. noPermanent					เป็น NVARCHAR	รับค่าบ้านเลขที่ของที่อยู่ตามทะเบียนบ้าน
--  6. mooPermanent					เป็น NVARCHAR	รับค่าหมู่ที่ของที่อยู่ตามทะเบียนบ้าน
--  7. soiPermanent					เป็น NVARCHAR	รับค่าซอยของที่อยู่ตามทะเบียนบ้าน
--  8. roadPermanent				เป็น NVARCHAR	รับค่าถนนของที่อยู่ตามทะเบียนบ้าน
--  9. subdistrictPermanent			เป็น VARCHAR	รับค่ารหัสตำบลของที่อยู่ตามทะเบียนบ้าน
-- 10. districtPermanent			เป็น VARCHAR	รับค่ารหัสอำเภอของที่อยู่ตามทะเบียนบ้าน
-- 11. provincePermanent			เป็น VARCHAR	รับค่ารหัสสถานที่หรือจังหวัดของที่อยู่ตามทะเบียนบ้าน
-- 12. zipCodePermanent				เป็น NVARCHAR	รับค่ารหัสไปรษณีย์ของที่อยู่ตามทะเบียนบ้าน
-- 13. phoneNumberPermanent			เป็น NVARCHAR	รับค่าเบอร์โทรศัพท์บ้านของที่อยู่ตามทะเบียนบ้าน
-- 14. mobileNumberPermanent		เป็น NVARCHAR	รับค่าเบอร์โทรศัพท์มือถือของที่อยู่ตามทะเบียนบ้าน
-- 15. faxNumberPermanent			เป็น NVARCHAR	รับค่าเบอร์แฟกซ์ของที่อยู่ตามทะเบียนบ้าน
-- 16. countryCurrent				เป็น VARCHAR	รับค่ารหัสประเทศของที่อยู่ปัจจุบันที่ติดต่อได้
-- 17. villageCurrent				เป็น NVARCHAR	รับค่าชื่อหมู่บ้านของที่อยู่ปัจจุบันที่ติดต่อได้
-- 18. noCurrent					เป็น NVARCHAR	รับค่าบ้านเลขที่ของที่อยู่ปัจจุบันที่ติดต่อได้
-- 19. mooCurrent					เป็น NVARCHAR	รับค่าหมู่ที่ของที่อยู่ปัจจุบันที่ติดต่อได้
-- 20. soiCurrent					เป็น NVARCHAR	รับค่าซอยของที่อยู่ปัจจุบันที่ติดต่อได้
-- 21. roadCurrent					เป็น NVARCHAR	รับค่าถนนของที่อยู่ปัจจุบันที่ติดต่อได้
-- 22. subdistrictCurrent			เป็น VARCHAR	รับค่ารหัสตำบลของที่อยู่ปัจจุบันที่ติดต่อได้
-- 23. districtCurrent				เป็น VARCHAR	รับค่ารหัสอำเภอของที่อยู่ปัจจุบันที่ติดต่อได้
-- 24. provinceCurrent				เป็น VARCHAR	รับค่ารหัสสถานที่หรือจังหวัดของที่อยู่ปัจจุบันที่ติดต่อได้
-- 25. zipCodeCurrent				เป็น NVARCHAR	รับค่ารหัสไปรษณีย์ของที่อยู่ปัจจุบันที่ติดต่อได้
-- 26. phoneNumberCurrent			เป็น NVARCHAR	รับค่าเบอร์โทรศัพท์บ้านของที่อยู่ปัจจุบันที่ติดต่อได้
-- 27. mobileNumberCurrent			เป็น NVARCHAR	รับค่าเบอร์โทรศัพท์มือถือของที่อยู่ปัจจุบันที่ติดต่อได้
-- 28. faxNumberCurrent				เป็น NVARCHAR	รับค่าเบอร์แฟกซ์ของที่อยู่ปัจจุบันที่ติดต่อได้
-- 29. by							เป็น NVARCHAR	รับค่าชื่อของผู้ที่กระทำกับฐานข้อมูล
-- 30. ip							เป็น VARCHAR	รับค่าหมายเลขไอพีของผู้ที่กระทำกับฐานข้อมูล
-- =============================================
ALTER PROCEDURE [dbo].[sp_perSetAddress]
(
	@action VARCHAR(10) = NULL,	
	@personId VARCHAR(10) = NULL,
	@countryPermanent VARCHAR(3) = NULL,
	@villagePermanent NVARCHAR(255) = NULL,
	@noPermanent NVARCHAR(100) = NULL,
	@mooPermanent NVARCHAR(100) = NULL,
	@soiPermanent NVARCHAR(100) = NULL,
	@roadPermanent NVARCHAR(255) = NULL,
	@subdistrictPermanent VARCHAR(7) = NULL,
	@districtPermanent VARCHAR(5) = NULL,
	@provincePermanent VARCHAR(3) = NULL,
	@zipCodePermanent NVARCHAR(10) = NULL,
	@phoneNumberPermanent NVARCHAR(50) = NULL,
	@mobileNumberPermanent NVARCHAR(50) = NULL,
	@faxNumberPermanent NVARCHAR(50) = NULL,
	@countryCurrent VARCHAR(3) = NULL,
	@villageCurrent NVARCHAR(255) = NULL,
	@noCurrent NVARCHAR(100) = NULL,
	@mooCurrent NVARCHAR(100) = NULL,
	@soiCurrent NVARCHAR(100) = NULL,
	@roadCurrent NVARCHAR(255) = NULL,
	@subdistrictCurrent VARCHAR(7) = NULL,
	@districtCurrent VARCHAR(5) = NULL,
	@provinceCurrent VARCHAR(3) = NULL,
	@zipCodeCurrent NVARCHAR(10) = NULL,
	@phoneNumberCurrent NVARCHAR(50) = NULL,
	@mobileNumberCurrent NVARCHAR(50) = NULL,
	@faxNumberCurrent NVARCHAR(50) = NULL,	
	@by NVARCHAR(255) = NULL,
	@ip VARCHAR(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	
	SET @action = LTRIM(RTRIM(@action))
	SET @personId = LTRIM(RTRIM(@personId))
	SET @countryPermanent = LTRIM(RTRIM(@countryPermanent))
	SET @villagePermanent = LTRIM(RTRIM(@villagePermanent))
	SET @noPermanent = LTRIM(RTRIM(@noPermanent))
	SET @mooPermanent = LTRIM(RTRIM(@mooPermanent))
	SET @soiPermanent = LTRIM(RTRIM(@soiPermanent))
	SET @roadPermanent = LTRIM(RTRIM(@roadPermanent))
	SET @subdistrictPermanent = LTRIM(RTRIM(@subdistrictPermanent))
	SET @districtPermanent = LTRIM(RTRIM(@districtPermanent))
	SET @provincePermanent = LTRIM(RTRIM(@provincePermanent))
	SET @zipCodePermanent = LTRIM(RTRIM(@zipCodePermanent))
	SET @phoneNumberPermanent = LTRIM(RTRIM(@phoneNumberPermanent))
	SET @mobileNumberPermanent = LTRIM(RTRIM(@mobileNumberPermanent))
	SET @faxNumberPermanent = LTRIM(RTRIM(@faxNumberPermanent))
	SET @countryCurrent = LTRIM(RTRIM(@countryCurrent))
	SET @villageCurrent = LTRIM(RTRIM(@villageCurrent))
	SET @noCurrent = LTRIM(RTRIM(@noCurrent))
	SET @mooCurrent = LTRIM(RTRIM(@mooCurrent))
	SET @soiCurrent = LTRIM(RTRIM(@soiCurrent))
	SET @roadCurrent = LTRIM(RTRIM(@roadCurrent))
	SET @subdistrictCurrent = LTRIM(RTRIM(@subdistrictCurrent))
	SET @districtCurrent = LTRIM(RTRIM(@districtCurrent))
	SET @provinceCurrent = LTRIM(RTRIM(@provinceCurrent))
	SET @zipCodeCurrent = LTRIM(RTRIM(@zipCodeCurrent))
	SET @phoneNumberCurrent = LTRIM(RTRIM(@phoneNumberCurrent))
	SET @mobileNumberCurrent = LTRIM(RTRIM(@mobileNumberCurrent))
	SET @faxNumberCurrent = LTRIM(RTRIM(@faxNumberCurrent))	
	SET @by = LTRIM(RTRIM(@by))
	SET @ip = LTRIM(RTRIM(@ip))
		
	DECLARE @table VARCHAR(50) = 'perAddress'
	DECLARE @rowCount INT = 0
	DECLARE @rowCountUpdate INT = 0
	DECLARE @value NVARCHAR(MAX) = NULL
	DECLARE	@strBlank VARCHAR(50) = '----------**********.........0.0000000000000000000'
	
	SET @action = UPPER(@action)
	
	IF (@action = 'INSERT' OR @action = 'UPDATE' OR @action = 'DELETE')
	BEGIN
		SET @value = 'perPersonId=' + (CASE WHEN (@personId IS NOT NULL AND LEN(@personId) > 0 AND CHARINDEX(@personId, @strBlank) = 0) THEN ('"' + @personId + '"') ELSE 'NULL' END) + ', ' +
					 'plcCountryIdPermanent=' + (CASE WHEN (@countryPermanent IS NOT NULL AND LEN(@countryPermanent) > 0 AND CHARINDEX(@countryPermanent, @strBlank) = 0) THEN ('"' + @countryPermanent + '"') ELSE 'NULL' END) + ', ' +
					 'villagePermanent=' + (CASE WHEN (@villagePermanent IS NOT NULL AND LEN(@villagePermanent) > 0 AND CHARINDEX(@villagePermanent, @strBlank) = 0) THEN ('"' + @villagePermanent + '"') ELSE 'NULL' END) + ', ' +
					 'noPermanent=' + (CASE WHEN (@noPermanent IS NOT NULL AND LEN(@noPermanent) > 0 AND CHARINDEX(@noPermanent, @strBlank) = 0) THEN ('"' + @noPermanent + '"') ELSE 'NULL' END) + ', ' +
					 'mooPermanent=' + (CASE WHEN (@mooPermanent IS NOT NULL AND LEN(@mooPermanent) > 0 AND CHARINDEX(@mooPermanent, @strBlank) = 0) THEN ('"' + @mooPermanent + '"') ELSE 'NULL' END) + ', ' +
					 'soiPermanent=' + (CASE WHEN (@soiPermanent IS NOT NULL AND LEN(@soiPermanent) > 0 AND CHARINDEX(@soiPermanent, @strBlank) = 0) THEN ('"' + @soiPermanent + '"') ELSE 'NULL' END) + ', ' +
					 'roadPermanent=' + (CASE WHEN (@roadPermanent IS NOT NULL AND LEN(@roadPermanent) > 0 AND CHARINDEX(@roadPermanent, @strBlank) = 0) THEN ('"' + @roadPermanent + '"') ELSE 'NULL' END) + ', ' +
					 'plcSubdistrictIdPermanent=' + (CASE WHEN (@subdistrictPermanent IS NOT NULL AND LEN(@subdistrictPermanent) > 0 AND CHARINDEX(@subdistrictPermanent, @strBlank) = 0) THEN ('"' + @subdistrictPermanent + '"') ELSE 'NULL' END) + ', ' +
					 'plcDistrictIdPermanent=' + (CASE WHEN (@districtPermanent IS NOT NULL AND LEN(@districtPermanent) > 0 AND CHARINDEX(@districtPermanent, @strBlank) = 0) THEN ('"' + @districtPermanent + '"') ELSE 'NULL' END) + ', ' +
					 'plcProvinceIdPermanent=' + (CASE WHEN (@provincePermanent IS NOT NULL AND LEN(@provincePermanent) > 0 AND CHARINDEX(@provincePermanent, @strBlank) = 0) THEN ('"' + @provincePermanent + '"') ELSE 'NULL' END) + ', ' +
					 'zipCodePermanent=' + (CASE WHEN (@zipCodePermanent IS NOT NULL AND LEN(@zipCodePermanent) > 0 AND CHARINDEX(@zipCodePermanent, @strBlank) = 0) THEN ('"' + @zipCodePermanent + '"') ELSE 'NULL' END) + ', ' +
					 'phoneNumberPermanent=' + (CASE WHEN (@phoneNumberPermanent IS NOT NULL AND LEN(@phoneNumberPermanent) > 0 AND CHARINDEX(@phoneNumberPermanent, @strBlank) = 0) THEN ('"' + @phoneNumberPermanent + '"') ELSE 'NULL' END) + ', ' +
					 'mobileNumberPermanent=' + (CASE WHEN (@mobileNumberPermanent IS NOT NULL AND LEN(@mobileNumberPermanent) > 0 AND CHARINDEX(@mobileNumberPermanent, @strBlank) = 0) THEN ('"' + @mobileNumberPermanent + '"') ELSE 'NULL' END) + ', ' +
					 'faxNumberPermanent=' + (CASE WHEN (@faxNumberPermanent IS NOT NULL AND LEN(@faxNumberPermanent) > 0 AND CHARINDEX(@faxNumberPermanent, @strBlank) = 0) THEN ('"' + @faxNumberPermanent + '"') ELSE 'NULL' END) + ', ' +
					 'plcCountryIdCurrent=' + (CASE WHEN (@countryCurrent IS NOT NULL AND LEN(@countryCurrent) > 0 AND CHARINDEX(@countryCurrent, @strBlank) = 0) THEN ('"' + @countryCurrent + '"') ELSE 'NULL' END) + ', ' +
					 'villageCurrent=' + (CASE WHEN (@villageCurrent IS NOT NULL AND LEN(@villageCurrent) > 0 AND CHARINDEX(@villageCurrent, @strBlank) = 0) THEN ('"' + @villageCurrent + '"') ELSE 'NULL' END) + ', ' +
					 'noCurrent=' + (CASE WHEN (@noCurrent IS NOT NULL AND LEN(@noCurrent) > 0 AND CHARINDEX(@noCurrent, @strBlank) = 0) THEN ('"' + @noCurrent + '"') ELSE 'NULL' END) + ', ' +
					 'mooCurrent=' + (CASE WHEN (@mooCurrent IS NOT NULL AND LEN(@mooCurrent) > 0 AND CHARINDEX(@mooCurrent, @strBlank) = 0) THEN ('"' + @mooCurrent + '"') ELSE 'NULL' END) + ', ' +
					 'soiCurrent=' + (CASE WHEN (@soiCurrent IS NOT NULL AND LEN(@soiCurrent) > 0 AND CHARINDEX(@soiCurrent, @strBlank) = 0) THEN ('"' + @soiCurrent + '"') ELSE 'NULL' END) + ', ' +
					 'roadCurrent=' + (CASE WHEN (@roadCurrent IS NOT NULL AND LEN(@roadCurrent) > 0 AND CHARINDEX(@roadCurrent, @strBlank) = 0) THEN ('"' + @roadCurrent + '"') ELSE 'NULL' END) + ', ' +
					 'plcSubdistrictIdCurrent=' + (CASE WHEN (@subdistrictCurrent IS NOT NULL AND LEN(@subdistrictCurrent) > 0 AND CHARINDEX(@subdistrictCurrent, @strBlank) = 0) THEN ('"' + @subdistrictCurrent + '"') ELSE 'NULL' END) + ', ' +
					 'plcDistrictIdCurrent=' + (CASE WHEN (@districtCurrent IS NOT NULL AND LEN(@districtCurrent) > 0 AND CHARINDEX(@districtCurrent, @strBlank) = 0) THEN ('"' + @districtCurrent + '"') ELSE 'NULL' END) + ', ' +
					 'plcProvinceIdCurrent=' + (CASE WHEN (@provinceCurrent IS NOT NULL AND LEN(@provinceCurrent) > 0 AND CHARINDEX(@provinceCurrent, @strBlank) = 0) THEN ('"' + @provinceCurrent + '"') ELSE 'NULL' END) + ', ' +
					 'zipCodeCurrent=' + (CASE WHEN (@zipCodeCurrent IS NOT NULL AND LEN(@zipCodeCurrent) > 0 AND CHARINDEX(@zipCodeCurrent, @strBlank) = 0) THEN ('"' + @zipCodeCurrent + '"') ELSE 'NULL' END) + ', ' +
					 'phoneNumberCurrent=' + (CASE WHEN (@phoneNumberCurrent IS NOT NULL AND LEN(@phoneNumberCurrent) > 0 AND CHARINDEX(@phoneNumberCurrent, @strBlank) = 0) THEN ('"' + @phoneNumberCurrent + '"') ELSE 'NULL' END) + ', ' +
					 'mobileNumberCurrent=' + (CASE WHEN (@mobileNumberCurrent IS NOT NULL AND LEN(@mobileNumberCurrent) > 0 AND CHARINDEX(@mobileNumberCurrent, @strBlank) = 0) THEN ('"' + @mobileNumberCurrent + '"') ELSE 'NULL' END) + ', ' +
					 'faxNumberCurrent=' + (CASE WHEN (@faxNumberCurrent IS NOT NULL AND LEN(@faxNumberCurrent) > 0 AND CHARINDEX(@faxNumberCurrent, @strBlank) = 0) THEN ('"' + @faxNumberCurrent + '"') ELSE 'NULL' END)
					 
		BEGIN TRY
			BEGIN TRAN
				IF (@action = 'INSERT')
				BEGIN
 					INSERT INTO perAddress
 					(
						perPersonId,
						plcCountryIdPermanent,
						villagePermanent,
						noPermanent,
						mooPermanent,
						soiPermanent,
						roadPermanent,						
						plcSubdistrictIdPermanent,
						plcDistrictIdPermanent,
						plcProvinceIdPermanent,
						zipCodePermanent,
						phoneNumberPermanent,
						mobileNumberPermanent,
						faxNumberPermanent,
						plcCountryIdCurrent,
						villageCurrent,
						noCurrent,
						mooCurrent,
						soiCurrent,
						roadCurrent,						
						plcSubdistrictIdCurrent,
						plcDistrictIdCurrent,
						plcProvinceIdCurrent,
						zipCodeCurrent,
						phoneNumberCurrent,
						mobileNumberCurrent,
						faxNumberCurrent,						
						createDate,
						createBy,
						createIp,
						modifyDate,
						modifyBy,
						modifyIp		
					)
					VALUES
					(
						CASE WHEN (@personId IS NOT NULL AND LEN(@personId) > 0 AND CHARINDEX(@personId, @strBlank) = 0) THEN @personId ELSE NULL END,
						CASE WHEN (@countryPermanent IS NOT NULL AND LEN(@countryPermanent) > 0 AND CHARINDEX(@countryPermanent, @strBlank) = 0) THEN @countryPermanent ELSE NULL END,
						CASE WHEN (@villagePermanent IS NOT NULL AND LEN(@villagePermanent) > 0 AND CHARINDEX(@villagePermanent, @strBlank) = 0) THEN @villagePermanent ELSE NULL END,
						CASE WHEN (@noPermanent IS NOT NULL AND LEN(@noPermanent) > 0 AND CHARINDEX(@noPermanent, @strBlank) = 0) THEN @noPermanent ELSE NULL END,
						CASE WHEN (@mooPermanent IS NOT NULL AND LEN(@mooPermanent) > 0 AND CHARINDEX(@mooPermanent, @strBlank) = 0) THEN @mooPermanent ELSE NULL END,
						CASE WHEN (@soiPermanent IS NOT NULL AND LEN(@soiPermanent) > 0 AND CHARINDEX(@soiPermanent, @strBlank) = 0) THEN @soiPermanent ELSE NULL END,
						CASE WHEN (@roadPermanent IS NOT NULL AND LEN(@roadPermanent) > 0 AND CHARINDEX(@roadPermanent, @strBlank) = 0) THEN @roadPermanent ELSE NULL END,
						CASE WHEN (@subdistrictPermanent IS NOT NULL AND LEN(@subdistrictPermanent) > 0 AND CHARINDEX(@subdistrictPermanent, @strBlank) = 0) THEN @subdistrictPermanent ELSE NULL END,
						CASE WHEN (@districtPermanent IS NOT NULL AND LEN(@districtPermanent) > 0 AND CHARINDEX(@districtPermanent, @strBlank) = 0) THEN @districtPermanent ELSE NULL END,
						CASE WHEN (@provincePermanent IS NOT NULL AND LEN(@provincePermanent) > 0 AND CHARINDEX(@provincePermanent, @strBlank) = 0) THEN @provincePermanent ELSE NULL END,
						CASE WHEN (@zipCodePermanent IS NOT NULL AND LEN(@zipCodePermanent) > 0 AND CHARINDEX(@zipCodePermanent, @strBlank) = 0) THEN @zipCodePermanent ELSE NULL END,
						CASE WHEN (@phoneNumberPermanent IS NOT NULL AND LEN(@phoneNumberPermanent) > 0 AND CHARINDEX(@phoneNumberPermanent, @strBlank) = 0) THEN @phoneNumberPermanent ELSE NULL END,
						CASE WHEN (@mobileNumberPermanent IS NOT NULL AND LEN(@mobileNumberPermanent) > 0 AND CHARINDEX(@mobileNumberPermanent, @strBlank) = 0) THEN @mobileNumberPermanent ELSE NULL END,
						CASE WHEN (@faxNumberPermanent IS NOT NULL AND LEN(@faxNumberPermanent) > 0 AND CHARINDEX(@faxNumberPermanent, @strBlank) = 0) THEN @faxNumberPermanent ELSE NULL END,
						CASE WHEN (@countryCurrent IS NOT NULL AND LEN(@countryCurrent) > 0 AND CHARINDEX(@countryCurrent, @strBlank) = 0) THEN @countryCurrent ELSE NULL END,
						CASE WHEN (@villageCurrent IS NOT NULL AND LEN(@villageCurrent) > 0 AND CHARINDEX(@villageCurrent, @strBlank) = 0) THEN @villageCurrent ELSE NULL END,
						CASE WHEN (@noCurrent IS NOT NULL AND LEN(@noCurrent) > 0 AND CHARINDEX(@noCurrent, @strBlank) = 0) THEN @noCurrent ELSE NULL END,
						CASE WHEN (@mooCurrent IS NOT NULL AND LEN(@mooCurrent) > 0 AND CHARINDEX(@mooCurrent, @strBlank) = 0) THEN @mooCurrent ELSE NULL END,
						CASE WHEN (@soiCurrent IS NOT NULL AND LEN(@soiCurrent) > 0 AND CHARINDEX(@soiCurrent, @strBlank) = 0) THEN @soiCurrent ELSE NULL END,
						CASE WHEN (@roadCurrent IS NOT NULL AND LEN(@roadCurrent) > 0 AND CHARINDEX(@roadCurrent, @strBlank) = 0) THEN @roadCurrent ELSE NULL END,
						CASE WHEN (@subdistrictCurrent IS NOT NULL AND LEN(@subdistrictCurrent) > 0 AND CHARINDEX(@subdistrictCurrent, @strBlank) = 0) THEN @subdistrictCurrent ELSE NULL END,
						CASE WHEN (@districtCurrent IS NOT NULL AND LEN(@districtCurrent) > 0 AND CHARINDEX(@districtCurrent, @strBlank) = 0) THEN @districtCurrent ELSE NULL END,
						CASE WHEN (@provinceCurrent IS NOT NULL AND LEN(@provinceCurrent) > 0 AND CHARINDEX(@provinceCurrent, @strBlank) = 0) THEN @provinceCurrent ELSE NULL END,
						CASE WHEN (@zipCodeCurrent IS NOT NULL AND LEN(@zipCodeCurrent) > 0 AND CHARINDEX(@zipCodeCurrent, @strBlank) = 0) THEN @zipCodeCurrent ELSE NULL END,
						CASE WHEN (@phoneNumberCurrent IS NOT NULL AND LEN(@phoneNumberCurrent) > 0 AND CHARINDEX(@phoneNumberCurrent, @strBlank) = 0) THEN @phoneNumberCurrent ELSE NULL END,
						CASE WHEN (@mobileNumberCurrent IS NOT NULL AND LEN(@mobileNumberCurrent) > 0 AND CHARINDEX(@mobileNumberCurrent, @strBlank) = 0) THEN @mobileNumberCurrent ELSE NULL END,
						CASE WHEN (@faxNumberCurrent IS NOT NULL AND LEN(@faxNumberCurrent) > 0 AND CHARINDEX(@faxNumberCurrent, @strBlank) = 0) THEN @faxNumberCurrent ELSE NULL END,						
						GETDATE(),
						CASE WHEN (@by IS NOT NULL AND LEN(@by) > 0 AND CHARINDEX(@by, @strBlank) = 0) THEN @by ELSE NULL END,
						CASE WHEN (@ip IS NOT NULL AND LEN(@ip) > 0 AND CHARINDEX(@ip, @strBlank) = 0) THEN @ip ELSE NULL END,
						NULL,
						NULL,
						NULL
					)
					
					SET @rowCount = @rowCount + 1
				END
				
				IF (@action = 'UPDATE' OR @action = 'DELETE')					
				BEGIN
					IF (@personId IS NOT NULL AND LEN(@personId) > 0 AND CHARINDEX(@personId, @strBlank) = 0)
					BEGIN
						SET @rowCountUpdate = (SELECT COUNT(perPersonId) FROM perAddress WHERE perPersonId = @personId)
						
						IF (@rowCountUpdate > 0)
						BEGIN
							IF (@action = 'UPDATE')
							BEGIN
								UPDATE perAddress SET
									plcCountryIdPermanent		= CASE WHEN (@countryPermanent IS NOT NULL AND LEN(@countryPermanent) > 0 AND CHARINDEX(@countryPermanent, @strBlank) = 0) THEN @countryPermanent ELSE (CASE WHEN (@countryPermanent IS NOT NULL AND (LEN(@countryPermanent) = 0 OR CHARINDEX(@countryPermanent, @strBlank) > 0)) THEN NULL ELSE plcCountryIdPermanent END) END,
									villagePermanent			= CASE WHEN (@villagePermanent IS NOT NULL AND LEN(@villagePermanent) > 0 AND CHARINDEX(@villagePermanent, @strBlank) = 0) THEN @villagePermanent ELSE (CASE WHEN (@villagePermanent IS NOT NULL AND (LEN(@villagePermanent) = 0 OR CHARINDEX(@villagePermanent, @strBlank) > 0)) THEN NULL ELSE villagePermanent END) END,
									noPermanent					= CASE WHEN (@noPermanent IS NOT NULL AND LEN(@noPermanent) > 0 AND CHARINDEX(@noPermanent, @strBlank) = 0) THEN @noPermanent ELSE (CASE WHEN (@noPermanent IS NOT NULL AND (LEN(@noPermanent) = 0 OR CHARINDEX(@noPermanent, @strBlank) > 0)) THEN NULL ELSE noPermanent END) END,
									mooPermanent				= CASE WHEN (@mooPermanent IS NOT NULL AND LEN(@mooPermanent) > 0 AND CHARINDEX(@mooPermanent, @strBlank) = 0) THEN @mooPermanent ELSE (CASE WHEN (@mooPermanent IS NOT NULL AND (LEN(@mooPermanent) = 0 OR CHARINDEX(@mooPermanent, @strBlank) > 0)) THEN NULL ELSE mooPermanent END) END,
									soiPermanent				= CASE WHEN (@soiPermanent IS NOT NULL AND LEN(@soiPermanent) > 0 AND CHARINDEX(@soiPermanent, @strBlank) = 0) THEN @soiPermanent ELSE (CASE WHEN (@soiPermanent IS NOT NULL AND (LEN(@soiPermanent) = 0 OR CHARINDEX(@soiPermanent, @strBlank) > 0)) THEN NULL ELSE soiPermanent END) END,
									roadPermanent				= CASE WHEN (@roadPermanent IS NOT NULL AND LEN(@roadPermanent) > 0 AND CHARINDEX(@roadPermanent, @strBlank) = 0) THEN @roadPermanent ELSE (CASE WHEN (@roadPermanent IS NOT NULL AND (LEN(@roadPermanent) = 0 OR CHARINDEX(@roadPermanent, @strBlank) > 0)) THEN NULL ELSE roadPermanent END) END,
									plcSubdistrictIdPermanent	= CASE WHEN (@subdistrictPermanent IS NOT NULL AND LEN(@subdistrictPermanent) > 0 AND CHARINDEX(@subdistrictPermanent, @strBlank) = 0) THEN @subdistrictPermanent ELSE (CASE WHEN (@subdistrictPermanent IS NOT NULL AND (LEN(@subdistrictPermanent) = 0 OR CHARINDEX(@subdistrictPermanent, @strBlank) > 0)) THEN NULL ELSE plcSubdistrictIdPermanent END) END,
									plcDistrictIdPermanent		= CASE WHEN (@districtPermanent IS NOT NULL AND LEN(@districtPermanent) > 0 AND CHARINDEX(@districtPermanent, @strBlank) = 0) THEN @districtPermanent ELSE (CASE WHEN (@districtPermanent IS NOT NULL AND (LEN(@districtPermanent) = 0 OR CHARINDEX(@districtPermanent, @strBlank) > 0)) THEN NULL ELSE plcDistrictIdPermanent END) END,
									plcProvinceIdPermanent		= CASE WHEN (@provincePermanent IS NOT NULL AND LEN(@provincePermanent) > 0 AND CHARINDEX(@provincePermanent, @strBlank) = 0) THEN @provincePermanent ELSE (CASE WHEN (@provincePermanent IS NOT NULL AND (LEN(@provincePermanent) = 0 OR CHARINDEX(@provincePermanent, @strBlank) > 0)) THEN NULL ELSE plcProvinceIdPermanent END) END,
									zipCodePermanent			= CASE WHEN (@zipCodePermanent IS NOT NULL AND LEN(@zipCodePermanent) > 0 AND CHARINDEX(@zipCodePermanent, @strBlank) = 0) THEN @zipCodePermanent ELSE (CASE WHEN (@zipCodePermanent IS NOT NULL AND (LEN(@zipCodePermanent) = 0 OR CHARINDEX(@zipCodePermanent, @strBlank) > 0)) THEN NULL ELSE zipCodePermanent END) END,
									phoneNumberPermanent		= CASE WHEN (@phoneNumberPermanent IS NOT NULL AND LEN(@phoneNumberPermanent) > 0 AND CHARINDEX(@phoneNumberPermanent, @strBlank) = 0) THEN @phoneNumberPermanent ELSE (CASE WHEN (@phoneNumberPermanent IS NOT NULL AND (LEN(@phoneNumberPermanent) = 0 OR CHARINDEX(@phoneNumberPermanent, @strBlank) > 0)) THEN NULL ELSE phoneNumberPermanent END) END,
									mobileNumberPermanent		= CASE WHEN (@mobileNumberPermanent IS NOT NULL AND LEN(@mobileNumberPermanent) > 0 AND CHARINDEX(@mobileNumberPermanent, @strBlank) = 0) THEN @mobileNumberPermanent ELSE (CASE WHEN (@mobileNumberPermanent IS NOT NULL AND (LEN(@mobileNumberPermanent) = 0 OR CHARINDEX(@mobileNumberPermanent, @strBlank) > 0)) THEN NULL ELSE mobileNumberPermanent END) END,
									faxNumberPermanent			= CASE WHEN (@faxNumberPermanent IS NOT NULL AND LEN(@faxNumberPermanent) > 0 AND CHARINDEX(@faxNumberPermanent, @strBlank) = 0) THEN @faxNumberPermanent ELSE (CASE WHEN (@faxNumberPermanent IS NOT NULL AND (LEN(@faxNumberPermanent) = 0 OR CHARINDEX(@faxNumberPermanent, @strBlank) > 0)) THEN NULL ELSE faxNumberPermanent END) END,
									plcCountryIdCurrent			= CASE WHEN (@countryCurrent IS NOT NULL AND LEN(@countryCurrent) > 0 AND CHARINDEX(@countryCurrent, @strBlank) = 0) THEN @countryCurrent ELSE (CASE WHEN (@countryCurrent IS NOT NULL AND (LEN(@countryCurrent) = 0 OR CHARINDEX(@countryCurrent, @strBlank) > 0)) THEN NULL ELSE plcCountryIdCurrent END) END,
									villageCurrent				= CASE WHEN (@villageCurrent IS NOT NULL AND LEN(@villageCurrent) > 0 AND CHARINDEX(@villageCurrent, @strBlank) = 0) THEN @villageCurrent ELSE (CASE WHEN (@villageCurrent IS NOT NULL AND (LEN(@villageCurrent) = 0 OR CHARINDEX(@villageCurrent, @strBlank) > 0)) THEN NULL ELSE villageCurrent END) END,
									noCurrent					= CASE WHEN (@noCurrent IS NOT NULL AND LEN(@noCurrent) > 0 AND CHARINDEX(@noCurrent, @strBlank) = 0) THEN @noCurrent ELSE (CASE WHEN (@noCurrent IS NOT NULL AND (LEN(@noCurrent) = 0 OR CHARINDEX(@noCurrent, @strBlank) > 0)) THEN NULL ELSE noCurrent END) END,
									mooCurrent					= CASE WHEN (@mooCurrent IS NOT NULL AND LEN(@mooCurrent) > 0 AND CHARINDEX(@mooCurrent, @strBlank) = 0) THEN @mooCurrent ELSE (CASE WHEN (@mooCurrent IS NOT NULL AND (LEN(@mooCurrent) = 0 OR CHARINDEX(@mooCurrent, @strBlank) > 0)) THEN NULL ELSE mooCurrent END) END,
									soiCurrent					= CASE WHEN (@soiCurrent IS NOT NULL AND LEN(@soiCurrent) > 0 AND CHARINDEX(@soiCurrent, @strBlank) = 0) THEN @soiCurrent ELSE (CASE WHEN (@soiCurrent IS NOT NULL AND (LEN(@soiCurrent) = 0 OR CHARINDEX(@soiCurrent, @strBlank) > 0)) THEN NULL ELSE soiCurrent END) END,
									roadCurrent					= CASE WHEN (@roadCurrent IS NOT NULL AND LEN(@roadCurrent) > 0 AND CHARINDEX(@roadCurrent, @strBlank) = 0) THEN @roadCurrent ELSE (CASE WHEN (@roadCurrent IS NOT NULL AND (LEN(@roadCurrent) = 0 OR CHARINDEX(@roadCurrent, @strBlank) > 0)) THEN NULL ELSE roadCurrent END) END,
									plcSubdistrictIdCurrent		= CASE WHEN (@subdistrictCurrent IS NOT NULL AND LEN(@subdistrictCurrent) > 0 AND CHARINDEX(@subdistrictCurrent, @strBlank) = 0) THEN @subdistrictCurrent ELSE (CASE WHEN (@subdistrictCurrent IS NOT NULL AND (LEN(@subdistrictCurrent) = 0 OR CHARINDEX(@subdistrictCurrent, @strBlank) > 0)) THEN NULL ELSE plcSubdistrictIdCurrent END) END,
									plcDistrictIdCurrent		= CASE WHEN (@districtCurrent IS NOT NULL AND LEN(@districtCurrent) > 0 AND CHARINDEX(@districtCurrent, @strBlank) = 0) THEN @districtCurrent ELSE (CASE WHEN (@districtCurrent IS NOT NULL AND (LEN(@districtCurrent) = 0 OR CHARINDEX(@districtCurrent, @strBlank) > 0)) THEN NULL ELSE plcDistrictIdCurrent END) END,
									plcProvinceIdCurrent		= CASE WHEN (@provinceCurrent IS NOT NULL AND LEN(@provinceCurrent) > 0 AND CHARINDEX(@provinceCurrent, @strBlank) = 0) THEN @provinceCurrent ELSE (CASE WHEN (@provinceCurrent IS NOT NULL AND (LEN(@provinceCurrent) = 0 OR CHARINDEX(@provinceCurrent, @strBlank) > 0)) THEN NULL ELSE plcProvinceIdCurrent END) END,
									zipCodeCurrent				= CASE WHEN (@zipCodeCurrent IS NOT NULL AND LEN(@zipCodeCurrent) > 0 AND CHARINDEX(@zipCodeCurrent, @strBlank) = 0) THEN @zipCodeCurrent ELSE (CASE WHEN (@zipCodeCurrent IS NOT NULL AND (LEN(@zipCodeCurrent) = 0 OR CHARINDEX(@zipCodeCurrent, @strBlank) > 0)) THEN NULL ELSE zipCodeCurrent END) END,
									phoneNumberCurrent			= CASE WHEN (@phoneNumberCurrent IS NOT NULL AND LEN(@phoneNumberCurrent) > 0 AND CHARINDEX(@phoneNumberCurrent, @strBlank) = 0) THEN @phoneNumberCurrent ELSE (CASE WHEN (@phoneNumberCurrent IS NOT NULL AND (LEN(@phoneNumberCurrent) = 0 OR CHARINDEX(@phoneNumberCurrent, @strBlank) > 0)) THEN NULL ELSE phoneNumberCurrent END) END,
									mobileNumberCurrent			= CASE WHEN (@mobileNumberCurrent IS NOT NULL AND LEN(@mobileNumberCurrent) > 0 AND CHARINDEX(@mobileNumberCurrent, @strBlank) = 0) THEN @mobileNumberCurrent ELSE (CASE WHEN (@mobileNumberCurrent IS NOT NULL AND (LEN(@mobileNumberCurrent) = 0 OR CHARINDEX(@mobileNumberCurrent, @strBlank) > 0)) THEN NULL ELSE mobileNumberCurrent END) END,
									faxNumberCurrent			= CASE WHEN (@faxNumberCurrent IS NOT NULL AND LEN(@faxNumberCurrent) > 0 AND CHARINDEX(@faxNumberCurrent, @strBlank) = 0) THEN @faxNumberCurrent ELSE (CASE WHEN (@faxNumberCurrent IS NOT NULL AND (LEN(@faxNumberCurrent) = 0 OR CHARINDEX(@faxNumberCurrent, @strBlank) > 0)) THEN NULL ELSE faxNumberCurrent END) END,									
									modifyDate					= GETDATE(),
									modifyBy					= CASE WHEN (@by IS NOT NULL AND LEN(@by) > 0 AND CHARINDEX(@by, @strBlank) = 0) THEN @by ELSE (CASE WHEN (@by IS NOT NULL AND (LEN(@by) = 0 OR CHARINDEX(@by, @strBlank) > 0)) THEN NULL ELSE modifyBy END) END,
									modifyIp					= CASE WHEN (@ip IS NOT NULL AND LEN(@ip) > 0 AND CHARINDEX(@ip, @strBlank) = 0) THEN @ip ELSE (CASE WHEN (@ip IS NOT NULL AND (LEN(@ip) = 0 OR CHARINDEX(@ip, @strBlank) > 0)) THEN NULL ELSE modifyIp END) END
								WHERE perPersonId = @personId
							END
							
							IF (@action = 'DELETE')								
							BEGIN
								DELETE FROM perAddress WHERE perPersonId = @personId
							END
							
							SET @rowCount = @rowCount + 1
						END							
					END				
				END													
			COMMIT TRAN									
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN
			INSERT INTO InfinityLog..perErrorLog
			(
				errorDatabase,
				errorTable,
				errorAction,
				errorValue,
				errorMessage,
				errorNumber,
				errorSeverity,
				errorState,
				errorLine,
				errorProcedure,
				errorActionDate,
				errorActionBy,
				errorIp
			)
			VALUES
			(
				DB_NAME(),
				@table,
				@action,
				@value,
				ERROR_MESSAGE(),
				ERROR_NUMBER(),
				ERROR_SEVERITY(),
				ERROR_STATE(),
				ERROR_LINE(),
				ERROR_PROCEDURE(),
				GETDATE(),
				CASE WHEN (@by IS NOT NULL AND LEN(@by) > 0 AND CHARINDEX(@by, @strBlank) = 0) THEN @by ELSE NULL END,
				CASE WHEN (@ip IS NOT NULL AND LEN(@ip) > 0 AND CHARINDEX(@ip, @strBlank) = 0) THEN @ip ELSE NULL END
			)			
		END CATCH					 
	END
	
	SELECT @rowCount		
	
	EXEC sp_stdTransferStudentRecordsToMUStudent
		@personId = @personId
END

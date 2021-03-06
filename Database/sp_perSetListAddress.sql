USE [MUStudent]
GO
/****** Object:  StoredProcedure [dbo].[sp_perSetListAddress]    Script Date: 03/28/2014 09:44:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๒๘/๑๑/๒๕๕๖>
-- Description	: <สำหรับบันทึกข้อมูลตาราง perAddress ครั้งละหลายเรคคอร์ด>
--  1. order					เป็น VARCHAR	รับค่าลำดับของเรคคอร์ด
--  2. perPersonId				เป็น VARCHAR	รับค่ารหัสบุคคล
--  3. plcCountryIdPermanent	เป็น VARCHAR	รับค่ารหัสประเทศของที่อยู่ตามทะเบียนบ้าน
--  4. villagePermanent			เป็น NVARCHAR	รับค่าชื่อหมู่บ้านของที่อยู่ตามทะเบียนบ้าน
--  5. noPermanent				เป็น NVARCHAR	รับค่าบ้านเลขที่ของที่อยู่ตามทะเบียนบ้าน
--  6. mooPermanent				เป็น NVARCHAR	รับค่าหมู่ที่ของที่อยู่ตามทะเบียนบ้าน
--  7. soiPermanent				เป็น NVARCHAR	รับค่าซอยของที่อยู่ตามทะเบียนบ้าน
--  8. roadPermanent			เป็น NVARCHAR	รับค่าถนนของที่อยู่ตามทะเบียนบ้าน
--  9. subDistrictPermanent		เป็น NVARCHAR	รับค่าตำบลของที่อยู่ตามทะเบียนบ้าน
-- 10. districtPermanent		เป็น NVARCHAR	รับค่าอำเภอของที่อยู่ตามทะเบียนบ้าน
-- 11. plcProvinceIdPermanent	เป็น VARCHAR	รับค่ารหัสสถานที่หรือจังหวัดของที่อยู่ตามทะเบียนบ้าน
-- 12. zipCodePermanent			เป็น NVARCHAR	รับค่ารหัสไปรษณีย์ของที่อยู่ตามทะเบียนบ้าน
-- 13. phoneNumberPermanent		เป็น NVARCHAR	รับค่าเบอร์โทรศัพท์บ้านของที่อยู่ตามทะเบียนบ้าน
-- 14. mobileNumberPermanent	เป็น NVARCHAR	รับค่าเบอร์โทรศัพท์มือถือของที่อยู่ตามทะเบียนบ้าน
-- 15. faxNumberPermanent		เป็น NVARCHAR	รับค่าเบอร์แฟกซ์ของที่อยู่ตามทะเบียนบ้าน
-- 16. plcCountryIdCurrent		เป็น VARCHAR	รับค่ารหัสประเทศของที่อยู่ปัจจุบันที่ติดต่อได้
-- 17. villageCurrent			เป็น NVARCHAR	รับค่าชื่อหมู่บ้านของที่อยู่ปัจจุบันที่ติดต่อได้
-- 18. noCurrent				เป็น NVARCHAR	รับค่าบ้านเลขที่ของที่อยู่ปัจจุบันที่ติดต่อได้
-- 19. mooCurrent				เป็น NVARCHAR	รับค่าหมู่ที่ของที่อยู่ปัจจุบันที่ติดต่อได้
-- 20. soiCurrent				เป็น NVARCHAR	รับค่าซอยของที่อยู่ปัจจุบันที่ติดต่อได้
-- 21. roadCurrent				เป็น NVARCHAR	รับค่าถนนของที่อยู่ปัจจุบันที่ติดต่อได้
-- 22. subDistrictCurrent		เป็น NVARCHAR	รับค่าตำบลของที่อยู่ปัจจุบันที่ติดต่อได้
-- 23. districtCurrent			เป็น NVARCHAR	รับค่าอำเภอของที่อยู่ปัจจุบันที่ติดต่อได้
-- 24. plcProvinceIdCurrent		เป็น VARCHAR	รับค่ารหัสสถานที่หรือจังหวัดของที่อยู่ปัจจุบันที่ติดต่อได้
-- 25. zipCodeCurrent			เป็น NVARCHAR	รับค่ารหัสไปรษณีย์ของที่อยู่ปัจจุบันที่ติดต่อได้
-- 26. phoneNumberCurrent		เป็น NVARCHAR	รับค่าเบอร์โทรศัพท์บ้านของที่อยู่ปัจจุบันที่ติดต่อได้
-- 27. mobileNumberCurrent		เป็น NVARCHAR	รับค่าเบอร์โทรศัพท์มือถือของที่อยู่ปัจจุบันที่ติดต่อได้
-- 28. faxNumberCurrent			เป็น NVARCHAR	รับค่าเบอร์แฟกซ์ของที่อยู่ปัจจุบันที่ติดต่อได้
-- 29. by						เป็น NVARCHAR	รับค่าชื่อของผู้ที่กระทำกับฐานข้อมูล
-- =============================================
ALTER PROCEDURE [dbo].[sp_perSetListAddress]
(
	@order VARCHAR(MAX) = NULL,
	@perPersonId VARCHAR(MAX) = NULL,
	@plcCountryIdPermanent VARCHAR(MAX) = NULL,
	@villagePermanent NVARCHAR(MAX) = NULL,
	@noPermanent NVARCHAR(MAX) = NULL,
	@mooPermanent NVARCHAR(MAX) = NULL,
	@soiPermanent NVARCHAR(MAX) = NULL,
	@roadPermanent NVARCHAR(MAX) = NULL,
	@subDistrictPermanent NVARCHAR(MAX) = NULL,
	@districtPermanent NVARCHAR(MAX) = NULL,
	@plcProvinceIdPermanent VARCHAR(MAX) = NULL,
	@zipCodePermanent NVARCHAR(MAX) = NULL,
	@phoneNumberPermanent NVARCHAR(MAX) = NULL,
	@mobileNumberPermanent NVARCHAR(MAX) = NULL,
	@faxNumberPermanent NVARCHAR(MAX) = NULL,
	@plcCountryIdCurrent VARCHAR(MAX) = NULL,
	@villageCurrent NVARCHAR(MAX) = NULL,
	@noCurrent NVARCHAR(MAX) = NULL,
	@mooCurrent NVARCHAR(MAX) = NULL,
	@soiCurrent NVARCHAR(MAX) = NULL,
	@roadCurrent NVARCHAR(MAX) = NULL,
	@subDistrictCurrent NVARCHAR(MAX) = NULL,
	@districtCurrent NVARCHAR(MAX) = NULL,
	@plcProvinceIdCurrent VARCHAR(MAX) = NULL,
	@zipCodeCurrent NVARCHAR(MAX) = NULL,
	@phoneNumberCurrent NVARCHAR(MAX) = NULL,
	@mobileNumberCurrent NVARCHAR(MAX) = NULL,
	@faxNumberCurrent NVARCHAR(MAX) = NULL,	
	@by NVARCHAR(255) = NULL   
)
AS
BEGIN
	SET NOCOUNT ON
	
	SET @order = LTRIM(RTRIM(@order))
	SET @perPersonId = LTRIM(RTRIM(@perPersonId))
	SET @plcCountryIdPermanent = LTRIM(RTRIM(@plcCountryIdPermanent))
	SET @villagePermanent = LTRIM(RTRIM(@villagePermanent))
	SET @noPermanent = LTRIM(RTRIM(@noPermanent))
	SET @mooPermanent = LTRIM(RTRIM(@mooPermanent))
	SET @soiPermanent = LTRIM(RTRIM(@soiPermanent))
	SET @roadPermanent = LTRIM(RTRIM(@roadPermanent))
	SET @subDistrictPermanent = LTRIM(RTRIM(@subDistrictPermanent))
	SET @districtPermanent = LTRIM(RTRIM(@districtPermanent))
	SET @plcProvinceIdPermanent = LTRIM(RTRIM(@plcProvinceIdPermanent))
	SET @zipCodePermanent = LTRIM(RTRIM(@zipCodePermanent))
	SET @phoneNumberPermanent = LTRIM(RTRIM(@phoneNumberPermanent))
	SET @mobileNumberPermanent = LTRIM(RTRIM(@mobileNumberPermanent))
	SET @faxNumberPermanent = LTRIM(RTRIM(@faxNumberPermanent))
	SET @plcCountryIdCurrent = LTRIM(RTRIM(@plcCountryIdCurrent))
	SET @villageCurrent = LTRIM(RTRIM(@villageCurrent))
	SET @noCurrent = LTRIM(RTRIM(@noCurrent))
	SET @mooCurrent = LTRIM(RTRIM(@mooCurrent))
	SET @soiCurrent = LTRIM(RTRIM(@soiCurrent))
	SET @roadCurrent = LTRIM(RTRIM(@roadCurrent))
	SET @subDistrictCurrent = LTRIM(RTRIM(@subDistrictCurrent))
	SET @districtCurrent = LTRIM(RTRIM(@districtCurrent))
	SET @plcProvinceIdCurrent = LTRIM(RTRIM(@plcProvinceIdCurrent))
	SET @zipCodeCurrent = LTRIM(RTRIM(@zipCodeCurrent))
	SET @phoneNumberCurrent = LTRIM(RTRIM(@phoneNumberCurrent))
	SET @mobileNumberCurrent = LTRIM(RTRIM(@mobileNumberCurrent))
	SET @faxNumberCurrent = LTRIM(RTRIM(@faxNumberCurrent))	
	SET @by = LTRIM(RTRIM(@by))	
	
	DECLARE @action VARCHAR(10) = 'INSERT'
	DECLARE @table VARCHAR(50) = 'perAddress'
	DECLARE @i INT = 1
	DECLARE @delimiter CHAR(1) = ';'
	DECLARE @orderSlice VARCHAR(MAX) = NULL
	DECLARE @perPersonIdSlice VARCHAR(MAX) = NULL
	DECLARE @plcCountryIdPermanentSlice VARCHAR(MAX) = NULL
	DECLARE @villagePermanentSlice NVARCHAR(MAX) = NULL
	DECLARE @noPermanentSlice NVARCHAR(MAX) = NULL
	DECLARE @mooPermanentSlice NVARCHAR(MAX) = NULL
	DECLARE @soiPermanentSlice NVARCHAR(MAX) = NULL
	DECLARE @roadPermanentSlice NVARCHAR(MAX) = NULL
	DECLARE @subDistrictPermanentSlice NVARCHAR(MAX) = NULL
	DECLARE @districtPermanentSlice NVARCHAR(MAX) = NULL
	DECLARE @plcProvinceIdPermanentSlice VARCHAR(MAX) = NULL
	DECLARE @zipCodePermanentSlice NVARCHAR(MAX) = NULL
	DECLARE	@phoneNumberPermanentSlice NVARCHAR(MAX) = NULL
	DECLARE	@mobileNumberPermanentSlice NVARCHAR(MAX) = NULL
	DECLARE @faxNumberPermanentSlice NVARCHAR(MAX) = NULL
	DECLARE @plcCountryIdCurrentSlice VARCHAR(MAX) = NULL
	DECLARE @villageCurrentSlice NVARCHAR(MAX) = NULL
	DECLARE @noCurrentSlice NVARCHAR(MAX) = NULL
	DECLARE @mooCurrentSlice NVARCHAR(MAX) = NULL
	DECLARE @soiCurrentSlice NVARCHAR(MAX) = NULL
	DECLARE @roadCurrentSlice NVARCHAR(MAX) = NULL
	DECLARE @subDistrictCurrentSlice NVARCHAR(MAX) = NULL
	DECLARE @districtCurrentSlice NVARCHAR(MAX) = NULL
	DECLARE @plcProvinceIdCurrentSlice VARCHAR(MAX) = NULL
	DECLARE @zipCodeCurrentSlice NVARCHAR(MAX) = NULL
	DECLARE	@phoneNumberCurrentSlice NVARCHAR(MAX) = NULL
	DECLARE	@mobileNumberCurrentSlice NVARCHAR(MAX) = NULL
	DECLARE @faxNumberCurrentSlice NVARCHAR(MAX) = NULL	
	DECLARE @rowCount INT = 0
	DECLARE @value NVARCHAR(MAX) = NULL	
	DECLARE	@strBlank VARCHAR(50) = '----------**********.........0.0000000000000000000'
	DECLARE @ip VARCHAR(255) = dbo.fnc_perGetIP()		
	
	WHILE (LEN(@order) > 0)
	BEGIN
		SET @orderSlice = (SELECT stringSlice FROM fnc_perParseString(@order, @delimiter))
		SET @order = (SELECT string FROM fnc_perParseString(@order, @delimiter))
		
		SET @perPersonIdSlice = (SELECT stringSlice FROM fnc_perParseString(@perPersonId, @delimiter))
		SET @perPersonId = (SELECT string FROM fnc_perParseString(@perPersonId, @delimiter))
		
		SET @plcCountryIdPermanentSlice = (SELECT stringSlice FROM fnc_perParseString(@plcCountryIdPermanent, @delimiter))
		SET @plcCountryIdPermanent = (SELECT string FROM fnc_perParseString(@plcCountryIdPermanent, @delimiter))		
		
		SET @villagePermanentSlice = (SELECT stringSlice FROM fnc_perParseString(@villagePermanent, @delimiter))
		SET @villagePermanent = (SELECT string FROM fnc_perParseString(@villagePermanent, @delimiter))	

		SET @noPermanentSlice = (SELECT stringSlice FROM fnc_perParseString(@noPermanent, @delimiter))
		SET @noPermanent = (SELECT string FROM fnc_perParseString(@noPermanent, @delimiter))			
		
		SET @mooPermanentSlice = (SELECT stringSlice FROM fnc_perParseString(@mooPermanent, @delimiter))
		SET @mooPermanent = (SELECT string FROM fnc_perParseString(@mooPermanent, @delimiter))
		
		SET @soiPermanentSlice = (SELECT stringSlice FROM fnc_perParseString(@soiPermanent, @delimiter))
		SET @soiPermanent = (SELECT string FROM fnc_perParseString(@soiPermanent, @delimiter))		

		SET @roadPermanentSlice = (SELECT stringSlice FROM fnc_perParseString(@roadPermanent, @delimiter))
		SET @roadPermanent = (SELECT string FROM fnc_perParseString(@roadPermanent, @delimiter))		
		
		SET @subDistrictPermanentSlice = (SELECT stringSlice FROM fnc_perParseString(@subDistrictPermanent, @delimiter))
		SET @subDistrictPermanent = (SELECT string FROM fnc_perParseString(@subDistrictPermanent, @delimiter))		
		
		SET @districtPermanentSlice = (SELECT stringSlice FROM fnc_perParseString(@districtPermanent, @delimiter))
		SET @districtPermanent = (SELECT string FROM fnc_perParseString(@districtPermanent, @delimiter))
		
		SET @plcProvinceIdPermanentSlice = (SELECT stringSlice FROM fnc_perParseString(@plcProvinceIdPermanent, @delimiter))
		SET @plcProvinceIdPermanent = (SELECT string FROM fnc_perParseString(@plcProvinceIdPermanent, @delimiter))

		SET @zipCodePermanentSlice = (SELECT stringSlice FROM fnc_perParseString(@zipCodePermanent, @delimiter))
		SET @zipCodePermanent = (SELECT string FROM fnc_perParseString(@zipCodePermanent, @delimiter))		

		SET @phoneNumberPermanentSlice = (SELECT stringSlice FROM fnc_perParseString(@phoneNumberPermanent, @delimiter))
		SET @phoneNumberPermanent = (SELECT string FROM fnc_perParseString(@phoneNumberPermanent, @delimiter))		

		SET @mobileNumberPermanentSlice = (SELECT stringSlice FROM fnc_perParseString(@mobileNumberPermanent, @delimiter))
		SET @mobileNumberPermanent = (SELECT string FROM fnc_perParseString(@mobileNumberPermanent, @delimiter))		
		
		SET @faxNumberPermanentSlice = (SELECT stringSlice FROM fnc_perParseString(@faxNumberPermanent, @delimiter))
		SET @faxNumberPermanent = (SELECT string FROM fnc_perParseString(@faxNumberPermanent, @delimiter))		
		
		SET @plcCountryIdCurrentSlice = (SELECT stringSlice FROM fnc_perParseString(@plcCountryIdCurrent, @delimiter))
		SET @plcCountryIdCurrent = (SELECT string FROM fnc_perParseString(@plcCountryIdCurrent, @delimiter))		
		
		SET @villageCurrentSlice = (SELECT stringSlice FROM fnc_perParseString(@villageCurrent, @delimiter))
		SET @villageCurrent = (SELECT string FROM fnc_perParseString(@villageCurrent, @delimiter))	

		SET @noCurrentSlice = (SELECT stringSlice FROM fnc_perParseString(@noCurrent, @delimiter))
		SET @noCurrent = (SELECT string FROM fnc_perParseString(@noCurrent, @delimiter))			
		
		SET @mooCurrentSlice = (SELECT stringSlice FROM fnc_perParseString(@mooCurrent, @delimiter))
		SET @mooCurrent = (SELECT string FROM fnc_perParseString(@mooCurrent, @delimiter))
		
		SET @soiCurrentSlice = (SELECT stringSlice FROM fnc_perParseString(@soiCurrent, @delimiter))
		SET @soiCurrent = (SELECT string FROM fnc_perParseString(@soiCurrent, @delimiter))		

		SET @roadCurrentSlice = (SELECT stringSlice FROM fnc_perParseString(@roadCurrent, @delimiter))
		SET @roadCurrent = (SELECT string FROM fnc_perParseString(@roadCurrent, @delimiter))		
		
		SET @subDistrictCurrentSlice = (SELECT stringSlice FROM fnc_perParseString(@subDistrictCurrent, @delimiter))
		SET @subDistrictCurrent = (SELECT string FROM fnc_perParseString(@subDistrictCurrent, @delimiter))		
		
		SET @districtCurrentSlice = (SELECT stringSlice FROM fnc_perParseString(@districtCurrent, @delimiter))
		SET @districtCurrent = (SELECT string FROM fnc_perParseString(@districtCurrent, @delimiter))
		
		SET @plcProvinceIdCurrentSlice = (SELECT stringSlice FROM fnc_perParseString(@plcProvinceIdCurrent, @delimiter))
		SET @plcProvinceIdCurrent = (SELECT string FROM fnc_perParseString(@plcProvinceIdCurrent, @delimiter))

		SET @zipCodeCurrentSlice = (SELECT stringSlice FROM fnc_perParseString(@zipCodeCurrent, @delimiter))
		SET @zipCodeCurrent = (SELECT string FROM fnc_perParseString(@zipCodeCurrent, @delimiter))		

		SET @phoneNumberCurrentSlice = (SELECT stringSlice FROM fnc_perParseString(@phoneNumberCurrent, @delimiter))
		SET @phoneNumberCurrent = (SELECT string FROM fnc_perParseString(@phoneNumberCurrent, @delimiter))		

		SET @mobileNumberCurrentSlice = (SELECT stringSlice FROM fnc_perParseString(@mobileNumberCurrent, @delimiter))
		SET @mobileNumberCurrent = (SELECT string FROM fnc_perParseString(@mobileNumberCurrent, @delimiter))		
		
		SET @faxNumberCurrentSlice = (SELECT stringSlice FROM fnc_perParseString(@faxNumberCurrent, @delimiter))
		SET @faxNumberCurrent = (SELECT string FROM fnc_perParseString(@faxNumberCurrent, @delimiter))
				
		IF (LEN(@orderSlice) > 0)
		BEGIN			
			SET @value = 'perPersonId=' + (CASE WHEN (@perPersonIdSlice IS NOT NULL AND LEN(@perPersonIdSlice) > 0 AND CHARINDEX(@perPersonIdSlice, @strBlank) = 0) THEN ('"' + @perPersonIdSlice + '"') ELSE 'NULL' END) + ', ' +
						 'plcCountryIdPermanent=' + (CASE WHEN (@plcCountryIdPermanentSlice IS NOT NULL AND LEN(@plcCountryIdPermanentSlice) > 0 AND CHARINDEX(@plcCountryIdPermanentSlice, @strBlank) = 0) THEN ('"' + @plcCountryIdPermanentSlice + '"') ELSE 'NULL' END) + ', ' +
						 'villagePermanent=' + (CASE WHEN (@villagePermanentSlice IS NOT NULL AND LEN(@villagePermanentSlice) > 0 AND CHARINDEX(@villagePermanentSlice, @strBlank) = 0) THEN ('"' + @villagePermanentSlice + '"') ELSE 'NULL' END) + ', ' +
						 'noPermanent=' + (CASE WHEN (@noPermanentSlice IS NOT NULL AND LEN(@noPermanentSlice) > 0 AND CHARINDEX(@noPermanentSlice, @strBlank) = 0) THEN ('"' + @noPermanentSlice + '"') ELSE 'NULL' END) + ', ' +
						 'mooPermanent=' + (CASE WHEN (@mooPermanentSlice IS NOT NULL AND LEN(@mooPermanentSlice) > 0 AND CHARINDEX(@mooPermanentSlice, @strBlank) = 0) THEN ('"' + @mooPermanentSlice + '"') ELSE 'NULL' END) + ', ' +
						 'soiPermanent=' + (CASE WHEN (@soiPermanentSlice IS NOT NULL AND LEN(@soiPermanentSlice) > 0 AND CHARINDEX(@soiPermanentSlice, @strBlank) = 0) THEN ('"' + @soiPermanentSlice + '"') ELSE 'NULL' END) + ', ' +
						 'roadPermanent=' + (CASE WHEN (@roadPermanentSlice IS NOT NULL AND LEN(@roadPermanentSlice) > 0 AND CHARINDEX(@roadPermanentSlice, @strBlank) = 0) THEN ('"' + @roadPermanentSlice + '"') ELSE 'NULL' END) + ', ' +
						 'subDistrictPermanent=' + (CASE WHEN (@subDistrictPermanentSlice IS NOT NULL AND LEN(@subDistrictPermanentSlice) > 0 AND CHARINDEX(@subDistrictPermanentSlice, @strBlank) = 0) THEN ('"' + @subDistrictPermanentSlice + '"') ELSE 'NULL' END) + ', ' +
						 'districtPermanent=' + (CASE WHEN (@districtPermanentSlice IS NOT NULL AND LEN(@districtPermanentSlice) > 0 AND CHARINDEX(@districtPermanentSlice, @strBlank) = 0) THEN ('"' + @districtPermanentSlice + '"') ELSE 'NULL' END) + ', ' +
						 'plcProvinceIdPermanent=' + (CASE WHEN (@plcProvinceIdPermanentSlice IS NOT NULL AND LEN(@plcProvinceIdPermanentSlice) > 0 AND CHARINDEX(@plcProvinceIdPermanentSlice, @strBlank) = 0) THEN ('"' + @plcProvinceIdPermanentSlice + '"') ELSE 'NULL' END) + ', ' +
						 'zipCodePermanent=' + (CASE WHEN (@zipCodePermanentSlice IS NOT NULL AND LEN(@zipCodePermanentSlice) > 0 AND CHARINDEX(@zipCodePermanentSlice, @strBlank) = 0) THEN ('"' + @zipCodePermanentSlice + '"') ELSE 'NULL' END) + ', ' +
						 'phoneNumberPermanent=' + (CASE WHEN (@phoneNumberPermanentSlice IS NOT NULL AND LEN(@phoneNumberPermanentSlice) > 0 AND CHARINDEX(@phoneNumberPermanentSlice, @strBlank) = 0) THEN ('"' + @phoneNumberPermanentSlice + '"') ELSE 'NULL' END) + ', ' +
						 'mobileNumberPermanent=' + (CASE WHEN (@mobileNumberPermanentSlice IS NOT NULL AND LEN(@mobileNumberPermanentSlice) > 0 AND CHARINDEX(@mobileNumberPermanentSlice, @strBlank) = 0) THEN ('"' + @mobileNumberPermanentSlice + '"') ELSE 'NULL' END) + ', ' +
						 'faxNumberPermanent=' + (CASE WHEN (@faxNumberPermanentSlice IS NOT NULL AND LEN(@faxNumberPermanentSlice) > 0 AND CHARINDEX(@faxNumberPermanentSlice, @strBlank) = 0) THEN ('"' + @faxNumberPermanentSlice + '"') ELSE 'NULL' END) + ', ' +		 				
						 'plcCountryIdCurrent=' + (CASE WHEN (@plcCountryIdCurrentSlice IS NOT NULL AND LEN(@plcCountryIdCurrentSlice) > 0 AND CHARINDEX(@plcCountryIdCurrentSlice, @strBlank) = 0) THEN ('"' + @plcCountryIdCurrentSlice + '"') ELSE 'NULL' END) + ', ' +
						 'villageCurrent=' + (CASE WHEN (@villageCurrentSlice IS NOT NULL AND LEN(@villageCurrentSlice) > 0 AND CHARINDEX(@villageCurrentSlice, @strBlank) = 0) THEN ('"' + @villageCurrentSlice + '"') ELSE 'NULL' END) + ', ' +
						 'noCurrent=' + (CASE WHEN (@noCurrentSlice IS NOT NULL AND LEN(@noCurrentSlice) > 0 AND CHARINDEX(@noCurrentSlice, @strBlank) = 0) THEN ('"' + @noCurrentSlice + '"') ELSE 'NULL' END) + ', ' +
						 'mooCurrent=' + (CASE WHEN (@mooCurrentSlice IS NOT NULL AND LEN(@mooCurrentSlice) > 0 AND CHARINDEX(@mooCurrentSlice, @strBlank) = 0) THEN ('"' + @mooCurrentSlice + '"') ELSE 'NULL' END) + ', ' +
						 'soiCurrent=' + (CASE WHEN (@soiCurrentSlice IS NOT NULL AND LEN(@soiCurrentSlice) > 0 AND CHARINDEX(@soiCurrentSlice, @strBlank) = 0) THEN ('"' + @soiCurrentSlice + '"') ELSE 'NULL' END) + ', ' +
						 'roadCurrent=' + (CASE WHEN (@roadCurrentSlice IS NOT NULL AND LEN(@roadCurrentSlice) > 0 AND CHARINDEX(@roadCurrentSlice, @strBlank) = 0) THEN ('"' + @roadCurrentSlice + '"') ELSE 'NULL' END) + ', ' +
						 'subDistrictCurrent=' + (CASE WHEN (@subDistrictCurrentSlice IS NOT NULL AND LEN(@subDistrictCurrentSlice) > 0 AND CHARINDEX(@subDistrictCurrentSlice, @strBlank) = 0) THEN ('"' + @subDistrictCurrentSlice + '"') ELSE 'NULL' END) + ', ' +
						 'districtCurrent=' + (CASE WHEN (@districtCurrentSlice IS NOT NULL AND LEN(@districtCurrentSlice) > 0 AND CHARINDEX(@districtCurrentSlice, @strBlank) = 0) THEN ('"' + @districtCurrentSlice + '"') ELSE 'NULL' END) + ', ' +
						 'plcProvinceIdCurrent=' + (CASE WHEN (@plcProvinceIdCurrentSlice IS NOT NULL AND LEN(@plcProvinceIdCurrentSlice) > 0 AND CHARINDEX(@plcProvinceIdCurrentSlice, @strBlank) = 0) THEN ('"' + @plcProvinceIdCurrentSlice + '"') ELSE 'NULL' END) + ', ' +
						 'zipCodeCurrent=' + (CASE WHEN (@zipCodeCurrentSlice IS NOT NULL AND LEN(@zipCodeCurrentSlice) > 0 AND CHARINDEX(@zipCodeCurrentSlice, @strBlank) = 0) THEN ('"' + @zipCodeCurrentSlice + '"') ELSE 'NULL' END) + ', ' +
						 'phoneNumberCurrent=' + (CASE WHEN (@phoneNumberCurrentSlice IS NOT NULL AND LEN(@phoneNumberCurrentSlice) > 0 AND CHARINDEX(@phoneNumberCurrentSlice, @strBlank) = 0) THEN ('"' + @phoneNumberCurrentSlice + '"') ELSE 'NULL' END) + ', ' +
						 'mobileNumberCurrent=' + (CASE WHEN (@mobileNumberCurrentSlice IS NOT NULL AND LEN(@mobileNumberCurrentSlice) > 0 AND CHARINDEX(@mobileNumberCurrentSlice, @strBlank) = 0) THEN ('"' + @mobileNumberCurrentSlice + '"') ELSE 'NULL' END) + ', ' +
						 'faxNumberCurrent=' + (CASE WHEN (@faxNumberCurrentSlice IS NOT NULL AND LEN(@faxNumberCurrentSlice) > 0 AND CHARINDEX(@faxNumberCurrentSlice, @strBlank) = 0) THEN ('"' + @faxNumberCurrentSlice + '"') ELSE 'NULL' END)						 
						 
			BEGIN TRY
				BEGIN TRAN	
					INSERT INTO perAddress
					(
						perPersonId,
						plcCountryIdPermanent,
						villagePermanent,
						noPermanent,
						mooPermanent,
						soiPermanent,
						roadPermanent,						
						subDistrictPermanent,
						districtPermanent,
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
						subDistrictCurrent,
						districtCurrent,
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
						CASE WHEN (@perPersonIdSlice IS NOT NULL AND LEN(@perPersonIdSlice) > 0 AND CHARINDEX(@perPersonIdSlice, @strBlank) = 0) THEN @perPersonIdSlice ELSE NULL END,
						CASE WHEN (@plcCountryIdPermanentSlice IS NOT NULL AND LEN(@plcCountryIdPermanentSlice) > 0 AND CHARINDEX(@plcCountryIdPermanentSlice, @strBlank) = 0) THEN @plcCountryIdPermanentSlice ELSE NULL END,
						CASE WHEN (@villagePermanentSlice IS NOT NULL AND LEN(@villagePermanentSlice) > 0 AND CHARINDEX(@villagePermanentSlice, @strBlank) = 0) THEN @villagePermanentSlice ELSE NULL END,
						CASE WHEN (@noPermanentSlice IS NOT NULL AND LEN(@noPermanentSlice) > 0 AND CHARINDEX(@noPermanentSlice, @strBlank) = 0) THEN @noPermanentSlice ELSE NULL END,
						CASE WHEN (@mooPermanentSlice IS NOT NULL AND LEN(@mooPermanentSlice) > 0 AND CHARINDEX(@mooPermanentSlice, @strBlank) = 0) THEN @mooPermanentSlice ELSE NULL END,
						CASE WHEN (@soiPermanentSlice IS NOT NULL AND LEN(@soiPermanentSlice) > 0 AND CHARINDEX(@soiPermanentSlice, @strBlank) = 0) THEN @soiPermanentSlice ELSE NULL END,
						CASE WHEN (@roadPermanentSlice IS NOT NULL AND LEN(@roadPermanentSlice) > 0 AND CHARINDEX(@roadPermanentSlice, @strBlank) = 0) THEN @roadPermanentSlice ELSE NULL END,
						CASE WHEN (@subDistrictPermanentSlice IS NOT NULL AND LEN(@subDistrictPermanentSlice) > 0 AND CHARINDEX(@subDistrictPermanentSlice, @strBlank) = 0) THEN @subDistrictPermanentSlice ELSE NULL END,
						CASE WHEN (@districtPermanentSlice IS NOT NULL AND LEN(@districtPermanentSlice) > 0 AND CHARINDEX(@districtPermanentSlice, @strBlank) = 0) THEN @districtPermanentSlice ELSE NULL END,
						CASE WHEN (@plcProvinceIdPermanentSlice IS NOT NULL AND LEN(@plcProvinceIdPermanentSlice) > 0 AND CHARINDEX(@plcProvinceIdPermanentSlice, @strBlank) = 0) THEN @plcProvinceIdPermanentSlice ELSE NULL END,
						CASE WHEN (@zipCodePermanentSlice IS NOT NULL AND LEN(@zipCodePermanentSlice) > 0 AND CHARINDEX(@zipCodePermanentSlice, @strBlank) = 0) THEN @zipCodePermanentSlice ELSE NULL END,
						CASE WHEN (@phoneNumberPermanentSlice IS NOT NULL AND LEN(@phoneNumberPermanentSlice) > 0 AND CHARINDEX(@phoneNumberPermanentSlice, @strBlank) = 0) THEN @phoneNumberPermanentSlice ELSE NULL END,
						CASE WHEN (@mobileNumberPermanentSlice IS NOT NULL AND LEN(@mobileNumberPermanentSlice) > 0 AND CHARINDEX(@mobileNumberPermanentSlice, @strBlank) = 0) THEN @mobileNumberPermanentSlice ELSE NULL END,
						CASE WHEN (@faxNumberPermanentSlice IS NOT NULL AND LEN(@faxNumberPermanentSlice) > 0 AND CHARINDEX(@faxNumberPermanentSlice, @strBlank) = 0) THEN @faxNumberPermanentSlice ELSE NULL END,
						CASE WHEN (@plcCountryIdCurrentSlice IS NOT NULL AND LEN(@plcCountryIdCurrentSlice) > 0 AND CHARINDEX(@plcCountryIdCurrentSlice, @strBlank) = 0) THEN @plcCountryIdCurrentSlice ELSE NULL END,
						CASE WHEN (@villageCurrentSlice IS NOT NULL AND LEN(@villageCurrentSlice) > 0 AND CHARINDEX(@villageCurrentSlice, @strBlank) = 0) THEN @villageCurrentSlice ELSE NULL END,
						CASE WHEN (@noCurrentSlice IS NOT NULL AND LEN(@noCurrentSlice) > 0 AND CHARINDEX(@noCurrentSlice, @strBlank) = 0) THEN @noCurrentSlice ELSE NULL END,
						CASE WHEN (@mooCurrentSlice IS NOT NULL AND LEN(@mooCurrentSlice) > 0 AND CHARINDEX(@mooCurrentSlice, @strBlank) = 0) THEN @mooCurrentSlice ELSE NULL END,
						CASE WHEN (@soiCurrentSlice IS NOT NULL AND LEN(@soiCurrentSlice) > 0 AND CHARINDEX(@soiCurrentSlice, @strBlank) = 0) THEN @soiCurrentSlice ELSE NULL END,
						CASE WHEN (@roadCurrentSlice IS NOT NULL AND LEN(@roadCurrentSlice) > 0 AND CHARINDEX(@roadCurrentSlice, @strBlank) = 0) THEN @roadCurrentSlice ELSE NULL END,
						CASE WHEN (@subDistrictCurrentSlice IS NOT NULL AND LEN(@subDistrictCurrentSlice) > 0 AND CHARINDEX(@subDistrictCurrentSlice, @strBlank) = 0) THEN @subDistrictCurrentSlice ELSE NULL END,
						CASE WHEN (@districtCurrentSlice IS NOT NULL AND LEN(@districtCurrentSlice) > 0 AND CHARINDEX(@districtCurrentSlice, @strBlank) = 0) THEN @districtCurrentSlice ELSE NULL END,
						CASE WHEN (@plcProvinceIdCurrentSlice IS NOT NULL AND LEN(@plcProvinceIdCurrentSlice) > 0 AND CHARINDEX(@plcProvinceIdCurrentSlice, @strBlank) = 0) THEN @plcProvinceIdCurrentSlice ELSE NULL END,
						CASE WHEN (@zipCodeCurrentSlice IS NOT NULL AND LEN(@zipCodeCurrentSlice) > 0 AND CHARINDEX(@zipCodeCurrentSlice, @strBlank) = 0) THEN @zipCodeCurrentSlice ELSE NULL END,
						CASE WHEN (@phoneNumberCurrentSlice IS NOT NULL AND LEN(@phoneNumberCurrentSlice) > 0 AND CHARINDEX(@phoneNumberCurrentSlice, @strBlank) = 0) THEN @phoneNumberCurrentSlice ELSE NULL END,
						CASE WHEN (@mobileNumberCurrentSlice IS NOT NULL AND LEN(@mobileNumberCurrentSlice) > 0 AND CHARINDEX(@mobileNumberCurrentSlice, @strBlank) = 0) THEN @mobileNumberCurrentSlice ELSE NULL END,
						CASE WHEN (@faxNumberCurrentSlice IS NOT NULL AND LEN(@faxNumberCurrentSlice) > 0 AND CHARINDEX(@faxNumberCurrentSlice, @strBlank) = 0) THEN @faxNumberCurrentSlice ELSE NULL END,						
						GETDATE(),
						CASE WHEN (@by IS NOT NULL AND LEN(@by) > 0 AND CHARINDEX(@by, @strBlank) = 0) THEN @by ELSE NULL END,
						@ip,
						NULL,
						NULL,
						NULL						
					)
				COMMIT TRAN
				SET @rowCount = @rowCount + 1
			END TRY
			BEGIN CATCH
				ROLLBACK TRAN
				INSERT INTO perErrorLog
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
					@ip
				)				
			END CATCH						 		 
		END		
	END	
	
	SELECT @rowCount				
END

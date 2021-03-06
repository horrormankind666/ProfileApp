USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_perSetEducation]    Script Date: 11/16/2015 16:23:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๓/๑๒/๒๕๕๖>
-- Description	: <สำหรับบันทึกข้อมูลตาราง perEducation ครั้งละ ๑ เรคคอร์ด>
--  1. action							เป็น VARCHAR	รับค่าการกระทำกับฐานข้อมูล
--  2. personId							เป็น VARCHAR	รับค่ารหัสบุคคล
--  3. countryPrimarySchool				เป็น VARCHAR	รับค่ารหัสประเทศของการศึกษาระดับประถม
--  4. provincePrimarySchool			เป็น VARCHAR	รับค่ารหัสสถานที่หรือจังหวัดของการศึกษาระดับประถม
--  5. primarySchoolName				เป็น NVARCHAR	รับค่าชื่อสถานศึกษาของการศึกษาระดับประถม
--  6. primarySchoolYearAttended		เป็น VARCHAR	รับค่าปีที่เข้าศึกษาของการศึกษาระดับประถม
--  7. primarySchoolYearGraduate		เป็น VARCHAR	รับค่าปีที่สำเร็จการศึกษาของการศึกษาระดับประถม
--  8. primarySchoolGPA					เป็น VARCHAR	รับค่าเกรดเฉลี่ยของการศึกษาระดับประถม
--  9. countryJuniorHighSchool			เป็น VARCHAR	รับค่ารหัสประเทศของการศึกษาระดับมัธยมต้น
-- 10. provinceJuniorHighSchool			เป็น VARCHAR	รับค่ารหัสสถานที่หรือจังหวัดของการศึกษาระดับมัธยมต้น
-- 11. juniorHighSchoolName				เป็น NVARCHAR	รับค่าชื่อสถานศึกษาของการศึกษาระดับมัธยมต้น
-- 12. juniorHighSchoolYearAttended		เป็น VARCHAR	รับค่าปีที่เข้าศึกษาของการศึกษาระดับมัธยมต้น
-- 13. juniorHighSchoolYearGraduate		เป็น VARCHAR	รับค่าปีที่สำเร็จการศึกษาของการศึกษาระดับมัธยมต้น
-- 14. juniorHighSchoolGPA				เป็น VARCHAR	รับค่าเกรดเฉลี่ยของการศึกษาระดับมัธยมต้น
-- 15. countryHighSchool				เป็น VARCHAR	รับค่ารหัสประเทศของการศึกษาระดับมัธยมปลาย
-- 16. provinceHighSchool				เป็น VARCHAR	รับค่ารหัสสถานที่หรือจังหวัดของการศึกษาระดับมัธยมปลาย
-- 17. highSchoolName					เป็น NVARCHAR	รับค่าชื่อสถานศึกษาของการศึกษาระดับมัธยมปลาย
-- 18. highSchoolStudentId				เป็น NVARCHAR	รับค่าเลขประจำตัวนักเรียนของการศึกษาระดับมัธยมปลาย
-- 19. educationalMajorHighSchool		เป็น VARCHAR	รับค่ารหัสสายการเรียนของการศึกษาระดับมัธยมปลาย
-- 20. educationalMajorOtherHighSchool	เป็น NVARCHAR	รับค่าสายการเรียนอื่น ๆ ของการศึกษาระดับมัธยมปลาย
-- 21. highSchoolYearAttended			เป็น VARCHAR	รับค่าปีที่เข้าศึกษาของการศึกษาระดับมัธยมปลาย
-- 22. highSchoolYearGraduate			เป็น VARCHAR	รับค่าปีที่สำเร็จการศึกษาของการศึกษาระดับมัธยมปลาย
-- 23. highSchoolGPA					เป็น VARCHAR	รับค่าเกรดเฉลี่ยของการศึกษาระดับมัธยมปลาย
-- 24. educationalBackgroundHighSchool	เป็น VARCHAR	รับค่ารหัสวุฒิการศึกษาของการศึกษาระดับมัธยมปลาย
-- 25. educationalBackground			เป็น VARCHAR	รับค่ารหัสวุฒิการศึกษาของการศึกษาก่อนเข้ามหาวิทยาลัยมหิดล
-- 26. graduateBy						เป็น VARCHAR	รับค่าวิธีการสอบเข้าของการศึกษาก่อนเข้ามหาวิทยาลัยมหิดล
-- 27. graduateBySchoolName				เป็น NVARCHAR	รับค่าชื่อโรงเรียนของวิธีการสอบเข้าโดยการสอบเทียบของการศึกษาก่อนเข้ามหาวิทยาลัยมหิดล
-- 28. entranceTime						เป็น VARCHAR	รับค่าจำนวนครั้งที่สอบเข้าของการศึกษาก่อนเข้ามหาวิทยาลัยมหิดล
-- 29. studentIs						เป็น VARCHAR	รับค่าการเคยเป็นนักศึกษาของการศึกษาก่อนเข้ามหาวิทยาลัยมหิดล
-- 30. studentIsUniversity				เป็น NVARCHAR	รับค่าการเคยเป็นนักศึกษาของมหาวิทยาลัยของการศึกษาก่อนเข้ามหาวิทยาลัยมหิดล
-- 31. studentIsFaculty					เป็น NVARCHAR	รับค่าการเคยเป็นนักศึกษาของคณะของการศึกษาก่อนเข้ามหาวิทยาลัยมหิดล
-- 31. studentIsProgram					เป็น NVARCHAR	รับค่าการเคยเป็นนักศึกษาของหลักสูตรของการศึกษาก่อนเข้ามหาวิทยาลัยมหิดล
-- 32. entranceType						เป็น VARCHAR	รับค่ารหัสระบบที่สอบเข้าของการศึกษาก่อนเข้ามหาวิทยาลัยมหิดล
-- 33. admissionRanking					เป็น VARCHAR	รับค่าลำดับที่ของการสอบได้ของการศึกษาก่อนเข้ามหาวิทยาลัยมหิดล
-- 34. scoreONET01						เป็น VARCHAR	รับค่าคะแนนสอบ ONET01
-- 35. scoreONET02						เป็น VARCHAR	รับค่าคะแนนสอบ ONET02
-- 36. scoreONET03						เป็น VARCHAR	รับค่าคะแนนสอบ ONET03
-- 37. scoreONET04						เป็น VARCHAR	รับค่าคะแนนสอบ ONET04
-- 38. scoreONET05						เป็น VARCHAR	รับค่าคะแนนสอบ ONET05
-- 39. scoreONET06						เป็น VARCHAR	รับค่าคะแนนสอบ ONET06
-- 40. scoreONET07						เป็น VARCHAR	รับค่าคะแนนสอบ ONET07
-- 41. scoreONET08						เป็น VARCHAR	รับค่าคะแนนสอบ ONET08
-- 42. scoreANET11						เป็น VARCHAR	รับค่าคะแนนสอบ ANET11
-- 43. scoreANET12						เป็น VARCHAR	รับค่าคะแนนสอบ ANET12
-- 44. scoreANET13						เป็น VARCHAR	รับค่าคะแนนสอบ ANET13
-- 45. scoreANET14						เป็น VARCHAR	รับค่าคะแนนสอบ ANET14
-- 46. scoreANET15						เป็น VARCHAR	รับค่าคะแนนสอบ ANET15
-- 47. scoreGAT85						เป็น VARCHAR	รับค่าคะแนนสอบ GAT85
-- 48. scorePAT71						เป็น VARCHAR	รับค่าคะแนนสอบ PAT71
-- 49. scorePAT72						เป็น VARCHAR	รับค่าคะแนนสอบ PAT72
-- 50. scorePAT73						เป็น VARCHAR	รับค่าคะแนนสอบ PAT73
-- 51. scorePAT74						เป็น VARCHAR	รับค่าคะแนนสอบ PAT74
-- 52. scorePAT75						เป็น VARCHAR	รับค่าคะแนนสอบ PAT75
-- 53. scorePAT76						เป็น VARCHAR	รับค่าคะแนนสอบ PAT76
-- 53. scorePAT77						เป็น VARCHAR	รับค่าคะแนนสอบ PAT77
-- 54. scorePAT78						เป็น VARCHAR	รับค่าคะแนนสอบ PAT78
-- 55. scorePAT79						เป็น VARCHAR	รับค่าคะแนนสอบ PAT79
-- 56. scorePAT80						เป็น VARCHAR	รับค่าคะแนนสอบ PAT80
-- 57. scorePAT81						เป็น VARCHAR	รับค่าคะแนนสอบ PAT81
-- 58. scorePAT82						เป็น VARCHAR	รับค่าคะแนนสอบ PAT82
-- 59. by								เป็น NVARCHAR	รับค่าชื่อของผู้ที่กระทำกับฐานข้อมูล
-- 60. ip								เป็น VARCHAR	รับค่าหมายเลขไอพีของผู้ที่กระทำกับฐานข้อมูล
-- =============================================
ALTER PROCEDURE [dbo].[sp_perSetEducation]
(
	@action VARCHAR(10) = NULL,	
	@personId VARCHAR(10) = NULL,
	@countryPrimarySchool VARCHAR(3) = NULL,
	@provincePrimarySchool VARCHAR(3) = NULL,
	@primarySchoolName NVARCHAR(255) = NULL,
	@primarySchoolYearAttended VARCHAR(4) = NULL,
	@primarySchoolYearGraduate VARCHAR(4) = NULL,
	@primarySchoolGPA VARCHAR(4) = NULL,
	@countryJuniorHighSchool VARCHAR(3) = NULL,
	@provinceJuniorHighSchool VARCHAR(3) = NULL,
	@juniorHighSchoolName NVARCHAR(255) = NULL,
	@juniorHighSchoolYearAttended VARCHAR(4) = NULL,
	@juniorHighSchoolYearGraduate VARCHAR(4) = NULL,
	@juniorHighSchoolGPA VARCHAR(4) = NULL,
	@countryHighSchool VARCHAR(3) = NULL,
	@provinceHighSchool VARCHAR(3) = NULL,
	@highSchoolName NVARCHAR(255) = NULL,
	@highSchoolStudentId NVARCHAR(20) = NULL,
	@educationalMajorHighSchool VARCHAR(2) = NULL,
	@educationalMajorOtherHighSchool NVARCHAR(255) = NULL,
	@highSchoolYearAttended VARCHAR(4) = NULL,
	@highSchoolYearGraduate VARCHAR(4) = NULL,
	@highSchoolGPA VARCHAR(4) = NULL,
	@educationalBackgroundHighSchool VARCHAR(2) = NULL,
	@educationalBackground VARCHAR(2) = NULL,
	@graduateBy VARCHAR(2) = NULL,
	@graduateBySchoolName NVARCHAR(255) = NULL,
	@entranceTime VARCHAR(2) = NULL,
	@studentIs VARCHAR(2) = NULL,
	@studentIsUniversity NVARCHAR(255) = NULL,
	@studentIsFaculty NVARCHAR(255) = NULL,
	@studentIsProgram NVARCHAR(255) = NULL,
	@entranceType VARCHAR(20) = NULL,
	@admissionRanking VARCHAR(10) = NULL,
	@scoreONET01 VARCHAR(10) = NULL,
	@scoreONET02 VARCHAR(10) = NULL,
	@scoreONET03 VARCHAR(10) = NULL,
	@scoreONET04 VARCHAR(10) = NULL,
	@scoreONET05 VARCHAR(10) = NULL,
	@scoreONET06 VARCHAR(10) = NULL,
	@scoreONET07 VARCHAR(10) = NULL,
	@scoreONET08 VARCHAR(10) = NULL,
	@scoreANET11 VARCHAR(10) = NULL,
	@scoreANET12 VARCHAR(10) = NULL,
	@scoreANET13 VARCHAR(10) = NULL,
	@scoreANET14 VARCHAR(10) = NULL,
	@scoreANET15 VARCHAR(10) = NULL,
	@scoreGAT85 VARCHAR(10) = NULL,
	@scorePAT71 VARCHAR(10) = NULL,
	@scorePAT72 VARCHAR(10) = NULL,
	@scorePAT73 VARCHAR(10) = NULL,
	@scorePAT74 VARCHAR(10) = NULL,
	@scorePAT75 VARCHAR(10) = NULL,
	@scorePAT76 VARCHAR(10) = NULL,
	@scorePAT77 VARCHAR(10) = NULL,
	@scorePAT78 VARCHAR(10) = NULL,
	@scorePAT79 VARCHAR(10) = NULL,
	@scorePAT80 VARCHAR(10) = NULL,
	@scorePAT81 VARCHAR(10) = NULL,
	@scorePAT82 VARCHAR(10) = NULL,
	@by NVARCHAR(255) = NULL,
	@ip VARCHAR(255) = NULL
)	
AS
BEGIN
	SET NOCOUNT ON
	
	SET @action = LTRIM(RTRIM(@action))
	SET	@personId = LTRIM(RTRIM(@personId))
	SET @countryPrimarySchool = LTRIM(RTRIM(@countryPrimarySchool))
	SET @provincePrimarySchool = LTRIM(RTRIM(@provincePrimarySchool))
	SET @primarySchoolName = LTRIM(RTRIM(@primarySchoolName))
	SET @primarySchoolYearAttended = LTRIM(RTRIM(@primarySchoolYearAttended))
	SET @primarySchoolYearGraduate = LTRIM(RTRIM(@primarySchoolYearGraduate))
	SET @primarySchoolGPA = LTRIM(RTRIM(@primarySchoolGPA))
	SET @countryJuniorHighSchool = LTRIM(RTRIM(@countryJuniorHighSchool))
	SET @provinceJuniorHighSchool = LTRIM(RTRIM(@provinceJuniorHighSchool))
	SET @juniorHighSchoolName = LTRIM(RTRIM(@juniorHighSchoolName))
	SET @juniorHighSchoolYearAttended = LTRIM(RTRIM(@juniorHighSchoolYearAttended))
	SET @juniorHighSchoolYearGraduate = LTRIM(RTRIM(@juniorHighSchoolYearGraduate))
	SET @juniorHighSchoolGPA = LTRIM(RTRIM(@juniorHighSchoolGPA))
	SET @countryHighSchool = LTRIM(RTRIM(@countryHighSchool))
	SET @provinceHighSchool = LTRIM(RTRIM(@provinceHighSchool))
	SET @highSchoolName = LTRIM(RTRIM(@highSchoolName))
	SET @highSchoolStudentId = LTRIM(RTRIM(@highSchoolStudentId))
	SET @educationalMajorHighSchool = LTRIM(RTRIM(@educationalMajorHighSchool))
	SET @educationalMajorOtherHighSchool = LTRIM(RTRIM(@educationalMajorOtherHighSchool))
	SET @highSchoolYearAttended = LTRIM(RTRIM(@highSchoolYearAttended))
	SET @highSchoolYearGraduate = LTRIM(RTRIM(@highSchoolYearGraduate))
	SET @highSchoolGPA = LTRIM(RTRIM(@highSchoolGPA))
	SET @educationalBackgroundHighSchool = LTRIM(RTRIM(@educationalBackgroundHighSchool))
	SET @educationalBackground = LTRIM(RTRIM(@educationalBackground))
	SET @graduateBy = LTRIM(RTRIM(@graduateBy))
	SET @graduateBySchoolName = LTRIM(RTRIM(@graduateBySchoolName))
	SET @entranceTime = LTRIM(RTRIM(@entranceTime))
	SET @studentIs = LTRIM(RTRIM(@studentIs))
	SET @studentIsUniversity = LTRIM(RTRIM(@studentIsUniversity))
	SET @studentIsFaculty = LTRIM(RTRIM(@studentIsFaculty))
	SET @studentIsProgram = LTRIM(RTRIM(@studentIsProgram))
	SET @entranceType = LTRIM(RTRIM(@entranceType))
	SET @admissionRanking = LTRIM(RTRIM(@admissionRanking))
	SET @scoreONET01 = LTRIM(RTRIM(@scoreONET01))
	SET @scoreONET02 = LTRIM(RTRIM(@scoreONET02))
	SET @scoreONET03 = LTRIM(RTRIM(@scoreONET03))
	SET @scoreONET04 = LTRIM(RTRIM(@scoreONET04))
	SET @scoreONET05 = LTRIM(RTRIM(@scoreONET05))
	SET @scoreONET06 = LTRIM(RTRIM(@scoreONET06))
	SET @scoreONET07 = LTRIM(RTRIM(@scoreONET07))
	SET @scoreONET08 = LTRIM(RTRIM(@scoreONET08))
	SET @scoreANET11 = LTRIM(RTRIM(@scoreANET11))
	SET @scoreANET12 = LTRIM(RTRIM(@scoreANET12))
	SET @scoreANET13 = LTRIM(RTRIM(@scoreANET13))
	SET @scoreANET14 = LTRIM(RTRIM(@scoreANET14))
	SET @scoreANET15 = LTRIM(RTRIM(@scoreANET15))
	SET @scoreGAT85 = LTRIM(RTRIM(@scoreGAT85))
	SET @scorePAT71 = LTRIM(RTRIM(@scorePAT71))
	SET @scorePAT72 = LTRIM(RTRIM(@scorePAT72))
	SET @scorePAT73 = LTRIM(RTRIM(@scorePAT73))
	SET @scorePAT74 = LTRIM(RTRIM(@scorePAT74))
	SET @scorePAT75 = LTRIM(RTRIM(@scorePAT75))
	SET @scorePAT76 = LTRIM(RTRIM(@scorePAT76))
	SET @scorePAT77 = LTRIM(RTRIM(@scorePAT77))
	SET @scorePAT78 = LTRIM(RTRIM(@scorePAT78))
	SET @scorePAT79 = LTRIM(RTRIM(@scorePAT79))
	SET @scorePAT80 = LTRIM(RTRIM(@scorePAT80))
	SET @scorePAT81 = LTRIM(RTRIM(@scorePAT81))
	SET @scorePAT82 = LTRIM(RTRIM(@scorePAT82))
	SET @by = LTRIM(RTRIM(@by))	
	SET @ip = LTRIM(RTRIM(@ip))	
	
	DECLARE @table VARCHAR(50) = 'perEducation'
	DECLARE @rowCount INT = 0
	DECLARE @rowCountUpdate INT = 0
	DECLARE @value NVARCHAR(MAX) = NULL
	DECLARE	@strBlank VARCHAR(50) = '----------**********.........0.0000000000000000000'
	
	SET @action = UPPER(@action)

	IF (@action = 'INSERT' OR @action = 'UPDATE' OR @action = 'DELETE')
	BEGIN
		SET @value = 'perPersonId=' + (CASE WHEN (@personId IS NOT NULL AND LEN(@personId) > 0 AND CHARINDEX(@personId, @strBlank) = 0) THEN ('"' + @personId + '"') ELSE 'NULL' END) + ', ' +
					 'plcCountryIdPrimarySchool=' + (CASE WHEN (@countryPrimarySchool IS NOT NULL AND LEN(@countryPrimarySchool) > 0 AND CHARINDEX(@countryPrimarySchool, @strBlank) = 0) THEN ('"' + @countryPrimarySchool + '"') ELSE 'NULL' END) + ', ' +
					 'plcProvinceIdPrimarySchool=' + (CASE WHEN (@provincePrimarySchool IS NOT NULL AND LEN(@provincePrimarySchool) > 0 AND CHARINDEX(@provincePrimarySchool, @strBlank) = 0) THEN ('"' + @provincePrimarySchool + '"') ELSE 'NULL' END) + ', ' +
					 'primarySchoolName=' + (CASE WHEN (@primarySchoolName IS NOT NULL AND LEN(@primarySchoolName) > 0 AND CHARINDEX(@primarySchoolName, @strBlank) = 0) THEN ('"' + @primarySchoolName + '"') ELSE 'NULL' END) + ', ' +
					 'primarySchoolYearAttended=' + (CASE WHEN (@primarySchoolYearAttended IS NOT NULL AND LEN(@primarySchoolYearAttended) > 0 AND CHARINDEX(@primarySchoolYearAttended, @strBlank) = 0) THEN ('"' + @primarySchoolYearAttended + '"') ELSE 'NULL' END) + ', ' +
					 'primarySchoolYearGraduate=' + (CASE WHEN (@primarySchoolYearGraduate IS NOT NULL AND LEN(@primarySchoolYearGraduate) > 0 AND CHARINDEX(@primarySchoolYearGraduate, @strBlank) = 0) THEN ('"' + @primarySchoolYearGraduate + '"') ELSE 'NULL' END) + ', ' +
					 'primarySchoolGPA=' + (CASE WHEN (@primarySchoolGPA IS NOT NULL AND LEN(@primarySchoolGPA) > 0 AND CHARINDEX(@primarySchoolGPA, @strBlank) = 0) THEN ('"' + @primarySchoolGPA + '"') ELSE 'NULL' END) + ', ' +
					 'plcCountryIdJuniorHighSchool=' + (CASE WHEN (@countryJuniorHighSchool IS NOT NULL AND LEN(@countryJuniorHighSchool) > 0 AND CHARINDEX(@countryJuniorHighSchool, @strBlank) = 0) THEN ('"' + @countryJuniorHighSchool + '"') ELSE 'NULL' END) + ', ' +
					 'plcProvinceIdJuniorHighSchool=' + (CASE WHEN (@provinceJuniorHighSchool IS NOT NULL AND LEN(@provinceJuniorHighSchool) > 0 AND CHARINDEX(@provinceJuniorHighSchool, @strBlank) = 0) THEN ('"' + @provinceJuniorHighSchool + '"') ELSE 'NULL' END) + ', ' +
					 'juniorHighSchoolName=' + (CASE WHEN (@juniorHighSchoolName IS NOT NULL AND LEN(@juniorHighSchoolName) > 0 AND CHARINDEX(@juniorHighSchoolName, @strBlank) = 0) THEN ('"' + @juniorHighSchoolName + '"') ELSE 'NULL' END) + ', ' +
					 'juniorHighSchoolYearAttended=' + (CASE WHEN (@juniorHighSchoolYearAttended IS NOT NULL AND LEN(@juniorHighSchoolYearAttended) > 0 AND CHARINDEX(@juniorHighSchoolYearAttended, @strBlank) = 0) THEN ('"' + @juniorHighSchoolYearAttended + '"') ELSE 'NULL' END) + ', ' +
					 'juniorHighSchoolYearGraduate=' + (CASE WHEN (@juniorHighSchoolYearGraduate IS NOT NULL AND LEN(@juniorHighSchoolYearGraduate) > 0 AND CHARINDEX(@juniorHighSchoolYearGraduate, @strBlank) = 0) THEN ('"' + @juniorHighSchoolYearGraduate + '"') ELSE 'NULL' END) + ', ' +
					 'juniorHighSchoolGPA=' + (CASE WHEN (@juniorHighSchoolGPA IS NOT NULL AND LEN(@juniorHighSchoolGPA) > 0 AND CHARINDEX(@juniorHighSchoolGPA, @strBlank) = 0) THEN ('"' + @juniorHighSchoolGPA + '"') ELSE 'NULL' END) + ', ' +
					 'plcCountryIdHighSchool=' + (CASE WHEN (@countryHighSchool IS NOT NULL AND LEN(@countryHighSchool) > 0 AND CHARINDEX(@countryHighSchool, @strBlank) = 0) THEN ('"' + @countryHighSchool + '"') ELSE 'NULL' END) + ', ' +
					 'plcProvinceIdHighSchool=' + (CASE WHEN (@provinceHighSchool IS NOT NULL AND LEN(@provinceHighSchool) > 0 AND CHARINDEX(@provinceHighSchool, @strBlank) = 0) THEN ('"' + @provinceHighSchool + '"') ELSE 'NULL' END) + ', ' +
					 'highSchoolName=' + (CASE WHEN (@highSchoolName IS NOT NULL AND LEN(@highSchoolName) > 0 AND CHARINDEX(@highSchoolName, @strBlank) = 0) THEN ('"' + @highSchoolName + '"') ELSE 'NULL' END) + ', ' +
					 'highSchoolStudentId=' + (CASE WHEN (@highSchoolStudentId IS NOT NULL AND LEN(@highSchoolStudentId) > 0 AND CHARINDEX(@highSchoolStudentId, @strBlank) = 0) THEN ('"' + @highSchoolStudentId + '"') ELSE 'NULL' END) + ', ' +
					 'perEducationalMajorIdHighSchool=' + (CASE WHEN (@educationalMajorHighSchool IS NOT NULL AND LEN(@educationalMajorHighSchool) > 0 AND CHARINDEX(@educationalMajorHighSchool, @strBlank) = 0) THEN ('"' + @educationalMajorHighSchool + '"') ELSE 'NULL' END) + ', ' +
					 'educationalMajorOtherHighSchool=' + (CASE WHEN (@educationalMajorOtherHighSchool IS NOT NULL AND LEN(@educationalMajorOtherHighSchool) > 0 AND CHARINDEX(@educationalMajorOtherHighSchool, @strBlank) = 0) THEN ('"' + @educationalMajorOtherHighSchool + '"') ELSE 'NULL' END) + ', ' +
					 'highSchoolYearAttended=' + (CASE WHEN (@highSchoolYearAttended IS NOT NULL AND LEN(@highSchoolYearAttended) > 0 AND CHARINDEX(@highSchoolYearAttended, @strBlank) = 0) THEN ('"' + @highSchoolYearAttended + '"') ELSE 'NULL' END) + ', ' +
					 'highSchoolYearGraduate=' + (CASE WHEN (@highSchoolYearGraduate IS NOT NULL AND LEN(@highSchoolYearGraduate) > 0 AND CHARINDEX(@highSchoolYearGraduate, @strBlank) = 0) THEN ('"' + @highSchoolYearGraduate + '"') ELSE 'NULL' END) + ', ' +
					 'highSchoolGPA=' + (CASE WHEN (@highSchoolGPA IS NOT NULL AND LEN(@highSchoolGPA) > 0 AND CHARINDEX(@highSchoolGPA, @strBlank) = 0) THEN ('"' + @highSchoolGPA + '"') ELSE 'NULL' END) + ', ' +
					 'perEducationalBackgroundIdHighSchool=' + (CASE WHEN (@educationalBackgroundHighSchool IS NOT NULL AND LEN(@educationalBackgroundHighSchool) > 0 AND CHARINDEX(@educationalBackgroundHighSchool, @strBlank) = 0) THEN ('"' + @educationalBackgroundHighSchool + '"') ELSE 'NULL' END) + ', ' +
					 'perEducationalBackgroundId=' + (CASE WHEN (@educationalBackground IS NOT NULL AND LEN(@educationalBackground) > 0 AND CHARINDEX(@educationalBackground, @strBlank) = 0) THEN ('"' + @educationalBackground + '"') ELSE 'NULL' END) + ', ' +
					 'graduateBy=' + (CASE WHEN (@graduateBy IS NOT NULL AND LEN(@graduateBy) > 0 AND CHARINDEX(@graduateBy, @strBlank) = 0) THEN ('"' + @graduateBy + '"') ELSE 'NULL' END) + ', ' +
					 'graduateBySchoolName=' + (CASE WHEN (@graduateBySchoolName IS NOT NULL AND LEN(@graduateBySchoolName) > 0 AND CHARINDEX(@graduateBySchoolName, @strBlank) = 0) THEN ('"' + @graduateBySchoolName + '"') ELSE 'NULL' END) + ', ' +
					 'entranceTime=' + (CASE WHEN (@entranceTime IS NOT NULL AND LEN(@entranceTime) > 0 AND CHARINDEX(@entranceTime, @strBlank) = 0) THEN ('"' + @entranceTime + '"') ELSE 'NULL' END) + ', ' +
					 'studentIs=' + (CASE WHEN (@studentIs IS NOT NULL AND LEN(@studentIs) > 0 AND CHARINDEX(@studentIs, @strBlank) = 0) THEN ('"' + @studentIs + '"') ELSE 'NULL' END) + ', ' +
					 'studentIsUniversity=' + (CASE WHEN (@studentIsUniversity IS NOT NULL AND LEN(@studentIsUniversity) > 0 AND CHARINDEX(@studentIsUniversity, @strBlank) = 0) THEN ('"' + @studentIsUniversity + '"') ELSE 'NULL' END) + ', ' +
					 'studentIsFaculty =' + (CASE WHEN (@studentIsFaculty  IS NOT NULL AND LEN(@studentIsFaculty ) > 0 AND CHARINDEX(@studentIsFaculty , @strBlank) = 0) THEN ('"' + @studentIsFaculty  + '"') ELSE 'NULL' END) + ', ' +
					 'studentIsProgram=' + (CASE WHEN (@studentIsProgram IS NOT NULL AND LEN(@studentIsProgram) > 0 AND CHARINDEX(@studentIsProgram, @strBlank) = 0) THEN ('"' + @studentIsProgram + '"') ELSE 'NULL' END) + ', ' +
					 'perEntranceTypeId=' + (CASE WHEN (@entranceType IS NOT NULL AND LEN(@entranceType) > 0 AND CHARINDEX(@entranceType, @strBlank) = 0) THEN ('"' + @entranceType + '"') ELSE 'NULL' END) + ', ' +
					 'admissionRanking=' + (CASE WHEN (@admissionRanking IS NOT NULL AND LEN(@admissionRanking) > 0 AND CHARINDEX(@admissionRanking, @strBlank) = 0) THEN ('"' + @admissionRanking + '"') ELSE 'NULL' END) + ', ' +
					 'scoreONET01=' + (CASE WHEN (@scoreONET01 IS NOT NULL AND LEN(@scoreONET01) > 0 AND CHARINDEX(@scoreONET01, @strBlank) = 0) THEN ('"' + @scoreONET01 + '"') ELSE 'NULL' END) + ', ' +
					 'scoreONET02=' + (CASE WHEN (@scoreONET02 IS NOT NULL AND LEN(@scoreONET02) > 0 AND CHARINDEX(@scoreONET02, @strBlank) = 0) THEN ('"' + @scoreONET02 + '"') ELSE 'NULL' END) + ', ' +
					 'scoreONET03=' + (CASE WHEN (@scoreONET03 IS NOT NULL AND LEN(@scoreONET03) > 0 AND CHARINDEX(@scoreONET03, @strBlank) = 0) THEN ('"' + @scoreONET03 + '"') ELSE 'NULL' END) + ', ' +
					 'scoreONET04=' + (CASE WHEN (@scoreONET04 IS NOT NULL AND LEN(@scoreONET04) > 0 AND CHARINDEX(@scoreONET04, @strBlank) = 0) THEN ('"' + @scoreONET04 + '"') ELSE 'NULL' END) + ', ' +
					 'scoreONET05=' + (CASE WHEN (@scoreONET05 IS NOT NULL AND LEN(@scoreONET05) > 0 AND CHARINDEX(@scoreONET05, @strBlank) = 0) THEN ('"' + @scoreONET05 + '"') ELSE 'NULL' END) + ', ' +
					 'scoreONET06=' + (CASE WHEN (@scoreONET06 IS NOT NULL AND LEN(@scoreONET06) > 0 AND CHARINDEX(@scoreONET06, @strBlank) = 0) THEN ('"' + @scoreONET06 + '"') ELSE 'NULL' END) + ', ' +
					 'scoreONET07=' + (CASE WHEN (@scoreONET07 IS NOT NULL AND LEN(@scoreONET07) > 0 AND CHARINDEX(@scoreONET07, @strBlank) = 0) THEN ('"' + @scoreONET07 + '"') ELSE 'NULL' END) + ', ' +
					 'scoreONET08=' + (CASE WHEN (@scoreONET08 IS NOT NULL AND LEN(@scoreONET08) > 0 AND CHARINDEX(@scoreONET08, @strBlank) = 0) THEN ('"' + @scoreONET08 + '"') ELSE 'NULL' END) + ', ' +
					 'scoreANET11=' + (CASE WHEN (@scoreANET11 IS NOT NULL AND LEN(@scoreANET11) > 0 AND CHARINDEX(@scoreANET11, @strBlank) = 0) THEN ('"' + @scoreANET11 + '"') ELSE 'NULL' END) + ', ' +
					 'scoreANET12=' + (CASE WHEN (@scoreANET12 IS NOT NULL AND LEN(@scoreANET12) > 0 AND CHARINDEX(@scoreANET12, @strBlank) = 0) THEN ('"' + @scoreANET12 + '"') ELSE 'NULL' END) + ', ' +
					 'scoreANET13=' + (CASE WHEN (@scoreANET13 IS NOT NULL AND LEN(@scoreANET13) > 0 AND CHARINDEX(@scoreANET13, @strBlank) = 0) THEN ('"' + @scoreANET13 + '"') ELSE 'NULL' END) + ', ' +
					 'scoreANET14=' + (CASE WHEN (@scoreANET14 IS NOT NULL AND LEN(@scoreANET14) > 0 AND CHARINDEX(@scoreANET14, @strBlank) = 0) THEN ('"' + @scoreANET14 + '"') ELSE 'NULL' END) + ', ' +
					 'scoreANET15=' + (CASE WHEN (@scoreANET15 IS NOT NULL AND LEN(@scoreANET15) > 0 AND CHARINDEX(@scoreANET15, @strBlank) = 0) THEN ('"' + @scoreANET15 + '"') ELSE 'NULL' END) + ', ' +
					 'scoreGAT85=' + (CASE WHEN (@scoreGAT85 IS NOT NULL AND LEN(@scoreGAT85) > 0 AND CHARINDEX(@scoreGAT85, @strBlank) = 0) THEN ('"' + @scoreGAT85 + '"') ELSE 'NULL' END) + ', ' +
					 'scorePAT71=' + (CASE WHEN (@scorePAT71 IS NOT NULL AND LEN(@scorePAT71) > 0 AND CHARINDEX(@scorePAT71, @strBlank) = 0) THEN ('"' + @scorePAT71 + '"') ELSE 'NULL' END) + ', ' +
					 'scorePAT72=' + (CASE WHEN (@scorePAT72 IS NOT NULL AND LEN(@scorePAT72) > 0 AND CHARINDEX(@scorePAT72, @strBlank) = 0) THEN ('"' + @scorePAT72 + '"') ELSE 'NULL' END) + ', ' +
					 'scorePAT73=' + (CASE WHEN (@scorePAT73 IS NOT NULL AND LEN(@scorePAT73) > 0 AND CHARINDEX(@scorePAT73, @strBlank) = 0) THEN ('"' + @scorePAT73 + '"') ELSE 'NULL' END) + ', ' +
					 'scorePAT74=' + (CASE WHEN (@scorePAT74 IS NOT NULL AND LEN(@scorePAT74) > 0 AND CHARINDEX(@scorePAT74, @strBlank) = 0) THEN ('"' + @scorePAT74 + '"') ELSE 'NULL' END) + ', ' +
					 'scorePAT75=' + (CASE WHEN (@scorePAT75 IS NOT NULL AND LEN(@scorePAT75) > 0 AND CHARINDEX(@scorePAT75, @strBlank) = 0) THEN ('"' + @scorePAT75 + '"') ELSE 'NULL' END) + ', ' +
					 'scorePAT76=' + (CASE WHEN (@scorePAT76 IS NOT NULL AND LEN(@scorePAT76) > 0 AND CHARINDEX(@scorePAT76, @strBlank) = 0) THEN ('"' + @scorePAT76 + '"') ELSE 'NULL' END) + ', ' +
					 'scorePAT77=' + (CASE WHEN (@scorePAT77 IS NOT NULL AND LEN(@scorePAT77) > 0 AND CHARINDEX(@scorePAT77, @strBlank) = 0) THEN ('"' + @scorePAT77 + '"') ELSE 'NULL' END) + ', ' +
					 'scorePAT78=' + (CASE WHEN (@scorePAT78 IS NOT NULL AND LEN(@scorePAT78) > 0 AND CHARINDEX(@scorePAT78, @strBlank) = 0) THEN ('"' + @scorePAT78 + '"') ELSE 'NULL' END) + ', ' +
					 'scorePAT79=' + (CASE WHEN (@scorePAT79 IS NOT NULL AND LEN(@scorePAT79) > 0 AND CHARINDEX(@scorePAT79, @strBlank) = 0) THEN ('"' + @scorePAT79 + '"') ELSE 'NULL' END) + ', ' +
					 'scorePAT80=' + (CASE WHEN (@scorePAT80 IS NOT NULL AND LEN(@scorePAT80) > 0 AND CHARINDEX(@scorePAT80, @strBlank) = 0) THEN ('"' + @scorePAT80 + '"') ELSE 'NULL' END) + ', ' +
					 'scorePAT81=' + (CASE WHEN (@scorePAT81 IS NOT NULL AND LEN(@scorePAT81) > 0 AND CHARINDEX(@scorePAT81, @strBlank) = 0) THEN ('"' + @scorePAT81 + '"') ELSE 'NULL' END) + ', ' +
					 'scorePAT82=' + (CASE WHEN (@scorePAT82 IS NOT NULL AND LEN(@scorePAT82) > 0 AND CHARINDEX(@scorePAT82, @strBlank) = 0) THEN ('"' + @scorePAT82 + '"') ELSE 'NULL' END)					 					 					 
		BEGIN TRY
			BEGIN TRAN
				IF (@action = 'INSERT')
				BEGIN
 					INSERT INTO perEducation
 					(
						perPersonId,
						plcCountryIdPrimarySchool,
						plcProvinceIdPrimarySchool,
						primarySchoolName,
						primarySchoolYearAttended,
						primarySchoolYearGraduate,
						primarySchoolGPA,
						plcCountryIdJuniorHighSchool,
						plcProvinceIdJuniorHighSchool,
						juniorHighSchoolName,
						juniorHighSchoolYearAttended,
						juniorHighSchoolYearGraduate,
						juniorHighSchoolGPA,
						plcCountryIdHighSchool,
						plcProvinceIdHighSchool,
						highSchoolName,
						highSchoolStudentId,
						perEducationalMajorIdHighSchool,
						educationalMajorOtherHighSchool,
						highSchoolYearAttended,
						highSchoolYearGraduate,
						highSchoolGPA,
						perEducationalBackgroundIdHighSchool,
						perEducationalBackgroundId,
						graduateBy,
						graduateBySchoolName,
						entranceTime,
						studentIs,
						studentIsUniversity,
						studentIsFaculty,
						studentIsProgram,
						perEntranceTypeId,
						admissionRanking,
						scoreONET01,
						scoreONET02,
						scoreONET03,
						scoreONET04,
						scoreONET05,
						scoreONET06,
						scoreONET07,
						scoreONET08,
						scoreANET11,
						scoreANET12,
						scoreANET13,
						scoreANET14,
						scoreANET15,
						scoreGAT85,
						scorePAT71,
						scorePAT72,
						scorePAT73,
						scorePAT74,
						scorePAT75,
						scorePAT76,
						scorePAT77,
						scorePAT78,
						scorePAT79,
						scorePAT80,
						scorePAT81,
						scorePAT82,
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
						CASE WHEN (@countryPrimarySchool IS NOT NULL AND LEN(@countryPrimarySchool) > 0 AND CHARINDEX(@countryPrimarySchool, @strBlank) = 0) THEN @countryPrimarySchool ELSE NULL END,
						CASE WHEN (@provincePrimarySchool IS NOT NULL AND LEN(@provincePrimarySchool) > 0 AND CHARINDEX(@provincePrimarySchool, @strBlank) = 0) THEN @provincePrimarySchool ELSE NULL END,
						CASE WHEN (@primarySchoolName IS NOT NULL AND LEN(@primarySchoolName) > 0 AND CHARINDEX(@primarySchoolName, @strBlank) = 0) THEN @primarySchoolName ELSE NULL END,
						CASE WHEN (@primarySchoolYearAttended IS NOT NULL AND LEN(@primarySchoolYearAttended) > 0 AND CHARINDEX(@primarySchoolYearAttended, @strBlank) = 0) THEN @primarySchoolYearAttended ELSE NULL END,
						CASE WHEN (@primarySchoolYearGraduate IS NOT NULL AND LEN(@primarySchoolYearGraduate) > 0 AND CHARINDEX(@primarySchoolYearGraduate, @strBlank) = 0) THEN @primarySchoolYearGraduate ELSE NULL END,
						CASE WHEN (@primarySchoolGPA IS NOT NULL AND LEN(@primarySchoolGPA) > 0 AND CHARINDEX(@primarySchoolGPA, @strBlank) = 0) THEN @primarySchoolGPA ELSE NULL END,
						CASE WHEN (@countryJuniorHighSchool IS NOT NULL AND LEN(@countryJuniorHighSchool) > 0 AND CHARINDEX(@countryJuniorHighSchool, @strBlank) = 0) THEN @countryJuniorHighSchool ELSE NULL END,
						CASE WHEN (@provinceJuniorHighSchool IS NOT NULL AND LEN(@provinceJuniorHighSchool) > 0 AND CHARINDEX(@provinceJuniorHighSchool, @strBlank) = 0) THEN @provinceJuniorHighSchool ELSE NULL END,
						CASE WHEN (@juniorHighSchoolName IS NOT NULL AND LEN(@juniorHighSchoolName) > 0 AND CHARINDEX(@juniorHighSchoolName, @strBlank) = 0) THEN @juniorHighSchoolName ELSE NULL END,
						CASE WHEN (@juniorHighSchoolYearAttended IS NOT NULL AND LEN(@juniorHighSchoolYearAttended) > 0 AND CHARINDEX(@juniorHighSchoolYearAttended, @strBlank) = 0) THEN @juniorHighSchoolYearAttended ELSE NULL END,
						CASE WHEN (@juniorHighSchoolYearGraduate IS NOT NULL AND LEN(@juniorHighSchoolYearGraduate) > 0 AND CHARINDEX(@juniorHighSchoolYearGraduate, @strBlank) = 0) THEN @juniorHighSchoolYearGraduate ELSE NULL END,
						CASE WHEN (@juniorHighSchoolGPA IS NOT NULL AND LEN(@juniorHighSchoolGPA) > 0 AND CHARINDEX(@juniorHighSchoolGPA, @strBlank) = 0) THEN @juniorHighSchoolGPA ELSE NULL END,
						CASE WHEN (@countryHighSchool IS NOT NULL AND LEN(@countryHighSchool) > 0 AND CHARINDEX(@countryHighSchool, @strBlank) = 0) THEN @countryHighSchool ELSE NULL END,
						CASE WHEN (@provinceHighSchool IS NOT NULL AND LEN(@provinceHighSchool) > 0 AND CHARINDEX(@provinceHighSchool, @strBlank) = 0) THEN @provinceHighSchool ELSE NULL END,
						CASE WHEN (@highSchoolName IS NOT NULL AND LEN(@highSchoolName) > 0 AND CHARINDEX(@highSchoolName, @strBlank) = 0) THEN @highSchoolName ELSE NULL END,
						CASE WHEN (@highSchoolStudentId IS NOT NULL AND LEN(@highSchoolStudentId) > 0 AND CHARINDEX(@highSchoolStudentId, @strBlank) = 0) THEN @highSchoolStudentId ELSE NULL END,
						CASE WHEN (@educationalMajorHighSchool IS NOT NULL AND LEN(@educationalMajorHighSchool) > 0 AND CHARINDEX(@educationalMajorHighSchool, @strBlank) = 0) THEN @educationalMajorHighSchool ELSE NULL END,
						CASE WHEN (@educationalMajorOtherHighSchool IS NOT NULL AND LEN(@educationalMajorOtherHighSchool) > 0 AND CHARINDEX(@educationalMajorOtherHighSchool, @strBlank) = 0) THEN @educationalMajorOtherHighSchool ELSE NULL END,
						CASE WHEN (@highSchoolYearAttended IS NOT NULL AND LEN(@highSchoolYearAttended) > 0 AND CHARINDEX(@highSchoolYearAttended, @strBlank) = 0) THEN @highSchoolYearAttended ELSE NULL END,
						CASE WHEN (@highSchoolYearGraduate IS NOT NULL AND LEN(@highSchoolYearGraduate) > 0 AND CHARINDEX(@highSchoolYearGraduate, @strBlank) = 0) THEN @highSchoolYearGraduate ELSE NULL END,
						CASE WHEN (@highSchoolGPA IS NOT NULL AND LEN(@highSchoolGPA) > 0 AND CHARINDEX(@highSchoolGPA, @strBlank) = 0) THEN @highSchoolGPA ELSE NULL END,
						CASE WHEN (@educationalBackgroundHighSchool IS NOT NULL AND LEN(@educationalBackgroundHighSchool) > 0 AND CHARINDEX(@educationalBackgroundHighSchool, @strBlank) = 0) THEN @educationalBackgroundHighSchool ELSE NULL END,
						CASE WHEN (@educationalBackground IS NOT NULL AND LEN(@educationalBackground) > 0 AND CHARINDEX(@educationalBackground, @strBlank) = 0) THEN @educationalBackground ELSE NULL END,
						CASE WHEN (@graduateBy IS NOT NULL AND LEN(@graduateBy) > 0 AND CHARINDEX(@graduateBy, @strBlank) = 0) THEN @graduateBy ELSE NULL END,
						CASE WHEN (@graduateBySchoolName IS NOT NULL AND LEN(@graduateBySchoolName) > 0 AND CHARINDEX(@graduateBySchoolName, @strBlank) = 0) THEN @graduateBySchoolName ELSE NULL END,
						CASE WHEN (@entranceTime IS NOT NULL AND LEN(@entranceTime) > 0 AND CHARINDEX(@entranceTime, @strBlank) = 0) THEN @entranceTime ELSE NULL END,
						CASE WHEN (@studentIs IS NOT NULL AND LEN(@studentIs) > 0 AND CHARINDEX(@studentIs, @strBlank) = 0) THEN @studentIs ELSE NULL END,
						CASE WHEN (@studentIsUniversity IS NOT NULL AND LEN(@studentIsUniversity) > 0 AND CHARINDEX(@studentIsUniversity, @strBlank) = 0) THEN @studentIsUniversity ELSE NULL END,
						CASE WHEN (@studentIsFaculty IS NOT NULL AND LEN(@studentIsFaculty) > 0 AND CHARINDEX(@studentIsFaculty, @strBlank) = 0) THEN @studentIsFaculty ELSE NULL END,
						CASE WHEN (@studentIsProgram IS NOT NULL AND LEN(@studentIsProgram) > 0 AND CHARINDEX(@studentIsProgram, @strBlank) = 0) THEN @studentIsProgram ELSE NULL END,
						CASE WHEN (@entranceType IS NOT NULL AND LEN(@entranceType) > 0 AND CHARINDEX(@entranceType, @strBlank) = 0) THEN @entranceType ELSE NULL END,
						CASE WHEN (@admissionRanking IS NOT NULL AND LEN(@admissionRanking) > 0 AND CHARINDEX(@admissionRanking, @strBlank) = 0) THEN @admissionRanking ELSE NULL END,
						CASE WHEN (@scoreONET01 IS NOT NULL AND LEN(@scoreONET01) > 0 AND CHARINDEX(@scoreONET01, @strBlank) = 0) THEN @scoreONET01 ELSE NULL END,
						CASE WHEN (@scoreONET02 IS NOT NULL AND LEN(@scoreONET02) > 0 AND CHARINDEX(@scoreONET02, @strBlank) = 0) THEN @scoreONET02 ELSE NULL END,
						CASE WHEN (@scoreONET03 IS NOT NULL AND LEN(@scoreONET03) > 0 AND CHARINDEX(@scoreONET03, @strBlank) = 0) THEN @scoreONET03 ELSE NULL END,
						CASE WHEN (@scoreONET04 IS NOT NULL AND LEN(@scoreONET04) > 0 AND CHARINDEX(@scoreONET04, @strBlank) = 0) THEN @scoreONET04 ELSE NULL END,
						CASE WHEN (@scoreONET05 IS NOT NULL AND LEN(@scoreONET05) > 0 AND CHARINDEX(@scoreONET05, @strBlank) = 0) THEN @scoreONET05 ELSE NULL END,
						CASE WHEN (@scoreONET06 IS NOT NULL AND LEN(@scoreONET06) > 0 AND CHARINDEX(@scoreONET06, @strBlank) = 0) THEN @scoreONET06 ELSE NULL END,
						CASE WHEN (@scoreONET07 IS NOT NULL AND LEN(@scoreONET07) > 0 AND CHARINDEX(@scoreONET07, @strBlank) = 0) THEN @scoreONET07 ELSE NULL END,
						CASE WHEN (@scoreONET08 IS NOT NULL AND LEN(@scoreONET08) > 0 AND CHARINDEX(@scoreONET08, @strBlank) = 0) THEN @scoreONET08 ELSE NULL END,
						CASE WHEN (@scoreANET11 IS NOT NULL AND LEN(@scoreANET11) > 0 AND CHARINDEX(@scoreANET11, @strBlank) = 0) THEN @scoreANET11 ELSE NULL END,
						CASE WHEN (@scoreANET12 IS NOT NULL AND LEN(@scoreANET12) > 0 AND CHARINDEX(@scoreANET12, @strBlank) = 0) THEN @scoreANET12 ELSE NULL END,
						CASE WHEN (@scoreANET13 IS NOT NULL AND LEN(@scoreANET13) > 0 AND CHARINDEX(@scoreANET13, @strBlank) = 0) THEN @scoreANET13 ELSE NULL END,
						CASE WHEN (@scoreANET14 IS NOT NULL AND LEN(@scoreANET14) > 0 AND CHARINDEX(@scoreANET14, @strBlank) = 0) THEN @scoreANET14 ELSE NULL END,
						CASE WHEN (@scoreANET15 IS NOT NULL AND LEN(@scoreANET15) > 0 AND CHARINDEX(@scoreANET15, @strBlank) = 0) THEN @scoreANET15 ELSE NULL END,
						CASE WHEN (@scoreGAT85 IS NOT NULL AND LEN(@scoreGAT85) > 0 AND CHARINDEX(@scoreGAT85, @strBlank) = 0) THEN @scoreGAT85 ELSE NULL END,
						CASE WHEN (@scorePAT71 IS NOT NULL AND LEN(@scorePAT71) > 0 AND CHARINDEX(@scorePAT71, @strBlank) = 0) THEN @scorePAT71 ELSE NULL END,
						CASE WHEN (@scorePAT72 IS NOT NULL AND LEN(@scorePAT72) > 0 AND CHARINDEX(@scorePAT72, @strBlank) = 0) THEN @scorePAT72 ELSE NULL END,
						CASE WHEN (@scorePAT73 IS NOT NULL AND LEN(@scorePAT73) > 0 AND CHARINDEX(@scorePAT73, @strBlank) = 0) THEN @scorePAT73 ELSE NULL END,
						CASE WHEN (@scorePAT74 IS NOT NULL AND LEN(@scorePAT74) > 0 AND CHARINDEX(@scorePAT74, @strBlank) = 0) THEN @scorePAT74 ELSE NULL END,
						CASE WHEN (@scorePAT75 IS NOT NULL AND LEN(@scorePAT75) > 0 AND CHARINDEX(@scorePAT75, @strBlank) = 0) THEN @scorePAT75 ELSE NULL END,
						CASE WHEN (@scorePAT76 IS NOT NULL AND LEN(@scorePAT76) > 0 AND CHARINDEX(@scorePAT76, @strBlank) = 0) THEN @scorePAT76 ELSE NULL END,
						CASE WHEN (@scorePAT77 IS NOT NULL AND LEN(@scorePAT77) > 0 AND CHARINDEX(@scorePAT77, @strBlank) = 0) THEN @scorePAT77 ELSE NULL END,
						CASE WHEN (@scorePAT78 IS NOT NULL AND LEN(@scorePAT78) > 0 AND CHARINDEX(@scorePAT78, @strBlank) = 0) THEN @scorePAT78 ELSE NULL END,
						CASE WHEN (@scorePAT79 IS NOT NULL AND LEN(@scorePAT79) > 0 AND CHARINDEX(@scorePAT79, @strBlank) = 0) THEN @scorePAT79 ELSE NULL END,
						CASE WHEN (@scorePAT80 IS NOT NULL AND LEN(@scorePAT80) > 0 AND CHARINDEX(@scorePAT80, @strBlank) = 0) THEN @scorePAT80 ELSE NULL END,
						CASE WHEN (@scorePAT81 IS NOT NULL AND LEN(@scorePAT81) > 0 AND CHARINDEX(@scorePAT81, @strBlank) = 0) THEN @scorePAT81 ELSE NULL END,
						CASE WHEN (@scorePAT82 IS NOT NULL AND LEN(@scorePAT82) > 0 AND CHARINDEX(@scorePAT82, @strBlank) = 0) THEN @scorePAT82 ELSE NULL END,
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
						SET @rowCountUpdate = (SELECT COUNT(perPersonId) FROM perEducation WHERE perPersonId = @personId)
						
						IF (@rowCountUpdate > 0)
						BEGIN
							IF (@action = 'UPDATE')
							BEGIN
								UPDATE perEducation SET
									plcCountryIdPrimarySchool				= CASE WHEN (@countryPrimarySchool IS NOT NULL AND LEN(@countryPrimarySchool) > 0 AND CHARINDEX(@countryPrimarySchool, @strBlank) = 0) THEN @countryPrimarySchool ELSE (CASE WHEN (@countryPrimarySchool IS NOT NULL AND (LEN(@countryPrimarySchool) = 0 OR CHARINDEX(@countryPrimarySchool, @strBlank) > 0)) THEN NULL ELSE plcCountryIdPrimarySchool END) END,
									plcProvinceIdPrimarySchool				= CASE WHEN (@provincePrimarySchool IS NOT NULL AND LEN(@provincePrimarySchool) > 0 AND CHARINDEX(@provincePrimarySchool, @strBlank) = 0) THEN @provincePrimarySchool ELSE (CASE WHEN (@provincePrimarySchool IS NOT NULL AND (LEN(@provincePrimarySchool) = 0 OR CHARINDEX(@provincePrimarySchool, @strBlank) > 0)) THEN NULL ELSE plcProvinceIdPrimarySchool END) END,
									primarySchoolName						= CASE WHEN (@primarySchoolName IS NOT NULL AND LEN(@primarySchoolName) > 0 AND CHARINDEX(@primarySchoolName, @strBlank) = 0) THEN @primarySchoolName ELSE (CASE WHEN (@primarySchoolName IS NOT NULL AND (LEN(@primarySchoolName) = 0 OR CHARINDEX(@primarySchoolName, @strBlank) > 0)) THEN NULL ELSE primarySchoolName END) END,
									primarySchoolYearAttended				= CASE WHEN (@primarySchoolYearAttended IS NOT NULL AND LEN(@primarySchoolYearAttended) > 0 AND CHARINDEX(@primarySchoolYearAttended, @strBlank) = 0) THEN @primarySchoolYearAttended ELSE (CASE WHEN (@primarySchoolYearAttended IS NOT NULL AND (LEN(@primarySchoolYearAttended) = 0 OR CHARINDEX(@primarySchoolYearAttended, @strBlank) > 0)) THEN NULL ELSE primarySchoolYearAttended END) END,
									primarySchoolYearGraduate				= CASE WHEN (@primarySchoolYearGraduate IS NOT NULL AND LEN(@primarySchoolYearGraduate) > 0 AND CHARINDEX(@primarySchoolYearGraduate, @strBlank) = 0) THEN @primarySchoolYearGraduate ELSE (CASE WHEN (@primarySchoolYearGraduate IS NOT NULL AND (LEN(@primarySchoolYearGraduate) = 0 OR CHARINDEX(@primarySchoolYearGraduate, @strBlank) > 0)) THEN NULL ELSE primarySchoolYearGraduate END) END,
									primarySchoolGPA						= CASE WHEN (@primarySchoolGPA IS NOT NULL AND LEN(@primarySchoolGPA) > 0 AND CHARINDEX(@primarySchoolGPA, @strBlank) = 0) THEN @primarySchoolGPA ELSE (CASE WHEN (@primarySchoolGPA IS NOT NULL AND (LEN(@primarySchoolGPA) = 0 OR CHARINDEX(@primarySchoolGPA, @strBlank) > 0)) THEN NULL ELSE primarySchoolGPA END) END,
									plcCountryIdJuniorHighSchool			= CASE WHEN (@countryJuniorHighSchool IS NOT NULL AND LEN(@countryJuniorHighSchool) > 0 AND CHARINDEX(@countryJuniorHighSchool, @strBlank) = 0) THEN @countryJuniorHighSchool ELSE (CASE WHEN (@countryJuniorHighSchool IS NOT NULL AND (LEN(@countryJuniorHighSchool) = 0 OR CHARINDEX(@countryJuniorHighSchool, @strBlank) > 0)) THEN NULL ELSE plcCountryIdJuniorHighSchool END) END,
									plcProvinceIdJuniorHighSchool			= CASE WHEN (@provinceJuniorHighSchool IS NOT NULL AND LEN(@provinceJuniorHighSchool) > 0 AND CHARINDEX(@provinceJuniorHighSchool, @strBlank) = 0) THEN @provinceJuniorHighSchool ELSE (CASE WHEN (@provinceJuniorHighSchool IS NOT NULL AND (LEN(@provinceJuniorHighSchool) = 0 OR CHARINDEX(@provinceJuniorHighSchool, @strBlank) > 0)) THEN NULL ELSE plcProvinceIdJuniorHighSchool END) END,
									juniorHighSchoolName					= CASE WHEN (@juniorHighSchoolName IS NOT NULL AND LEN(@juniorHighSchoolName) > 0 AND CHARINDEX(@juniorHighSchoolName, @strBlank) = 0) THEN @juniorHighSchoolName ELSE (CASE WHEN (@juniorHighSchoolName IS NOT NULL AND (LEN(@juniorHighSchoolName) = 0 OR CHARINDEX(@juniorHighSchoolName, @strBlank) > 0)) THEN NULL ELSE juniorHighSchoolName END) END,
									juniorHighSchoolYearAttended			= CASE WHEN (@juniorHighSchoolYearAttended IS NOT NULL AND LEN(@juniorHighSchoolYearAttended) > 0 AND CHARINDEX(@juniorHighSchoolYearAttended, @strBlank) = 0) THEN @juniorHighSchoolYearAttended ELSE (CASE WHEN (@juniorHighSchoolYearAttended IS NOT NULL AND (LEN(@juniorHighSchoolYearAttended) = 0 OR CHARINDEX(@juniorHighSchoolYearAttended, @strBlank) > 0)) THEN NULL ELSE juniorHighSchoolYearAttended END) END,
									juniorHighSchoolYearGraduate			= CASE WHEN (@juniorHighSchoolYearGraduate IS NOT NULL AND LEN(@juniorHighSchoolYearGraduate) > 0 AND CHARINDEX(@juniorHighSchoolYearGraduate, @strBlank) = 0) THEN @juniorHighSchoolYearGraduate ELSE (CASE WHEN (@juniorHighSchoolYearGraduate IS NOT NULL AND (LEN(@juniorHighSchoolYearGraduate) = 0 OR CHARINDEX(@juniorHighSchoolYearGraduate, @strBlank) > 0)) THEN NULL ELSE juniorHighSchoolYearGraduate END) END,
									juniorHighSchoolGPA						= CASE WHEN (@juniorHighSchoolGPA IS NOT NULL AND LEN(@juniorHighSchoolGPA) > 0 AND CHARINDEX(@juniorHighSchoolGPA, @strBlank) = 0) THEN @juniorHighSchoolGPA ELSE (CASE WHEN (@juniorHighSchoolGPA IS NOT NULL AND (LEN(@juniorHighSchoolGPA) = 0 OR CHARINDEX(@juniorHighSchoolGPA, @strBlank) > 0)) THEN NULL ELSE juniorHighSchoolGPA END) END,
									plcCountryIdHighSchool					= CASE WHEN (@countryHighSchool IS NOT NULL AND LEN(@countryHighSchool) > 0 AND CHARINDEX(@countryHighSchool, @strBlank) = 0) THEN @countryHighSchool ELSE (CASE WHEN (@countryHighSchool IS NOT NULL AND (LEN(@countryHighSchool) = 0 OR CHARINDEX(@countryHighSchool, @strBlank) > 0)) THEN NULL ELSE plcCountryIdHighSchool END) END,
									plcProvinceIdHighSchool					= CASE WHEN (@provinceHighSchool IS NOT NULL AND LEN(@provinceHighSchool) > 0 AND CHARINDEX(@provinceHighSchool, @strBlank) = 0) THEN @provinceHighSchool ELSE (CASE WHEN (@provinceHighSchool IS NOT NULL AND (LEN(@provinceHighSchool) = 0 OR CHARINDEX(@provinceHighSchool, @strBlank) > 0)) THEN NULL ELSE plcProvinceIdHighSchool END) END,
									highSchoolName							= CASE WHEN (@highSchoolName IS NOT NULL AND LEN(@highSchoolName) > 0 AND CHARINDEX(@highSchoolName, @strBlank) = 0) THEN @highSchoolName ELSE (CASE WHEN (@highSchoolName IS NOT NULL AND (LEN(@highSchoolName) = 0 OR CHARINDEX(@highSchoolName, @strBlank) > 0)) THEN NULL ELSE highSchoolName END) END,
									highSchoolStudentId						= CASE WHEN (@highSchoolStudentId IS NOT NULL AND LEN(@highSchoolStudentId) > 0 AND CHARINDEX(@highSchoolStudentId, @strBlank) = 0) THEN @highSchoolStudentId ELSE (CASE WHEN (@highSchoolStudentId IS NOT NULL AND (LEN(@highSchoolStudentId) = 0 OR CHARINDEX(@highSchoolStudentId, @strBlank) > 0)) THEN NULL ELSE highSchoolStudentId END) END,
									perEducationalMajorIdHighSchool			= CASE WHEN (@educationalMajorHighSchool IS NOT NULL AND LEN(@educationalMajorHighSchool) > 0 AND CHARINDEX(@educationalMajorHighSchool, @strBlank) = 0) THEN @educationalMajorHighSchool ELSE (CASE WHEN (@educationalMajorHighSchool IS NOT NULL AND (LEN(@educationalMajorHighSchool) = 0 OR CHARINDEX(@educationalMajorHighSchool, @strBlank) > 0)) THEN NULL ELSE perEducationalMajorIdHighSchool END) END,
									educationalMajorOtherHighSchool			= CASE WHEN (@educationalMajorOtherHighSchool IS NOT NULL AND LEN(@educationalMajorOtherHighSchool) > 0 AND CHARINDEX(@educationalMajorOtherHighSchool, @strBlank) = 0) THEN @educationalMajorOtherHighSchool ELSE (CASE WHEN (@educationalMajorOtherHighSchool IS NOT NULL AND (LEN(@educationalMajorOtherHighSchool) = 0 OR CHARINDEX(@educationalMajorOtherHighSchool, @strBlank) > 0)) THEN NULL ELSE educationalMajorOtherHighSchool END) END,
									highSchoolYearAttended					= CASE WHEN (@highSchoolYearAttended IS NOT NULL AND LEN(@highSchoolYearAttended) > 0 AND CHARINDEX(@highSchoolYearAttended, @strBlank) = 0) THEN @highSchoolYearAttended ELSE (CASE WHEN (@highSchoolYearAttended IS NOT NULL AND (LEN(@highSchoolYearAttended) = 0 OR CHARINDEX(@highSchoolYearAttended, @strBlank) > 0)) THEN NULL ELSE highSchoolYearAttended END) END,
									highSchoolYearGraduate					= CASE WHEN (@highSchoolYearGraduate IS NOT NULL AND LEN(@highSchoolYearGraduate) > 0 AND CHARINDEX(@highSchoolYearGraduate, @strBlank) = 0) THEN @highSchoolYearGraduate ELSE (CASE WHEN (@highSchoolYearGraduate IS NOT NULL AND (LEN(@highSchoolYearGraduate) = 0 OR CHARINDEX(@highSchoolYearGraduate, @strBlank) > 0)) THEN NULL ELSE highSchoolYearGraduate END) END,
									highSchoolGPA							= CASE WHEN (@highSchoolGPA IS NOT NULL AND LEN(@highSchoolGPA) > 0 AND CHARINDEX(@highSchoolGPA, @strBlank) = 0) THEN @highSchoolGPA ELSE (CASE WHEN (@highSchoolGPA IS NOT NULL AND (LEN(@highSchoolGPA) = 0 OR CHARINDEX(@highSchoolGPA, @strBlank) > 0)) THEN NULL ELSE highSchoolGPA END) END,
									perEducationalBackgroundIdHighSchool	= CASE WHEN (@educationalBackgroundHighSchool IS NOT NULL AND LEN(@educationalBackgroundHighSchool) > 0 AND CHARINDEX(@educationalBackgroundHighSchool, @strBlank) = 0) THEN @educationalBackgroundHighSchool ELSE (CASE WHEN (@educationalBackgroundHighSchool IS NOT NULL AND (LEN(@educationalBackgroundHighSchool) = 0 OR CHARINDEX(@educationalBackgroundHighSchool, @strBlank) > 0)) THEN NULL ELSE perEducationalBackgroundIdHighSchool END) END,
									perEducationalBackgroundId				= CASE WHEN (@educationalBackground IS NOT NULL AND LEN(@educationalBackground) > 0 AND CHARINDEX(@educationalBackground, @strBlank) = 0) THEN @educationalBackground ELSE (CASE WHEN (@educationalBackground IS NOT NULL AND (LEN(@educationalBackground) = 0 OR CHARINDEX(@educationalBackground, @strBlank) > 0)) THEN NULL ELSE perEducationalBackgroundId END) END,
									graduateBy								= CASE WHEN (@graduateBy IS NOT NULL AND LEN(@graduateBy) > 0 AND CHARINDEX(@graduateBy, @strBlank) = 0) THEN @graduateBy ELSE (CASE WHEN (@graduateBy IS NOT NULL AND (LEN(@graduateBy) = 0 OR CHARINDEX(@graduateBy, @strBlank) > 0)) THEN NULL ELSE graduateBy END) END,
									graduateBySchoolName					= CASE WHEN (@graduateBySchoolName IS NOT NULL AND LEN(@graduateBySchoolName) > 0 AND CHARINDEX(@graduateBySchoolName, @strBlank) = 0) THEN @graduateBySchoolName ELSE (CASE WHEN (@graduateBySchoolName IS NOT NULL AND (LEN(@graduateBySchoolName) = 0 OR CHARINDEX(@graduateBySchoolName, @strBlank) > 0)) THEN NULL ELSE graduateBySchoolName END) END,
									entranceTime							= CASE WHEN (@entranceTime IS NOT NULL AND LEN(@entranceTime) > 0 AND CHARINDEX(@entranceTime, @strBlank) = 0) THEN @entranceTime ELSE (CASE WHEN (@entranceTime IS NOT NULL AND (LEN(@entranceTime) = 0 OR CHARINDEX(@entranceTime, @strBlank) > 0)) THEN NULL ELSE entranceTime END) END,
									studentIs								= CASE WHEN (@studentIs IS NOT NULL AND LEN(@studentIs) > 0 AND CHARINDEX(@studentIs, @strBlank) = 0) THEN @studentIs ELSE (CASE WHEN (@studentIs IS NOT NULL AND (LEN(@studentIs) = 0 OR CHARINDEX(@studentIs, @strBlank) > 0)) THEN NULL ELSE studentIs END) END,
									studentIsUniversity						= CASE WHEN (@studentIsUniversity IS NOT NULL AND LEN(@studentIsUniversity) > 0 AND CHARINDEX(@studentIsUniversity, @strBlank) = 0) THEN @studentIsUniversity ELSE (CASE WHEN (@studentIsUniversity IS NOT NULL AND (LEN(@studentIsUniversity) = 0 OR CHARINDEX(@studentIsUniversity, @strBlank) > 0)) THEN NULL ELSE studentIsUniversity END) END,
									studentIsFaculty						= CASE WHEN (@studentIsFaculty IS NOT NULL AND LEN(@studentIsFaculty) > 0 AND CHARINDEX(@studentIsFaculty, @strBlank) = 0) THEN @studentIsFaculty ELSE (CASE WHEN (@studentIsFaculty IS NOT NULL AND (LEN(@studentIsFaculty) = 0 OR CHARINDEX(@studentIsFaculty, @strBlank) > 0)) THEN NULL ELSE studentIsFaculty END) END,
									studentIsProgram						= CASE WHEN (@studentIsProgram IS NOT NULL AND LEN(@studentIsProgram) > 0 AND CHARINDEX(@studentIsProgram, @strBlank) = 0) THEN @studentIsProgram ELSE (CASE WHEN (@studentIsProgram IS NOT NULL AND (LEN(@studentIsProgram) = 0 OR CHARINDEX(@studentIsProgram, @strBlank) > 0)) THEN NULL ELSE studentIsProgram END) END,
									perEntranceTypeId						= CASE WHEN (@entranceType IS NOT NULL AND LEN(@entranceType) > 0 AND CHARINDEX(@entranceType, @strBlank) = 0) THEN @entranceType ELSE (CASE WHEN (@entranceType IS NOT NULL AND (LEN(@entranceType) = 0 OR CHARINDEX(@entranceType, @strBlank) > 0)) THEN NULL ELSE perEntranceTypeId END) END,
									admissionRanking						= CASE WHEN (@admissionRanking IS NOT NULL AND LEN(@admissionRanking) > 0 AND CHARINDEX(@admissionRanking, @strBlank) = 0) THEN @admissionRanking ELSE (CASE WHEN (@admissionRanking IS NOT NULL AND (LEN(@admissionRanking) = 0 OR CHARINDEX(@admissionRanking, @strBlank) > 0)) THEN NULL ELSE admissionRanking END) END,
									scoreONET01								= CASE WHEN (@scoreONET01 IS NOT NULL AND LEN(@scoreONET01) > 0 AND CHARINDEX(@scoreONET01, @strBlank) = 0) THEN @scoreONET01 ELSE (CASE WHEN (@scoreONET01 IS NOT NULL AND (LEN(@scoreONET01) = 0 OR CHARINDEX(@scoreONET01, @strBlank) > 0)) THEN NULL ELSE scoreONET01 END) END,
									scoreONET02								= CASE WHEN (@scoreONET02 IS NOT NULL AND LEN(@scoreONET02) > 0 AND CHARINDEX(@scoreONET02, @strBlank) = 0) THEN @scoreONET02 ELSE (CASE WHEN (@scoreONET02 IS NOT NULL AND (LEN(@scoreONET02) = 0 OR CHARINDEX(@scoreONET02, @strBlank) > 0)) THEN NULL ELSE scoreONET02 END) END,
									scoreONET03								= CASE WHEN (@scoreONET03 IS NOT NULL AND LEN(@scoreONET03) > 0 AND CHARINDEX(@scoreONET03, @strBlank) = 0) THEN @scoreONET03 ELSE (CASE WHEN (@scoreONET03 IS NOT NULL AND (LEN(@scoreONET03) = 0 OR CHARINDEX(@scoreONET03, @strBlank) > 0)) THEN NULL ELSE scoreONET03 END) END,
									scoreONET04								= CASE WHEN (@scoreONET04 IS NOT NULL AND LEN(@scoreONET04) > 0 AND CHARINDEX(@scoreONET04, @strBlank) = 0) THEN @scoreONET04 ELSE (CASE WHEN (@scoreONET04 IS NOT NULL AND (LEN(@scoreONET04) = 0 OR CHARINDEX(@scoreONET04, @strBlank) > 0)) THEN NULL ELSE scoreONET04 END) END,
									scoreONET05								= CASE WHEN (@scoreONET05 IS NOT NULL AND LEN(@scoreONET05) > 0 AND CHARINDEX(@scoreONET05, @strBlank) = 0) THEN @scoreONET05 ELSE (CASE WHEN (@scoreONET05 IS NOT NULL AND (LEN(@scoreONET05) = 0 OR CHARINDEX(@scoreONET05, @strBlank) > 0)) THEN NULL ELSE scoreONET05 END) END,
									scoreONET06								= CASE WHEN (@scoreONET06 IS NOT NULL AND LEN(@scoreONET06) > 0 AND CHARINDEX(@scoreONET06, @strBlank) = 0) THEN @scoreONET06 ELSE (CASE WHEN (@scoreONET06 IS NOT NULL AND (LEN(@scoreONET06) = 0 OR CHARINDEX(@scoreONET06, @strBlank) > 0)) THEN NULL ELSE scoreONET06 END) END,
									scoreONET07								= CASE WHEN (@scoreONET07 IS NOT NULL AND LEN(@scoreONET07) > 0 AND CHARINDEX(@scoreONET07, @strBlank) = 0) THEN @scoreONET07 ELSE (CASE WHEN (@scoreONET07 IS NOT NULL AND (LEN(@scoreONET07) = 0 OR CHARINDEX(@scoreONET07, @strBlank) > 0)) THEN NULL ELSE scoreONET07 END) END,
									scoreONET08								= CASE WHEN (@scoreONET08 IS NOT NULL AND LEN(@scoreONET08) > 0 AND CHARINDEX(@scoreONET08, @strBlank) = 0) THEN @scoreONET08 ELSE (CASE WHEN (@scoreONET08 IS NOT NULL AND (LEN(@scoreONET08) = 0 OR CHARINDEX(@scoreONET08, @strBlank) > 0)) THEN NULL ELSE scoreONET08 END) END,
									scoreANET11								= CASE WHEN (@scoreANET11 IS NOT NULL AND LEN(@scoreANET11) > 0 AND CHARINDEX(@scoreANET11, @strBlank) = 0) THEN @scoreANET11 ELSE (CASE WHEN (@scoreANET11 IS NOT NULL AND (LEN(@scoreANET11) = 0 OR CHARINDEX(@scoreANET11, @strBlank) > 0)) THEN NULL ELSE scoreANET11 END) END,
									scoreANET12								= CASE WHEN (@scoreANET12 IS NOT NULL AND LEN(@scoreANET12) > 0 AND CHARINDEX(@scoreANET12, @strBlank) = 0) THEN @scoreANET12 ELSE (CASE WHEN (@scoreANET12 IS NOT NULL AND (LEN(@scoreANET12) = 0 OR CHARINDEX(@scoreANET12, @strBlank) > 0)) THEN NULL ELSE scoreANET12 END) END,
									scoreANET13								= CASE WHEN (@scoreANET13 IS NOT NULL AND LEN(@scoreANET13) > 0 AND CHARINDEX(@scoreANET13, @strBlank) = 0) THEN @scoreANET13 ELSE (CASE WHEN (@scoreANET13 IS NOT NULL AND (LEN(@scoreANET13) = 0 OR CHARINDEX(@scoreANET13, @strBlank) > 0)) THEN NULL ELSE scoreANET13 END) END,
									scoreANET14								= CASE WHEN (@scoreANET14 IS NOT NULL AND LEN(@scoreANET14) > 0 AND CHARINDEX(@scoreANET14, @strBlank) = 0) THEN @scoreANET14 ELSE (CASE WHEN (@scoreANET14 IS NOT NULL AND (LEN(@scoreANET14) = 0 OR CHARINDEX(@scoreANET14, @strBlank) > 0)) THEN NULL ELSE scoreANET14 END) END,
									scoreANET15								= CASE WHEN (@scoreANET15 IS NOT NULL AND LEN(@scoreANET15) > 0 AND CHARINDEX(@scoreANET15, @strBlank) = 0) THEN @scoreANET15 ELSE (CASE WHEN (@scoreANET15 IS NOT NULL AND (LEN(@scoreANET15) = 0 OR CHARINDEX(@scoreANET15, @strBlank) > 0)) THEN NULL ELSE scoreANET15 END) END,
									scoreGAT85								= CASE WHEN (@scoreGAT85 IS NOT NULL AND LEN(@scoreGAT85) > 0 AND CHARINDEX(@scoreGAT85, @strBlank) = 0) THEN @scoreGAT85 ELSE (CASE WHEN (@scoreGAT85 IS NOT NULL AND (LEN(@scoreGAT85) = 0 OR CHARINDEX(@scoreGAT85, @strBlank) > 0)) THEN NULL ELSE scoreGAT85 END) END,
									scorePAT71								= CASE WHEN (@scorePAT71 IS NOT NULL AND LEN(@scorePAT71) > 0 AND CHARINDEX(@scorePAT71, @strBlank) = 0) THEN @scorePAT71 ELSE (CASE WHEN (@scorePAT71 IS NOT NULL AND (LEN(@scorePAT71) = 0 OR CHARINDEX(@scorePAT71, @strBlank) > 0)) THEN NULL ELSE scorePAT71 END) END,
									scorePAT72								= CASE WHEN (@scorePAT72 IS NOT NULL AND LEN(@scorePAT72) > 0 AND CHARINDEX(@scorePAT72, @strBlank) = 0) THEN @scorePAT72 ELSE (CASE WHEN (@scorePAT72 IS NOT NULL AND (LEN(@scorePAT72) = 0 OR CHARINDEX(@scorePAT72, @strBlank) > 0)) THEN NULL ELSE scorePAT72 END) END,
									scorePAT73								= CASE WHEN (@scorePAT73 IS NOT NULL AND LEN(@scorePAT73) > 0 AND CHARINDEX(@scorePAT73, @strBlank) = 0) THEN @scorePAT73 ELSE (CASE WHEN (@scorePAT73 IS NOT NULL AND (LEN(@scorePAT73) = 0 OR CHARINDEX(@scorePAT73, @strBlank) > 0)) THEN NULL ELSE scorePAT73 END) END,
									scorePAT74								= CASE WHEN (@scorePAT74 IS NOT NULL AND LEN(@scorePAT74) > 0 AND CHARINDEX(@scorePAT74, @strBlank) = 0) THEN @scorePAT74 ELSE (CASE WHEN (@scorePAT74 IS NOT NULL AND (LEN(@scorePAT74) = 0 OR CHARINDEX(@scorePAT74, @strBlank) > 0)) THEN NULL ELSE scorePAT74 END) END,
									scorePAT75								= CASE WHEN (@scorePAT75 IS NOT NULL AND LEN(@scorePAT75) > 0 AND CHARINDEX(@scorePAT75, @strBlank) = 0) THEN @scorePAT75 ELSE (CASE WHEN (@scorePAT75 IS NOT NULL AND (LEN(@scorePAT75) = 0 OR CHARINDEX(@scorePAT75, @strBlank) > 0)) THEN NULL ELSE scorePAT75 END) END,
									scorePAT76								= CASE WHEN (@scorePAT76 IS NOT NULL AND LEN(@scorePAT76) > 0 AND CHARINDEX(@scorePAT76, @strBlank) = 0) THEN @scorePAT76 ELSE (CASE WHEN (@scorePAT76 IS NOT NULL AND (LEN(@scorePAT76) = 0 OR CHARINDEX(@scorePAT76, @strBlank) > 0)) THEN NULL ELSE scorePAT76 END) END,
									scorePAT77								= CASE WHEN (@scorePAT77 IS NOT NULL AND LEN(@scorePAT77) > 0 AND CHARINDEX(@scorePAT77, @strBlank) = 0) THEN @scorePAT77 ELSE (CASE WHEN (@scorePAT77 IS NOT NULL AND (LEN(@scorePAT77) = 0 OR CHARINDEX(@scorePAT77, @strBlank) > 0)) THEN NULL ELSE scorePAT77 END) END,
									scorePAT78								= CASE WHEN (@scorePAT78 IS NOT NULL AND LEN(@scorePAT78) > 0 AND CHARINDEX(@scorePAT78, @strBlank) = 0) THEN @scorePAT78 ELSE (CASE WHEN (@scorePAT78 IS NOT NULL AND (LEN(@scorePAT78) = 0 OR CHARINDEX(@scorePAT78, @strBlank) > 0)) THEN NULL ELSE scorePAT78 END) END,
									scorePAT79								= CASE WHEN (@scorePAT79 IS NOT NULL AND LEN(@scorePAT79) > 0 AND CHARINDEX(@scorePAT79, @strBlank) = 0) THEN @scorePAT79 ELSE (CASE WHEN (@scorePAT79 IS NOT NULL AND (LEN(@scorePAT79) = 0 OR CHARINDEX(@scorePAT79, @strBlank) > 0)) THEN NULL ELSE scorePAT79 END) END,
									scorePAT80								= CASE WHEN (@scorePAT80 IS NOT NULL AND LEN(@scorePAT80) > 0 AND CHARINDEX(@scorePAT80, @strBlank) = 0) THEN @scorePAT80 ELSE (CASE WHEN (@scorePAT80 IS NOT NULL AND (LEN(@scorePAT80) = 0 OR CHARINDEX(@scorePAT80, @strBlank) > 0)) THEN NULL ELSE scorePAT80 END) END,
									scorePAT81								= CASE WHEN (@scorePAT81 IS NOT NULL AND LEN(@scorePAT81) > 0 AND CHARINDEX(@scorePAT81, @strBlank) = 0) THEN @scorePAT81 ELSE (CASE WHEN (@scorePAT81 IS NOT NULL AND (LEN(@scorePAT81) = 0 OR CHARINDEX(@scorePAT81, @strBlank) > 0)) THEN NULL ELSE scorePAT81 END) END,
									scorePAT82								= CASE WHEN (@scorePAT82 IS NOT NULL AND LEN(@scorePAT82) > 0 AND CHARINDEX(@scorePAT82, @strBlank) = 0) THEN @scorePAT82 ELSE (CASE WHEN (@scorePAT82 IS NOT NULL AND (LEN(@scorePAT82) = 0 OR CHARINDEX(@scorePAT82, @strBlank) > 0)) THEN NULL ELSE scorePAT82 END) END,
									modifyDate								= GETDATE(),
									modifyBy								= CASE WHEN (@by IS NOT NULL AND LEN(@by) > 0 AND CHARINDEX(@by, @strBlank) = 0) THEN @by ELSE (CASE WHEN (@by IS NOT NULL AND (LEN(@by) = 0 OR CHARINDEX(@by, @strBlank) > 0)) THEN NULL ELSE modifyBy END) END,
									modifyIp								= CASE WHEN (@ip IS NOT NULL AND LEN(@ip) > 0 AND CHARINDEX(@ip, @strBlank) = 0) THEN @ip ELSE (CASE WHEN (@ip IS NOT NULL AND (LEN(@ip) = 0 OR CHARINDEX(@ip, @strBlank) > 0)) THEN NULL ELSE modifyIp END) END
								WHERE perPersonId = @personId
							END
							
							IF (@action = 'DELETE')								
							BEGIN
								DELETE FROM perEducation WHERE perPersonId = @personId
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

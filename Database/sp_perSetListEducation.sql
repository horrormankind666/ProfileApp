USE [MUStudent]
GO
/****** Object:  StoredProcedure [dbo].[sp_perSetListEducation]    Script Date: 03/28/2014 10:04:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๓/๑๒/๒๕๕๖>
-- Description	: <สำหรับบันทึกข้อมูลตาราง perEducation ครั้งละหลายเรคคอร์ด>
--  1. order								เป็น VARCHAR	รับค่าลำดับของเรคคอร์ด
--  2. perPersonId							เป็น VARCHAR	รับค่ารหัสบุคคล
--  3. plcCountryIdPrimarySchool			เป็น VARCHAR	รับค่ารหัสประเทศของการศึกษาระดับประถม
--  4. plcProvinceIdPrimarySchool			เป็น VARCHAR	รับค่ารหัสสถานที่หรือจังหวัดของการศึกษาระดับประถม
--  5. primarySchoolName					เป็น NVARCHAR	รับค่าชื่อสถานศึกษาของการศึกษาระดับประถม
--  6. primarySchoolYearAttended			เป็น VARCHAR	รับค่าปีที่เข้าศึกษาของการศึกษาระดับประถม
--  7. primarySchoolYearGraduate			เป็น VARCHAR	รับค่าปีที่สำเร็จการศึกษาของการศึกษาระดับประถม
--  8. primarySchoolGPA						เป็น VARCHAR	รับค่าเกรดเฉลี่ยของการศึกษาระดับประถม
--  9. plcCountryIdJuniorHighSchool			เป็น VARCHAR	รับค่ารหัสประเทศของการศึกษาระดับมัธยมต้น
-- 10. plcProvinceIdJuniorHighSchool		เป็น VARCHAR	รับค่ารหัสสถานที่หรือจังหวัดของการศึกษาระดับมัธยมต้น
-- 11. juniorHighSchoolName					เป็น NVARCHAR	รับค่าชื่อสถานศึกษาของการศึกษาระดับมัธยมต้น
-- 12. juniorHighSchoolYearAttended			เป็น VARCHAR	รับค่าปีที่เข้าศึกษาของการศึกษาระดับมัธยมต้น
-- 13. juniorHighSchoolYearGraduate			เป็น VARCHAR	รับค่าปีที่สำเร็จการศึกษาของการศึกษาระดับมัธยมต้น
-- 14. juniorHighSchoolGPA					เป็น VARCHAR	รับค่าเกรดเฉลี่ยของการศึกษาระดับมัธยมต้น
-- 15. plcCountryIdHighSchool				เป็น VARCHAR	รับค่ารหัสประเทศของการศึกษาระดับมัธยมปลาย
-- 16. plcProvinceIdHighSchool				เป็น VARCHAR	รับค่ารหัสสถานที่หรือจังหวัดของการศึกษาระดับมัธยมปลาย
-- 17. highSchoolName						เป็น NVARCHAR	รับค่าชื่อสถานศึกษาของการศึกษาระดับมัธยมปลาย
-- 18. highSchoolStudentId					เป็น NVARCHAR	รับค่าเลขประจำตัวนักเรียนของการศึกษาระดับมัธยมปลาย
-- 19. perEducationalMajorIdHighSchool		เป็น VARCHAR	รับค่ารหัสสายการเรียนของการศึกษาระดับมัธยมปลาย
-- 20. educationalMajorOtherHighSchool		เป็น NVARCHAR	รับค่าสายการเรียนอื่น ๆ ของการศึกษาระดับมัธยมปลาย
-- 21. highSchoolYearAttended				เป็น VARCHAR	รับค่าปีที่เข้าศึกษาของการศึกษาระดับมัธยมปลาย
-- 22. highSchoolYearGraduate				เป็น VARCHAR	รับค่าปีที่สำเร็จการศึกษาของการศึกษาระดับมัธยมปลาย
-- 23. highSchoolGPA						เป็น VARCHAR	รับค่าเกรดเฉลี่ยของการศึกษาระดับมัธยมปลาย
-- 24. perEducationalBackgroundIdHighSchool	เป็น VARCHAR	รับค่ารหัสวุฒิการศึกษาของการศึกษาระดับมัธยมปลาย
-- 25. perEducationalBackgroundId			เป็น VARCHAR	รับค่ารหัสวุฒิการศึกษาของการศึกษาก่อนเข้ามหาวิทยาลัยมหิดล
-- 26. graduateBy							เป็น VARCHAR	รับค่าวิธีการสอบเข้าของการศึกษาก่อนเข้ามหาวิทยาลัยมหิดล
-- 27. graduateBySchoolName					เป็น NVARCHAR	รับค่าชื่อโรงเรียนของวิธีการสอบเข้าโดยการสอบเทียบของการศึกษาก่อนเข้ามหาวิทยาลัยมหิดล
-- 28. entranceTime							เป็น VARCHAR	รับค่าจำนวนครั้งที่สอบเข้าของการศึกษาก่อนเข้ามหาวิทยาลัยมหิดล
-- 29. studentIs							เป็น VARCHAR	รับค่าการเคยเป็นนักศึกษาของการศึกษาก่อนเข้ามหาวิทยาลัยมหิดล
-- 30. studentIsUniversity					เป็น NVARCHAR	รับค่าการเคยเป็นนักศึกษาของมหาวิทยาลัยของการศึกษาก่อนเข้ามหาวิทยาลัยมหิดล
-- 31. studentIsFaculty						เป็น NVARCHAR	รับค่าการเคยเป็นนักศึกษาของคณะของการศึกษาก่อนเข้ามหาวิทยาลัยมหิดล
-- 31. studentIsProgram						เป็น NVARCHAR	รับค่าการเคยเป็นนักศึกษาของหลักสูตรของการศึกษาก่อนเข้ามหาวิทยาลัยมหิดล
-- 32. perEntranceTypeId					เป็น VARCHAR	รับค่ารหัสระบบที่สอบเข้าของการศึกษาก่อนเข้ามหาวิทยาลัยมหิดล
-- 33. admissionRanking						เป็น VARCHAR	รับค่าลำดับที่ของการสอบได้ของการศึกษาก่อนเข้ามหาวิทยาลัยมหิดล
-- 34. scoreONET01							เป็น VARCHAR	รับค่าคะแนนสอบ ONET01
-- 35. scoreONET02							เป็น VARCHAR	รับค่าคะแนนสอบ ONET02
-- 36. scoreONET03							เป็น VARCHAR	รับค่าคะแนนสอบ ONET03
-- 37. scoreONET04							เป็น VARCHAR	รับค่าคะแนนสอบ ONET04
-- 38. scoreONET05							เป็น VARCHAR	รับค่าคะแนนสอบ ONET05
-- 39. scoreONET06							เป็น VARCHAR	รับค่าคะแนนสอบ ONET06
-- 40. scoreONET07							เป็น VARCHAR	รับค่าคะแนนสอบ ONET07
-- 41. scoreONET08							เป็น VARCHAR	รับค่าคะแนนสอบ ONET08
-- 42. scoreANET11							เป็น VARCHAR	รับค่าคะแนนสอบ ANET11
-- 43. scoreANET12							เป็น VARCHAR	รับค่าคะแนนสอบ ANET12
-- 44. scoreANET13							เป็น VARCHAR	รับค่าคะแนนสอบ ANET13
-- 45. scoreANET14							เป็น VARCHAR	รับค่าคะแนนสอบ ANET14
-- 46. scoreANET15							เป็น VARCHAR	รับค่าคะแนนสอบ ANET15
-- 47. scoreGAT85							เป็น VARCHAR	รับค่าคะแนนสอบ GAT85
-- 48. scorePAT71							เป็น VARCHAR	รับค่าคะแนนสอบ PAT71
-- 49. scorePAT72							เป็น VARCHAR	รับค่าคะแนนสอบ PAT72
-- 50. scorePAT73							เป็น VARCHAR	รับค่าคะแนนสอบ PAT73
-- 51. scorePAT74							เป็น VARCHAR	รับค่าคะแนนสอบ PAT74
-- 52. scorePAT75							เป็น VARCHAR	รับค่าคะแนนสอบ PAT75
-- 53. scorePAT76							เป็น VARCHAR	รับค่าคะแนนสอบ PAT76
-- 53. scorePAT77							เป็น VARCHAR	รับค่าคะแนนสอบ PAT77
-- 54. scorePAT78							เป็น VARCHAR	รับค่าคะแนนสอบ PAT78
-- 55. scorePAT79							เป็น VARCHAR	รับค่าคะแนนสอบ PAT79
-- 56. scorePAT80							เป็น VARCHAR	รับค่าคะแนนสอบ PAT80
-- 57. scorePAT81							เป็น VARCHAR	รับค่าคะแนนสอบ PAT81
-- 58. scorePAT82							เป็น VARCHAR	รับค่าคะแนนสอบ PAT82
-- 59. by									เป็น NVARCHAR	รับค่าชื่อของผู้ที่กระทำกับฐานข้อมูล
-- =============================================
ALTER PROCEDURE [dbo].[sp_perSetListEducation]
(
	@order VARCHAR(MAX) = NULL,
	@perPersonId VARCHAR(MAX) = NULL,
	@plcCountryIdPrimarySchool VARCHAR(MAX) = NULL,
	@plcProvinceIdPrimarySchool VARCHAR(MAX) = NULL,
	@primarySchoolName NVARCHAR(MAX) = NULL,
	@primarySchoolYearAttended VARCHAR(MAX) = NULL,
	@primarySchoolYearGraduate VARCHAR(MAX) = NULL,
	@primarySchoolGPA VARCHAR(MAX) = NULL,
	@plcCountryIdJuniorHighSchool VARCHAR(MAX) = NULL,
	@plcProvinceIdJuniorHighSchool VARCHAR(MAX) = NULL,
	@juniorHighSchoolName NVARCHAR(MAX) = NULL,
	@juniorHighSchoolYearAttended VARCHAR(MAX) = NULL,
	@juniorHighSchoolYearGraduate VARCHAR(MAX) = NULL,
	@juniorHighSchoolGPA VARCHAR(MAX) = NULL,
	@plcCountryIdHighSchool VARCHAR(MAX) = NULL,
	@plcProvinceIdHighSchool VARCHAR(MAX) = NULL,
	@highSchoolName NVARCHAR(MAX) = NULL,
	@highSchoolStudentId NVARCHAR(MAX) = NULL,
	@perEducationalMajorIdHighSchool VARCHAR(MAX) = NULL,
	@educationalMajorOtherHighSchool NVARCHAR(MAX) = NULL,
	@highSchoolYearAttended VARCHAR(MAX) = NULL,
	@highSchoolYearGraduate VARCHAR(MAX) = NULL,
	@highSchoolGPA VARCHAR(MAX) = NULL,
	@perEducationalBackgroundIdHighSchool VARCHAR(MAX) = NULL,
	@perEducationalBackgroundId VARCHAR(MAX) = NULL,
	@graduateBy VARCHAR(MAX) = NULL,
	@graduateBySchoolName NVARCHAR(MAX) = NULL,
	@entranceTime VARCHAR(MAX) = NULL,
	@studentIs VARCHAR(MAX) = NULL,
	@studentIsUniversity NVARCHAR(MAX) = NULL,
	@studentIsFaculty NVARCHAR(MAX) = NULL,
	@studentIsProgram NVARCHAR(MAX) = NULL,
	@perEntranceTypeId VARCHAR(MAX) = NULL,
	@admissionRanking VARCHAR(MAX) = NULL,
	@scoreONET01 VARCHAR(MAX) = NULL,
	@scoreONET02 VARCHAR(MAX) = NULL,
	@scoreONET03 VARCHAR(MAX) = NULL,
	@scoreONET04 VARCHAR(MAX) = NULL,
	@scoreONET05 VARCHAR(MAX) = NULL,
	@scoreONET06 VARCHAR(MAX) = NULL,
	@scoreONET07 VARCHAR(MAX) = NULL,
	@scoreONET08 VARCHAR(MAX) = NULL,
	@scoreANET11 VARCHAR(MAX) = NULL,
	@scoreANET12 VARCHAR(MAX) = NULL,
	@scoreANET13 VARCHAR(MAX) = NULL,
	@scoreANET14 VARCHAR(MAX) = NULL,
	@scoreANET15 VARCHAR(MAX) = NULL,
	@scoreGAT85 VARCHAR(MAX) = NULL,
	@scorePAT71 VARCHAR(MAX) = NULL,
	@scorePAT72 VARCHAR(MAX) = NULL,
	@scorePAT73 VARCHAR(MAX) = NULL,
	@scorePAT74 VARCHAR(MAX) = NULL,
	@scorePAT75 VARCHAR(MAX) = NULL,
	@scorePAT76 VARCHAR(MAX) = NULL,
	@scorePAT77 VARCHAR(MAX) = NULL,
	@scorePAT78 VARCHAR(MAX) = NULL,
	@scorePAT79 VARCHAR(MAX) = NULL,
	@scorePAT80 VARCHAR(MAX) = NULL,
	@scorePAT81 VARCHAR(MAX) = NULL,
	@scorePAT82 VARCHAR(MAX) = NULL,
	@by NVARCHAR(255) = NULL 
)	
AS
BEGIN
	SET NOCOUNT ON
	
	SET @order = LTRIM(RTRIM(@order))
	SET	@perPersonId = LTRIM(RTRIM(@perPersonId))
	SET @plcCountryIdPrimarySchool = LTRIM(RTRIM(@plcCountryIdPrimarySchool))
	SET @plcProvinceIdPrimarySchool = LTRIM(RTRIM(@plcProvinceIdPrimarySchool))
	SET @primarySchoolName = LTRIM(RTRIM(@primarySchoolName))
	SET @primarySchoolYearAttended = LTRIM(RTRIM(@primarySchoolYearAttended))
	SET @primarySchoolYearGraduate = LTRIM(RTRIM(@primarySchoolYearGraduate))
	SET @primarySchoolGPA = LTRIM(RTRIM(@primarySchoolGPA))
	SET @plcCountryIdJuniorHighSchool = LTRIM(RTRIM(@plcCountryIdJuniorHighSchool))
	SET @plcProvinceIdJuniorHighSchool = LTRIM(RTRIM(@plcProvinceIdJuniorHighSchool))
	SET @juniorHighSchoolName = LTRIM(RTRIM(@juniorHighSchoolName))
	SET @juniorHighSchoolYearAttended = LTRIM(RTRIM(@juniorHighSchoolYearAttended))
	SET @juniorHighSchoolYearGraduate = LTRIM(RTRIM(@juniorHighSchoolYearGraduate))
	SET @juniorHighSchoolGPA = LTRIM(RTRIM(@juniorHighSchoolGPA))
	SET @plcCountryIdHighSchool = LTRIM(RTRIM(@plcCountryIdHighSchool))
	SET @plcProvinceIdHighSchool = LTRIM(RTRIM(@plcProvinceIdHighSchool))
	SET @highSchoolName = LTRIM(RTRIM(@highSchoolName))
	SET @highSchoolStudentId = LTRIM(RTRIM(@highSchoolStudentId))
	SET @perEducationalMajorIdHighSchool = LTRIM(RTRIM(@perEducationalMajorIdHighSchool))
	SET @educationalMajorOtherHighSchool = LTRIM(RTRIM(@educationalMajorOtherHighSchool))
	SET @highSchoolYearAttended = LTRIM(RTRIM(@highSchoolYearAttended))
	SET @highSchoolYearGraduate = LTRIM(RTRIM(@highSchoolYearGraduate))
	SET @highSchoolGPA = LTRIM(RTRIM(@highSchoolGPA))
	SET @perEducationalBackgroundIdHighSchool = LTRIM(RTRIM(@perEducationalBackgroundIdHighSchool))
	SET @perEducationalBackgroundId = LTRIM(RTRIM(@perEducationalBackgroundId))
	SET @graduateBy = LTRIM(RTRIM(@graduateBy))
	SET @graduateBySchoolName = LTRIM(RTRIM(@graduateBySchoolName))
	SET @entranceTime = LTRIM(RTRIM(@entranceTime))
	SET @studentIs = LTRIM(RTRIM(@studentIs))
	SET @studentIsUniversity = LTRIM(RTRIM(@studentIsUniversity))
	SET @studentIsFaculty = LTRIM(RTRIM(@studentIsFaculty))
	SET @studentIsProgram = LTRIM(RTRIM(@studentIsProgram))
	SET @perEntranceTypeId = LTRIM(RTRIM(@perEntranceTypeId))
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
	
	DECLARE @action VARCHAR(10) = 'INSERT'
	DECLARE @table VARCHAR(50) = 'perEducation'
	DECLARE @i INT = 1
	DECLARE @delimiter CHAR(1) = ';'
	DECLARE @orderSlice VARCHAR(MAX) = NULL
	DECLARE @perPersonIdSlice VARCHAR(MAX) = NULL
	DECLARE @plcCountryIdPrimarySchoolSlice VARCHAR(MAX) = NULL
	DECLARE @plcProvinceIdPrimarySchoolSlice VARCHAR(MAX) = NULL
	DECLARE @primarySchoolNameSlice NVARCHAR(MAX) = NULL
	DECLARE @primarySchoolYearAttendedSlice VARCHAR(MAX) = NULL
	DECLARE @primarySchoolYearGraduateSlice VARCHAR(MAX) = NULL
	DECLARE @primarySchoolGPASlice VARCHAR(MAX) = NULL
	DECLARE @plcCountryIdJuniorHighSchoolSlice VARCHAR(MAX) = NULL
	DECLARE @plcProvinceIdJuniorHighSchoolSlice VARCHAR(MAX) = NULL
	DECLARE @juniorHighSchoolNameSlice NVARCHAR(MAX) = NULL
	DECLARE @juniorHighSchoolYearAttendedSlice VARCHAR(MAX) = NULL
	DECLARE @juniorHighSchoolYearGraduateSlice VARCHAR(MAX) = NULL
	DECLARE @juniorHighSchoolGPASlice VARCHAR(MAX) = NULL
	DECLARE @plcCountryIdHighSchoolSlice VARCHAR(MAX) = NULL
	DECLARE @plcProvinceIdHighSchoolSlice VARCHAR(MAX) = NULL
	DECLARE @highSchoolNameSlice NVARCHAR(MAX) = NULL
	DECLARE @highSchoolStudentIdSlice NVARCHAR(MAX) = NULL
	DECLARE @perEducationalMajorIdHighSchoolSlice VARCHAR(MAX) = NULL
	DECLARE @educationalMajorOtherHighSchoolSlice NVARCHAR(MAX) = NULL
	DECLARE @highSchoolYearAttendedSlice VARCHAR(MAX) = NULL
	DECLARE @highSchoolYearGraduateSlice VARCHAR(MAX) = NULL
	DECLARE @highSchoolGPASlice VARCHAR(MAX) = NULL
	DECLARE @perEducationalBackgroundIdHighSchoolSlice VARCHAR(MAX) = NULL
	DECLARE @perEducationalBackgroundIdSlice VARCHAR(MAX) = NULL
	DECLARE @graduateBySlice VARCHAR(MAX) = NULL
	DECLARE @graduateBySchoolNameSlice NVARCHAR(MAX) = NULL
	DECLARE @entranceTimeSlice VARCHAR(MAX) = NULL
	DECLARE @studentIsSlice VARCHAR(MAX) = NULL
	DECLARE @studentIsUniversitySlice NVARCHAR(MAX) = NULL
	DECLARE @studentIsFacultySlice NVARCHAR(MAX) = NULL
	DECLARE @studentIsProgramSlice NVARCHAR(MAX) = NULL
	DECLARE @perEntranceTypeIdSlice VARCHAR(MAX) = NULL
	DECLARE @admissionRankingSlice VARCHAR(MAX) = NULL
	DECLARE @scoreONET01Slice VARCHAR(MAX) = NULL
	DECLARE @scoreONET02Slice VARCHAR(MAX) = NULL
	DECLARE @scoreONET03Slice VARCHAR(MAX) = NULL
	DECLARE @scoreONET04Slice VARCHAR(MAX) = NULL
	DECLARE @scoreONET05Slice VARCHAR(MAX) = NULL
	DECLARE @scoreONET06Slice VARCHAR(MAX) = NULL
	DECLARE @scoreONET07Slice VARCHAR(MAX) = NULL
	DECLARE @scoreONET08Slice VARCHAR(MAX) = NULL
	DECLARE @scoreANET11Slice VARCHAR(MAX) = NULL
	DECLARE @scoreANET12Slice VARCHAR(MAX) = NULL
	DECLARE @scoreANET13Slice VARCHAR(MAX) = NULL
	DECLARE @scoreANET14Slice VARCHAR(MAX) = NULL
	DECLARE @scoreANET15Slice VARCHAR(MAX) = NULL
	DECLARE @scoreGAT85Slice VARCHAR(MAX) = NULL
	DECLARE @scorePAT71Slice VARCHAR(MAX) = NULL
	DECLARE @scorePAT72Slice VARCHAR(MAX) = NULL
	DECLARE @scorePAT73Slice VARCHAR(MAX) = NULL
	DECLARE @scorePAT74Slice VARCHAR(MAX) = NULL
	DECLARE @scorePAT75Slice VARCHAR(MAX) = NULL
	DECLARE @scorePAT76Slice VARCHAR(MAX) = NULL
	DECLARE @scorePAT77Slice VARCHAR(MAX) = NULL
	DECLARE @scorePAT78Slice VARCHAR(MAX) = NULL
	DECLARE @scorePAT79Slice VARCHAR(MAX) = NULL
	DECLARE @scorePAT80Slice VARCHAR(MAX) = NULL
	DECLARE @scorePAT81Slice VARCHAR(MAX) = NULL
	DECLARE @scorePAT82Slice VARCHAR(MAX) = NULL
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
		
		SET @plcCountryIdPrimarySchoolSlice = (SELECT stringSlice FROM fnc_perParseString(@plcCountryIdPrimarySchool, @delimiter))
		SET @plcCountryIdPrimarySchool = (SELECT string FROM fnc_perParseString(@plcCountryIdPrimarySchool, @delimiter))

		SET @plcProvinceIdPrimarySchoolSlice = (SELECT stringSlice FROM fnc_perParseString(@plcProvinceIdPrimarySchool, @delimiter))
		SET @plcProvinceIdPrimarySchool = (SELECT string FROM fnc_perParseString(@plcProvinceIdPrimarySchool, @delimiter))		
		
		SET @primarySchoolNameSlice = (SELECT stringSlice FROM fnc_perParseString(@primarySchoolName, @delimiter))
		SET @primarySchoolName = (SELECT string FROM fnc_perParseString(@primarySchoolName, @delimiter))	

		SET @primarySchoolYearAttendedSlice = (SELECT stringSlice FROM fnc_perParseString(@primarySchoolYearAttended, @delimiter))
		SET @primarySchoolYearAttended = (SELECT string FROM fnc_perParseString(@primarySchoolYearAttended, @delimiter))			
		
		SET @primarySchoolYearGraduateSlice = (SELECT stringSlice FROM fnc_perParseString(@primarySchoolYearGraduate, @delimiter))
		SET @primarySchoolYearGraduate = (SELECT string FROM fnc_perParseString(@primarySchoolYearGraduate, @delimiter))
		
		SET @primarySchoolGPASlice = (SELECT stringSlice FROM fnc_perParseString(@primarySchoolGPA, @delimiter))
		SET @primarySchoolGPA = (SELECT string FROM fnc_perParseString(@primarySchoolGPA, @delimiter))		

		SET @plcCountryIdJuniorHighSchoolSlice = (SELECT stringSlice FROM fnc_perParseString(@plcCountryIdJuniorHighSchool, @delimiter))
		SET @plcCountryIdJuniorHighSchool = (SELECT string FROM fnc_perParseString(@plcCountryIdJuniorHighSchool, @delimiter))		
		
		SET @plcProvinceIdJuniorHighSchoolSlice = (SELECT stringSlice FROM fnc_perParseString(@plcProvinceIdJuniorHighSchool, @delimiter))
		SET @plcProvinceIdJuniorHighSchool = (SELECT string FROM fnc_perParseString(@plcProvinceIdJuniorHighSchool, @delimiter))		
		
		SET @juniorHighSchoolNameSlice = (SELECT stringSlice FROM fnc_perParseString(@juniorHighSchoolName, @delimiter))
		SET @juniorHighSchoolName = (SELECT string FROM fnc_perParseString(@juniorHighSchoolName, @delimiter))
		
		SET @juniorHighSchoolYearAttendedSlice = (SELECT stringSlice FROM fnc_perParseString(@juniorHighSchoolYearAttended, @delimiter))
		SET @juniorHighSchoolYearAttended = (SELECT string FROM fnc_perParseString(@juniorHighSchoolYearAttended, @delimiter))

		SET @juniorHighSchoolYearGraduateSlice = (SELECT stringSlice FROM fnc_perParseString(@juniorHighSchoolYearGraduate, @delimiter))
		SET @juniorHighSchoolYearGraduate = (SELECT string FROM fnc_perParseString(@juniorHighSchoolYearGraduate, @delimiter))		

		SET @juniorHighSchoolGPASlice = (SELECT stringSlice FROM fnc_perParseString(@juniorHighSchoolGPA, @delimiter))
		SET @juniorHighSchoolGPA = (SELECT string FROM fnc_perParseString(@juniorHighSchoolGPA, @delimiter))		

		SET @plcCountryIdHighSchoolSlice = (SELECT stringSlice FROM fnc_perParseString(@plcCountryIdHighSchool, @delimiter))
		SET @plcCountryIdHighSchool = (SELECT string FROM fnc_perParseString(@plcCountryIdHighSchool, @delimiter))		
		
		SET @plcProvinceIdHighSchoolSlice = (SELECT stringSlice FROM fnc_perParseString(@plcProvinceIdHighSchool, @delimiter))
		SET @plcProvinceIdHighSchool = (SELECT string FROM fnc_perParseString(@plcProvinceIdHighSchool, @delimiter))
		
		SET @highSchoolNameSlice = (SELECT stringSlice FROM fnc_perParseString(@highSchoolName, @delimiter))
		SET @highSchoolName = (SELECT string FROM fnc_perParseString(@highSchoolName, @delimiter))

		SET @highSchoolStudentIdSlice = (SELECT stringSlice FROM fnc_perParseString(@highSchoolStudentId, @delimiter))
		SET @highSchoolStudentId = (SELECT string FROM fnc_perParseString(@highSchoolStudentId, @delimiter))

		SET @perEducationalMajorIdHighSchoolSlice = (SELECT stringSlice FROM fnc_perParseString(@perEducationalMajorIdHighSchool, @delimiter))
		SET @perEducationalMajorIdHighSchool = (SELECT string FROM fnc_perParseString(@perEducationalMajorIdHighSchool, @delimiter))

		SET @educationalMajorOtherHighSchoolSlice = (SELECT stringSlice FROM fnc_perParseString(@educationalMajorOtherHighSchool, @delimiter))
		SET @educationalMajorOtherHighSchool = (SELECT string FROM fnc_perParseString(@educationalMajorOtherHighSchool, @delimiter))

		SET @highSchoolYearAttendedSlice = (SELECT stringSlice FROM fnc_perParseString(@highSchoolYearAttended, @delimiter))
		SET @highSchoolYearAttended = (SELECT string FROM fnc_perParseString(@highSchoolYearAttended, @delimiter))

		SET @highSchoolYearGraduateSlice = (SELECT stringSlice FROM fnc_perParseString(@highSchoolYearGraduate, @delimiter))
		SET @highSchoolYearGraduate = (SELECT string FROM fnc_perParseString(@highSchoolYearGraduate, @delimiter))

		SET @highSchoolGPASlice = (SELECT stringSlice FROM fnc_perParseString(@highSchoolGPA, @delimiter))
		SET @highSchoolGPA = (SELECT string FROM fnc_perParseString(@highSchoolGPA, @delimiter))

		SET @perEducationalBackgroundIdHighSchoolSlice = (SELECT stringSlice FROM fnc_perParseString(@perEducationalBackgroundIdHighSchool, @delimiter))
		SET @perEducationalBackgroundIdHighSchool = (SELECT string FROM fnc_perParseString(@perEducationalBackgroundIdHighSchool, @delimiter))

		SET @perEducationalBackgroundIdSlice = (SELECT stringSlice FROM fnc_perParseString(@perEducationalBackgroundId, @delimiter))
		SET @perEducationalBackgroundId = (SELECT string FROM fnc_perParseString(@perEducationalBackgroundId, @delimiter))

		SET @graduateBySlice = (SELECT stringSlice FROM fnc_perParseString(@graduateBy, @delimiter))
		SET @graduateBy = (SELECT string FROM fnc_perParseString(@graduateBy, @delimiter))		
		
		SET @graduateBySchoolNameSlice = (SELECT stringSlice FROM fnc_perParseString(@graduateBySchoolName, @delimiter))
		SET @graduateBySchoolName = (SELECT string FROM fnc_perParseString(@graduateBySchoolName, @delimiter))		

		SET @entranceTimeSlice = (SELECT stringSlice FROM fnc_perParseString(@entranceTime, @delimiter))
		SET @entranceTime = (SELECT string FROM fnc_perParseString(@entranceTime, @delimiter))		

		SET @studentIsSlice = (SELECT stringSlice FROM fnc_perParseString(@studentIs, @delimiter))
		SET @studentIs = (SELECT string FROM fnc_perParseString(@studentIs, @delimiter))		

		SET @studentIsUniversitySlice = (SELECT stringSlice FROM fnc_perParseString(@studentIsUniversity, @delimiter))
		SET @studentIsUniversity = (SELECT string FROM fnc_perParseString(@studentIsUniversity, @delimiter))		

		SET @studentIsFacultySlice = (SELECT stringSlice FROM fnc_perParseString(@studentIsFaculty, @delimiter))
		SET @studentIsFaculty = (SELECT string FROM fnc_perParseString(@studentIsFaculty, @delimiter))		

		SET @studentIsProgramSlice = (SELECT stringSlice FROM fnc_perParseString(@studentIsProgram, @delimiter))
		SET @studentIsProgram = (SELECT string FROM fnc_perParseString(@studentIsProgram, @delimiter))		

		SET @perEntranceTypeIdSlice = (SELECT stringSlice FROM fnc_perParseString(@perEntranceTypeId, @delimiter))
		SET @perEntranceTypeId = (SELECT string FROM fnc_perParseString(@perEntranceTypeId, @delimiter))		

		SET @admissionRankingSlice = (SELECT stringSlice FROM fnc_perParseString(@admissionRanking, @delimiter))
		SET @admissionRanking = (SELECT string FROM fnc_perParseString(@admissionRanking, @delimiter))		

		SET @scoreONET01Slice = (SELECT stringSlice FROM fnc_perParseString(@scoreONET01, @delimiter))
		SET @scoreONET01 = (SELECT string FROM fnc_perParseString(@scoreONET01, @delimiter))		

		SET @scoreONET02Slice = (SELECT stringSlice FROM fnc_perParseString(@scoreONET02, @delimiter))
		SET @scoreONET02 = (SELECT string FROM fnc_perParseString(@scoreONET02, @delimiter))				
		
		SET @scoreONET03Slice = (SELECT stringSlice FROM fnc_perParseString(@scoreONET03, @delimiter))
		SET @scoreONET03 = (SELECT string FROM fnc_perParseString(@scoreONET03, @delimiter))				

		SET @scoreONET04Slice = (SELECT stringSlice FROM fnc_perParseString(@scoreONET04, @delimiter))
		SET @scoreONET04 = (SELECT string FROM fnc_perParseString(@scoreONET04, @delimiter))				

		SET @scoreONET05Slice = (SELECT stringSlice FROM fnc_perParseString(@scoreONET05, @delimiter))
		SET @scoreONET05 = (SELECT string FROM fnc_perParseString(@scoreONET05, @delimiter))				

		SET @scoreONET06Slice = (SELECT stringSlice FROM fnc_perParseString(@scoreONET06, @delimiter))
		SET @scoreONET06 = (SELECT string FROM fnc_perParseString(@scoreONET06, @delimiter))				

		SET @scoreONET07Slice = (SELECT stringSlice FROM fnc_perParseString(@scoreONET07, @delimiter))
		SET @scoreONET07 = (SELECT string FROM fnc_perParseString(@scoreONET07, @delimiter))				

		SET @scoreONET08Slice = (SELECT stringSlice FROM fnc_perParseString(@scoreONET08, @delimiter))
		SET @scoreONET08 = (SELECT string FROM fnc_perParseString(@scoreONET08, @delimiter))				

		SET @scoreANET11Slice = (SELECT stringSlice FROM fnc_perParseString(@scoreANET11, @delimiter))
		SET @scoreANET11 = (SELECT string FROM fnc_perParseString(@scoreANET11, @delimiter))				

		SET @scoreANET12Slice = (SELECT stringSlice FROM fnc_perParseString(@scoreANET12, @delimiter))
		SET @scoreANET12 = (SELECT string FROM fnc_perParseString(@scoreANET12, @delimiter))				

		SET @scoreANET13Slice = (SELECT stringSlice FROM fnc_perParseString(@scoreANET13, @delimiter))
		SET @scoreANET13 = (SELECT string FROM fnc_perParseString(@scoreANET13, @delimiter))				

		SET @scoreANET14Slice = (SELECT stringSlice FROM fnc_perParseString(@scoreANET14, @delimiter))
		SET @scoreANET14 = (SELECT string FROM fnc_perParseString(@scoreANET14, @delimiter))						
		
		SET @scoreANET15Slice = (SELECT stringSlice FROM fnc_perParseString(@scoreANET15, @delimiter))
		SET @scoreANET15 = (SELECT string FROM fnc_perParseString(@scoreANET15, @delimiter))						

		SET @scoreGAT85Slice = (SELECT stringSlice FROM fnc_perParseString(@scoreGAT85, @delimiter))
		SET @scoreGAT85 = (SELECT string FROM fnc_perParseString(@scoreGAT85, @delimiter))						

		SET @scorePAT71Slice = (SELECT stringSlice FROM fnc_perParseString(@scorePAT71, @delimiter))
		SET @scorePAT71 = (SELECT string FROM fnc_perParseString(@scorePAT71, @delimiter))						

		SET @scorePAT72Slice = (SELECT stringSlice FROM fnc_perParseString(@scorePAT72, @delimiter))
		SET @scorePAT72 = (SELECT string FROM fnc_perParseString(@scorePAT72, @delimiter))						

		SET @scorePAT73Slice = (SELECT stringSlice FROM fnc_perParseString(@scorePAT73, @delimiter))
		SET @scorePAT73 = (SELECT string FROM fnc_perParseString(@scorePAT73, @delimiter))						

		SET @scorePAT74Slice = (SELECT stringSlice FROM fnc_perParseString(@scorePAT74, @delimiter))
		SET @scorePAT74 = (SELECT string FROM fnc_perParseString(@scorePAT74, @delimiter))						

		SET @scorePAT75Slice = (SELECT stringSlice FROM fnc_perParseString(@scorePAT75, @delimiter))
		SET @scorePAT75 = (SELECT string FROM fnc_perParseString(@scorePAT75, @delimiter))						

		SET @scorePAT76Slice = (SELECT stringSlice FROM fnc_perParseString(@scorePAT76, @delimiter))
		SET @scorePAT76 = (SELECT string FROM fnc_perParseString(@scorePAT76, @delimiter))						

		SET @scorePAT77Slice = (SELECT stringSlice FROM fnc_perParseString(@scorePAT77, @delimiter))
		SET @scorePAT77 = (SELECT string FROM fnc_perParseString(@scorePAT77, @delimiter))						

		SET @scorePAT78Slice = (SELECT stringSlice FROM fnc_perParseString(@scorePAT78, @delimiter))
		SET @scorePAT78 = (SELECT string FROM fnc_perParseString(@scorePAT78, @delimiter))						
	
		SET @scorePAT79Slice = (SELECT stringSlice FROM fnc_perParseString(@scorePAT79, @delimiter))
		SET @scorePAT79 = (SELECT string FROM fnc_perParseString(@scorePAT79, @delimiter))						

		SET @scorePAT80Slice = (SELECT stringSlice FROM fnc_perParseString(@scorePAT80, @delimiter))
		SET @scorePAT80 = (SELECT string FROM fnc_perParseString(@scorePAT80, @delimiter))						

		SET @scorePAT81Slice = (SELECT stringSlice FROM fnc_perParseString(@scorePAT81, @delimiter))
		SET @scorePAT81 = (SELECT string FROM fnc_perParseString(@scorePAT81, @delimiter))						

		SET @scorePAT82Slice = (SELECT stringSlice FROM fnc_perParseString(@scorePAT82, @delimiter))
		SET @scorePAT82 = (SELECT string FROM fnc_perParseString(@scorePAT82, @delimiter))						
		
		IF (LEN(@orderSlice) > 0)
		BEGIN			
			SET @value = 'perPersonId=' + (CASE WHEN (@perPersonIdSlice IS NOT NULL AND LEN(@perPersonIdSlice) > 0 AND CHARINDEX(@perPersonIdSlice, @strBlank) = 0) THEN ('"' + @perPersonIdSlice + '"') ELSE 'NULL' END) + ', ' +
						 'plcCountryIdPrimarySchool=' + (CASE WHEN (@plcCountryIdPrimarySchoolSlice IS NOT NULL AND LEN(@plcCountryIdPrimarySchoolSlice) > 0 AND CHARINDEX(@plcCountryIdPrimarySchoolSlice, @strBlank) = 0) THEN ('"' + @plcCountryIdPrimarySchoolSlice + '"') ELSE 'NULL' END) + ', ' +
						 'plcProvinceIdPrimarySchool=' + (CASE WHEN (@plcProvinceIdPrimarySchoolSlice IS NOT NULL AND LEN(@plcProvinceIdPrimarySchoolSlice) > 0 AND CHARINDEX(@plcProvinceIdPrimarySchoolSlice, @strBlank) = 0) THEN ('"' + @plcProvinceIdPrimarySchoolSlice + '"') ELSE 'NULL' END) + ', ' +
						 'primarySchoolName=' + (CASE WHEN (@primarySchoolNameSlice IS NOT NULL AND LEN(@primarySchoolNameSlice) > 0 AND CHARINDEX(@primarySchoolNameSlice, @strBlank) = 0) THEN ('"' + @primarySchoolNameSlice + '"') ELSE 'NULL' END) + ', ' +
						 'primarySchoolYearAttended=' + (CASE WHEN (@primarySchoolYearAttendedSlice IS NOT NULL AND LEN(@primarySchoolYearAttendedSlice) > 0 AND CHARINDEX(@primarySchoolYearAttendedSlice, @strBlank) = 0) THEN ('"' + @primarySchoolYearAttendedSlice + '"') ELSE 'NULL' END) + ', ' +
						 'primarySchoolYearGraduate=' + (CASE WHEN (@primarySchoolYearGraduateSlice IS NOT NULL AND LEN(@primarySchoolYearGraduateSlice) > 0 AND CHARINDEX(@primarySchoolYearGraduateSlice, @strBlank) = 0) THEN ('"' + @primarySchoolYearGraduateSlice + '"') ELSE 'NULL' END) + ', ' +
						 'primarySchoolGPA=' + (CASE WHEN (@primarySchoolGPASlice IS NOT NULL AND LEN(@primarySchoolGPASlice) > 0 AND CHARINDEX(@primarySchoolGPASlice, @strBlank) = 0) THEN ('"' + @primarySchoolGPASlice + '"') ELSE 'NULL' END) + ', ' +
						 'plcCountryIdJuniorHighSchool=' + (CASE WHEN (@plcCountryIdJuniorHighSchoolSlice IS NOT NULL AND LEN(@plcCountryIdJuniorHighSchoolSlice) > 0 AND CHARINDEX(@plcCountryIdJuniorHighSchoolSlice, @strBlank) = 0) THEN ('"' + @plcCountryIdJuniorHighSchoolSlice + '"') ELSE 'NULL' END) + ', ' +
						 'plcProvinceIdJuniorHighSchool=' + (CASE WHEN (@plcProvinceIdJuniorHighSchoolSlice IS NOT NULL AND LEN(@plcProvinceIdJuniorHighSchoolSlice) > 0 AND CHARINDEX(@plcProvinceIdJuniorHighSchoolSlice, @strBlank) = 0) THEN ('"' + @plcProvinceIdJuniorHighSchoolSlice + '"') ELSE 'NULL' END) + ', ' +
						 'juniorHighSchoolName=' + (CASE WHEN (@juniorHighSchoolNameSlice IS NOT NULL AND LEN(@juniorHighSchoolNameSlice) > 0 AND CHARINDEX(@juniorHighSchoolNameSlice, @strBlank) = 0) THEN ('"' + @juniorHighSchoolNameSlice + '"') ELSE 'NULL' END) + ', ' +
						 'juniorHighSchoolYearAttended=' + (CASE WHEN (@juniorHighSchoolYearAttendedSlice IS NOT NULL AND LEN(@juniorHighSchoolYearAttendedSlice) > 0 AND CHARINDEX(@juniorHighSchoolYearAttendedSlice, @strBlank) = 0) THEN ('"' + @juniorHighSchoolYearAttendedSlice + '"') ELSE 'NULL' END) + ', ' +
						 'juniorHighSchoolYearGraduate=' + (CASE WHEN (@juniorHighSchoolYearGraduateSlice IS NOT NULL AND LEN(@juniorHighSchoolYearGraduateSlice) > 0 AND CHARINDEX(@juniorHighSchoolYearGraduateSlice, @strBlank) = 0) THEN ('"' + @juniorHighSchoolYearGraduateSlice + '"') ELSE 'NULL' END) + ', ' +
						 'juniorHighSchoolGPA=' + (CASE WHEN (@juniorHighSchoolGPASlice IS NOT NULL AND LEN(@juniorHighSchoolGPASlice) > 0 AND CHARINDEX(@juniorHighSchoolGPASlice, @strBlank) = 0) THEN ('"' + @juniorHighSchoolGPASlice + '"') ELSE 'NULL' END) + ', ' +
						 'plcCountryIdHighSchool=' + (CASE WHEN (@plcCountryIdHighSchoolSlice IS NOT NULL AND LEN(@plcCountryIdHighSchoolSlice) > 0 AND CHARINDEX(@plcCountryIdHighSchoolSlice, @strBlank) = 0) THEN ('"' + @plcCountryIdHighSchoolSlice + '"') ELSE 'NULL' END) + ', ' +
						 'plcProvinceIdHighSchool=' + (CASE WHEN (@plcProvinceIdHighSchoolSlice IS NOT NULL AND LEN(@plcProvinceIdHighSchoolSlice) > 0 AND CHARINDEX(@plcProvinceIdHighSchoolSlice, @strBlank) = 0) THEN ('"' + @plcProvinceIdHighSchoolSlice + '"') ELSE 'NULL' END) + ', ' +
						 'highSchoolName=' + (CASE WHEN (@highSchoolNameSlice IS NOT NULL AND LEN(@highSchoolNameSlice) > 0 AND CHARINDEX(@highSchoolNameSlice, @strBlank) = 0) THEN ('"' + @highSchoolNameSlice + '"') ELSE 'NULL' END) + ', ' +
						 'highSchoolStudentId=' + (CASE WHEN (@highSchoolStudentIdSlice IS NOT NULL AND LEN(@highSchoolStudentIdSlice) > 0 AND CHARINDEX(@highSchoolStudentIdSlice, @strBlank) = 0) THEN ('"' + @highSchoolStudentIdSlice + '"') ELSE 'NULL' END) + ', ' +
						 'perEducationalMajorIdHighSchool=' + (CASE WHEN (@perEducationalMajorIdHighSchoolSlice IS NOT NULL AND LEN(@perEducationalMajorIdHighSchoolSlice) > 0 AND CHARINDEX(@perEducationalMajorIdHighSchoolSlice, @strBlank) = 0) THEN ('"' + @perEducationalMajorIdHighSchoolSlice + '"') ELSE 'NULL' END) + ', ' +
						 'educationalMajorOtherHighSchool=' + (CASE WHEN (@educationalMajorOtherHighSchoolSlice IS NOT NULL AND LEN(@educationalMajorOtherHighSchoolSlice) > 0 AND CHARINDEX(@educationalMajorOtherHighSchoolSlice, @strBlank) = 0) THEN ('"' + @educationalMajorOtherHighSchoolSlice + '"') ELSE 'NULL' END) + ', ' +
						 'highSchoolYearAttended=' + (CASE WHEN (@highSchoolYearAttendedSlice IS NOT NULL AND LEN(@highSchoolYearAttendedSlice) > 0 AND CHARINDEX(@highSchoolYearAttendedSlice, @strBlank) = 0) THEN ('"' + @highSchoolYearAttendedSlice + '"') ELSE 'NULL' END) + ', ' +
						 'highSchoolYearGraduate=' + (CASE WHEN (@highSchoolYearGraduateSlice IS NOT NULL AND LEN(@highSchoolYearGraduateSlice) > 0 AND CHARINDEX(@highSchoolYearGraduateSlice, @strBlank) = 0) THEN ('"' + @highSchoolYearGraduateSlice + '"') ELSE 'NULL' END) + ', ' +
						 'highSchoolGPA=' + (CASE WHEN (@highSchoolGPASlice IS NOT NULL AND LEN(@highSchoolGPASlice) > 0 AND CHARINDEX(@highSchoolGPASlice, @strBlank) = 0) THEN ('"' + @highSchoolGPASlice + '"') ELSE 'NULL' END) + ', ' +
						 'perEducationalBackgroundIdHighSchool=' + (CASE WHEN (@perEducationalBackgroundIdHighSchoolSlice IS NOT NULL AND LEN(@perEducationalBackgroundIdHighSchoolSlice) > 0 AND CHARINDEX(@perEducationalBackgroundIdHighSchoolSlice, @strBlank) = 0) THEN ('"' + @perEducationalBackgroundIdHighSchoolSlice + '"') ELSE 'NULL' END) + ', ' +
						 'perEducationalBackgroundId=' + (CASE WHEN (@perEducationalBackgroundIdSlice IS NOT NULL AND LEN(@perEducationalBackgroundIdSlice) > 0 AND CHARINDEX(@perEducationalBackgroundIdSlice, @strBlank) = 0) THEN ('"' + @perEducationalBackgroundIdSlice + '"') ELSE 'NULL' END) + ', ' +
						 'graduateBy=' + (CASE WHEN (@graduateBySlice IS NOT NULL AND LEN(@graduateBySlice) > 0 AND CHARINDEX(@graduateBySlice, @strBlank) = 0) THEN ('"' + @graduateBySlice + '"') ELSE 'NULL' END) + ', ' +
						 'graduateBySchoolName=' + (CASE WHEN (@graduateBySchoolNameSlice IS NOT NULL AND LEN(@graduateBySchoolNameSlice) > 0 AND CHARINDEX(@graduateBySchoolNameSlice, @strBlank) = 0) THEN ('"' + @graduateBySchoolNameSlice + '"') ELSE 'NULL' END) + ', ' +
						 'entranceTime=' + (CASE WHEN (@entranceTimeSlice IS NOT NULL AND LEN(@entranceTimeSlice) > 0 AND CHARINDEX(@entranceTimeSlice, @strBlank) = 0) THEN ('"' + @entranceTimeSlice + '"') ELSE 'NULL' END) + ', ' +
						 'studentIs=' + (CASE WHEN (@studentIsSlice IS NOT NULL AND LEN(@studentIsSlice) > 0 AND CHARINDEX(@studentIsSlice, @strBlank) = 0) THEN ('"' + @studentIsSlice + '"') ELSE 'NULL' END) + ', ' +
						 'studentIsUniversity=' + (CASE WHEN (@studentIsUniversitySlice IS NOT NULL AND LEN(@studentIsUniversitySlice) > 0 AND CHARINDEX(@studentIsUniversitySlice, @strBlank) = 0) THEN ('"' + @studentIsUniversitySlice + '"') ELSE 'NULL' END) + ', ' +
						 'studentIsFaculty=' + (CASE WHEN (@studentIsFacultySlice IS NOT NULL AND LEN(@studentIsFacultySlice) > 0 AND CHARINDEX(@studentIsFacultySlice, @strBlank) = 0) THEN ('"' + @studentIsFacultySlice + '"') ELSE 'NULL' END) + ', ' +
						 'studentIsProgram=' + (CASE WHEN (@studentIsProgramSlice IS NOT NULL AND LEN(@studentIsProgramSlice) > 0 AND CHARINDEX(@studentIsProgramSlice, @strBlank) = 0) THEN ('"' + @studentIsProgramSlice + '"') ELSE 'NULL' END) + ', ' +
						 'perEntranceTypeId=' + (CASE WHEN (@perEntranceTypeIdSlice IS NOT NULL AND LEN(@perEntranceTypeIdSlice) > 0 AND CHARINDEX(@perEntranceTypeIdSlice, @strBlank) = 0) THEN ('"' + @perEntranceTypeIdSlice + '"') ELSE 'NULL' END) + ', ' +
						 'admissionRanking=' + (CASE WHEN (@admissionRankingSlice IS NOT NULL AND LEN(@admissionRankingSlice) > 0 AND CHARINDEX(@admissionRankingSlice, @strBlank) = 0) THEN ('"' + @admissionRankingSlice + '"') ELSE 'NULL' END) + ', ' +
						 'scoreONET01=' + (CASE WHEN (@scoreONET01Slice IS NOT NULL AND LEN(@scoreONET01Slice) > 0 AND CHARINDEX(@scoreONET01Slice, @strBlank) = 0) THEN ('"' + @scoreONET01Slice + '"') ELSE 'NULL' END) + ', ' +
						 'scoreONET02=' + (CASE WHEN (@scoreONET02Slice IS NOT NULL AND LEN(@scoreONET02Slice) > 0 AND CHARINDEX(@scoreONET02Slice, @strBlank) = 0) THEN ('"' + @scoreONET02Slice + '"') ELSE 'NULL' END) + ', ' +
						 'scoreONET03=' + (CASE WHEN (@scoreONET03Slice IS NOT NULL AND LEN(@scoreONET03Slice) > 0 AND CHARINDEX(@scoreONET03Slice, @strBlank) = 0) THEN ('"' + @scoreONET03Slice + '"') ELSE 'NULL' END) + ', ' +
						 'scoreONET04=' + (CASE WHEN (@scoreONET04Slice IS NOT NULL AND LEN(@scoreONET04Slice) > 0 AND CHARINDEX(@scoreONET04Slice, @strBlank) = 0) THEN ('"' + @scoreONET04Slice + '"') ELSE 'NULL' END) + ', ' +
						 'scoreONET05=' + (CASE WHEN (@scoreONET05Slice IS NOT NULL AND LEN(@scoreONET05Slice) > 0 AND CHARINDEX(@scoreONET05Slice, @strBlank) = 0) THEN ('"' + @scoreONET05Slice + '"') ELSE 'NULL' END) + ', ' +
						 'scoreONET06=' + (CASE WHEN (@scoreONET06Slice IS NOT NULL AND LEN(@scoreONET06Slice) > 0 AND CHARINDEX(@scoreONET06Slice, @strBlank) = 0) THEN ('"' + @scoreONET06Slice + '"') ELSE 'NULL' END) + ', ' +
						 'scoreONET07=' + (CASE WHEN (@scoreONET07Slice IS NOT NULL AND LEN(@scoreONET07Slice) > 0 AND CHARINDEX(@scoreONET07Slice, @strBlank) = 0) THEN ('"' + @scoreONET07Slice + '"') ELSE 'NULL' END) + ', ' +
						 'scoreONET08=' + (CASE WHEN (@scoreONET08Slice IS NOT NULL AND LEN(@scoreONET08Slice) > 0 AND CHARINDEX(@scoreONET08Slice, @strBlank) = 0) THEN ('"' + @scoreONET08Slice + '"') ELSE 'NULL' END) + ', ' +
						 'scoreANET11=' + (CASE WHEN (@scoreANET11Slice IS NOT NULL AND LEN(@scoreANET11Slice) > 0 AND CHARINDEX(@scoreANET11Slice, @strBlank) = 0) THEN ('"' + @scoreANET11Slice + '"') ELSE 'NULL' END) + ', ' +
						 'scoreANET12=' + (CASE WHEN (@scoreANET12Slice IS NOT NULL AND LEN(@scoreANET12Slice) > 0 AND CHARINDEX(@scoreANET12Slice, @strBlank) = 0) THEN ('"' + @scoreANET12Slice + '"') ELSE 'NULL' END) + ', ' +
						 'scoreANET13=' + (CASE WHEN (@scoreANET13Slice IS NOT NULL AND LEN(@scoreANET13Slice) > 0 AND CHARINDEX(@scoreANET13Slice, @strBlank) = 0) THEN ('"' + @scoreANET13Slice + '"') ELSE 'NULL' END) + ', ' +
						 'scoreANET14=' + (CASE WHEN (@scoreANET14Slice IS NOT NULL AND LEN(@scoreANET14Slice) > 0 AND CHARINDEX(@scoreANET14Slice, @strBlank) = 0) THEN ('"' + @scoreANET14Slice + '"') ELSE 'NULL' END) + ', ' +
						 'scoreANET15=' + (CASE WHEN (@scoreANET15Slice IS NOT NULL AND LEN(@scoreANET15Slice) > 0 AND CHARINDEX(@scoreANET15Slice, @strBlank) = 0) THEN ('"' + @scoreANET15Slice + '"') ELSE 'NULL' END) + ', ' +
						 'scoreGAT85=' + (CASE WHEN (@scoreGAT85Slice IS NOT NULL AND LEN(@scoreGAT85Slice) > 0 AND CHARINDEX(@scoreGAT85Slice, @strBlank) = 0) THEN ('"' + @scoreGAT85Slice + '"') ELSE 'NULL' END) + ', ' +
						 'scorePAT71=' + (CASE WHEN (@scorePAT71Slice IS NOT NULL AND LEN(@scorePAT71Slice) > 0 AND CHARINDEX(@scorePAT71Slice, @strBlank) = 0) THEN ('"' + @scorePAT71Slice + '"') ELSE 'NULL' END) + ', ' +
						 'scorePAT72=' + (CASE WHEN (@scorePAT72Slice IS NOT NULL AND LEN(@scorePAT72Slice) > 0 AND CHARINDEX(@scorePAT72Slice, @strBlank) = 0) THEN ('"' + @scorePAT72Slice + '"') ELSE 'NULL' END) + ', ' +
						 'scorePAT73=' + (CASE WHEN (@scorePAT73Slice IS NOT NULL AND LEN(@scorePAT73Slice) > 0 AND CHARINDEX(@scorePAT73Slice, @strBlank) = 0) THEN ('"' + @scorePAT73Slice + '"') ELSE 'NULL' END) + ', ' +
						 'scorePAT74=' + (CASE WHEN (@scorePAT74Slice IS NOT NULL AND LEN(@scorePAT74Slice) > 0 AND CHARINDEX(@scorePAT74Slice, @strBlank) = 0) THEN ('"' + @scorePAT74Slice + '"') ELSE 'NULL' END) + ', ' +
						 'scorePAT75=' + (CASE WHEN (@scorePAT75Slice IS NOT NULL AND LEN(@scorePAT75Slice) > 0 AND CHARINDEX(@scorePAT75Slice, @strBlank) = 0) THEN ('"' + @scorePAT75Slice + '"') ELSE 'NULL' END) + ', ' +
						 'scorePAT76=' + (CASE WHEN (@scorePAT76Slice IS NOT NULL AND LEN(@scorePAT76Slice) > 0 AND CHARINDEX(@scorePAT76Slice, @strBlank) = 0) THEN ('"' + @scorePAT76Slice + '"') ELSE 'NULL' END) + ', ' +
						 'scorePAT77=' + (CASE WHEN (@scorePAT77Slice IS NOT NULL AND LEN(@scorePAT77Slice) > 0 AND CHARINDEX(@scorePAT77Slice, @strBlank) = 0) THEN ('"' + @scorePAT77Slice + '"') ELSE 'NULL' END) + ', ' +
						 'scorePAT78=' + (CASE WHEN (@scorePAT78Slice IS NOT NULL AND LEN(@scorePAT78Slice) > 0 AND CHARINDEX(@scorePAT78Slice, @strBlank) = 0) THEN ('"' + @scorePAT78Slice + '"') ELSE 'NULL' END) + ', ' +
						 'scorePAT79=' + (CASE WHEN (@scorePAT79Slice IS NOT NULL AND LEN(@scorePAT79Slice) > 0 AND CHARINDEX(@scorePAT79Slice, @strBlank) = 0) THEN ('"' + @scorePAT79Slice + '"') ELSE 'NULL' END) + ', ' +
						 'scorePAT80=' + (CASE WHEN (@scorePAT80Slice IS NOT NULL AND LEN(@scorePAT80Slice) > 0 AND CHARINDEX(@scorePAT80Slice, @strBlank) = 0) THEN ('"' + @scorePAT80Slice + '"') ELSE 'NULL' END) + ', ' +
						 'scorePAT81=' + (CASE WHEN (@scorePAT81Slice IS NOT NULL AND LEN(@scorePAT81Slice) > 0 AND CHARINDEX(@scorePAT81Slice, @strBlank) = 0) THEN ('"' + @scorePAT81Slice + '"') ELSE 'NULL' END) + ', ' +
						 'scorePAT82=' + (CASE WHEN (@scorePAT82Slice IS NOT NULL AND LEN(@scorePAT82Slice) > 0 AND CHARINDEX(@scorePAT82Slice, @strBlank) = 0) THEN ('"' + @scorePAT82Slice + '"') ELSE 'NULL' END)

			BEGIN TRY
				BEGIN TRAN	
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
						CASE WHEN (@perPersonIdSlice IS NOT NULL AND LEN(@perPersonIdSlice) > 0 AND CHARINDEX(@perPersonIdSlice, @strBlank) = 0) THEN @perPersonIdSlice ELSE NULL END,
						CASE WHEN (@plcCountryIdPrimarySchoolSlice IS NOT NULL AND LEN(@plcCountryIdPrimarySchoolSlice) > 0 AND CHARINDEX(@plcCountryIdPrimarySchoolSlice, @strBlank) = 0) THEN @plcCountryIdPrimarySchoolSlice ELSE NULL END,
						CASE WHEN (@plcProvinceIdPrimarySchoolSlice IS NOT NULL AND LEN(@plcProvinceIdPrimarySchoolSlice) > 0 AND CHARINDEX(@plcProvinceIdPrimarySchoolSlice, @strBlank) = 0) THEN @plcProvinceIdPrimarySchoolSlice ELSE NULL END,
						CASE WHEN (@primarySchoolNameSlice IS NOT NULL AND LEN(@primarySchoolNameSlice) > 0 AND CHARINDEX(@primarySchoolNameSlice, @strBlank) = 0) THEN @primarySchoolNameSlice ELSE NULL END,
						CASE WHEN (@primarySchoolYearAttendedSlice IS NOT NULL AND LEN(@primarySchoolYearAttendedSlice) > 0 AND CHARINDEX(@primarySchoolYearAttendedSlice, @strBlank) = 0) THEN @primarySchoolYearAttendedSlice ELSE NULL END,
						CASE WHEN (@primarySchoolYearGraduateSlice IS NOT NULL AND LEN(@primarySchoolYearGraduateSlice) > 0 AND CHARINDEX(@primarySchoolYearGraduateSlice, @strBlank) = 0) THEN @primarySchoolYearGraduateSlice ELSE NULL END,
						CASE WHEN (@primarySchoolGPASlice IS NOT NULL AND LEN(@primarySchoolGPASlice) > 0 AND CHARINDEX(@primarySchoolGPASlice, @strBlank) = 0) THEN @primarySchoolGPASlice ELSE NULL END,
						CASE WHEN (@plcCountryIdJuniorHighSchoolSlice IS NOT NULL AND LEN(@plcCountryIdJuniorHighSchoolSlice) > 0 AND CHARINDEX(@plcCountryIdJuniorHighSchoolSlice, @strBlank) = 0) THEN @plcCountryIdJuniorHighSchoolSlice ELSE NULL END,
						CASE WHEN (@plcProvinceIdJuniorHighSchoolSlice IS NOT NULL AND LEN(@plcProvinceIdJuniorHighSchoolSlice) > 0 AND CHARINDEX(@plcProvinceIdJuniorHighSchoolSlice, @strBlank) = 0) THEN @plcProvinceIdJuniorHighSchoolSlice ELSE NULL END,
						CASE WHEN (@juniorHighSchoolNameSlice IS NOT NULL AND LEN(@juniorHighSchoolNameSlice) > 0 AND CHARINDEX(@juniorHighSchoolNameSlice, @strBlank) = 0) THEN @juniorHighSchoolNameSlice ELSE NULL END,
						CASE WHEN (@juniorHighSchoolYearAttendedSlice IS NOT NULL AND LEN(@juniorHighSchoolYearAttendedSlice) > 0 AND CHARINDEX(@juniorHighSchoolYearAttendedSlice, @strBlank) = 0) THEN @juniorHighSchoolYearAttendedSlice ELSE NULL END,
						CASE WHEN (@juniorHighSchoolYearGraduateSlice IS NOT NULL AND LEN(@juniorHighSchoolYearGraduateSlice) > 0 AND CHARINDEX(@juniorHighSchoolYearGraduateSlice, @strBlank) = 0) THEN @juniorHighSchoolYearGraduateSlice ELSE NULL END,
						CASE WHEN (@juniorHighSchoolGPASlice IS NOT NULL AND LEN(@juniorHighSchoolGPASlice) > 0 AND CHARINDEX(@juniorHighSchoolGPASlice, @strBlank) = 0) THEN @juniorHighSchoolGPASlice ELSE NULL END,
						CASE WHEN (@plcCountryIdHighSchoolSlice IS NOT NULL AND LEN(@plcCountryIdHighSchoolSlice) > 0 AND CHARINDEX(@plcCountryIdHighSchoolSlice, @strBlank) = 0) THEN @plcCountryIdHighSchoolSlice ELSE NULL END,
						CASE WHEN (@plcProvinceIdHighSchoolSlice IS NOT NULL AND LEN(@plcProvinceIdHighSchoolSlice) > 0 AND CHARINDEX(@plcProvinceIdHighSchoolSlice, @strBlank) = 0) THEN @plcProvinceIdHighSchoolSlice ELSE NULL END,
						CASE WHEN (@highSchoolNameSlice IS NOT NULL AND LEN(@highSchoolNameSlice) > 0 AND CHARINDEX(@highSchoolNameSlice, @strBlank) = 0) THEN @highSchoolNameSlice ELSE NULL END,
						CASE WHEN (@highSchoolStudentIdSlice IS NOT NULL AND LEN(@highSchoolStudentIdSlice) > 0 AND CHARINDEX(@highSchoolStudentIdSlice, @strBlank) = 0) THEN @highSchoolStudentIdSlice ELSE NULL END,
						CASE WHEN (@perEducationalMajorIdHighSchoolSlice IS NOT NULL AND LEN(@perEducationalMajorIdHighSchoolSlice) > 0 AND CHARINDEX(@perEducationalMajorIdHighSchoolSlice, @strBlank) = 0) THEN @perEducationalMajorIdHighSchoolSlice ELSE NULL END,
						CASE WHEN (@educationalMajorOtherHighSchoolSlice IS NOT NULL AND LEN(@educationalMajorOtherHighSchoolSlice) > 0 AND CHARINDEX(@educationalMajorOtherHighSchoolSlice, @strBlank) = 0) THEN @educationalMajorOtherHighSchoolSlice ELSE NULL END,
						CASE WHEN (@highSchoolYearAttendedSlice IS NOT NULL AND LEN(@highSchoolYearAttendedSlice) > 0 AND CHARINDEX(@highSchoolYearAttendedSlice, @strBlank) = 0) THEN @highSchoolYearAttendedSlice ELSE NULL END,
						CASE WHEN (@highSchoolYearGraduateSlice IS NOT NULL AND LEN(@highSchoolYearGraduateSlice) > 0 AND CHARINDEX(@highSchoolYearGraduateSlice, @strBlank) = 0) THEN @highSchoolYearGraduateSlice ELSE NULL END,
						CASE WHEN (@highSchoolGPASlice IS NOT NULL AND LEN(@highSchoolGPASlice) > 0 AND CHARINDEX(@highSchoolGPASlice, @strBlank) = 0) THEN @highSchoolGPASlice ELSE NULL END,
						CASE WHEN (@perEducationalBackgroundIdHighSchoolSlice IS NOT NULL AND LEN(@perEducationalBackgroundIdHighSchoolSlice) > 0 AND CHARINDEX(@perEducationalBackgroundIdHighSchoolSlice, @strBlank) = 0) THEN @perEducationalBackgroundIdHighSchoolSlice ELSE NULL END,
						CASE WHEN (@perEducationalBackgroundIdSlice IS NOT NULL AND LEN(@perEducationalBackgroundIdSlice) > 0 AND CHARINDEX(@perEducationalBackgroundIdSlice, @strBlank) = 0) THEN @perEducationalBackgroundIdSlice ELSE NULL END,
						CASE WHEN (@graduateBySlice IS NOT NULL AND LEN(@graduateBySlice) > 0 AND CHARINDEX(@graduateBySlice, @strBlank) = 0) THEN @graduateBySlice ELSE NULL END,
						CASE WHEN (@graduateBySchoolNameSlice IS NOT NULL AND LEN(@graduateBySchoolNameSlice) > 0 AND CHARINDEX(@graduateBySchoolNameSlice, @strBlank) = 0) THEN @graduateBySchoolNameSlice ELSE NULL END,
						CASE WHEN (@entranceTimeSlice IS NOT NULL AND LEN(@entranceTimeSlice) > 0 AND CHARINDEX(@entranceTimeSlice, @strBlank) = 0) THEN @entranceTimeSlice ELSE NULL END,
						CASE WHEN (@studentIsSlice IS NOT NULL AND LEN(@studentIsSlice) > 0 AND CHARINDEX(@studentIsSlice, @strBlank) = 0) THEN @studentIsSlice ELSE NULL END,
						CASE WHEN (@studentIsUniversitySlice IS NOT NULL AND LEN(@studentIsUniversitySlice) > 0 AND CHARINDEX(@studentIsUniversitySlice, @strBlank) = 0) THEN @studentIsUniversitySlice ELSE NULL END,
						CASE WHEN (@studentIsFacultySlice IS NOT NULL AND LEN(@studentIsFacultySlice) > 0 AND CHARINDEX(@studentIsFacultySlice, @strBlank) = 0) THEN @studentIsFacultySlice ELSE NULL END,
						CASE WHEN (@studentIsProgramSlice IS NOT NULL AND LEN(@studentIsProgramSlice) > 0 AND CHARINDEX(@studentIsProgramSlice, @strBlank) = 0) THEN @studentIsProgramSlice ELSE NULL END,
						CASE WHEN (@perEntranceTypeIdSlice IS NOT NULL AND LEN(@perEntranceTypeIdSlice) > 0 AND CHARINDEX(@perEntranceTypeIdSlice, @strBlank) = 0) THEN @perEntranceTypeIdSlice ELSE NULL END,
						CASE WHEN (@admissionRankingSlice IS NOT NULL AND LEN(@admissionRankingSlice) > 0 AND CHARINDEX(@admissionRankingSlice, @strBlank) = 0) THEN @admissionRankingSlice ELSE NULL END,
						CASE WHEN (@scoreONET01Slice IS NOT NULL AND LEN(@scoreONET01Slice) > 0 AND CHARINDEX(@scoreONET01Slice, @strBlank) = 0) THEN @scoreONET01Slice ELSE NULL END,
						CASE WHEN (@scoreONET02Slice IS NOT NULL AND LEN(@scoreONET02Slice) > 0 AND CHARINDEX(@scoreONET02Slice, @strBlank) = 0) THEN @scoreONET02Slice ELSE NULL END,
						CASE WHEN (@scoreONET03Slice IS NOT NULL AND LEN(@scoreONET03Slice) > 0 AND CHARINDEX(@scoreONET03Slice, @strBlank) = 0) THEN @scoreONET03Slice ELSE NULL END,
						CASE WHEN (@scoreONET04Slice IS NOT NULL AND LEN(@scoreONET04Slice) > 0 AND CHARINDEX(@scoreONET04Slice, @strBlank) = 0) THEN @scoreONET04Slice ELSE NULL END,
						CASE WHEN (@scoreONET05Slice IS NOT NULL AND LEN(@scoreONET05Slice) > 0 AND CHARINDEX(@scoreONET05Slice, @strBlank) = 0) THEN @scoreONET05Slice ELSE NULL END,
						CASE WHEN (@scoreONET06Slice IS NOT NULL AND LEN(@scoreONET06Slice) > 0 AND CHARINDEX(@scoreONET06Slice, @strBlank) = 0) THEN @scoreONET06Slice ELSE NULL END,
						CASE WHEN (@scoreONET07Slice IS NOT NULL AND LEN(@scoreONET07Slice) > 0 AND CHARINDEX(@scoreONET07Slice, @strBlank) = 0) THEN @scoreONET07Slice ELSE NULL END,
						CASE WHEN (@scoreONET08Slice IS NOT NULL AND LEN(@scoreONET08Slice) > 0 AND CHARINDEX(@scoreONET08Slice, @strBlank) = 0) THEN @scoreONET08Slice ELSE NULL END,
						CASE WHEN (@scoreANET11Slice IS NOT NULL AND LEN(@scoreANET11Slice) > 0 AND CHARINDEX(@scoreANET11Slice, @strBlank) = 0) THEN @scoreANET11Slice ELSE NULL END,
						CASE WHEN (@scoreANET12Slice IS NOT NULL AND LEN(@scoreANET12Slice) > 0 AND CHARINDEX(@scoreANET12Slice, @strBlank) = 0) THEN @scoreANET12Slice ELSE NULL END,
						CASE WHEN (@scoreANET13Slice IS NOT NULL AND LEN(@scoreANET13Slice) > 0 AND CHARINDEX(@scoreANET13Slice, @strBlank) = 0) THEN @scoreANET13Slice ELSE NULL END,
						CASE WHEN (@scoreANET14Slice IS NOT NULL AND LEN(@scoreANET14Slice) > 0 AND CHARINDEX(@scoreANET14Slice, @strBlank) = 0) THEN @scoreANET14Slice ELSE NULL END,
						CASE WHEN (@scoreANET15Slice IS NOT NULL AND LEN(@scoreANET15Slice) > 0 AND CHARINDEX(@scoreANET15Slice, @strBlank) = 0) THEN @scoreANET15Slice ELSE NULL END,
						CASE WHEN (@scoreGAT85Slice IS NOT NULL AND LEN(@scoreGAT85Slice) > 0 AND CHARINDEX(@scoreGAT85Slice, @strBlank) = 0) THEN @scoreGAT85Slice ELSE NULL END,
						CASE WHEN (@scorePAT71Slice IS NOT NULL AND LEN(@scorePAT71Slice) > 0 AND CHARINDEX(@scorePAT71Slice, @strBlank) = 0) THEN @scorePAT71Slice ELSE NULL END,
						CASE WHEN (@scorePAT72Slice IS NOT NULL AND LEN(@scorePAT72Slice) > 0 AND CHARINDEX(@scorePAT72Slice, @strBlank) = 0) THEN @scorePAT72Slice ELSE NULL END,
						CASE WHEN (@scorePAT73Slice IS NOT NULL AND LEN(@scorePAT73Slice) > 0 AND CHARINDEX(@scorePAT73Slice, @strBlank) = 0) THEN @scorePAT73Slice ELSE NULL END,
						CASE WHEN (@scorePAT74Slice IS NOT NULL AND LEN(@scorePAT74Slice) > 0 AND CHARINDEX(@scorePAT74Slice, @strBlank) = 0) THEN @scorePAT74Slice ELSE NULL END,
						CASE WHEN (@scorePAT75Slice IS NOT NULL AND LEN(@scorePAT75Slice) > 0 AND CHARINDEX(@scorePAT75Slice, @strBlank) = 0) THEN @scorePAT75Slice ELSE NULL END,
						CASE WHEN (@scorePAT76Slice IS NOT NULL AND LEN(@scorePAT76Slice) > 0 AND CHARINDEX(@scorePAT76Slice, @strBlank) = 0) THEN @scorePAT76Slice ELSE NULL END,
						CASE WHEN (@scorePAT77Slice IS NOT NULL AND LEN(@scorePAT77Slice) > 0 AND CHARINDEX(@scorePAT77Slice, @strBlank) = 0) THEN @scorePAT77Slice ELSE NULL END,
						CASE WHEN (@scorePAT78Slice IS NOT NULL AND LEN(@scorePAT78Slice) > 0 AND CHARINDEX(@scorePAT78Slice, @strBlank) = 0) THEN @scorePAT78Slice ELSE NULL END,
						CASE WHEN (@scorePAT79Slice IS NOT NULL AND LEN(@scorePAT79Slice) > 0 AND CHARINDEX(@scorePAT79Slice, @strBlank) = 0) THEN @scorePAT79Slice ELSE NULL END,
						CASE WHEN (@scorePAT80Slice IS NOT NULL AND LEN(@scorePAT80Slice) > 0 AND CHARINDEX(@scorePAT80Slice, @strBlank) = 0) THEN @scorePAT80Slice ELSE NULL END,
						CASE WHEN (@scorePAT81Slice IS NOT NULL AND LEN(@scorePAT81Slice) > 0 AND CHARINDEX(@scorePAT81Slice, @strBlank) = 0) THEN @scorePAT81Slice ELSE NULL END,
						CASE WHEN (@scorePAT82Slice IS NOT NULL AND LEN(@scorePAT82Slice) > 0 AND CHARINDEX(@scorePAT82Slice, @strBlank) = 0) THEN @scorePAT82Slice ELSE NULL END,
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

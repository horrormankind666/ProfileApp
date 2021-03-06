USE [Infinity]
GO
/****** Object:  UserDefinedFunction [dbo].[fnc_perGetListEducation]    Script Date: 03/16/2015 15:00:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๔/๐๑/๒๕๕๗>
-- Description	: <สำหรับแสดงข้อมูลการศึกษาของบุคคล>
--  1. id		เป็น VARCHAR	รับค่ารหัสบุคคล
--  2. idCard 	เป็น NVARCHAR	รับค่าเลขประจำตัวประชาชนหรือเลขหนังสือเดินทาง
--  3. name		เป็น NVARCHAR	รับค่าชื่อ
-- =============================================
ALTER FUNCTION [dbo].[fnc_perGetListEducation]
(	
	@id	VARCHAR(MAX) = NULL,
	@idCard NVARCHAR(MAX) = NULL,
	@name NVARCHAR(MAX) = NULL
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT	perps.id,
			perps.idCard,
			perps.perTitlePrefixId,
			perps.thTitleFullName,
			perps.thTitleInitials,
			perps.thDescription,
			perps.enTitleFullName,
			perps.enTitleInitials,
			perps.enDescription,			
			perps.firstName,
			perps.middleName, 
			perps.lastName,
			perps.enFirstName,
			perps.enMiddleName,
			perps.enLastName, 
			pered.plcCountryIdPrimarySchool,
			plccoprimaryschool.thCountryName AS thPrimarySchoolCountryName,
			plccoprimaryschool.enCountryName AS enPrimarySchoolCountryName,
			plccoprimaryschool.isoCountryCodes2Letter AS isoPrimarySchoolCountryCodes2Letter, 
			plccoprimaryschool.isoCountryCodes3Letter AS isoPrimarySchoolCountryCodes3Letter,
			pered.plcProvinceIdPrimarySchool,
			plcpvprimaryschool.thPlaceName AS thPrimarySchoolPlaceName,
			plcpvprimaryschool.enPlaceName AS enPrimarySchoolPlaceName, 
			pered.primarySchoolName,
			pered.primarySchoolYearAttended,
			pered.primarySchoolYearGraduate,
			pered.primarySchoolGPA, 
			pered.plcCountryIdJuniorHighSchool,
			plccojuniorhighschool.thCountryName AS thJuniorHighSchoolCountryName,
			plccojuniorhighschool.enCountryName AS enJuniorHighSchoolCountryName, 
			plccojuniorhighschool.isoCountryCodes2Letter AS isoJuniorHighSchoolCountryCodes2Letter,
			plccojuniorhighschool.isoCountryCodes3Letter AS isoJuniorHighSchoolCountryCodes3Letter,
			pered.plcProvinceIdJuniorHighSchool, 
			plcpvjuniorhighschool.thPlaceName AS thJuniorHighSchoolPlaceName,
			plcpvjuniorhighschool.enPlaceName AS enJuniorHighSchoolPlaceName,
			pered.juniorHighSchoolName, 
			pered.juniorHighSchoolYearAttended,
			pered.juniorHighSchoolYearGraduate,
			pered.juniorHighSchoolGPA,
			pered.plcCountryIdHighSchool, 
			plccohighschool.thCountryName AS thHighSchoolCountryName,
			plccohighschool.enCountryName AS enHighSchoolCountryName,
			plccohighschool.isoCountryCodes2Letter AS isoHighSchoolCountryCodes2Letter, 
			plccohighschool.isoCountryCodes3Letter AS isoHighSchoolCountryCodes3Letter,
			pered.plcProvinceIdHighSchool,
			plcpvhighschool.thPlaceName AS thHighSchoolPlaceName, 
			plcpvhighschool.enPlaceName AS enHighSchoolPlaceName,
			pered.highSchoolName,
			pered.highSchoolStudentId,
			pered.perEducationalMajorIdHighSchool, 
			peremhighschool.thEducationalMajorName AS thHighSchoolEducationalMajorName,
			peremhighschool.enEducationalMajorName AS enHighSchoolEducationalMajorName,
			pered.educationalMajorOtherHighSchool, 
			pered.highSchoolYearAttended,
			pered.highSchoolYearGraduate,
			pered.highSchoolGPA,
			pered.perEducationalBackgroundIdHighSchool,
			perebhighschool.thEducationalBackgroundName AS thHighSchoolEducationalBackgroundName,
			perebhighschool.enEducationalBackgroundName AS enHighSchoolEducationalBackgroundName,
			perelhighschool.thEducationalLevelName AS thHighSchoolEducationalLevelName,
			perelhighschool.enEducationalLevelName AS enHighSchoolEducationalLevelName,
			pered.perEducationalBackgroundId, 
			pereb.thEducationalBackgroundName,
			pereb.enEducationalBackgroundName,          
			perel.thEducationalLevelName,
			perel.enEducationalLevelName,
			pered.graduateBy,
			(
				CASE pered.graduateBy
					WHEN '01' THEN 'สอบปกติ'
					WHEN '02' THEN 'สอบเทียบ'
					ELSE NULL
				END
			) AS thGraduateBy,
			(
				CASE pered.graduateBy
					WHEN '01' THEN 'High School Education'
					WHEN '02' THEN 'Non-Formal And Informal Education'
					ELSE NULL
				END				
			) AS enGraduateBy,						
			pered.graduateBySchoolName,
			pered.entranceTime,
			(
				CASE pered.entranceTime
					WHEN '1' THEN 'ครั้งแรก'
					WHEN '2' THEN 'ครั้งที่ 2'
					WHEN '3' THEN 'ครั้งที่ 3'
					WHEN '4' THEN 'มากกว่า 3 ครั้ง'
					ELSE NULL
				END					
			) AS thEntranceTime,
			(
				CASE pered.entranceTime
					WHEN '1' THEN 'First Time'
					WHEN '2' THEN '2 Times'
					WHEN '3' THEN '3 Times'
					WHEN '4' THEN 'More Than 3 Times'
					ELSE NULL
				END					
			) AS enEntranceTime,			
			pered.studentIs,
			(
				CASE pered.studentIs
					WHEN '01' THEN 'เข้าเป็นนักศึกษามหาวิทยาลัยมหิดลครั้งแรก'
					WHEN '02' THEN 'เคยเป็นนักศึกษา'
					ELSE NULL
				END								
			) AS thStudentIs,
			(
				CASE pered.studentIs
					WHEN '01' THEN 'First Time To Be A Student In Mahidol University'
					WHEN '02' THEN 'Was A Student'
					ELSE NULL
				END				
			) AS enStudentIs,	
			pered.studentIsUniversity, 
			pered.studentIsFaculty,
			pered.studentIsProgram,
			pered.perEntranceTypeId,
			peret.thEntranceTypeName, 
			peret.enEntranceTypeName,
			pered.admissionRanking,
			pered.scoreONET01,
			('O-NET ภาษาไทย') AS thScoreONET01Name,
			('O-NET Thai') AS enScoreONET01Name,
			pered.scoreONET02,
			('O-NET สังคมศึกษา') AS thScoreONET02Name,
			('O-NET Social Science') AS enScoreONET02Name,
			pered.scoreONET03, 
			('O-NET ภาษาอังกฤษ') AS thScoreONET03Name,
			('O-NET English') AS enScoreONET03Name,			
			pered.scoreONET04,
			('O-NET คณิตศาสตร์') AS thScoreONET04Name,
			('O-NET Mathematics') AS enScoreONET04Name,			
			pered.scoreONET05,
			('O-NET วิทยาศาสตร์') AS thScoreONET05Name,
			('O-NET Science') AS enScoreONET05Name,			
			pered.scoreONET06,
			('O-NET สุขศึกษาและพลศึกษา') AS thScoreONET06Name,
			('O-NET Health Education & Physical Education') AS enScoreONET06Name,				
			pered.scoreONET07,
			('O-NET ศิลปะ') AS thScoreONET07Name,
			('O-NET Atrs') AS enScoreONET07Name,			
			pered.scoreONET08, 
			('O-NET การงานอาชีพและเทคโนโลยี') AS thScoreONET08Name,
			('O-NET Occupation & Teachnology') AS enScoreONET08Name,			
			pered.scoreANET11,
			('A-NET ภาษาไทย 2') AS thScoreANET11Name,
			('A-NET Thai 2') AS enScoreANET11Name,			
			pered.scoreANET12,
			('A-NET สังคมศึกษา 2') AS thScoreANET12Name,
			('A-NET Social Science 2') AS enScoreANET12Name,			
			pered.scoreANET13,
			('A-NET ภาษาอังกฤษ 3') AS thScoreANET13Name,
			('A-NET English 3') AS enScoreANET13Name,			
			pered.scoreANET14,
			('A-NET คณิตศาสตร์ 2') AS thScoreANET14Name,
			('A-NET Mathematics 2') AS enScoreANET14Name,			
			pered.scoreANET15, 
			('A-NET วิทยาศาสตร์ 2') AS thScoreANET15Name,
			('A-NET Science 2') AS enScoreANET15Name,			
			pered.scoreGAT85,
			('GAT ความถนัดทั่วไป') AS thScoreGAT85Name,
			('GAT Genaral Aptitude Test') AS enScoreGAT85Name,
			pered.scorePAT71,
			('PAT 1 ความถนัดคณิตศาสตร์') AS thScorePAT71Name,
			('PAT 1 Aptitude In Mathematics') AS enScorePAT71Name,			
			pered.scorePAT72,
			('PAT 2 ความถนัดวิทยาศาสตร์') AS thScorePAT72Name,
			('PAT 2 Aptitude In Science') AS enScorePAT72Name,			
			pered.scorePAT73,
			('PAT 3 ความถนัดวิศวกรรมศาสตร์') AS thScorePAT73Name,
			('PAT 3 Aptitude In Engineering') AS enScorePAT73Name,			
			pered.scorePAT74,
			('PAT 4 ความถนัดสถาปัตยกรรมศาสตร์') AS thScorePAT74Name,
			('PAT 4 Aptitude In Architecture') AS enScorePAT74Name,			
			pered.scorePAT75, 
			('PAT 5 ความถนัดวิชาชีพครู') AS thScorePAT75Name,
			('PAT 5 Aptitude In Teaching') AS enScorePAT75Name,				
			pered.scorePAT76,
			('PAT 6 ความถนัดศิลปกรรมศาสตร์') AS thScorePAT76Name,
			('PAT 6 Aptitude In Arts') AS enScorePAT76Name,			
			pered.scorePAT77,
			('PAT 7 ภาษาฝรั่งเศส') AS thScorePAT77Name,
			('PAT 7 French Languages') AS enScorePAT77Name,			
			pered.scorePAT78,
			('PAT 8 ภาษาเยอรมัน') AS thScorePAT78Name,
			('PAT 8 Germany Languages') AS enScorePAT78Name,				
			pered.scorePAT79,
			('PAT 9 ภาษาญี่ปุ่น') AS thScorePAT79Name,
			('PAT 9 Japanese Languages') AS enScorePAT79Name,			
			pered.scorePAT80,
			('PAT 10 ภาษาจีน') AS thScorePAT80Name,
			('PAT 10 Chinese Languages') AS enScorePAT80Name,			
			pered.scorePAT81,
			('PAT 11 ภาษาอาหรับ') AS thScorePAT81Name,
			('PAT 11 Arabic Languages') AS enScorePAT81Name,			 
			pered.scorePAT82,
			('PAT 12 ภาษาบาลี') AS thScorePAT82Name,
			('PAT 12 Bali Languages') AS enScorePAT82Name,			
			pered.createBy,
			pered.createDate,
			pered.createIp,
			pered.modifyDate,
			pered.modifyBy, 
			pered.modifyIp
	FROM	fnc_perGetListPerson(@id, @idCard, @name) AS perps LEFT JOIN
			perEducation AS pered ON perps.id = pered.perPersonId LEFT JOIN
			plcCountry AS plccoprimaryschool ON pered.plcCountryIdPrimarySchool = plccoprimaryschool.id LEFT JOIN
			plcProvince AS plcpvprimaryschool ON pered.plcProvinceIdPrimarySchool = plcpvprimaryschool.id AND plccoprimaryschool.id = plcpvprimaryschool.plcCountryId LEFT JOIN
			plcCountry AS plccojuniorhighschool ON pered.plcCountryIdJuniorHighSchool = plccojuniorhighschool.id LEFT JOIN
			plcProvince AS plcpvjuniorhighschool ON pered.plcProvinceIdJuniorHighSchool = plcpvjuniorhighschool.id AND plccojuniorhighschool.id = plcpvjuniorhighschool.plcCountryId LEFT JOIN
			plcCountry AS plccohighschool ON pered.plcCountryIdHighSchool = plccohighschool.id LEFT JOIN
			plcProvince AS plcpvhighschool ON pered.plcProvinceIdHighSchool = plcpvhighschool.id AND plccohighschool.id = plcpvhighschool.plcCountryId LEFT JOIN
			perEducationalMajor AS peremhighschool ON pered.perEducationalMajorIdHighSchool = peremhighschool.id LEFT JOIN
			perEducationalBackground AS perebhighschool ON pered.perEducationalBackgroundIdHighSchool = perebhighschool.id LEFT JOIN
			perEducationalLevel AS perelhighschool ON perebhighschool.perEducationalLevelId = perelhighschool.id LEFT JOIN
			perEducationalBackground AS pereb ON pered.perEducationalBackgroundId = pereb.id LEFT JOIN
			perEducationalLevel AS perel ON pereb.perEducationalLevelId = perel.id LEFT JOIN
			perEntranceType AS peret ON pered.perEntranceTypeId = peret.id
)

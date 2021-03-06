USE [Infinity]
GO
/****** Object:  Trigger [dbo].[tg_perEducation]    Script Date: 05/22/2015 11:23:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<ยุทธภูมิ ตวันนา>
-- Create date: <๑๓/๑๒/๒๕๕๖>
-- Description:	<สำหรับบันทึกข้อมูล Transaction ของตาราง perEducation หลังจากที่มีการ INSERT, DELETE, UPDATE>
-- =============================================
ALTER TRIGGER [dbo].[tg_perEducation]
   ON [dbo].[perEducation]
   AFTER INSERT, DELETE, UPDATE
AS 
BEGIN
	SET NOCOUNT ON
	
	DECLARE @table VARCHAR(50) = 'perEducation'
    DECLARE @action VARCHAR(10) = NULL
    
	IF EXISTS (SELECT * FROM inserted)
	BEGIN						
		IF EXISTS (SELECT * FROM deleted)
			SET @action = 'UPDATE'
		ELSE
			SET @action = 'INSERT'

		INSERT INTO InfinityLog..perEducationLog
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
			modifyIp,
			logDatabase,
			logTable,
			logAction,
			logActionDate,
			logActionBy,
			logIp
		)
		SELECT	*,
				DB_NAME(),
				@table,
				@action,
				GETDATE(),
				SYSTEM_USER,
				dbo.fnc_perGetIP()
		FROM	inserted
	END
	ELSE
		BEGIN
			SET @action = 'DELETE'
			
			INSERT INTO InfinityLog..perEducationLog
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
				modifyIp,
				logDatabase,
				logTable,
				logAction,
				logActionDate,
				logActionBy,
				logIp
			)
			SELECT	*,
					DB_NAME(),
					@table,
					@action,
					GETDATE(),
					SYSTEM_USER,
					dbo.fnc_perGetIP()
			FROM	deleted
		END
END

USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_perGetListPersonStudent]    Script Date: 11/16/2015 15:54:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๔/๐๕/๒๕๕๘>
-- Description	: <สำหรับเรียกดูข้อมูลของนักศึกษา>
-- Parameter
--  1. personId		เป็น VARCHAR	รับค่ารหัสบุคคล
--  2. studentId	เป็น VARCHAR	รับค่ารหัสนักศึกษา
--  3. idCard		เป็น VARCHAR	รับค่าเลขประจำตัวประชาชนหรือเลขหนังสือเดินทาง
--  4. date			เป็น VARCHAR	รับค่าวันที่
--  5. facultyId	เป็น VARCHAR	รับค่ารหัสคณะ
--  6. programId	เป็น VARCHAR	รับค่ารหัสหลักสูตร
--  7. yearEntry	เป็น VARCHAR	รับค่าปีที่เข้าศึกษา
-- =============================================
ALTER PROCEDURE [dbo].[sp_perGetListPersonStudent]
(
	@personId VARCHAR(10) = NULL,
	@studentId VARCHAR(15) = NULL,
	@idCard VARCHAR(20) = NULL,
	@date VARCHAR(20) = NULL,
	@facultyId VARCHAR(15) = NULL,
	@programId VARCHAR(15) = NULL,
	@yearEntry VARCHAR(4) = NULL	
)
AS
BEGIN
	SET NOCOUNT ON

	SET @personId = LTRIM(RTRIM(@personId))
	SET @studentId = LTRIM(RTRIM(@studentId))
	SET @idCard = LTRIM(RTRIM(@idCard))
	SET @date = LTRIM(RTRIM(@date))
	SET @facultyId = LTRIM(RTRIM(@facultyId))
	SET @programId = LTRIM(RTRIM(@programId))
	SET @yearEntry = LTRIM(RTRIM(@yearEntry))

	SELECT	stdstd.id,
			stdstd.studentId,
			stdstd.studentCode,
			stdstd.idCard,
			stdstd.thBirthDate,
			stdstd.enBirthDate,
			stdstd.thTitleFullName,
			stdstd.thTitleInitials,
			stdstd.enTitleInitials,
			stdstd.enTitleFullName,
			stdstd.firstName,
			stdstd.middleName,
			stdstd.lastName,
			stdstd.enFirstName,
			stdstd.enMiddleName,
			stdstd.enLastName,
			stdstd.enGenderInitials,
			stdstd.thDegreeLevelName,
			stdstd.enDegreeLevelName,
			stdstd.facultyId,
			stdstd.facultyCode,
			stdstd.thFacultyName,
			stdstd.enFacultyName,
			stdstd.programId,
			stdstd.programCode,
			stdstd.majorCode,
			stdstd.groupNum,
			stdstd.thProgramName,
			stdstd.enProgramName,
			stdstd.yearEntry,
			stdstd.perEntranceTypeId,
			stdstd.stdEntranceTypeNameTH,
			stdstd.stdEntranceTypeNameEN,
			stdstd.stdStatusTypeId,
			stdstd.thStatusTypeName,
			stdstd.enStatusTypeName,
			stdstd.folderPictureName,
			stdstd.profilePictureName
	FROM	fnc_perGetListPersonStudent(@personId, @studentId, @idCard, @date, @facultyId, @programId, @yearEntry) AS stdstd
END
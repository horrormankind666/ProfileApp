USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_perGetPersonStudentWithAuthenStaff]    Script Date: 04-08-2016 16:56:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๘/๐๖/๒๕๕๘>
-- Description	: <สำหรับเรียกดูข้อมูลของนักศึกษาตามสิทธิ์ผู้ใช้งาน>
-- Parameter
--	1. username		เป็น VARCHAR	รับค่าชื่อผู้ใช้งาน
--	2. userlevel	เป็น VARCHAR	รับค่าระดับผู้ใช้งาน
--	3. systemGroup	เป็น VARCHAR	รับค่าชื่อระบบงาน
--  4. personId		เป็น VARCHAR	รับค่ารหัสบุคคล
-- =============================================
ALTER PROCEDURE [dbo].[sp_perGetPersonStudentWithAuthenStaff]
(
	@username VARCHAR(255) = NULL,
	@userlevel VARCHAR(20) = NULL,
	@systemGroup VARCHAR(50) = NULL,	
	@personId VARCHAR(10) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	
	SET @username = LTRIM(RTRIM(@username))
	SET @userlevel = LTRIM(RTRIM(@userlevel))
	SET @systemGroup = LTRIM(RTRIM(@systemGroup))
	SET @personId = LTRIM(RTRIM(@personId))
	
	DECLARE	@userFaculty VARCHAR(15) = NULL
	DECLARE @userProgram VARCHAR(15) = NULL

	SELECT	@userFaculty = autusr.facultyId,
			@userProgram = autusr.programId
	FROM	autUserAccessProgram AS autusr
	WHERE	(autusr.username = @username) AND
			(autusr.level = @userlevel) AND
			(autusr.systemGroup = @systemGroup)

	SET @userFaculty = ISNULL(@userFaculty, '')
	SET @userProgram = ISNULL(@userProgram, '')

	SELECT	stdstd.id,
			stdstd.studentId,
			stdstd.studentCode,
			stdstd.idCard,
			stdstd.thBirthDate AS birthDateTH,
			stdstd.enBirthDate AS birthDateEN,
			stdstd.thTitleFullName AS titlePrefixFullNameTH,
			stdstd.thTitleInitials AS titlePrefixInitialsTH,
			stdstd.enTitleInitials AS titlePrefixFullNameEN,
			stdstd.enTitleFullName AS titlePrefixInitialsEN,
			stdstd.firstName,
			stdstd.middleName,
			stdstd.lastName,
			stdstd.enFirstName AS firstNameEN,
			stdstd.enMiddleName AS middleNameEN,
			stdstd.enLastName AS lastNameEN,
			stdstd.degreeLevelNameTH,
			stdstd.degreeLevelNameEN,
			stdstd.facultyId,
			stdstd.facultyCode,
			stdstd.facultyNameTH,
			stdstd.facultyNameEN,
			stdstd.programId,
			stdstd.programCode,
			stdstd.majorCode,
			stdstd.groupNum,
			stdstd.programNameTH,
			stdstd.programNameEN,
			stdstd.yearEntry,
			stdstd.class,
			stdstd.perEntranceTypeId,
			stdstd.stdEntranceTypeNameTH,
			stdstd.stdEntranceTypeNameEN,
			stdstd.stdStatusTypeId,
			stdstd.statusTypeNameTH,
			stdstd.statusTypeNameEN,
			stdstd.graduateDate,
			stdstd.folderPictureName,
			stdstd.profilePictureName
	 FROM	fnc_perGetPersonStudent(@personId) AS stdstd
	 WHERE	(1 = (CASE WHEN (@userFaculty <> 'MU-01') THEN 0 ELSE 1 END) OR stdstd.facultyId = @userFaculty) AND
			(1 = (CASE WHEN (LEN(@userProgram) > 0 AND LEN(@userFaculty) > 0) THEN 0 ELSE 1 END) OR stdstd.programId = @userProgram)
END
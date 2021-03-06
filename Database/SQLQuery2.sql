USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_stdSetStudent]    Script Date: 12/25/2015 12:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๔/๑๐/๒๕๕๘>
-- Description	: <สำหรับบันทึกข้อมูลตาราง stdStudent ครั้งละ ๑ เรคคอร์ด>
--  1. action			เป็น VARCHAR	รับค่าการกระทำกับฐานข้อมูล
--  2. personId 		เป็น VARCHAR	รับค่ารหัสบุคคล
--	3. faculty			เป็น VARCHAR	รับค่ารหัสคณะ
--	4. program			เป็น VARCHAR	รับค่าหลักสูตร
--	5. degreeLevel		เป็น NVARCHAR	รับค่าระดับปริญญา
--	6. programYear		เป็น VARCHAR	รับค่าจำนวนปีที่ศึกษาตามหลักสูตร
--  7. class			เป็น VARCHAR	รับค่าชั้นปี
--  8. studentStatus	เป็น VARCHAR	รับค่าสถานภาพการเป็นนักศึกษา
--	9. graduateDate		เป็น VARCHAR	รับค่าวันที่สำเร็จการศึกษาหรือวันที่ออกจากการศึกษา
-- 10. updateWhat		เป็น VARCHAR	รับค่าปรับปรุงอะไร
-- 11. updateReason		เป็น NVARCHAR	รับค่าเหตุผลที่ปรับปรุง
-- 10. by				เป็น NVARCHAR	รับค่าชื่อของผู้ที่กระทำกับฐานข้อมูล
-- 11. ip				เป็น VARCHAR	รับค่าหมายเลขไอพีของผู้ที่กระทำกับฐานข้อมูล
-- =============================================
ALTER PROCEDURE [dbo].[sp_stdSetStudent]
(
	@action VARCHAR(10) = NULL,
	@personId VARCHAR(10) = NULL,
	@faculty VARCHAR(15) = NULL,
	@program VARCHAR(15) = NULL,
	@degreeLevel NVARCHAR(2) = NULL,	
	@programYear VARCHAR(2) = NULL,	
	@class VARCHAR(1) = NULL,
	@studentStatus VARCHAR(3) = NULL,
	@graduateDate VARCHAR(20) = NULL,
	@updateWhat VARCHAR(100) = NULL,
	@updateReason NVARCHAR(255) = NULL,
	@by NVARCHAR(255) = NULL,
	@ip VARCHAR(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON

	SET @action = LTRIM(RTRIM(@action))
	SET @personId = LTRIM(RTRIM(@personId))	
	SET @faculty = LTRIM(RTRIM(@faculty))
	SET @program = LTRIM(RTRIM(@program))
	SET @degreeLevel = LTRIM(RTRIM(@degreeLevel))
	SET @programYear = LTRIM(RTRIM(@programYear))
	SET @class = LTRIM(RTRIM(@class))
	SET @studentStatus = LTRIM(RTRIM(@studentStatus))
	SET @graduateDate = LTRIM(RTRIM(@graduateDate))
	SET @updateWhat = LTRIM(RTRIM(@updateWhat))
	SET @updateReason = LTRIM(RTRIM(@updateReason))
	SET @by = LTRIM(RTRIM(@by))
	SET @ip = LTRIM(RTRIM(@ip))
		
	DECLARE @studentId VARCHAR(7) = NULL
	DECLARE @major VARCHAR(4) = NULL
	DECLARE @groupNum VARCHAR(1) = NULL
	DECLARE @table VARCHAR(50) = 'stdStudent'
	DECLARE @rowCount INT = 0
	DECLARE @rowCountUpdate INT = 0
	DECLARE @value NVARCHAR(MAX) = NULL
	DECLARE	@strBlank VARCHAR(50) = '----------**********.........0.0000000000000000000'

	SET @action = UPPER(@action)
	
	IF (@action = 'INSERT' OR @action = 'UPDATE' OR @action = 'DELETE')
	BEGIN
		SET @value = 'personId='		+ (CASE WHEN (@personId IS NOT NULL AND LEN(@personId) > 0 AND CHARINDEX(@personId, @strBlank) = 0) THEN ('"' + @personId + '"') ELSE 'NULL' END) + ', ' +
					 'facultyId='		+ (CASE WHEN (@faculty IS NOT NULL AND LEN(@faculty) > 0 AND CHARINDEX(@faculty, @strBlank) = 0) THEN ('"' + @faculty + '"') ELSE 'NULL' END) + ', ' +
					 'programId='		+ (CASE WHEN (@program IS NOT NULL AND LEN(@program) > 0 AND CHARINDEX(@program, @strBlank) = 0) THEN ('"' + @program + '"') ELSE 'NULL' END) + ', ' +
					 'degree='			+ (CASE WHEN (@degreeLevel IS NOT NULL AND LEN(@degreeLevel) > 0 AND CHARINDEX(@degreeLevel, @strBlank) = 0) THEN ('"' + @degreeLevel + '"') ELSE 'NULL' END) + ', ' +
					 'programYear='		+ (CASE WHEN (@programYear IS NOT NULL AND LEN(@programYear) > 0 AND CHARINDEX(@programYear, @strBlank) = 0) THEN ('"' + @programYear + '"') ELSE 'NULL' END) + ', ' +
					 'class='			+ (CASE WHEN (@class IS NOT NULL AND LEN(@class) > 0 AND CHARINDEX(@class, @strBlank) = 0) THEN ('"' + @class + '"') ELSE 'NULL' END) + ', ' +
					 'status='			+ (CASE WHEN (@studentStatus IS NOT NULL AND LEN(@studentStatus) > 0) THEN ('"' + @studentStatus + '"') ELSE 'NULL' END) + ', ' +
					 'graduateDate='	+ (CASE WHEN (@graduateDate IS NOT NULL AND LEN(@graduateDate) > 0 AND CHARINDEX(@graduateDate, @strBlank) = 0) THEN ('"' + @graduateDate + '"') ELSE 'NULL' END) + ', ' +
					 'updateWhat='		+ (CASE WHEN (@updateWhat IS NOT NULL AND LEN(@updateWhat) > 0 AND CHARINDEX(@updateWhat, @strBlank) = 0) THEN ('"' + @updateWhat + '"') ELSE 'NULL' END) + ', ' +
					 'updateReason='	+ (CASE WHEN (@updateReason IS NOT NULL AND LEN(@updateReason) > 0 AND CHARINDEX(@updateReason, @strBlank) = 0) THEN ('"' + @updateReason + '"') ELSE 'NULL' END)
					 					 
		BEGIN TRY
			BEGIN TRAN
				IF (@action = 'INSERT')
				BEGIN
 					INSERT INTO stdStudent
 					(
						personId,
						facultyId,
						programId,
						degree,
						programYear,
						status,
						class,
						createdDate,
						createdBy,
						graduateDate,
						updateWhat,
						updateReason
					)
					VALUES
					(
						CASE WHEN (@personId IS NOT NULL AND LEN(@personId) > 0 AND CHARINDEX(@personId, @strBlank) = 0) THEN @personId ELSE NULL END,
						CASE WHEN (@faculty IS NOT NULL AND LEN(@faculty) > 0 AND CHARINDEX(@faculty, @strBlank) = 0) THEN @faculty ELSE NULL END,
						CASE WHEN (@program IS NOT NULL AND LEN(@program) > 0 AND CHARINDEX(@program, @strBlank) = 0) THEN @program ELSE NULL END,
						CASE WHEN (@degreeLevel IS NOT NULL AND LEN(@degreeLevel) > 0 AND CHARINDEX(@degreeLevel, @strBlank) = 0) THEN @degreeLevel ELSE NULL END,
						CASE WHEN (@programYear IS NOT NULL AND LEN(@programYear) > 0 AND CHARINDEX(@programYear, @strBlank) = 0) THEN @programYear ELSE NULL END,
						CASE WHEN (@studentStatus IS NOT NULL AND LEN(@studentStatus) > 0) THEN @studentStatus ELSE NULL END,
						CASE WHEN (@class IS NOT NULL AND LEN(@class) > 0 AND CHARINDEX(@class, @strBlank) = 0) THEN @class ELSE NULL END,
						GETDATE(),
						CASE WHEN (@by IS NOT NULL AND LEN(@by) > 0 AND CHARINDEX(@by, @strBlank) = 0) THEN @by ELSE NULL END,
						CASE WHEN (@graduateDate IS NOT NULL AND LEN(@graduateDate) > 0 AND CHARINDEX(@graduateDate, @strBlank) = 0) THEN CONVERT(DATETIME, @graduateDate, 103) ELSE NULL END,
						CASE WHEN (@updateWhat IS NOT NULL AND LEN(@updateWhat) > 0 AND CHARINDEX(@updateWhat, @strBlank) = 0) THEN @updateWhat ELSE NULL END,
						CASE WHEN (@updateReason IS NOT NULL AND LEN(@updateReason) > 0 AND CHARINDEX(@updateReason, @strBlank) = 0) THEN @updateReason ELSE NULL END
					)		
					
					SET @rowCount = @rowCount + 1
				END
				
				IF (@action = 'UPDATE')
				BEGIN
					IF (@personId IS NOT NULL AND LEN(@personId) > 0 AND CHARINDEX(@personId, @strBlank) = 0)
					BEGIN
						SET @rowCountUpdate = (SELECT COUNT(personId) FROM stdStudent WHERE personId = @personId)
						
						IF (@rowCountUpdate > 0)
						BEGIN
							UPDATE stdStudent SET
								facultyId		= CASE WHEN (@faculty IS NOT NULL AND LEN(@faculty) > 0 AND CHARINDEX(@faculty, @strBlank) = 0) THEN @faculty ELSE (CASE WHEN (@faculty IS NOT NULL AND (LEN(@faculty) = 0 OR CHARINDEX(@faculty, @strBlank) > 0)) THEN NULL ELSE facultyId END) END,
								programId		= CASE WHEN (@program IS NOT NULL AND LEN(@program) > 0 AND CHARINDEX(@program, @strBlank) = 0) THEN @program ELSE (CASE WHEN (@program IS NOT NULL AND (LEN(@program) = 0 OR CHARINDEX(@program, @strBlank) > 0)) THEN NULL ELSE programId END) END,
								degree			= CASE WHEN (@degreeLevel IS NOT NULL AND LEN(@degreeLevel) > 0 AND CHARINDEX(@degreeLevel, @strBlank) = 0) THEN @degreeLevel ELSE (CASE WHEN (@degreeLevel IS NOT NULL AND (LEN(@degreeLevel) = 0 OR CHARINDEX(@degreeLevel, @strBlank) > 0)) THEN NULL ELSE degree END) END,
								programYear		= CASE WHEN (@programYear IS NOT NULL AND LEN(@programYear) > 0 AND CHARINDEX(@programYear, @strBlank) = 0) THEN @programYear ELSE (CASE WHEN (@programYear IS NOT NULL AND (LEN(@programYear) = 0 OR CHARINDEX(@programYear, @strBlank) > 0)) THEN NULL ELSE programYear END) END,
								status			= CASE WHEN (@studentStatus IS NOT NULL AND LEN(@studentStatus) > 0) THEN @studentStatus ELSE (CASE WHEN (@studentStatus IS NOT NULL AND LEN(@studentStatus) = 0) THEN NULL ELSE status END) END,
								class			= CASE WHEN (@class IS NOT NULL AND LEN(@class) > 0 AND CHARINDEX(@class, @strBlank) = 0) THEN @class ELSE (CASE WHEN (@class IS NOT NULL AND (LEN(@class) = 0 OR CHARINDEX(@class, @strBlank) > 0)) THEN NULL ELSE class END) END,
								graduateDate	= CASE WHEN (@graduateDate IS NOT NULL AND LEN(@graduateDate) > 0 AND CHARINDEX(@graduateDate, @strBlank) = 0) THEN CONVERT(DATETIME, @graduateDate, 103) ELSE (CASE WHEN (@graduateDate IS NOT NULL AND (LEN(@graduateDate) = 0 OR CHARINDEX(@graduateDate, @strBlank) > 0)) THEN NULL ELSE graduateDate END) END,
								modifyDate		= GETDATE(),
								modifyBy		= CASE WHEN (@by IS NOT NULL AND LEN(@by) > 0 AND CHARINDEX(@by, @strBlank) = 0) THEN @by ELSE (CASE WHEN (@by IS NOT NULL AND (LEN(@by) = 0 OR CHARINDEX(@by, @strBlank) > 0)) THEN NULL ELSE modifyBy END) END,
								modifyIp		= CASE WHEN (@ip IS NOT NULL AND LEN(@ip) > 0 AND CHARINDEX(@ip, @strBlank) = 0) THEN @ip ELSE (CASE WHEN (@ip IS NOT NULL AND (LEN(@ip) = 0 OR CHARINDEX(@ip, @strBlank) > 0)) THEN NULL ELSE modifyIp END) END,
								updateWhat		= CASE WHEN (@updateWhat IS NOT NULL AND LEN(@updateWhat) > 0 AND CHARINDEX(@updateWhat, @strBlank) = 0) THEN @updateWhat ELSE (CASE WHEN (@updateWhat IS NOT NULL AND (LEN(@updateWhat) = 0 OR CHARINDEX(@updateWhat, @strBlank) > 0)) THEN NULL ELSE updateWhat END) END,
								updateReason	= CASE WHEN (@updateReason IS NOT NULL AND LEN(@updateReason) > 0 AND CHARINDEX(@updateReason, @strBlank) = 0) THEN @updateReason ELSE (CASE WHEN (@updateReason IS NOT NULL AND (LEN(@updateReason) = 0 OR CHARINDEX(@updateReason, @strBlank) > 0)) THEN NULL ELSE updateReason END) END
							WHERE personId = @personId
						END

						SET @rowCount = @rowCount + 1							
					END						
				END														
			COMMIT TRAN									
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN
			INSERT INTO InfinityLog..stdStudentErrorLog
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
	
	IF (@rowCount > 0)
	BEGIN
		SELECT	@studentId = studentCode
		FROM	stdStudent
		WHERE	personId = @personId
					
		IF (@studentId IS NOT NULL AND LEN(@studentId) > 0 AND CHARINDEX(@studentId, @strBlank) = 0)
		BEGIN
			IF (@updateWhat = 'UpdateFacultyAndProgram')
			BEGIN
				SELECT	@program		= programCode,
						@major			= majorCode,
						@groupNum		= groupNum,
						@programYear	= studyYear,
						@degreeLevel	= dLevel
				FROM	Infinity..acaProgram
				WHERE	id = @program
				
				UPDATE MUStudent..Student SET
					ProgramCode	= @program,
					MajorCode	= @major,
					GroupNum	= @groupNum,
					ProgramYear = @programYear,
					Degree = @degreeLevel
				WHERE StudentID = @studentId					
			END
			
			IF (@updateWhat = 'UpdateClassYear')
			BEGIN
				UPDATE MUStudent..StudentStatus SET
					CurrentYear	= @class
				WHERE StudentID = @studentId					
			END
			
			IF (@updateWhat = 'UpdateStudentStatus')
			BEGIN
				SELECT	@studentStatus = oldId
				FROM	Infinity..stdStatusType
				WHERE	id = @studentStatus
				
				UPDATE MUStudent..StudentStatus SET
					StudentStatus	= @studentStatus,
					GraduateDate	= CASE WHEN (@graduateDate IS NOT NULL AND LEN(@graduateDate) > 0 AND CHARINDEX(@graduateDate, @strBlank) = 0) THEN CONVERT(DATETIME, @graduateDate, 103) ELSE NULL END
				WHERE StudentID = @studentId					
			END			
		
			SET @rowCountUpdate = (SELECT COUNT(Studentid) FROM MUStudent..SReasonleave WHERE Studentid = @studentId)
			
			IF (@rowCountUpdate = 0)
			BEGIN
				INSERT INTO MUStudent..SReasonleave
				(
					Studentid,
					Reason
				)
				VALUES
				(
					@studentId,
					CASE WHEN (@updateReason IS NOT NULL AND LEN(@updateReason) > 0 AND CHARINDEX(@updateReason, @strBlank) = 0) THEN @updateReason ELSE NULL END
				)									
			END
			
			IF (@rowCountUpdate > 0)
			BEGIN
				UPDATE MUStudent..SReasonleave SET
					Reason = CASE WHEN (@updateReason IS NOT NULL AND LEN(@updateReason) > 0 AND CHARINDEX(@updateReason, @strBlank) = 0) THEN @updateReason ELSE NULL END
				WHERE Studentid = @studentId					
			END
		END
	END	
END

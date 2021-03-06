USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_hcsSetAgency]    Script Date: 5/4/2559 9:15:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๒๓/๐๗/๒๕๕๘>
-- Description	: <สำหรับบันทึกข้อมูลตาราง  hcsAgency ครั้งละ ๑ เรคคอร์ด>
--  1. action			เป็น VARCHAR	รับค่าการกระทำกับฐานข้อมูล
--  2. yearEntry		เป็น VARCHAR	รับค่าปีที่เข้าศึกษา
--	3. program			เป็น VARCHAR	รับค่ารหัสหลักสูตร
--	4. hospital			เป็น VARCHAR	รับค่าหน่วยบริการสุขภาพ
--	5. registrationForm	เป็น VARCHAR	รับค่าแบบฟอร์มบริการสุขภาพ
--	6. programAddress	เป็น VARCHAR	รับค่าที่อยู่สำหรับจัดส่งเอกสาร
--	7. programTelephone	เป็น VARCHAR	รับค่าเบอร์โทรศัพท์
--  8. cancelledStatus	เป็น VARCHAR	รับค่าสถานะการยกเลิก
--  9. by				เป็น NVARCHAR	รับค่าชื่อของผู้ที่กระทำกับฐานข้อมูล
-- 10. ip				เป็น VARCHAR	รับค่าหมายเลขไอพีของผู้ที่กระทำกับฐานข้อมูล
-- =============================================
ALTER PROCEDURE [dbo].[sp_hcsSetAgency]
(
	@action VARCHAR(10) = NULL,
	@yearEntry VARCHAR(4) = NULL,
	@program VARCHAR(15) = NULL,
	@hospital VARCHAR(15) = NULL,
	@registrationForm NVARCHAR(255) = NULL,
    @programAddress VARCHAR(255) = NULL,
    @programTelephone VARCHAR(100) = NULL,		
	@cancelledStatus VARCHAR(1) = NULL,
	@by NVARCHAR(255) = NULL,
	@ip VARCHAR(255) = NULL
)	
AS
BEGIN
	SET NOCOUNT ON

	SET @action = LTRIM(RTRIM(@action))
	SET @yearEntry = LTRIM(RTRIM(@yearEntry))
	SET @program = LTRIM(RTRIM(@program))
	SET @hospital = LTRIM(RTRIM(@hospital))
	SET @registrationForm = LTRIM(RTRIM(@registrationForm))	
	SET @programAddress = LTRIM(RTRIM(@programAddress))	
	SET @programTelephone = LTRIM(RTRIM(@programTelephone))	
	SET @cancelledStatus = LTRIM(RTRIM(@cancelledStatus))
	SET @by = LTRIM(RTRIM(@by))
	SET @ip = LTRIM(RTRIM(@ip))
	
	DECLARE @table VARCHAR(50) = 'hcsAgency'
	DECLARE @rowCount INT = 0
	DECLARE @rowCountUpdate INT = 0
	DECLARE @value NVARCHAR(MAX) = NULL
	DECLARE	@strBlank VARCHAR(50) = '----------**********.........0.0000000000000000000'
	
	SET @action = UPPER(@action)
	
	IF (@action = 'INSERT' OR @action = 'UPDATE' OR @action = 'DELETE')
	BEGIN
		SET @value = 'yearEntry='				+ (CASE WHEN (@yearEntry IS NOT NULL AND LEN(@yearEntry) > 0 AND CHARINDEX(@yearEntry, @strBlank) = 0) THEN ('"' + @yearEntry + '"') ELSE 'NULL' END) + ', ' +
					 'acaProgramId='			+ (CASE WHEN (@program IS NOT NULL AND LEN(@program) > 0 AND CHARINDEX(@program, @strBlank) = 0) THEN ('"' + @program + '"') ELSE 'NULL' END) + ', ' +
					 'hcsHospitalId='			+ (CASE WHEN (@hospital IS NOT NULL AND LEN(@hospital) > 0 AND CHARINDEX(@hospital, @strBlank) = 0) THEN ('"' + @hospital + '"') ELSE 'NULL' END) + ', ' +
					 'hcsRegistrationFormId='	+ (CASE WHEN (@registrationForm IS NOT NULL AND LEN(@registrationForm) > 0 AND CHARINDEX(@registrationForm, @strBlank) = 0) THEN ('"' + @registrationForm + '"') ELSE 'NULL' END) + ', ' +
					 'programAddress='			+ (CASE WHEN (@programAddress IS NOT NULL AND LEN(@programAddress) > 0 AND CHARINDEX(@programAddress, @strBlank) = 0) THEN ('"' + @programAddress + '"') ELSE 'NULL' END) + ', ' +
					 'programTelephone='		+ (CASE WHEN (@programTelephone IS NOT NULL AND LEN(@programTelephone) > 0 AND CHARINDEX(@programTelephone, @strBlank) = 0) THEN ('"' + @programTelephone + '"') ELSE 'NULL' END) + ', ' +
					 'cancelledStatus='			+ (CASE WHEN (@cancelledStatus IS NOT NULL AND LEN(@cancelledStatus) > 0 AND CHARINDEX(@cancelledStatus, @strBlank) = 0) THEN ('"' + @cancelledStatus + '"') ELSE 'NULL' END)
					 
		BEGIN TRY
			BEGIN TRAN
				IF (@action = 'INSERT')
				BEGIN
					IF ((@yearEntry + @program) IS NOT NULL AND LEN(@yearEntry + @program) > 0 AND CHARINDEX((@yearEntry + @program), @strBlank) = 0)
					BEGIN
						SET @rowCountUpdate = (SELECT COUNT(yearEntry + acaProgramId) FROM Infinity..hcsAgency WHERE ((yearEntry + acaProgramId) = (@yearEntry + @program)))
						
						IF (@rowCountUpdate = 0)
						BEGIN		
 							INSERT INTO Infinity..hcsAgency
 							(
								yearEntry,
								acaProgramId,
								hcsHospitalId,
								hcsRegistrationFormId,
								cancelledStatus,
								createDate,
								createBy,
								createIp,
								modifyDate,
								modifyBy,
								modifyIp
							)
							VALUES
							(
								CASE WHEN (@yearEntry IS NOT NULL AND LEN(@yearEntry) > 0 AND CHARINDEX(@yearEntry, @strBlank) = 0) THEN @yearEntry ELSE NULL END,
								CASE WHEN (@program IS NOT NULL AND LEN(@program) > 0 AND CHARINDEX(@program, @strBlank) = 0) THEN @program ELSE NULL END,
								CASE WHEN (@hospital IS NOT NULL AND LEN(@hospital) > 0 AND CHARINDEX(@hospital, @strBlank) = 0) THEN @hospital ELSE NULL END,
								CASE WHEN (@registrationForm IS NOT NULL AND LEN(@registrationForm) > 0 AND CHARINDEX(@registrationForm, @strBlank) = 0) THEN @registrationForm ELSE NULL END,
								CASE WHEN (@cancelledStatus IS NOT NULL AND LEN(@cancelledStatus) > 0 AND CHARINDEX(@cancelledStatus, @strBlank) = 0) THEN @cancelledStatus ELSE NULL END,
								GETDATE(),
								CASE WHEN (@by IS NOT NULL AND LEN(@by) > 0 AND CHARINDEX(@by, @strBlank) = 0) THEN @by ELSE NULL END,
								CASE WHEN (@ip IS NOT NULL AND LEN(@ip) > 0 AND CHARINDEX(@ip, @strBlank) = 0) THEN @ip ELSE NULL END,
								NULL,
								NULL,
								NULL
							)		
															
							SET @rowCount = @rowCount + 1
						END
					END													
				END					 
				
				IF (@action = 'UPDATE' OR @action = 'DELETE')					
				BEGIN
					IF ((@yearEntry + @program) IS NOT NULL AND LEN(@yearEntry + @program) > 0 AND CHARINDEX((@yearEntry + @program), @strBlank) = 0)
					BEGIN
						SET @rowCountUpdate = (SELECT COUNT(yearEntry + acaProgramId) FROM Infinity..hcsAgency WHERE ((yearEntry + acaProgramId) = (@yearEntry + @program)))

						IF (@rowCountUpdate > 0)
						BEGIN
							IF (@action = 'UPDATE')
							BEGIN								
								UPDATE Infinity..hcsAgency SET
									hcsHospitalId			= CASE WHEN (@hospital IS NOT NULL AND LEN(@hospital) > 0 AND CHARINDEX(@hospital, @strBlank) = 0) THEN @hospital ELSE (CASE WHEN (@hospital IS NOT NULL AND (LEN(@hospital) = 0 OR CHARINDEX(@hospital, @strBlank) > 0)) THEN NULL ELSE hcsHospitalId END) END,
									hcsRegistrationFormId	= CASE WHEN (@registrationForm IS NOT NULL AND LEN(@registrationForm) > 0 AND CHARINDEX(@registrationForm, @strBlank) = 0) THEN @registrationForm ELSE (CASE WHEN (@registrationForm IS NOT NULL AND (LEN(@registrationForm) = 0 OR CHARINDEX(@registrationForm, @strBlank) > 0)) THEN NULL ELSE hcsRegistrationFormId END) END,
									cancelledStatus			= CASE WHEN (@cancelledStatus IS NOT NULL AND LEN(@cancelledStatus) > 0 AND CHARINDEX(@cancelledStatus, @strBlank) = 0) THEN @cancelledStatus ELSE (CASE WHEN (@cancelledStatus IS NOT NULL AND (LEN(@cancelledStatus) = 0 OR CHARINDEX(@cancelledStatus, @strBlank) > 0)) THEN NULL ELSE cancelledStatus END) END,
									modifyDate				= GETDATE(),
									modifyBy				= CASE WHEN (@by IS NOT NULL AND LEN(@by) > 0 AND CHARINDEX(@by, @strBlank) = 0) THEN @by ELSE (CASE WHEN (@by IS NOT NULL AND (LEN(@by) = 0 OR CHARINDEX(@by, @strBlank) > 0)) THEN NULL ELSE modifyBy END) END,
									modifyIp				= CASE WHEN (@ip IS NOT NULL AND LEN(@ip) > 0 AND CHARINDEX(@ip, @strBlank) = 0) THEN @ip ELSE (CASE WHEN (@ip IS NOT NULL AND (LEN(@ip) = 0 OR CHARINDEX(@ip, @strBlank) > 0)) THEN NULL ELSE modifyIp END) END
								WHERE ((yearEntry + acaProgramId) = (@yearEntry + @program))
							END
															
							IF (@action = 'DELETE')
							BEGIN
								DELETE FROM Infinity..hcsAgency WHERE ((yearEntry + acaProgramId) = (@yearEntry + @program))
							END
								
							SET @rowCount = @rowCount + 1							
						END							
					END				
				END
				
				IF (@program IS NOT NULL AND LEN(@program) > 0 AND CHARINDEX(@program, @strBlank) = 0 AND @rowCount > 0)
				BEGIN
					UPDATE Infinity..acaProgram SET
						address		= CASE WHEN (@programAddress IS NOT NULL AND LEN(@programAddress) > 0 AND CHARINDEX(@programAddress, @strBlank) = 0) THEN @programAddress ELSE (CASE WHEN (@programAddress IS NOT NULL AND (LEN(@programAddress) = 0 OR CHARINDEX(@programAddress, @strBlank) > 0)) THEN NULL ELSE address END) END,
						telephone	= CASE WHEN (@programTelephone IS NOT NULL AND LEN(@programTelephone) > 0 AND CHARINDEX(@programTelephone, @strBlank) = 0) THEN @programTelephone ELSE (CASE WHEN (@programTelephone IS NOT NULL AND (LEN(@programTelephone) = 0 OR CHARINDEX(@programTelephone, @strBlank) > 0)) THEN NULL ELSE telephone END) END					
					WHERE (id = @program)
				END					
			COMMIT TRAN									
		END TRY
		BEGIN CATCH		
			ROLLBACK TRAN
			INSERT INTO InfinityLog..hcsErrorLog
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
END
USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_hcsSetDownloadLog]    Script Date: 12/11/2015 10:17:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๐๗/๐๘/๒๕๕๘>
-- Description	: <สำหรับบันทึกข้อมูลตาราง  hcsDownloadLog ครั้งละ ๑ เรคคอร์ด>
--  1. personId			เป็น VARCHAR	รับค่ารหัสบุคคล
--	2. registrationForm	เป็น VARCHAR	รับค่าแบบฟอร์มบริการสุขภาพ
--  3. by				เป็น NVARCHAR	รับค่าชื่อของผู้ที่กระทำกับฐานข้อมูล
--  4. ip				เป็น VARCHAR	รับค่าหมายเลขไอพี
-- =============================================
ALTER PROCEDURE [dbo].[sp_hcsSetDownloadLog]
(
	@personId VARCHAR(10) = NULL,
	@registrationForm VARCHAR(50) = NULL,			
	@by NVARCHAR(255) = NULL,
	@ip VARCHAR(255) = NULL
)	
AS
BEGIN
	SET NOCOUNT ON
	
	SET @personId = LTRIM(RTRIM(@personId))
	SET @registrationForm = LTRIM(RTRIM(@registrationForm))
	SET @by = LTRIM(RTRIM(@by))
	SET @ip = LTRIM(RTRIM(@ip))
	
	DECLARE @action VARCHAR(10) = 'INSERT'
	DECLARE @table VARCHAR(50) = 'hcsDownloadLog'
	DECLARE @rowCount INT = 0
	DECLARE @value NVARCHAR(MAX) = NULL
	DECLARE	@strBlank VARCHAR(50) = '----------**********.........0.0000000000000000000'		
	
	IF (@personId IS NOT NULL AND LEN(@personId) > 0)
	BEGIN
		SET @value = 'perPersonId='	+ (CASE WHEN (@personId IS NOT NULL AND LEN(@personId) > 0 AND CHARINDEX(@personId, @strBlank) = 0) THEN ('"' + @personId + '"') ELSE 'NULL' END) + ', ' +
					 'logForm='		+ (CASE WHEN (@registrationForm IS NOT NULL AND LEN(@registrationForm) > 0 AND CHARINDEX(@registrationForm, @strBlank) = 0) THEN ('"' + @registrationForm + '"') ELSE 'NULL' END)
					 
		BEGIN TRY
			BEGIN TRAN
				IF (@action = 'INSERT')
				BEGIN
 					INSERT INTO Infinity..hcsDownloadLog
 					(
						perPersonId,
						logForm,
						logDate,
						logBy,
						logIp
					)
					VALUES
					(
						CASE WHEN (@personId IS NOT NULL AND LEN(@personId) > 0 AND CHARINDEX(@personId, @strBlank) = 0) THEN @personId ELSE NULL END,
						CASE WHEN (@registrationForm IS NOT NULL AND LEN(@registrationForm) > 0 AND CHARINDEX(@registrationForm, @strBlank) = 0) THEN @registrationForm ELSE NULL END,
						GETDATE(),
						CASE WHEN (@by IS NOT NULL AND LEN(@by) > 0 AND CHARINDEX(@by, @strBlank) = 0) THEN @by ELSE NULL END,
						CASE WHEN (@ip IS NOT NULL AND LEN(@ip) > 0 AND CHARINDEX(@ip, @strBlank) = 0) THEN @ip ELSE NULL END
					)		
					
					SET @rowCount = @rowCount + 1
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

	DECLARE @latestDateDownload DATETIME
	DECLARE @countDownload INT

	SELECT	 @latestDateDownload = MAX(hcsdlg.logDate),
			 @countDownload = COUNT(hcsdlg.perPersonId)
	FROM	 hcsDownloadLog AS hcsdlg INNER JOIN
			 hcsForm AS hcsfrm ON hcsdlg.logForm = hcsfrm.id
	WHERE	 (hcsdlg.perPersonId = @personId) AND
			 (hcsdlg.logForm = @registrationForm) AND
			 (hcsdlg.logBy <> 'Student')
	GROUP BY hcsdlg.perPersonId, hcsdlg.logForm	
		
	SELECT @rowCount, @latestDateDownload, @countDownload
END
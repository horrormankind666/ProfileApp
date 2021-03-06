USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_segSetValidateLog]    Script Date: 05-09-2016 08:28:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๓๐/๐๘/๒๕๕๙>
-- Description	: <สำหรับบันทึกข้อมูลตาราง segValidateLog ครั้งละ ๑ เรคคอร์ด>
--  1. personId			เป็น VARCHAR	รับค่ารหัสบุคคล
--	2. validateResult	เป็น VARCHAR	รับค่าผลการตรวจสอบ
--  3. by				เป็น NVARCHAR	รับค่าชื่อของผู้ที่กระทำกับฐานข้อมูล
--  4. ip				เป็น VARCHAR	รับค่าหมายเลขไอพี
-- =============================================
ALTER PROCEDURE [dbo].[sp_segSetValidateLog]
(
	@personId VARCHAR(10) = NULL,
	@validateResult VARCHAR(1) = NULL,			
	@by NVARCHAR(255) = NULL,
	@ip VARCHAR(20) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	
	SET @personId = LTRIM(RTRIM(@personId))
	SET @validateResult = LTRIM(RTRIM(@validateResult))
	SET @by = LTRIM(RTRIM(@by))
	SET @ip = LTRIM(RTRIM(@ip))
	
	DECLARE @action VARCHAR(10) = 'INSERT'
	DECLARE @table VARCHAR(50) = 'segValidateLog'
	DECLARE @rowCount INT = 0
	DECLARE @value NVARCHAR(MAX) = NULL
	DECLARE	@strBlank VARCHAR(50) = '----------**********.........0.0000000000000000000'

	IF (@personId IS NOT NULL AND LEN(@personId) > 0)
	BEGIN
		SET @value = 'perPersonId='		+ (CASE WHEN (@personId IS NOT NULL AND LEN(@personId) > 0 AND CHARINDEX(@personId, @strBlank) = 0) THEN ('"' + @personId + '"') ELSE 'NULL' END) + ', ' +
					 'validateResult='	+ (CASE WHEN (@validateResult IS NOT NULL AND LEN(@validateResult) > 0 AND CHARINDEX(@validateResult, @strBlank) = 0) THEN ('"' + @validateResult + '"') ELSE 'NULL' END)

		BEGIN TRY
			BEGIN TRAN
				IF (@action = 'INSERT')
				BEGIN
 					INSERT INTO Infinity..segValidateLog
 					(
						perPersonId,
						validateResult,
						validateDate,
						validateBy,
						validateIP
					)
					VALUES
					(
						CASE WHEN (@personId IS NOT NULL AND LEN(@personId) > 0 AND CHARINDEX(@personId, @strBlank) = 0) THEN @personId ELSE NULL END,
						CASE WHEN (@validateResult IS NOT NULL AND LEN(@validateResult) > 0 AND CHARINDEX(@validateResult, @strBlank) = 0) THEN @validateResult ELSE NULL END,
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
			INSERT INTO InfinityLog..segErrorLog
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

	DECLARE @latestValidateResult VARCHAR(1)
	DECLARE @latestValidateDate DATETIME	

	SELECT	TOP 1
			@latestValidateResult = segvlg.validateResult,
			@latestValidateDate = segvlg.validateDate
	FROM	Infinity..segValidateLog AS segvlg
	WHERE	(segvlg.perPersonId = @personId)
	ORDER BY id DESC
		
	SELECT	@rowCount AS rowAction,
			@personId AS personId,			
			@latestValidateDate AS latestValidateDate,
			@latestValidateResult AS latestValidateResult,
			(
				CASE @latestValidateResult
					WHEN 'Y' THEN 'ข้อมูลถูกต้อง'
					WHEN 'N' THEN 'ข้อมูลไม่ถุกต้อง'
				END
			) AS latestValidateResultTH,
			(
				CASE @latestValidateResult
					WHEN 'Y' THEN 'Correct Information'
					WHEN 'N' THEN 'Incorrect Information'
				END
			) AS latestValidateResultEN
END
USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_perSetBankAccount]    Script Date: 11/16/2015 16:20:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๒๓/๑๒/๒๕๕๖>
-- Description	: <สำหรับบันทึกข้อมูลตาราง perBankAccount ครั้งละ ๑ เรคคอร์ด>
--  1. action			เป็น VARCHAR	รับค่าการกระทำกับฐานข้อมูล
--  2. personId			เป็น VARCHAR	รับค่ารหัสบุคคล
--  3. bankCode			เป็น VARCHAR	รับค่ารหัสธนาคาร
--  4. bankCodeNew		เป็น VARCHAR	รับค่ารหัสธนาคารใหม่ กรณี Update
--	5. accNo			เป็น VARCHAR	รับค่าเลขบัญชี
--  6. cancelledStatus	เป็น VARCHAR	รับค่าสถานะการยกเลิก
--	7. by				เป็น NVARCHAR	รับค่าชื่อของผู้ที่กระทำกับฐานข้อมูล
--	8. ip				เป็น VARCHAR	รับค่าหมายเลขไอพีของผู้ที่กระทำกับฐานข้อมูล
-- =============================================
ALTER PROCEDURE [dbo].[sp_perSetBankAccount]
(
	@action VARCHAR(10) = NULL,
	@personId VARCHAR(10) = NULL,
	@bankCode VARCHAR(10) = NULL,
	@bankCodeNew VARCHAR(10) = NULL,
	@accNo VARCHAR(20) = NULL,
	@cancelledStatus VARCHAR(1) = NULL,
	@by NVARCHAR(255) = NULL,
	@ip VARCHAR(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	
	SET @action = LTRIM(RTRIM(@action))
	SET @personId = LTRIM(RTRIM(@personId))
	SET @bankCode = LTRIM(RTRIM(@bankCode))
	SET @bankCodeNew = LTRIM(RTRIM(@bankCodeNew))
	SET @accNo = LTRIM(RTRIM(@accNo))
	SET @cancelledStatus = LTRIM(RTRIM(@cancelledStatus))
	SET @by = LTRIM(RTRIM(@by))
	SET @ip = LTRIM(RTRIM(@ip))
	
	DECLARE @table VARCHAR(50) = 'perBankAccount'
	DECLARE @rowCount INT = 0
	DECLARE @rowCountUpdate INT = 0
	DECLARE @value NVARCHAR(MAX) = NULL
	DECLARE	@strBlank VARCHAR(50) = '----------**********.........0.0000000000000000000'
	
	SET @action = UPPER(@action)	
	
	IF (@action = 'INSERT' OR @action = 'UPDATE' OR @action = 'DELETE')
	BEGIN
		SET @value = 'perPersonId=' + (CASE WHEN (@personId IS NOT NULL AND LEN(@personId) > 0 AND CHARINDEX(@personId, @strBlank) = 0) THEN ('"' + @personId + '"') ELSE 'NULL' END) + ', ' +
					 'bankCode=' + (CASE WHEN (@bankCode IS NOT NULL AND LEN(@bankCode) > 0 AND CHARINDEX(@bankCode, @strBlank) = 0) THEN ('"' + @bankCode + '"') ELSE 'NULL' END) + ', ' +
					 'bankCodeNew=' + (CASE WHEN (@bankCodeNew IS NOT NULL AND LEN(@bankCodeNew) > 0 AND CHARINDEX(@bankCodeNew, @strBlank) = 0) THEN ('"' + @bankCodeNew + '"') ELSE 'NULL' END) + ', ' +
					 'accNo=' + (CASE WHEN (@accNo IS NOT NULL AND LEN(@accNo) > 0 AND CHARINDEX(@accNo, @strBlank) = 0) THEN ('"' + @accNo + '"') ELSE 'NULL' END) + ', ' +
					 'cancel=' + (CASE WHEN (@cancelledStatus IS NOT NULL AND LEN(@cancelledStatus) > 0 AND CHARINDEX(@cancelledStatus, @strBlank) = 0) THEN ('"' + @cancelledStatus + '"') ELSE 'NULL' END)		
		BEGIN TRY
			BEGIN TRAN
				IF (@action = 'INSERT')
				BEGIN
 					INSERT INTO perBankAccount
 					(
						perPersonId,
						bankCode,
						accNo,
						cancelStatus,
						createdDate,
						createdBy,
						createdIp
					)
					VALUES
					(
						CASE WHEN (@personId IS NOT NULL AND LEN(@personId) > 0 AND CHARINDEX(@personId, @strBlank) = 0) THEN @personId ELSE NULL END,
						CASE WHEN (@bankCode IS NOT NULL AND LEN(@bankCode) > 0 AND CHARINDEX(@bankCode, @strBlank) = 0) THEN @bankCode ELSE NULL END,
						CASE WHEN (@accNo IS NOT NULL AND LEN(@accNo) > 0 AND CHARINDEX(@accNo, @strBlank) = 0) THEN @accNo ELSE NULL END,
						CASE WHEN (@cancelledStatus IS NOT NULL AND LEN(@cancelledStatus) > 0 AND CHARINDEX(@cancelledStatus, @strBlank) = 0) THEN @cancelledStatus ELSE NULL END,
						GETDATE(),
						CASE WHEN (@by IS NOT NULL AND LEN(@by) > 0 AND CHARINDEX(@by, @strBlank) = 0) THEN @by ELSE NULL END,
						CASE WHEN (@ip IS NOT NULL AND LEN(@ip) > 0 AND CHARINDEX(@ip, @strBlank) = 0) THEN @ip ELSE NULL END
					)		
					
					SET @rowCount = @rowCount + 1
				END
				
				IF (@action = 'UPDATE' OR @action = 'DELETE')					
				BEGIN
					IF ((@personId IS NOT NULL AND LEN(@personId) > 0 AND CHARINDEX(@personId, @strBlank) = 0) AND
						(@bankCode IS NOT NULL AND LEN(@bankCode) > 0 AND CHARINDEX(@bankCode, @strBlank) = 0))
					BEGIN
						SET @rowCountUpdate = (SELECT COUNT(perPersonId + bankCode) FROM perBankAccount WHERE (perPersonId = @personId) AND (bankCode = @bankCode))
						
						IF (@rowCountUpdate > 0)
						BEGIN
							IF (@action = 'UPDATE')
							BEGIN
								UPDATE perBankAccount SET
									bankCode		= CASE WHEN (@bankCodeNew IS NOT NULL AND LEN(@bankCodeNew) > 0 AND CHARINDEX(@bankCodeNew, @strBlank) = 0) THEN @bankCodeNew ELSE (CASE WHEN (@bankCodeNew IS NOT NULL AND (LEN(@bankCodeNew) = 0 OR CHARINDEX(@bankCodeNew, @strBlank) > 0)) THEN NULL ELSE bankCode END) END,
									accNo			= CASE WHEN (@accNo IS NOT NULL AND LEN(@accNo) > 0 AND CHARINDEX(@accNo, @strBlank) = 0) THEN @accNo ELSE (CASE WHEN (@accNo IS NOT NULL AND (LEN(@accNo) = 0 OR CHARINDEX(@accNo, @strBlank) > 0)) THEN NULL ELSE accNo END) END,
									cancelStatus	= CASE WHEN (@cancelledStatus IS NOT NULL AND LEN(@cancelledStatus) > 0 AND CHARINDEX(@cancelledStatus, @strBlank) = 0) THEN @cancelledStatus ELSE (CASE WHEN (@cancelledStatus IS NOT NULL AND (LEN(@cancelledStatus) = 0 OR CHARINDEX(@cancelledStatus, @strBlank) > 0)) THEN NULL ELSE cancelStatus END) END
								WHERE perPersonId = @personId	
							END
							
							IF (@action = 'DELETE')								
							BEGIN
								DELETE FROM perBankAccount WHERE (perPersonId = @personId) AND (bankCode = @bankCode)
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
END
USE [MUStudent]
GO
/****** Object:  StoredProcedure [dbo].[sp_perSetListBankAccount]    Script Date: 03/27/2014 11:46:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<ยุทธภูมิ ตวันนา>
-- Create date: <๒๓/๑๒/๒๕๕๖>
-- Description:	<สำหรับบันทึกข้อมูลตาราง perBankAccount ครั้งละหลายเรคคอร์ด>
--  1. order		เป็น VARCHAR	รับค่าลำดับของเรคคอร์ด
--  2. perPersonId	เป็น VARCHAR	รับค่ารหัสบุคคล
--  3. bankCode		เป็น VARCHAR	รับค่ารหัสธนาคาร
--	4. accNo		เป็น VARCHAR	รับค่าเลขบัญชี
--	5. cancelStatus	เป็น VARCHAR	รับค่าสถานะการใช้งาน
--	6. by			เป็น NVARCHAR	รับค่าชื่อของผู้ที่กระทำกับฐานข้อมูล
-- =============================================
ALTER PROCEDURE [dbo].[sp_perSetListBankAccount] 
(
	@order VARCHAR(MAX) = NULL,
	@perPersonId VARCHAR(MAX) = NULL,
	@bankCode VARCHAR(MAX) = NULL,
	@accNo VARCHAR(MAX) = NULL,
	@cancelStatus VARCHAR(MAX) = NULL,
	@by NVARCHAR(255) = NULL
)	
AS
BEGIN
	SET NOCOUNT ON
	
	SET @order = LTRIM(RTRIM(@order))
	SET @perPersonId = LTRIM(RTRIM(@perPersonId))
	SET @bankCode = LTRIM(RTRIM(@bankCode))
	SET @accNo = LTRIM(RTRIM(@accNo))
	SET @cancelStatus = LTRIM(RTRIM(@cancelStatus))
	SET @by = LTRIM(RTRIM(@by))
	
	DECLARE @action VARCHAR(10) = 'INSERT'
	DECLARE @table VARCHAR(50) = 'perBankAccount'
	DECLARE @i INT = 1
	DECLARE @delimiter CHAR(1) = ';'
	DECLARE @orderSlice VARCHAR(MAX) = NULL
	DECLARE @perPersonIdSlice VARCHAR(MAX) = NULL
	DECLARE @bankCodeSlice VARCHAR(MAX) = NULL
	DECLARE @accNoSlice VARCHAR(MAX) = NULL
	DECLARE @cancelStatusSlice VARCHAR(MAX) = NULL
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
		
		SET @bankCodeSlice = (SELECT stringSlice FROM fnc_perParseString(@bankCode, @delimiter))
		SET @bankCode = (SELECT string FROM fnc_perParseString(@bankCode, @delimiter))
		
		SET @accNoSlice = (SELECT stringSlice FROM fnc_perParseString(@accNo, @delimiter))
		SET @accNo = (SELECT string FROM fnc_perParseString(@accNo, @delimiter))

		SET @cancelStatusSlice = (SELECT stringSlice FROM fnc_perParseString(@cancelStatus, @delimiter))
		SET @cancelStatus = (SELECT string FROM fnc_perParseString(@cancelStatus, @delimiter))

		IF (LEN(@orderSlice) > 0)
		BEGIN			
			SET @value = 'perPersonId=' + (CASE WHEN (@perPersonIdSlice IS NOT NULL AND LEN(@perPersonIdSlice) > 0 AND CHARINDEX(@perPersonIdSlice, @strBlank) = 0) THEN ('"' + @perPersonIdSlice + '"') ELSE 'NULL' END) + ', ' +
						 'bankCode=' + (CASE WHEN (@bankCodeSlice IS NOT NULL AND LEN(@bankCodeSlice) > 0 AND CHARINDEX(@bankCodeSlice, @strBlank) = 0) THEN ('"' + @bankCodeSlice + '"') ELSE 'NULL' END) + ', ' +
						 'accNo=' + (CASE WHEN (@accNoSlice IS NOT NULL AND LEN(@accNoSlice) > 0 AND CHARINDEX(@accNoSlice, @strBlank) = 0) THEN ('"' + @accNoSlice + '"') ELSE 'NULL' END) + ', ' +
						 'cancelStatus=' + (CASE WHEN (@cancelStatusSlice IS NOT NULL AND LEN(@cancelStatusSlice) > 0 AND CHARINDEX(@cancelStatusSlice, @strBlank) = 0) THEN ('"' + @cancelStatusSlice + '"') ELSE 'NULL' END)

			BEGIN TRY
				BEGIN TRAN	
					INSERT INTO perBankAccount
					(
						perPersonId,
						bankCode,
						accNo,
						cancelStatus,
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
						CASE WHEN (@bankCodeSlice IS NOT NULL AND LEN(@bankCodeSlice) > 0 AND CHARINDEX(@bankCodeSlice, @strBlank) = 0) THEN @bankCodeSlice ELSE NULL END,
						CASE WHEN (@accNoSlice IS NOT NULL AND LEN(@accNoSlice) > 0 AND CHARINDEX(@accNoSlice, @strBlank) = 0) THEN @accNoSlice ELSE NULL END,
						CASE WHEN (@cancelStatusSlice IS NOT NULL AND LEN(@cancelStatusSlice) > 0 AND CHARINDEX(@cancelStatusSlice, @strBlank) = 0) THEN @cancelStatusSlice ELSE NULL END,
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

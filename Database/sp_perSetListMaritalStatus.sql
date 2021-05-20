USE [MUStudent]
GO
/****** Object:  StoredProcedure [dbo].[sp_perSetListMaritalStatus]    Script Date: 03/27/2014 11:49:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๒๐/๑๑/๒๕๕๖>
-- Description	: <สำหรับบันทึกข้อมูลตาราง perMaritalStatus ครั้งละหลายเรคคอร์ด>
--  1. order				เป็น VARCHAR	รับค่าลำดับของเรคคอร์ด
--  2. id					เป็น VARCHAR	รับค่ารหัสสถานะภาพการสมรส
--  3. thMaritalStatusName	เป็น NVARCHAR	รับค่าชื่อสถานะภาพการสมรสภาษาไทย
--  4. enMaritalStatusName	เป็น NVARCHAR	รับค่าชื่อสถานะภาพการสมรสภาษาอังกฤษ
--  5. by					เป็น NVARCHAR	รับค่าชื่อของผู้ที่กระทำกับฐานข้อมูล
-- =============================================
ALTER PROCEDURE [dbo].[sp_perSetListMaritalStatus]
(
	@order VARCHAR(MAX) = NULL,
	@id VARCHAR(MAX) = NULL,
	@thMaritalStatusName NVARCHAR(MAX) = NULL,
	@enMaritalStatusName NVARCHAR(MAX) = NULL,
	@by NVARCHAR(255) = NULL	
)
AS
BEGIN
	SET NOCOUNT ON
	
	SET @order = LTRIM(RTRIM(@order))
	SET @id = LTRIM(RTRIM(@id))
	SET @thMaritalStatusName = LTRIM(RTRIM(@thMaritalStatusName))
	SET @enMaritalStatusName = LTRIM(RTRIM(@enMaritalStatusName))
	SET @by = LTRIM(RTRIM(@by))
	
	DECLARE @action VARCHAR(10) = 'INSERT'
	DECLARE @table VARCHAR(50) = 'perMaritalStatus'
	DECLARE @i INT = 1
	DECLARE @delimiter CHAR(1) = ';'
	DECLARE @orderSlice VARCHAR(MAX) = NULL
	DECLARE @idSlice VARCHAR(MAX) = NULL
	DECLARE @thMaritalStatusNameSlice NVARCHAR(MAX) = NULL
	DECLARE @enMaritalStatusNameSlice NVARCHAR(MAX) = NULL
	DECLARE @rowCount INT = 0
	DECLARE @value NVARCHAR(MAX) = NULL	
	DECLARE	@strBlank VARCHAR(50) = '----------**********.........0.0000000000000000000'
	DECLARE @ip VARCHAR(255) = dbo.fnc_perGetIP()
	
	WHILE (LEN(@order) > 0)
	BEGIN
		SET @orderSlice = (SELECT stringSlice FROM fnc_perParseString(@order, @delimiter))
		SET @order = (SELECT string FROM fnc_perParseString(@order, @delimiter))

		SET @idSlice = (SELECT stringSlice FROM fnc_perParseString(@id, @delimiter))
		SET @id = (SELECT string FROM fnc_perParseString(@id, @delimiter))
		
		SET @thMaritalStatusNameSlice = (SELECT stringSlice FROM fnc_perParseString(@thMaritalStatusName, @delimiter))
		SET @thMaritalStatusName = (SELECT string FROM fnc_perParseString(@thMaritalStatusName, @delimiter))
						
		SET @enMaritalStatusNameSlice = (SELECT stringSlice FROM fnc_perParseString(@enMaritalStatusName, @delimiter))
		SET @enMaritalStatusName = (SELECT string FROM fnc_perParseString(@enMaritalStatusName, @delimiter))

		IF (LEN(@orderSlice) > 0)
		BEGIN			
			SET @value = 'id=' + (CASE WHEN (@idSlice IS NOT NULL AND LEN(@idSlice) > 0 AND CHARINDEX(@idSlice, @strBlank) = 0) THEN ('"' + @idSlice + '"') ELSE 'NULL' END) + ', ' +
						 'thMaritalStatusName=' + (CASE WHEN (@thMaritalStatusNameSlice IS NOT NULL AND LEN(@thMaritalStatusNameSlice) > 0 AND CHARINDEX(@thMaritalStatusNameSlice, @strBlank) = 0) THEN ('"' + @thMaritalStatusNameSlice + '"') ELSE 'NULL' END) + ', ' +
						 'enMaritalStatusName=' + (CASE WHEN (@enMaritalStatusNameSlice IS NOT NULL AND LEN(@enMaritalStatusNameSlice) > 0 AND CHARINDEX(@enMaritalStatusNameSlice, @strBlank) = 0) THEN ('"' + @enMaritalStatusNameSlice + '"') ELSE 'NULL' END)
						 						 
			BEGIN TRY
				BEGIN TRAN	
					INSERT INTO perMaritalStatus
					(
						id,
						thMaritalStatusName,
						enMaritalStatusName,
						createDate,
						createBy,
						createIp,
						modifyDate,
						modifyBy,
						modifyIp						
					)
					VALUES
					(
						CASE WHEN (@idSlice IS NOT NULL AND LEN(@idSlice) > 0 AND CHARINDEX(@idSlice, @strBlank) = 0) THEN @idSlice ELSE NULL END,
						CASE WHEN (@thMaritalStatusNameSlice IS NOT NULL AND LEN(@thMaritalStatusNameSlice) > 0 AND CHARINDEX(@thMaritalStatusNameSlice, @strBlank) = 0) THEN @thMaritalStatusNameSlice ELSE NULL END,
						CASE WHEN (@enMaritalStatusNameSlice IS NOT NULL AND LEN(@enMaritalStatusNameSlice) > 0 AND CHARINDEX(@enMaritalStatusNameSlice, @strBlank) = 0) THEN @enMaritalStatusNameSlice ELSE NULL END,
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

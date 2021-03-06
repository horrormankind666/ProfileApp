USE [MUStudent]
GO
/****** Object:  StoredProcedure [dbo].[sp_perSetListAgency]    Script Date: 03/27/2014 11:46:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๘/๑๒/๒๕๕๖>
-- Description	: <สำหรับบันทึกข้อมูลตาราง perAgency ครั้งละหลายเรคคอร์ด>
--  1. order		เป็น VARCHAR	รับค่าลำดับของเรคคอร์ด
--  2. id			เป็น VARCHAR	รับค่ารหัสต้นสังกัด
--  3. thAgencyName	เป็น NVARCHAR	รับค่าชื่อต้นสังกัดภาษาไทย
--  4. enAgencyName	เป็น NVARCHAR	รับค่าชื่อต้นสังกัดภาษาอังกฤษ
--	5. by			เป็น NVARCHAR	รับค่าชื่อของผู้ที่กระทำกับฐานข้อมูล
-- =============================================
ALTER PROCEDURE [dbo].[sp_perSetListAgency]
(
	@order VARCHAR(MAX) = NULL,
	@id VARCHAR(MAX) = NULL,
    @thAgencyName NVARCHAR(MAX) = NULL,
    @enAgencyName NVARCHAR(MAX) = NULL,
    @by NVARCHAR(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	
	SET @order = LTRIM(RTRIM(@order))
	SET @id = LTRIM(RTRIM(@id))
	SET @thAgencyName = LTRIM(RTRIM(@thAgencyName))
	SET @enAgencyName = LTRIM(RTRIM(@enAgencyName))
	SET @by = LTRIM(RTRIM(@by))
	
	DECLARE @action VARCHAR(10) = 'INSERT'
	DECLARE @table VARCHAR(50) = 'perAgency'
	DECLARE @i INT = 1
	DECLARE @delimiter CHAR(1) = ';'
	DECLARE @orderSlice VARCHAR(MAX) = NULL
	DECLARE @idSlice VARCHAR(MAX) = NULL
	DECLARE @thAgencyNameSlice NVARCHAR(MAX) = NULL
	DECLARE @enAgencyNameSlice NVARCHAR(MAX) = NULL
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
		
		SET @thAgencyNameSlice = (SELECT stringSlice FROM fnc_perParseString(@thAgencyName, @delimiter))
		SET @thAgencyName = (SELECT string FROM fnc_perParseString(@thAgencyName, @delimiter))
						
		SET @enAgencyNameSlice = (SELECT stringSlice FROM fnc_perParseString(@enAgencyName, @delimiter))
		SET @enAgencyName = (SELECT string FROM fnc_perParseString(@enAgencyName, @delimiter))		
		
		IF (LEN(@orderSlice) > 0)
		BEGIN			
			SET @value = 'id=' + (CASE WHEN (@idSlice IS NOT NULL AND LEN(@idSlice) > 0 AND CHARINDEX(@idSlice, @strBlank) = 0) THEN ('"' + @idSlice + '"') ELSE 'NULL' END) + ', ' +
						 'thAgencyName=' + (CASE WHEN (@thAgencyNameSlice IS NOT NULL AND LEN(@thAgencyNameSlice) > 0 AND CHARINDEX(@thAgencyNameSlice, @strBlank) = 0) THEN ('"' + @thAgencyNameSlice + '"') ELSE 'NULL' END) + ', ' +
						 'enAgencyName=' + (CASE WHEN (@enAgencyNameSlice IS NOT NULL AND LEN(@enAgencyNameSlice) > 0 AND CHARINDEX(@enAgencyNameSlice, @strBlank) = 0) THEN ('"' + @enAgencyNameSlice + '"') ELSE 'NULL' END)
						 						 
			BEGIN TRY
				BEGIN TRAN	
					INSERT INTO perAgency
					(
						id,
						thAgencyName,
						enAgencyName,
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
						CASE WHEN (@thAgencyNameSlice IS NOT NULL AND LEN(@thAgencyNameSlice) > 0 AND CHARINDEX(@thAgencyNameSlice, @strBlank) = 0) THEN @thAgencyNameSlice ELSE NULL END,
						CASE WHEN (@enAgencyNameSlice IS NOT NULL AND LEN(@enAgencyNameSlice) > 0 AND CHARINDEX(@enAgencyNameSlice, @strBlank) = 0) THEN @enAgencyNameSlice ELSE NULL END,
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

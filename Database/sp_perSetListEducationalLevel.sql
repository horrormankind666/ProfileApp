USE [MUStudent]
GO
/****** Object:  StoredProcedure [dbo].[sp_perSetListEducationalLevel]    Script Date: 03/27/2014 11:48:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๐๖/๑๑/๒๕๕๖>
-- Description	: <สำหรับบันทึกข้อมูลตาราง perEducationalLevel ครั้งละหลายเรคคอร์ด>
--  1. order					เป็น VARCHAR	รับค่าลำดับของเรคคอร์ด
--  2. id						เป็น VARCHAR	รับค่ารหัสระดับการศึกษา
--  3. thEducationalLevelName	เป็น NVARCHAR	รับค่าชื่อระดับการศึกษาภาษาไทย
--  4. enEducationalLevelName	เป็น NVARCHAR	รับค่าชื่อระดับการศึกษาภาษาอังกฤษ
--	5. by						เป็น NVARCHAR	รับค่าชื่อของผู้ที่กระทำกับฐานข้อมูล
-- =============================================
ALTER PROCEDURE [dbo].[sp_perSetListEducationalLevel]
(
	@order VARCHAR(MAX) = NULL,
	@id VARCHAR(MAX) = NULL,
	@thEducationalLevelName NVARCHAR(MAX) = NULL,
	@enEducationalLevelName NVARCHAR(MAX) = NULL,
	@by NVARCHAR(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	
	SET @order = LTRIM(RTRIM(@order))
	SET @id = LTRIM(RTRIM(@id))
	SET @thEducationalLevelName = LTRIM(RTRIM(@thEducationalLevelName))
	SET @enEducationalLevelName = LTRIM(RTRIM(@enEducationalLevelName))
	SET @by = LTRIM(RTRIM(@by))
			
	DECLARE @action VARCHAR(10) = 'INSERT'
	DECLARE @table VARCHAR(50) = 'perEducationalLevel'
	DECLARE @i INT = 1
	DECLARE @delimiter CHAR(1) = ';'
	DECLARE @orderSlice VARCHAR(MAX) = NULL
	DECLARE @idSlice VARCHAR(MAX) = NULL
	DECLARE @thEducationalLevelNameSlice NVARCHAR(MAX) = NULL
	DECLARE @enEducationalLevelNameSlice NVARCHAR(MAX) = NULL	
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
		
		SET @thEducationalLevelNameSlice = (SELECT stringSlice FROM fnc_perParseString(@thEducationalLevelName, @delimiter))
		SET @thEducationalLevelName = (SELECT string FROM fnc_perParseString(@thEducationalLevelName, @delimiter))
						
		SET @enEducationalLevelNameSlice = (SELECT stringSlice FROM fnc_perParseString(@enEducationalLevelName, @delimiter))
		SET @enEducationalLevelName = (SELECT string FROM fnc_perParseString(@enEducationalLevelName, @delimiter))

		IF (LEN(@orderSlice) > 0)
		BEGIN			
			SET @value = 'id=' + (CASE WHEN (@idSlice IS NOT NULL AND LEN(@idSlice) > 0 AND CHARINDEX(@idSlice, @strBlank) = 0) THEN ('"' + @idSlice + '"') ELSE 'NULL' END) + ', ' +
						 'thEducationalLevelName=' + (CASE WHEN (@thEducationalLevelNameSlice IS NOT NULL AND LEN(@thEducationalLevelNameSlice) > 0 AND CHARINDEX(@thEducationalLevelNameSlice, @strBlank) = 0) THEN ('"' + @thEducationalLevelNameSlice + '"') ELSE 'NULL' END) + ', ' +
						 'enEducationalLevelName=' + (CASE WHEN (@enEducationalLevelNameSlice IS NOT NULL AND LEN(@enEducationalLevelNameSlice) > 0 AND CHARINDEX(@enEducationalLevelNameSlice, @strBlank) = 0) THEN ('"' + @enEducationalLevelNameSlice + '"') ELSE 'NULL' END)

			BEGIN TRY
				BEGIN TRAN	
					INSERT INTO perEducationalLevel
					(
						id,
						thEducationalLevelName,
						enEducationalLevelName,
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
						CASE WHEN (@thEducationalLevelNameSlice IS NOT NULL AND LEN(@thEducationalLevelNameSlice) > 0 AND CHARINDEX(@thEducationalLevelNameSlice, @strBlank) = 0) THEN @thEducationalLevelNameSlice ELSE NULL END,
						CASE WHEN (@enEducationalLevelNameSlice IS NOT NULL AND LEN(@enEducationalLevelNameSlice) > 0 AND CHARINDEX(@enEducationalLevelNameSlice, @strBlank) = 0) THEN @enEducationalLevelNameSlice ELSE NULL END,
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

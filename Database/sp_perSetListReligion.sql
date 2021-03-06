USE [MUStudent]
GO
/****** Object:  StoredProcedure [dbo].[sp_perSetListReligion]    Script Date: 03/27/2014 11:51:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๘/๑๑/๒๕๕๖>
-- Description	: <สำหรับบันทึกข้อมูลตาราง perReligion ครั้งละหลายเรคคอร์ด>
--  1. order			เป็น VARCHAR	รับค่าลำดับของเรคคอร์ด
--  2. id 				เป็น VARCHAR	รับค่ารหัสศาสนา
--  3. thReligionName	เป็น NVARCHAR	รับค่าชื่อศาสนาภาษาไทย
--  4. enReligionName	เป็น NVARCHAR	รับค่าชื่อศาสนาภาษาอังกฤษ
--  5. by				เป็น NVARCHAR	รับค่าชื่อของผู้ที่กระทำกับฐานข้อมูล
-- =============================================
ALTER PROCEDURE [dbo].[sp_perSetListReligion]
(
	@order VARCHAR(MAX) = NULL,
	@id VARCHAR(MAX) = NULL,
	@thReligionName NVARCHAR(MAX) = NULL,
	@enReligionName NVARCHAR(MAX) = NULL,
	@by NVARCHAR(255) = NULL
)	
AS
BEGIN
	SET NOCOUNT ON
	
	SET @order = LTRIM(RTRIM(@order))
	SET @id = LTRIM(RTRIM(@id))
	SET @thReligionName = LTRIM(RTRIM(@thReligionName))
	SET @enReligionName = LTRIM(RTRIM(@enReligionName))
	SET @by = LTRIM(RTRIM(@by))
	
	DECLARE @action VARCHAR(10) = 'INSERT'
	DECLARE @table VARCHAR(50) = 'perReligion'
	DECLARE @i INT = 1
	DECLARE @delimiter CHAR(1) = ';'
	DECLARE @orderSlice VARCHAR(MAX) = NULL
	DECLARE @idSlice VARCHAR(MAX) = NULL
	DECLARE @thReligionNameSlice NVARCHAR(MAX) = NULL
	DECLARE @enReligionNameSlice NVARCHAR(MAX) = NULL
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
		
		SET @thReligionNameSlice = (SELECT stringSlice FROM fnc_perParseString(@thReligionName, @delimiter))
		SET @thReligionName = (SELECT string FROM fnc_perParseString(@thReligionName, @delimiter))
						
		SET @enReligionNameSlice = (SELECT stringSlice FROM fnc_perParseString(@enReligionName, @delimiter))
		SET @enReligionName = (SELECT string FROM fnc_perParseString(@enReligionName, @delimiter))
		
		IF (LEN(@orderSlice) > 0)
		BEGIN			
			SET @value = 'id=' + (CASE WHEN (@idSlice IS NOT NULL AND LEN(@idSlice) > 0 AND CHARINDEX(@idSlice, @strBlank) = 0) THEN ('"' + @idSlice + '"') ELSE 'NULL' END) + ', ' +
						 'thReligionName=' + (CASE WHEN (@thReligionNameSlice IS NOT NULL AND LEN(@thReligionNameSlice) > 0 AND CHARINDEX(@thReligionNameSlice, @strBlank) = 0) THEN ('"' + @thReligionNameSlice + '"') ELSE 'NULL' END) + ', ' +
						 'enReligionName=' + (CASE WHEN (@enReligionNameSlice IS NOT NULL AND LEN(@enReligionNameSlice) > 0 AND CHARINDEX(@enReligionNameSlice, @strBlank) = 0) THEN ('"' + @enReligionNameSlice + '"') ELSE 'NULL' END)
						 						 
			BEGIN TRY
				BEGIN TRAN	
					INSERT INTO perReligion
					(
						id,
						thReligionName,
						enReligionName,
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
						CASE WHEN (@thReligionNameSlice IS NOT NULL AND LEN(@thReligionNameSlice) > 0 AND CHARINDEX(@thReligionNameSlice, @strBlank) = 0) THEN @thReligionNameSlice ELSE NULL END,
						CASE WHEN (@enReligionNameSlice IS NOT NULL AND LEN(@enReligionNameSlice) > 0 AND CHARINDEX(@enReligionNameSlice, @strBlank) = 0) THEN @enReligionNameSlice ELSE NULL END,
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

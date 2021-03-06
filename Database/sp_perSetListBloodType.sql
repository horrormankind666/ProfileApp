USE [MUStudent]
GO
/****** Object:  StoredProcedure [dbo].[sp_perSetListBloodType]    Script Date: 03/27/2014 11:47:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๒/๑๑/๒๕๕๖>
-- Description	: <สำหรับบันทึกข้อมูลตาราง perBloodType ครั้งละหลายเรคคอร์ด>
--  1. order			เป็น VARCHAR	รับค่าลำดับของเรคคอร์ด
--  2. id				เป็น VARCHAR	รับค่ารหัสหมู่เลือด
--  3. thBloodTypeName	เป็น NVARCHAR	รับค่าชื่อหมู่เลือดภาษาไทย
--  4. enBloodTypeName	เป็น NVARCHAR	รับค่าชื่อหมู่เลือดภาษาอังกฤษ
--	5. by				เป็น NVARCHAR	รับค่าชื่อของผู้ที่กระทำกับฐานข้อมูล
-- =============================================
ALTER PROCEDURE [dbo].[sp_perSetListBloodType]
(
	@order VARCHAR(MAX) = NULL,
	@id VARCHAR(MAX) = NULL,
	@thBloodTypeName NVARCHAR(MAX) = NULL,
	@enBloodTypeName NVARCHAR(MAX) = NULL,
    @by NVARCHAR(255) = NULL
)	
AS
BEGIN
	SET NOCOUNT ON
		
	SET @order = LTRIM(RTRIM(@order))
	SET @id = LTRIM(RTRIM(@id))
	SET @thBloodTypeName = LTRIM(RTRIM(@thBloodTypeName))
	SET @enBloodTypeName = LTRIM(RTRIM(@enBloodTypeName))
	SET @by = LTRIM(RTRIM(@by))
			
	DECLARE @action VARCHAR(10) = 'INSERT'
	DECLARE @table VARCHAR(50) = 'perBloodType'
	DECLARE @i INT = 1
	DECLARE @delimiter CHAR(1) = ';'
	DECLARE @orderSlice VARCHAR(MAX) = NULL
	DECLARE @idSlice VARCHAR(MAX) = NULL
	DECLARE @thBloodTypeNameSlice NVARCHAR(MAX) = NULL
	DECLARE @enBloodTypeNameSlice NVARCHAR(MAX) = NULL	
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
		
		SET @thBloodTypeNameSlice = (SELECT stringSlice FROM fnc_perParseString(@thBloodTypeName, @delimiter))
		SET @thBloodTypeName = (SELECT string FROM fnc_perParseString(@thBloodTypeName, @delimiter))
						
		SET @enBloodTypeNameSlice = (SELECT stringSlice FROM fnc_perParseString(@enBloodTypeName, @delimiter))
		SET @enBloodTypeName = (SELECT string FROM fnc_perParseString(@enBloodTypeName, @delimiter))

		IF (LEN(@orderSlice) > 0)
		BEGIN			
			SET @value = 'id=' + (CASE WHEN (@idSlice IS NOT NULL AND LEN(@idSlice) > 0 AND CHARINDEX(@idSlice, @strBlank) = 0) THEN ('"' + @idSlice + '"') ELSE 'NULL' END) + ', ' +
						 'thBloodTypeName=' + (CASE WHEN (@thBloodTypeNameSlice IS NOT NULL AND LEN(@thBloodTypeNameSlice) > 0 AND CHARINDEX(@thBloodTypeNameSlice, @strBlank) = 0) THEN ('"' + @thBloodTypeNameSlice + '"') ELSE 'NULL' END) + ', ' +
						 'enBloodTypeName=' + (CASE WHEN (@enBloodTypeNameSlice IS NOT NULL AND LEN(@enBloodTypeNameSlice) > 0 AND CHARINDEX(@enBloodTypeNameSlice, @strBlank) = 0) THEN ('"' + @enBloodTypeNameSlice + '"') ELSE 'NULL' END)

			BEGIN TRY
				BEGIN TRAN	
					INSERT INTO perBloodType
					(
						id,
						thBloodTypeName,
						enBloodTypeName,
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
						CASE WHEN (@thBloodTypeNameSlice IS NOT NULL AND LEN(@thBloodTypeNameSlice) > 0 AND CHARINDEX(@thBloodTypeNameSlice, @strBlank) = 0) THEN @thBloodTypeNameSlice ELSE NULL END,
						CASE WHEN (@enBloodTypeNameSlice IS NOT NULL AND LEN(@enBloodTypeNameSlice) > 0 AND CHARINDEX(@enBloodTypeNameSlice, @strBlank) = 0) THEN @enBloodTypeNameSlice ELSE NULL END,
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

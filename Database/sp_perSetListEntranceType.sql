USE [MUStudent]
GO
/****** Object:  StoredProcedure [dbo].[sp_perSetListEntranceType]    Script Date: 03/27/2014 11:48:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๑/๑๒/๒๕๕๖>
-- Description	: <สำหรับบันทึกข้อมูลตาราง perEntranceType ครั้งละหลายเรคคอร์ด>
--  1. order				เป็น VARCHAR	รับค่าลำดับของเรคคอร์ด
--  2. id					เป็น VARCHAR	รับค่ารหัสระบบที่สอบเข้ามหาวิทยาลัย
--  3. thEntranceTypeName	เป็น NVARCHAR	รับค่าชื่อระบบที่สอบเข้ามหาวิทยาลัยภาษาไทย
--  4. enEntranceTypeName	เป็น NVARCHAR	รับค่าชื่อระบบที่สอบเข้ามหาวิทยาลัยภาษาอังกฤษ
--	5. by					เป็น NVARCHAR	รับค่าชื่อของผู้ที่กระทำกับฐานข้อมูล
-- =============================================
ALTER PROCEDURE [dbo].[sp_perSetListEntranceType]
(
	@order VARCHAR(MAX) = NULL,
	@id VARCHAR(MAX) = NULL,
	@thEntranceTypeName NVARCHAR(MAX) = NULL,
	@enEntranceTypeName NVARCHAR(MAX) = NULL,	
	@by NVARCHAR(255) = NULL
)	
AS
BEGIN
	SET NOCOUNT ON

	SET @order = LTRIM(RTRIM(@order))
	SET @id = LTRIM(RTRIM(@id))
	SET @thEntranceTypeName = LTRIM(RTRIM(@thEntranceTypeName))
	SET @enEntranceTypeName = LTRIM(RTRIM(@enEntranceTypeName))
	SET @by = LTRIM(RTRIM(@by))
			
	DECLARE @action VARCHAR(10) = 'INSERT'
	DECLARE @table VARCHAR(50) = 'perEntranceType'
	DECLARE @i INT = 1
	DECLARE @delimiter CHAR(1) = ';'
	DECLARE @orderSlice VARCHAR(MAX) = NULL
	DECLARE @idSlice VARCHAR(MAX) = NULL
	DECLARE @thEntranceTypeNameSlice NVARCHAR(MAX) = NULL
	DECLARE @enEntranceTypeNameSlice NVARCHAR(MAX) = NULL	
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
		
		SET @thEntranceTypeNameSlice = (SELECT stringSlice FROM fnc_perParseString(@thEntranceTypeName, @delimiter))
		SET @thEntranceTypeName = (SELECT string FROM fnc_perParseString(@thEntranceTypeName, @delimiter))
						
		SET @enEntranceTypeNameSlice = (SELECT stringSlice FROM fnc_perParseString(@enEntranceTypeName, @delimiter))
		SET @enEntranceTypeName = (SELECT string FROM fnc_perParseString(@enEntranceTypeName, @delimiter))

		IF (LEN(@orderSlice) > 0)
		BEGIN			
			SET @value = 'id=' + (CASE WHEN (@idSlice IS NOT NULL AND LEN(@idSlice) > 0 AND CHARINDEX(@idSlice, @strBlank) = 0) THEN ('"' + @idSlice + '"') ELSE 'NULL' END) + ', ' +
						 'thEntranceTypeName=' + (CASE WHEN (@thEntranceTypeNameSlice IS NOT NULL AND LEN(@thEntranceTypeNameSlice) > 0 AND CHARINDEX(@thEntranceTypeNameSlice, @strBlank) = 0) THEN ('"' + @thEntranceTypeNameSlice + '"') ELSE 'NULL' END) + ', ' +
						 'enEntranceTypeName=' + (CASE WHEN (@enEntranceTypeNameSlice IS NOT NULL AND LEN(@enEntranceTypeNameSlice) > 0 AND CHARINDEX(@enEntranceTypeNameSlice, @strBlank) = 0) THEN ('"' + @enEntranceTypeNameSlice + '"') ELSE 'NULL' END)

			BEGIN TRY
				BEGIN TRAN	
					INSERT INTO perEntranceType
					(
						id,
						thEntranceTypeName,
						enEntranceTypeName,
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
						CASE WHEN (@thEntranceTypeNameSlice IS NOT NULL AND LEN(@thEntranceTypeNameSlice) > 0 AND CHARINDEX(@thEntranceTypeNameSlice, @strBlank) = 0) THEN @thEntranceTypeNameSlice ELSE NULL END,
						CASE WHEN (@enEntranceTypeNameSlice IS NOT NULL AND LEN(@enEntranceTypeNameSlice) > 0 AND CHARINDEX(@enEntranceTypeNameSlice, @strBlank) = 0) THEN @enEntranceTypeNameSlice ELSE NULL END,
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

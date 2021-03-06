USE [MUStudent]
GO
/****** Object:  StoredProcedure [dbo].[sp_perSetListAddressType]    Script Date: 12/11/2013 11:07:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<ยุทธภูมิ ตวันนา>
-- Create date: <๑๓/๑๑/๒๕๕๖>
-- Description:	<สำหรับบันทึกข้อมูลตาราง perAddressType ครั้งละหลายเรคคอร์ด>
-- =============================================
ALTER PROCEDURE [dbo].[sp_perSetListAddressType] 
(
	@order VARCHAR(MAX) = NULL,
	@id VARCHAR(MAX) = NULL,
	@thAddressTypeName NVARCHAR(MAX) = NULL,
	@enAddressTypeName NVARCHAR(MAX) = NULL,
	@by NVARCHAR(255) = NULL
)	
AS
BEGIN
	SET NOCOUNT ON
	
	SET @order = LTRIM(RTRIM(@order))
	SET @id = LTRIM(RTRIM(@id))
	SET @thAddressTypeName = LTRIM(RTRIM(@thAddressTypeName))
	SET @enAddressTypeName = LTRIM(RTRIM(@enAddressTypeName))
	SET @by = LTRIM(RTRIM(@by))
			
	DECLARE @action VARCHAR(10) = 'INSERT'
	DECLARE @table VARCHAR(50) = 'perAddressType'
	DECLARE @i INT = 1
	DECLARE @delimiter CHAR(1) = ';'
	DECLARE @orderSlice VARCHAR(MAX) = NULL
	DECLARE @idSlice VARCHAR(MAX) = NULL
	DECLARE @thAddressTypeNameSlice NVARCHAR(MAX) = NULL
	DECLARE @enAddressTypeNameSlice NVARCHAR(MAX) = NULL	
	DECLARE @rowCount INT = 0
	DECLARE @value NVARCHAR(MAX) = NULL
	DECLARE	@strBlank VARCHAR(50) = '----------..........'
	DECLARE @ip VARCHAR(255) = dbo.fnc_perGetIP()

	WHILE (LEN(@order) > 0)
	BEGIN
		SET @orderSlice = (SELECT stringSlice FROM fnc_perParseString(@order, @delimiter))
		SET @order = (SELECT string FROM fnc_perParseString(@order, @delimiter))
		
		SET @idSlice = (SELECT stringSlice FROM fnc_perParseString(@id, @delimiter))
		SET @id = (SELECT string FROM fnc_perParseString(@id, @delimiter))
		
		SET @thAddressTypeNameSlice = (SELECT stringSlice FROM fnc_perParseString(@thAddressTypeName, @delimiter))
		SET @thAddressTypeName = (SELECT string FROM fnc_perParseString(@thAddressTypeName, @delimiter))
						
		SET @enAddressTypeNameSlice = (SELECT stringSlice FROM fnc_perParseString(@enAddressTypeName, @delimiter))
		SET @enAddressTypeName = (SELECT string FROM fnc_perParseString(@enAddressTypeName, @delimiter))

		IF (LEN(@orderSlice) > 0)
		BEGIN			
			SET @value = 'id=' + (CASE WHEN (@idSlice IS NOT NULL AND LEN(@idSlice) > 0 AND CHARINDEX(@idSlice, @strBlank) = 0) THEN ('"' + @idSlice + '"') ELSE 'NULL' END) + ', ' +
						 'thAddressTypeName=' + (CASE WHEN (@thAddressTypeNameSlice IS NOT NULL AND LEN(@thAddressTypeNameSlice) > 0 AND CHARINDEX(@thAddressTypeNameSlice, @strBlank) = 0) THEN ('"' + @thAddressTypeNameSlice + '"') ELSE 'NULL' END) + ', ' +
						 'enAddressTypeName=' + (CASE WHEN (@enAddressTypeNameSlice IS NOT NULL AND LEN(@enAddressTypeNameSlice) > 0 AND CHARINDEX(@enAddressTypeNameSlice, @strBlank) = 0) THEN ('"' + @enAddressTypeNameSlice + '"') ELSE 'NULL' END)

			BEGIN TRY
				BEGIN TRAN	
					INSERT INTO perAddressType
					(
						id,
						thAddressTypeName,
						enAddressTypeName,
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
						CASE WHEN (@thAddressTypeNameSlice IS NOT NULL AND LEN(@thAddressTypeNameSlice) > 0 AND CHARINDEX(@thAddressTypeNameSlice, @strBlank) = 0) THEN @thAddressTypeNameSlice ELSE NULL END,
						CASE WHEN (@enAddressTypeNameSlice IS NOT NULL AND LEN(@enAddressTypeNameSlice) > 0 AND CHARINDEX(@enAddressTypeNameSlice, @strBlank) = 0) THEN @enAddressTypeNameSlice ELSE NULL END,
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

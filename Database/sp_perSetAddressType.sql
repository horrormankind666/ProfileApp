USE [MUStudent]
GO
/****** Object:  StoredProcedure [dbo].[sp_perSetAddressType]    Script Date: 12/11/2013 10:01:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<ยุทธภูมิ ตวันนา>
-- Create date: <๑๓/๑๑/๒๕๕๖>
-- Description:	<สำหรับบันทึกข้อมูลตาราง perAddressType ครั้งละ ๑ เรคคอร์ด>
-- =============================================
ALTER PROCEDURE [dbo].[sp_perSetAddressType] 
(
	@action VARCHAR(10) = NULL,
	@id VARCHAR(MAX) = NULL,
	@thAddressTypeName NVARCHAR(MAX) = NULL,
	@enAddressTypeName NVARCHAR(MAX) = NULL,
	@by NVARCHAR(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	
	SET @action = LTRIM(RTRIM(@action))
	SET @id = LTRIM(RTRIM(@id))
	SET @thAddressTypeName = LTRIM(RTRIM(@thAddressTypeName))
	SET @enAddressTypeName = LTRIM(RTRIM(@enAddressTypeName))
	SET @by = LTRIM(RTRIM(@by))
	
	DECLARE @table VARCHAR(50) = 'perAddressType'
	DECLARE @rowCount INT = 0
	DECLARE @rowCountUpdate INT = 0
	DECLARE @value NVARCHAR(MAX) = NULL
	DECLARE	@strBlank VARCHAR(50) = '----------..........'
	DECLARE @ip VARCHAR(255) = dbo.fnc_perGetIP()
	
	SET @action = UPPER(@action)
	
	IF (@action = 'INSERT' OR @action = 'UPDATE' OR @action = 'DELETE')
	BEGIN
		SET @value = 'id=' + (CASE WHEN (@id IS NOT NULL AND LEN(@id) > 0 AND CHARINDEX(@id, @strBlank) = 0) THEN ('"' + @id + '"') ELSE 'NULL' END) + ', ' +
					 'thAddressTypeName=' + (CASE WHEN (@thAddressTypeName IS NOT NULL AND LEN(@thAddressTypeName) > 0 AND CHARINDEX(@thAddressTypeName, @strBlank) = 0) THEN ('"' + @thAddressTypeName + '"') ELSE 'NULL' END) + ', ' +
					 'enAddressTypeName=' + (CASE WHEN (@enAddressTypeName IS NOT NULL AND LEN(@enAddressTypeName) > 0 AND CHARINDEX(@enAddressTypeName, @strBlank) = 0) THEN ('"' + @enAddressTypeName + '"') ELSE 'NULL' END)
					 
		BEGIN TRY
			BEGIN TRAN
				IF (@action = 'INSERT')
				BEGIN
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
						CASE WHEN (@id IS NOT NULL AND LEN(@id) > 0 AND CHARINDEX(@id, @strBlank) = 0) THEN @id ELSE NULL END,
						CASE WHEN (@thAddressTypeName IS NOT NULL AND LEN(@thAddressTypeName) > 0 AND CHARINDEX(@thAddressTypeName, @strBlank) = 0) THEN @thAddressTypeName ELSE NULL END,
						CASE WHEN (@enAddressTypeName IS NOT NULL AND LEN(@enAddressTypeName) > 0 AND CHARINDEX(@enAddressTypeName, @strBlank) = 0) THEN @enAddressTypeName ELSE NULL END,
						GETDATE(),
						CASE WHEN (@by IS NOT NULL AND LEN(@by) > 0 AND CHARINDEX(@by, @strBlank) = 0) THEN @by ELSE NULL END,
						@ip,
						NULL,
						NULL,
						NULL
					)		
					
					SET @rowCount = @rowCount + 1
				END
				
				IF (@action = 'UPDATE' OR @action = 'DELETE')					
				BEGIN
					IF (@id IS NOT NULL AND LEN(@id) > 0 AND CHARINDEX(@id, @strBlank) = 0)
					BEGIN
						SET @rowCountUpdate = (SELECT COUNT(id) FROM perAddressType WHERE id = @id)
					
						IF (@rowCountUpdate > 0)
						BEGIN
							IF (@action = 'UPDATE')
							BEGIN
								UPDATE perAddressType SET
									thAddressTypeName = CASE WHEN (@thAddressTypeName IS NOT NULL AND LEN(@thAddressTypeName) > 0 AND CHARINDEX(@thAddressTypeName, @strBlank) = 0) THEN @thAddressTypeName ELSE (CASE WHEN (@thAddressTypeName IS NOT NULL AND (LEN(@thAddressTypeName) = 0 OR CHARINDEX(@thAddressTypeName, @strBlank) > 0)) THEN NULL ELSE thAddressTypeName END) END,
									enAddressTypeName = CASE WHEN (@enAddressTypeName IS NOT NULL AND LEN(@enAddressTypeName) > 0 AND CHARINDEX(@enAddressTypeName, @strBlank) = 0) THEN @enAddressTypeName ELSE (CASE WHEN (@enAddressTypeName IS NOT NULL AND (LEN(@enAddressTypeName) = 0 OR CHARINDEX(@enAddressTypeName, @strBlank) > 0)) THEN NULL ELSE enAddressTypeName END) END,
									modifyDate = GETDATE(),
									modifyBy = CASE WHEN (@by IS NOT NULL AND LEN(@by) > 0 AND CHARINDEX(@by, @strBlank) = 0) THEN @by ELSE (CASE WHEN (@by IS NOT NULL AND (LEN(@by) = 0 OR CHARINDEX(@by, @strBlank) > 0)) THEN NULL ELSE modifyBy END) END,
									modifyIp = @ip							
								WHERE id = @id	
							END								
							
							IF (@action = 'DELETE')
							BEGIN
								DELETE FROM perAddressType WHERE id = @id
							END
							
							SET @rowCount = @rowCount + 1						
						END							
					END				
				END
			COMMIT TRAN									
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
	
	SELECT @rowCount		
END
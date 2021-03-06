USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_perSetBloodType]    Script Date: 11/16/2015 16:21:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๒/๑๑/๒๕๕๖>
-- Description	: <สำหรับบันทึกข้อมูลตาราง perBloodType ครั้งละ ๑ เรคคอร์ด>
--  1. action			เป็น VARCHAR	รับค่าการกระทำกับฐานข้อมูล
--  2. id				เป็น VARCHAR	รับค่ารหัสหมู่เลือด
--  3. thBloodTypeName	เป็น NVARCHAR	รับค่าชื่อหมู่เลือดภาษาไทย
--  4. enBloodTypeName	เป็น NVARCHAR	รับค่าชื่อหมู่เลือดภาษาอังกฤษ
--	5. cancel			เป็น VARCHAR	รับค่าสถานะการยกเลิก
--	6. by				เป็น NVARCHAR	รับค่าชื่อของผู้ที่กระทำกับฐานข้อมูล
-- =============================================
ALTER PROCEDURE [dbo].[sp_perSetBloodType]
(
	@action VARCHAR(10) = NULL,
	@id VARCHAR(2) = NULL,
    @thBloodTypeName NVARCHAR(255) = NULL,
    @enBloodTypeName NVARCHAR(255) = NULL,
    @cancel VARCHAR(1) = NULL,
    @by NVARCHAR(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON

	SET @action = LTRIM(RTRIM(@action))
	SET @id = LTRIM(RTRIM(@id))
	SET @thBloodTypeName = LTRIM(RTRIM(@thBloodTypeName))
	SET @enBloodTypeName = LTRIM(RTRIM(@enBloodTypeName))
	SET @cancel = LTRIM(RTRIM(@cancel))
	SET @by = LTRIM(RTRIM(@by))
	
	DECLARE @table VARCHAR(50) = 'perBloodType'
	DECLARE @rowCount INT = 0
	DECLARE @rowCountUpdate INT = 0
	DECLARE @value NVARCHAR(MAX) = NULL
	DECLARE	@strBlank VARCHAR(50) = '----------**********.........0.0000000000000000000'
	DECLARE @ip VARCHAR(255) = dbo.fnc_perGetIP()
	
	SET @action = UPPER(@action)
	
	IF (@action = 'INSERT' OR @action = 'UPDATE' OR @action = 'DELETE')
	BEGIN
		SET @value = 'id=' + (CASE WHEN (@id IS NOT NULL AND LEN(@id) > 0 AND CHARINDEX(@id, @strBlank) = 0) THEN ('"' + @id + '"') ELSE 'NULL' END) + ', ' +
					 'thBloodTypeName=' + (CASE WHEN (@thBloodTypeName IS NOT NULL AND LEN(@thBloodTypeName) > 0 AND CHARINDEX(@thBloodTypeName, @strBlank) = 0) THEN ('"' + @thBloodTypeName + '"') ELSE 'NULL' END) + ', ' +
					 'enBloodTypeName=' + (CASE WHEN (@enBloodTypeName IS NOT NULL AND LEN(@enBloodTypeName) > 0 AND CHARINDEX(@enBloodTypeName, @strBlank) = 0) THEN ('"' + @enBloodTypeName + '"') ELSE 'NULL' END) + ', ' +
					 'cancel=' + (CASE WHEN (@cancel IS NOT NULL AND LEN(@cancel) > 0 AND CHARINDEX(@cancel, @strBlank) = 0) THEN ('"' + @cancel + '"') ELSE 'NULL' END)

		BEGIN TRY
			BEGIN TRAN
				IF (@action = 'INSERT')
				BEGIN
 					INSERT INTO perBloodType
 					(
						id,
						thBloodTypeName,
						enBloodTypeName,
						cancel,
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
						CASE WHEN (@thBloodTypeName IS NOT NULL AND LEN(@thBloodTypeName) > 0 AND CHARINDEX(@thBloodTypeName, @strBlank) = 0) THEN @thBloodTypeName ELSE NULL END,
						CASE WHEN (@enBloodTypeName IS NOT NULL AND LEN(@enBloodTypeName) > 0 AND CHARINDEX(@enBloodTypeName, @strBlank) = 0) THEN @enBloodTypeName ELSE NULL END,
						CASE WHEN (@cancel IS NOT NULL AND LEN(@cancel) > 0 AND CHARINDEX(@cancel, @strBlank) = 0) THEN @cancel ELSE NULL END,
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
						SET @rowCountUpdate = (SELECT COUNT(id) FROM perBloodType WHERE id = @id)
					
						IF (@rowCountUpdate > 0)
						BEGIN
							IF (@action = 'UPDATE')
							BEGIN
								UPDATE perBloodType SET
									thBloodTypeName = CASE WHEN (@thBloodTypeName IS NOT NULL AND LEN(@thBloodTypeName) > 0 AND CHARINDEX(@thBloodTypeName, @strBlank) = 0) THEN @thBloodTypeName ELSE (CASE WHEN (@thBloodTypeName IS NOT NULL AND (LEN(@thBloodTypeName) = 0 OR CHARINDEX(@thBloodTypeName, @strBlank) > 0)) THEN NULL ELSE thBloodTypeName END) END,
									enBloodTypeName = CASE WHEN (@enBloodTypeName IS NOT NULL AND LEN(@enBloodTypeName) > 0 AND CHARINDEX(@enBloodTypeName, @strBlank) = 0) THEN @enBloodTypeName ELSE (CASE WHEN (@enBloodTypeName IS NOT NULL AND (LEN(@enBloodTypeName) = 0 OR CHARINDEX(@enBloodTypeName, @strBlank) > 0)) THEN NULL ELSE enBloodTypeName END) END,
									cancel = CASE WHEN (@cancel IS NOT NULL AND LEN(@cancel) > 0 AND CHARINDEX(@cancel, @strBlank) = 0) THEN @cancel ELSE (CASE WHEN (@cancel IS NOT NULL AND (LEN(@cancel) = 0 OR CHARINDEX(@cancel, @strBlank) > 0)) THEN NULL ELSE cancel END) END,
									modifyDate = GETDATE(),
									modifyBy = CASE WHEN (@by IS NOT NULL AND LEN(@by) > 0 AND CHARINDEX(@by, @strBlank) = 0) THEN @by ELSE (CASE WHEN (@by IS NOT NULL AND (LEN(@by) = 0 OR CHARINDEX(@by, @strBlank) > 0)) THEN NULL ELSE modifyBy END) END,
									modifyIp = @ip
								WHERE id = @id	
							END
							
							IF (@action = 'DELETE')								
							BEGIN
								DELETE FROM perBloodType WHERE id = @id
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
				@ip
			)			
		END CATCH	
	END
	
	SELECT @rowCount	
END
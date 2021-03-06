USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_perSetRelationship]    Script Date: 11/16/2015 16:41:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๑/๑๑/๒๕๕๖>
-- Description	: <สำหรับบันทึกข้อมูลตาราง perRelationship ครั้งละ ๑ เรคคอร์ด>
--  1. action				เป็น VARCHAR	รับค่าการกระทำกับฐานข้อมูล
--  2. id 					เป็น VARCHAR	รับค่ารหัสความสัมพันธ์ในครอบครัว
--  3. relationshipNameTH	เป็น NVARCHAR	รับค่าชื่อความสัมพันธ์ในครอบครัวภาษาไทย
--  4. relationshipNameEN	เป็น NVARCHAR	รับค่าชื่อความสัมพันธ์ในครอบครัวภาษาอังกฤษ
--  5. gender				เป็น VARCHAR	รับค่ารหัสเพศ
--  6. cancelledStatus		เป็น VARCHAR	รับค่าสถานะการยกเลิก
--  7. by					เป็น NVARCHAR	รับค่าชื่อของผู้ที่กระทำกับฐานข้อมูล
--	8. ip					เป็น VARCHAR	รับค่าหมายเลขไอพีของผู้ที่กระทำกับฐานข้อมูล
-- =============================================
ALTER PROCEDURE [dbo].[sp_perSetRelationship]
(
	@action VARCHAR(10) = NULL,
	@id VARCHAR(2) = NULL,
	@relationshipNameTH NVARCHAR(255) = NULL,
	@relationshipNameEN NVARCHAR(255) = NULL,
	@gender VARCHAR(2) = NULL,
	@cancelledStatus VARCHAR(1) = NULL,
    @by NVARCHAR(255) = NULL,
    @ip VARCHAR(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON		
	
	SET @action = LTRIM(RTRIM(@action))
	SET @id = LTRIM(RTRIM(@id))
	SET @relationshipNameTH = LTRIM(RTRIM(@relationshipNameTH))
	SET @relationshipNameEN = LTRIM(RTRIM(@relationshipNameEN))
	SET @gender = LTRIM(RTRIM(@gender))
	SET @cancelledStatus = LTRIM(RTRIM(@cancelledStatus))
	SET @by = LTRIM(RTRIM(@by))
	SET @ip = LTRIM(RTRIM(@ip))
	
	DECLARE @table VARCHAR(50) = 'perRelationship'
	DECLARE @rowCount INT = 0
	DECLARE @rowCountUpdate INT = 0
	DECLARE @value NVARCHAR(MAX) = NULL
	DECLARE	@strBlank VARCHAR(50) = '----------**********.........0.0000000000000000000'
	
	SET @action = UPPER(@action)

	IF (@action = 'INSERT' OR @action = 'UPDATE' OR @action = 'DELETE')
	BEGIN
		SET @value = 'id=' + (CASE WHEN (@id IS NOT NULL AND LEN(@id) > 0 AND CHARINDEX(@id, @strBlank) = 0) THEN ('"' + @id + '"') ELSE 'NULL' END) + ', ' +
					 'relationshipNameTH=' + (CASE WHEN (@relationshipNameTH IS NOT NULL AND LEN(@relationshipNameTH) > 0 AND CHARINDEX(@relationshipNameTH, @strBlank) = 0) THEN ('"' + @relationshipNameTH + '"') ELSE 'NULL' END) + ', ' +
					 'relationshipNameEN=' + (CASE WHEN (@relationshipNameEN IS NOT NULL AND LEN(@relationshipNameEN) > 0 AND CHARINDEX(@relationshipNameEN, @strBlank) = 0) THEN ('"' + @relationshipNameEN + '"') ELSE 'NULL' END) + ', ' +
					 'perGenderId=' + (CASE WHEN (@gender IS NOT NULL AND LEN(@gender) > 0 AND CHARINDEX(@gender, @strBlank) = 0) THEN ('"' + @gender + '"') ELSE 'NULL' END) + ', ' +
					 'cancelledStatus=' + (CASE WHEN (@cancelledStatus IS NOT NULL AND LEN(@cancelledStatus) > 0 AND CHARINDEX(@cancelledStatus, @strBlank) = 0) THEN ('"' + @cancelledStatus + '"') ELSE 'NULL' END)

		BEGIN TRY
			BEGIN TRAN
				IF (@action = 'INSERT')
				BEGIN
 					INSERT INTO perRelationship
 					(
						id,
						relationshipNameTH,
						relationshipNameEN,
						perGenderId,
						cancelledStatus,
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
						CASE WHEN (@relationshipNameTH IS NOT NULL AND LEN(@relationshipNameTH) > 0 AND CHARINDEX(@relationshipNameTH, @strBlank) = 0) THEN @relationshipNameTH ELSE NULL END,
						CASE WHEN (@relationshipNameEN IS NOT NULL AND LEN(@relationshipNameEN) > 0 AND CHARINDEX(@relationshipNameEN, @strBlank) = 0) THEN @relationshipNameEN ELSE NULL END,
						CASE WHEN (@gender IS NOT NULL AND LEN(@gender) > 0 AND CHARINDEX(@gender, @strBlank) = 0) THEN @gender ELSE NULL END,
						CASE WHEN (@cancelledStatus IS NOT NULL AND LEN(@cancelledStatus) > 0 AND CHARINDEX(@cancelledStatus, @strBlank) = 0) THEN @cancelledStatus ELSE NULL END,
						GETDATE(),
						CASE WHEN (@by IS NOT NULL AND LEN(@by) > 0 AND CHARINDEX(@by, @strBlank) = 0) THEN @by ELSE NULL END,
						CASE WHEN (@ip IS NOT NULL AND LEN(@ip) > 0 AND CHARINDEX(@ip, @strBlank) = 0) THEN @ip ELSE NULL END,
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
						SET @rowCountUpdate = (SELECT COUNT(id) FROM perRelationship WHERE id = @id)
						
						IF (@rowCountUpdate > 0)
						BEGIN
							IF (@action = 'UPDATE')
							BEGIN
								UPDATE perRelationship SET
									relationshipNameTH	= CASE WHEN (@relationshipNameTH IS NOT NULL AND LEN(@relationshipNameTH) > 0 AND CHARINDEX(@relationshipNameTH, @strBlank) = 0) THEN @relationshipNameTH ELSE (CASE WHEN (@relationshipNameTH IS NOT NULL AND (LEN(@relationshipNameTH) = 0 OR CHARINDEX(@relationshipNameTH, @strBlank) > 0)) THEN NULL ELSE relationshipNameTH END) END,
									relationshipNameEN	= CASE WHEN (@relationshipNameEN IS NOT NULL AND LEN(@relationshipNameEN) > 0 AND CHARINDEX(@relationshipNameEN, @strBlank) = 0) THEN @relationshipNameEN ELSE (CASE WHEN (@relationshipNameEN IS NOT NULL AND (LEN(@relationshipNameEN) = 0 OR CHARINDEX(@relationshipNameEN, @strBlank) > 0)) THEN NULL ELSE relationshipNameEN END) END,
									perGenderId			= CASE WHEN (@gender IS NOT NULL AND LEN(@gender) > 0 AND CHARINDEX(@gender, @strBlank) = 0) THEN @gender ELSE (CASE WHEN (@gender IS NOT NULL AND (LEN(@gender) = 0 OR CHARINDEX(@gender, @strBlank) > 0)) THEN NULL ELSE perGenderId END) END,
									cancelledStatus		= CASE WHEN (@cancelledStatus IS NOT NULL AND LEN(@cancelledStatus) > 0 AND CHARINDEX(@cancelledStatus, @strBlank) = 0) THEN @cancelledStatus ELSE (CASE WHEN (@cancelledStatus IS NOT NULL AND (LEN(@cancelledStatus) = 0 OR CHARINDEX(@cancelledStatus, @strBlank) > 0)) THEN NULL ELSE cancelledStatus END) END,
									modifyDate			= GETDATE(),
									modifyBy			= CASE WHEN (@by IS NOT NULL AND LEN(@by) > 0 AND CHARINDEX(@by, @strBlank) = 0) THEN @by ELSE (CASE WHEN (@by IS NOT NULL AND (LEN(@by) = 0 OR CHARINDEX(@by, @strBlank) > 0)) THEN NULL ELSE modifyBy END) END,
									modifyIp			= CASE WHEN (@ip IS NOT NULL AND LEN(@ip) > 0 AND CHARINDEX(@ip, @strBlank) = 0) THEN @ip ELSE (CASE WHEN (@ip IS NOT NULL AND (LEN(@ip) = 0 OR CHARINDEX(@ip, @strBlank) > 0)) THEN NULL ELSE modifyIp END) END
								WHERE id = @id	
							END
							
							IF (@action = 'DELETE')								
							BEGIN
								DELETE FROM perRelationship WHERE id = @id
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
				CASE WHEN (@ip IS NOT NULL AND LEN(@ip) > 0 AND CHARINDEX(@ip, @strBlank) = 0) THEN @ip ELSE NULL END
			)
		END CATCH	
	END
	
	SELECT @rowCount	
END

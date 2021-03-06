USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_perSetParent]    Script Date: 11/16/2015 16:38:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๐๖/๑๒/๒๕๕๖>
-- Description	: <สำหรับบันทึกข้อมูลตาราง perParent ครั้งละ ๑ เรคคอร์ด>
--  1. action			เป็น VARCHAR	รับค่าการกระทำกับฐานข้อมูล
--  2. personId 		เป็น VARCHAR	รับค่ารหัสบุคคล
--  3. personIdFather	เป็น VARCHAR	รับค่ารหัสบุคคลของบิดา
--  4. personIdMother	เป็น VARCHAR	รับค่ารหัสบุคคลของมารดา
--  5. personIdParent	เป็น VARCHAR	รับค่ารหัสบุคคลของผู้ปกครอง
--  6. relationship		เป็น VARCHAR	รับค่ารหัสความสัมพันธ์ในครอบครัวของผู้ปกครอง
--  7. by				เป็น NVARCHAR	รับค่าชื่อของผู้ที่กระทำกับฐานข้อมูล
--  8. ip				เป็น VARCHAR	รับค่าหมายเลขไอพีของผู้ที่กระทำกับฐานข้อมูล
-- =============================================
ALTER PROCEDURE [dbo].[sp_perSetParent] 
(
	@action VARCHAR(10) = NULL,
	@personId VARCHAR(10) = NULL,
	@personIdFather VARCHAR(10) = NULL,
	@personIdMother VARCHAR(10) = NULL,
	@personIdParent VARCHAR(10) = NULL,
	@relationship VARCHAR(2) = NULL,
	@by NVARCHAR(255) = NULL,
	@ip VARCHAR(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	
	SET @action = LTRIM(RTRIM(@action))
	SET @personId = LTRIM(RTRIM(@personId))
	SET @personIdFather = LTRIM(RTRIM(@personIdFather))
	SET @personIdMother = LTRIM(RTRIM(@personIdMother))
	SET @personIdParent = LTRIM(RTRIM(@personIdParent))
	SET @relationship = LTRIM(RTRIM(@relationship))
	SET @by = LTRIM(RTRIM(@by))
	SET @ip = LTRIM(RTRIM(@ip))
	
	DECLARE @table VARCHAR(50) = 'perParent'
	DECLARE @rowCount INT = 0
	DECLARE @rowCountUpdate INT = 0
	DECLARE @value NVARCHAR(MAX) = NULL
	DECLARE	@strBlank VARCHAR(50) = '----------**********.........0.0000000000000000000'
	
	SET @action = UPPER(@action)	
	
	IF (@action = 'INSERT' OR @action = 'UPDATE' OR @action = 'DELETE')
	BEGIN
		SET @value = 'perPersonId=' + (CASE WHEN (@personId IS NOT NULL AND LEN(@personId) > 0 AND CHARINDEX(@personId, @strBlank) = 0) THEN ('"' + @personId + '"') ELSE 'NULL' END) + ', ' +
					 'perPersonIdFather=' + (CASE WHEN (@personIdFather IS NOT NULL AND LEN(@personIdFather) > 0 AND CHARINDEX(@personIdFather, @strBlank) = 0) THEN ('"' + @personIdFather + '"') ELSE 'NULL' END) + ', ' +
					 'perPersonIdMother=' + (CASE WHEN (@personIdMother IS NOT NULL AND LEN(@personIdMother) > 0 AND CHARINDEX(@personIdMother, @strBlank) = 0) THEN ('"' + @personIdMother + '"') ELSE 'NULL' END) + ', ' +
					 'perPersonIdParent=' + (CASE WHEN (@personIdParent IS NOT NULL AND LEN(@personIdParent) > 0 AND CHARINDEX(@personIdParent, @strBlank) = 0) THEN ('"' + @personIdParent + '"') ELSE 'NULL' END) + ', ' +
					 'perRelationshipId=' + (CASE WHEN (@relationship IS NOT NULL AND LEN(@relationship) > 0 AND CHARINDEX(@relationship, @strBlank) = 0) THEN ('"' + @relationship + '"') ELSE 'NULL' END)
		
		BEGIN TRY
			BEGIN TRAN
				IF (@action = 'INSERT')
				BEGIN
 					INSERT INTO perParent
 					(
						perPersonId,
						perPersonIdFather,
						perPersonIdMother,
						perPersonIdParent,
						perRelationshipId,
						createDate,
						createBy,
						createIp,
						modifyDate,
						modifyBy,
						modifyIp
					)
					VALUES
					(
						CASE WHEN (@personId IS NOT NULL AND LEN(@personId) > 0 AND CHARINDEX(@personId, @strBlank) = 0) THEN @personId ELSE NULL END,
						CASE WHEN (@personIdFather IS NOT NULL AND LEN(@personIdFather) > 0 AND CHARINDEX(@personIdFather, @strBlank) = 0) THEN @personIdFather ELSE NULL END,
						CASE WHEN (@personIdMother IS NOT NULL AND LEN(@personIdMother) > 0 AND CHARINDEX(@personIdMother, @strBlank) = 0) THEN @personIdMother ELSE NULL END,
						CASE WHEN (@personIdParent IS NOT NULL AND LEN(@personIdParent) > 0 AND CHARINDEX(@personIdParent, @strBlank) = 0) THEN @personIdParent ELSE NULL END,
						CASE WHEN (@relationship IS NOT NULL AND LEN(@relationship) > 0 AND CHARINDEX(@relationship, @strBlank) = 0) THEN @relationship ELSE NULL END,
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
					IF (@personId IS NOT NULL AND LEN(@personId) > 0 AND CHARINDEX(@personId, @strBlank) = 0)
					BEGIN
						SET @rowCountUpdate = (SELECT COUNT(perPersonId) FROM perParent WHERE perPersonId = @personId)
						
						IF (@rowCountUpdate > 0)
						BEGIN
							IF (@action = 'UPDATE')
							BEGIN							
								UPDATE perParent SET
									perPersonIdFather	= CASE WHEN (@personIdFather IS NOT NULL AND LEN(@personIdFather) > 0 AND CHARINDEX(@personIdFather, @strBlank) = 0) THEN @personIdFather ELSE (CASE WHEN (@personIdFather IS NOT NULL AND (LEN(@personIdFather) = 0 OR CHARINDEX(@personIdFather, @strBlank) > 0)) THEN NULL ELSE perPersonIdFather END) END,
									perPersonIdMother	= CASE WHEN (@personIdMother IS NOT NULL AND LEN(@personIdMother) > 0 AND CHARINDEX(@personIdMother, @strBlank) = 0) THEN @personIdMother ELSE (CASE WHEN (@personIdMother IS NOT NULL AND (LEN(@personIdMother) = 0 OR CHARINDEX(@personIdMother, @strBlank) > 0)) THEN NULL ELSE perPersonIdMother END) END,
									perPersonIdParent	= CASE WHEN (@personIdParent IS NOT NULL AND LEN(@personIdParent) > 0 AND CHARINDEX(@personIdParent, @strBlank) = 0) THEN @personIdParent ELSE (CASE WHEN (@personIdParent IS NOT NULL AND (LEN(@personIdParent) = 0 OR CHARINDEX(@personIdParent, @strBlank) > 0)) THEN NULL ELSE perPersonIdParent END) END,
									perRelationshipId	= CASE WHEN (@relationship IS NOT NULL AND LEN(@relationship) > 0 AND CHARINDEX(@relationship, @strBlank) = 0) THEN @relationship ELSE (CASE WHEN (@relationship IS NOT NULL AND (LEN(@relationship) = 0 OR CHARINDEX(@relationship, @strBlank) > 0)) THEN NULL ELSE perRelationshipId END) END,
									modifyDate			= GETDATE(),
									modifyBy			= CASE WHEN (@by IS NOT NULL AND LEN(@by) > 0 AND CHARINDEX(@by, @strBlank) = 0) THEN @by ELSE (CASE WHEN (@by IS NOT NULL AND (LEN(@by) = 0 OR CHARINDEX(@by, @strBlank) > 0)) THEN NULL ELSE modifyBy END) END,
									modifyIp			= CASE WHEN (@ip IS NOT NULL AND LEN(@ip) > 0 AND CHARINDEX(@ip, @strBlank) = 0) THEN @ip ELSE (CASE WHEN (@ip IS NOT NULL AND (LEN(@ip) = 0 OR CHARINDEX(@ip, @strBlank) > 0)) THEN NULL ELSE modifyIp END) END
								WHERE perPersonId = @personId
							END
							
							IF (@action = 'DELETE')
							BEGIN
								DELETE FROM perParent WHERE perPersonId = @personId
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
	
	EXEC Infinity..sp_stdTransferStudentRecordsToMUStudent
		@personId = @personId
	
END
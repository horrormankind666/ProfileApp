USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_perSetEducationalBackground]    Script Date: 11/16/2015 16:27:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๐๖/๑๒/๒๕๕๖>
-- Description	: <สำหรับบันทึกข้อมูลตาราง perEducationalBackground ครั้งละ ๑ เรคคอร์ด>
--  1. action						เป็น VARCHAR	รับค่าการกระทำกับฐานข้อมูล
--  2. id							เป็น VARCHAR	รับค่าวฺุฒิการศึกษา
--  3. educationalBackgroundNameTH	เป็น NVARCHAR	รับค่าชื่อวุฒิการศึกษาภาษาไทย
--  4. educationalBackgroundNameEN	เป็น NVARCHAR	รับค่าชื่อวุฒิการศึกษาภาษาอังกฤษ
--  5. educationalLevel				เป็น VARCHAR	รับค่ารหัสระดับการศึกษา
--	6. cancelledStatus				เป็น VARCHAR	รับค่าสถานะการยกเลิก
--	7. by							เป็น NVARCHAR	รับค่าชื่อของผู้ที่กระทำกับฐานข้อมูล
--	8. ip							เป็น VARCHAR	รับค่าหมายเลขไอพีของผู้ที่กระทำกับฐานข้อมูล
-- =============================================
ALTER PROCEDURE [dbo].[sp_perSetEducationalBackground] 
(
	@action VARCHAR(10) = NULL,
	@id VARCHAR(2) = NULL,
	@educationalBackgroundNameTH NVARCHAR(255) = NULL,
	@educationalBackgroundNameEN NVARCHAR(255) = NULL,
	@educationalLevel VARCHAR(2) = NULL,
	@cancelledStatus VARCHAR(1) = NULL,
	@by NVARCHAR(255) = NULL,
	@ip VARCHAR(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	
	SET @action = LTRIM(RTRIM(@action))
	SET @id = LTRIM(RTRIM(@id))
	SET @educationalBackgroundNameTH = LTRIM(RTRIM(@educationalBackgroundNameTH))
	SET @educationalBackgroundNameEN = LTRIM(RTRIM(@educationalBackgroundNameEN))
	SET @educationalLevel = LTRIM(RTRIM(@educationalLevel))
	SET @cancelledStatus = LTRIM(RTRIM(@cancelledStatus))
	SET @by = LTRIM(RTRIM(@by))
	SET @ip = LTRIM(RTRIM(@ip))
	
	DECLARE @table VARCHAR(50) = 'perEducationalBackground'
	DECLARE @rowCount INT = 0
	DECLARE @rowCountUpdate INT = 0
	DECLARE @value NVARCHAR(MAX) = NULL
	DECLARE	@strBlank VARCHAR(50) = '----------**********.........0.0000000000000000000'
	
	SET @action = UPPER(@action)
	
	IF (@action = 'INSERT' OR @action = 'UPDATE' OR @action = 'DELETE')
	BEGIN
		SET @value = 'id=' + (CASE WHEN (@id IS NOT NULL AND LEN(@id) > 0 AND CHARINDEX(@id, @strBlank) = 0) THEN ('"' + @id + '"') ELSE 'NULL' END) + ', ' +
					 'thEducationalBackgroundName=' + (CASE WHEN (@educationalBackgroundNameTH IS NOT NULL AND LEN(@educationalBackgroundNameTH) > 0 AND CHARINDEX(@educationalBackgroundNameTH, @strBlank) = 0) THEN ('"' + @educationalBackgroundNameTH + '"') ELSE 'NULL' END) + ', ' +
					 'enEducationalBackgroundName=' + (CASE WHEN (@educationalBackgroundNameEN IS NOT NULL AND LEN(@educationalBackgroundNameEN) > 0 AND CHARINDEX(@educationalBackgroundNameEN, @strBlank) = 0) THEN ('"' + @educationalBackgroundNameEN + '"') ELSE 'NULL' END) + ', ' +
					 'perEducationalLevelId=' + (CASE WHEN (@educationalLevel IS NOT NULL AND LEN(@educationalLevel) > 0 AND CHARINDEX(@educationalLevel, @strBlank) = 0) THEN ('"' + @educationalLevel + '"') ELSE 'NULL' END) + ', ' +
					 'cancel=' + (CASE WHEN (@cancelledStatus IS NOT NULL AND LEN(@cancelledStatus) > 0 AND CHARINDEX(@cancelledStatus, @strBlank) = 0) THEN ('"' + @cancelledStatus + '"') ELSE 'NULL' END)
					 
		BEGIN TRY
			BEGIN TRAN
				IF (@action = 'INSERT')
				BEGIN
 					INSERT INTO perEducationalBackground
 					(
						id,
						thEducationalBackgroundName,
						enEducationalBackgroundName,
						perEducationalLevelId,
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
						CASE WHEN (@educationalBackgroundNameTH IS NOT NULL AND LEN(@educationalBackgroundNameTH) > 0 AND CHARINDEX(@educationalBackgroundNameTH, @strBlank) = 0) THEN @educationalBackgroundNameTH ELSE NULL END,
						CASE WHEN (@educationalBackgroundNameEN IS NOT NULL AND LEN(@educationalBackgroundNameEN) > 0 AND CHARINDEX(@educationalBackgroundNameEN, @strBlank) = 0) THEN @educationalBackgroundNameEN ELSE NULL END,
						CASE WHEN (@educationalLevel IS NOT NULL AND LEN(@educationalLevel) > 0 AND CHARINDEX(@educationalLevel, @strBlank) = 0) THEN @educationalLevel ELSE NULL END,
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
						SET @rowCountUpdate = (SELECT COUNT(id) FROM perEducationalBackground WHERE id = @id)
					
						IF (@rowCountUpdate > 0)
						BEGIN
							IF (@action = 'UPDATE')
							BEGIN
								UPDATE perEducationalBackground SET
									thEducationalBackgroundName	= CASE WHEN (@educationalBackgroundNameTH IS NOT NULL AND LEN(@educationalBackgroundNameTH) > 0 AND CHARINDEX(@educationalBackgroundNameTH, @strBlank) = 0) THEN @educationalBackgroundNameTH ELSE (CASE WHEN (@educationalBackgroundNameTH IS NOT NULL AND (LEN(@educationalBackgroundNameTH) = 0 OR CHARINDEX(@educationalBackgroundNameTH, @strBlank) > 0)) THEN NULL ELSE thEducationalBackgroundName END) END,
									enEducationalBackgroundName = CASE WHEN (@educationalBackgroundNameEN IS NOT NULL AND LEN(@educationalBackgroundNameEN) > 0 AND CHARINDEX(@educationalBackgroundNameEN, @strBlank) = 0) THEN @educationalBackgroundNameEN ELSE (CASE WHEN (@educationalBackgroundNameEN IS NOT NULL AND (LEN(@educationalBackgroundNameEN) = 0 OR CHARINDEX(@educationalBackgroundNameEN, @strBlank) > 0)) THEN NULL ELSE enEducationalBackgroundName END) END,
									perEducationalLevelId		= CASE WHEN (@educationalLevel IS NOT NULL AND LEN(@educationalLevel) > 0 AND CHARINDEX(@educationalLevel, @strBlank) = 0) THEN @educationalLevel ELSE (CASE WHEN (@educationalLevel IS NOT NULL AND (LEN(@educationalLevel) = 0 OR CHARINDEX(@educationalLevel, @strBlank) > 0)) THEN NULL ELSE perEducationalLevelId END) END,
									cancel						= CASE WHEN (@cancelledStatus IS NOT NULL AND LEN(@cancelledStatus) > 0 AND CHARINDEX(@cancelledStatus, @strBlank) = 0) THEN @cancelledStatus ELSE (CASE WHEN (@cancelledStatus IS NOT NULL AND (LEN(@cancelledStatus) = 0 OR CHARINDEX(@cancelledStatus, @strBlank) > 0)) THEN NULL ELSE cancel END) END,
									modifyDate					= GETDATE(),
									modifyBy					= CASE WHEN (@by IS NOT NULL AND LEN(@by) > 0 AND CHARINDEX(@by, @strBlank) = 0) THEN @by ELSE (CASE WHEN (@by IS NOT NULL AND (LEN(@by) = 0 OR CHARINDEX(@by, @strBlank) > 0)) THEN NULL ELSE modifyBy END) END,
									modifyIp					= CASE WHEN (@ip IS NOT NULL AND LEN(@ip) > 0 AND CHARINDEX(@ip, @strBlank) = 0) THEN @ip ELSE (CASE WHEN (@ip IS NOT NULL AND (LEN(@ip) = 0 OR CHARINDEX(@ip, @strBlank) > 0)) THEN NULL ELSE modifyIp END) END
								WHERE id = @id	
							END								
							
							IF (@action = 'DELETE')
							BEGIN
								DELETE FROM perEducationalBackground WHERE id = @id
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
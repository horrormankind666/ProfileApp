USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_hcsSetWelfareLog]    Script Date: 05-01-2017 14:51:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๐๕/๐๑/๒๕๖๐>
-- Description	: <สำหรับบันทึกข้อมูลตาราง hcsWelfareLog ครั้งละ ๑ เรคคอร์ด>
--  1. action	เป็น VARCHAR	รับค่าการกระทำกับฐานข้อมูล
--  2. personId	เป็น VARCHAR	รับค่ารหัสบุคคล
--	3. welfare	เป็น VARCHAR	รับค่ารหัสสิทธิการรักษาพยาบาล
--	4. by		เป็น VARCHAR	รับค่าชื่อของผู้ที่กระทำกับฐานข้อมูล
--	5. ip		เป็น VARCHAR	รับค่าหมายเลขไอพีของผู้ที่กระทำกับฐานข้อมูล
-- =============================================
ALTER PROCEDURE [dbo].[sp_hcsSetWelfareLog]
(
	@action VARCHAR(10) = NULL,
	@personId VARCHAR(10) = NULL,
	@welfare VARCHAR(3) = NULL,
	@by VARCHAR(255) = NULL,
	@ip VARCHAR(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON

	SET @action = LTRIM(RTRIM(@action))
	SET @personId = LTRIM(RTRIM(@personId))
	SET @welfare = LTRIM(RTRIM(@welfare))
	SET @by = LTRIM(RTRIM(@by))
	SET @ip = LTRIM(RTRIM(@ip))

	DECLARE @table VARCHAR(50) = 'hcsWelfareLog'
	DECLARE @rowCount INT = 0
	DECLARE @rowCountUpdate INT = 0
	DECLARE @value NVARCHAR(MAX) = NULL
	DECLARE	@strBlank VARCHAR(50) = '----------**********.........0.0000000000000000000'
	
	SET @action = UPPER(@action)
	
	IF (@action = 'INSERT' OR @action = 'UPDATE' OR @action = 'DELETE')
	BEGIN
		SET @value = 'perPersonId='		+ (CASE WHEN (@personId IS NOT NULL AND LEN(@personId) > 0 AND CHARINDEX(@personId, @strBlank) = 0) THEN ('"' + @personId + '"') ELSE 'NULL' END) + ', ' +
					 'hcsWelfareId='	+ (CASE WHEN (@welfare IS NOT NULL AND LEN(@welfare) > 0 AND CHARINDEX(@welfare, @strBlank) = 0) THEN ('"' + @welfare + '"') ELSE 'NULL' END)

		BEGIN TRY
			BEGIN TRAN
				IF (@action = 'INSERT')
				BEGIN
					IF (@personId IS NOT NULL AND LEN(@personId) > 0 AND CHARINDEX(@personId, @strBlank) = 0)
					BEGIN
						SET @rowCountUpdate = (SELECT COUNT(@personId) FROM Infinity..hcsWelfareLog WHERE perPersonId = @personId)
						
						IF (@rowCountUpdate = 0)
						BEGIN
 							INSERT INTO Infinity..hcsWelfareLog
 							(
								perPersonId,
								hcsWelfareId,
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
								CASE WHEN (@welfare IS NOT NULL AND LEN(@welfare) > 0 AND CHARINDEX(@welfare, @strBlank) = 0) THEN @welfare ELSE NULL END,
								GETDATE(),
								CASE WHEN (@by IS NOT NULL AND LEN(@by) > 0 AND CHARINDEX(@by, @strBlank) = 0) THEN @by ELSE NULL END,
								CASE WHEN (@ip IS NOT NULL AND LEN(@ip) > 0 AND CHARINDEX(@ip, @strBlank) = 0) THEN @ip ELSE NULL END,
								NULL,
								NULL,
								NULL
							)		
					
							SET @rowCount = @rowCount + 1
						END
					END
				END
				
				IF (@action = 'UPDATE' OR @action = 'DELETE')					
				BEGIN
					IF (@personId IS NOT NULL AND LEN(@personId) > 0 AND CHARINDEX(@personId, @strBlank) = 0)
					BEGIN
						SET @rowCountUpdate = (SELECT COUNT(@personId) FROM Infinity..hcsWelfareLog WHERE perPersonId = @personId)
						
						IF (@rowCountUpdate > 0)
						BEGIN
							IF (@action = 'UPDATE')
							BEGIN
								UPDATE Infinity..hcsWelfareLog SET
									hcsWelfareId	= CASE WHEN (@welfare IS NOT NULL AND LEN(@welfare) > 0 AND CHARINDEX(@welfare, @strBlank) = 0) THEN @welfare ELSE (CASE WHEN (@welfare IS NOT NULL AND (LEN(@welfare) = 0 OR CHARINDEX(@welfare, @strBlank) > 0)) THEN NULL ELSE hcsWelfareId END) END,
									modifyDate		= GETDATE(),
									modifyBy		= CASE WHEN (@by IS NOT NULL AND LEN(@by) > 0 AND CHARINDEX(@by, @strBlank) = 0) THEN @by ELSE (CASE WHEN (@by IS NOT NULL AND (LEN(@by) = 0 OR CHARINDEX(@by, @strBlank) > 0)) THEN NULL ELSE modifyBy END) END,
									modifyIp		= CASE WHEN (@ip IS NOT NULL AND LEN(@ip) > 0 AND CHARINDEX(@ip, @strBlank) = 0) THEN @ip ELSE (CASE WHEN (@ip IS NOT NULL AND (LEN(@ip) = 0 OR CHARINDEX(@ip, @strBlank) > 0)) THEN NULL ELSE modifyIp END) END
								WHERE perPersonId = @personId
							END								
							
							IF (@action = 'DELETE')
							BEGIN
								DELETE FROM Infinity..hcsWelfareLog WHERE perPersonId = @personId
							END
							
							SET @rowCount = @rowCount + 1							
						END							
					END				
				END								
			COMMIT TRAN									
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN
			INSERT INTO InfinityLog..hcsErrorLog
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

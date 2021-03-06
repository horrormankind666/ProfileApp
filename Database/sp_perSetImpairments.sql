USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_perSetImpairments]    Script Date: 11/16/2015 16:34:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๒๑/๑๑/๒๕๕๗>
-- Description	: <สำหรับบันทึกข้อมูลตาราง perImpairments ครั้งละ ๑ เรคคอร์ด>
--  1. action				เป็น VARCHAR	รับค่าการกระทำกับฐานข้อมูล
--  2. id					เป็น VARCHAR	รับค่ารหัสความบกพร่องของสุขภาพ
--  3. impairmentsNameTH	เป็น NVARCHAR	รับค่าชื่อความบกพร่องของสุขภาพภาษาไทย
--  4. impairmentsNameEN	เป็น NVARCHAR	รับค่าชื่อความบกพร่องของสุขภาพภาษาอังกฤษ
--  5. cancelledStatus		เป็น VARCHAR	รับค่าสถานะการยกเลิก
--	6. by					เป็น NVARCHAR	รับค่าชื่อของผู้ที่กระทำกับฐานข้อมูล
--	7. ip					เป็น VARCHAR	รับค่าหมายเลขไอพีของผู้ที่กระทำกับฐานข้อมูล
-- =============================================
ALTER PROCEDURE [dbo].[sp_perSetImpairments]
(
	@action VARCHAR(10) = NULL,
	@id VARCHAR(3) = NULL,
	@impairmentsNameTH NVARCHAR(255) = NULL,
	@impairmentsNameEN NVARCHAR(255) = NULL,
	@cancelledStatus VARCHAR(1) = NULL,
	@by NVARCHAR(255) = NULL,
	@ip VARCHAR(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	
	SET @action = LTRIM(RTRIM(@action))
	SET @id = LTRIM(RTRIM(@id))
	SET @impairmentsNameTH = LTRIM(RTRIM(@impairmentsNameTH))
	SET @impairmentsNameEN = LTRIM(RTRIM(@impairmentsNameEN))
	SET @cancelledStatus = LTRIM(RTRIM(@cancelledStatus))
	SET @by = LTRIM(RTRIM(@by))
	SET @id = LTRIM(RTRIM(@ip))
	
	DECLARE @table VARCHAR(50) = 'perImpairments'
	DECLARE @rowCount INT = 0
	DECLARE @rowCountUpdate INT = 0
	DECLARE @value NVARCHAR(MAX) = NULL
	DECLARE	@strBlank VARCHAR(50) = '----------**********.........0.0000000000000000000'
	
	SET @action = UPPER(@action)
	
	IF (@action = 'INSERT' OR @action = 'UPDATE' OR @action = 'DELETE')
	BEGIN
		SET @value = 'id=' + (CASE WHEN (@id IS NOT NULL AND LEN(@id) > 0 AND CHARINDEX(@id, @strBlank) = 0) THEN ('"' + @id + '"') ELSE 'NULL' END) + ', ' +
					 'impairmentsNameTH=' + (CASE WHEN (@impairmentsNameTH IS NOT NULL AND LEN(@impairmentsNameTH) > 0 AND CHARINDEX(@impairmentsNameTH, @strBlank) = 0) THEN ('"' + @impairmentsNameTH + '"') ELSE 'NULL' END) + ', ' +
					 'impairmentsNameEN=' + (CASE WHEN (@impairmentsNameEN IS NOT NULL AND LEN(@impairmentsNameEN) > 0 AND CHARINDEX(@impairmentsNameEN, @strBlank) = 0) THEN ('"' + @impairmentsNameEN + '"') ELSE 'NULL' END) + ', ' +
					 'cancelledStatus=' + (CASE WHEN (@cancelledStatus IS NOT NULL AND LEN(@cancelledStatus) > 0 AND CHARINDEX(@cancelledStatus, @strBlank) = 0) THEN ('"' + @cancelledStatus + '"') ELSE 'NULL' END)
		
		BEGIN TRY
			BEGIN TRAN
				IF (@action = 'INSERT')
				BEGIN
 					INSERT INTO perImpairments
 					(
						id,
						impairmentsNameTH,
						impairmentsNameEN,
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
						CASE WHEN (@impairmentsNameTH IS NOT NULL AND LEN(@impairmentsNameTH) > 0 AND CHARINDEX(@impairmentsNameTH, @strBlank) = 0) THEN @impairmentsNameTH ELSE NULL END,
						CASE WHEN (@impairmentsNameEN IS NOT NULL AND LEN(@impairmentsNameEN) > 0 AND CHARINDEX(@impairmentsNameEN, @strBlank) = 0) THEN @impairmentsNameEN ELSE NULL END,
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
						SET @rowCountUpdate = (SELECT COUNT(id) FROM perImpairments WHERE id = @id)
						
						IF (@rowCountUpdate > 0)
						BEGIN
							IF (@action = 'UPDATE')
							BEGIN
								UPDATE perImpairments SET
									impairmentsNameTH	= CASE WHEN (@impairmentsNameTH IS NOT NULL AND LEN(@impairmentsNameTH) > 0 AND CHARINDEX(@impairmentsNameTH, @strBlank) = 0) THEN @impairmentsNameTH ELSE (CASE WHEN (@impairmentsNameTH IS NOT NULL AND (LEN(@impairmentsNameTH) = 0 OR CHARINDEX(@impairmentsNameTH, @strBlank) > 0)) THEN NULL ELSE impairmentsNameTH END) END,
									impairmentsNameEN	= CASE WHEN (@impairmentsNameEN IS NOT NULL AND LEN(@impairmentsNameEN) > 0 AND CHARINDEX(@impairmentsNameEN, @strBlank) = 0) THEN @impairmentsNameEN ELSE (CASE WHEN (@impairmentsNameEN IS NOT NULL AND (LEN(@impairmentsNameEN) = 0 OR CHARINDEX(@impairmentsNameEN, @strBlank) > 0)) THEN NULL ELSE impairmentsNameEN END) END,
									cancelledStatus		= CASE WHEN (@cancelledStatus IS NOT NULL AND LEN(@cancelledStatus) > 0 AND CHARINDEX(@cancelledStatus, @strBlank) = 0) THEN @cancelledStatus ELSE (CASE WHEN (@cancelledStatus IS NOT NULL AND (LEN(@cancelledStatus) = 0 OR CHARINDEX(@cancelledStatus, @strBlank) > 0)) THEN NULL ELSE cancelledStatus END) END,
									modifyDate			= GETDATE(),
									modifyBy			= CASE WHEN (@by IS NOT NULL AND LEN(@by) > 0 AND CHARINDEX(@by, @strBlank) = 0) THEN @by ELSE (CASE WHEN (@by IS NOT NULL AND (LEN(@by) = 0 OR CHARINDEX(@by, @strBlank) > 0)) THEN NULL ELSE modifyBy END) END,
									modifyIp			= CASE WHEN (@ip IS NOT NULL AND LEN(@ip) > 0 AND CHARINDEX(@ip, @strBlank) = 0) THEN @ip ELSE (CASE WHEN (@ip IS NOT NULL AND (LEN(@ip) = 0 OR CHARINDEX(@ip, @strBlank) > 0)) THEN NULL ELSE modifyIp END) END
								WHERE id = @id
							END
							
							IF (@action = 'DELETE')								
							BEGIN
								DELETE FROM perImpairments WHERE id = @id
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
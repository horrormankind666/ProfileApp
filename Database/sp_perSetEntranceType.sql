USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_perSetEntranceType]    Script Date: 11/16/2015 16:29:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๑/๑๒/๒๕๕๖>
-- Description	: <สำหรับบันทึกข้อมูลตาราง perEntranceType ครั้งละ ๑ เรคคอร์ด>
--  1. action				เป็น VARCHAR	รับค่าการกระทำกับฐานข้อมูล
--  2. id					เป็น VARCHAR	รับค่ารหัสระบบที่สอบเข้ามหาวิทยาลัย
--  3. entranceTypeNameTH	เป็น NVARCHAR	รับค่าชื่อระบบที่สอบเข้ามหาวิทยาลัยภาษาไทย
--  4. entranceTypeNameEN	เป็น NVARCHAR	รับค่าชื่อระบบที่สอบเข้ามหาวิทยาลัยภาษาอังกฤษ
--	5. cancelledStatus		เป็น VARCHAR	รับค่าสถานะการยกเลิก
--	6. by					เป็น NVARCHAR	รับค่าชื่อของผู้ที่กระทำกับฐานข้อมูล
--	7. ip					เป็น VARCHAR	รับค่าหมายเลขไอพีของผู้ที่กระทำกับฐานข้อมูล
-- =============================================
ALTER PROCEDURE [dbo].[sp_perSetEntranceType]
(
	@action VARCHAR(10) = NULL,
	@id VARCHAR(20) = NULL,
	@entranceTypeNameTH NVARCHAR(255) = NULL,
	@entranceTypeNameEN NVARCHAR(255) = NULL,
	@cancelledStatus VARCHAR(1) = NULL,
	@by NVARCHAR(255) = NULL,
	@ip VARCHAR(255) = NULL
)	
AS
BEGIN
	SET NOCOUNT ON
	
	SET @action = LTRIM(RTRIM(@action))
	SET @id = LTRIM(RTRIM(@id))
	SET @entranceTypeNameTH = LTRIM(RTRIM(@entranceTypeNameTH))
	SET @entranceTypeNameEN = LTRIM(RTRIM(@entranceTypeNameEN))
	SET @cancelledStatus = LTRIM(RTRIM(@cancelledStatus))
	SET @by = LTRIM(RTRIM(@by))
	SET @ip = LTRIM(RTRIM(@ip))
	
	DECLARE @table VARCHAR(50) = 'perEntranceType'
	DECLARE @rowCount INT = 0
	DECLARE @rowCountUpdate INT = 0
	DECLARE @value NVARCHAR(MAX) = NULL
	DECLARE	@strBlank VARCHAR(50) = '----------**********.........0.0000000000000000000'
	
	SET @action = UPPER(@action)
	
	IF (@action = 'INSERT' OR @action = 'UPDATE' OR @action = 'DELETE')
	BEGIN
		SET @value = 'id=' + (CASE WHEN (@id IS NOT NULL AND LEN(@id) > 0 AND CHARINDEX(@id, @strBlank) = 0) THEN ('"' + @id + '"') ELSE 'NULL' END) + ', ' +
					 'entranceTypeNameTH=' + (CASE WHEN (@entranceTypeNameTH IS NOT NULL AND LEN(@entranceTypeNameTH) > 0 AND CHARINDEX(@entranceTypeNameTH, @strBlank) = 0) THEN ('"' + @entranceTypeNameTH + '"') ELSE 'NULL' END) + ', ' +
					 'entranceTypeNameEN=' + (CASE WHEN (@entranceTypeNameEN IS NOT NULL AND LEN(@entranceTypeNameEN) > 0 AND CHARINDEX(@entranceTypeNameEN, @strBlank) = 0) THEN ('"' + @entranceTypeNameEN + '"') ELSE 'NULL' END) + ', ' +
					 'cancelledStatus=' + (CASE WHEN (@cancelledStatus IS NOT NULL AND LEN(@cancelledStatus) > 0 AND CHARINDEX(@cancelledStatus, @strBlank) = 0) THEN ('"' + @cancelledStatus + '"') ELSE 'NULL' END)
					 
		BEGIN TRY
			BEGIN TRAN
				IF (@action = 'INSERT')
				BEGIN
 					INSERT INTO perEntranceType
 					(
						id,
						entranceTypeNameTH,
						entranceTypeNameEN,
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
						CASE WHEN (@entranceTypeNameTH IS NOT NULL AND LEN(@entranceTypeNameTH) > 0 AND CHARINDEX(@entranceTypeNameTH, @strBlank) = 0) THEN @entranceTypeNameTH ELSE NULL END,
						CASE WHEN (@entranceTypeNameEN IS NOT NULL AND LEN(@entranceTypeNameEN) > 0 AND CHARINDEX(@entranceTypeNameEN, @strBlank) = 0) THEN @entranceTypeNameEN ELSE NULL END,
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
						SET @rowCountUpdate = (SELECT COUNT(id) FROM perEntranceType WHERE id = @id)
					
						IF (@rowCountUpdate > 0)
						BEGIN
							IF (@action = 'UPDATE')
							BEGIN
								UPDATE perEntranceType SET
									entranceTypeNameTH	= CASE WHEN (@entranceTypeNameTH IS NOT NULL AND LEN(@entranceTypeNameTH) > 0 AND CHARINDEX(@entranceTypeNameTH, @strBlank) = 0) THEN @entranceTypeNameTH ELSE (CASE WHEN (@entranceTypeNameTH IS NOT NULL AND (LEN(@entranceTypeNameTH) = 0 OR CHARINDEX(@entranceTypeNameTH, @strBlank) > 0)) THEN NULL ELSE entranceTypeNameTH END) END,
									entranceTypeNameEN	= CASE WHEN (@entranceTypeNameEN IS NOT NULL AND LEN(@entranceTypeNameEN) > 0 AND CHARINDEX(@entranceTypeNameEN, @strBlank) = 0) THEN @entranceTypeNameEN ELSE (CASE WHEN (@entranceTypeNameEN IS NOT NULL AND (LEN(@entranceTypeNameEN) = 0 OR CHARINDEX(@entranceTypeNameEN, @strBlank) > 0)) THEN NULL ELSE entranceTypeNameEN END) END,
									cancelledStatus		= CASE WHEN (@cancelledStatus IS NOT NULL AND LEN(@cancelledStatus) > 0 AND CHARINDEX(@cancelledStatus, @strBlank) = 0) THEN @cancelledStatus ELSE (CASE WHEN (@cancelledStatus IS NOT NULL AND (LEN(@cancelledStatus) = 0 OR CHARINDEX(@cancelledStatus, @strBlank) > 0)) THEN NULL ELSE cancelledStatus END) END,
									modifyDate			= GETDATE(),
									modifyBy			= CASE WHEN (@by IS NOT NULL AND LEN(@by) > 0 AND CHARINDEX(@by, @strBlank) = 0) THEN @by ELSE (CASE WHEN (@by IS NOT NULL AND (LEN(@by) = 0 OR CHARINDEX(@by, @strBlank) > 0)) THEN NULL ELSE modifyBy END) END,
									modifyIp			= CASE WHEN (@ip IS NOT NULL AND LEN(@ip) > 0 AND CHARINDEX(@ip, @strBlank) = 0) THEN @ip ELSE (CASE WHEN (@ip IS NOT NULL AND (LEN(@ip) = 0 OR CHARINDEX(@ip, @strBlank) > 0)) THEN NULL ELSE modifyIp END) END							
								WHERE id = @id	
							END								
							
							IF (@action = 'DELETE')
							BEGIN
								DELETE FROM perEntranceType WHERE id = @id
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
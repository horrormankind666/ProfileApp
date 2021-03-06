USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_perSetTitlePrefix]    Script Date: 11/16/2015 16:43:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๓/๑๑/๒๕๕๖>
-- Description	: <สำหรับบันทึกข้อมูลตาราง perTitlePrefix ครั้งละ ๑ เรคคอร์ด>
--  1. action					เป็น VARCHAR	รับค่าการกระทำกับฐานข้อมูล
--  2. id 						เป็น VARCHAR	รับค่ารหัสคำนำหน้าชื่อ
--  3. titlePrefixFullNameTH	เป็น NVARCHAR	รับค่าชื่อเต็มคำหน้าชื่อภาษาไทย
--  4. titlePrefixInitialsTH	เป็น NVARCHAR	รับค่าชื่อย่อคำหน้าชื่อภาษาไทย
--  5. descriptionTH			เป็น NVARCHAR	รับค่ารายละเอียดคำหน้าชื่อภาษาไทย
--  6. titlePrefixFullNameEN	เป็น NVARCHAR	รับค่าชื่อเต็มคำหน้าชื่อภาษาอังกฤษ
--  7. titlePrefixInitialsEN	เป็น NVARCHAR	รับค่าชื่อย่อคำหน้าชื่อภาษาอังกฤษ
--  8. descriptionEN			เป็น NVARCHAR	รับค่ารายละเอียดคำหน้าชื่อภาษาอังกฤษ
--  9. gender					เป็น VARCHAR	รับค่ารหัสเพศ
-- 10. cancelledStatus			เป็น VARCHAR	รับค่าสถานะการยกเลิก
-- 11. by						เป็น NVARCHAR	รับค่าชื่อของผู้ที่กระทำกับฐานข้อมูล
-- 12. ip						เป็น VARCHAR	รับค่าหมายเลขไอพีของผู้ที่กระทำกับฐานข้อมูล
-- =============================================
ALTER PROCEDURE [dbo].[sp_perSetTitlePrefix]
(
	@action VARCHAR(10) = NULL,
	@id VARCHAR(3) = NULL,
	@titlePrefixFullNameTH NVARCHAR(255) = NULL,
	@titlePrefixInitialsTH NVARCHAR(50) = NULL,
	@descriptionTH NVARCHAR(255) = NULL,
	@titlePrefixFullNameEN NVARCHAR(255) = NULL,
	@titlePrefixInitialsEN NVARCHAR(50) = NULL,
	@descriptionEN NVARCHAR(255) = NULL,
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
	SET @titlePrefixFullNameTH = LTRIM(RTRIM(@titlePrefixFullNameTH))
	SET @titlePrefixInitialsTH = LTRIM(RTRIM(@titlePrefixInitialsTH))
	SET @descriptionTH = LTRIM(RTRIM(@descriptionTH))
	SET @titlePrefixFullNameEN = LTRIM(RTRIM(@titlePrefixFullNameEN))
	SET @titlePrefixInitialsEN = LTRIM(RTRIM(@titlePrefixInitialsEN))
	SET @descriptionEN = LTRIM(RTRIM(@descriptionEN))
	SET @gender = LTRIM(RTRIM(@gender))
	SET @cancelledStatus = LTRIM(RTRIM(@cancelledStatus))
	SET @by = LTRIM(RTRIM(@by))
	SET @ip = LTRIM(RTRIM(@ip))
	
	DECLARE @table VARCHAR(50) = 'perTitlePrefix'
	DECLARE @rowCount INT = 0
	DECLARE @rowCountUpdate INT = 0
	DECLARE @value NVARCHAR(MAX) = NULL
	DECLARE	@strBlank VARCHAR(50) = '----------**********.........0.0000000000000000000'
	
	SET @action = UPPER(@action)
	
	IF (@action = 'INSERT' OR @action = 'UPDATE' OR @action = 'DELETE')
	BEGIN
		SET @value = 'id=' + (CASE WHEN (@id IS NOT NULL AND LEN(@id) > 0 AND CHARINDEX(@id, @strBlank) = 0) THEN ('"' + @id + '"') ELSE 'NULL' END) + ', ' +
					 'thTitleFullName=' + (CASE WHEN (@titlePrefixFullNameTH IS NOT NULL AND LEN(@titlePrefixFullNameTH) > 0 AND CHARINDEX(@titlePrefixFullNameTH, @strBlank) = 0) THEN ('"' + @titlePrefixFullNameTH + '"') ELSE 'NULL' END) + ', ' +
					 'thTitleInitials=' + (CASE WHEN (@titlePrefixInitialsTH IS NOT NULL AND LEN(@titlePrefixInitialsTH) > 0 AND CHARINDEX(@titlePrefixInitialsTH, @strBlank) = 0) THEN ('"' + @titlePrefixInitialsTH + '"') ELSE 'NULL' END) + ', ' +
					 'thDescription=' + (CASE WHEN (@descriptionTH IS NOT NULL AND LEN(@descriptionTH) > 0 AND CHARINDEX(@descriptionTH, @strBlank) = 0) THEN ('"' + @descriptionTH + '"') ELSE 'NULL' END) + ', ' +
					 'enTitleFullName=' + (CASE WHEN (@titlePrefixFullNameEN IS NOT NULL AND LEN(@titlePrefixFullNameEN) > 0 AND CHARINDEX(@titlePrefixFullNameEN, @strBlank) = 0) THEN ('"' + @titlePrefixFullNameEN + '"') ELSE 'NULL' END) + ', ' +
					 'enTitleInitials=' + (CASE WHEN (@titlePrefixInitialsEN IS NOT NULL AND LEN(@titlePrefixInitialsEN) > 0 AND CHARINDEX(@titlePrefixInitialsEN, @strBlank) = 0) THEN ('"' + @titlePrefixInitialsEN + '"') ELSE 'NULL' END) + ', ' +
					 'enDescription=' + (CASE WHEN (@descriptionEN IS NOT NULL AND LEN(@descriptionEN) > 0 AND CHARINDEX(@descriptionEN, @strBlank) = 0) THEN ('"' + @descriptionEN + '"') ELSE 'NULL' END) + ', ' +
					 'perGenderId=' + (CASE WHEN (@gender IS NOT NULL AND LEN(@gender) > 0 AND CHARINDEX(@gender, @strBlank) = 0) THEN ('"' + @gender + '"') ELSE 'NULL' END) + ', ' +
					 'cancel=' + (CASE WHEN (@cancelledStatus IS NOT NULL AND LEN(@cancelledStatus) > 0 AND CHARINDEX(@cancelledStatus, @strBlank) = 0) THEN ('"' + @cancelledStatus + '"') ELSE 'NULL' END)
					 
		BEGIN TRY
			BEGIN TRAN
				IF (@action = 'INSERT')
				BEGIN
 					INSERT INTO perTitlePrefix
 					(
						id,
						thTitleFullName,
						thTitleInitials,
						thDescription,
						enTitleFullName,
						enTitleInitials,
						enDescription,
						perGenderId,
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
						CASE WHEN (@titlePrefixFullNameTH IS NOT NULL AND LEN(@titlePrefixFullNameTH) > 0 AND CHARINDEX(@titlePrefixFullNameTH, @strBlank) = 0) THEN @titlePrefixFullNameTH ELSE NULL END,
						CASE WHEN (@titlePrefixInitialsTH IS NOT NULL AND LEN(@titlePrefixInitialsTH) > 0 AND CHARINDEX(@titlePrefixInitialsTH, @strBlank) = 0) THEN @titlePrefixInitialsTH ELSE NULL END,
						CASE WHEN (@descriptionTH IS NOT NULL AND LEN(@descriptionTH) > 0 AND CHARINDEX(@descriptionTH, @strBlank) = 0) THEN @descriptionTH ELSE NULL END,
						CASE WHEN (@titlePrefixFullNameEN IS NOT NULL AND LEN(@titlePrefixFullNameEN) > 0 AND CHARINDEX(@titlePrefixFullNameEN, @strBlank) = 0) THEN @titlePrefixFullNameEN ELSE NULL END,
						CASE WHEN (@titlePrefixInitialsEN IS NOT NULL AND LEN(@titlePrefixInitialsEN) > 0 AND CHARINDEX(@titlePrefixInitialsEN, @strBlank) = 0) THEN @titlePrefixInitialsEN ELSE NULL END,
						CASE WHEN (@descriptionEN IS NOT NULL AND LEN(@descriptionEN) > 0 AND CHARINDEX(@descriptionEN, @strBlank) = 0) THEN @descriptionEN ELSE NULL END,
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
						SET @rowCountUpdate = (SELECT COUNT(id) FROM perTitlePrefix WHERE id = @id)
						
						IF (@rowCountUpdate > 0)
						BEGIN				
							IF (@action = 'UPDATE')		
							BEGIN
								UPDATE perTitlePrefix SET
									thTitleFullName = CASE WHEN (@titlePrefixFullNameTH IS NOT NULL AND LEN(@titlePrefixFullNameTH) > 0 AND CHARINDEX(@titlePrefixFullNameTH, @strBlank) = 0) THEN @titlePrefixFullNameTH ELSE (CASE WHEN (@titlePrefixFullNameTH IS NOT NULL AND (LEN(@titlePrefixFullNameTH) = 0 OR CHARINDEX(@titlePrefixFullNameTH, @strBlank) > 0)) THEN NULL ELSE thTitleFullName END) END,
									thTitleInitials = CASE WHEN (@titlePrefixInitialsTH IS NOT NULL AND LEN(@titlePrefixInitialsTH) > 0 AND CHARINDEX(@titlePrefixInitialsTH, @strBlank) = 0) THEN @titlePrefixInitialsTH ELSE (CASE WHEN (@titlePrefixInitialsTH IS NOT NULL AND (LEN(@titlePrefixInitialsTH) = 0 OR CHARINDEX(@titlePrefixInitialsTH, @strBlank) > 0)) THEN NULL ELSE thTitleInitials END) END,
									thDescription	= CASE WHEN (@descriptionTH IS NOT NULL AND LEN(@descriptionTH) > 0 AND CHARINDEX(@descriptionTH, @strBlank) = 0) THEN @descriptionTH ELSE (CASE WHEN (@descriptionTH IS NOT NULL AND (LEN(@descriptionTH) = 0 OR CHARINDEX(@descriptionTH, @strBlank) > 0)) THEN NULL ELSE thDescription END) END,
									enTitleFullName	= CASE WHEN (@titlePrefixFullNameEN IS NOT NULL AND LEN(@titlePrefixFullNameEN) > 0 AND CHARINDEX(@titlePrefixFullNameEN, @strBlank) = 0) THEN @titlePrefixFullNameEN ELSE (CASE WHEN (@titlePrefixFullNameEN IS NOT NULL AND (LEN(@titlePrefixFullNameEN) = 0 OR CHARINDEX(@titlePrefixFullNameEN, @strBlank) > 0)) THEN NULL ELSE enTitleFullName END) END,
									enTitleInitials	= CASE WHEN (@titlePrefixInitialsEN IS NOT NULL AND LEN(@titlePrefixInitialsEN) > 0 AND CHARINDEX(@titlePrefixInitialsEN, @strBlank) = 0) THEN @titlePrefixInitialsEN ELSE (CASE WHEN (@titlePrefixInitialsEN IS NOT NULL AND (LEN(@titlePrefixInitialsEN) = 0 OR CHARINDEX(@titlePrefixInitialsEN, @strBlank) > 0)) THEN NULL ELSE enTitleInitials END) END,
									enDescription	= CASE WHEN (@descriptionEN IS NOT NULL AND LEN(@descriptionEN) > 0 AND CHARINDEX(@descriptionEN, @strBlank) = 0) THEN @descriptionEN ELSE (CASE WHEN (@descriptionEN IS NOT NULL AND (LEN(@descriptionEN) = 0 OR CHARINDEX(@descriptionEN, @strBlank) > 0)) THEN NULL ELSE enDescription END) END,
									perGenderId		= CASE WHEN (@gender IS NOT NULL AND LEN(@gender) > 0 AND CHARINDEX(@gender, @strBlank) = 0) THEN @gender ELSE (CASE WHEN (@gender IS NOT NULL AND (LEN(@gender) = 0 OR CHARINDEX(@gender, @strBlank) > 0)) THEN NULL ELSE perGenderId END) END,									
									cancel			= CASE WHEN (@cancelledStatus IS NOT NULL AND LEN(@cancelledStatus) > 0 AND CHARINDEX(@cancelledStatus, @strBlank) = 0) THEN @cancelledStatus ELSE (CASE WHEN (@cancelledStatus IS NOT NULL AND (LEN(@cancelledStatus) = 0 OR CHARINDEX(@cancelledStatus, @strBlank) > 0)) THEN NULL ELSE cancel END) END,									
									modifyDate		= GETDATE(),
									modifyBy		= CASE WHEN (@by IS NOT NULL AND LEN(@by) > 0 AND CHARINDEX(@by, @strBlank) = 0) THEN @by ELSE (CASE WHEN (@by IS NOT NULL AND (LEN(@by) = 0 OR CHARINDEX(@by, @strBlank) > 0)) THEN NULL ELSE modifyBy END) END,
									modifyIp		= CASE WHEN (@ip IS NOT NULL AND LEN(@ip) > 0 AND CHARINDEX(@ip, @strBlank) = 0) THEN @ip ELSE (CASE WHEN (@ip IS NOT NULL AND (LEN(@ip) = 0 OR CHARINDEX(@ip, @strBlank) > 0)) THEN NULL ELSE modifyIp END) END
								WHERE id = @id		
							END
							
							IF (@action = 'DELETE')								
							BEGIN
								DELETE FROM perTitlePrefix WHERE id = @id
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

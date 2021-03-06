USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_quoSetVerifyIdentity]    Script Date: 11/12/2015 12:02:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๐๙/๑๑/๒๕๕๘>
-- Description	: <สำหรับบันทึกข้อมูลตาราง  quoVerifyIdentity ครั้งละ ๑ เรคคอร์ด>
--  1. action			เป็น VARCHAR	รับค่าการกระทำกับฐานข้อมูล
--	2. id				เป็น VARCHAR	รับค่ารหัสผู้ใช้งาน
--	3. acaYear			เป็น VARCHAR	รับค่าปีการศึกษา
--	4. idCard			เป็น NVARCHAR	รับค่าเลขประจำตัวประชาชน
--	5. email			เป็น NVARCHAR	รับค่าชื่ออีเมล์
--	6. verifiedCode		เป็น NVARCHAR	รับค่ารหัสสำหรับการยืนยันตัวตน
--  8. verifiedStatus	เป็น VARCHAR	รับค่าสถานะการยืนยันตัวตน
--  9. by				เป็น NVARCHAR	รับค่าชื่อของผู้ที่กระทำกับฐานข้อมูล
-- 10. ip				เป็น VARCHAR	รับค่าหมายเลขไอพีของผู้ที่กระทำกับฐานข้อมูล
-- =============================================
ALTER PROCEDURE [dbo].[sp_quoSetVerifyIdentity]
(
	@action VARCHAR(10) = NULL,
	@id VARCHAR(MAX) = NULL,
	@acaYear VARCHAR(MAX) = NULL,
	@idCard NVARCHAR(MAX) = NULL,
	@email NVARCHAR(MAX) = NULL,
	@verifiedCode NVARCHAR(MAX) = NULL,
	@verifiedStatus VARCHAR(MAX) = NULL,
	@by NVARCHAR(255) = NULL,
	@ip VARCHAR(MAX) = NULL
)	
AS
BEGIN
	SET NOCOUNT ON

	SET @action = LTRIM(RTRIM(@action))
	SET @id = LTRIM(RTRIM(@id))
	SET @acaYear = LTRIM(RTRIM(@acaYear))
	SET @idCard = LTRIM(RTRIM(@idCard))
	SET @email = LTRIM(RTRIM(@email))
	SET @verifiedCode = LTRIM(RTRIM(@verifiedCode))
	SET @verifiedStatus = LTRIM(RTRIM(@verifiedStatus))
	SET @by = LTRIM(RTRIM(@by))
	SET @ip = LTRIM(RTRIM(@ip))
	
	DECLARE @table VARCHAR(50) = 'quoVerifyIdentity'
	DECLARE @rowCount INT = 0
	DECLARE @rowCountUpdate INT = 0
	DECLARE @value NVARCHAR(MAX) = NULL
	DECLARE	@strBlank VARCHAR(50) = '----------**********.........0.0000000000000000000'

	SET @action = UPPER(@action)		
		
	SET @value = 'id='				+ (CASE WHEN (@id IS NOT NULL AND LEN(@id) > 0 AND CHARINDEX(@id, @strBlank) = 0) THEN ('"' + @id + '"') ELSE 'NULL' END) + ', ' +
				 'acaYear='			+ (CASE WHEN (@acaYear IS NOT NULL AND LEN(@acaYear) > 0 AND CHARINDEX(@acaYear, @strBlank) = 0) THEN ('"' + @acaYear + '"') ELSE 'NULL' END) + ', ' +
				 'idCard='			+ (CASE WHEN (@idCard IS NOT NULL AND LEN(@idCard) > 0 AND CHARINDEX(@idCard, @strBlank) = 0) THEN ('"' + @idCard + '"') ELSE 'NULL' END) + ', ' +
				 'email='			+ (CASE WHEN (@email IS NOT NULL AND LEN(@email) > 0 AND CHARINDEX(@email, @strBlank) = 0) THEN ('"' + @email + '"') ELSE 'NULL' END) + ', ' +
				 'verifiedCode='	+ (CASE WHEN (@verifiedCode IS NOT NULL AND LEN(@verifiedCode) > 0 AND CHARINDEX(@verifiedCode, @strBlank) = 0) THEN ('"' + @verifiedCode + '"') ELSE 'NULL' END) + ', ' +
				 'verifiedStatus='	+ (CASE WHEN (@verifiedStatus IS NOT NULL AND LEN(@verifiedStatus) > 0 AND CHARINDEX(@verifiedStatus, @strBlank) = 0) THEN ('"' + @verifiedStatus + '"') ELSE 'N' END)
					 
	BEGIN TRY
		BEGIN TRAN
			IF (@action = 'INSERT')
			BEGIN
				SET @verifiedCode = dbo.fnc_quoGetVerifyCode(50)
			
 				INSERT INTO Infinity..quoVerifyIdentity
 				(
					acaYear,
					idCard,
					email,
					verifiedCode,
					verifiedStatus,
					createDate,
					createBy,
					createIp,
					verifyDate,
					verifyBy,
					verifyIp
				)
				VALUES
				(
					CASE WHEN (@acaYear IS NOT NULL AND LEN(@acaYear) > 0 AND CHARINDEX(@acaYear, @strBlank) = 0) THEN @acaYear ELSE NULL END,
					CASE WHEN (@idCard IS NOT NULL AND LEN(@idCard) > 0 AND CHARINDEX(@idCard, @strBlank) = 0) THEN @idCard ELSE NULL END,
					CASE WHEN (@email IS NOT NULL AND LEN(@email) > 0 AND CHARINDEX(@email, @strBlank) = 0) THEN @email ELSE NULL END,
					CASE WHEN (@verifiedCode IS NOT NULL AND LEN(@verifiedCode) > 0 AND CHARINDEX(@verifiedCode, @strBlank) = 0) THEN @verifiedCode ELSE NULL END,
					CASE WHEN (@verifiedStatus IS NOT NULL AND LEN(@verifiedStatus) > 0 AND CHARINDEX(@verifiedStatus, @strBlank) = 0) THEN @verifiedStatus ELSE 'N' END,
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
				SET @rowCountUpdate = (SELECT COUNT(id) FROM Infinity..quoVerifyIdentity WHERE (id = @id))
						
				IF (@rowCountUpdate > 0)
				BEGIN				
					SELECT	@acaYear = acaYear,
							@idCard = idCard,
							@email = email
					FROM	Infinity..quoVerifyIdentity WHERE (id = @id)
					
					IF (@action = 'UPDATE')
					BEGIN
						UPDATE Infinity..quoVerifyIdentity SET
							verifiedStatus	= (CASE WHEN (@verifiedStatus IS NOT NULL AND LEN(@verifiedStatus) > 0 AND CHARINDEX(@verifiedStatus, @strBlank) = 0) THEN @verifiedStatus ELSE verifiedStatus END),
							verifyDate		= GETDATE(),
							verifyBy		= (CASE WHEN (@by IS NOT NULL AND LEN(@by) > 0 AND CHARINDEX(@by, @strBlank) = 0) THEN @by ELSE verifyBy END),
							verifyIp		= (CASE WHEN (@ip IS NOT NULL AND LEN(@ip) > 0 AND CHARINDEX(@ip, @strBlank) = 0) THEN @ip ELSE verifyIp END)					
						WHERE (id = @id)
					END
					
					IF (@action = 'DELETE')
					BEGIN
						DELETE
						FROM	Infinity..quoVerifyIdentity
						WHERE	(id = @id)
					END
					
					SET @rowCount = @rowCount + 1							
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
			dbo.fnc_perGetIP()
		)			
	END CATCH
	
	SELECT	@rowCount, @acaYear, @idCard, @email, @verifiedCode
END		

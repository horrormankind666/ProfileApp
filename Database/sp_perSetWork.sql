USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_perSetWork]    Script Date: 11/16/2015 16:44:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๙/๑๒/๒๕๕๖>
-- Description	: <สำหรับบันทึกข้อมูลตาราง perWork ครั้งละ ๑ เรคคอร์ด>
--  1. action		เป็น VARCHAR	รับค่าการกระทำกับฐานข้อมูล
--  2. personId 	เป็น VARCHAR	รับค่ารหัสบุคคล
--  3. occupation	เป็น VARCHAR	รับค่าอาชีพ
--  4. agency		เป็น VARCHAR	รับค่ารหัสต้นสังกัด
--  5. agencyOther	เป็น NVARCHAR	รับค่าต้นสังกัดอื่น ๆ
--  6. workplace	เป็น NVARCHAR	รับค่าชื่อสถานที่ทำงาน
--  7. position		เป็น NVARCHAR	รับค่าชื่อตำแหน่ง
--  8. telephone	เป็น NVARCHAR	รับค่าหมายเลขโทรศัพท์ที่ทำงาน
--  9. salary		เป็น VARCHAR	รับค่าเงินเดือน
-- 10. by			เป็น NVARCHAR	รับค่าชื่อของผู้ที่กระทำกับฐานข้อมูล
-- 11. ip			เป็น VARCHAR	รับค่าหมายเลขไอพีของผู้ที่กระทำกับฐานข้อมูล
-- =============================================
ALTER PROCEDURE [dbo].[sp_perSetWork]
(
	@action VARCHAR(10) = NULL,
	@personId VARCHAR(10) = NULL,
	@occupation VARCHAR(2) = NULL,
	@agency VARCHAR(3) = NULL,
	@agencyOther NVARCHAR(255) = NULL,
	@workplace NVARCHAR(255) = NULL,
	@position NVARCHAR(255) = NULL,
	@telephone NVARCHAR(50) = NULL,
	@salary VARCHAR(20) = NULL,
	@by NVARCHAR(255) = NULL,
	@ip VARCHAR(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	
	SET @action = LTRIM(RTRIM(@action))
	SET @personId = LTRIM(RTRIM(@personId))
	SET @occupation = LTRIM(RTRIM(@occupation))
	SET @agency = LTRIM(RTRIM(@agency))
	SET @agencyOther = LTRIM(RTRIM(@agencyOther))
	SET @workplace = LTRIM(RTRIM(@workplace))
	SET @position = LTRIM(RTRIM(@position))
	SET @telephone = LTRIM(RTRIM(@telephone))
	SET @salary = LTRIM(RTRIM(@salary))
	SET @by = LTRIM(RTRIM(@by))
	SET @ip = LTRIM(RTRIM(@ip))
	
	DECLARE @table VARCHAR(50) = 'perWork'
	DECLARE @rowCount INT = 0
	DECLARE @rowCountUpdate INT = 0
	DECLARE @value NVARCHAR(MAX) = NULL
	DECLARE	@strBlank VARCHAR(50) = '----------**********.........0.0000000000000000000'
	
	SET @action = UPPER(@action)	
	
	IF (@action = 'INSERT' OR @action = 'UPDATE' OR @action = 'DELETE')
	BEGIN
		SET @value = 'perPersonId=' + (CASE WHEN (@personId IS NOT NULL AND LEN(@personId) > 0 AND CHARINDEX(@personId, @strBlank) = 0) THEN ('"' + @personId + '"') ELSE 'NULL' END) + ', ' +
					 'occupation=' + (CASE WHEN (@occupation IS NOT NULL AND LEN(@occupation) > 0 AND CHARINDEX(@occupation, @strBlank) = 0) THEN ('"' + @occupation + '"') ELSE 'NULL' END) + ', ' +
					 'perAgencyId=' + (CASE WHEN (@agency IS NOT NULL AND LEN(@agency) > 0 AND CHARINDEX(@agency, @strBlank) = 0) THEN ('"' + @agency + '"') ELSE 'NULL' END) + ', ' +
					 'agencyOther=' + (CASE WHEN (@agencyOther IS NOT NULL AND LEN(@agencyOther) > 0 AND CHARINDEX(@agencyOther, @strBlank) = 0) THEN ('"' + @agencyOther + '"') ELSE 'NULL' END) + ', ' +
					 'workplace=' + (CASE WHEN (@workplace IS NOT NULL AND LEN(@workplace) > 0 AND CHARINDEX(@workplace, @strBlank) = 0) THEN ('"' + @workplace + '"') ELSE 'NULL' END) + ', ' +
					 'position=' + (CASE WHEN (@position IS NOT NULL AND LEN(@position) > 0 AND CHARINDEX(@position, @strBlank) = 0) THEN ('"' + @position + '"') ELSE 'NULL' END) + ', ' +
					 'telephone=' + (CASE WHEN (@telephone IS NOT NULL AND LEN(@telephone) > 0 AND CHARINDEX(@telephone, @strBlank) = 0) THEN ('"' + @telephone + '"') ELSE 'NULL' END) + ', ' +
					 'salary=' + (CASE WHEN (@salary IS NOT NULL AND LEN(@salary) > 0 AND CHARINDEX(@salary, @strBlank) = 0) THEN ('"' + @salary + '"') ELSE 'NULL' END)
		
		BEGIN TRY
			BEGIN TRAN
				IF (@action = 'INSERT')
				BEGIN
 					INSERT INTO perWork
 					(
						perPersonId,
						occupation,
						perAgencyId,
						agencyOther,
						workplace,
						position,
						telephone,
						salary,
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
						CASE WHEN (@occupation IS NOT NULL AND LEN(@occupation) > 0 AND CHARINDEX(@occupation, @strBlank) = 0) THEN @occupation ELSE NULL END,
						CASE WHEN (@agency IS NOT NULL AND LEN(@agency) > 0 AND CHARINDEX(@agency, @strBlank) = 0) THEN @agency ELSE NULL END,
						CASE WHEN (@agencyOther IS NOT NULL AND LEN(@agencyOther) > 0 AND CHARINDEX(@agencyOther, @strBlank) = 0) THEN @agencyOther ELSE NULL END,
						CASE WHEN (@workplace IS NOT NULL AND LEN(@workplace) > 0 AND CHARINDEX(@workplace, @strBlank) = 0) THEN @workplace ELSE NULL END,
						CASE WHEN (@position IS NOT NULL AND LEN(@position) > 0 AND CHARINDEX(@position, @strBlank) = 0) THEN @position ELSE NULL END,
						CASE WHEN (@telephone IS NOT NULL AND LEN(@telephone) > 0 AND CHARINDEX(@telephone, @strBlank) = 0) THEN @telephone ELSE NULL END,
						CASE WHEN (@salary IS NOT NULL AND LEN(@salary) > 0 AND CHARINDEX(@salary, @strBlank) = 0) THEN @salary ELSE NULL END,
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
						SET @rowCountUpdate = (SELECT COUNT(perPersonId) FROM perWork WHERE perPersonId = @personId)
						
						IF (@rowCountUpdate > 0)
						BEGIN
							IF (@action = 'UPDATE')
							BEGIN
								UPDATE perWork SET
									occupation	= CASE WHEN (@occupation IS NOT NULL AND LEN(@occupation) > 0 AND CHARINDEX(@occupation, @strBlank) = 0) THEN @occupation ELSE (CASE WHEN (@occupation IS NOT NULL AND (LEN(@occupation) = 0 OR CHARINDEX(@occupation, @strBlank) > 0)) THEN NULL ELSE occupation END) END,
									perAgencyId	= CASE WHEN (@agency IS NOT NULL AND LEN(@agency) > 0 AND CHARINDEX(@agency, @strBlank) = 0) THEN @agency ELSE (CASE WHEN (@agency IS NOT NULL AND (LEN(@agency) = 0 OR CHARINDEX(@agency, @strBlank) > 0)) THEN NULL ELSE perAgencyId END) END,
									agencyOther = CASE WHEN (@agencyOther IS NOT NULL AND LEN(@agencyOther) > 0 AND CHARINDEX(@agencyOther, @strBlank) = 0) THEN @agencyOther ELSE (CASE WHEN (@agencyOther IS NOT NULL AND (LEN(@agencyOther) = 0 OR CHARINDEX(@agencyOther, @strBlank) > 0)) THEN NULL ELSE agencyOther END) END,
									workplace	= CASE WHEN (@workplace IS NOT NULL AND LEN(@workplace) > 0 AND CHARINDEX(@workplace, @strBlank) = 0) THEN @workplace ELSE (CASE WHEN (@workplace IS NOT NULL AND (LEN(@workplace) = 0 OR CHARINDEX(@workplace, @strBlank) > 0)) THEN NULL ELSE workplace END) END,
									position	= CASE WHEN (@position IS NOT NULL AND LEN(@position) > 0 AND CHARINDEX(@position, @strBlank) = 0) THEN @position ELSE (CASE WHEN (@position IS NOT NULL AND (LEN(@position) = 0 OR CHARINDEX(@position, @strBlank) > 0)) THEN NULL ELSE position END) END,
									telephone	= CASE WHEN (@telephone IS NOT NULL AND LEN(@telephone) > 0 AND CHARINDEX(@telephone, @strBlank) = 0) THEN @telephone ELSE (CASE WHEN (@telephone IS NOT NULL AND (LEN(@telephone) = 0 OR CHARINDEX(@telephone, @strBlank) > 0)) THEN NULL ELSE telephone END) END,
									salary		= CASE WHEN (@salary IS NOT NULL AND LEN(@salary) > 0 AND CHARINDEX(@salary, @strBlank) = 0) THEN @salary ELSE (CASE WHEN (@salary IS NOT NULL AND (LEN(@salary) = 0 OR CHARINDEX(@salary, @strBlank) > 0)) THEN NULL ELSE salary END) END,
									modifyDate	= GETDATE(),
									modifyBy	= CASE WHEN (@by IS NOT NULL AND LEN(@by) > 0 AND CHARINDEX(@by, @strBlank) = 0) THEN @by ELSE (CASE WHEN (@by IS NOT NULL AND (LEN(@by) = 0 OR CHARINDEX(@by, @strBlank) > 0)) THEN NULL ELSE modifyBy END) END,
									modifyIp	= CASE WHEN (@ip IS NOT NULL AND LEN(@ip) > 0 AND CHARINDEX(@ip, @strBlank) = 0) THEN @ip ELSE (CASE WHEN (@ip IS NOT NULL AND (LEN(@ip) = 0 OR CHARINDEX(@ip, @strBlank) > 0)) THEN NULL ELSE modifyIp END) END
								WHERE perPersonId = @personId	
							END
							
							IF (@action = 'DELETE')								
							BEGIN
								DELETE FROM perWork WHERE perPersonId = @personId
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
	
	EXEC sp_stdTransferStudentRecordsToMUStudent
		@personId = @personId	
END
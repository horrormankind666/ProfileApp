USE [MUStudent]
GO
/****** Object:  StoredProcedure [dbo].[sp_perSetListWork]    Script Date: 03/27/2014 11:52:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๙/๑๒/๒๕๕๖>
-- Description	: <สำหรับบันทึกข้อมูลตาราง perWork ครั้งละหลายเรคคอร์ด>
--  1. order		เป็น VARCHAR	รับค่าลำดับของเรคคอร์ด
--  2. perPersonId 	เป็น VARCHAR	รับค่ารหัสบุคคล
--  3. occupation	เป็น VARCHAR	รับค่าอาชีพ
--  4. perAgencyId	เป็น VARCHAR	รับค่ารหัสต้นสังกัด
--  5. agencyOther	เป็น NVARCHAR	รับค่าต้นสังกัดอื่น ๆ
--  6. workplace	เป็น NVARCHAR	รับค่าชื่อสถานที่ทำงาน
--  7. position		เป็น NVARCHAR	รับค่าชื่อตำแหน่ง
--  8. telephone	เป็น NVARCHAR	รับค่าหมายเลขโทรศัพท์ที่ทำงาน
--  9. salary		เป็น VARCHAR	รับค่าเงินเดือน
-- 10. by			เป็น NVARCHAR	รับค่าชื่อของผู้ที่กระทำกับฐานข้อมูล
-- =============================================
ALTER PROCEDURE [dbo].[sp_perSetListWork]
(
	@order VARCHAR(MAX) = NULL,
	@perPersonId VARCHAR(MAX) = NULL,
	@occupation VARCHAR(MAX) = NULL,
	@perAgencyId VARCHAR(MAX) = NULL,
	@agencyOther NVARCHAR(MAX) = NULL,
	@workplace NVARCHAR(MAX) = NULL,
	@position NVARCHAR(MAX) = NULL,
	@telephone NVARCHAR(MAX) = NULL,
	@salary VARCHAR(MAX) = NULL,
	@by NVARCHAR(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	
	SET @order = LTRIM(RTRIM(@order))
	SET @perPersonId = LTRIM(RTRIM(@perPersonId))
	SET @occupation = LTRIM(RTRIM(@occupation))
	SET @perAgencyId = LTRIM(RTRIM(@perAgencyId))
	SET @agencyOther = LTRIM(RTRIM(@agencyOther))
	SET @workplace = LTRIM(RTRIM(@workplace))
	SET @position = LTRIM(RTRIM(@position))
	SET @telephone = LTRIM(RTRIM(@telephone))
	SET @salary = LTRIM(RTRIM(@salary))	
	SET @by = LTRIM(RTRIM(@by))
	
	DECLARE @action VARCHAR(10) = 'INSERT'
	DECLARE @table VARCHAR(50) = 'perWork'
	DECLARE @i INT = 1
	DECLARE @delimiter CHAR(1) = ';'
	DECLARE @orderSlice VARCHAR(MAX) = NULL
	DECLARE @perPersonIdSlice VARCHAR(MAX) = NULL
	DECLARE @occupationSlice VARCHAR(MAX) = NULL
	DECLARE @perAgencyIdSlice VARCHAR(MAX) = NULL
	DECLARE @agencyOtherSlice NVARCHAR(MAX) = NULL
	DECLARE @workplaceSlice NVARCHAR(MAX) = NULL
	DECLARE @positionSlice NVARCHAR(MAX) = NULL
	DECLARE @telephoneSlice NVARCHAR(MAX) = NULL
	DECLARE @salarySlice VARCHAR(MAX) = NULL
	DECLARE @rowCount INT = 0
	DECLARE @value NVARCHAR(MAX) = NULL
	DECLARE	@strBlank VARCHAR(50) = '----------**********.........0.0000000000000000000'
	DECLARE @ip VARCHAR(255) = dbo.fnc_perGetIP()
	
	WHILE (LEN(@order) > 0)
	BEGIN
		SET @orderSlice = (SELECT stringSlice FROM fnc_perParseString(@order, @delimiter))
		SET @order = (SELECT string FROM fnc_perParseString(@order, @delimiter))
		
		SET @perPersonIdSlice = (SELECT stringSlice FROM fnc_perParseString(@perPersonId, @delimiter))
		SET @perPersonId = (SELECT string FROM fnc_perParseString(@perPersonId, @delimiter))
		
		SET @occupationSlice = (SELECT stringSlice FROM fnc_perParseString(@occupation, @delimiter))
		SET @occupation = (SELECT string FROM fnc_perParseString(@occupation, @delimiter))
		
		SET @perAgencyIdSlice = (SELECT stringSlice FROM fnc_perParseString(@perAgencyId, @delimiter))
		SET @perAgencyId = (SELECT string FROM fnc_perParseString(@perAgencyId, @delimiter))

		SET @agencyOtherSlice = (SELECT stringSlice FROM fnc_perParseString(@agencyOther, @delimiter))
		SET @agencyOther = (SELECT string FROM fnc_perParseString(@agencyOther, @delimiter))

		SET @workplaceSlice = (SELECT stringSlice FROM fnc_perParseString(@workplace, @delimiter))
		SET @workplace = (SELECT string FROM fnc_perParseString(@workplace, @delimiter))

		SET @positionSlice = (SELECT stringSlice FROM fnc_perParseString(@position, @delimiter))
		SET @position = (SELECT string FROM fnc_perParseString(@position, @delimiter))

		SET @telephoneSlice = (SELECT stringSlice FROM fnc_perParseString(@telephone, @delimiter))
		SET @telephone = (SELECT string FROM fnc_perParseString(@telephone, @delimiter))

		SET @salarySlice = (SELECT stringSlice FROM fnc_perParseString(@salary, @delimiter))
		SET @salary = (SELECT string FROM fnc_perParseString(@salary, @delimiter))

		IF (LEN(@orderSlice) > 0)
		BEGIN			
			SET @value = 'perPersonId=' + (CASE WHEN (@perPersonIdSlice IS NOT NULL AND LEN(@perPersonIdSlice) > 0 AND CHARINDEX(@perPersonIdSlice, @strBlank) = 0) THEN ('"' + @perPersonIdSlice + '"') ELSE 'NULL' END) + ', ' +
						 'occupation=' + (CASE WHEN (@occupationSlice IS NOT NULL AND LEN(@occupationSlice) > 0 AND CHARINDEX(@occupationSlice, @strBlank) = 0) THEN ('"' + @occupationSlice + '"') ELSE 'NULL' END) + ', ' +
						 'perAgencyId=' + (CASE WHEN (@perAgencyIdSlice IS NOT NULL AND LEN(@perAgencyIdSlice) > 0 AND CHARINDEX(@perAgencyIdSlice, @strBlank) = 0) THEN ('"' + @perAgencyIdSlice + '"') ELSE 'NULL' END) + ', ' +
						 'agencyOther=' + (CASE WHEN (@agencyOtherSlice IS NOT NULL AND LEN(@agencyOtherSlice) > 0 AND CHARINDEX(@agencyOtherSlice, @strBlank) = 0) THEN ('"' + @agencyOtherSlice + '"') ELSE 'NULL' END) + ', ' +
						 'workplace=' + (CASE WHEN (@workplaceSlice IS NOT NULL AND LEN(@workplaceSlice) > 0 AND CHARINDEX(@workplaceSlice, @strBlank) = 0) THEN ('"' + @workplaceSlice + '"') ELSE 'NULL' END) + ', ' +
						 'position=' + (CASE WHEN (@positionSlice IS NOT NULL AND LEN(@positionSlice) > 0 AND CHARINDEX(@positionSlice, @strBlank) = 0) THEN ('"' + @positionSlice + '"') ELSE 'NULL' END) + ', ' +
						 'telephone=' + (CASE WHEN (@telephoneSlice IS NOT NULL AND LEN(@telephoneSlice) > 0 AND CHARINDEX(@telephoneSlice, @strBlank) = 0) THEN ('"' + @telephoneSlice + '"') ELSE 'NULL' END) + ', ' +
						 'salary=' + (CASE WHEN (@salarySlice IS NOT NULL AND LEN(@salarySlice) > 0 AND CHARINDEX(@salarySlice, @strBlank) = 0) THEN ('"' + @salarySlice + '"') ELSE 'NULL' END)

			BEGIN TRY
				BEGIN TRAN	
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
						CASE WHEN (@perPersonIdSlice IS NOT NULL AND LEN(@perPersonIdSlice) > 0 AND CHARINDEX(@perPersonIdSlice, @strBlank) = 0) THEN @perPersonIdSlice ELSE NULL END,
						CASE WHEN (@occupationSlice IS NOT NULL AND LEN(@occupationSlice) > 0 AND CHARINDEX(@occupationSlice, @strBlank) = 0) THEN @occupationSlice ELSE NULL END,
						CASE WHEN (@perAgencyIdSlice IS NOT NULL AND LEN(@perAgencyIdSlice) > 0 AND CHARINDEX(@perAgencyIdSlice, @strBlank) = 0) THEN @perAgencyIdSlice ELSE NULL END,
						CASE WHEN (@agencyOtherSlice IS NOT NULL AND LEN(@agencyOtherSlice) > 0 AND CHARINDEX(@agencyOtherSlice, @strBlank) = 0) THEN @agencyOtherSlice ELSE NULL END,
						CASE WHEN (@workplaceSlice IS NOT NULL AND LEN(@workplaceSlice) > 0 AND CHARINDEX(@workplaceSlice, @strBlank) = 0) THEN @workplaceSlice ELSE NULL END,
						CASE WHEN (@positionSlice IS NOT NULL AND LEN(@positionSlice) > 0 AND CHARINDEX(@positionSlice, @strBlank) = 0) THEN @positionSlice ELSE NULL END,
						CASE WHEN (@telephoneSlice IS NOT NULL AND LEN(@telephoneSlice) > 0 AND CHARINDEX(@telephoneSlice, @strBlank) = 0) THEN @telephoneSlice ELSE NULL END,
						CASE WHEN (@salarySlice IS NOT NULL AND LEN(@salarySlice) > 0 AND CHARINDEX(@salarySlice, @strBlank) = 0) THEN @salarySlice ELSE NULL END,
						GETDATE(),
						CASE WHEN (@by IS NOT NULL AND LEN(@by) > 0 AND CHARINDEX(@by, @strBlank) = 0) THEN @by ELSE NULL END,
						@ip,
						NULL,
						NULL,
						NULL
					)
				COMMIT TRAN
				SET @rowCount = @rowCount + 1
			END TRY
			BEGIN CATCH
				ROLLBACK TRAN
				INSERT INTO perErrorLog
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
	END
	
	SELECT @rowCount	
END

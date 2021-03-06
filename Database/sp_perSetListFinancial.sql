USE [MUStudent]
GO
/****** Object:  StoredProcedure [dbo].[sp_perSetListFinancial]    Script Date: 03/27/2014 11:49:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๘/๑๒/๒๕๕๖>
-- Description	: <สำหรับบันทึกข้อมูลตาราง perFinancial ครั้งละหลายเรคคอร์ด>
--  1. order							เป็น VARCHAR	รับค่าลำดับของเรคคอร์ด
--  2. perPersonId						เป็น VARCHAR	รับค่ารหัสบุคคล
--  3. scholarshipFirstBachelor			เป็น VARCHAR	รับค่าก่อนศึกษาระดับปริญญาตรีเคยได้รับทุนการศึกษาหรือไม่
--  4. scholarshipFirstBachelorFrom		เป็น VARCHAR	รับค่าก่อนศึกษาระดับปริญญาตรีเคยได้รับทุนการศึกษาจาก
--  5. scholarshipFirstBachelorName		เป็น NVARCHAR	รับค่าก่อนศึกษาระดับปริญญาตรีเคยได้รับทุนการศึกษาชื่อ
--  6. scholarshipFirstBachelorMoney	เป็น VARCHAR	รับค่าก่อนศึกษาระดับปริญญาตรีเคยได้รับทุนการศึกษาจำนวนเงิน
--  7. scholarshipBachelor				เป็น VARCHAR	รับค่าระหว่างศึกษาระดับปริญญาตรีเคยได้รับทุนการศึกษาหรือไม่
--  8. scholarshipBachelorFrom			เป็น VARCHAR	รับค่าระหว่างศึกษาระดับปริญญาตรีเคยได้รับทุนการศึกษาจาก
--  9. scholarshipBachelorName			เป็น NVARCHAR	รับค่าระหว่างศึกษาระดับปริญญาตรีเคยได้รับทุนการศึกษาชื่อ
-- 10. scholarshipBachelorMoney			เป็น VARCHAR	รับค่าระหว่างศึกษาระดับปริญญาตรีเคยได้รับทุนการศึกษาจำนวนเงิน
-- 11. worked							เป็น VARCHAR	รับค่าเคยทำงานหรือไม่
-- 12. salary							เป็น VARCHAR	รับค่าเคยทำงานได้รับเงินเดือนเท่าไร
-- 13. workplace						เป็น NVARCHAR	รับค่าสถานที่ที่เคยทำงาน
-- 14. gotMoneyFrom						เป็น VARCHAR	รับค่าได้รับการอุปการะด้านรายได้จาก
-- 14. gotMoneyFromOther				เป็น NVARCHAR	รับค่าได้รับการอุปการะด้านรายได้จากที่อื่น ๆ
-- 15. gotMoneyPerMonth					เป็น VARCHAR	รับค่าได้รับการอุปการะด้านรายได้ต่อเดือนเท่าไร
-- 16. costPerMonth						เป็น VARCHAR	รับค่ามีค่าใช้จ่ายต่อเดือนเท่าไร
-- 17. by								เป็น NVARCHAR	รับค่าชื่อของผู้ที่กระทำกับฐานข้อมูล
-- =============================================
ALTER PROCEDURE [dbo].[sp_perSetListFinancial]
(
	@order VARCHAR(MAX) = NULL,
	@perPersonId VARCHAR(MAX) = NULL,
	@scholarshipFirstBachelor VARCHAR(MAX) = NULL,
	@scholarshipFirstBachelorFrom VARCHAR(MAX) = NULL,
	@scholarshipFirstBachelorName NVARCHAR(MAX) = NULL,
	@scholarshipFirstBachelorMoney VARCHAR(MAX) = NULL,
	@scholarshipBachelor VARCHAR(MAX) = NULL,
	@scholarshipBachelorFrom VARCHAR(MAX) = NULL,
	@scholarshipBachelorName NVARCHAR(MAX) = NULL,
	@scholarshipBachelorMoney VARCHAR(MAX) = NULL,
	@worked VARCHAR(MAX) = NULL,
	@salary VARCHAR(MAX) = NULL,
	@workplace NVARCHAR(MAX) = NULL,
	@gotMoneyFrom VARCHAR(MAX) = NULL,
	@gotMoneyFromOther NVARCHAR(MAX) = NULL,
	@gotMoneyPerMonth VARCHAR(MAX) = NULL,
	@costPerMonth VARCHAR(MAX) = NULL,
	@by NVARCHAR(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	
	SET @order = LTRIM(RTRIM(@order))
	SET @perPersonId = LTRIM(RTRIM(@perPersonId))
	SET @scholarshipFirstBachelor = LTRIM(RTRIM(@scholarshipFirstBachelor))
	SET @scholarshipFirstBachelorFrom = LTRIM(RTRIM(@scholarshipFirstBachelorFrom))
	SET @scholarshipFirstBachelorName = LTRIM(RTRIM(@scholarshipFirstBachelorName))
	SET @scholarshipFirstBachelorMoney = LTRIM(RTRIM(@scholarshipFirstBachelorMoney))
	SET @scholarshipBachelor = LTRIM(RTRIM(@scholarshipBachelor))
	SET @scholarshipBachelorFrom = LTRIM(RTRIM(@scholarshipBachelorFrom))
	SET @scholarshipBachelorName = LTRIM(RTRIM(@scholarshipBachelorName))
	SET @scholarshipBachelorMoney = LTRIM(RTRIM(@scholarshipBachelorMoney))
	SET @worked = LTRIM(RTRIM(@worked))
	SET @salary = LTRIM(RTRIM(@salary))
	SET @workplace = LTRIM(RTRIM(@workplace))
	SET @gotMoneyFrom = LTRIM(RTRIM(@gotMoneyFrom))
	SET @gotMoneyFromOther = LTRIM(RTRIM(@gotMoneyFromOther))
	SET @gotMoneyPerMonth = LTRIM(RTRIM(@gotMoneyPerMonth))
	SET @costPerMonth = LTRIM(RTRIM(@costPerMonth))	
	SET @by = LTRIM(RTRIM(@by))
	
	DECLARE @action VARCHAR(10) = 'INSERT'
	DECLARE @table VARCHAR(50) = 'perFinancial'
	DECLARE @i INT = 1
	DECLARE @delimiter CHAR(1) = ';'
	DECLARE @orderSlice VARCHAR(MAX) = NULL
	DECLARE @perPersonIdSlice VARCHAR(MAX) = NULL
	DECLARE @scholarshipFirstBachelorSlice VARCHAR(MAX) = NULL
	DECLARE @scholarshipFirstBachelorFromSlice VARCHAR(MAX) = NULL
	DECLARE @scholarshipFirstBachelorNameSlice NVARCHAR(MAX) = NULL
	DECLARE @scholarshipFirstBachelorMoneySlice VARCHAR(MAX) = NULL
	DECLARE @scholarshipBachelorSlice VARCHAR(MAX) = NULL
	DECLARE @scholarshipBachelorFromSlice VARCHAR(MAX) = NULL
	DECLARE @scholarshipBachelorNameSlice NVARCHAR(MAX) = NULL
	DECLARE @scholarshipBachelorMoneySlice VARCHAR(MAX) = NULL
	DECLARE @workedSlice VARCHAR(MAX) = NULL
	DECLARE @salarySlice VARCHAR(MAX) = NULL
	DECLARE @workplaceSlice NVARCHAR(MAX) = NULL
	DECLARE @gotMoneyFromSlice VARCHAR(MAX) = NULL
	DECLARE @gotMoneyFromOtherSlice NVARCHAR(MAX) = NULL
	DECLARE @gotMoneyPerMonthSlice VARCHAR(MAX) = NULL
	DECLARE @costPerMonthSlice VARCHAR(MAX) = NULL
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
		
		SET @scholarshipFirstBachelorSlice = (SELECT stringSlice FROM fnc_perParseString(@scholarshipFirstBachelor, @delimiter))
		SET @scholarshipFirstBachelor = (SELECT string FROM fnc_perParseString(@scholarshipFirstBachelor, @delimiter))

		SET @scholarshipFirstBachelorFromSlice = (SELECT stringSlice FROM fnc_perParseString(@scholarshipFirstBachelorFrom, @delimiter))
		SET @scholarshipFirstBachelorFrom = (SELECT string FROM fnc_perParseString(@scholarshipFirstBachelorFrom, @delimiter))
		
		SET @scholarshipFirstBachelorNameSlice = (SELECT stringSlice FROM fnc_perParseString(@scholarshipFirstBachelorName, @delimiter))
		SET @scholarshipFirstBachelorName = (SELECT string FROM fnc_perParseString(@scholarshipFirstBachelorName, @delimiter))

		SET @scholarshipFirstBachelorMoneySlice = (SELECT stringSlice FROM fnc_perParseString(@scholarshipFirstBachelorMoney, @delimiter))
		SET @scholarshipFirstBachelorMoney = (SELECT string FROM fnc_perParseString(@scholarshipFirstBachelorMoney, @delimiter))

		SET @scholarshipBachelorSlice = (SELECT stringSlice FROM fnc_perParseString(@scholarshipBachelor, @delimiter))
		SET @scholarshipBachelor = (SELECT string FROM fnc_perParseString(@scholarshipBachelor, @delimiter))

		SET @scholarshipBachelorFromSlice = (SELECT stringSlice FROM fnc_perParseString(@scholarshipBachelorFrom, @delimiter))
		SET @scholarshipBachelorFrom = (SELECT string FROM fnc_perParseString(@scholarshipBachelorFrom, @delimiter))

		SET @scholarshipBachelorNameSlice = (SELECT stringSlice FROM fnc_perParseString(@scholarshipBachelorName, @delimiter))
		SET @scholarshipBachelorName = (SELECT string FROM fnc_perParseString(@scholarshipBachelorName, @delimiter))

		SET @scholarshipBachelorMoneySlice = (SELECT stringSlice FROM fnc_perParseString(@scholarshipBachelorMoney, @delimiter))
		SET @scholarshipBachelorMoney = (SELECT string FROM fnc_perParseString(@scholarshipBachelorMoney, @delimiter))

		SET @workedSlice = (SELECT stringSlice FROM fnc_perParseString(@worked, @delimiter))
		SET @worked = (SELECT string FROM fnc_perParseString(@worked, @delimiter))

		SET @salarySlice = (SELECT stringSlice FROM fnc_perParseString(@salary, @delimiter))
		SET @salary = (SELECT string FROM fnc_perParseString(@salary, @delimiter))

		SET @workplaceSlice = (SELECT stringSlice FROM fnc_perParseString(@workplace, @delimiter))
		SET @workplace = (SELECT string FROM fnc_perParseString(@workplace, @delimiter))

		SET @gotMoneyFromSlice = (SELECT stringSlice FROM fnc_perParseString(@gotMoneyFrom, @delimiter))
		SET @gotMoneyFrom = (SELECT string FROM fnc_perParseString(@gotMoneyFrom, @delimiter))

		SET @gotMoneyFromOtherSlice = (SELECT stringSlice FROM fnc_perParseString(@gotMoneyFromOther, @delimiter))
		SET @gotMoneyFromOther = (SELECT string FROM fnc_perParseString(@gotMoneyFromOther, @delimiter))

		SET @gotMoneyPerMonthSlice = (SELECT stringSlice FROM fnc_perParseString(@gotMoneyPerMonth, @delimiter))
		SET @gotMoneyPerMonth = (SELECT string FROM fnc_perParseString(@gotMoneyPerMonth, @delimiter))

		SET @costPerMonthSlice = (SELECT stringSlice FROM fnc_perParseString(@costPerMonth, @delimiter))
		SET @costPerMonth = (SELECT string FROM fnc_perParseString(@costPerMonth, @delimiter))

		IF (LEN(@orderSlice) > 0)
		BEGIN			
			SET @value = 'perPersonId=' + (CASE WHEN (@perPersonIdSlice IS NOT NULL AND LEN(@perPersonIdSlice) > 0 AND CHARINDEX(@perPersonIdSlice, @strBlank) = 0) THEN ('"' + @perPersonIdSlice + '"') ELSE 'NULL' END) + ', ' +
						 'scholarshipFirstBachelor=' + (CASE WHEN (@scholarshipFirstBachelorSlice IS NOT NULL AND LEN(@scholarshipFirstBachelorSlice) > 0 AND CHARINDEX(@scholarshipFirstBachelorSlice, @strBlank) = 0) THEN ('"' + @scholarshipFirstBachelorSlice + '"') ELSE 'NULL' END) + ', ' +
						 'scholarshipFirstBachelorFrom=' + (CASE WHEN (@scholarshipFirstBachelorFromSlice IS NOT NULL AND LEN(@scholarshipFirstBachelorFromSlice) > 0 AND CHARINDEX(@scholarshipFirstBachelorFromSlice, @strBlank) = 0) THEN ('"' + @scholarshipFirstBachelorFromSlice + '"') ELSE 'NULL' END) + ', ' +
						 'scholarshipFirstBachelorName=' + (CASE WHEN (@scholarshipFirstBachelorNameSlice IS NOT NULL AND LEN(@scholarshipFirstBachelorNameSlice) > 0 AND CHARINDEX(@scholarshipFirstBachelorNameSlice, @strBlank) = 0) THEN ('"' + @scholarshipFirstBachelorNameSlice + '"') ELSE 'NULL' END) + ', ' +
						 'scholarshipFirstBachelorMoney=' + (CASE WHEN (@scholarshipFirstBachelorMoneySlice IS NOT NULL AND LEN(@scholarshipFirstBachelorMoneySlice) > 0 AND CHARINDEX(@scholarshipFirstBachelorMoneySlice, @strBlank) = 0) THEN ('"' + @scholarshipFirstBachelorMoneySlice + '"') ELSE 'NULL' END) + ', ' +
						 'scholarshipBachelor=' + (CASE WHEN (@scholarshipBachelorSlice IS NOT NULL AND LEN(@scholarshipBachelorSlice) > 0 AND CHARINDEX(@scholarshipBachelorSlice, @strBlank) = 0) THEN ('"' + @scholarshipBachelorSlice + '"') ELSE 'NULL' END) + ', ' +
						 'scholarshipBachelorFrom=' + (CASE WHEN (@scholarshipBachelorFromSlice IS NOT NULL AND LEN(@scholarshipBachelorFromSlice) > 0 AND CHARINDEX(@scholarshipBachelorFromSlice, @strBlank) = 0) THEN ('"' + @scholarshipBachelorFromSlice + '"') ELSE 'NULL' END) + ', ' +
						 'scholarshipBachelorName=' + (CASE WHEN (@scholarshipBachelorNameSlice IS NOT NULL AND LEN(@scholarshipBachelorNameSlice) > 0 AND CHARINDEX(@scholarshipBachelorNameSlice, @strBlank) = 0) THEN ('"' + @scholarshipBachelorNameSlice + '"') ELSE 'NULL' END) + ', ' +
						 'scholarshipBachelorMoney=' + (CASE WHEN (@scholarshipBachelorMoneySlice IS NOT NULL AND LEN(@scholarshipBachelorMoneySlice) > 0 AND CHARINDEX(@scholarshipBachelorMoneySlice, @strBlank) = 0) THEN ('"' + @scholarshipBachelorMoneySlice + '"') ELSE 'NULL' END) + ', ' +
						 'worked=' + (CASE WHEN (@workedSlice IS NOT NULL AND LEN(@workedSlice) > 0 AND CHARINDEX(@workedSlice, @strBlank) = 0) THEN ('"' + @workedSlice + '"') ELSE 'NULL' END) + ', ' +
						 'salary=' + (CASE WHEN (@salarySlice IS NOT NULL AND LEN(@salarySlice) > 0 AND CHARINDEX(@salarySlice, @strBlank) = 0) THEN ('"' + @salarySlice + '"') ELSE 'NULL' END) + ', ' +
						 'workplace=' + (CASE WHEN (@workplaceSlice IS NOT NULL AND LEN(@workplaceSlice) > 0 AND CHARINDEX(@workplaceSlice, @strBlank) = 0) THEN ('"' + @workplaceSlice + '"') ELSE 'NULL' END) + ', ' +					 
						 'gotMoneyFrom=' + (CASE WHEN (@gotMoneyFromSlice IS NOT NULL AND LEN(@gotMoneyFromSlice) > 0 AND CHARINDEX(@gotMoneyFromSlice, @strBlank) = 0) THEN ('"' + @gotMoneyFromSlice + '"') ELSE 'NULL' END) + ', ' +
						 'gotMoneyFromOther=' + (CASE WHEN (@gotMoneyFromOtherSlice IS NOT NULL AND LEN(@gotMoneyFromOtherSlice) > 0 AND CHARINDEX(@gotMoneyFromOtherSlice, @strBlank) = 0) THEN ('"' + @gotMoneyFromOtherSlice + '"') ELSE 'NULL' END) + ', ' +
						 'gotMoneyPerMonth=' + (CASE WHEN (@gotMoneyPerMonthSlice IS NOT NULL AND LEN(@gotMoneyPerMonthSlice) > 0 AND CHARINDEX(@gotMoneyPerMonthSlice, @strBlank) = 0) THEN ('"' + @gotMoneyPerMonthSlice + '"') ELSE 'NULL' END) + ', ' +
						 'costPerMonth=' + (CASE WHEN (@costPerMonthSlice IS NOT NULL AND LEN(@costPerMonthSlice) > 0 AND CHARINDEX(@costPerMonthSlice, @strBlank) = 0) THEN ('"' + @costPerMonthSlice + '"') ELSE 'NULL' END)

			BEGIN TRY
				BEGIN TRAN	
					INSERT INTO perFinancial
					(
						perPersonId,
						scholarshipFirstBachelor,
						scholarshipFirstBachelorFrom,
						scholarshipFirstBachelorName,
						scholarshipFirstBachelorMoney,
						scholarshipBachelor,
						scholarshipBachelorFrom,
						scholarshipBachelorName,
						scholarshipBachelorMoney,
						worked,
						salary,
						workplace,
						gotMoneyFrom,
						gotMoneyFromOther,
						gotMoneyPerMonth,
						costPerMonth,
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
						CASE WHEN (@scholarshipFirstBachelorSlice IS NOT NULL AND LEN(@scholarshipFirstBachelorSlice) > 0 AND CHARINDEX(@scholarshipFirstBachelorSlice, @strBlank) = 0) THEN @scholarshipFirstBachelorSlice ELSE NULL END,
						CASE WHEN (@scholarshipFirstBachelorFromSlice IS NOT NULL AND LEN(@scholarshipFirstBachelorFromSlice) > 0 AND CHARINDEX(@scholarshipFirstBachelorFromSlice, @strBlank) = 0) THEN @scholarshipFirstBachelorFromSlice ELSE NULL END,
						CASE WHEN (@scholarshipFirstBachelorNameSlice IS NOT NULL AND LEN(@scholarshipFirstBachelorNameSlice) > 0 AND CHARINDEX(@scholarshipFirstBachelorNameSlice, @strBlank) = 0) THEN @scholarshipFirstBachelorNameSlice ELSE NULL END,
						CASE WHEN (@scholarshipFirstBachelorMoneySlice IS NOT NULL AND LEN(@scholarshipFirstBachelorMoneySlice) > 0 AND CHARINDEX(@scholarshipFirstBachelorMoneySlice, @strBlank) = 0) THEN @scholarshipFirstBachelorMoneySlice ELSE NULL END,
						CASE WHEN (@scholarshipBachelorSlice IS NOT NULL AND LEN(@scholarshipBachelorSlice) > 0 AND CHARINDEX(@scholarshipBachelorSlice, @strBlank) = 0) THEN @scholarshipBachelorSlice ELSE NULL END,
						CASE WHEN (@scholarshipBachelorFromSlice IS NOT NULL AND LEN(@scholarshipBachelorFromSlice) > 0 AND CHARINDEX(@scholarshipBachelorFromSlice, @strBlank) = 0) THEN @scholarshipBachelorFromSlice ELSE NULL END,
						CASE WHEN (@scholarshipBachelorNameSlice IS NOT NULL AND LEN(@scholarshipBachelorNameSlice) > 0 AND CHARINDEX(@scholarshipBachelorNameSlice, @strBlank) = 0) THEN @scholarshipBachelorNameSlice ELSE NULL END,
						CASE WHEN (@scholarshipBachelorMoneySlice IS NOT NULL AND LEN(@scholarshipBachelorMoneySlice) > 0 AND CHARINDEX(@scholarshipBachelorMoneySlice, @strBlank) = 0) THEN @scholarshipBachelorMoneySlice ELSE NULL END,
						CASE WHEN (@workedSlice IS NOT NULL AND LEN(@workedSlice) > 0 AND CHARINDEX(@workedSlice, @strBlank) = 0) THEN @workedSlice ELSE NULL END,
						CASE WHEN (@salarySlice IS NOT NULL AND LEN(@salarySlice) > 0 AND CHARINDEX(@salarySlice, @strBlank) = 0) THEN @salarySlice ELSE NULL END,
						CASE WHEN (@workplaceSlice IS NOT NULL AND LEN(@workplaceSlice) > 0 AND CHARINDEX(@workplaceSlice, @strBlank) = 0) THEN @workplaceSlice ELSE NULL END,
						CASE WHEN (@gotMoneyFromSlice IS NOT NULL AND LEN(@gotMoneyFromSlice) > 0 AND CHARINDEX(@gotMoneyFromSlice, @strBlank) = 0) THEN @gotMoneyFromSlice ELSE NULL END,
						CASE WHEN (@gotMoneyFromOtherSlice IS NOT NULL AND LEN(@gotMoneyFromOtherSlice) > 0 AND CHARINDEX(@gotMoneyFromOtherSlice, @strBlank) = 0) THEN @gotMoneyFromOtherSlice ELSE NULL END,
						CASE WHEN (@gotMoneyPerMonthSlice IS NOT NULL AND LEN(@gotMoneyPerMonthSlice) > 0 AND CHARINDEX(@gotMoneyPerMonthSlice, @strBlank) = 0) THEN @gotMoneyPerMonthSlice ELSE NULL END,
						CASE WHEN (@costPerMonthSlice IS NOT NULL AND LEN(@costPerMonthSlice) > 0 AND CHARINDEX(@costPerMonthSlice, @strBlank) = 0) THEN @costPerMonthSlice ELSE NULL END,
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

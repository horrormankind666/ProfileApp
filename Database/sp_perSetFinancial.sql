USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_perSetFinancial]    Script Date: 11/16/2015 16:30:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๗/๑๒/๒๕๕๖>
-- Description	: <สำหรับบันทึกข้อมูลตาราง perFinancial ครั้งละ ๑ เรคคอร์ด>
--  1. action							เป็น VARCHAR	รับค่าการกระทำกับฐานข้อมูล
--  2. personId							เป็น VARCHAR	รับค่ารหัสบุคคล
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
-- 18. ip								เป็น VARCHAR	รับค่าหมายเลขไอพีของผู้ที่กระทำกับฐานข้อมูล
-- =============================================
ALTER PROCEDURE [dbo].[sp_perSetFinancial]
(
	@action VARCHAR(10) = NULL,
	@personId VARCHAR(10) = NULL,
	@scholarshipFirstBachelor VARCHAR(1) = NULL,
	@scholarshipFirstBachelorFrom VARCHAR(2) = NULL,
	@scholarshipFirstBachelorName NVARCHAR(255) = NULL,
	@scholarshipFirstBachelorMoney VARCHAR(20) = NULL,
	@scholarshipBachelor VARCHAR(1) = NULL,
	@scholarshipBachelorFrom VARCHAR(2) = NULL,
	@scholarshipBachelorName NVARCHAR(255) = NULL,
	@scholarshipBachelorMoney VARCHAR(20) = NULL,
	@worked VARCHAR(1) = NULL,
	@salary VARCHAR(20) = NULL,
	@workplace NVARCHAR(255) = NULL,
	@gotMoneyFrom VARCHAR(2) = NULL,
	@gotMoneyFromOther NVARCHAR(255) = NULL,
	@gotMoneyPerMonth VARCHAR(20) = NULL,
	@costPerMonth VARCHAR(20) = NULL,
	@by NVARCHAR(255) = NULL,
	@ip VARCHAR(255) = NULL
)	
AS
BEGIN
	SET NOCOUNT ON
	
	SET @action = LTRIM(RTRIM(@action))
	SET @personId = LTRIM(RTRIM(@personId))
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
	SET @ip = LTRIM(RTRIM(@ip))
	
	DECLARE @table VARCHAR(50) = 'perFinancial'
	DECLARE @rowCount INT = 0
	DECLARE @rowCountUpdate INT = 0
	DECLARE @value NVARCHAR(MAX) = NULL
	DECLARE	@strBlank VARCHAR(50) = '----------**********.........0.0000000000000000000'
		
	SET @action = UPPER(@action)	
	
	IF (@action = 'INSERT' OR @action = 'UPDATE' OR @action = 'DELETE')
	BEGIN
		SET @value = 'perPersonId=' + (CASE WHEN (@personId IS NOT NULL AND LEN(@personId) > 0 AND CHARINDEX(@personId, @strBlank) = 0) THEN ('"' + @personId + '"') ELSE 'NULL' END) + ', ' +
					 'scholarshipFirstBachelor=' + (CASE WHEN (@scholarshipFirstBachelor IS NOT NULL AND LEN(@scholarshipFirstBachelor) > 0 AND CHARINDEX(@scholarshipFirstBachelor, @strBlank) = 0) THEN ('"' + @scholarshipFirstBachelor + '"') ELSE 'NULL' END) + ', ' +
					 'scholarshipFirstBachelorFrom=' + (CASE WHEN (@scholarshipFirstBachelorFrom IS NOT NULL AND LEN(@scholarshipFirstBachelorFrom) > 0 AND CHARINDEX(@scholarshipFirstBachelorFrom, @strBlank) = 0) THEN ('"' + @scholarshipFirstBachelorFrom + '"') ELSE 'NULL' END) + ', ' +
					 'scholarshipFirstBachelorName=' + (CASE WHEN (@scholarshipFirstBachelorName IS NOT NULL AND LEN(@scholarshipFirstBachelorName) > 0 AND CHARINDEX(@scholarshipFirstBachelorName, @strBlank) = 0) THEN ('"' + @scholarshipFirstBachelorName + '"') ELSE 'NULL' END) + ', ' +
					 'scholarshipFirstBachelorMoney=' + (CASE WHEN (@scholarshipFirstBachelorMoney IS NOT NULL AND LEN(@scholarshipFirstBachelorMoney) > 0 AND CHARINDEX(@scholarshipFirstBachelorMoney, @strBlank) = 0) THEN ('"' + @scholarshipFirstBachelorMoney + '"') ELSE 'NULL' END) + ', ' +
					 'scholarshipBachelor=' + (CASE WHEN (@scholarshipBachelor IS NOT NULL AND LEN(@scholarshipBachelor) > 0 AND CHARINDEX(@scholarshipBachelor, @strBlank) = 0) THEN ('"' + @scholarshipBachelor + '"') ELSE 'NULL' END) + ', ' +
					 'scholarshipBachelorFrom=' + (CASE WHEN (@scholarshipBachelorFrom IS NOT NULL AND LEN(@scholarshipBachelorFrom) > 0 AND CHARINDEX(@scholarshipBachelorFrom, @strBlank) = 0) THEN ('"' + @scholarshipBachelorFrom + '"') ELSE 'NULL' END) + ', ' +
					 'scholarshipBachelorName=' + (CASE WHEN (@scholarshipBachelorName IS NOT NULL AND LEN(@scholarshipBachelorName) > 0 AND CHARINDEX(@scholarshipBachelorName, @strBlank) = 0) THEN ('"' + @scholarshipBachelorName + '"') ELSE 'NULL' END) + ', ' +
					 'scholarshipBachelorMoney=' + (CASE WHEN (@scholarshipBachelorMoney IS NOT NULL AND LEN(@scholarshipBachelorMoney) > 0 AND CHARINDEX(@scholarshipBachelorMoney, @strBlank) = 0) THEN ('"' + @scholarshipBachelorMoney + '"') ELSE 'NULL' END) + ', ' +
					 'worked=' + (CASE WHEN (@worked IS NOT NULL AND LEN(@worked) > 0 AND CHARINDEX(@worked, @strBlank) = 0) THEN ('"' + @worked + '"') ELSE 'NULL' END) + ', ' +
					 'salary=' + (CASE WHEN (@salary IS NOT NULL AND LEN(@salary) > 0 AND CHARINDEX(@salary, @strBlank) = 0) THEN ('"' + @salary + '"') ELSE 'NULL' END) + ', ' +
					 'workplace=' + (CASE WHEN (@workplace IS NOT NULL AND LEN(@workplace) > 0 AND CHARINDEX(@workplace, @strBlank) = 0) THEN ('"' + @workplace + '"') ELSE 'NULL' END) + ', ' +					 
					 'gotMoneyFrom=' + (CASE WHEN (@gotMoneyFrom IS NOT NULL AND LEN(@gotMoneyFrom) > 0 AND CHARINDEX(@gotMoneyFrom, @strBlank) = 0) THEN ('"' + @gotMoneyFrom + '"') ELSE 'NULL' END) + ', ' +
					 'gotMoneyFromOther=' + (CASE WHEN (@gotMoneyFromOther IS NOT NULL AND LEN(@gotMoneyFromOther) > 0 AND CHARINDEX(@gotMoneyFromOther, @strBlank) = 0) THEN ('"' + @gotMoneyFromOther + '"') ELSE 'NULL' END) + ', ' +
					 'gotMoneyPerMonth=' + (CASE WHEN (@gotMoneyPerMonth IS NOT NULL AND LEN(@gotMoneyPerMonth) > 0 AND CHARINDEX(@gotMoneyPerMonth, @strBlank) = 0) THEN ('"' + @gotMoneyPerMonth + '"') ELSE 'NULL' END) + ', ' +
					 'costPerMonth=' + (CASE WHEN (@costPerMonth IS NOT NULL AND LEN(@costPerMonth) > 0 AND CHARINDEX(@costPerMonth, @strBlank) = 0) THEN ('"' + @costPerMonth + '"') ELSE 'NULL' END)
		
		BEGIN TRY
			BEGIN TRAN
				IF (@action = 'INSERT')
				BEGIN
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
						CASE WHEN (@personId IS NOT NULL AND LEN(@personId) > 0 AND CHARINDEX(@personId, @strBlank) = 0) THEN @personId ELSE NULL END,
						CASE WHEN (@scholarshipFirstBachelor IS NOT NULL AND LEN(@scholarshipFirstBachelor) > 0 AND CHARINDEX(@scholarshipFirstBachelor, @strBlank) = 0) THEN @scholarshipFirstBachelor ELSE NULL END,
						CASE WHEN (@scholarshipFirstBachelorFrom IS NOT NULL AND LEN(@scholarshipFirstBachelorFrom) > 0 AND CHARINDEX(@scholarshipFirstBachelorFrom, @strBlank) = 0) THEN @scholarshipFirstBachelorFrom ELSE NULL END,
						CASE WHEN (@scholarshipFirstBachelorName IS NOT NULL AND LEN(@scholarshipFirstBachelorName) > 0 AND CHARINDEX(@scholarshipFirstBachelorName, @strBlank) = 0) THEN @scholarshipFirstBachelorName ELSE NULL END,
						CASE WHEN (@scholarshipFirstBachelorMoney IS NOT NULL AND LEN(@scholarshipFirstBachelorMoney) > 0 AND CHARINDEX(@scholarshipFirstBachelorMoney, @strBlank) = 0) THEN @scholarshipFirstBachelorMoney ELSE NULL END,
						CASE WHEN (@scholarshipBachelor IS NOT NULL AND LEN(@scholarshipBachelor) > 0 AND CHARINDEX(@scholarshipBachelor, @strBlank) = 0) THEN @scholarshipBachelor ELSE NULL END,
						CASE WHEN (@scholarshipBachelorFrom IS NOT NULL AND LEN(@scholarshipBachelorFrom) > 0 AND CHARINDEX(@scholarshipBachelorFrom, @strBlank) = 0) THEN @scholarshipBachelorFrom ELSE NULL END,
						CASE WHEN (@scholarshipBachelorName IS NOT NULL AND LEN(@scholarshipBachelorName) > 0 AND CHARINDEX(@scholarshipBachelorName, @strBlank) = 0) THEN @scholarshipBachelorName ELSE NULL END,
						CASE WHEN (@scholarshipBachelorMoney IS NOT NULL AND LEN(@scholarshipBachelorMoney) > 0 AND CHARINDEX(@scholarshipBachelorMoney, @strBlank) = 0) THEN @scholarshipBachelorMoney ELSE NULL END,
						CASE WHEN (@worked IS NOT NULL AND LEN(@worked) > 0 AND CHARINDEX(@worked, @strBlank) = 0) THEN @worked ELSE NULL END,
						CASE WHEN (@salary IS NOT NULL AND LEN(@salary) > 0 AND CHARINDEX(@salary, @strBlank) = 0) THEN @salary ELSE NULL END,
						CASE WHEN (@workplace IS NOT NULL AND LEN(@workplace) > 0 AND CHARINDEX(@workplace, @strBlank) = 0) THEN @workplace ELSE NULL END,
						CASE WHEN (@gotMoneyFrom IS NOT NULL AND LEN(@gotMoneyFrom) > 0 AND CHARINDEX(@gotMoneyFrom, @strBlank) = 0) THEN @gotMoneyFrom ELSE NULL END,
						CASE WHEN (@gotMoneyFromOther IS NOT NULL AND LEN(@gotMoneyFromOther) > 0 AND CHARINDEX(@gotMoneyFromOther, @strBlank) = 0) THEN @gotMoneyFromOther ELSE NULL END,
						CASE WHEN (@gotMoneyPerMonth IS NOT NULL AND LEN(@gotMoneyPerMonth) > 0 AND CHARINDEX(@gotMoneyPerMonth, @strBlank) = 0) THEN @gotMoneyPerMonth ELSE NULL END,
						CASE WHEN (@costPerMonth IS NOT NULL AND LEN(@costPerMonth) > 0 AND CHARINDEX(@costPerMonth, @strBlank) = 0) THEN @costPerMonth ELSE NULL END,
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
						SET @rowCountUpdate = (SELECT COUNT(perPersonId) FROM perFinancial WHERE perPersonId = @personId)
						
						IF (@rowCountUpdate > 0)
						BEGIN
							IF (@action = 'UPDATE')
							BEGIN
								UPDATE perFinancial SET
									scholarshipFirstBachelor		= CASE WHEN (@scholarshipFirstBachelor IS NOT NULL AND LEN(@scholarshipFirstBachelor) > 0 AND CHARINDEX(@scholarshipFirstBachelor, @strBlank) = 0) THEN @scholarshipFirstBachelor ELSE (CASE WHEN (@scholarshipFirstBachelor IS NOT NULL AND (LEN(@scholarshipFirstBachelor) = 0 OR CHARINDEX(@scholarshipFirstBachelor, @strBlank) > 0)) THEN NULL ELSE scholarshipFirstBachelor END) END,
									scholarshipFirstBachelorFrom	= CASE WHEN (@scholarshipFirstBachelorFrom IS NOT NULL AND LEN(@scholarshipFirstBachelorFrom) > 0 AND CHARINDEX(@scholarshipFirstBachelorFrom, @strBlank) = 0) THEN @scholarshipFirstBachelorFrom ELSE (CASE WHEN (@scholarshipFirstBachelorFrom IS NOT NULL AND (LEN(@scholarshipFirstBachelorFrom) = 0 OR CHARINDEX(@scholarshipFirstBachelorFrom, @strBlank) > 0)) THEN NULL ELSE scholarshipFirstBachelorFrom END) END,
									scholarshipFirstBachelorName	= CASE WHEN (@scholarshipFirstBachelorName IS NOT NULL AND LEN(@scholarshipFirstBachelorName) > 0 AND CHARINDEX(@scholarshipFirstBachelorName, @strBlank) = 0) THEN @scholarshipFirstBachelorName ELSE (CASE WHEN (@scholarshipFirstBachelorName IS NOT NULL AND (LEN(@scholarshipFirstBachelorName) = 0 OR CHARINDEX(@scholarshipFirstBachelorName, @strBlank) > 0)) THEN NULL ELSE scholarshipFirstBachelorName END) END,
									scholarshipFirstBachelorMoney	= CASE WHEN (@scholarshipFirstBachelorMoney IS NOT NULL AND LEN(@scholarshipFirstBachelorMoney) > 0 AND CHARINDEX(@scholarshipFirstBachelorMoney, @strBlank) = 0) THEN @scholarshipFirstBachelorMoney ELSE (CASE WHEN (@scholarshipFirstBachelorMoney IS NOT NULL AND (LEN(@scholarshipFirstBachelorMoney) = 0 OR CHARINDEX(@scholarshipFirstBachelorMoney, @strBlank) > 0)) THEN NULL ELSE scholarshipFirstBachelorMoney END) END,
									scholarshipBachelor				= CASE WHEN (@scholarshipBachelor IS NOT NULL AND LEN(@scholarshipBachelor) > 0 AND CHARINDEX(@scholarshipBachelor, @strBlank) = 0) THEN @scholarshipBachelor ELSE (CASE WHEN (@scholarshipBachelor IS NOT NULL AND (LEN(@scholarshipBachelor) = 0 OR CHARINDEX(@scholarshipBachelor, @strBlank) > 0)) THEN NULL ELSE scholarshipBachelor END) END,
									scholarshipBachelorFrom			= CASE WHEN (@scholarshipBachelorFrom IS NOT NULL AND LEN(@scholarshipBachelorFrom) > 0 AND CHARINDEX(@scholarshipBachelorFrom, @strBlank) = 0) THEN @scholarshipBachelorFrom ELSE (CASE WHEN (@scholarshipBachelorFrom IS NOT NULL AND (LEN(@scholarshipBachelorFrom) = 0 OR CHARINDEX(@scholarshipBachelorFrom, @strBlank) > 0)) THEN NULL ELSE scholarshipBachelorFrom END) END,
									scholarshipBachelorName			= CASE WHEN (@scholarshipBachelorName IS NOT NULL AND LEN(@scholarshipBachelorName) > 0 AND CHARINDEX(@scholarshipBachelorName, @strBlank) = 0) THEN @scholarshipBachelorName ELSE (CASE WHEN (@scholarshipBachelorName IS NOT NULL AND (LEN(@scholarshipBachelorName) = 0 OR CHARINDEX(@scholarshipBachelorName, @strBlank) > 0)) THEN NULL ELSE scholarshipBachelorName END) END,
									scholarshipBachelorMoney		= CASE WHEN (@scholarshipBachelorMoney IS NOT NULL AND LEN(@scholarshipBachelorMoney) > 0 AND CHARINDEX(@scholarshipBachelorMoney, @strBlank) = 0) THEN @scholarshipBachelorMoney ELSE (CASE WHEN (@scholarshipBachelorMoney IS NOT NULL AND (LEN(@scholarshipBachelorMoney) = 0 OR CHARINDEX(@scholarshipBachelorMoney, @strBlank) > 0)) THEN NULL ELSE scholarshipBachelorMoney END) END,
									worked							= CASE WHEN (@worked IS NOT NULL AND LEN(@worked) > 0 AND CHARINDEX(@worked, @strBlank) = 0) THEN @worked ELSE (CASE WHEN (@worked IS NOT NULL AND (LEN(@worked) = 0 OR CHARINDEX(@worked, @strBlank) > 0)) THEN NULL ELSE worked END) END,
									salary							= CASE WHEN (@salary IS NOT NULL AND LEN(@salary) > 0 AND CHARINDEX(@salary, @strBlank) = 0) THEN @salary ELSE (CASE WHEN (@salary IS NOT NULL AND (LEN(@salary) = 0 OR CHARINDEX(@salary, @strBlank) > 0)) THEN NULL ELSE salary END) END,
									workplace						= CASE WHEN (@workplace IS NOT NULL AND LEN(@workplace) > 0 AND CHARINDEX(@workplace, @strBlank) = 0) THEN @workplace ELSE (CASE WHEN (@workplace IS NOT NULL AND (LEN(@workplace) = 0 OR CHARINDEX(@workplace, @strBlank) > 0)) THEN NULL ELSE workplace END) END,
									gotMoneyFrom					= CASE WHEN (@gotMoneyFrom IS NOT NULL AND LEN(@gotMoneyFrom) > 0 AND CHARINDEX(@gotMoneyFrom, @strBlank) = 0) THEN @gotMoneyFrom ELSE (CASE WHEN (@gotMoneyFrom IS NOT NULL AND (LEN(@gotMoneyFrom) = 0 OR CHARINDEX(@gotMoneyFrom, @strBlank) > 0)) THEN NULL ELSE gotMoneyFrom END) END,
									gotMoneyFromOther				= CASE WHEN (@gotMoneyFromOther IS NOT NULL AND LEN(@gotMoneyFromOther) > 0 AND CHARINDEX(@gotMoneyFromOther, @strBlank) = 0) THEN @gotMoneyFromOther ELSE (CASE WHEN (@gotMoneyFromOther IS NOT NULL AND (LEN(@gotMoneyFromOther) = 0 OR CHARINDEX(@gotMoneyFromOther, @strBlank) > 0)) THEN NULL ELSE gotMoneyFromOther END) END,
									gotMoneyPerMonth				= CASE WHEN (@gotMoneyPerMonth IS NOT NULL AND LEN(@gotMoneyPerMonth) > 0 AND CHARINDEX(@gotMoneyPerMonth, @strBlank) = 0) THEN @gotMoneyPerMonth ELSE (CASE WHEN (@gotMoneyPerMonth IS NOT NULL AND (LEN(@gotMoneyPerMonth) = 0 OR CHARINDEX(@gotMoneyPerMonth, @strBlank) > 0)) THEN NULL ELSE gotMoneyPerMonth END) END,
									costPerMonth					= CASE WHEN (@costPerMonth IS NOT NULL AND LEN(@costPerMonth) > 0 AND CHARINDEX(@costPerMonth, @strBlank) = 0) THEN @costPerMonth ELSE (CASE WHEN (@costPerMonth IS NOT NULL AND (LEN(@costPerMonth) = 0 OR CHARINDEX(@costPerMonth, @strBlank) > 0)) THEN NULL ELSE costPerMonth END) END,
									modifyDate						= GETDATE(),
									modifyBy						= CASE WHEN (@by IS NOT NULL AND LEN(@by) > 0 AND CHARINDEX(@by, @strBlank) = 0) THEN @by ELSE (CASE WHEN (@by IS NOT NULL AND (LEN(@by) = 0 OR CHARINDEX(@by, @strBlank) > 0)) THEN NULL ELSE modifyBy END) END,
									modifyIp						= CASE WHEN (@ip IS NOT NULL AND LEN(@ip) > 0 AND CHARINDEX(@ip, @strBlank) = 0) THEN @ip ELSE (CASE WHEN (@ip IS NOT NULL AND (LEN(@ip) = 0 OR CHARINDEX(@ip, @strBlank) > 0)) THEN NULL ELSE modifyIp END) END
								WHERE perPersonId = @personId	
							END
							
							IF (@action = 'DELETE')								
							BEGIN
								DELETE FROM perFinancial WHERE perPersonId = @personId
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

USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_ecpSetIndemnityAgreement]    Script Date: 18/1/2559 13:02:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๕/๐๑/๒๕๕๙>
-- Description	: <สำหรับบันทึกข้อมูลตาราง ecpIndemnityAgreement ครั้งละ ๑ เรคคอร์ด>
--  1. action					เป็น VARCHAR	รับค่าการกระทำกับฐานข้อมูล
--	2. program					เป็น VARCHAR	รับค่ารหัสหลักสูตร
--	3. graduation				เป็น VARCHAR	รับค่ากรณีการชดใช้ตามสัญญา
--	4. amountCash				เป็น VARCHAR	รับค่าจำนวนเงินชดใช้
--	5. periodWork				เป็น VARCHAR	รับค่าระยะเวลาทำงานชดใช้หลังสำเร็จการศึกษา
--	6. formula					เป็น VARCHAR	รับค่าวิธีคำนวณเงินชดใช้
--  7. cancelledStatus			เป็น VARCHAR	รับค่าสถานะการยกเลิก
--  8. by						เป็น NVARCHAR	รับค่าชื่อของผู้ที่กระทำกับฐานข้อมูล
--  9. ip						เป็น VARCHAR	รับค่าหมายเลขไอพีของผู้ที่กระทำกับฐานข้อมูล
-- =============================================
ALTER PROCEDURE [dbo].[sp_ecpSetIndemnityAgreement]
(
	@action VARCHAR(10) = NULL,
	@program VARCHAR(15) = NULL,
	@graduation VARCHAR(2) = NULL,
	@amountCash VARCHAR(20) = NULL,
	@periodWork VARCHAR(20) = NULL,
	@formula VARCHAR(2) = NULL,
	@cancelledStatus VARCHAR(1) = NULL,
	@by NVARCHAR(255) = NULL,
	@ip VARCHAR(255) = NULL
)	
AS
BEGIN
	SET NOCOUNT ON

	SET @action = LTRIM(RTRIM(@action))
	SET @program = LTRIM(RTRIM(@program))
	SET @graduation = LTRIM(RTRIM(@graduation))
	SET @amountCash = LTRIM(RTRIM(@amountCash))
	SET @periodWork = LTRIM(RTRIM(@periodWork))
	SET @formula = LTRIM(RTRIM(@formula))
	SET @cancelledStatus = LTRIM(RTRIM(@cancelledStatus))
	SET @by = LTRIM(RTRIM(@by))
	SET @ip = LTRIM(RTRIM(@ip))
	
	DECLARE @table VARCHAR(50) = 'ecpIndemnityAgreement'
	DECLARE @rowCount INT = 0
	DECLARE @rowCountUpdate INT = 0
	DECLARE @value NVARCHAR(MAX) = NULL
	DECLARE	@strBlank VARCHAR(50) = '----------**********.........0.0000000000000000000'
	
	SET @action = UPPER(@action)
	
	IF (@action = 'INSERT' OR @action = 'UPDATE' OR @action = 'DELETE')
	BEGIN
		SET @value = 'ecpProgramContractId='				+ (CASE WHEN (@program IS NOT NULL AND LEN(@program) > 0 AND CHARINDEX(@program, @strBlank) = 0) THEN ('"' + @program + '"') ELSE 'NULL' END) + ', ' +
					 'caseGraduation='						+ (CASE WHEN (@graduation IS NOT NULL AND LEN(@graduation) > 0 AND CHARINDEX(@graduation, @strBlank) = 0) THEN ('"' + @graduation + '"') ELSE 'NULL' END) + ', ' +
					 'amountCash='							+ (CASE WHEN (@amountCash IS NOT NULL AND LEN(@amountCash) > 0 AND CHARINDEX(@amountCash, @strBlank) = 0) THEN ('"' + @amountCash + '"') ELSE 'NULL' END) + ', ' +
					 'periodWorkAfterGraduation='			+ (CASE WHEN (@periodWork IS NOT NULL AND LEN(@periodWork) > 0 AND CHARINDEX(@periodWork, @strBlank) = 0) THEN ('"' + @periodWork + '"') ELSE 'NULL' END) + ', ' +
					 'ecpConditionFormulaCalculationId='	+ (CASE WHEN (@formula IS NOT NULL AND LEN(@formula) > 0 AND CHARINDEX(@formula, @strBlank) = 0) THEN ('"' + @formula + '"') ELSE 'NULL' END) + ', ' +
					 'cancelledStatus='						+ (CASE WHEN (@cancelledStatus IS NOT NULL AND LEN(@cancelledStatus) > 0 AND CHARINDEX(@cancelledStatus, @strBlank) = 0) THEN ('"' + @cancelledStatus + '"') ELSE 'NULL' END)
					 
		BEGIN TRY
			BEGIN TRAN
				IF (@action = 'INSERT')
				BEGIN
					SET @rowCountUpdate = (SELECT COUNT(ecpProgramContractId + caseGraduation) FROM Infinity..ecpIndemnityAgreement WHERE (ecpProgramContractId = @program) AND (caseGraduation = @graduation))
						
					IF (@rowCountUpdate = 0)
					BEGIN		
 						INSERT INTO Infinity..ecpIndemnityAgreement
 						(
							ecpProgramContractId,
							caseGraduation,
							amountCash,
							periodWorkAfterGraduation,
							ecpConditionFormulaCalculationId,
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
							CASE WHEN (@program IS NOT NULL AND LEN(@program) > 0 AND CHARINDEX(@program, @strBlank) = 0) THEN @program ELSE NULL END,
							CASE WHEN (@graduation IS NOT NULL AND LEN(@graduation) > 0 AND CHARINDEX(@graduation, @strBlank) = 0) THEN @graduation ELSE NULL END,
							CASE WHEN (@amountCash IS NOT NULL AND LEN(@amountCash) > 0 AND CHARINDEX(@amountCash, @strBlank) = 0) THEN @amountCash ELSE NULL END,
							CASE WHEN (@periodWork IS NOT NULL AND LEN(@periodWork) > 0 AND CHARINDEX(@periodWork, @strBlank) = 0) THEN @periodWork ELSE NULL END,
							CASE WHEN (@formula IS NOT NULL AND LEN(@formula) > 0 AND CHARINDEX(@formula, @strBlank) = 0) THEN @formula ELSE NULL END,
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
				END					 
				
				IF (@action = 'UPDATE' OR @action = 'DELETE')					
				BEGIN
					SET @rowCountUpdate = (SELECT COUNT(ecpProgramContractId + caseGraduation) FROM Infinity..ecpIndemnityAgreement WHERE (ecpProgramContractId = @program) AND (caseGraduation = @graduation))
						
					IF (@rowCountUpdate > 0)
					BEGIN
						IF (@action = 'UPDATE')
						BEGIN								
							UPDATE Infinity..ecpIndemnityAgreement SET
								amountCash							= CASE WHEN (@amountCash IS NOT NULL AND LEN(@amountCash) > 0 AND CHARINDEX(@amountCash, @strBlank) = 0) THEN @amountCash ELSE (CASE WHEN (@amountCash IS NOT NULL AND (LEN(@amountCash) = 0 OR CHARINDEX(@amountCash, @strBlank) > 0)) THEN NULL ELSE amountCash END) END,
								periodWorkAfterGraduation			= CASE WHEN (@periodWork IS NOT NULL AND LEN(@periodWork) > 0 AND CHARINDEX(@periodWork, @strBlank) = 0) THEN @periodWork ELSE (CASE WHEN (@periodWork IS NOT NULL AND (LEN(@periodWork) = 0 OR CHARINDEX(@periodWork, @strBlank) > 0)) THEN NULL ELSE periodWorkAfterGraduation END) END,
								ecpConditionFormulaCalculationId	= CASE WHEN (@formula IS NOT NULL AND LEN(@formula) > 0 AND CHARINDEX(@formula, @strBlank) = 0) THEN @formula ELSE (CASE WHEN (@formula IS NOT NULL AND (LEN(@formula) = 0 OR CHARINDEX(@formula, @strBlank) > 0)) THEN NULL ELSE ecpConditionFormulaCalculationId END) END,
								cancelledStatus						= CASE WHEN (@cancelledStatus IS NOT NULL AND LEN(@cancelledStatus) > 0 AND CHARINDEX(@cancelledStatus, @strBlank) = 0) THEN @cancelledStatus ELSE (CASE WHEN (@cancelledStatus IS NOT NULL AND (LEN(@cancelledStatus) = 0 OR CHARINDEX(@cancelledStatus, @strBlank) > 0)) THEN NULL ELSE cancelledStatus END) END,
								modifyDate							= GETDATE(),
								modifyBy							= CASE WHEN (@by IS NOT NULL AND LEN(@by) > 0 AND CHARINDEX(@by, @strBlank) = 0) THEN @by ELSE (CASE WHEN (@by IS NOT NULL AND (LEN(@by) = 0 OR CHARINDEX(@by, @strBlank) > 0)) THEN NULL ELSE modifyBy END) END,
								modifyIp							= CASE WHEN (@ip IS NOT NULL AND LEN(@ip) > 0 AND CHARINDEX(@ip, @strBlank) = 0) THEN @ip ELSE (CASE WHEN (@ip IS NOT NULL AND (LEN(@ip) = 0 OR CHARINDEX(@ip, @strBlank) > 0)) THEN NULL ELSE modifyIp END) END
							WHERE (ecpProgramContractId = @program) AND (caseGraduation = @graduation)
						END
															
						IF (@action = 'DELETE')
						BEGIN
							DELETE FROM Infinity..ecpIndemnityAgreement WHERE (ecpProgramContractId = @program) AND (caseGraduation = @graduation)
						END
								
						SET @rowCount = @rowCount + 1							
					END				
				END
			COMMIT TRAN									
		END TRY
		BEGIN CATCH		
			ROLLBACK TRAN
			INSERT INTO InfinityLog..ecpErrorLog
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
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๙/๐๑/๒๕๕๙>
-- Description	: <สำหรับบันทึกข้อมูลตาราง ecpProgramScholarships ครั้งละ ๑ เรคคอร์ด>
--  1. action				เป็น VARCHAR	รับค่าการกระทำกับฐานข้อมูล
--	2. program				เป็น VARCHAR	รับค่ารหัสหลักสูตร
--	3. amountScholarship	เป็น VARCHAR	รับค่าจำนวนเงินทุนการศึกษา
--  4. cancelledStatus		เป็น VARCHAR	รับค่าสถานะการยกเลิก
--  5. by					เป็น NVARCHAR	รับค่าชื่อของผู้ที่กระทำกับฐานข้อมูล
--  6. ip					เป็น VARCHAR	รับค่าหมายเลขไอพีของผู้ที่กระทำกับฐานข้อมูล
-- =============================================
CREATE PROCEDURE [dbo].[sp_ecpSetProgramScholarships]
(
	@action VARCHAR(10) = NULL,
	@program VARCHAR(15) = NULL,
	@amountScholarship VARCHAR(20) = NULL,
	@cancelledStatus VARCHAR(1) = NULLL,
	@by NVARCHAR(255) = NULL,
	@ip VARCHAR(255) = NULL
)	
AS
BEGIN
	SET NOCOUNT ON

	SET @action = LTRIM(RTRIM(@action))
	SET @program = LTRIM(RTRIM(@program))
	SET @amountScholarship = LTRIM(RTRIM(@amountScholarship))
	SET @cancelledStatus = LTRIM(RTRIM(@cancelledStatus))
	SET @by = LTRIM(RTRIM(@by))
	SET @ip = LTRIM(RTRIM(@ip))
	
	DECLARE @table VARCHAR(50) = 'ecpProgramScholarships'
	DECLARE @rowCount INT = 0
	DECLARE @rowCountUpdate INT = 0
	DECLARE @value NVARCHAR(MAX) = NULL
	DECLARE	@strBlank VARCHAR(50) = '----------**********.........0.0000000000000000000'
	
	SET @action = UPPER(@action)
	
	IF (@action = 'INSERT' OR @action = 'UPDATE' OR @action = 'DELETE')
	BEGIN
		SET @value = 'ecpProgramContractId='	+ (CASE WHEN (@program IS NOT NULL AND LEN(@program) > 0 AND CHARINDEX(@program, @strBlank) = 0) THEN ('"' + @program + '"') ELSE 'NULL' END) + ', ' +
					 'amountScholarship='		+ (CASE WHEN (@amountScholarship IS NOT NULL AND LEN(@amountScholarship) > 0 AND CHARINDEX(@amountScholarship, @strBlank) = 0) THEN ('"' + @amountScholarship + '"') ELSE 'NULL' END) + ', ' +
					 'cancelledStatus='			+ (CASE WHEN (@cancelledStatus IS NOT NULL AND LEN(@cancelledStatus) > 0 AND CHARINDEX(@cancelledStatus, @strBlank) = 0) THEN ('"' + @cancelledStatus + '"') ELSE 'NULL' END)
					 
		BEGIN TRY
			BEGIN TRAN
				IF (@action = 'INSERT')
				BEGIN
					SET @rowCountUpdate = (SELECT COUNT(@program) FROM Infinity..ecpProgramScholarships WHERE ecpProgramContractId = @program)
						
					IF (@rowCountUpdate = 0)
					BEGIN		
 						INSERT INTO Infinity..ecpProgramScholarships
 						(
							ecpProgramContractId,
							amountScholarship,
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
							CASE WHEN (@amountScholarship IS NOT NULL AND LEN(@amountScholarship) > 0 AND CHARINDEX(@amountScholarship, @strBlank) = 0) THEN @amountScholarship ELSE NULL END,
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
					SET @rowCountUpdate = (SELECT COUNT(@program) FROM Infinity..ecpProgramScholarships WHERE ecpProgramContractId = @program)
						
					IF (@rowCountUpdate > 0)
					BEGIN
						IF (@action = 'UPDATE')
						BEGIN								
							UPDATE Infinity..ecpProgramScholarships SET
								amountScholarship	= CASE WHEN (@amountScholarship IS NOT NULL AND LEN(@amountScholarship) > 0 AND CHARINDEX(@amountScholarship, @strBlank) = 0) THEN @amountScholarship ELSE (CASE WHEN (@amountScholarship IS NOT NULL AND (LEN(@amountScholarship) = 0 OR CHARINDEX(@amountScholarship, @strBlank) > 0)) THEN NULL ELSE amountScholarship END) END,
								cancelledStatus		= CASE WHEN (@cancelledStatus IS NOT NULL AND LEN(@cancelledStatus) > 0 AND CHARINDEX(@cancelledStatus, @strBlank) = 0) THEN @cancelledStatus ELSE (CASE WHEN (@cancelledStatus IS NOT NULL AND (LEN(@cancelledStatus) = 0 OR CHARINDEX(@cancelledStatus, @strBlank) > 0)) THEN NULL ELSE cancelledStatus END) END,
								modifyDate			= GETDATE(),
								modifyBy			= CASE WHEN (@by IS NOT NULL AND LEN(@by) > 0 AND CHARINDEX(@by, @strBlank) = 0) THEN @by ELSE (CASE WHEN (@by IS NOT NULL AND (LEN(@by) = 0 OR CHARINDEX(@by, @strBlank) > 0)) THEN NULL ELSE modifyBy END) END,
								modifyIp			= CASE WHEN (@ip IS NOT NULL AND LEN(@ip) > 0 AND CHARINDEX(@ip, @strBlank) = 0) THEN @ip ELSE (CASE WHEN (@ip IS NOT NULL AND (LEN(@ip) = 0 OR CHARINDEX(@ip, @strBlank) > 0)) THEN NULL ELSE modifyIp END) END
							WHERE (ecpProgramContractId = @program)
						END
															
						IF (@action = 'DELETE')
						BEGIN
							DELETE FROM Infinity..ecpProgramScholarships WHERE ecpProgramContractId = @program
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
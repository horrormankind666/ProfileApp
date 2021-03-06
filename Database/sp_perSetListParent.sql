USE [MUStudent]
GO
/****** Object:  StoredProcedure [dbo].[sp_perSetListParent]    Script Date: 03/27/2014 11:50:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<ยุทธภูมิ ตวันนา>
-- Create date: <๐๖/๑๒/๒๕๕๖>
-- Description:	<สำหรับบันทึกข้อมูลตาราง perParent ครั้งละหลายเรคคอร์ด>
--  1. order				เป็น VARCHAR	รับค่าลำดับของเรคคอร์ด
--  2. perPersonId 			เป็น VARCHAR	รับค่ารหัสบุคคล
--  3. perPersonIdFather	เป็น VARCHAR	รับค่ารหัสบุคคลของบิดา
--  4. perPersonIdMother	เป็น VARCHAR	รับค่ารหัสบุคคลของมารดา
--  5. perPersonIdParent	เป็น VARCHAR	รับค่ารหัสบุคคลของผู้ปกครอง
--  6. perRelationshipId	เป็น VARCHAR	รับค่ารหัสความสัมพันธ์ในครอบครัวของผู้ปกครอง
--  7. by					เป็น NVARCHAR	รับค่าชื่อของผู้ที่กระทำกับฐานข้อมูล
-- =============================================
ALTER PROCEDURE [dbo].[sp_perSetListParent]
(
	@order VARCHAR(MAX) = NULL,
	@perPersonId VARCHAR(MAX) = NULL,
	@perPersonIdFather VARCHAR(MAX) = NULL,
	@perPersonIdMother VARCHAR(MAX) = NULL,
	@perPersonIdParent VARCHAR(MAX) = NULL,
	@perRelationshipId VARCHAR(MAX) = NULL,
	@by NVARCHAR(255) = NULL   
)
AS
BEGIN
	SET NOCOUNT ON
	
	SET @order = LTRIM(RTRIM(@order))
	SET @perPersonId = LTRIM(RTRIM(@perPersonId))
	SET @perPersonIdFather = LTRIM(RTRIM(@perPersonIdFather))
	SET @perPersonIdMother = LTRIM(RTRIM(@perPersonIdMother))
	SET @perPersonIdParent = LTRIM(RTRIM(@perPersonIdParent))
	SET @perRelationshipId = LTRIM(RTRIM(@perRelationshipId))
	SET @by = LTRIM(RTRIM(@by))	
	
	DECLARE @action VARCHAR(10) = 'INSERT'
	DECLARE @table VARCHAR(50) = 'perParent'
	DECLARE @i INT = 1
	DECLARE @delimiter CHAR(1) = ';'
	DECLARE @orderSlice VARCHAR(MAX) = NULL
	DECLARE @perPersonIdSlice VARCHAR(MAX) = NULL
	DECLARE @perPersonIdFatherSlice VARCHAR(MAX) = NULL
	DECLARE @perPersonIdMotherSlice VARCHAR(MAX) = NULL
	DECLARE @perPersonIdParentSlice VARCHAR(MAX) = NULL
	DECLARE @perRelationshipIdSlice VARCHAR(MAX) = NULL
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
		
		SET @perPersonIdFatherSlice = (SELECT stringSlice FROM fnc_perParseString(@perPersonIdFather, @delimiter))
		SET @perPersonIdFather = (SELECT string FROM fnc_perParseString(@perPersonIdFather, @delimiter))

		SET @perPersonIdMotherSlice = (SELECT stringSlice FROM fnc_perParseString(@perPersonIdMother, @delimiter))
		SET @perPersonIdMother = (SELECT string FROM fnc_perParseString(@perPersonIdMother, @delimiter))

		SET @perPersonIdParentSlice = (SELECT stringSlice FROM fnc_perParseString(@perPersonIdParent, @delimiter))
		SET @perPersonIdParent = (SELECT string FROM fnc_perParseString(@perPersonIdParent, @delimiter))

		SET @perRelationshipIdSlice = (SELECT stringSlice FROM fnc_perParseString(@perRelationshipId, @delimiter))
		SET @perRelationshipId = (SELECT string FROM fnc_perParseString(@perRelationshipId, @delimiter))
			
		IF (LEN(@orderSlice) > 0)
		BEGIN			
			SET @value = 'perPersonId=' + (CASE WHEN (@perPersonIdSlice IS NOT NULL AND LEN(@perPersonIdSlice) > 0 AND CHARINDEX(@perPersonIdSlice, @strBlank) = 0) THEN ('"' + @perPersonIdSlice + '"') ELSE 'NULL' END) + ', ' +
						 'perPersonIdFather=' + (CASE WHEN (@perPersonIdFatherSlice IS NOT NULL AND LEN(@perPersonIdFatherSlice) > 0 AND CHARINDEX(@perPersonIdFatherSlice, @strBlank) = 0) THEN ('"' + @perPersonIdFatherSlice + '"') ELSE 'NULL' END) + ', ' +
						 'perPersonIdMother=' + (CASE WHEN (@perPersonIdMotherSlice IS NOT NULL AND LEN(@perPersonIdMotherSlice) > 0 AND CHARINDEX(@perPersonIdMotherSlice, @strBlank) = 0) THEN ('"' + @perPersonIdMotherSlice + '"') ELSE 'NULL' END) + ', ' +
						 'perPersonIdParent=' + (CASE WHEN (@perPersonIdParentSlice IS NOT NULL AND LEN(@perPersonIdParentSlice) > 0 AND CHARINDEX(@perPersonIdParentSlice, @strBlank) = 0) THEN ('"' + @perPersonIdParentSlice + '"') ELSE 'NULL' END) + ', ' +
						 'perRelationshipId=' + (CASE WHEN (@perRelationshipIdSlice IS NOT NULL AND LEN(@perRelationshipIdSlice) > 0 AND CHARINDEX(@perRelationshipIdSlice, @strBlank) = 0) THEN ('"' + @perRelationshipIdSlice + '"') ELSE 'NULL' END)
						 
			BEGIN TRY
				BEGIN TRAN	
					INSERT INTO perParent
					(
						perPersonId,
						perPersonIdFather,
						perPersonIdMother,
						perPersonIdParent,
						perRelationshipId,
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
						CASE WHEN (@perPersonIdFatherSlice IS NOT NULL AND LEN(@perPersonIdFatherSlice) > 0 AND CHARINDEX(@perPersonIdFatherSlice, @strBlank) = 0) THEN @perPersonIdFatherSlice ELSE NULL END,
						CASE WHEN (@perPersonIdMotherSlice IS NOT NULL AND LEN(@perPersonIdMotherSlice) > 0 AND CHARINDEX(@perPersonIdMotherSlice, @strBlank) = 0) THEN @perPersonIdMotherSlice ELSE NULL END,
						CASE WHEN (@perPersonIdParentSlice IS NOT NULL AND LEN(@perPersonIdParentSlice) > 0 AND CHARINDEX(@perPersonIdParentSlice, @strBlank) = 0) THEN @perPersonIdParentSlice ELSE NULL END,
						CASE WHEN (@perRelationshipIdSlice IS NOT NULL AND LEN(@perRelationshipIdSlice) > 0 AND CHARINDEX(@perRelationshipIdSlice, @strBlank) = 0) THEN @perRelationshipIdSlice ELSE NULL END,
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

USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_ecpGetListNotifyDefaultedContract]    Script Date: 22/1/2559 16:32:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๒๙/๐๗/๒๕๕๘>
-- Description	: <สำหรับเรียกดูข้อมูลของนักศึกษาตามสิทธิ์ผู้ใช้งาน>
-- Parameter
--	1. username			เป็น VARCHAR	รับค่าชื่อผู้ใช้งาน
--	2. userlevel		เป็น VARCHAR	รับค่าระดับผู้ใช้งาน
--	3. systemGroup		เป็น VARCHAR	รับค่าชื่อระบบงาน
--	4. keyword			เป็น NVARCHAR	รับค่าคำค้น
--	5. faculty			เป็น VARCHAR	รับค่ารหัสคณะ
--	6. program			เป็น VARCHAR	รับค่ารหัสหลักสูตร
--  7. yearAttended		เป็น VARCHAR	รับค่าปีที่เข้าศึกษา
--  8. notifiedStatus	เป็น VARCHAR	รับค่าสถานะรายการแจ้ง
--  9. startCreatedDate	เป็น VARCHAR	รับค่าวันที่เริ่มต้นทำรายการแจ้ง
-- 10. endCreatedDate	เป็น VARCHAR	รับค่าวันที่สิ้นสุดทำรายการแจ้ง
-- 11. startSentDate	เป็น VARCHAR	รับค่าวันที่เริ่มต้นส่งรายการแจ้ง
-- 12. endSentDate		เป็น VARCHAR	รับค่าวันที่สิ้นสุดส่งรายการแจ้ง
-- 13. sortOrderBy		เป็น VARCHAR	รับค่าคอลัมภ์ที่ต้องการเรียงลำดับ
-- 14. sortExpression	เป็น VARCHAR	รับค่าวิธีการเรียงลำดับ
-- =============================================
ALTER PROCEDURE [dbo].[sp_ecpGetListNotifyDefaultedContract]
(
	@username VARCHAR(255) = NULL,
	@userlevel VARCHAR(20) = NULL,
	@systemGroup VARCHAR(50) = NULL,	
	@keyword NVARCHAR(MAX) = NULL,	
	@faculty VARCHAR(15) = NULL,
	@program VARCHAR(15) = NULL,
	@yearAttended VARCHAR(4) = NULL,
	@notifiedStatus VARCHAR(2) = NULL,	
	@startCreatedDate VARCHAR(10) = NULL,	
	@endCreatedDate VARCHAR(10) = NULL,	
	@startSentDate VARCHAR(10) = NULL,	
	@endSentDate VARCHAR(10) = NULL,
	@sortOrderBy VARCHAR(255) = NULL,
	@sortExpression VARCHAR(255) = NULL			
)
AS
BEGIN
	SET NOCOUNT ON

	SET @username = LTRIM(RTRIM(@username))
	SET @userlevel = LTRIM(RTRIM(@userlevel))
	SET @systemGroup = LTRIM(RTRIM(@systemGroup))
	SET @keyword = LTRIM(RTRIM(@keyword))	
	SET @faculty = LTRIM(RTRIM(@faculty))
	SET @program = LTRIM(RTRIM(@program))	
	SET @yearAttended = LTRIM(RTRIM(@yearAttended))	
	SET @notifiedStatus = LTRIM(RTRIM(@notifiedStatus))
	SET @startCreatedDate = LTRIM(RTRIM(@startCreatedDate))
	SET @endCreatedDate = LTRIM(RTRIM(@endCreatedDate))
	SET @startSentDate = LTRIM(RTRIM(@startSentDate))
	SET @endSentDate = LTRIM(RTRIM(@endSentDate))
	SET @sortOrderBy = LTRIM(RTRIM(@sortOrderBy))
	SET @sortExpression = LTRIM(RTRIM(@sortExpression))		

	DECLARE @sort VARCHAR(255) = ''	
	DECLARE @keywordIn VARCHAR(10) = ''
	DECLARE @xml XML
	
	SET @sortOrderBy = (CASE WHEN (@sortOrderBy IS NOT NULL) AND (LEN(@sortOrderBy) > 0) THEN @sortOrderBy ELSE 'Create Date' END)
	SET @sortExpression = (CASE WHEN (@sortExpression IS NOT NULL) AND (LEN(@sortExpression) > 0) THEN @sortExpression ELSE 'Descending' END)
	SET @sort = (@sortOrderBy + ' ' + @sortExpression)

	IF (@keyword IS NOT NULL AND LEN(@keyword) > 0)
	BEGIN
		IF (SUBSTRING(@keyword, 1, 8) = 'INPERSON')
			SET @keywordIn = 'INPERSON'
		ELSE
			IF (SUBSTRING(@keyword, 1, 2) = 'IN')				
				SET @keywordIn = 'IN'
			
		IF (@keywordIn = 'INPERSON' OR @keywordIn = 'IN')
			SET @keyword = REPLACE(@keyword, (@keywordIn + ' '), '')			
	END

	SET @xml = CAST(('<A>' + REPLACE(@keyword, '|', '</A><A>') + '</A>') AS XML)

	SELECT	*
	FROM	(SELECT	ROW_NUMBER() OVER(ORDER BY
						CASE WHEN @sort = 'Student ID Ascending'	THEN ecpndc.stdStudentCode END ASC,
						CASE WHEN @sort = 'Name Ascending'			THEN ecpndc.firstName END ASC,
						CASE WHEN @sort = 'Faculty Ascending'		THEN ecpndc.acaFacultyId END ASC,
						CASE WHEN @sort = 'Program Ascending'		THEN ecpndc.acaProgramId END ASC,
						CASE WHEN @sort = 'Create Date Ascending'	THEN ecpndc.createDate END ASC,
						CASE WHEN @sort = 'Send Date Ascending'		THEN ecpndc.modifyDate END ASC,
							
						CASE WHEN @sort = 'Student ID Descending'	THEN ecpndc.stdStudentCode END DESC,
						CASE WHEN @sort = 'Name Descending'			THEN ecpndc.firstName END DESC,
						CASE WHEN @sort = 'Faculty Descending'		THEN ecpndc.acaFacultyId END DESC,
						CASE WHEN @sort = 'Program Descending'		THEN ecpndc.acaProgramId END DESC,
						CASE WHEN @sort = 'Create Date Descending'	THEN ecpndc.createDate END DESC,
						CASE WHEN @sort = 'Send Date Descending'	THEN ecpndc.modifyDate END DESC
					) AS rowNum,
					ecpndc.id,
					ecpndc.stdStudentCode,
					ecpndc.perTitlePrefixId,
					ecpndc.perTitlePrefixFullNameTH,
					ecpndc.perTitlePrefixInitialsTH,
					ecpndc.perTitlePrefixFullNameEN,
					ecpndc.perTitlePrefixInitialsEN,
					ecpndc.firstName,
					ecpndc.middleName,
					ecpndc.lastName,
					ecpndc.firstNameEN,
					ecpndc.middleNameEN,
					ecpndc.lastNameEN, 
					ecpndc.acaFacultyId,
					ecpndc.acaFacultyCode,
					ecpndc.acaFacultyNameTH,
					ecpndc.acaProgramId,
					ecpndc.acaProgramCode,
					ecpndc.acaProgramNameTH,
					ecpndc.acaProgramMajorCode,
					ecpndc.acaProgramGroupNum,
					ecpndc.acaProgramDLevel,
					stddlv.thDegreeLevelName AS degreeLevelNameTH,
					stddlv.enDegreeLevelName AS degreeLevelNameEN,
					ecpndc.pursuantBook,
					ecpndc.pursuant,
					ecpndc.pursuantBookDate,
					ecpndc.location, 
					ecpndc.inputDate,
					ecpndc.stateLocation,
					ecpndc.stateLocationDate,
					ecpndc.contractDate,
					ecpndc.contractDateAgreement,
					ecpndc.guarantor,
					ecpndc.scholarshipStatus,
					ecpndc.scholarshipAmount,
					ecpndc.scholarshipYear,
					ecpndc.scholarshipMonth,
					ecpndc.graduateStatus,
					ecpndc.educationDate,
					ecpndc.graduateDate,
					ecpndc.publicServantStatus,
					ecpndc.contractEffectiveStartDate,
					ecpndc.contractEffectiveEndDate,					
					ecpndc.ecpConditionFormulaCalculationId,
					ecpndc.periodWork,
					ecpndc.amountCash,
					ecpndc.notifiedStatus,
					ecpndc.createDate,
					ecpndc.modifyDate
			 FROM	Infinity..autUserAccessProgram AS autusr INNER JOIN
					Infinity..ecpNotifyDefaultedContract AS ecpndc ON (CASE WHEN autusr.facultyId = 'MU-01' THEN '1' ELSE autusr.facultyId END) = (CASE WHEN autusr.facultyId = 'MU-01' THEN '1' ELSE ecpndc.acaFacultyId END) AND (CASE WHEN (autusr.programId IS NOT NULL AND LEN(autusr.programId) > 0) THEN autusr.programId ELSE '1' END) = (CASE WHEN (autusr.programId IS NOT NULL AND LEN(autusr.programId) > 0) THEN ecpndc.acaProgramId ELSE '1' END) INNER JOIN
					Infinity..ecpProgramContract AS ecppgc ON ecpndc.acaProgramId = ecppgc.acaProgramId	LEFT JOIN
					Infinity..stdDegreeLevel AS stddlv ON ecpndc.acaProgramDLevel = stddlv.id
			 WHERE	(autusr.username = @username) AND
					(autusr.level = @userlevel) AND
					(autusr.systemGroup = @systemGroup) AND
					(ecppgc.cancelledStatus = 'N') AND
					(
						(1 = (CASE WHEN (@keywordIn = 'IN') THEN 0 ELSE 1 END)) OR
						(ecpndc.stdStudentCode IN (SELECT A.value('.', 'VARCHAR(MAX)') as [Column] FROM @xml.nodes('A') AS FN(A)))
					) AND					
					(
						(1 = (CASE WHEN ((@keywordIn IS NULL OR LEN(@keywordIn) = 0) AND @keyword IS NOT NULL AND LEN(@keyword) > 0) THEN 0 ELSE 1 END)) OR	
			 			(ecpndc.stdStudentCode LIKE ('%' + @keyword + '%')) OR
			 			(ecpndc.perTitlePrefixFullNameTH LIKE ('%' + @keyword + '%')) OR
			 			(ecpndc.perTitlePrefixFullNameEN LIKE ('%' + @keyword + '%')) OR
			 			(ecpndc.firstName LIKE ('%' + @keyword + '%')) OR
			 			(ecpndc.middleName LIKE ('%' + @keyword + '%')) OR
			 			(ecpndc.lastName LIKE ('%' + @keyword + '%')) OR
			 			(ecpndc.firstNameEN LIKE ('%' + @keyword + '%')) OR
			 			(ecpndc.middleNameEN LIKE ('%' + @keyword + '%')) OR
			 			(ecpndc.lastNameEN LIKE ('%' + @keyword + '%'))
			 			) AND
						(
							(1 = (CASE WHEN (@faculty IS NOT NULL AND LEN(@faculty) > 0) THEN 0 ELSE 1 END)) OR
							(ecpndc.acaFacultyId = @faculty)
						) AND
						(
							(1 = (CASE WHEN (@program IS NOT NULL AND LEN(@program) > 0) THEN 0 ELSE 1 END)) OR
							(ecpndc.acaProgramId = @program)
						) AND
						(
							(1 = (CASE WHEN (@yearAttended IS NOT NULL AND LEN(@yearAttended) > 0) THEN 0 ELSE 1 END)) OR
							(ecpndc.yearAttended = @yearAttended)
						) AND
						(
							(1 = (CASE WHEN (@notifiedStatus IS NOT NULL AND LEN(@notifiedStatus) > 0) THEN 0 ELSE 1 END)) OR
							(ecpndc.notifiedStatus = @notifiedStatus)
						) AND
						(
							(1 = (CASE WHEN (@startCreatedDate IS NOT NULL AND LEN(@startCreatedDate) > 0 AND @endCreatedDate IS NOT NULL AND LEN(@endCreatedDate) > 0) THEN 0 ELSE 1 END)) OR
							(CONVERT(DATE, ecpndc.createDate, 103) BETWEEN CONVERT(DATE, @startCreatedDate, 103) AND CONVERT(DATE, @endCreatedDate, 103))
						) AND
						(
							(1 = (CASE WHEN (@startSentDate IS NOT NULL AND LEN(@startSentDate) > 0 AND @endSentDate IS NOT NULL AND LEN(@endSentDate) > 0) THEN 0 ELSE 1 END)) OR
							(CONVERT(DATE, ecpndc.modifyDate, 103) BETWEEN CONVERT(DATE, @startSentDate, 103) AND CONVERT(DATE, @endSentDate, 103))
						)) AS ecpndc

	SELECT	COUNT(ecpndc.id)
	FROM	Infinity..autUserAccessProgram AS autusr INNER JOIN
			Infinity..ecpNotifyDefaultedContract AS ecpndc ON (CASE WHEN autusr.facultyId = 'MU-01' THEN '1' ELSE autusr.facultyId END) = (CASE WHEN autusr.facultyId = 'MU-01' THEN '1' ELSE ecpndc.acaFacultyId END) AND (CASE WHEN (autusr.programId IS NOT NULL AND LEN(autusr.programId) > 0) THEN autusr.programId ELSE '1' END) = (CASE WHEN (autusr.programId IS NOT NULL AND LEN(autusr.programId) > 0) THEN ecpndc.acaProgramId ELSE '1' END) INNER JOIN
			Infinity..ecpProgramContract AS ecppgc ON ecpndc.acaProgramId = ecppgc.acaProgramId	LEFT JOIN
			Infinity..stdDegreeLevel AS stddlv ON ecpndc.acaProgramDLevel = stddlv.id
	WHERE	(autusr.username = @username) AND
			(autusr.level = @userlevel) AND
			(autusr.systemGroup = @systemGroup)
END
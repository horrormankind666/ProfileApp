USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_udsGetListPersonStudentWithAuthenStaff]    Script Date: 10-10-2016 13:54:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๒๖/๐๖/๒๕๕๘>
-- Description	: <สำหรับเรียกดูข้อมูลของนักศึกษาตามสิทธิ์ผู้ใช้งาน>
-- Parameter
--	1. username				เป็น VARCHAR	รับค่าชื่อผู้ใช้งาน
--	2. userlevel			เป็น VARCHAR	รับค่าระดับผู้ใช้งาน
--	3. systemGroup			เป็น VARCHAR	รับค่าชื่อระบบงาน
--	4. sectionAction		เป็น VARCHAR	รับค่าการกระทำที่เกิดขึ้นกับหัวข้อที่อัพโหลด
--	5. reportName			เป็น VARCHAR	รับค่าชื่อรายงาน
--	6. keyword				เป็น NVARCHAR	รับค่าคำค้น
--	7. degreeLevel			เป็น VARCHAR	รับค่าระดับปริญญา
--  8. faculty				เป็น VARCHAR	รับค่ารหัสคณะ
--  9. program				เป็น VARCHAR	รับค่าหลักสูตร
-- 10. yearEntry			เป็น VARCHAR	รับค่าปีที่เข้าศึกษา
-- 11. entranceType			เป็น VARCHAR	รับค่าระบบการสอบเข้า
-- 12. studentStatus		เป็น VARCHAR	รับค่าสถานภาพการเป็นนักศึกษา
-- 13. documentUpload		เป็น VARCHAR	รับค่าชื่อเอกสาร
-- 14. submittedStatus		เป็น VARCHAR	รับค่าสถานะการส่ง
-- 15. approvalStatus		เป็น VARCHAR	รับค่าสถานะการอนุมัติ
-- 16. instituteCountry		เป็น VARCHAR	รับค่ารหัสประเทศของโรงเรียน / สถาบัน
-- 17. instituteProvince	เป็น VARCHAR	รับค่ารหัสจังหวัดของโรงเรียน / สถาบัน
-- 18. institute			เป็น VARCHAR	รับค่ารหัสโรงเรียน / สถาบัน
-- 19. sentDateStartAudit	เป็น VARCHAR	รับค่าวันที่เริ่มต้นส่งระเบียนแสดงผลการเรียนตรวจสอบ
-- 20. sentDateEndAudit		เป็น VARCHAR	รับค่าวันที่สิ้นสุดส่งระเบีบนแสดงผลการเรียนตรวจสอบ
-- 21. auditedstatus		เป็น VARCHAR	รับค่าผลการตรวจสอบระเบียนแสดงผลการเรียน
-- 22. exportstatus			เป็น VARCHAR	รับค่าสถานะการส่งออก
-- 23. sortOrderBy			เป็น VARCHAR	รับค่าคอลัมภ์ที่ต้องการเรียงลำดับ
-- 24. sortExpression		เป็น VARCHAR	รับค่าวิธีการเรียงลำดับ
-- =============================================
ALTER PROCEDURE [dbo].[sp_udsGetListPersonStudentWithAuthenStaff]
(
	@username VARCHAR(255) = NULL,
	@userlevel VARCHAR(20) = NULL,
	@systemGroup VARCHAR(50) = NULL,	
	@sectionAction VARCHAR(20) = NULL,
	@reportName VARCHAR(100) = NULL,
	@keyword NVARCHAR(MAX) = NULL,
	@degreeLevel NVARCHAR(2) = NULL,
	@faculty VARCHAR(15) = NULL,
	@program VARCHAR(15) = NULL,
	@yearEntry VARCHAR(4) = NULL,
	@entranceType VARCHAR(20) = NULL,
	@studentStatus VARCHAR(3) = NULL,
	@documentUpload VARCHAR(255) = NULL,
	@submittedStatus VARCHAR(1) = NULL,
	@approvalStatus VARCHAR(1) = NULL,
	@instituteCountry VARCHAR(3) = NULL,
	@instituteProvince VARCHAR(3) = NULL,
	@institute VARCHAR(10) = NULL,
	@sentDateStartAudit	VARCHAR(10) = NULL,
	@sentDateEndAudit VARCHAR(10) = NULL,
	@auditedStatus VARCHAR(1) = NULL,	
	@exportStatus VARCHAR(1) = NULL,	
	@sortOrderBy VARCHAR(255) = NULL,
	@sortExpression VARCHAR(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	
	SET @username = LTRIM(RTRIM(@username))
	SET @userlevel = LTRIM(RTRIM(@userlevel))
	SET @systemGroup = LTRIM(RTRIM(@systemGroup))
	SET @sectionAction = LTRIM(RTRIM(@sectionAction))
	SET @reportName = LTRIM(RTRIM(@reportName))
	SET @keyword = LTRIM(RTRIM(@keyword))
	SET @degreeLevel = LTRIM(RTRIM(@degreeLevel))
	SET @faculty = LTRIM(RTRIM(@faculty))
	SET @program = LTRIM(RTRIM(@program))	
	SET @yearEntry = LTRIM(RTRIM(@yearEntry))
	SET @entranceType = LTRIM(RTRIM(@entranceType))
	SET @studentStatus = LTRIM(RTRIM(@studentStatus))
	SET @documentUpload = LTRIM(RTRIM(@documentUpload))
	SET @submittedStatus = LTRIM(RTRIM(@submittedStatus))
	SET @approvalStatus = LTRIM(RTRIM(@approvalStatus))
	SET @instituteCountry = LTRIM(RTRIM(@instituteCountry))
	SET @instituteProvince = LTRIM(RTRIM(@instituteProvince))
	SET @institute = LTRIM(RTRIM(@institute))
	SET @sentDateStartAudit = LTRIM(RTRIM(@sentDateStartAudit))
	SET @sentDateEndAudit = LTRIM(RTRIM(@sentDateEndAudit))
	SET @auditedStatus = LTRIM(RTRIM(@auditedStatus))
	SET @sortOrderBy = LTRIM(RTRIM(@sortOrderBy))
	SET @sortExpression = LTRIM(RTRIM(@sortExpression))		
	
	DECLARE	@userFaculty VARCHAR(15) = NULL
	DECLARE @userProgram VARCHAR(15) = NULL
	DECLARE @sort VARCHAR(255) = ''	
	DECLARE @keywordIn VARCHAR(10) = ''
    DECLARE @sectionActionSubmit VARCHAR(20) = 'submit'
    DECLARE @sectionActionApprove VARCHAR(20) = 'approve'
	DECLARE @sectionActionSubmitApprove VARCHAR(20) = 'submitapprove'
	DECLARE @documentP VARCHAR(50) = 'ProfilePicture'
	DECLARE @documentIC VARCHAR(50) = 'IDCard'
	DECLARE @documentI VARCHAR(50) = 'IdentityCard'
	DECLARE @documentT VARCHAR(50) = 'Transcript'
	DECLARE @documentTF VARCHAR(50) = 'TranscriptFrontside'
	DECLARE @documentTB VARCHAR(50) = 'TranscriptBackside'
	DECLARE @xml XML

	SET @sortOrderBy = (CASE WHEN (@sortOrderBy IS NOT NULL) AND (LEN(@sortOrderBy) > 0) THEN @sortOrderBy ELSE 'Student ID' END)
	SET @sortExpression = (CASE WHEN (@sortExpression IS NOT NULL) AND (LEN(@sortExpression) > 0) THEN @sortExpression ELSE 'Ascending' END)
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

	SELECT	A.value('.', 'VARCHAR(MAX)') as keyword
	INTO	#keywordTemp
	FROM	@xml.nodes('A') AS FN(A)
	
	SELECT	@userFaculty = autusr.facultyId,
			@userProgram = autusr.programId
	FROM	autUserAccessProgram AS autusr
	WHERE	(autusr.username = @username) AND
			(autusr.level = @userlevel) AND
			(autusr.systemGroup = @systemGroup)
	
	SET @userFaculty = ISNULL(@userFaculty, '')
	SET @userProgram = ISNULL(@userProgram, '')

	SELECT	stdper.id,
			udsull.perPersonId,
			stdper.studentId,
			stdper.studentCode,
			stdper.idCard,
			stdper.perTitlePrefixId,
			stdper.titlePrefixFullNameTH,
			stdper.titlePrefixInitialsTH, 
			stdper.titlePrefixFullNameEN,
			stdper.titlePrefixInitialsEN,
			stdper.firstName,
			stdper.middleName,
			stdper.lastName,
			stdper.firstNameEN, 
			stdper.middleNameEN,
			stdper.lastNameEN,
			stdper.degree,
			stdper.facultyId,
			stdper.facultyCode,
			stdper.programId,
			stdper.programCode,
			stdper.majorCode,
			stdper.groupNum, 
			stdper.yearEntry,
			stdper.perEntranceTypeId,
			stdper.status,
			stdper.statusGroup,
			@documentUpload AS documentUpload,
			(
				CASE @documentUpload
					WHEN (@documentP + @documentIC)	THEN 'PI'
					WHEN @documentP					THEN 'P'
					WHEN @documentI					THEN 'I'
					WHEN @documentT					THEN 'T'
					WHEN @documentTF				THEN 'TF'
					WHEN @documentTB				THEN 'TB'
				END
			) AS documentUploadInitials,
			udsull.profilepictureFileName,
			ISNULL(udsull.profilepictureSavedStatus, 'N') AS profilepictureSavedStatus, 
			(CASE WHEN (udsull.profilepictureSavedStatus IS NOT NULL) THEN udsull.profilepictureSavedDate ELSE NULL END) AS profilepictureSavedDate,
			ISNULL(udsull.profilepictureSubmittedStatus, 'N') AS profilepictureSubmittedStatus,
			(CASE WHEN (udsull.profilepictureSubmittedStatus IS NOT NULL) THEN udsull.profilepictureSubmittedDate ELSE NULL END) AS profilepictureSubmittedDate, 
			ISNULL(udsull.profilepictureApprovalStatus, 'S') AS profilepictureApprovalStatus,
			(CASE WHEN (udsull.profilepictureApprovalStatus IS NOT NULL) THEN udsull.profilepictureApprovalDate ELSE NULL END) AS profilepictureApprovalDate,
			udsull.profilepictureExportDate,
			udsull.identitycardFileName,
			ISNULL(udsull.identitycardSavedStatus, 'N') AS identitycardSavedStatus,
			(CASE WHEN (udsull.identitycardSavedStatus IS NOT NULL) THEN udsull.identitycardSavedDate ELSE NULL END) AS identitycardSavedDate,
			ISNULL(udsull.identitycardSubmittedStatus, 'N') AS identitycardSubmittedStatus, 
			(CASE WHEN (udsull.identitycardSubmittedStatus IS NOT NULL) THEN udsull.identitycardSubmittedDate ELSE NULL END) AS identitycardSubmittedDate,
			ISNULL(udsull.identitycardApprovalStatus, 'S') AS identitycardApprovalStatus,
			(CASE WHEN (udsull.identitycardApprovalStatus IS NOT NULL) THEN udsull.identitycardApprovalDate ELSE NULL END) AS identitycardApprovalDate, 
			udsull.perInstituteIdTranscript AS instituteIdTranscript, 
			perins.institutelNameTH AS institutelNameTHTranscript,
			perins.institutelNameEN AS institutelNameENTranscript, 
			plcpvn.plcCountryId AS instituteCountryIdTranscript,
			plccon.isoCountryCodes3Letter AS instituteCountryCodes3LetterTranscript,
			plccon.countryNameTH AS instituteCountryNameTHTranscript, 
			plccon.countryNameEN AS instituteCountryNameENTranscript,
			perins.plcProvinceId AS instituteProvinceIdTranscript,
			plcpvn.provinceNameTH AS instituteProvinceNameTHTranscript, 
			plcpvn.provinceNameEN AS instituteProvinceNameENTranscript,
			udsull.transcriptfrontsideFileName,
			ISNULL(udsull.transcriptfrontsideSavedStatus, 'N') AS transcriptfrontsideSavedStatus, 
			(CASE WHEN (udsull.transcriptfrontsideSavedStatus IS NOT NULL) THEN udsull.transcriptfrontsideSavedDate ELSE NULL END) AS transcriptfrontsideSavedDate,
			ISNULL(udsull.transcriptfrontsideSubmittedStatus, 'N') AS transcriptfrontsideSubmittedStatus,
			(CASE WHEN (udsull.transcriptfrontsideSubmittedStatus IS NOT NULL) THEN udsull.transcriptfrontsideSubmittedDate ELSE NULL END) AS transcriptfrontsideSubmittedDate,
			ISNULL(udsull.transcriptfrontsideApprovalStatus, 'S') AS transcriptfrontsideApprovalStatus,
			(CASE WHEN (udsull.transcriptfrontsideApprovalStatus IS NOT NULL) THEN udsull.transcriptfrontsideApprovalDate ELSE NULL END) AS transcriptfrontsideApprovalDate,
			udsull.transcriptbacksideFileName, 
			ISNULL(udsull.transcriptbacksideSavedStatus, 'N') AS transcriptbacksideSavedStatus,
			(CASE WHEN (udsull.transcriptbacksideSavedStatus IS NOT NULL) THEN udsull.transcriptbacksideSavedDate ELSE NULL END) AS transcriptbacksideSavedDate, 
			ISNULL(udsull.transcriptbacksideSubmittedStatus, 'N') AS transcriptbacksideSubmittedStatus,
			(CASE WHEN (udsull.transcriptbacksideSubmittedStatus IS NOT NULL) THEN udsull.transcriptbacksideSubmittedDate ELSE NULL END) AS transcriptbacksideSubmittedDate,
			ISNULL(udsull.transcriptbacksideApprovalStatus, 'S') AS transcriptbacksideApprovalStatus, 
			(CASE WHEN (udsull.transcriptbacksideApprovalStatus IS NOT NULL) THEN udsull.transcriptbacksideApprovalDate ELSE NULL END) AS transcriptbacksideApprovalDate,
			udsull.transcriptAuditSentDate, 
			(CASE WHEN (udsull.transcriptAuditSentDate IS NOT NULL) THEN 'Y' ELSE 'N' END) AS transcriptAuditSentStatus,
			(CASE WHEN (udsull.transcriptAuditSentDate IS NOT NULL AND udsull.transcriptResultAudit IS NOT NULL AND (udsull.transcriptResultAudit = 'Y' OR udsull.transcriptResultAudit = 'N') AND udsull.transcriptResultAuditReceivedDate IS NOT NULL) THEN udsull.transcriptResultAudit ELSE NULL END) AS transcriptResultAudit, 
			(CASE WHEN (udsull.transcriptAuditSentDate IS NOT NULL AND udsull.transcriptResultAudit IS NOT NULL AND (udsull.transcriptResultAudit = 'Y' OR udsull.transcriptResultAudit = 'N') AND udsull.transcriptResultAuditReceivedDate IS NOT NULL) THEN 'Y' ELSE 'N' END) AS transcriptResultAuditReceivedStatus, 
			(CASE WHEN (udsull.transcriptAuditSentDate IS NOT NULL AND udsull.transcriptResultAudit IS NOT NULL AND (udsull.transcriptResultAudit = 'Y' OR udsull.transcriptResultAudit = 'N') AND udsull.transcriptResultAuditReceivedDate IS NOT NULL) THEN udsull.transcriptResultAuditReceivedDate ELSE NULL END) AS transcriptResultAuditReceivedDate
	INTO	#udsTemp1
	FROM	vw_perGetListPersonStudent AS stdper LEFT JOIN
			udsUploadLog AS udsull ON stdper.id = udsull.perPersonId LEFT JOIN
			perInstitute AS perins ON udsull.perInstituteIdTranscript = perins.id LEFT JOIN
			plcProvince AS plcpvn ON perins.plcProvinceId = plcpvn.id LEFT JOIN
			plcCountry AS plccon ON plcpvn.plcCountryId = plccon.id
	WHERE	(1 = (CASE WHEN (@userFaculty <> 'MU-01') THEN 0 ELSE 1 END) OR stdper.facultyId = @userFaculty) AND
			(1 = (CASE WHEN (LEN(@userProgram) > 0 AND LEN(@userFaculty) > 0) THEN 0 ELSE 1 END) OR stdper.programId = @userProgram) AND
			(1 = (CASE WHEN (LEN(ISNULL(@documentUpload, '')) > 0 AND @sectionAction = @sectionActionApprove) THEN 0 ELSE 1 END) OR udsull.perPersonId IS NOT NULL)
	
	SELECT	udstmp.*
	INTO	#udsTemp2
	FROM	#udsTemp1 AS udstmp	LEFT JOIN
			#keywordTemp AS keytmp1 ON keytmp1.keyword = udstmp.id LEFT JOIN
			#keywordTemp AS keytmp2 ON keytmp2.keyword = udstmp.studentCode
	WHERE	(1 = (CASE WHEN (@keywordIn = 'INPERSON') THEN 0 ELSE 1 END) OR keytmp1.keyword IS NOT NULL) AND					
			(1 = (CASE WHEN (@keywordIn = 'IN') THEN 0 ELSE 1 END) OR keytmp2.keyword IS NOT NULL) AND
			(1 = (CASE WHEN (LEN(ISNULL(@keywordIn, '')) = 0 AND LEN(ISNULL(@keyword, '')) > 0) THEN 0 ELSE 1 END) OR
				(ISNULL(udstmp.studentCode, '') LIKE (@keyword + '%')) OR
				(ISNULL(udstmp.titlePrefixFullNameTH, '') LIKE ('%' + @keyword + '%')) OR
				(ISNULL(udstmp.titlePrefixInitialsTH, '') LIKE ('%' + @keyword + '%')) OR
				(ISNULL(udstmp.titlePrefixFullNameEN, '') LIKE ('%' + @keyword + '%')) OR
				(ISNULL(udstmp.titlePrefixInitialsEN, '') LIKE ('%' + @keyword + '%')) OR
				(ISNULL(udstmp.firstName, '') LIKE ('%' + @keyword + '%')) OR
				(ISNULL(udstmp.middleName, '') LIKE ('%' + @keyword + '%')) OR
				(ISNULL(udstmp.lastName, '') LIKE ('%' + @keyword + '%')) OR
				(ISNULL(udstmp.firstNameEN, '') LIKE ('%' + @keyword + '%')) OR
				(ISNULL(udstmp.middleNameEN, '') LIKE ('%' + @keyword + '%')) OR
				(ISNULL(udstmp.lastNameEN, '') LIKE ('%' + @keyword + '%')) OR
				(ISNULL(udstmp.idCard, '') LIKE ('%' + @keyword + '%'))) AND	
			(1 = (CASE WHEN (LEN(ISNULL(@degreeLevel, '')) > 0) THEN 0 ELSE 1 END) OR udstmp.degree = @degreeLevel) AND
			(1 = (CASE WHEN (LEN(ISNULL(@faculty, '')) > 0) THEN 0 ELSE 1 END) OR udstmp.facultyId = @faculty) AND
			(1 = (CASE WHEN (LEN(ISNULL(@program, '')) > 0) THEN 0 ELSE 1 END) OR udstmp.programId = @program) AND
			(1 = (CASE WHEN (LEN(ISNULL(@yearEntry, '')) > 0) THEN 0 ELSE 1 END) OR udstmp.yearEntry = @yearEntry) AND
			(1 = (CASE WHEN (LEN(ISNULL(@entranceType, '')) > 0) THEN 0 ELSE 1 END) OR udstmp.perEntranceTypeId = @entranceType) AND
			(1 = (CASE WHEN (LEN(ISNULL(@studentStatus, '')) > 0) THEN 0 ELSE 1 END) OR
				(udstmp.status = @studentStatus) OR
				(udstmp.statusGroup = (CASE WHEN (@studentStatus = '100') THEN '01' ELSE '' END))) AND
			(1 = (CASE WHEN (LEN(ISNULL(@documentUpload, '')) > 0 OR @sectionAction = @sectionActionSubmitApprove) THEN 0 ELSE 1 END) OR
				(CASE @documentUpload
					WHEN (@documentP + @documentIC) THEN
				 		CASE @sectionAction
							WHEN @sectionActionSubmit			THEN (profilepictureSubmittedStatus + identitycardSubmittedStatus)
							WHEN @sectionActionApprove			THEN (profilepictureApprovalStatus + identitycardApprovalStatus)
							WHEN @sectionActionSubmitApprove	THEN (profilepictureApprovalStatus + identitycardApprovalStatus)
						END
					WHEN @documentP THEN
						CASE @sectionAction 
							WHEN @sectionActionSubmit			THEN profilepictureSubmittedStatus
							WHEN @sectionActionApprove			THEN profilepictureApprovalStatus
							WHEN @sectionActionSubmitApprove	THEN profilepictureApprovalStatus
						END
					WHEN @documentI THEN
						CASE @sectionAction
							WHEN @sectionActionSubmit			THEN identitycardSubmittedStatus
							WHEN @sectionActionApprove			THEN identitycardApprovalStatus
							WHEN @sectionActionSubmitApprove	THEN identitycardApprovalStatus
						END
					WHEN @documentT THEN
						CASE @sectionAction
							WHEN @sectionActionSubmit			THEN (transcriptfrontsideSubmittedStatus + transcriptbacksideSubmittedStatus)
							WHEN @sectionActionApprove			THEN (transcriptfrontsideApprovalStatus + transcriptbacksideApprovalStatus)
							WHEN @sectionActionSubmitApprove	THEN (transcriptfrontsideApprovalStatus + transcriptbacksideApprovalStatus)
						END
					WHEN @documentTF THEN 
						CASE @sectionAction
							WHEN @sectionActionSubmit			THEN transcriptfrontsideSubmittedStatus
							WHEN @sectionActionApprove			THEN transcriptfrontsideApprovalStatus
							WHEN @sectionActionSubmitApprove	THEN transcriptfrontsideApprovalStatus
						END
					WHEN @documentTB THEN
						CASE @sectionAction
							WHEN @sectionActionSubmit			THEN transcriptbacksideSubmittedStatus
							WHEN @sectionActionApprove			THEN transcriptbacksideApprovalStatus
							WHEN @sectionActionSubmitApprove	THEN transcriptbacksideApprovalStatus
						END
					WHEN (@documentP + @documentI) THEN
						CASE @sectionAction
							WHEN @sectionActionApprove			THEN (CASE WHEN (yearEntry >= 2557) THEN (profilepictureApprovalStatus + identitycardApprovalStatus) ELSE profilepictureApprovalStatus END)
						END
					WHEN (@documentTF + @documentTB) THEN
						CASE @sectionAction
							WHEN @sectionActionApprove			THEN (transcriptfrontsideApprovalStatus + transcriptbacksideApprovalStatus)
							WHEN @sectionActionSubmitApprove	THEN (transcriptfrontsideApprovalStatus + transcriptbacksideApprovalStatus)
						END
					ELSE
						(profilepictureApprovalStatus + identitycardApprovalStatus + transcriptfrontsideApprovalStatus + transcriptbacksideApprovalStatus)
				 END) LIKE (CASE @sectionAction
								WHEN @sectionActionSubmit THEN
									CASE WHEN LEN(ISNULL(@submittedStatus, '')) > 0	THEN
										CASE @documentUpload
											WHEN (@documentP + @documentIC)		THEN ('%' + (ISNULL(@submittedStatus, '') + '%'))
											WHEN @documentT						THEN ('%' + (ISNULL(@submittedStatus, '') + '%'))
										ELSE
											ISNULL(@submittedStatus, '')
										END
									ELSE
										('%' + ISNULL(@submittedStatus, '') + '%')
									END
								WHEN @sectionActionApprove THEN
									CASE WHEN LEN(ISNULL(@approvalStatus, '')) > 0 THEN
										CASE @documentUpload
											WHEN (@documentP + @documentIC)		THEN ('%' + (ISNULL(@approvalStatus, '') + '%'))
											WHEN (@documentP + @documentI)		THEN (CASE WHEN (yearEntry >= 2557) THEN (ISNULL(@approvalStatus, '') + ISNULL(@approvalStatus, '')) ELSE ISNULL(@approvalStatus, '') END)
											WHEN @documentT						THEN ('%' + (ISNULL(@approvalStatus, '') + '%'))
											WHEN (@documentTF + @documentTB)	THEN (ISNULL(@approvalStatus, '') + ISNULL(@approvalStatus, ''))																
										ELSE										
											ISNULL(@approvalStatus, '')
										END
									ELSE
										('%' + ISNULL(@approvalStatus, '') + '%')
									END
								WHEN @sectionActionSubmitApprove THEN
									CASE WHEN (LEN(ISNULL(@approvalStatus, '')) > 0 AND LEN(ISNULL(@documentUpload, '')) > 0) THEN
										CASE @documentUpload
											WHEN (@documentP + @documentIC)		THEN ('%' + (ISNULL(@approvalStatus, '') + '%'))
											WHEN @documentT						THEN ('%' + (ISNULL(@approvalStatus, '') + '%'))
											WHEN (@documentTF + @documentTB)	THEN ('%' + (ISNULL(@approvalStatus, '') + '%'))
										ELSE												
											ISNULL(@approvalStatus, '')
										END
									ELSE
										('%' + ISNULL(@approvalStatus, '') + '%')
									END
							END) OR LEN(ISNULL(perPersonId, '')) = (CASE WHEN
																		(@sectionAction = @sectionActionApprove OR @submittedStatus = 'Y') OR
																		(@sectionAction = @sectionActionSubmitApprove AND LEN(ISNULL(@approvalStatus, '')) > 0 AND @approvalStatus <> 'S')
																	THEN
																		1
																	ELSE
																		0
																	END)
			) AND
			(1 = (CASE WHEN (LEN(ISNULL(@instituteCountry, '')) > 0) THEN 0 ELSE 1 END) OR instituteCountryIdTranscript = @instituteCountry) AND	
			(1 = (CASE WHEN (LEN(ISNULL(@instituteProvince, '')) > 0) THEN 0 ELSE 1 END) OR instituteProvinceIdTranscript = @instituteProvince) AND					
			(1 = (CASE WHEN (LEN(ISNULL(@institute, '')) > 0) THEN 0 ELSE 1 END) OR instituteIdTranscript = @institute) AND
			(1 = (CASE WHEN (LEN(ISNULL(@sentDateStartAudit, '')) > 0 AND LEN(ISNULL(@sentDateEndAudit, '')) > 0) THEN 0 ELSE 1 END) OR
				transcriptAuditSentDate BETWEEN CONVERT(VARCHAR, CONVERT(DATE, @sentDateStartAudit, 103)) AND CONVERT(VARCHAR, CONVERT(DATE, @sentDateEndAudit, 103))) AND	
			(1 = (CASE WHEN (LEN(ISNULL(@auditedStatus, '')) > 0) THEN 0 ELSE 1 END) OR transcriptResultAudit = @auditedStatus) AND
			(1 = (CASE WHEN (LEN(ISNULL(@exportStatus, '')) > 0) THEN 0 ELSE 1 END) OR
				(CASE @documentUpload
					WHEN (@documentP + @documentI) THEN
						CASE @sectionAction
							WHEN @sectionActionApprove THEN (CASE WHEN profilepictureExportDate IS NOT NULL THEN 'Y' ELSE 'N' END)
						END
				 END) = @exportStatus)

	SELECT	ROW_NUMBER() OVER(ORDER BY 
				CASE WHEN @sort = 'Student ID Ascending'	THEN (ISNULL(yearEntry, '') + ISNULL(studentCode, '')) END ASC,
				CASE WHEN @sort = 'Student ID Descending'	THEN (ISNULL(yearEntry, '') + ISNULL(studentCode, '')) END DESC
			) AS rowNum,			
			*
	FROM	#udsTemp2
	
	------------------------------------------------------------------------------------------------------------------------------------------------------
	
	IF (@reportName = 'DocumentStatusStudentViewChart')
	BEGIN
		SELECT	 'profilepicture' AS documentUpload,
				 profilepictureApprovalStatus AS approvalStatus,
				 (
					CASE profilepictureApprovalStatus
						WHEN 'S'	THEN '1,รอยืนยันการส่ง,Pending Submit,#CCCCCC,PendingSubmitDrillDown'
						WHEN 'W'	THEN '2,รอผลการอนุมัติ,Pending Approved,#F7DD02,PendingApprovedDrillDown'
						WHEN 'Y'	THEN '3,ได้รับการอนุมัติ,Approved,#00C600,ApprovedDrillDown'
						WHEN 'N'	THEN '4,ไม่ได้รับการอนุมัติ,Not Approved,#FE0101,NotApprovedDrillDown'
					END
				 ) AS series,
				 COUNT(id) AS countPeople
		FROM	 #udsTemp2
		GROUP BY profilepictureApprovalStatus
		ORDER BY series
		
		SELECT	 'profilepicture' AS documentUpload,
				 profilepictureApprovalStatus AS approvalStatus,
				 (
					CASE profilepictureApprovalStatus
						WHEN 'S'	THEN ('1,' + ISNULL(yearEntry, 'N/A') + ',PendingSubmitDrillDownYearEntry' + ISNULL(yearEntry, 'N/A'))
						WHEN 'W'	THEN ('2,' + ISNULL(yearEntry, 'N/A') + ',PendingApprovedDrillDownYearEntry' + ISNULL(yearEntry, 'N/A'))
						WHEN 'Y'	THEN ('3,' + ISNULL(yearEntry, 'N/A') + ',ApprovedDrillDownYearEntry' + ISNULL(yearEntry, 'N/A'))
						WHEN 'N'	THEN ('4,' + ISNULL(yearEntry, 'N/A') + ',NotApprovedDrillDownYearEntry' + ISNULL(yearEntry, 'N/A'))
					END
				 ) AS series,
				 COUNT(id) AS countPeople
		FROM	 #udsTemp2
		GROUP BY profilepictureApprovalStatus, yearEntry
		ORDER BY series, yearEntry

		SELECT	 'profilepicture' AS documentUpload,
				 profilepictureApprovalStatus AS approvalStatus,
				 ISNULL(yearEntry, 'N/A') AS yearEntry,
				 (
					CASE profilepictureApprovalStatus
						WHEN 'S'	THEN ('1,' + ISNULL(yearEntry, 'N/A') + ',' + ISNULL(facultyCode, ''))
						WHEN 'W'	THEN ('2,' + ISNULL(yearEntry, 'N/A') + ',' + ISNULL(facultyCode, ''))
						WHEN 'Y'	THEN ('3,' + ISNULL(yearEntry, 'N/A') + ',' + ISNULL(facultyCode, ''))
						WHEN 'N'	THEN ('4,' + ISNULL(yearEntry, 'N/A') + ',' + ISNULL(facultyCode, ''))
					END
				 ) AS series,
				 COUNT(id) AS countPeople
		FROM	 #udsTemp2
		GROUP BY profilepictureApprovalStatus, yearEntry, facultyCode
		ORDER BY series, yearEntry, facultyCode
		
		SELECT	 'identitycard' AS documentUpload,
				 identitycardApprovalStatus AS approvalStatus,
				 (
					CASE identitycardApprovalStatus
						WHEN 'S'	THEN '1,รอยืนยันการส่ง,Pending Submit,#CCCCCC,PendingSubmitDrillDown'
						WHEN 'W'	THEN '2,รอผลการอนุมัติ,Pending Approved,#F7DD02,PendingApprovedDrillDown'
						WHEN 'Y'	THEN '3,ได้รับการอนุมัติ,Approved,#00C600,ApprovedDrillDown'
						WHEN 'N'	THEN '4,ไม่ได้รับการอนุมัติ,Not Approved,#FE0101,NotApprovedDrillDown'
					END
				 ) AS series,
				 COUNT(id) AS countPeople
		FROM	 #udsTemp2
		GROUP BY identitycardApprovalStatus
		ORDER BY series

		SELECT	 'identitycard' AS documentUpload,
				 identitycardApprovalStatus AS approvalStatus,
				 (
					CASE identitycardApprovalStatus
						WHEN 'S'	THEN ('1,' + ISNULL(yearEntry, 'N/A') + ',PendingSubmitDrillDownYearEntry' + ISNULL(yearEntry, 'N/A'))
						WHEN 'W'	THEN ('2,' + ISNULL(yearEntry, 'N/A') + ',PendingApprovedDrillDownYearEntry' + ISNULL(yearEntry, 'N/A'))
						WHEN 'Y'	THEN ('3,' + ISNULL(yearEntry, 'N/A') + ',ApprovedDrillDownYearEntry' + ISNULL(yearEntry, 'N/A'))
						WHEN 'N'	THEN ('4,' + ISNULL(yearEntry, 'N/A') + ',NotApprovedDrillDownYearEntry' + ISNULL(yearEntry, 'N/A'))
					END
				 ) AS series,
				 COUNT(id) AS countPeople
		FROM	 #udsTemp2
		GROUP BY identitycardApprovalStatus, yearEntry
		ORDER BY series, yearEntry

		SELECT	 'identitycard' AS documentUpload,
				 identitycardApprovalStatus AS approvalStatus,
				 ISNULL(yearEntry, 'N/A') AS yearEntry,
				 (
					CASE identitycardApprovalStatus
						WHEN 'S'	THEN ('1,' + ISNULL(yearEntry, 'N/A') + ',' + ISNULL(facultyCode, ''))
						WHEN 'W'	THEN ('2,' + ISNULL(yearEntry, 'N/A') + ',' + ISNULL(facultyCode, ''))
						WHEN 'Y'	THEN ('3,' + ISNULL(yearEntry, 'N/A') + ',' + ISNULL(facultyCode, ''))
						WHEN 'N'	THEN ('4,' + ISNULL(yearEntry, 'N/A') + ',' + ISNULL(facultyCode, ''))
					END
				 ) AS series,
				 COUNT(id) AS countPeople
		FROM	 #udsTemp2
		GROUP BY identitycardApprovalStatus, yearEntry, facultyCode
		ORDER BY series, yearEntry, facultyCode

		SELECT	 'transcriptfrontside' AS documentUpload,
				 transcriptfrontsideApprovalStatus AS approvalStatus,
				 (
					CASE transcriptfrontsideApprovalStatus
						WHEN 'S'	THEN '1,รอยืนยันการส่ง,Pending Submit,#CCCCCC,PendingSubmitDrillDown'
						WHEN 'W'	THEN '2,รอผลการอนุมัติ,Pending Approved,#F7DD02,PendingApprovedDrillDown'
						WHEN 'Y'	THEN '3,ได้รับการอนุมัติ,Approved,#00C600,ApprovedDrillDown'
						WHEN 'N'	THEN '4,ไม่ได้รับการอนุมัติ,Not Approved,#FE0101,NotApprovedDrillDown'
					END
				 ) AS series,
				 COUNT(id) AS countPeople
		FROM	 #udsTemp2
		GROUP BY transcriptfrontsideApprovalStatus
		ORDER BY series

		SELECT	 'transcriptfrontside' AS documentUpload,
				 transcriptfrontsideApprovalStatus AS approvalStatus,
				 (
					CASE transcriptfrontsideApprovalStatus
						WHEN 'S'	THEN ('1,' + ISNULL(yearEntry, 'N/A') + ',PendingSubmitDrillDownYearEntry' + ISNULL(yearEntry, 'N/A'))
						WHEN 'W'	THEN ('2,' + ISNULL(yearEntry, 'N/A') + ',PendingApprovedDrillDownYearEntry' + ISNULL(yearEntry, 'N/A'))
						WHEN 'Y'	THEN ('3,' + ISNULL(yearEntry, 'N/A') + ',ApprovedDrillDownYearEntry' + ISNULL(yearEntry, 'N/A'))
						WHEN 'N'	THEN ('4,' + ISNULL(yearEntry, 'N/A') + ',NotApprovedDrillDownYearEntry' + ISNULL(yearEntry, 'N/A'))
					END
				 ) AS series,
				 COUNT(id) AS countPeople
		FROM	 #udsTemp2
		GROUP BY transcriptfrontsideApprovalStatus, yearEntry
		ORDER BY series, yearEntry

		SELECT	 'transcriptfrontside' AS documentUpload,
				 transcriptfrontsideApprovalStatus AS approvalStatus,
				 ISNULL(yearEntry, 'N/A') AS yearEntry,
				 (
					CASE transcriptfrontsideApprovalStatus
						WHEN 'S'	THEN ('1,' + ISNULL(yearEntry, 'N/A') + ',' + ISNULL(facultyCode, ''))
						WHEN 'W'	THEN ('2,' + ISNULL(yearEntry, 'N/A') + ',' + ISNULL(facultyCode, ''))
						WHEN 'Y'	THEN ('3,' + ISNULL(yearEntry, 'N/A') + ',' + ISNULL(facultyCode, ''))
						WHEN 'N'	THEN ('4,' + ISNULL(yearEntry, 'N/A') + ',' + ISNULL(facultyCode, ''))
					END
				 ) AS series,
				 COUNT(id) AS countPeople
		FROM	 #udsTemp2
		GROUP BY transcriptfrontsideApprovalStatus, yearEntry, facultyCode
		ORDER BY series, yearEntry, facultyCode

		SELECT	 'transcriptbackside' AS documentUpload,
				 transcriptbacksideApprovalStatus AS approvalStatus,
				 (
					CASE transcriptbacksideApprovalStatus
						WHEN 'S'	THEN '1,รอยืนยันการส่ง,Pending Submit,#CCCCCC,PendingSubmitDrillDown'
						WHEN 'W'	THEN '2,รอผลการอนุมัติ,Pending Approved,#F7DD02,PendingApprovedDrillDown'
						WHEN 'Y'	THEN '3,ได้รับการอนุมัติ,Approved,#00C600,ApprovedDrillDown'
						WHEN 'N'	THEN '4,ไม่ได้รับการอนุมัติ,Not Approved,#FE0101,NotApprovedDrillDown'
					END
				 ) AS series,
				 COUNT(id) AS countPeople
		FROM	 #udsTemp2
		GROUP BY transcriptbacksideApprovalStatus
		ORDER BY series

		SELECT	 'transcriptbackside' AS documentUpload,
				 transcriptbacksideApprovalStatus AS approvalStatus,
				 (
					CASE transcriptbacksideApprovalStatus
						WHEN 'S'	THEN ('1,' + ISNULL(yearEntry, 'N/A') + ',PendingSubmitDrillDownYearEntry' + ISNULL(yearEntry, 'N/A'))
						WHEN 'W'	THEN ('2,' + ISNULL(yearEntry, 'N/A') + ',PendingApprovedDrillDownYearEntry' + ISNULL(yearEntry, 'N/A'))
						WHEN 'Y'	THEN ('3,' + ISNULL(yearEntry, 'N/A') + ',ApprovedDrillDownYearEntry' + ISNULL(yearEntry, 'N/A'))
						WHEN 'N'	THEN ('4,' + ISNULL(yearEntry, 'N/A') + ',NotApprovedDrillDownYearEntry' + ISNULL(yearEntry, 'N/A'))
					END
				 ) AS series,
				 COUNT(id) AS countPeople
		FROM	 #udsTemp2
		GROUP BY transcriptbacksideApprovalStatus, yearEntry
		ORDER BY series, yearEntry

		SELECT	 'transcriptbackside' AS documentUpload,
				 transcriptbacksideApprovalStatus AS approvalStatus,
				 ISNULL(yearEntry, 'N/A') AS yearEntry,
				 (
					CASE transcriptbacksideApprovalStatus
						WHEN 'S'	THEN ('1,' + ISNULL(yearEntry, 'N/A') + ',' + ISNULL(facultyCode, ''))
						WHEN 'W'	THEN ('2,' + ISNULL(yearEntry, 'N/A') + ',' + ISNULL(facultyCode, ''))
						WHEN 'Y'	THEN ('3,' + ISNULL(yearEntry, 'N/A') + ',' + ISNULL(facultyCode, ''))
						WHEN 'N'	THEN ('4,' + ISNULL(yearEntry, 'N/A') + ',' + ISNULL(facultyCode, ''))
					END
				 ) AS series,
				 COUNT(id) AS countPeople
		FROM	 #udsTemp2
		GROUP BY transcriptbacksideApprovalStatus, yearEntry, facultyCode
		ORDER BY series, yearEntry, facultyCode
	END
	
	------------------------------------------------------------------------------------------------------------------------------------------------------
	
	IF (@reportName = 'AuditTranscriptApprovedViewChart' OR
		@reportName = 'AuditTranscriptApprovedLevel1ViewTable' OR
	 	@reportName = 'AuditTranscriptApprovedLevel21ViewTableNeedSend' OR
		@reportName = 'AuditTranscriptApprovedLevel22ViewTableNeedSend' OR
		@reportName = 'AuditTranscriptApprovedLevel21ViewTableSend' OR
		@reportName = 'AuditTranscriptApprovedLevel22ViewTableSend' OR
		@reportName = 'AuditTranscriptApprovedLevel21ViewTableNotSend' OR
		@reportName = 'AuditTranscriptApprovedLevel22ViewTableNotSend' OR
		@reportName = 'AuditTranscriptApprovedLevel21ViewTableSendReceive' OR
		@reportName = 'AuditTranscriptApprovedLevel22ViewTableSendReceive' OR
		@reportName = 'AuditTranscriptApprovedLevel21ViewTableSendNotReceive' OR
		@reportName = 'AuditTranscriptApprovedLevel22ViewTableSendNotReceive')
	BEGIN
		SELECT	 yearEntry,
				 instituteCountryIdTranscript,
				 instituteCountryCodes3LetterTranscript,
				 instituteProvinceIdTranscript,
				 instituteProvinceNameTHTranscript,
				 instituteProvinceNameENTranscript,
				 ISNULL(instituteIdTranscript, 'N/A') AS instituteIdTranscript,
				 institutelNameTHTranscript,
				 institutelNameENTranscript,
				 COUNT(id) AS countPeople
		INTO	 #udsTemp3
		FROM	 #udsTemp2
		GROUP BY yearEntry,
				 instituteCountryIdTranscript,
				 instituteCountryCodes3LetterTranscript,
				 instituteProvinceIdTranscript,
				 instituteProvinceNameTHTranscript,
				 instituteProvinceNameENTranscript,
				 instituteIdTranscript,
				 institutelNameTHTranscript,
				 institutelNameENTranscript
		
		SELECT	 yearEntry,
				 instituteCountryIdTranscript,
				 instituteCountryCodes3LetterTranscript,
				 instituteProvinceIdTranscript,
				 instituteProvinceNameTHTranscript,
				 instituteProvinceNameENTranscript,
				 ISNULL(instituteIdTranscript, 'N/A') AS instituteIdTranscript,
				 institutelNameTHTranscript,
				 institutelNameENTranscript,
				 COUNT(id) AS countPeople
		INTO	 #udsTemp4 
		FROM	 #udsTemp2
		WHERE	 transcriptAuditSentStatus = 'Y'
		GROUP BY yearEntry,
				 instituteCountryIdTranscript,
				 instituteCountryCodes3LetterTranscript,
				 instituteProvinceIdTranscript,
				 instituteProvinceNameTHTranscript,
				 instituteProvinceNameENTranscript,
				 instituteIdTranscript,
				 institutelNameTHTranscript,
				 institutelNameENTranscript

		SELECT	 yearEntry,
				 instituteCountryIdTranscript,
				 instituteCountryCodes3LetterTranscript,
				 instituteProvinceIdTranscript,
				 instituteProvinceNameTHTranscript,
				 instituteProvinceNameENTranscript,
				 ISNULL(instituteIdTranscript, 'N/A') AS instituteIdTranscript,
				 institutelNameTHTranscript,
				 institutelNameENTranscript,
				 COUNT(id) AS countPeople
		INTO	 #udsTemp5
		FROM	 #udsTemp2
		WHERE	 transcriptAuditSentStatus = 'N'
		GROUP BY yearEntry,
				 instituteCountryIdTranscript,
				 instituteCountryCodes3LetterTranscript,
				 instituteProvinceIdTranscript,
				 instituteProvinceNameTHTranscript,
				 instituteProvinceNameENTranscript,
				 instituteIdTranscript,
				 institutelNameTHTranscript,
				 institutelNameENTranscript

		SELECT	 yearEntry,
				 instituteCountryIdTranscript,
				 instituteCountryCodes3LetterTranscript,
				 instituteProvinceIdTranscript,
				 instituteProvinceNameTHTranscript,
				 instituteProvinceNameENTranscript,
				 ISNULL(instituteIdTranscript, 'N/A') AS instituteIdTranscript,
				 institutelNameTHTranscript,
				 institutelNameENTranscript,
				 COUNT(id) AS countPeople
		INTO	 #udsTemp6
		FROM	 #udsTemp2
		WHERE	 (transcriptAuditSentStatus = 'Y' AND transcriptResultAuditReceivedStatus = 'Y')
		GROUP BY yearEntry,
				 instituteCountryIdTranscript,
				 instituteCountryCodes3LetterTranscript,
				 instituteProvinceIdTranscript,
				 instituteProvinceNameTHTranscript,
				 instituteProvinceNameENTranscript,
				 instituteIdTranscript,
				 institutelNameTHTranscript,
				 institutelNameENTranscript

		SELECT	 yearEntry,
				 instituteCountryIdTranscript,
				 instituteCountryCodes3LetterTranscript,
				 instituteProvinceIdTranscript,
				 instituteProvinceNameTHTranscript,
				 instituteProvinceNameENTranscript,
				 ISNULL(instituteIdTranscript, 'N/A') AS instituteIdTranscript,
				 institutelNameTHTranscript,
				 institutelNameENTranscript,
				 COUNT(id) AS countPeople
		INTO	 #udsTemp7 
		FROM	 #udsTemp2
		WHERE	 (transcriptAuditSentStatus = 'Y' AND transcriptResultAuditReceivedStatus = 'N')
		GROUP BY yearEntry,
				 instituteCountryIdTranscript,
				 instituteCountryCodes3LetterTranscript,
				 instituteProvinceIdTranscript,
				 instituteProvinceNameTHTranscript,
				 instituteProvinceNameENTranscript,
				 instituteIdTranscript,
				 institutelNameTHTranscript,
				 institutelNameENTranscript

		SELECT	 a.yearEntry AS yearEntry1,
				 a.instituteCountryCodes3LetterTranscript AS instituteCountryCodes3LetterTranscript1,
				 ISNULL(a.instituteProvinceNameTHTranscript, a.instituteProvinceNameENTranscript) AS instituteProvinceNameTranscript1,
				 a.instituteIdTranscript AS instituteIdTranscript1,
				 ISNULL(a.institutelNameTHTranscript, a.institutelNameENTranscript) AS instituteNameTranscript1,
				 a.countPeople AS countPeople1,

				 b.yearEntry AS yearEntry2,
				 b.instituteCountryCodes3LetterTranscript AS instituteCountryCodes3LetterTranscript2,
				 ISNULL(b.instituteProvinceNameTHTranscript, b.instituteProvinceNameENTranscript) AS instituteProvinceNameTranscript2,
				 b.instituteIdTranscript AS instituteIdTranscript2,
				 ISNULL(b.institutelNameTHTranscript, b.institutelNameENTranscript) AS instituteNameTranscript2,
				 b.countPeople AS countPeople2,

				 c.yearEntry AS yearEntry3,
				 c.instituteCountryCodes3LetterTranscript AS instituteCountryCodes3LetterTranscript3,
				 ISNULL(c.instituteProvinceNameTHTranscript, c.instituteProvinceNameENTranscript) AS instituteProvinceNameTranscript3,
				 c.instituteIdTranscript AS instituteIdTranscript3,
				 ISNULL(c.institutelNameTHTranscript, c.institutelNameENTranscript) AS instituteNameTranscript3,
				 c.countPeople AS countPeople3,

				 d.yearEntry AS yearEntry4,
				 d.instituteCountryCodes3LetterTranscript AS instituteCountryCodes3LetterTranscript4,
				 ISNULL(d.instituteProvinceNameTHTranscript, d.instituteProvinceNameENTranscript) AS instituteProvinceNameTranscript4,
				 d.instituteIdTranscript AS instituteIdTranscript4,
				 ISNULL(d.institutelNameTHTranscript, d.institutelNameENTranscript) AS instituteNameTranscript4,
				 d.countPeople AS countPeople4,

				 e.yearEntry AS yearEntry5, 
				 e.instituteCountryCodes3LetterTranscript AS instituteCountryCodes3LetterTranscript5,
				 ISNULL(e.instituteProvinceNameTHTranscript, e.instituteProvinceNameENTranscript) AS instituteProvinceNameTranscript5,
				 e.instituteIdTranscript AS instituteIdTranscript5,
				 ISNULL(e.institutelNameTHTranscript, e.institutelNameENTranscript) AS instituteNameTranscript5,
				 e.countPeople AS countPeople5
		INTO	 #udsTemp8
		FROM	 #udsTemp3 AS a LEFT JOIN
				 #udsTemp4 AS b ON (a.yearEntry = b.yearEntry AND a.instituteIdTranscript = b.instituteIdTranscript) LEFT JOIN
				 #udsTemp5 AS c ON (a.yearEntry = c.yearEntry AND a.instituteIdTranscript = c.instituteIdTranscript) LEFT JOIN
				 #udsTemp6 AS d ON (b.yearEntry = d.yearEntry AND b.instituteIdTranscript = d.instituteIdTranscript) LEFT JOIN
				 #udsTemp7 AS e ON (b.yearEntry = e.yearEntry AND b.instituteIdTranscript = e.instituteIdTranscript)
	END

	------------------------------------------------------------------------------------------------------------------------------------------------------

	IF (@reportName = 'AuditTranscriptApprovedViewChart')
	BEGIN
		SELECT	 'จำนวนโรงเรียนและจำนวนนักศึกษาทั้งหมดที่ต้องส่งไปตรวจสอบคุณวุฒิ' AS title,
				 'จำนวน,Number of,จำนวน ( โรงเรียน ),Number of ( school ),#F8A13F,NumberofSchoolDrillDown' AS titleSeries1,
				 COUNT(instituteIdTranscript1) AS valueSeries1,
				 'จำนวน,Number of,จำนวน ( นักศึกษา ),Number of ( student ),#C0463D,NumberofStudentDrillDown' AS titleSeries2,
				 SUM(ISNULL(countPeople1, 0)) AS valueSeries2
		FROM	 #udsTemp8

		SELECT	 ISNULL(yearEntry1, 'N/A') AS yearEntry,
				 COUNT(instituteIdTranscript1) AS valueSeries1,
				 SUM(ISNULL(countPeople1, 0)) AS valueSeries2
		FROM	 #udsTemp8
		WHERE	 yearEntry1 IS NOT NULL
		GROUP BY yearEntry1
		ORDER BY yearEntry1

		SELECT	 'จำนวนโรงเรียนและจำนวนนักศึกษาทั้งหมดที่ส่งไปตรวจสอบคุณวุฒิ' AS title,
				 'จำนวน,Number of,จำนวน ( โรงเรียน ),Number of ( school ),#F8A13F,NumberofSchoolDrillDown' AS titleSeries1,
				 COUNT(instituteIdTranscript2) AS valueSeries1,
				 'จำนวน,Number of,จำนวน ( นักศึกษา ),Number of ( student ),#C0463D,NumberofStudentDrillDown' AS titleSeries2,
				 SUM(ISNULL(countPeople2, 0)) AS valueSeries2
		FROM	 #udsTemp8

		SELECT	 ISNULL(yearEntry1, 'N/A') AS yearEntry,
				 COUNT(instituteIdTranscript2) AS valueSeries1,
				 SUM(ISNULL(countPeople2, 0)) AS valueSeries2
		FROM	 #udsTemp8
		WHERE	 yearEntry2 IS NOT NULL
		GROUP BY yearEntry1
		ORDER BY yearEntry1

		SELECT	 'จำนวนโรงเรียนและจำนวนนักศึกษาทั้งหมดที่ยังไม่ส่งไปตรวจสอบคุณวุฒิ' AS title,
				 'จำนวน,Number of,จำนวน ( โรงเรียน ),Number of ( school ),#F8A13F,NumberofSchoolDrillDown' AS titleSeries1,
				 COUNT(CASE WHEN instituteIdTranscript2 IS NOT NULL THEN NULL ELSE instituteIdTranscript3 END) AS valueSeries1,
				 'จำนวน,Number of,จำนวน ( นักศึกษา ),Number of ( student ),#C0463D,NumberofStudentDrillDown' AS titleSeries2,
				 SUM(ISNULL(countPeople3, 0)) AS valueSeries2
		FROM	 #udsTemp8

		SELECT	 ISNULL(yearEntry1, 'N/A') AS yearEntry,
				 COUNT(CASE WHEN instituteIdTranscript2 IS NOT NULL THEN NULL ELSE instituteIdTranscript3 END) AS valueSeries1,
				 SUM(ISNULL(countPeople3, 0)) AS valueSeries2
		FROM	 #udsTemp8
		WHERE	 yearEntry3 IS NOT NULL
		GROUP BY yearEntry1
		ORDER BY yearEntry1

		SELECT	 'จำนวนโรงเรียนและจำนวนนักศึกษาทั้งหมดที่ส่งไปตรวจสอบคุณวุฒิและตอบกลับมา' AS title,
				 'จำนวน,Number of,จำนวน ( โรงเรียน ),Number of ( school ),#F8A13F,NumberofSchoolDrillDown' AS titleSeries1,
				 COUNT(instituteIdTranscript4) AS valueSeries1,
				 'จำนวน,Number of,จำนวน ( นักศึกษา ),Number of ( student ),#C0463D,NumberofStudentDrillDown' AS titleSeries2,
				 SUM(ISNULL(countPeople4, 0)) AS valueSeries2
		FROM	 #udsTemp8

		SELECT	 ISNULL(yearEntry1, 'N/A') AS yearEntry,
				 COUNT(instituteIdTranscript4) AS valueSeries1,
				 SUM(ISNULL(countPeople4, 0)) AS valueSeries2
		FROM	 #udsTemp8
		WHERE	 yearEntry4 IS NOT NULL
		GROUP BY yearEntry1
		ORDER BY yearEntry1

		SELECT	 'จำนวนโรงเรียนและจำนวนนักศึกษาทั้งหมดที่ส่งไปตรวจสอบคุณวุฒิและยังไม่ตอบกลับมา' AS title,
				 'จำนวน,Number of,จำนวน ( โรงเรียน ),Number of ( school ),#F8A13F,NumberofSchoolDrillDown' AS titleSeries1,
				 COUNT(CASE WHEN instituteIdTranscript4 IS NOT NULL THEN NULL ELSE instituteIdTranscript5 END) AS valueSeries1,
				 'จำนวน,Number of,จำนวน ( นักศึกษา ),Number of ( student ),#C0463D,NumberofStudentDrillDown' AS titleSeries2,
				 SUM(ISNULL(countPeople5, 0)) AS valueSeries2
		FROM	 #udsTemp8

		SELECT	 ISNULL(yearEntry1, 'N/A') AS yearEntry,
				 COUNT(CASE WHEN instituteIdTranscript4 IS NOT NULL THEN NULL ELSE instituteIdTranscript5 END) AS valueSeries1,
				 SUM(ISNULL(countPeople5, 0)) AS valueSeries2
		FROM	 #udsTemp8
		WHERE	 yearEntry5 IS NOT NULL
		GROUP BY yearEntry1
		ORDER BY yearEntry1
	END

	------------------------------------------------------------------------------------------------------------------------------------------------------

	IF (@reportName = 'AuditTranscriptApprovedLevel1ViewTable')
	BEGIN
		SELECT	 1 AS rowNum,
				 ('NeedSend' + yearEntry1) AS id,
				 'NeedSend' AS subject,
				 'จำนวนโรงเรียนและจำนวนนักศึกษาทั้งหมดที่ต้องส่งไปตรวจสอบคุณวุฒิ' AS title,
				 yearEntry1 AS yearEntry,
				 COUNT(instituteIdTranscript1) AS countInstitute,
				 SUM(ISNULL(countPeople1, 0)) AS countPeople
		FROM	 #udsTemp8
		WHERE	 yearEntry1 IS NOT NULL
		GROUP BY yearEntry1
		UNION
		SELECT	 2 AS rowNum,
				 ('Send' + yearEntry1) AS id,
				 'Send' AS subject,
				 'จำนวนโรงเรียนและจำนวนนักศึกษาทั้งหมดที่ส่งไปตรวจสอบคุณวุฒิ' AS title,
				 yearEntry1 AS yearEntry,
				 COUNT(instituteIdTranscript2) AS countInstitute,
				 SUM(ISNULL(countPeople2, 0)) AS countPeople
		FROM	 #udsTemp8
		WHERE	 yearEntry2 IS NOT NULL
		GROUP BY yearEntry1
		UNION
		SELECT	 3 AS rowNum,
				 ('NotSend' + yearEntry1) AS id,
				 'NotSend' AS subject,
				 'จำนวนโรงเรียนและจำนวนนักศึกษาทั้งหมดที่ยังไม่ส่งไปตรวจสอบคุณวุฒิ' AS title,
				 yearEntry1 AS yearEntry,
				 COUNT(CASE WHEN instituteIdTranscript2 IS NOT NULL THEN NULL ELSE instituteIdTranscript3 END) AS countInstitute,
				 SUM(ISNULL(countPeople3, 0)) AS countPeople
		FROM	 #udsTemp8
		WHERE	 yearEntry3 IS NOT NULL
		GROUP BY yearEntry1
		UNION
		SELECT	 4 AS rowNum,
				 ('SendReceive' + yearEntry1) AS id,
				 'SendReceive' AS subject,
				 'จำนวนโรงเรียนและจำนวนนักศึกษาทั้งหมดที่ส่งไปตรวจสอบคุณวุฒิและตอบกลับมา' AS title,
				 yearEntry1 AS yearEntry,
				 COUNT(instituteIdTranscript4) AS countInstitute,
				 SUM(ISNULL(countPeople4, 0)) AS countPeople
		FROM	 #udsTemp8
		WHERE	 yearEntry4 IS NOT NULL
		GROUP BY yearEntry1
		UNION
		SELECT	 5 AS rowNum,
				 ('SendNotReceive' + yearEntry1) AS id,
				 'SendNotReceive' AS subject,
				 'จำนวนโรงเรียนและจำนวนนักศึกษาทั้งหมดที่ส่งไปตรวจสอบคุณวุฒิและยังไม่ตอบกลับมา' AS title,
				 yearEntry1 AS yearEntry,
				 COUNT(CASE WHEN instituteIdTranscript4 IS NOT NULL THEN NULL ELSE instituteIdTranscript5 END) AS countInstitute,
				 SUM(ISNULL(countPeople5, 0)) AS countPeople
		FROM	 #udsTemp8
		WHERE	 yearEntry5 IS NOT NULL
		GROUP BY yearEntry1
	END

	------------------------------------------------------------------------------------------------------------------------------------------------------

	IF (@reportName = 'AuditTranscriptApprovedLevel21ViewTableNeedSend' OR
		@reportName = 'AuditTranscriptApprovedLevel21ViewTableSend' OR
		@reportName = 'AuditTranscriptApprovedLevel21ViewTableNotSend' OR
		@reportName = 'AuditTranscriptApprovedLevel21ViewTableSendReceive' OR
		@reportName = 'AuditTranscriptApprovedLevel21ViewTableSendNotReceive')
	BEGIN
		SELECT	COUNT(instituteIdTranscript1)
		FROM	#udsTemp8
		WHERE	yearEntry1 = @yearEntry

		IF (@reportName = 'AuditTranscriptApprovedLevel21ViewTableNeedSend')
		BEGIN
			SELECT	 ROW_NUMBER() OVER(ORDER BY
						yearEntry1,
						instituteCountryCodes3LetterTranscript1,
						instituteProvinceNameTranscript1,
						instituteNameTranscript1
					 ) AS rowNum,
					 instituteIdTranscript1 AS id,
					 yearEntry1 AS yearEntry,
					 instituteCountryCodes3LetterTranscript1 AS instituteCountryCodes3LetterTranscript,
					 instituteProvinceNameTranscript1 AS instituteProvinceNameTranscript,					 
					 instituteNameTranscript1 AS instituteNameTranscript,
					 SUM(ISNULL(countPeople1, 0)) AS countPeople
			FROM	 #udsTemp8
			WHERE	 yearEntry1 = @yearEntry
			GROUP BY yearEntry1, instituteCountryCodes3LetterTranscript1, instituteProvinceNameTranscript1, instituteIdTranscript1, instituteNameTranscript1
		END

		IF (@reportName = 'AuditTranscriptApprovedLevel21ViewTableSend')
		BEGIN
			SELECT	 ROW_NUMBER() OVER(ORDER BY
						yearEntry1,
						instituteCountryCodes3LetterTranscript2,
						instituteProvinceNameTranscript2,
						instituteNameTranscript2
					 ) AS rowNum,					 						
					 instituteIdTranscript2 AS id,
					 yearEntry1 AS yearEntry,
					 instituteCountryCodes3LetterTranscript2 AS instituteCountryCodes3LetterTranscript,
					 instituteProvinceNameTranscript2 AS instituteProvinceNameTranscript,					 
					 instituteNameTranscript2 AS instituteNameTranscript,
					 SUM(ISNULL(countPeople2, 0)) AS countPeople
			FROM	 #udsTemp8
			WHERE	 yearEntry2 = @yearEntry
			GROUP BY yearEntry1, instituteCountryCodes3LetterTranscript2, instituteProvinceNameTranscript2, instituteIdTranscript2, instituteNameTranscript2			
		END
		
		IF (@reportName = 'AuditTranscriptApprovedLevel21ViewTableNotSend')
		BEGIN
			SELECT	 ROW_NUMBER() OVER(ORDER BY
						yearEntry,
						instituteCountryCodes3LetterTranscript,
						instituteProvinceNameTranscript,
						instituteNameTranscript
					 ) AS rowNum,
					 *
			FROM	 (
						SELECT	 instituteIdTranscript3 AS id,
								 yearEntry1 AS yearEntry,
								 instituteCountryCodes3LetterTranscript3 AS instituteCountryCodes3LetterTranscript,
								 instituteProvinceNameTranscript3 AS instituteProvinceNameTranscript,								 
								 (CASE WHEN instituteIdTranscript2 IS NOT NULL THEN (instituteNameTranscript3 + ' ( มีการส่งไปบางส่วน ) ') ELSE instituteNameTranscript3 END) AS instituteNameTranscript,
								 SUM(ISNULL(countPeople3, 0)) AS countPeople
						FROM	 #udsTemp8
						WHERE	 yearEntry3 = @yearEntry
						GROUP BY yearEntry1, instituteIdTranscript2, instituteCountryCodes3LetterTranscript3, instituteProvinceNameTranscript3, instituteIdTranscript3, instituteNameTranscript3
					 ) AS a 
		END

		IF (@reportName = 'AuditTranscriptApprovedLevel21ViewTableSendReceive')
		BEGIN
			SELECT	 ROW_NUMBER() OVER(ORDER BY
						yearEntry1,
						instituteCountryCodes3LetterTranscript4,
						instituteProvinceNameTranscript4,
						instituteNameTranscript4
					 ) AS rowNum,
					 instituteIdTranscript4 AS id,
					 yearEntry1 AS yearEntry,
					 instituteCountryCodes3LetterTranscript4 AS instituteCountryCodes3LetterTranscript,
					 instituteProvinceNameTranscript4 AS instituteProvinceNameTranscript,					 
					 instituteNameTranscript4 AS instituteNameTranscript,
					 SUM(ISNULL(countPeople4, 0)) AS countPeople
			FROM	 #udsTemp8
			WHERE	 yearEntry4 = @yearEntry
			GROUP BY yearEntry1, instituteCountryCodes3LetterTranscript4, instituteProvinceNameTranscript4, instituteIdTranscript4, instituteNameTranscript4
		END

		IF (@reportName = 'AuditTranscriptApprovedLevel21ViewTableSendNotReceive')
		BEGIN
			SELECT	 ROW_NUMBER() OVER(ORDER BY
						yearEntry,
						instituteCountryCodes3LetterTranscript,
						instituteProvinceNameTranscript,
						instituteNameTranscript
					 ) AS rowNum,
					 *
			FROM	 (
						SELECT	 instituteIdTranscript5 AS id,
								 yearEntry1 AS yearEntry,
								 instituteCountryCodes3LetterTranscript5 AS instituteCountryCodes3LetterTranscript,
								 instituteProvinceNameTranscript5 AS instituteProvinceNameTranscript,								 
								 (CASE WHEN instituteIdTranscript4 IS NOT NULL THEN (instituteNameTranscript5 + ' ( มีการตอบกลับบางส่วน ) ') ELSE instituteNameTranscript5 END) AS instituteNameTranscript,
								 SUM(ISNULL(countPeople5, 0)) AS countPeople
						FROM	 #udsTemp8
						WHERE	 yearEntry5 = @yearEntry
						GROUP BY yearEntry1, instituteIdTranscript4, instituteCountryCodes3LetterTranscript5, instituteProvinceNameTranscript5, instituteIdTranscript5, instituteNameTranscript5
					 ) AS a
		END		
	END
	
	------------------------------------------------------------------------------------------------------------------------------------------------------
	
	IF (@reportName = 'AuditTranscriptApprovedLevel22ViewTableNeedSend' OR
		@reportName = 'AuditTranscriptApprovedLevel22ViewTableSend' OR
		@reportName = 'AuditTranscriptApprovedLevel22ViewTableNotSend' OR
		@reportName = 'AuditTranscriptApprovedLevel22ViewTableSendReceive' OR
		@reportName = 'AuditTranscriptApprovedLevel22ViewTableSendNotReceive')
	BEGIN
		SELECT	SUM(ISNULL(countPeople1, 0))
		FROM	#udsTemp8
		WHERE	yearEntry1 = @yearEntry

		SELECT	id,
				studentId,
				studentCode,
				titlePrefixFullNameTH,
				titlePrefixInitialsTH,					
				titlePrefixFullNameEN,
				titlePrefixInitialsEN,
				firstName,
				middleName,
				lastName,
				firstNameEN,
				middleNameEN,
				lastNameEN,
				facultyId,
				facultyCode,
				programId,
				programCode,
				majorCode,
				groupNum,
				yearEntry,
				perEntranceTypeId,
				status,
				transcriptAuditSentDate,
				transcriptAuditSentStatus,
				transcriptResultAudit,
				transcriptResultAuditReceivedStatus,
				transcriptResultAuditReceivedDate,
				instituteCountryIdTranscript,
				instituteCountryCodes3LetterTranscript,
				ISNULL(instituteCountryNameTHTranscript, instituteCountryNameENTranscript) AS instituteCountryNameTranscript,				
				instituteProvinceIdTranscript,
				ISNULL(instituteProvinceNameTHTranscript, instituteProvinceNameENTranscript) AS instituteProvinceNameTranscript,
				instituteIdTranscript,
				ISNULL(institutelNameTHTranscript, institutelNameENTranscript) AS institutelNameTranscript
		INTO	#udsTemp9
		FROM	#udsTemp2
		WHERE	yearEntry = @yearEntry

		IF (@reportName = 'AuditTranscriptApprovedLevel22ViewTableNeedSend')
		BEGIN
			SELECT	ROW_NUMBER() OVER(ORDER BY
							CASE WHEN @sort = 'Student ID Ascending'		THEN studentCode END ASC,
							CASE WHEN @sort = 'Name Ascending'				THEN firstName END ASC,
							CASE WHEN @sort = 'Faculty Ascending'			THEN facultyId END ASC,
							CASE WHEN @sort = 'Program Ascending'			THEN programId END ASC,
							CASE WHEN @sort = 'Year Attended Ascending'		THEN yearEntry END ASC
					) AS rowNum,
					*
			FROM	#udsTemp9
		END

		IF (@reportName = 'AuditTranscriptApprovedLevel22ViewTableSend')
		BEGIN
			SELECT	ROW_NUMBER() OVER(ORDER BY
							CASE WHEN @sort = 'Student ID Ascending'		THEN studentCode END ASC,
							CASE WHEN @sort = 'Name Ascending'				THEN firstName END ASC,
							CASE WHEN @sort = 'Faculty Ascending'			THEN facultyId END ASC,
							CASE WHEN @sort = 'Program Ascending'			THEN programId END ASC,
							CASE WHEN @sort = 'Year Attended Ascending'		THEN yearEntry END ASC
					) AS rowNum,
					*
			FROM	#udsTemp9
			WHERE	transcriptAuditSentStatus = 'Y'
		END

		IF (@reportName = 'AuditTranscriptApprovedLevel22ViewTableNotSend')
		BEGIN
			SELECT	ROW_NUMBER() OVER(ORDER BY
							CASE WHEN @sort = 'Student ID Ascending'		THEN studentCode END ASC,
							CASE WHEN @sort = 'Name Ascending'				THEN firstName END ASC,
							CASE WHEN @sort = 'Faculty Ascending'			THEN facultyId END ASC,
							CASE WHEN @sort = 'Program Ascending'			THEN programId END ASC,
							CASE WHEN @sort = 'Year Attended Ascending'		THEN yearEntry END ASC
					) AS rowNum,
					*
			FROM	#udsTemp9
			WHERE	transcriptAuditSentStatus = 'N'
		END

		IF (@reportName = 'AuditTranscriptApprovedLevel22ViewTableSendReceive')
		BEGIN
			SELECT	ROW_NUMBER() OVER(ORDER BY
							CASE WHEN @sort = 'Student ID Ascending'		THEN studentCode END ASC,
							CASE WHEN @sort = 'Name Ascending'				THEN firstName END ASC,
							CASE WHEN @sort = 'Faculty Ascending'			THEN facultyId END ASC,
							CASE WHEN @sort = 'Program Ascending'			THEN programId END ASC,
							CASE WHEN @sort = 'Year Attended Ascending'		THEN yearEntry END ASC
					) AS rowNum,
					*
			FROM	#udsTemp9
			WHERE	(transcriptAuditSentStatus = 'Y' AND transcriptResultAuditReceivedStatus = 'Y')
		END

		IF (@reportName = 'AuditTranscriptApprovedLevel22ViewTableSendNotReceive')
		BEGIN
			SELECT	ROW_NUMBER() OVER(ORDER BY
							CASE WHEN @sort = 'Student ID Ascending'		THEN studentCode END ASC,
							CASE WHEN @sort = 'Name Ascending'				THEN firstName END ASC,
							CASE WHEN @sort = 'Faculty Ascending'			THEN facultyId END ASC,
							CASE WHEN @sort = 'Program Ascending'			THEN programId END ASC,
							CASE WHEN @sort = 'Year Attended Ascending'		THEN yearEntry END ASC
					) AS rowNum,
					*
			FROM	#udsTemp9
			WHERE	(transcriptAuditSentStatus = 'Y' AND transcriptResultAuditReceivedStatus = 'N')
		END
	END
END
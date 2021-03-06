USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_udsSetUploadLog]    Script Date: 22-07-2016 13:09:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๑/๐๖/๒๕๕๘>
-- Description	: <สำหรับบันทึกข้อมูลตาราง  udsUploadLog ครั้งละ ๑ เรคคอร์ด>
--	1. section					เป็น VARCHAR	รับค่าชื่อหัวข้อที่อัพโหลด
--	2. sectionAction			เป็น VARCHAR	รับค่าการกระทำที่เกิดขึ้นกับหัวข้อที่อัพโหลด
--  3. personId 				เป็น VARCHAR	รับค่ารหัสบุคคล
--	4. transcriptInstitute		เป็น VARCHAR	รับค่ารหัสสถาบัน / โรงเรียน
--	5. filename					เป็น NVARCHAR	รับค่าชื่อไฟล์
--  6. savedStatus				เป็น VARCHAR	รับค่าสถานะการ Save
--	7. submittedStatus			เป็น VARCHAR	รับค่าสถานะการ Submit
--	8. approvalStatus			เป็น VARCHAR	รับค่าสถานะการ Approve
--	9. approvalBy				เป็น NVARCHAR	รับค่าชื่อผู้ Approve
-- 10. approvalIP				เป็น VARCHAR	รับค่าหมายเลขไอพีของผู้ Approve
-- 11. message					เป็น TEXT		รับค่าข้อความ
-- 12. auditSentDate			เป็น VARCHAR	รับค่าวันที่ส่งระเบียนแสดงผลการเรียนตรวจสอบ
-- 13. auditSentBy				เป็น NVARCHAR	รับค่าชื่อของผู้ที่ส่งระเบียนแสดงผลการเรียนตรวจสอบ
-- 14. auditSentIP				เป็น VARCHAR	รับค่าหมายเลขไอพีของผู้ที่ส่งระเบียนแสดงผลการเรียนตรวจสอบ
-- 15. resultAudit				เป็น VARCHAR	รับค่าผลการตรวจสอบระเบียนแสดงผลการเรียน
-- 16. resultAuditReceivedDate	เป็น VARCHAR	รับค่าวันที่รับผลการตรวจสอบระเบียนแสดงผลการเรียน
-- 17. resultAuditReceivedBy	เป็น NVARCHAR	รับค่าชื่อของผู้ที่รับผลการตรวจสอบระเบียนแสดงผลการเรียน
-- 18. resultAuditReceivedIP	เป็น VARCHAR	รับค่าหมายเลขไอพีของผู้ที่รับผลการตรวจสอบระเบียนแสดงผลการเรียน
-- 19. by						เป็น NVARCHAR	รับค่าชื่อของผู้ที่กระทำกับฐานข้อมูล
-- 20. ip						เป็น VARCHAR	รับค่าหมายเลขไอพีของผู้ที่กระทำกับฐานข้อมูล
/*
transcriptAuditSentDate	datetime	Checked
transcriptResultAuditReceivedDate	datetime	Checked
transcriptResultAudit	varchar(1)	Checked
*/
-- =============================================
ALTER PROCEDURE [dbo].[sp_udsSetUploadLog]
(
	@personId VARCHAR(10) = NULL,
	@section VARCHAR(255) = NULL,
	@sectionAction VARCHAR(255) = NULL,	
	@transcriptInstitute VARCHAR(10) = NULL,
	@filename NVARCHAR(100) = NULL,	
	@savedStatus VARCHAR(1) = NULL,
	@submittedStatus VARCHAR(1) = NULL,
	@approvalStatus VARCHAR(1) = NULL,
	@approvalBy NVARCHAR(255) = NULL,
	@approvalIP VARCHAR(20) = NULL,
	@message NVARCHAR(MAX) = NULL,
	@auditSentDate VARCHAR(20) = NULL,
	@auditSentBy NVARCHAR(255) = NULL,
	@auditSentIP VARCHAR(20) = NULL,
	@resultAudit VARCHAR(1) = NULL,
	@resultAuditReceivedDate VARCHAR(20) = NULL,
	@resultAuditReceivedBy NVARCHAR(255) = NULL,
	@resultAuditReceivedIP VARCHAR(20) = NULL,		
	@by NVARCHAR(255) = NULL,
	@ip VARCHAR(255) = NULL
)	
AS
BEGIN
	SET NOCOUNT ON

	SET @personId = LTRIM(RTRIM(@personId))
	SET @section = LTRIM(RTRIM(@section))
	SET @sectionAction = LTRIM(RTRIM(@sectionAction))	
	SET @transcriptInstitute = LTRIM(RTRIM(@transcriptInstitute))
	SET @filename = LTRIM(RTRIM(@filename))
	SET @savedStatus = LTRIM(RTRIM(@savedStatus))
	SET @submittedStatus = LTRIM(RTRIM(@submittedStatus))
	SET @approvalStatus = LTRIM(RTRIM(@approvalStatus))
	SET @approvalBy = LTRIM(RTRIM(@approvalBy))
	SET @approvalIP = LTRIM(RTRIM(@approvalIP))
	SET @message = LTRIM(RTRIM(@message))
	SET @auditSentDate = LTRIM(RTRIM(@auditSentDate))
	SET @auditSentBy = LTRIM(RTRIM(@auditSentBy))
	SET @auditSentIP = LTRIM(RTRIM(@auditSentIP))
	SET @resultAudit = LTRIM(RTRIM(@resultAudit))
	SET @resultAuditReceivedDate = LTRIM(RTRIM(@resultAuditReceivedDate))
	SET @resultAuditReceivedBy = LTRIM(RTRIM(@resultAuditReceivedBy))
	SET @resultAuditReceivedIP = LTRIM(RTRIM(@resultAuditReceivedIP))
	SET @by = LTRIM(RTRIM(@by))
	SET @ip = LTRIM(RTRIM(@ip))
	
    DECLARE @subjectSectionProfilePicture VARCHAR(50) = 'ProfilePicture'
    DECLARE @subjectSectionIdentityCard VARCHAR(50) = 'IdentityCard'
    DECLARE @subjectSectionTranscript VARCHAR(50) = 'Transcript'
    DECLARE @subjectSectionTranscriptFrontside VARCHAR(50) = 'TranscriptFrontside'
    DECLARE @subjectSectionTranscriptBackside VARCHAR(50) = 'TranscriptBackside'
    DECLARE @sectionActionSave VARCHAR(10) = 'save'
    DECLARE @sectionActionSubmit VARCHAR(10) = 'submit'
    DECLARE @sectionActionApprove VARCHAR(10) = 'approve'
    DECLARE @sectionActionSend VARCHAR(10) = 'send'
    DECLARE @sectionActionReceive VARCHAR(10) = 'receive'
	DECLARE @action VARCHAR(10) = NULL	
	DECLARE @table VARCHAR(50) = 'udsUploadLog'
	DECLARE @rowCount INT = 0
	DECLARE @rowCountUpdate INT = 0
	DECLARE @value NVARCHAR(MAX) = NULL
	DECLARE	@strBlank VARCHAR(50) = '----------**********.........0.0000000000000000000'
	
	IF ((@section IS NOT NULL AND LEN(@section) > 0 AND (@section = @subjectSectionProfilePicture OR @section = @subjectSectionIdentityCard OR @section = (@subjectSectionProfilePicture + @subjectSectionIdentityCard) OR @section = @subjectSectionTranscript OR @section = @subjectSectionTranscriptFrontside OR @section = @subjectSectionTranscriptBackside)) AND
		(@sectionAction IS NOT NULL AND LEN(@sectionAction) > 0 AND (@sectionAction = @sectionActionSave OR @sectionAction = @sectionActionSubmit OR @sectionAction = @sectionActionApprove OR @sectionAction = @sectionActionSend OR @sectionAction = @sectionActionReceive)) AND
		(@personId IS NOT NULL AND LEN(@personId) > 0))
	BEGIN
		SET @rowCountUpdate = (SELECT COUNT(perPersonId) FROM Infinity..udsUploadLog WHERE perPersonId = @personId)
		SET @action = (CASE WHEN @rowCountUpdate = 0 THEN 'INSERT' ELSE 'UPDATE' END)		

		SET @value = 'section='						+ ('"' + @section + '"') + ', ' +
					 'sectionAction='				+ ('"' + @sectionAction + '"') + ', ' +
					 'perPersonId='					+ ('"' + @personId + '"') + ', ' +
					 'perInstituteIdTranscript='	+(CASE WHEN (@transcriptInstitute IS NOT NULL AND LEN(@transcriptInstitute) > 0 AND CHARINDEX(@transcriptInstitute, @strBlank) = 0) THEN ('"' + @transcriptInstitute + '"') ELSE 'NULL' END) + ', ' +
					 'filename='					+ (CASE WHEN (@filename IS NOT NULL AND LEN(@filename) > 0 AND CHARINDEX(@filename, @strBlank) = 0) THEN ('"' + @filename + '"') ELSE 'NULL' END) + ', ' +
					 'savedStatus='					+ (CASE WHEN (@savedStatus IS NOT NULL AND LEN(@savedStatus) > 0 AND CHARINDEX(@savedStatus, @strBlank) = 0) THEN ('"' + @savedStatus + '"') ELSE '"N"' END) + ', ' +
					 'submittedStatus='				+ (CASE WHEN (@submittedStatus IS NOT NULL AND LEN(@submittedStatus) > 0 AND CHARINDEX(@submittedStatus, @strBlank) = 0) THEN ('"' + @submittedStatus + '"') ELSE '"N"' END) + ', ' +
					 'approvalStatus='				+ (CASE WHEN (@approvalStatus IS NOT NULL AND LEN(@approvalStatus) > 0 AND CHARINDEX(@approvalStatus, @strBlank) = 0) THEN ('"' + @approvalStatus + '"') ELSE '"S"' END) + ', ' +
					 'approvalBy='					+ (CASE WHEN (@approvalBy IS NOT NULL AND LEN(@approvalBy) > 0 AND CHARINDEX(@approvalBy, @strBlank) = 0) THEN ('"' + @approvalBy + '"') ELSE 'NULL' END) + ', ' +
					 'approvalIP='					+ (CASE WHEN (@approvalIP IS NOT NULL AND LEN(@approvalIP) > 0 AND CHARINDEX(@approvalIP, @strBlank) = 0) THEN ('"' + @approvalIP + '"') ELSE 'NULL' END) + ', ' +
					 'message='						+ (CASE WHEN (@message IS NOT NULL AND LEN(@message) > 0 AND CHARINDEX(@message, @strBlank) = 0) THEN ('"' + @message + '"') ELSE 'NULL' END) + ', ' +
					 'auditSentDate='				+ (CASE WHEN (@auditSentDate IS NOT NULL AND LEN(@auditSentDate) > 0 AND CHARINDEX(@auditSentDate, @strBlank) = 0) THEN ('"' + @auditSentDate + '"') ELSE 'NULL' END) + ', ' +
					 'auditSentBy='					+ (CASE WHEN (@auditSentBy IS NOT NULL AND LEN(@auditSentBy) > 0 AND CHARINDEX(@auditSentBy, @strBlank) = 0) THEN ('"' + @auditSentBy + '"') ELSE 'NULL' END) + ', ' +
					 'auditSentIP='					+ (CASE WHEN (@auditSentIP IS NOT NULL AND LEN(@auditSentIP) > 0 AND CHARINDEX(@auditSentIP, @strBlank) = 0) THEN ('"' + @auditSentIP + '"') ELSE 'NULL' END) + ', ' +
					 'resultAudit='					+ (CASE WHEN (@resultAudit IS NOT NULL AND LEN(@resultAudit) > 0 AND CHARINDEX(@resultAudit, @strBlank) = 0) THEN ('"' + @resultAudit + '"') ELSE 'NULL' END) + ', ' +
					 'resultAuditReceivedDate='		+ (CASE WHEN (@resultAuditReceivedDate IS NOT NULL AND LEN(@resultAuditReceivedDate) > 0 AND CHARINDEX(@resultAuditReceivedDate, @strBlank) = 0) THEN ('"' + @resultAuditReceivedDate + '"') ELSE 'NULL' END) + ', ' +
					 'resultAuditReceivedBy='		+ (CASE WHEN (@resultAuditReceivedBy IS NOT NULL AND LEN(@resultAuditReceivedBy) > 0 AND CHARINDEX(@resultAuditReceivedBy, @strBlank) = 0) THEN ('"' + @resultAuditReceivedBy + '"') ELSE 'NULL' END) + ', ' +
					 'resultAuditReceivedIP='		+ (CASE WHEN (@resultAuditReceivedIP IS NOT NULL AND LEN(@resultAuditReceivedIP) > 0 AND CHARINDEX(@resultAuditReceivedIP, @strBlank) = 0) THEN ('"' + @resultAuditReceivedIP + '"') ELSE 'NULL' END)
					 
		BEGIN TRY
			BEGIN TRAN
				IF (@action = 'INSERT')
				BEGIN
 					INSERT INTO Infinity..udsUploadLog
 					(
						perPersonId,
						profilepictureFileName,
						profilepictureSavedStatus,
						profilepictureSavedDate,
						profilepictureSubmittedStatus,
						profilepictureSubmittedDate,
						profilepictureApprovalStatus,
						profilepictureApprovalDate,
						profilepictureApprovalBy,
						profilepictureApprovalIP,
						profilepictureMessage,
						profilepictureExportDate,
						profilepictureExportBy,
						profilepictureExportIP,
						identitycardFileName,
						identitycardSavedStatus,
						identitycardSavedDate,
						identitycardSubmittedStatus,
						identitycardSubmittedDate,
						identitycardApprovalStatus,
						identitycardApprovalDate,
						identitycardApprovalBy,
						identitycardApprovalIP,
						identitycardMessage,						
						perInstituteIdTranscript,
						transcriptfrontsideFileName,
						transcriptfrontsideSavedStatus,
						transcriptfrontsideSavedDate,
						transcriptfrontsideSubmittedStatus,
						transcriptfrontsideSubmittedDate,
						transcriptfrontsideApprovalStatus,
						transcriptfrontsideApprovalDate,
						transcriptfrontsideApprovalBy,
						transcriptfrontsideApprovalIP,
						transcriptfrontsideMessage,
						transcriptbacksideFileName,
						transcriptbacksideSavedStatus,
						transcriptbacksideSavedDate,
						transcriptbacksideSubmittedStatus,
						transcriptbacksideSubmittedDate,
						transcriptbacksideApprovalStatus,
						transcriptbacksideApprovalDate,
						transcriptbacksideApprovalBy,
						transcriptbacksideApprovalIP,
						transcriptbacksideMessage,
						transcriptAuditSentDate,
						transcriptAuditSentBy,
						transcriptAuditSentIP,
						transcriptResultAudit,
						transcriptResultAuditReceivedDate,
						transcriptResultAuditReceivedBy,
						transcriptResultAuditReceivedIP
					)
					VALUES
					(
						@personId,
						(CASE WHEN (@section = @subjectSectionProfilePicture AND @filename IS NOT NULL AND LEN(@filename) > 0 AND CHARINDEX(@filename, @strBlank) = 0) THEN @filename ELSE NULL END),
						(CASE WHEN (@section = @subjectSectionProfilePicture AND @savedStatus IS NOT NULL AND LEN(@savedStatus) > 0 AND CHARINDEX(@savedStatus, @strBlank) = 0) THEN @savedStatus ELSE 'N' END),
						(CASE WHEN (@section = @subjectSectionProfilePicture AND @sectionAction = @sectionActionSave) THEN GETDATE() ELSE NULL END),
						(CASE WHEN (@section = @subjectSectionProfilePicture AND @submittedStatus IS NOT NULL AND LEN(@submittedStatus) > 0 AND CHARINDEX(@submittedStatus, @strBlank) = 0) THEN @submittedStatus ELSE 'N' END),
						(CASE WHEN (@section = @subjectSectionProfilePicture AND @sectionAction = @sectionActionSubmit) THEN GETDATE() ELSE NULL END),
						(CASE WHEN (@section = @subjectSectionProfilePicture AND @approvalStatus IS NOT NULL AND LEN(@approvalStatus) > 0 AND CHARINDEX(@approvalStatus, @strBlank) = 0) THEN @approvalStatus ELSE 'S' END),
						(CASE WHEN (@section = @subjectSectionProfilePicture AND @sectionAction = @sectionActionApprove) THEN GETDATE() ELSE NULL END),
						(CASE WHEN (@section = @subjectSectionProfilePicture AND @approvalBy IS NOT NULL AND LEN(@approvalBy) > 0 AND CHARINDEX(@approvalBy, @strBlank) = 0) THEN @approvalBy ELSE NULL END),
						(CASE WHEN (@section = @subjectSectionProfilePicture AND @approvalIP IS NOT NULL AND LEN(@approvalIP) > 0 AND CHARINDEX(@approvalIP, @strBlank) = 0) THEN @approvalIP ELSE NULL END),
						(CASE WHEN (@section = @subjectSectionProfilePicture AND @message IS NOT NULL AND LEN(@message) > 0 AND CHARINDEX(@message, @strBlank) = 0) THEN @message ELSE NULL END),
						(CASE WHEN (@section = (@subjectSectionProfilePicture + @subjectSectionIdentityCard) AND @sectionAction = @sectionActionApprove) THEN GETDATE() ELSE NULL END),
						(CASE WHEN (@section = (@subjectSectionProfilePicture + @subjectSectionIdentityCard) AND @sectionAction = @sectionActionApprove AND @by IS NOT NULL AND LEN(@by) > 0 AND CHARINDEX(@by, @strBlank) = 0) THEN @by ELSE NULL END),
						(CASE WHEN (@section = (@subjectSectionProfilePicture + @subjectSectionIdentityCard) AND @sectionAction = @sectionActionApprove AND @ip IS NOT NULL AND LEN(@ip) > 0 AND CHARINDEX(@ip, @strBlank) = 0) THEN @ip ELSE NULL END),
						(CASE WHEN (@section = @subjectSectionIdentityCard AND @filename IS NOT NULL AND LEN(@filename) > 0 AND CHARINDEX(@filename, @strBlank) = 0) THEN @filename ELSE NULL END),
						(CASE WHEN (@section = @subjectSectionIdentityCard AND @savedStatus IS NOT NULL AND LEN(@savedStatus) > 0 AND CHARINDEX(@savedStatus, @strBlank) = 0) THEN @savedStatus ELSE 'N' END),
						(CASE WHEN (@section = @subjectSectionIdentityCard AND @sectionAction = @sectionActionSave) THEN GETDATE() ELSE NULL END),
						(CASE WHEN (@section = @subjectSectionIdentityCard AND @submittedStatus IS NOT NULL AND LEN(@submittedStatus) > 0 AND CHARINDEX(@submittedStatus, @strBlank) = 0) THEN @submittedStatus ELSE 'N' END),
						(CASE WHEN (@section = @subjectSectionIdentityCard AND @sectionAction = @sectionActionSubmit) THEN GETDATE() ELSE NULL END),
						(CASE WHEN (@section = @subjectSectionIdentityCard AND @approvalStatus IS NOT NULL AND LEN(@approvalStatus) > 0 AND CHARINDEX(@approvalStatus, @strBlank) = 0) THEN @approvalStatus ELSE 'S' END),
						(CASE WHEN (@section = @subjectSectionIdentityCard AND @sectionAction = @sectionActionApprove) THEN GETDATE() ELSE NULL END),
						(CASE WHEN (@section = @subjectSectionIdentityCard AND @approvalBy IS NOT NULL AND LEN(@approvalBy) > 0 AND CHARINDEX(@approvalBy, @strBlank) = 0) THEN @approvalBy ELSE NULL END),
						(CASE WHEN (@section = @subjectSectionIdentityCard AND @approvalIP IS NOT NULL AND LEN(@approvalIP) > 0 AND CHARINDEX(@approvalIP, @strBlank) = 0) THEN @approvalIP ELSE NULL END),
						(CASE WHEN (@section = @subjectSectionIdentityCard AND @message IS NOT NULL AND LEN(@message) > 0 AND CHARINDEX(@message, @strBlank) = 0) THEN @message ELSE NULL END),						
						(CASE WHEN ((@section = @subjectSectionTranscriptFrontside OR @section = @subjectSectionTranscriptBackside) AND @transcriptInstitute IS NOT NULL AND LEN(@transcriptInstitute) > 0 AND CHARINDEX(@transcriptInstitute, @strBlank) = 0) THEN @transcriptInstitute ELSE NULL END),
						(CASE WHEN (@section = @subjectSectionTranscriptFrontside AND @filename IS NOT NULL AND LEN(@filename) > 0 AND CHARINDEX(@filename, @strBlank) = 0) THEN @filename ELSE NULL END),
						(CASE WHEN (@section = @subjectSectionTranscriptFrontside AND @savedStatus IS NOT NULL AND LEN(@savedStatus) > 0 AND CHARINDEX(@savedStatus, @strBlank) = 0) THEN @savedStatus ELSE 'N' END),
						(CASE WHEN (@section = @subjectSectionTranscriptFrontside AND @sectionAction = @sectionActionSave) THEN GETDATE() ELSE NULL END),
						(CASE WHEN (@section = @subjectSectionTranscriptFrontside AND @submittedStatus IS NOT NULL AND LEN(@submittedStatus) > 0 AND CHARINDEX(@submittedStatus, @strBlank) = 0) THEN @submittedStatus ELSE 'N' END),
						(CASE WHEN (@section = @subjectSectionTranscriptFrontside AND @sectionAction = @sectionActionSubmit) THEN GETDATE() ELSE NULL END),
						(CASE WHEN (@section = @subjectSectionTranscriptFrontside AND @approvalStatus IS NOT NULL AND LEN(@approvalStatus) > 0 AND CHARINDEX(@approvalStatus, @strBlank) = 0) THEN @approvalStatus ELSE 'S' END),
						(CASE WHEN (@section = @subjectSectionTranscriptFrontside AND @sectionAction = @sectionActionApprove) THEN GETDATE() ELSE NULL END),
						(CASE WHEN (@section = @subjectSectionTranscriptFrontside AND @approvalBy IS NOT NULL AND LEN(@approvalBy) > 0 AND CHARINDEX(@approvalBy, @strBlank) = 0) THEN @approvalBy ELSE NULL END),
						(CASE WHEN (@section = @subjectSectionTranscriptFrontside AND @approvalIP IS NOT NULL AND LEN(@approvalIP) > 0 AND CHARINDEX(@approvalIP, @strBlank) = 0) THEN @approvalIP ELSE NULL END),
						(CASE WHEN (@section = @subjectSectionTranscriptFrontside AND @message IS NOT NULL AND LEN(@message) > 0 AND CHARINDEX(@message, @strBlank) = 0) THEN @message ELSE NULL END),
						(CASE WHEN (@section = @subjectSectionTranscriptBackside AND @filename IS NOT NULL AND LEN(@filename) > 0 AND CHARINDEX(@filename, @strBlank) = 0) THEN @filename ELSE NULL END),
						(CASE WHEN (@section = @subjectSectionTranscriptBackside AND @savedStatus IS NOT NULL AND LEN(@savedStatus) > 0 AND CHARINDEX(@savedStatus, @strBlank) = 0) THEN @savedStatus ELSE 'N' END),
						(CASE WHEN (@section = @subjectSectionTranscriptBackside AND @sectionAction = @sectionActionSave) THEN GETDATE() ELSE NULL END),
						(CASE WHEN (@section = @subjectSectionTranscriptBackside AND @submittedStatus IS NOT NULL AND LEN(@submittedStatus) > 0 AND CHARINDEX(@submittedStatus, @strBlank) = 0) THEN @submittedStatus ELSE 'N' END),
						(CASE WHEN (@section = @subjectSectionTranscriptBackside AND @sectionAction = @sectionActionSubmit) THEN GETDATE() ELSE NULL END),
						(CASE WHEN (@section = @subjectSectionTranscriptBackside AND @approvalStatus IS NOT NULL AND LEN(@approvalStatus) > 0 AND CHARINDEX(@approvalStatus, @strBlank) = 0) THEN @approvalStatus ELSE 'S' END),
						(CASE WHEN (@section = @subjectSectionTranscriptBackside AND @sectionAction = @sectionActionApprove) THEN GETDATE() ELSE NULL END),
						(CASE WHEN (@section = @subjectSectionTranscriptBackside AND @approvalBy IS NOT NULL AND LEN(@approvalBy) > 0 AND CHARINDEX(@approvalBy, @strBlank) = 0) THEN @approvalBy ELSE NULL END),
						(CASE WHEN (@section = @subjectSectionTranscriptBackside AND @approvalIP IS NOT NULL AND LEN(@approvalIP) > 0 AND CHARINDEX(@approvalIP, @strBlank) = 0) THEN @approvalIP ELSE NULL END),
						(CASE WHEN (@section = @subjectSectionTranscriptBackside AND @message IS NOT NULL AND LEN(@message) > 0 AND CHARINDEX(@message, @strBlank) = 0) THEN @message ELSE NULL END),
						(CASE WHEN (@section = @subjectSectionTranscript AND @sectionAction = @sectionActionSend AND @auditSentDate IS NOT NULL AND LEN(@auditSentDate) > 0 AND CHARINDEX(@auditSentDate, @strBlank) = 0) THEN CONVERT(DATETIME, @auditSentDate, 103) ELSE NULL END),
						(CASE WHEN (@section = @subjectSectionTranscript AND @sectionAction = @sectionActionSend AND @auditSentBy IS NOT NULL AND LEN(@auditSentBy) > 0 AND CHARINDEX(@auditSentBy, @strBlank) = 0) THEN @auditSentBy ELSE NULL END),
						(CASE WHEN (@section = @subjectSectionTranscript AND @sectionAction = @sectionActionSend AND @auditSentIP IS NOT NULL AND LEN(@auditSentIP) > 0 AND CHARINDEX(@auditSentIP, @strBlank) = 0) THEN @auditSentIP ELSE NULL END),
						(CASE WHEN (@section = @subjectSectionTranscript AND @sectionAction = @sectionActionReceive AND @resultAudit IS NOT NULL AND LEN(@resultAudit) > 0 AND CHARINDEX(@resultAudit, @strBlank) = 0) THEN @resultAudit ELSE NULL END),
						(CASE WHEN (@section = @subjectSectionTranscript AND @sectionAction = @sectionActionReceive AND @resultAuditReceivedDate IS NOT NULL AND LEN(@resultAuditReceivedDate) > 0 AND CHARINDEX(@resultAuditReceivedDate, @strBlank) = 0) THEN CONVERT(DATETIME, @resultAuditReceivedDate, 103) ELSE NULL END),
						(CASE WHEN (@section = @subjectSectionTranscript AND @sectionAction = @sectionActionReceive AND @resultAuditReceivedBy IS NOT NULL AND LEN(@resultAuditReceivedBy) > 0 AND CHARINDEX(@resultAuditReceivedBy, @strBlank) = 0) THEN @resultAuditReceivedBy ELSE NULL END),
						(CASE WHEN (@section = @subjectSectionTranscript AND @sectionAction = @sectionActionReceive AND @resultAuditReceivedIP IS NOT NULL AND LEN(@resultAuditReceivedIP) > 0 AND CHARINDEX(@resultAuditReceivedIP, @strBlank) = 0) THEN @resultAuditReceivedIP ELSE NULL END)
					)		
					
					SET @rowCount = @rowCount + 1
				END					 
				
				IF (@action = 'UPDATE')
				BEGIN 
					UPDATE Infinity..udsUploadLog SET
						profilepictureFileName				= (CASE WHEN (@section = @subjectSectionProfilePicture) THEN (CASE WHEN (@filename IS NOT NULL AND LEN(@filename) > 0 AND CHARINDEX(@filename, @strBlank) = 0) THEN @filename ELSE NULL END) ELSE profilepictureFileName END),
						profilepictureSavedStatus			= (CASE WHEN (@section = @subjectSectionProfilePicture) THEN (CASE WHEN (@savedStatus IS NOT NULL AND LEN(@savedStatus) > 0 AND CHARINDEX(@savedStatus, @strBlank) = 0) THEN @savedStatus ELSE NULL END) ELSE profilepictureSavedStatus END),
						profilepictureSavedDate				= (CASE WHEN (@section = @subjectSectionProfilePicture) THEN (CASE WHEN (@savedStatus <> profilepictureSavedStatus) THEN GETDATE() ELSE profilepictureSavedDate END) ELSE profilepictureSavedDate END),
						profilepictureSubmittedStatus		= (CASE WHEN (@section = @subjectSectionProfilePicture) THEN (CASE WHEN (@submittedStatus IS NOT NULL AND LEN(@submittedStatus) > 0 AND CHARINDEX(@submittedStatus, @strBlank) = 0) THEN @submittedStatus ELSE NULL END) ELSE profilepictureSubmittedStatus END),
						profilepictureSubmittedDate			= (CASE WHEN (@section = @subjectSectionProfilePicture) THEN (CASE WHEN (@submittedStatus <> profilepictureSubmittedStatus) THEN GETDATE() ELSE profilepictureSubmittedDate END) ELSE profilepictureSubmittedDate END),
						profilepictureApprovalStatus		= (CASE WHEN (@section = @subjectSectionProfilePicture) THEN (CASE WHEN (@approvalStatus IS NOT NULL AND LEN(@approvalStatus) > 0 AND CHARINDEX(@approvalStatus, @strBlank) = 0) THEN @approvalStatus ELSE NULL END) ELSE profilepictureApprovalStatus END),
						profilepictureApprovalDate			= (CASE WHEN (@section = @subjectSectionProfilePicture) THEN GETDATE() ELSE profilepictureApprovalDate END),
						profilepictureApprovalBy			= (CASE WHEN (@section = @subjectSectionProfilePicture) THEN (CASE WHEN (@approvalBy IS NOT NULL AND LEN(@approvalBy) > 0 AND CHARINDEX(@approvalBy, @strBlank) = 0) THEN @approvalBy ELSE NULL END) ELSE profilepictureApprovalBy END),
						profilepictureApprovalIP			= (CASE WHEN (@section = @subjectSectionProfilePicture) THEN (CASE WHEN (@approvalIP IS NOT NULL AND LEN(@approvalIP) > 0 AND CHARINDEX(@approvalIP, @strBlank) = 0) THEN @approvalIP ELSE NULL END) ELSE profilepictureApprovalIP END),
						profilepictureMessage				= (CASE WHEN (@section = @subjectSectionProfilePicture) THEN (CASE WHEN (@message IS NOT NULL AND LEN(@message) > 0 AND CHARINDEX(@message, @strBlank) = 0) THEN @message ELSE NULL END) ELSE profilepictureMessage END),
						profilepictureExportDate			= (CASE WHEN (@section = (@subjectSectionProfilePicture + @subjectSectionIdentityCard) AND @sectionAction = @sectionActionApprove) THEN GETDATE() ELSE profilepictureExportDate END),
						profilepictureExportBy				= (CASE WHEN (@section = (@subjectSectionProfilePicture + @subjectSectionIdentityCard) AND @sectionAction = @sectionActionApprove) THEN (CASE WHEN (@by IS NOT NULL AND LEN(@by) > 0 AND CHARINDEX(@by, @strBlank) = 0) THEN @by ELSE NULL END) ELSE profilepictureExportBy END),						
						profilepictureExportIP				= (CASE WHEN (@section = (@subjectSectionProfilePicture + @subjectSectionIdentityCard) AND @sectionAction = @sectionActionApprove) THEN (CASE WHEN (@ip IS NOT NULL AND LEN(@ip) > 0 AND CHARINDEX(@ip, @strBlank) = 0) THEN @ip ELSE NULL END) ELSE profilepictureExportIP END),
						identitycardFileName				= (CASE WHEN (@section = @subjectSectionIdentityCard) THEN (CASE WHEN (@filename IS NOT NULL AND LEN(@filename) > 0 AND CHARINDEX(@filename, @strBlank) = 0) THEN @filename ELSE NULL END) ELSE identitycardFileName END),
						identitycardSavedStatus				= (CASE WHEN (@section = @subjectSectionIdentityCard) THEN (CASE WHEN (@savedStatus IS NOT NULL AND LEN(@savedStatus) > 0 AND CHARINDEX(@savedStatus, @strBlank) = 0) THEN @savedStatus ELSE NULL END) ELSE identitycardSavedStatus END),
						identitycardSavedDate				= (CASE WHEN (@section = @subjectSectionIdentityCard) THEN (CASE WHEN (@savedStatus <> identitycardSavedStatus) THEN GETDATE() ELSE identitycardSavedDate END) ELSE identitycardSavedDate END),
						identitycardSubmittedStatus			= (CASE WHEN (@section = @subjectSectionIdentityCard) THEN (CASE WHEN (@submittedStatus IS NOT NULL AND LEN(@submittedStatus) > 0 AND CHARINDEX(@submittedStatus, @strBlank) = 0) THEN @submittedStatus ELSE NULL END) ELSE identitycardSubmittedStatus END),
						identitycardSubmittedDate			= (CASE WHEN (@section = @subjectSectionIdentityCard) THEN (CASE WHEN (@submittedStatus <> identitycardSubmittedStatus) THEN GETDATE() ELSE identitycardSubmittedDate END) ELSE identitycardSubmittedDate END),
						identitycardApprovalStatus			= (CASE WHEN (@section = @subjectSectionIdentityCard) THEN (CASE WHEN (@approvalStatus IS NOT NULL AND LEN(@approvalStatus) > 0 AND CHARINDEX(@approvalStatus, @strBlank) = 0) THEN @approvalStatus ELSE NULL END) ELSE identitycardApprovalStatus END),
						identitycardApprovalDate			= (CASE WHEN (@section = @subjectSectionIdentityCard) THEN GETDATE() ELSE identitycardApprovalDate END),
						identitycardApprovalBy				= (CASE WHEN (@section = @subjectSectionIdentityCard) THEN (CASE WHEN (@approvalBy IS NOT NULL AND LEN(@approvalBy) > 0 AND CHARINDEX(@approvalBy, @strBlank) = 0) THEN @approvalBy ELSE NULL END) ELSE identitycardApprovalBy END),
						identitycardApprovalIP				= (CASE WHEN (@section = @subjectSectionIdentityCard) THEN (CASE WHEN (@approvalIP IS NOT NULL AND LEN(@approvalIP) > 0 AND CHARINDEX(@approvalIP, @strBlank) = 0) THEN @approvalIP ELSE NULL END) ELSE identitycardApprovalIP END),
						identitycardMessage					= (CASE WHEN (@section = @subjectSectionIdentityCard) THEN (CASE WHEN (@message IS NOT NULL AND LEN(@message) > 0 AND CHARINDEX(@message, @strBlank) = 0) THEN @message ELSE NULL END) ELSE identitycardMessage END),
						perInstituteIdTranscript			= (CASE WHEN (@section = @subjectSectionTranscriptFrontside OR @section = @subjectSectionTranscriptBackside) THEN (CASE WHEN (@transcriptInstitute IS NOT NULL AND LEN(@transcriptInstitute) > 0 AND CHARINDEX(@transcriptInstitute, @strBlank) = 0) THEN @transcriptInstitute ELSE NULL END) ELSE perInstituteIdTranscript END),
						transcriptfrontsideFileName			= (CASE WHEN (@section = @subjectSectionTranscriptFrontside) THEN (CASE WHEN (@filename IS NOT NULL AND LEN(@filename) > 0 AND CHARINDEX(@filename, @strBlank) = 0) THEN @filename ELSE NULL END) ELSE transcriptfrontsideFileName END),
						transcriptfrontsideSavedStatus		= (CASE WHEN (@section = @subjectSectionTranscriptFrontside) THEN (CASE WHEN (@savedStatus IS NOT NULL AND LEN(@savedStatus) > 0 AND CHARINDEX(@savedStatus, @strBlank) = 0) THEN @savedStatus ELSE NULL END) ELSE transcriptfrontsideSavedStatus END),
						transcriptfrontsideSavedDate		= (CASE WHEN (@section = @subjectSectionTranscriptFrontside) THEN (CASE WHEN (@savedStatus <> transcriptfrontsideSavedStatus) THEN GETDATE() ELSE transcriptfrontsideSavedDate END) ELSE transcriptfrontsideSavedDate END),
						transcriptfrontsideSubmittedStatus	= (CASE WHEN (@section = @subjectSectionTranscriptFrontside) THEN (CASE WHEN (@submittedStatus IS NOT NULL AND LEN(@submittedStatus) > 0 AND CHARINDEX(@submittedStatus, @strBlank) = 0) THEN @submittedStatus ELSE NULL END) ELSE transcriptfrontsideSubmittedStatus END),
						transcriptfrontsideSubmittedDate	= (CASE WHEN (@section = @subjectSectionTranscriptFrontside) THEN (CASE WHEN (@submittedStatus <> transcriptfrontsideSubmittedStatus) THEN GETDATE() ELSE transcriptfrontsideSubmittedDate END) ELSE transcriptfrontsideSubmittedDate END),
						transcriptfrontsideApprovalStatus	= (CASE WHEN (@section = @subjectSectionTranscriptFrontside) THEN (CASE WHEN (@approvalStatus IS NOT NULL AND LEN(@approvalStatus) > 0 AND CHARINDEX(@approvalStatus, @strBlank) = 0) THEN @approvalStatus ELSE NULL END) ELSE transcriptfrontsideApprovalStatus END),
						transcriptfrontsideApprovalDate		= (CASE WHEN (@section = @subjectSectionTranscriptFrontside) THEN GETDATE() ELSE transcriptfrontsideApprovalDate END),
						transcriptfrontsideApprovalBy		= (CASE WHEN (@section = @subjectSectionTranscriptFrontside) THEN (CASE WHEN (@approvalBy IS NOT NULL AND LEN(@approvalBy) > 0 AND CHARINDEX(@approvalBy, @strBlank) = 0) THEN @approvalBy ELSE NULL END) ELSE transcriptfrontsideApprovalBy END),
						transcriptfrontsideApprovalIP		= (CASE WHEN (@section = @subjectSectionTranscriptFrontside) THEN (CASE WHEN (@approvalIP IS NOT NULL AND LEN(@approvalIP) > 0 AND CHARINDEX(@approvalIP, @strBlank) = 0) THEN @approvalIP ELSE NULL END) ELSE transcriptfrontsideApprovalIP END),
						transcriptfrontsideMessage			= (CASE WHEN (@section = @subjectSectionTranscriptFrontside) THEN (CASE WHEN (@message IS NOT NULL AND LEN(@message) > 0 AND CHARINDEX(@message, @strBlank) = 0) THEN @message ELSE NULL END) ELSE transcriptfrontsideMessage END),
						transcriptbacksideFileName			= (CASE WHEN (@section = @subjectSectionTranscriptBackside) THEN (CASE WHEN (@filename IS NOT NULL AND LEN(@filename) > 0 AND CHARINDEX(@filename, @strBlank) = 0) THEN @filename ELSE NULL END) ELSE transcriptbacksideFileName END),
						transcriptbacksideSavedStatus		= (CASE WHEN (@section = @subjectSectionTranscriptBackside) THEN (CASE WHEN (@savedStatus IS NOT NULL AND LEN(@savedStatus) > 0 AND CHARINDEX(@savedStatus, @strBlank) = 0) THEN @savedStatus ELSE NULL END) ELSE transcriptbacksideSavedStatus END),
						transcriptbacksideSavedDate			= (CASE WHEN (@section = @subjectSectionTranscriptBackside) THEN (CASE WHEN (@savedStatus <> transcriptbacksideSavedStatus) THEN GETDATE() ELSE transcriptbacksideSavedDate END) ELSE transcriptbacksideSavedDate END),
						transcriptbacksideSubmittedStatus	= (CASE WHEN (@section = @subjectSectionTranscriptBackside) THEN (CASE WHEN (@submittedStatus IS NOT NULL AND LEN(@submittedStatus) > 0 AND CHARINDEX(@submittedStatus, @strBlank) = 0) THEN @submittedStatus ELSE NULL END) ELSE transcriptbacksideSubmittedStatus END),
						transcriptbacksideSubmittedDate		= (CASE WHEN (@section = @subjectSectionTranscriptBackside) THEN (CASE WHEN (@submittedStatus <> transcriptbacksideSubmittedStatus) THEN GETDATE() ELSE transcriptbacksideSubmittedDate END) ELSE transcriptbacksideSubmittedDate END),
						transcriptbacksideApprovalStatus	= (CASE WHEN (@section = @subjectSectionTranscriptBackside) THEN (CASE WHEN (@approvalStatus IS NOT NULL AND LEN(@approvalStatus) > 0 AND CHARINDEX(@approvalStatus, @strBlank) = 0) THEN @approvalStatus ELSE NULL END) ELSE transcriptbacksideApprovalStatus END),
						transcriptbacksideApprovalDate		= (CASE WHEN (@section = @subjectSectionTranscriptBackside) THEN GETDATE() ELSE transcriptbacksideApprovalDate END),
						transcriptbacksideApprovalBy		= (CASE WHEN (@section = @subjectSectionTranscriptBackside) THEN (CASE WHEN (@approvalBy IS NOT NULL AND LEN(@approvalBy) > 0 AND CHARINDEX(@approvalBy, @strBlank) = 0) THEN @approvalBy ELSE NULL END) ELSE transcriptbacksideApprovalBy END),
						transcriptbacksideApprovalIP		= (CASE WHEN (@section = @subjectSectionTranscriptBackside) THEN (CASE WHEN (@approvalIP IS NOT NULL AND LEN(@approvalIP) > 0 AND CHARINDEX(@approvalIP, @strBlank) = 0) THEN @approvalIP ELSE NULL END) ELSE transcriptbacksideApprovalIP END),
						transcriptbacksideMessage			= (CASE WHEN (@section = @subjectSectionTranscriptBackside) THEN (CASE WHEN (@message IS NOT NULL AND LEN(@message) > 0 AND CHARINDEX(@message, @strBlank) = 0) THEN @message ELSE NULL END) ELSE transcriptbacksideMessage END),
						transcriptAuditSentDate				= (CASE WHEN (@section = @subjectSectionTranscript AND @sectionAction = @sectionActionSend) THEN (CASE WHEN (@auditSentDate IS NOT NULL AND LEN(@auditSentDate) > 0 AND CHARINDEX(@auditSentDate, @strBlank) = 0) THEN CONVERT(DATETIME, @auditSentDate, 103) ELSE NULL END) ELSE transcriptAuditSentDate END),
						transcriptAuditSentBy				= (CASE WHEN (@section = @subjectSectionTranscript AND @sectionAction = @sectionActionSend) THEN (CASE WHEN (@auditSentBy IS NOT NULL AND LEN(@auditSentBy) > 0 AND CHARINDEX(@auditSentBy, @strBlank) = 0) THEN @auditSentBy ELSE NULL END) ELSE transcriptAuditSentBy END),
						transcriptAuditSentIP				= (CASE WHEN (@section = @subjectSectionTranscript AND @sectionAction = @sectionActionSend) THEN (CASE WHEN (@auditSentIP IS NOT NULL AND LEN(@auditSentIP) > 0 AND CHARINDEX(@auditSentIP, @strBlank) = 0) THEN @auditSentIP ELSE NULL END) ELSE transcriptAuditSentIP END),
						transcriptResultAudit				= (CASE WHEN (@section = @subjectSectionTranscript AND @sectionAction = @sectionActionReceive) THEN (CASE WHEN (@resultAudit IS NOT NULL AND LEN(@resultAudit) > 0 AND CHARINDEX(@resultAudit, @strBlank) = 0) THEN @resultAudit ELSE NULL END) ELSE transcriptResultAudit END),
						transcriptResultAuditReceivedDate	= (CASE WHEN (@section = @subjectSectionTranscript AND @sectionAction = @sectionActionReceive) THEN (CASE WHEN (@resultAuditReceivedDate IS NOT NULL AND LEN(@resultAuditReceivedDate) > 0 AND CHARINDEX(@resultAuditReceivedDate, @strBlank) = 0) THEN CONVERT(DATETIME, @resultAuditReceivedDate, 103) ELSE NULL END) ELSE transcriptResultAuditReceivedDate END),
						transcriptResultAuditReceivedBy		= (CASE WHEN (@section = @subjectSectionTranscript AND @sectionAction = @sectionActionReceive) THEN (CASE WHEN (@resultAuditReceivedBy IS NOT NULL AND LEN(@resultAuditReceivedBy) > 0 AND CHARINDEX(@resultAuditReceivedBy, @strBlank) = 0) THEN @resultAuditReceivedBy ELSE NULL END) ELSE transcriptResultAuditReceivedBy END),
						transcriptResultAuditReceivedIP		= (CASE WHEN (@section = @subjectSectionTranscript AND @sectionAction = @sectionActionReceive) THEN (CASE WHEN (@resultAuditReceivedIP IS NOT NULL AND LEN(@resultAuditReceivedIP) > 0 AND CHARINDEX(@resultAuditReceivedIP, @strBlank) = 0) THEN @resultAuditReceivedIP ELSE NULL END) ELSE transcriptResultAuditReceivedIP END)						
					WHERE perPersonId = @personId
					
					SET @rowCount = @rowCount + 1							
				END																			
			COMMIT TRAN									
		END TRY
		BEGIN CATCH		
			ROLLBACK TRAN
			INSERT INTO InfinityLog..udsErrorLog
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
	
	DECLARE @profilepictureApprovalStatus VARCHAR(1)
	DECLARE @profilepictureApprovalDate DATETIME
	DECLARE @profilepictureExportDate DATETIME
	DECLARE @identitycardApprovalStatus VARCHAR(1)
	DECLARE @identitycardApprovalDate DATETIME
	DECLARE @transcriptfrontsideApprovalStatus VARCHAR(1)
	DECLARE @transcriptfrontsideApprovalDate DATETIME
	DECLARE @transcriptbacksideApprovalStatus VARCHAR(1)
	DECLARE @transcriptbacksideApprovalDate DATETIME
	
	SELECT	@profilepictureApprovalStatus = profilepictureApprovalStatus,
			@profilepictureApprovalDate = profilepictureApprovalDate,
			@profilepictureExportDate = profilepictureExportDate,
			@identitycardApprovalStatus = identitycardApprovalStatus,
			@identitycardApprovalDate = identitycardApprovalDate,
			@transcriptfrontsideApprovalStatus = transcriptfrontsideApprovalStatus,
			@transcriptfrontsideApprovalDate = transcriptfrontsideApprovalDate,
			@transcriptbacksideApprovalStatus = transcriptbacksideApprovalStatus,
			@transcriptbacksideApprovalDate = transcriptbacksideApprovalDate
	FROM	Infinity..udsUploadLog
	WHERE	perPersonId = @personId

	SELECT	@rowCount,
			@action,
			(CASE WHEN (@profilepictureApprovalStatus = 'Y' OR @profilepictureApprovalStatus = 'N') THEN @profilepictureApprovalDate ELSE NULL END),			
			(CASE WHEN (@identitycardApprovalStatus = 'Y' OR @identitycardApprovalStatus = 'N') THEN @identitycardApprovalDate ELSE NULL END),
			(CASE WHEN (@transcriptfrontsideApprovalStatus = 'Y' OR @transcriptfrontsideApprovalStatus = 'N') THEN @transcriptfrontsideApprovalDate ELSE NULL END),
			(CASE WHEN (@transcriptbacksideApprovalStatus = 'Y' OR @transcriptbacksideApprovalStatus = 'N') THEN @transcriptbacksideApprovalDate ELSE NULL END)	,
			@profilepictureExportDate
END
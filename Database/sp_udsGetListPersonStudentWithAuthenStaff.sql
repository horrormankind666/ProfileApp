USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_udsGetListPersonStudentWithAuthenStaff]    Script Date: 6/8/2564 13:54:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๒๖/๐๖/๒๕๕๘>
-- Description	: <สำหรับเรียกดูข้อมูลของนักศึกษาตามสิทธิ์ผู้ใช้งาน>
-- Parameter
--	1. username				เป็น varchar	รับค่าชื่อผู้ใช้งาน
--	2. userlevel			เป็น varchar	รับค่าระดับผู้ใช้งาน
--	3. systemGroup			เป็น varchar	รับค่าชื่อระบบงาน
--	4. sectionAction		เป็น varchar	รับค่าการกระทำที่เกิดขึ้นกับหัวข้อที่อัพโหลด
--	5. reportName			เป็น varchar	รับค่าชื่อรายงาน
--	6. keyword				เป็น varchar	รับค่าคำค้น
--	7. degreeLevel			เป็น varchar	รับค่าระดับปริญญา
--  8. faculty				เป็น varchar	รับค่ารหัสคณะ
--  9. program				เป็น varchar	รับค่าหลักสูตร
-- 10. yearEntry			เป็น varchar	รับค่าปีที่เข้าศึกษา
-- 11. entranceType			เป็น varchar	รับค่าระบบการสอบเข้า
-- 12. studentStatus		เป็น varchar	รับค่าสถานภาพการเป็นนักศึกษา
-- 13. documentUpload		เป็น varchar	รับค่าชื่อเอกสาร
-- 14. submittedStatus		เป็น varchar	รับค่าสถานะการส่ง
-- 15. approvalStatus		เป็น varchar	รับค่าสถานะการอนุมัติ
-- 16. instituteCountry		เป็น varchar	รับค่ารหัสประเทศของโรงเรียน / สถาบัน
-- 17. instituteProvince	เป็น varchar	รับค่ารหัสจังหวัดของโรงเรียน / สถาบัน
-- 18. institute			เป็น varchar	รับค่ารหัสโรงเรียน / สถาบัน
-- 19. sentDateStartAudit	เป็น varchar	รับค่าวันที่เริ่มต้นส่งระเบียนแสดงผลการเรียนตรวจสอบ
-- 20. sentDateEndAudit		เป็น varchar	รับค่าวันที่สิ้นสุดส่งระเบีบนแสดงผลการเรียนตรวจสอบ
-- 21. auditedstatus		เป็น varchar	รับค่าผลการตรวจสอบระเบียนแสดงผลการเรียน
-- 22. exportstatus			เป็น varchar	รับค่าสถานะการส่งออก
-- 23. sortOrderBy			เป็น varchar	รับค่าคอลัมภ์ที่ต้องการเรียงลำดับ
-- 24. sortExpression		เป็น varchar	รับค่าวิธีการเรียงลำดับ
-- =============================================
ALTER procedure [dbo].[sp_udsGetListPersonStudentWithAuthenStaff]
(
	@username varchar(255) = null,
	@userlevel varchar(20) = null,
	@systemGroup varchar(50) = null,	
	@sectionAction varchar(20) = null,
	@reportName varchar(100) = null,
	@keyword varchar(3000) = null,
	@degreeLevel varchar(2) = null,
	@faculty varchar(15) = null,
	@program varchar(15) = null,
	@yearEntry varchar(4) = null,
	@entranceType varchar(20) = null,
	@studentStatus varchar(3) = null,
	@documentUpload varchar(255) = null,
	@submittedStatus varchar(1) = null,
	@approvalStatus varchar(1) = null,
	@instituteCountry varchar(3) = null,
	@instituteProvince varchar(3) = null,
	@institute varchar(10) = null,
	@sentDateStartAudit	varchar(10) = null,
	@sentDateEndAudit varchar(10) = null,
	@auditedStatus varchar(1) = null,	
	@exportStatus varchar(1) = null,	
	@sortOrderBy varchar(255) = null,
	@sortExpression varchar(25) = null
)
as
begin
	set concat_null_yields_null on
	
	set @username = ltrim(rtrim(isnull(@username, '')))
	set @userlevel = ltrim(rtrim(isnull(@userlevel, '')))
	set @systemGroup = ltrim(rtrim(isnull(@systemGroup, '')))
	set @sectionAction = ltrim(rtrim(isnull(@sectionAction, '')))
	set @reportName = ltrim(rtrim(isnull(@reportName, '')))
	set @keyword = ltrim(rtrim(isnull(@keyword, '')))
	set @degreeLevel = ltrim(rtrim(isnull(@degreeLevel, '')))
	set @faculty = ltrim(rtrim(isnull(@faculty, '')))
	set @program = ltrim(rtrim(isnull(@program, '')))	
	set @yearEntry = ltrim(rtrim(isnull(@yearEntry, '')))
	set @entranceType = ltrim(rtrim(isnull(@entranceType, '')))
	set @studentStatus = ltrim(rtrim(isnull(@studentStatus, '')))
	set @documentUpload = ltrim(rtrim(isnull(@documentUpload, '')))
	set @submittedStatus = ltrim(rtrim(isnull(@submittedStatus, '')))
	set @approvalStatus = ltrim(rtrim(isnull(@approvalStatus, '')))
	set @instituteCountry = ltrim(rtrim(isnull(@instituteCountry, '')))
	set @instituteProvince = ltrim(rtrim(isnull(@instituteProvince, '')))
	set @institute = ltrim(rtrim(isnull(@institute, '')))
	set @sentDateStartAudit = ltrim(rtrim(isnull(@sentDateStartAudit, '')))
	set @sentDateEndAudit = ltrim(rtrim(isnull(@sentDateEndAudit, '')))
	set @auditedStatus = ltrim(rtrim(isnull(@auditedStatus, '')))
	set @sortOrderBy = ltrim(rtrim(isnull(@sortOrderBy, '')))
	set @sortExpression = ltrim(rtrim(isnull(@sortExpression, '')))		
	
	declare	@userFaculty varchar(15) = null
	declare @userProgram varchar(255) = null
	declare @sort varchar(255) = ''	
	declare @keywordIn varchar(10) = ''
    declare @sectionActionSubmit varchar(20) = 'submit'
    declare @sectionActionApprove varchar(20) = 'approve'
	declare @sectionActionSubmitApprove varchar(20) = 'submitapprove'
	declare @documentP varchar(50) = 'ProfilePicture'
	declare @documentIC varchar(50) = 'IDCard'
	declare @documentI varchar(50) = 'IdentityCard'
	declare @documentT varchar(50) = 'Transcript'
	declare @documentTF varchar(50) = 'TranscriptFrontside'
	declare @documentTB varchar(50) = 'TranscriptBackside'
	declare @xml xml

	set @sortOrderBy = dbo.fnc_utilStringCompare(isnull(@sortOrderBy, ''), '', @sortOrderBy, 'Student ID')
	set @sortExpression = dbo.fnc_utilStringCompare(isnull(@sortExpression, ''), '', @sortExpression, 'Ascending')
	set @sort = (@sortOrderBy + ' ' + @sortExpression)

	if (len(isnull(@keyword, '')) > 0)
	begin
		if (substring(@keyword, 1, 2) = 'IN')
		begin
			set @keywordIn = 'IN'
			set @keyword = replace(@keyword, (@keywordIn + ' '), '')
			set @xml = cast(('<A>' + replace(@keyword, '|', '</A><A>') + '</A>') as xml)

			set @keyword = null
		end
	end

	select	A.value('.', 'varchar(1000)') as keyword
	into	#keywordTemp
	from	@xml.nodes('A') as fn(A)
	/*
	select	@userFaculty = autusr.facultyId,
			@userProgram = autusr.programId
	from	autUserAccessProgram as autusr with (nolock)
	where	(autusr.username = @username) and
			(autusr.level = @userlevel) and
			(autusr.systemGroup = @systemGroup)
	*/
	select	@userFaculty = a.facultyId,
			@userProgram = b.programId
	from	(
				select	top 1 autusr.facultyId
				from	autUserAccessProgram as autusr with (nolock)
				where	(autusr.username = @username) and
						(autusr.level = @userlevel) and
						(autusr.systemGroup = @systemGroup)
			) as a
			cross apply
			(
				select	(autusr.programId + ',')
				from	autUserAccessProgram as autusr with (nolock)
				where	(autusr.username = @username) and
						(autusr.level = @userlevel) and
						(autusr.systemGroup = @systemGroup)
				for xml path('')
			) as b (programId)

	set @userFaculty = isnull(@userFaculty, '')
	set @userProgram = isnull(@userProgram, '')	

	select	stdstd.personId as perPersonId,
			stdstd.yearEntry
	into	#udsTemp1
	from	stdStudent as stdstd with (nolock) inner join 
			perPerson as perpes with (nolock) on stdstd.personId = perpes.id left join
			#keywordTemp as keytmp with (nolock) on stdstd.studentCode = keytmp.keyword
	where	(@userFaculty = 'MU-01' or stdstd.facultyId = @userFaculty) and
			--(len(isnull(@userProgram, '')) = 0 or stdstd.programId = @userProgram) and
			(len(isnull(@userProgram, '')) = 0 or (charindex(stdstd.programId, @userProgram) > 0)) and
			(@keywordIn <> 'IN' or keytmp.keyword is not null) and
			(len(isnull(@keyword, '')) = 0 or 
				charindex(@keyword, (
					isnull(stdstd.studentCode, '') +
					isnull(perpes.firstName, '') +
					isnull(perpes.middleName, '') +
					isnull(perpes.lastName, '') +
					isnull(perpes.enFirstName, '') +
					isnull(perpes.enMiddleName, '') +
					isnull(perpes.enLastName, '')
				)) > 0
			)

	select	udstmp.perPersonId,
			@documentUpload as documentUpload,
			(
				case @documentUpload
					when (@documentP + @documentIC) then
				 		case @sectionAction
							when @sectionActionSubmit			then (isnull(profilepictureSubmittedStatus, 'N') + isnull(identitycardSubmittedStatus, 'N'))
							when @sectionActionApprove			then (isnull(profilepictureApprovalStatus, 'S') + isnull(identitycardApprovalStatus, 'S'))
							when @sectionActionSubmitApprove	then (isnull(profilepictureApprovalStatus, 'S') + isnull(identitycardApprovalStatus, 'S'))
						end
					when @documentP then
						case @sectionAction 
							when @sectionActionSubmit			then isnull(profilepictureSubmittedStatus, 'N')
							when @sectionActionApprove			then isnull(profilepictureApprovalStatus, 'S')
							when @sectionActionSubmitApprove	then isnull(profilepictureApprovalStatus, 'S')
						end
					when @documentI then
						case @sectionAction
							when @sectionActionSubmit			then isnull(identitycardSubmittedStatus, 'N')
							when @sectionActionApprove			then isnull(identitycardApprovalStatus, 'S')
							when @sectionActionSubmitApprove	then isnull(identitycardApprovalStatus, 'S')
						end
					when @documentT then
						case @sectionAction
							when @sectionActionSubmit			then (isnull(transcriptfrontsideSubmittedStatus, 'N') + isnull(transcriptbacksideSubmittedStatus, 'N'))
							when @sectionActionApprove			then (isnull(transcriptfrontsideApprovalStatus, 'S') + isnull(transcriptbacksideApprovalStatus, 'S'))
							when @sectionActionSubmitApprove	then (isnull(transcriptfrontsideApprovalStatus, 'S') + isnull(transcriptbacksideApprovalStatus, 'S'))
						end
					when @documentTF then
						case @sectionAction
							when @sectionActionSubmit			then isnull(transcriptfrontsideSubmittedStatus, 'N')
							when @sectionActionApprove			then isnull(transcriptfrontsideApprovalStatus, 'S')
							when @sectionActionSubmitApprove	then isnull(transcriptfrontsideApprovalStatus, 'S')
						end
					when @documentTB then
						case @sectionAction
							when @sectionActionSubmit			then isnull(transcriptbacksideSubmittedStatus, 'N')
							when @sectionActionApprove			then isnull(transcriptbacksideApprovalStatus, 'S')
							when @sectionActionSubmitApprove	then isnull(transcriptbacksideApprovalStatus, 'S')
						end
					when (@documentP + @documentI) THEN
						case @sectionAction
							when @sectionActionApprove			then (case when (yearEntry >= 2557) then (isnull(profilepictureApprovalStatus, 'S') + isnull(identitycardApprovalStatus, 'S')) else profilepictureApprovalStatus end)
						end
					when (@documentTF + @documentTB) then
						case @sectionAction
							when @sectionActionApprove			then (isnull(transcriptfrontsideApprovalStatus, 'S') + isnull(transcriptbacksideApprovalStatus, 'S'))
							when @sectionActionSubmitApprove	then (isnull(transcriptfrontsideApprovalStatus, 'S') + isnull(transcriptbacksideApprovalStatus, 'S'))
						end
					else
						(isnull(profilepictureApprovalStatus, 'S') + isnull(identitycardApprovalStatus, 'S') + isnull(transcriptfrontsideApprovalStatus, 'S') + isnull(transcriptbacksideApprovalStatus, 'S'))
				 end) as documentSubmitApproveStatus
	into	#udsTemp2
	from	#udsTemp1 as udstmp with (nolock) left join
			udsUploadLog as udsupl with (nolock) on udstmp.perPersonId = udsupl.perPersonId

	select 	perstd.id,
			udsupl.perPersonId,
			perstd.studentId,
			perstd.studentCode,
			perstd.idCard,
			perstd.perTitlePrefixId,
			perstd.titlePrefixFullNameTH,
			perstd.titlePrefixInitialsTH, 
			perstd.titlePrefixFullNameEN,
			perstd.titlePrefixInitialsEN,
			perstd.firstName,
			perstd.middleName,
			perstd.lastName,
			perstd.firstNameEN, 
			perstd.middleNameEN,
			perstd.lastNameEN,
			perstd.degree,
			perstd.facultyId,
			perstd.facultyCode,
			perstd.programId,
			perstd.programCode,
			perstd.majorCode,
			perstd.groupNum, 
			perstd.yearEntry,
			perstd.perEntranceTypeId,
			perstd.status,
			perstd.statusGroup,
			@documentUpload as documentUpload,
			(
				case @documentUpload
					when (@documentP + @documentIC)	then 'PI'
					when @documentP					then 'P'
					when @documentI					then 'I'
					when @documentT					then 'T'
					when @documentTF				then 'TF'
					when @documentTB				then 'TB'
				END
			) as documentUploadInitials,
			udsupl.profilepictureFileName,
			dbo.fnc_utilStringCompare(isnull(udsupl.profilepictureSavedStatus, ''), '', udsupl.profilepictureSavedStatus, 'N') as profilepictureSavedStatus,
			dbo.fnc_utilStringCompare(isnull(udsupl.profilepictureSavedStatus, ''), '', udsupl.profilepictureSavedDate, null) as profilepictureSavedDate,
			dbo.fnc_utilStringCompare(isnull(udsupl.profilepictureSubmittedStatus, ''), '', udsupl.profilepictureSubmittedStatus, 'N') as profilepictureSubmittedStatus,
			dbo.fnc_utilStringCompare(isnull(udsupl.profilepictureSubmittedStatus, ''), '', udsupl.profilepictureSubmittedDate, null) as profilepictureSubmittedDate,
			dbo.fnc_utilStringCompare(isnull(udsupl.profilepictureApprovalStatus, ''), '', udsupl.profilepictureApprovalStatus, 'S') as profilepictureApprovalStatus,
			dbo.fnc_utilStringCompare(isnull(udsupl.profilepictureApprovalStatus, ''), '', udsupl.profilepictureApprovalDate, null) as profilepictureApprovalDate,
			udsupl.profilepictureExportDate,
			udsupl.identitycardFileName,
			dbo.fnc_utilStringCompare(isnull(udsupl.identitycardSavedStatus, ''), '', udsupl.identitycardSavedStatus, 'N') as identitycardSavedStatus,
			dbo.fnc_utilStringCompare(isnull(udsupl.identitycardSavedStatus, ''), '', udsupl.identitycardSavedDate, null) as identitycardSavedDate,
			dbo.fnc_utilStringCompare(isnull(udsupl.identitycardSubmittedStatus, ''), '', udsupl.identitycardSubmittedStatus, 'N') as identitycardSubmittedStatus,
			dbo.fnc_utilStringCompare(isnull(udsupl.identitycardSubmittedStatus, ''), '', udsupl.identitycardSubmittedDate, null) as identitycardSubmittedDate,
			dbo.fnc_utilStringCompare(isnull(udsupl.identitycardApprovalStatus, ''), '', udsupl.identitycardApprovalStatus, 'S') as identitycardApprovalStatus,
			dbo.fnc_utilStringCompare(isnull(udsupl.identitycardApprovalStatus, ''), '', udsupl.identitycardApprovalDate, null) as identitycardApprovalDate,
			udsupl.perInstituteIdTranscript as instituteIdTranscript, 
			perins.institutelNameTH as institutelNameTHTranscript,
			perins.institutelNameEN as institutelNameENTranscript, 
			plcpvn.plcCountryId as instituteCountryIdTranscript,
			plccon.isoCountryCodes3Letter as instituteCountryCodes3LetterTranscript,
			plccon.countryNameTH as instituteCountryNameTHTranscript, 
			plccon.countryNameEN as instituteCountryNameENTranscript,
			perins.plcProvinceId as instituteProvinceIdTranscript,
			plcpvn.provinceNameTH as instituteProvinceNameTHTranscript, 
			plcpvn.provinceNameEN as instituteProvinceNameENTranscript,
			udsupl.transcriptfrontsideFileName,
			dbo.fnc_utilStringCompare(isnull(udsupl.transcriptfrontsideSavedStatus, ''), '', udsupl.transcriptfrontsideSavedStatus, 'N') as transcriptfrontsideSavedStatus,
			dbo.fnc_utilStringCompare(isnull(udsupl.transcriptfrontsideSavedStatus, ''), '', udsupl.transcriptfrontsideSavedDate, null) as transcriptfrontsideSavedDate,
			dbo.fnc_utilStringCompare(isnull(udsupl.transcriptfrontsideSubmittedStatus, ''), '', udsupl.transcriptfrontsideSubmittedStatus, 'N') as transcriptfrontsideSubmittedStatus,
			dbo.fnc_utilStringCompare(isnull(udsupl.transcriptfrontsideSubmittedStatus, ''), '', udsupl.transcriptfrontsideSubmittedDate, null) as transcriptfrontsideSubmittedDate,
			dbo.fnc_utilStringCompare(isnull(udsupl.transcriptfrontsideApprovalStatus, ''), '', udsupl.transcriptfrontsideApprovalStatus, 'S') as transcriptfrontsideApprovalStatus,
			dbo.fnc_utilStringCompare(isnull(udsupl.transcriptfrontsideApprovalStatus, ''), '', udsupl.transcriptfrontsideApprovalDate, null) as transcriptfrontsideApprovalDate,
			udsupl.transcriptbacksideFileName, 
			dbo.fnc_utilStringCompare(isnull(udsupl.transcriptbacksideSavedStatus, ''), '', udsupl.transcriptbacksideSavedStatus, 'N') as transcriptbacksideSavedStatus,
			dbo.fnc_utilStringCompare(isnull(udsupl.transcriptbacksideSavedStatus, ''), '', udsupl.transcriptbacksideSavedDate, null) as transcriptbacksideSavedDate,
			dbo.fnc_utilStringCompare(isnull(udsupl.transcriptbacksideSubmittedStatus, ''), '', udsupl.transcriptbacksideSubmittedStatus, 'N') as transcriptbacksideSubmittedStatus,
			dbo.fnc_utilStringCompare(isnull(udsupl.transcriptbacksideSubmittedStatus, ''), '', udsupl.transcriptbacksideSubmittedDate, null) as transcriptbacksideSubmittedDate,
			dbo.fnc_utilStringCompare(isnull(udsupl.transcriptbacksideApprovalStatus, ''), '', udsupl.transcriptbacksideApprovalStatus, 'S') as transcriptbacksideApprovalStatus,
			dbo.fnc_utilStringCompare(isnull(udsupl.transcriptbacksideApprovalStatus, ''), '', udsupl.transcriptbacksideApprovalDate, null) as transcriptbacksideApprovalDate,
			udsupl.transcriptAuditSentDate,
			(case when (udsupl.transcriptAuditSentDate is not null) then 'Y' else 'N' end) as transcriptAuditSentStatus,
			(case when (udsupl.transcriptAuditSentDate is not null and (udsupl.transcriptResultAudit in ('Y', 'N')) and udsupl.transcriptResultAuditReceivedDate is not null) then udsupl.transcriptResultAudit else null end) as transcriptResultAudit, 
			(case when (udsupl.transcriptAuditSentDate is not null and (udsupl.transcriptResultAudit in ('Y', 'N')) and udsupl.transcriptResultAuditReceivedDate is not null) then 'Y' else 'N' end) as transcriptResultAuditReceivedStatus, 
			(case when (udsupl.transcriptAuditSentDate is not null and (udsupl.transcriptResultAudit in ('Y', 'N')) and udsupl.transcriptResultAuditReceivedDate is not null) then udsupl.transcriptResultAuditReceivedDate else null end) as transcriptResultAuditReceivedDate
	into	#udsTemp3
	from	#udsTemp2 as udstmp with (nolock) inner join
			fnc_perGetListPersonStudent() as perstd on udstmp.perPersonId = perstd.id left join
			udsUploadLog as udsupl with (nolock) on perstd.id = udsupl.perPersonId left join
			perInstitute as perins with (nolock) on udsupl.perInstituteIdTranscript = perins.id left join
			plcProvince as plcpvn with (nolock) on perins.plcProvinceId = plcpvn.id left join
			plcCountry as plccon with (nolock) on plcpvn.plcCountryId = plccon.id
	where	(len(isnull(@degreeLevel, '')) = 0 or perstd.degree = @degreeLevel) and
			(len(isnull(@faculty, '')) = 0 or perstd.facultyId = @faculty) and
			(len(isnull(@program, '')) = 0 or perstd.programId = @program) and
			(len(isnull(@yearEntry, '')) = 0 or perstd.yearEntry = @yearEntry) and
			(len(isnull(@entranceType, '')) = 0 or perstd.perEntranceTypeId = @entranceType) and
			(len(isnull(@studentStatus, '')) = 0 or perstd.status = @studentStatus or perstd.statusGroup = (case when (@studentStatus = '100') then '01' else '' end)) and
			((len(isnull(@documentUpload, '')) = 0 or @sectionAction <> @sectionActionApprove) or udsupl.perPersonId is not null) and
			(len(isnull(@submittedStatus, '')) = 0 or
				charindex((
					case @sectionAction
						when @sectionActionSubmit then isnull(@submittedStatus, '')
					end 							
				), udstmp.documentSubmitApproveStatus) > 0
			) and
			(len(isnull(@approvalStatus, '')) = 0 or
				charindex((
					case @sectionAction
						when @sectionActionApprove then
							case @documentUpload
								when (@documentP + @documentIC)		then isnull(@approvalStatus, '')
								when (@documentP + @documentI)		then (case when (yearEntry >= 2557) then (isnull(@approvalStatus, '') + isnull(@approvalStatus, '')) else isnull(@approvalStatus, '') end)
								when @documentT						then isnull(@approvalStatus, '')
								when (@documentTF + @documentTB)	then (isnull(@approvalStatus, '') + isnull(@approvalStatus, ''))																
							else										
								isnull(@approvalStatus, '')
							end
						when @sectionActionSubmitApprove then isnull(@approvalStatus, '')
					end 							
				), udstmp.documentSubmitApproveStatus) > 0
			) and
			(len(isnull(@instituteCountry, '')) = 0 or plcpvn.plcCountryId = @instituteCountry) and
			(len(isnull(@instituteProvince, '')) = 0 or perins.plcProvinceId = @instituteProvince) and
			(len(isnull(@institute, '')) = 0 or udsupl.perInstituteIdTranscript = @institute) and
			((len(isnull(@sentDateStartAudit, '')) = 0 or len(isnull(@sentDateEndAudit, '')) = 0) or
				transcriptAuditSentDate between convert(varchar, convert(date, @sentDateStartAudit, 103)) and convert(varchar, convert(date, @sentDateEndAudit, 103))
			) and
			(len(isnull(@auditedStatus, '')) = 0 or udsupl.transcriptResultAudit = @auditedStatus) and
			(len(isnull(@exportStatus, '')) = 0 or
				(
					case @documentUpload
						when (@documentP + @documentI) then
							case @sectionAction
								when @sectionActionApprove then (case when (udsupl.profilepictureExportDate is not null) then 'Y' else 'N' end)
							end
						when @documentP then
							case @sectionAction
								when @sectionActionSubmitApprove then (case when (udsupl.profilepictureExportDate is not null) then 'Y' else 'N' end)
							end
					end
				) = @exportStatus
			)
	
	select	row_number() over(order by 
				case when @sort = 'Student ID Ascending'	then (isnull(udstmp.yearEntry, '') + isnull(udstmp.studentCode, '')) end asc,
				case when @sort = 'Student ID Descending'	then (isnull(udstmp.yearEntry, '') + isnull(udstmp.studentCode, '')) end desc
			) as rowNum,
			udstmp.*
	from	#udsTemp3 as udstmp with (nolock)
	
	------------------------------------------------------------------------------------------------------------------------------------------------------
	
	if (@reportName = 'DocumentStatusStudentViewChart')
	begin
		select	'profilepicture' as documentUpload,
				 profilepictureApprovalStatus as approvalStatus,
				 (
					case profilepictureApprovalStatus
						when 'S'	then '1,รอยืนยันการส่ง,Pending Submit,#CCCCCC,PendingSubmitDrillDown'
						when 'W'	then '2,รอผลการอนุมัติ,Pending Approved,#F7DD02,PendingApprovedDrillDown'
						when 'Y'	then '3,ได้รับการอนุมัติ,Approved,#00C600,ApprovedDrillDown'
						when 'N'	then '4,ไม่ได้รับการอนุมัติ,Not Approved,#FE0101,NotApprovedDrillDown'
					end
				 ) as series,
				 count(id) as countPeople
		from	 #udsTemp3
		group by profilepictureApprovalStatus
		order by series
		
		select	 'profilepicture' as documentUpload,
				 profilepictureApprovalStatus as approvalStatus,
				 (
					case profilepictureApprovalStatus
						when 'S'	then ('1,' + isnull(yearEntry, 'N/A') + ',PendingSubmitDrillDownYearEntry' + isnull(yearEntry, 'N/A'))
						when 'W'	then ('2,' + isnull(yearEntry, 'N/A') + ',PendingApprovedDrillDownYearEntry' + isnull(yearEntry, 'N/A'))
						when 'Y'	then ('3,' + isnull(yearEntry, 'N/A') + ',ApprovedDrillDownYearEntry' + isnull(yearEntry, 'N/A'))
						when 'N'	then ('4,' + isnull(yearEntry, 'N/A') + ',NotApprovedDrillDownYearEntry' + isnull(yearEntry, 'N/A'))
					end
				 ) as series,
				 count(id) as countPeople
		from	 #udsTemp3
		group by profilepictureApprovalStatus, yearEntry
		order by series, yearEntry

		select	 'profilepicture' as documentUpload,
				 profilepictureApprovalStatus as approvalStatus,
				 isnull(yearEntry, 'N/A') as yearEntry,
				 (
					case profilepictureApprovalStatus
						when 'S'	then ('1,' + isnull(yearEntry, 'N/A') + ',' + isnull(facultyCode, ''))
						when 'W'	then ('2,' + isnull(yearEntry, 'N/A') + ',' + isnull(facultyCode, ''))
						when 'Y'	then ('3,' + isnull(yearEntry, 'N/A') + ',' + isnull(facultyCode, ''))
						when 'N'	then ('4,' + isnull(yearEntry, 'N/A') + ',' + isnull(facultyCode, ''))
					end
				 ) as series,
				 count(id) as countPeople
		from	 #udsTemp3
		group by profilepictureApprovalStatus, yearEntry, facultyCode
		order by series, yearEntry, facultyCode
		
		select	 'identitycard' as documentUpload,
				 identitycardApprovalStatus as approvalStatus,
				 (
					case identitycardApprovalStatus
						when 'S'	then '1,รอยืนยันการส่ง,Pending Submit,#CCCCCC,PendingSubmitDrillDown'
						when 'W'	then '2,รอผลการอนุมัติ,Pending Approved,#F7DD02,PendingApprovedDrillDown'
						when 'Y'	then '3,ได้รับการอนุมัติ,Approved,#00C600,ApprovedDrillDown'
						when 'N'	then '4,ไม่ได้รับการอนุมัติ,Not Approved,#FE0101,NotApprovedDrillDown'
					end
				 ) as series,
				 count(id) as countPeople
		from	 #udsTemp3
		group by identitycardApprovalStatus
		order by series

		select	 'identitycard' as documentUpload,
				 identitycardApprovalStatus as approvalStatus,
				 (
					case identitycardApprovalStatus
						when 'S'	then ('1,' + isnull(yearEntry, 'N/A') + ',PendingSubmitDrillDownYearEntry' + isnull(yearEntry, 'N/A'))
						when 'W'	then ('2,' + isnull(yearEntry, 'N/A') + ',PendingApprovedDrillDownYearEntry' + isnull(yearEntry, 'N/A'))
						when 'Y'	then ('3,' + isnull(yearEntry, 'N/A') + ',ApprovedDrillDownYearEntry' + isnull(yearEntry, 'N/A'))
						when 'N'	then ('4,' + isnull(yearEntry, 'N/A') + ',NotApprovedDrillDownYearEntry' + isnull(yearEntry, 'N/A'))
					end
				 ) as series,
				 count(id) as countPeople
		from	 #udsTemp3
		group by identitycardApprovalStatus, yearEntry
		order by series, yearEntry

		select	 'identitycard' as documentUpload,
				 identitycardApprovalStatus as approvalStatus,
				 isnull(yearEntry, 'N/A') as yearEntry,
				 (
					case identitycardApprovalStatus
						when 'S'	then ('1,' + isnull(yearEntry, 'N/A') + ',' + isnull(facultyCode, ''))
						when 'W'	then ('2,' + isnull(yearEntry, 'N/A') + ',' + isnull(facultyCode, ''))
						when 'Y'	then ('3,' + isnull(yearEntry, 'N/A') + ',' + isnull(facultyCode, ''))
						when 'N'	then ('4,' + isnull(yearEntry, 'N/A') + ',' + isnull(facultyCode, ''))
					end
				 ) as series,
				 count(id) as countPeople
		from	 #udsTemp3
		group by identitycardApprovalStatus, yearEntry, facultyCode
		order by series, yearEntry, facultyCode

		select	 'transcriptfrontside' as documentUpload,
				 transcriptfrontsideApprovalStatus as approvalStatus,
				 (
					case transcriptfrontsideApprovalStatus
						when 'S'	then '1,รอยืนยันการส่ง,Pending Submit,#CCCCCC,PendingSubmitDrillDown'
						when 'W'	then '2,รอผลการอนุมัติ,Pending Approved,#F7DD02,PendingApprovedDrillDown'
						when 'Y'	then '3,ได้รับการอนุมัติ,Approved,#00C600,ApprovedDrillDown'
						when 'N'	then '4,ไม่ได้รับการอนุมัติ,Not Approved,#FE0101,NotApprovedDrillDown'
					end
				 ) as series,
				 count(id) as countPeople
		from	 #udsTemp3
		group by transcriptfrontsideApprovalStatus
		order by series

		select	 'transcriptfrontside' as documentUpload,
				 transcriptfrontsideApprovalStatus as approvalStatus,
				 (
					case transcriptfrontsideApprovalStatus
						when 'S'	then ('1,' + isnull(yearEntry, 'N/A') + ',PendingSubmitDrillDownYearEntry' + isnull(yearEntry, 'N/A'))
						when 'W'	then ('2,' + isnull(yearEntry, 'N/A') + ',PendingApprovedDrillDownYearEntry' + isnull(yearEntry, 'N/A'))
						when 'Y'	then ('3,' + isnull(yearEntry, 'N/A') + ',ApprovedDrillDownYearEntry' + isnull(yearEntry, 'N/A'))
						when 'N'	then ('4,' + isnull(yearEntry, 'N/A') + ',NotApprovedDrillDownYearEntry' + isnull(yearEntry, 'N/A'))
					end
				 ) as series,
				 count(id) as countPeople
		from	 #udsTemp3
		group by transcriptfrontsideApprovalStatus, yearEntry
		order by series, yearEntry

		select	 'transcriptfrontside' as documentUpload,
				 transcriptfrontsideApprovalStatus as approvalStatus,
				 isnull(yearEntry, 'N/A') as yearEntry,
				 (
					case transcriptfrontsideApprovalStatus
						when 'S'	then ('1,' + isnull(yearEntry, 'N/A') + ',' + isnull(facultyCode, ''))
						when 'W'	then ('2,' + isnull(yearEntry, 'N/A') + ',' + isnull(facultyCode, ''))
						when 'Y'	then ('3,' + isnull(yearEntry, 'N/A') + ',' + isnull(facultyCode, ''))
						when 'N'	then ('4,' + isnull(yearEntry, 'N/A') + ',' + isnull(facultyCode, ''))
					end
				 ) as series,
				 count(id) as countPeople
		from	 #udsTemp3
		group by transcriptfrontsideApprovalStatus, yearEntry, facultyCode
		order by series, yearEntry, facultyCode

		select	 'transcriptbackside' as documentUpload,
				 transcriptbacksideApprovalStatus as approvalStatus,
				 (
					case transcriptbacksideApprovalStatus
						when 'S'	then '1,รอยืนยันการส่ง,Pending Submit,#CCCCCC,PendingSubmitDrillDown'
						when 'W'	then '2,รอผลการอนุมัติ,Pending Approved,#F7DD02,PendingApprovedDrillDown'
						when 'Y'	then '3,ได้รับการอนุมัติ,Approved,#00C600,ApprovedDrillDown'
						when 'N'	then '4,ไม่ได้รับการอนุมัติ,Not Approved,#FE0101,NotApprovedDrillDown'
					end
				 ) as series,
				 count(id) as countPeople
		from	 #udsTemp3
		group by transcriptbacksideApprovalStatus
		order by series
		
		select	 'transcriptbackside' as documentUpload,
				 transcriptbacksideApprovalStatus as approvalStatus,
				 (
					case transcriptbacksideApprovalStatus
						when 'S'	then ('1,' + isnull(yearEntry, 'N/A') + ',PendingSubmitDrillDownYearEntry' + isnull(yearEntry, 'N/A'))
						when 'W'	then ('2,' + isnull(yearEntry, 'N/A') + ',PendingApprovedDrillDownYearEntry' + isnull(yearEntry, 'N/A'))
						when 'Y'	then ('3,' + isnull(yearEntry, 'N/A') + ',ApprovedDrillDownYearEntry' + isnull(yearEntry, 'N/A'))
						when 'N'	then ('4,' + isnull(yearEntry, 'N/A') + ',NotApprovedDrillDownYearEntry' + isnull(yearEntry, 'N/A'))
					end
				 ) as series,
				 count(id) as countPeople
		from	 #udsTemp3
		group by transcriptbacksideApprovalStatus, yearEntry
		order by series, yearEntry

		select	 'transcriptbackside' as documentUpload,
				 transcriptbacksideApprovalStatus as approvalStatus,
				 isnull(yearEntry, 'N/A') as yearEntry,
				 (
					case transcriptbacksideApprovalStatus
						when 'S'	then ('1,' + isnull(yearEntry, 'N/A') + ',' + isnull(facultyCode, ''))
						when 'W'	then ('2,' + isnull(yearEntry, 'N/A') + ',' + isnull(facultyCode, ''))
						when 'Y'	then ('3,' + isnull(yearEntry, 'N/A') + ',' + isnull(facultyCode, ''))
						when 'N'	then ('4,' + isnull(yearEntry, 'N/A') + ',' + isnull(facultyCode, ''))
					end
				 ) as series,
				 count(id) as countPeople
		from	 #udsTemp3
		group by transcriptbacksideApprovalStatus, yearEntry, facultyCode
		order by series, yearEntry, facultyCode
	end
	
	------------------------------------------------------------------------------------------------------------------------------------------------------

	if (@reportName = 'AuditTranscriptApprovedViewChart' or
		@reportName = 'AuditTranscriptApprovedLevel1ViewTable' or
	 	@reportName = 'AuditTranscriptApprovedLevel21ViewTableNeedSend' or
		@reportName = 'AuditTranscriptApprovedLevel22ViewTableNeedSend' or
		@reportName = 'AuditTranscriptApprovedLevel21ViewTableSend' or
		@reportName = 'AuditTranscriptApprovedLevel22ViewTableSend' or
		@reportName = 'AuditTranscriptApprovedLevel21ViewTableNotSend' or
		@reportName = 'AuditTranscriptApprovedLevel22ViewTableNotSend' or
		@reportName = 'AuditTranscriptApprovedLevel21ViewTableSendReceive' or
		@reportName = 'AuditTranscriptApprovedLevel22ViewTableSendReceive' or
		@reportName = 'AuditTranscriptApprovedLevel21ViewTableSendNotReceive' or
		@reportName = 'AuditTranscriptApprovedLevel22ViewTableSendNotReceive')
	begin
		select	 yearEntry,
				 instituteCountryIdTranscript,
				 instituteCountryCodes3LetterTranscript,
				 instituteProvinceIdTranscript,
				 instituteProvinceNameTHTranscript,
				 instituteProvinceNameENTranscript,
				 isnull(instituteIdTranscript, 'N/A') as instituteIdTranscript,
				 institutelNameTHTranscript,
				 institutelNameENTranscript,
				 count(id) as countPeople
		into	 #udsTemp4
		from	 #udsTemp3
		group by yearEntry,
				 instituteCountryIdTranscript,
				 instituteCountryCodes3LetterTranscript,
				 instituteProvinceIdTranscript,
				 instituteProvinceNameTHTranscript,
				 instituteProvinceNameENTranscript,
				 instituteIdTranscript,
				 institutelNameTHTranscript,
				 institutelNameENTranscript
		
		select	 yearEntry,
				 instituteCountryIdTranscript,
				 instituteCountryCodes3LetterTranscript,
				 instituteProvinceIdTranscript,
				 instituteProvinceNameTHTranscript,
				 instituteProvinceNameENTranscript,
				 isnull(instituteIdTranscript, 'N/A') as instituteIdTranscript,
				 institutelNameTHTranscript,
				 institutelNameENTranscript,
				 count(id) as countPeople
		into	 #udsTemp5 
		from	 #udsTemp3
		where	 transcriptAuditSentStatus = 'Y'
		group by yearEntry,
				 instituteCountryIdTranscript,
				 instituteCountryCodes3LetterTranscript,
				 instituteProvinceIdTranscript,
				 instituteProvinceNameTHTranscript,
				 instituteProvinceNameENTranscript,
				 instituteIdTranscript,
				 institutelNameTHTranscript,
				 institutelNameENTranscript

		select	 yearEntry,
				 instituteCountryIdTranscript,
				 instituteCountryCodes3LetterTranscript,
				 instituteProvinceIdTranscript,
				 instituteProvinceNameTHTranscript,
				 instituteProvinceNameENTranscript,
				 isnull(instituteIdTranscript, 'N/A') as instituteIdTranscript,
				 institutelNameTHTranscript,
				 institutelNameENTranscript,
				 count(id) as countPeople
		into	 #udsTemp6
		from	 #udsTemp3
		where	 transcriptAuditSentStatus = 'N'
		group by yearEntry,
				 instituteCountryIdTranscript,
				 instituteCountryCodes3LetterTranscript,
				 instituteProvinceIdTranscript,
				 instituteProvinceNameTHTranscript,
				 instituteProvinceNameENTranscript,
				 instituteIdTranscript,
				 institutelNameTHTranscript,
				 institutelNameENTranscript

		select	 yearEntry,
				 instituteCountryIdTranscript,
				 instituteCountryCodes3LetterTranscript,
				 instituteProvinceIdTranscript,
				 instituteProvinceNameTHTranscript,
				 instituteProvinceNameENTranscript,
				 isnull(instituteIdTranscript, 'N/A') as instituteIdTranscript,
				 institutelNameTHTranscript,
				 institutelNameENTranscript,
				 count(id) as countPeople
		into	 #udsTemp7
		from	 #udsTemp3
		where	 (transcriptAuditSentStatus = 'Y') and 
				 (transcriptResultAuditReceivedStatus = 'Y')
		group by yearEntry,
				 instituteCountryIdTranscript,
				 instituteCountryCodes3LetterTranscript,
				 instituteProvinceIdTranscript,
				 instituteProvinceNameTHTranscript,
				 instituteProvinceNameENTranscript,
				 instituteIdTranscript,
				 institutelNameTHTranscript,
				 institutelNameENTranscript

		select	 yearEntry,
				 instituteCountryIdTranscript,
				 instituteCountryCodes3LetterTranscript,
				 instituteProvinceIdTranscript,
				 instituteProvinceNameTHTranscript,
				 instituteProvinceNameENTranscript,
				 isnull(instituteIdTranscript, 'N/A') as instituteIdTranscript,
				 institutelNameTHTranscript,
				 institutelNameENTranscript,
				 count(id) as countPeople
		into	 #udsTemp8
		from	 #udsTemp3
		where	 (transcriptAuditSentStatus = 'Y') and
				 (transcriptResultAuditReceivedStatus = 'N')
		group by yearEntry,
				 instituteCountryIdTranscript,
				 instituteCountryCodes3LetterTranscript,
				 instituteProvinceIdTranscript,
				 instituteProvinceNameTHTranscript,
				 instituteProvinceNameENTranscript,
				 instituteIdTranscript,
				 institutelNameTHTranscript,
				 institutelNameENTranscript

		select	 a.yearEntry as yearEntry1,
				 a.instituteCountryCodes3LetterTranscript as instituteCountryCodes3LetterTranscript1,
				 isnull(a.instituteProvinceNameTHTranscript, a.instituteProvinceNameENTranscript) as instituteProvinceNameTranscript1,
				 a.instituteIdTranscript as instituteIdTranscript1,
				 isnull(a.institutelNameTHTranscript, a.institutelNameENTranscript) as instituteNameTranscript1,
				 a.countPeople as countPeople1,

				 b.yearEntry as yearEntry2,
				 b.instituteCountryCodes3LetterTranscript as instituteCountryCodes3LetterTranscript2,
				 isnull(b.instituteProvinceNameTHTranscript, b.instituteProvinceNameENTranscript) as instituteProvinceNameTranscript2,
				 b.instituteIdTranscript as instituteIdTranscript2,
				 isnull(b.institutelNameTHTranscript, b.institutelNameENTranscript) as instituteNameTranscript2,
				 b.countPeople as countPeople2,

				 c.yearEntry as yearEntry3,
				 c.instituteCountryCodes3LetterTranscript as instituteCountryCodes3LetterTranscript3,
				 isnull(c.instituteProvinceNameTHTranscript, c.instituteProvinceNameENTranscript) as instituteProvinceNameTranscript3,
				 c.instituteIdTranscript as instituteIdTranscript3,
				 isnull(c.institutelNameTHTranscript, c.institutelNameENTranscript) as instituteNameTranscript3,
				 c.countPeople as countPeople3,

				 d.yearEntry as yearEntry4,
				 d.instituteCountryCodes3LetterTranscript as instituteCountryCodes3LetterTranscript4,
				 isnull(d.instituteProvinceNameTHTranscript, d.instituteProvinceNameENTranscript) as instituteProvinceNameTranscript4,
				 d.instituteIdTranscript as instituteIdTranscript4,
				 isnull(d.institutelNameTHTranscript, d.institutelNameENTranscript) as instituteNameTranscript4,
				 d.countPeople as countPeople4,

				 e.yearEntry as yearEntry5, 
				 e.instituteCountryCodes3LetterTranscript as instituteCountryCodes3LetterTranscript5,
				 isnull(e.instituteProvinceNameTHTranscript, e.instituteProvinceNameENTranscript) as instituteProvinceNameTranscript5,
				 e.instituteIdTranscript as instituteIdTranscript5,
				 isnull(e.institutelNameTHTranscript, e.institutelNameENTranscript) as instituteNameTranscript5,
				 e.countPeople as countPeople5
		into	 #udsTemp9
		FROM	 #udsTemp4 as a left join
				 #udsTemp5 as b on (a.yearEntry = b.yearEntry and a.instituteIdTranscript = b.instituteIdTranscript) left join
				 #udsTemp6 as c on (a.yearEntry = c.yearEntry and a.instituteIdTranscript = c.instituteIdTranscript) left join
				 #udsTemp7 as d on (b.yearEntry = d.yearEntry and b.instituteIdTranscript = d.instituteIdTranscript) left join
				 #udsTemp8 as e on (b.yearEntry = e.yearEntry and b.instituteIdTranscript = e.instituteIdTranscript)
	end

	------------------------------------------------------------------------------------------------------------------------------------------------------

	if (@reportName = 'AuditTranscriptApprovedViewChart')
	begin
		select	 'จำนวนโรงเรียนและจำนวนนักศึกษาทั้งหมดที่ต้องส่งไปตรวจสอบคุณวุฒิ' as title,
				 'จำนวน,Number of,จำนวน ( โรงเรียน ),Number of ( school ),#F8A13F,NumberofSchoolDrillDown' as titleSeries1,
				 count(instituteIdTranscript1) as valueSeries1,
				 'จำนวน,Number of,จำนวน ( นักศึกษา ),Number of ( student ),#C0463D,NumberofStudentDrillDown' as titleSeries2,
				 sum(isnull(countPeople1, 0)) as valueSeries2
		from	 #udsTemp9

		select	 isnull(yearEntry1, 'N/A') as yearEntry,
				 count(instituteIdTranscript1) as valueSeries1,
				 sum(isnull(countPeople1, 0)) as valueSeries2
		from	 #udsTemp9
		where	 (yearEntry1 is not null)
		group by yearEntry1
		order by yearEntry1

		select	 'จำนวนโรงเรียนและจำนวนนักศึกษาทั้งหมดที่ส่งไปตรวจสอบคุณวุฒิ' as title,
				 'จำนวน,Number of,จำนวน ( โรงเรียน ),Number of ( school ),#F8A13F,NumberofSchoolDrillDown' as titleSeries1,
				 count(instituteIdTranscript2) as valueSeries1,
				 'จำนวน,Number of,จำนวน ( นักศึกษา ),Number of ( student ),#C0463D,NumberofStudentDrillDown' as titleSeries2,
				 sum(isnull(countPeople2, 0)) as valueSeries2
		from	 #udsTemp9

		select	 isnull(yearEntry1, 'N/A') as yearEntry,
				 count(instituteIdTranscript2) as valueSeries1,
				 sum(isnull(countPeople2, 0)) as valueSeries2
		from	 #udsTemp9
		where	 (yearEntry2 is not null)
		group by yearEntry1
		order by yearEntry1

		select	 'จำนวนโรงเรียนและจำนวนนักศึกษาทั้งหมดที่ยังไม่ส่งไปตรวจสอบคุณวุฒิ' as title,
				 'จำนวน,Number of,จำนวน ( โรงเรียน ),Number of ( school ),#F8A13F,NumberofSchoolDrillDown' as titleSeries1,
				 count(case when (instituteIdTranscript2 is not null) then null else instituteIdTranscript3 end) as valueSeries1,
				 'จำนวน,Number of,จำนวน ( นักศึกษา ),Number of ( student ),#C0463D,NumberofStudentDrillDown' as titleSeries2,
				 sum(isnull(countPeople3, 0)) as valueSeries2
		from	 #udsTemp9

		select	 isnull(yearEntry1, 'N/A') as yearEntry,
				 count(case when (instituteIdTranscript2 is not null) then null else instituteIdTranscript3 end) as valueSeries1,
				 sum(isnull(countPeople3, 0)) as valueSeries2
		from	 #udsTemp9
		where	 (yearEntry3 is not null)
		group by yearEntry1
		order by yearEntry1

		select	 'จำนวนโรงเรียนและจำนวนนักศึกษาทั้งหมดที่ส่งไปตรวจสอบคุณวุฒิและตอบกลับมา' as title,
				 'จำนวน,Number of,จำนวน ( โรงเรียน ),Number of ( school ),#F8A13F,NumberofSchoolDrillDown' as titleSeries1,
				 count(instituteIdTranscript4) as valueSeries1,
				 'จำนวน,Number of,จำนวน ( นักศึกษา ),Number of ( student ),#C0463D,NumberofStudentDrillDown' as titleSeries2,
				 sum(isnull(countPeople4, 0)) as valueSeries2
		from	 #udsTemp9

		select	 isnull(yearEntry1, 'N/A') as yearEntry,
				 count(instituteIdTranscript4) as valueSeries1,
				 sum(isnull(countPeople4, 0)) as valueSeries2
		from	 #udsTemp9
		where	 (yearEntry4 is not null)
		group by yearEntry1
		order by yearEntry1

		select	 'จำนวนโรงเรียนและจำนวนนักศึกษาทั้งหมดที่ส่งไปตรวจสอบคุณวุฒิและยังไม่ตอบกลับมา' as title,
				 'จำนวน,Number of,จำนวน ( โรงเรียน ),Number of ( school ),#F8A13F,NumberofSchoolDrillDown' as titleSeries1,
				 count(case when (instituteIdTranscript4 is not null) then null else instituteIdTranscript5 end) as valueSeries1,
				 'จำนวน,Number of,จำนวน ( นักศึกษา ),Number of ( student ),#C0463D,NumberofStudentDrillDown' as titleSeries2,
				 sum(isnull(countPeople5, 0)) as valueSeries2
		from	 #udsTemp9

		select	 isnull(yearEntry1, 'N/A') as yearEntry,
				 count(case when (instituteIdTranscript4 is not null) then null else instituteIdTranscript5 end) as valueSeries1,
				 sum(isnull(countPeople5, 0)) as valueSeries2
		from	 #udsTemp9
		where	 (yearEntry5 is not null)
		group by yearEntry1
		order by yearEntry1
	end

	------------------------------------------------------------------------------------------------------------------------------------------------------

	if (@reportName = 'AuditTranscriptApprovedLevel1ViewTable')
	begin
		select	 1 as rowNum,
				 ('NeedSend' + yearEntry1) as id,
				 'NeedSend' as subject,
				 'จำนวนโรงเรียนและจำนวนนักศึกษาทั้งหมดที่ต้องส่งไปตรวจสอบคุณวุฒิ' as title,
				 yearEntry1 as yearEntry,
				 count(instituteIdTranscript1) as countInstitute,
				 sum(isnull(countPeople1, 0)) as countPeople
		from	 #udsTemp9
		where	 (yearEntry1 is not null)
		group by yearEntry1
		union
		select	 2 as rowNum,
				 ('Send' + yearEntry1) as id,
				 'Send' as subject,
				 'จำนวนโรงเรียนและจำนวนนักศึกษาทั้งหมดที่ส่งไปตรวจสอบคุณวุฒิ' as title,
				 yearEntry1 as yearEntry,
				 count(instituteIdTranscript2) as countInstitute,
				 sum(isnull(countPeople2, 0)) as countPeople
		from	 #udsTemp9
		where	 (yearEntry2 is not null)
		group by yearEntry1
		union
		select	 3 as rowNum,
				 ('NotSend' + yearEntry1) as id,
				 'NotSend' as subject,
				 'จำนวนโรงเรียนและจำนวนนักศึกษาทั้งหมดที่ยังไม่ส่งไปตรวจสอบคุณวุฒิ' as title,
				 yearEntry1 as yearEntry,
				 count(case when (instituteIdTranscript2 is not null) then null else instituteIdTranscript3 end) as countInstitute,
				 sum(isnull(countPeople3, 0)) as countPeople
		from	 #udsTemp9
		where	 (yearEntry3 is not null)
		group by yearEntry1
		union
		select	 4 as rowNum,
				 ('SendReceive' + yearEntry1) as id,
				 'SendReceive' as subject,
				 'จำนวนโรงเรียนและจำนวนนักศึกษาทั้งหมดที่ส่งไปตรวจสอบคุณวุฒิและตอบกลับมา' as title,
				 yearEntry1 as yearEntry,
				 count(instituteIdTranscript4) as countInstitute,
				 sum(isnull(countPeople4, 0)) as countPeople
		from	 #udsTemp9
		where	 (yearEntry4 is not null)
		group by yearEntry1
		union
		select	 5 as rowNum,
				 ('SendNotReceive' + yearEntry1) as id,
				 'SendNotReceive' as subject,
				 'จำนวนโรงเรียนและจำนวนนักศึกษาทั้งหมดที่ส่งไปตรวจสอบคุณวุฒิและยังไม่ตอบกลับมา' as title,
				 yearEntry1 as yearEntry,
				 count(case when (instituteIdTranscript4 is not null) then null else instituteIdTranscript5 end) as countInstitute,
				 sum(isnull(countPeople5, 0)) as countPeople
		from	 #udsTemp9
		where	 (yearEntry5 is not null)
		group by yearEntry1
	end

	------------------------------------------------------------------------------------------------------------------------------------------------------

	if (@reportName = 'AuditTranscriptApprovedLevel21ViewTableNeedSend' or
		@reportName = 'AuditTranscriptApprovedLevel21ViewTableSend' or
		@reportName = 'AuditTranscriptApprovedLevel21ViewTableNotSend' or
		@reportName = 'AuditTranscriptApprovedLevel21ViewTableSendReceive' or
		@reportName = 'AuditTranscriptApprovedLevel21ViewTableSendNotReceive')
	begin
		select	count(instituteIdTranscript1)
		from	#udsTemp9
		where	(yearEntry1 = @yearEntry)

		if (@reportName = 'AuditTranscriptApprovedLevel21ViewTableNeedSend')
		begin
			select	 row_number() over(order by
						yearEntry1,
						instituteCountryCodes3LetterTranscript1,
						instituteProvinceNameTranscript1,
						instituteNameTranscript1
					 ) as rowNum,
					 instituteIdTranscript1 as id,
					 yearEntry1 as yearEntry,
					 instituteCountryCodes3LetterTranscript1 as instituteCountryCodes3LetterTranscript,
					 instituteProvinceNameTranscript1 as instituteProvinceNameTranscript,					 
					 instituteNameTranscript1 as instituteNameTranscript,
					 sum(isnull(countPeople1, 0)) as countPeople
			from	 #udsTemp9
			where	 (yearEntry1 = @yearEntry)
			group by yearEntry1, instituteCountryCodes3LetterTranscript1, instituteProvinceNameTranscript1, instituteIdTranscript1, instituteNameTranscript1
		end

		if (@reportName = 'AuditTranscriptApprovedLevel21ViewTableSend')
		begin
			select	 row_number() over(order by
						yearEntry1,
						instituteCountryCodes3LetterTranscript2,
						instituteProvinceNameTranscript2,
						instituteNameTranscript2
					 ) as rowNum,					 						
					 instituteIdTranscript2 as id,
					 yearEntry1 as yearEntry,
					 instituteCountryCodes3LetterTranscript2 as instituteCountryCodes3LetterTranscript,
					 instituteProvinceNameTranscript2 as instituteProvinceNameTranscript,					 
					 instituteNameTranscript2 as instituteNameTranscript,
					 sum(isnull(countPeople2, 0)) as countPeople
			from	 #udsTemp9
			where	 (yearEntry2 = @yearEntry)
			group by yearEntry1, instituteCountryCodes3LetterTranscript2, instituteProvinceNameTranscript2, instituteIdTranscript2, instituteNameTranscript2			
		end
		
		if (@reportName = 'AuditTranscriptApprovedLevel21ViewTableNotSend')
		begin
			select	 row_number() over(order by
						yearEntry,
						instituteCountryCodes3LetterTranscript,
						instituteProvinceNameTranscript,
						instituteNameTranscript
					 ) as rowNum,
					 *
			from	 (
						select	 instituteIdTranscript3 as id,
								 yearEntry1 as yearEntry,
								 instituteCountryCodes3LetterTranscript3 as instituteCountryCodes3LetterTranscript,
								 instituteProvinceNameTranscript3 as instituteProvinceNameTranscript,								 
								 (case when (instituteIdTranscript2 is not null) then (instituteNameTranscript3 + ' ( มีการส่งไปบางส่วน ) ') else instituteNameTranscript3 end) as instituteNameTranscript,
								 sum(isnull(countPeople3, 0)) as countPeople
						from	 #udsTemp9
						where	 (yearEntry3 = @yearEntry)
						group by yearEntry1, instituteIdTranscript2, instituteCountryCodes3LetterTranscript3, instituteProvinceNameTranscript3, instituteIdTranscript3, instituteNameTranscript3
					 ) as a 
		end

		if (@reportName = 'AuditTranscriptApprovedLevel21ViewTableSendReceive')
		begin
			select	 row_number() over(order by
						yearEntry1,
						instituteCountryCodes3LetterTranscript4,
						instituteProvinceNameTranscript4,
						instituteNameTranscript4
					 ) as rowNum,
					 instituteIdTranscript4 as id,
					 yearEntry1 as yearEntry,
					 instituteCountryCodes3LetterTranscript4 as instituteCountryCodes3LetterTranscript,
					 instituteProvinceNameTranscript4 as instituteProvinceNameTranscript,					 
					 instituteNameTranscript4 as instituteNameTranscript,
					 sum(isnull(countPeople4, 0)) as countPeople
			from	 #udsTemp9
			where	 (yearEntry4 = @yearEntry)
			group by yearEntry1, instituteCountryCodes3LetterTranscript4, instituteProvinceNameTranscript4, instituteIdTranscript4, instituteNameTranscript4
		end

		if (@reportName = 'AuditTranscriptApprovedLevel21ViewTableSendNotReceive')
		begin
			select	 row_number() over(order by
						yearEntry,
						instituteCountryCodes3LetterTranscript,
						instituteProvinceNameTranscript,
						instituteNameTranscript
					 ) as rowNum,
					 *
			from	 (
						select	 instituteIdTranscript5 as id,
								 yearEntry1 as yearEntry,
								 instituteCountryCodes3LetterTranscript5 as instituteCountryCodes3LetterTranscript,
								 instituteProvinceNameTranscript5 as instituteProvinceNameTranscript,								 
								 (case when (instituteIdTranscript4 is not null) then (instituteNameTranscript5 + ' ( มีการตอบกลับบางส่วน ) ') else instituteNameTranscript5 end) as instituteNameTranscript,
								 sum(isnull(countPeople5, 0)) as countPeople
						from	 #udsTemp9
						where	 yearEntry5 = @yearEntry
						group by yearEntry1, instituteIdTranscript4, instituteCountryCodes3LetterTranscript5, instituteProvinceNameTranscript5, instituteIdTranscript5, instituteNameTranscript5
					 ) as a
		end
	end
	
	------------------------------------------------------------------------------------------------------------------------------------------------------
	
	if (@reportName = 'AuditTranscriptApprovedLevel22ViewTableNeedSend' or
		@reportName = 'AuditTranscriptApprovedLevel22ViewTableSend' or
		@reportName = 'AuditTranscriptApprovedLevel22ViewTableNotSend' or
		@reportName = 'AuditTranscriptApprovedLevel22ViewTableSendReceive' or
		@reportName = 'AuditTranscriptApprovedLevel22ViewTableSendNotReceive')
	begin
		select	sum(isnull(countPeople1, 0))
		from	#udsTemp9
		where	(yearEntry1 = @yearEntry)

		select	id,
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
				isnull(instituteCountryNameTHTranscript, instituteCountryNameENTranscript) as instituteCountryNameTranscript,				
				instituteProvinceIdTranscript,
				isnull(instituteProvinceNameTHTranscript, instituteProvinceNameENTranscript) as instituteProvinceNameTranscript,
				instituteIdTranscript,
				isnull(institutelNameTHTranscript, institutelNameENTranscript) as institutelNameTranscript
		into	#udsTemp10
		from	#udsTemp3
		where	(yearEntry = @yearEntry)

		if (@reportName = 'AuditTranscriptApprovedLevel22ViewTableNeedSend')
		begin
			select	row_number() over(order by
							case when @sort = 'Student ID Ascending'		then studentCode end asc,
							case when @sort = 'Name Ascending'				then firstName end asc,
							case when @sort = 'Faculty Ascending'			then facultyId end asc,
							case when @sort = 'Program Ascending'			then programId end asc,
							case when @sort = 'Year Attended Ascending'		then yearEntry end asc
					) as rowNum,
					*
			from	#udsTemp10
		end

		if (@reportName = 'AuditTranscriptApprovedLevel22ViewTableSend')
		begin
			select	row_number() over(order by
							case when @sort = 'Student ID Ascending'		then studentCode end asc,
							case when @sort = 'Name Ascending'				then firstName end asc,
							case when @sort = 'Faculty Ascending'			then facultyId end asc,
							case when @sort = 'Program Ascending'			then programId end asc,
							case when @sort = 'Year Attended Ascending'		then yearEntry end asc
					) as rowNum,
					*
			from	#udsTemp10
			where	(transcriptAuditSentStatus = 'Y')
		end

		if (@reportName = 'AuditTranscriptApprovedLevel22ViewTableNotSend')
		begin
			select	row_number() over(order by
							case when @sort = 'Student ID Ascending'		then studentCode end asc,
							case when @sort = 'Name Ascending'				then firstName end asc,
							case when @sort = 'Faculty Ascending'			then facultyId end asc,
							case when @sort = 'Program Ascending'			then programId end asc,
							case when @sort = 'Year Attended Ascending'		then yearEntry end asc
					) as rowNum,
					*
			from	#udsTemp10
			where	(transcriptAuditSentStatus = 'N')
		end

		if (@reportName = 'AuditTranscriptApprovedLevel22ViewTableSendReceive')
		begin
			select	row_number() over(order by
							case when @sort = 'Student ID Ascending'		then studentCode end asc,
							case when @sort = 'Name Ascending'				then firstName end asc,
							case when @sort = 'Faculty Ascending'			then facultyId end asc,
							case when @sort = 'Program Ascending'			then programId end asc,
							case when @sort = 'Year Attended Ascending'		then yearEntry end asc
					) as rowNum,
					*
			from	#udsTemp10
			where	(transcriptAuditSentStatus = 'Y') and
					(transcriptResultAuditReceivedStatus = 'Y')
		end

		if (@reportName = 'AuditTranscriptApprovedLevel22ViewTableSendNotReceive')
		begin
			select	row_number() over(order by
							case when @sort = 'Student ID Ascending'		then studentCode end asc,
							case when @sort = 'Name Ascending'				then firstName end asc,
							case when @sort = 'Faculty Ascending'			then facultyId end asc,
							case when @sort = 'Program Ascending'			then programId end asc,
							case when @sort = 'Year Attended Ascending'		then yearEntry end asc
					) AS rowNum,
					*
			from	#udsTemp10
			where	(transcriptAuditSentStatus = 'Y') and
					(transcriptResultAuditReceivedStatus = 'N')
		end
	end

end
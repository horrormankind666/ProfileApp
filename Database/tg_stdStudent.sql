USE [Infinity]
GO
/****** Object:  Trigger [dbo].[tg_stdStudent]    Script Date: 12/5/2564 23:03:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<ยุทธภูมิ ตวันนา>
-- Create date: <๑๔/๑๐/๒๕๕๘>
-- Description:	<สำหรับบันทึกข้อมูล Transaction ของตาราง stdStudent หลังจากที่มีการ INSERT, DELETE, UPDATE>
-- =============================================
ALTER trigger [dbo].[tg_stdStudent] 
   ON [dbo].[stdStudent]
   after insert, delete, update
as
begin
	set concat_null_yields_null off
	
	declare @table varchar(50) = 'stdStudent'
    declare @action varchar(10) = null
    
	if exists (select * from inserted)
	begin
		if exists (select * from deleted)
			set @action = 'UPDATE'
		else
			set @action = 'INSERT'

		insert into InfinityLog..stdStudentLog
		(
			stdStudentId,
			uId,
			personId,
			studentCode,
			tempCode,
			facultyId,
			programId,
			degree,
			programYear,
			admissionDate,--10
			admissionType,
			acaYear,
			yearEntry,
			status,
			class,
			regisExtra,
			distinction,
			mspJoin,
			mspStartSemester,
			mspStartYear,
			mspEndSemester,
			mspEndYear,
			mspResignDate,
			pictureName,
			cancelStatus,
			cancelDate,--20
			createdDate,
			createdBy,
			graduateYear,
			graduateDate,
			councilDate,
			updateGradDate,
			updateGradBy,
			admissionId,
			modifyDate,
			modifyBy,--30
			modifyIp,
			updateWhat,
			updateReason,
			quotaCode,	
			courseYear,					
			logDatabase,
			logTable,
			logAction,
			logActionDate,
			logActionBy,
			logIp--40
	
		)
		select	[id],
				[uId],
				[personId],
				[studentCode],
				[tempCode],
				[facultyId],
				[programId],
				[degree],
				[programYear],
				[admissionDate],--10
				[admissionType],
				[acaYear],
				[yearEntry],
				[status],
				[class],
				[regisExtra],
				[distinction],
				[mspJoin],
				[mspStartSemester],
				[mspStartYear],
				[mspEndSemester],
				[mspEndYear],
				[mspResignDate],
				[pictureName],
				[cancelStatus],
				[cancelDate],--20
				[createdDate],
				[createdBy],
				[graduateYear],
				[graduateDate],
				[councilDate],
				[updateGradDate],
				[updateGradBy],
				[admissionId],
				[modifyDate],
				[modifyBy],--30
				[modifyIp],
				[updateWhat],
				[updateReason],
				[quotaCode],
				[courseYear],
				db_name(),
				@table,
				@action,
				getdate(),
				system_user,
				dbo.fnc_perGetIP()--40
		from	inserted		
	end
	else
		begin
			set @action = 'DELETE'
			
			insert into InfinityLog..stdStudentLog
			(
				stdStudentId,
				uId,
				personId,
				studentCode,
				tempCode,
				facultyId,
				programId,
				degree,
				programYear,
				admissionDate,
				admissionType,
				acaYear,
				yearEntry,
				status,
				class,
				regisExtra,
				distinction,
				mspJoin,
				mspStartSemester,
				mspStartYear,
				mspEndSemester,
				mspEndYear,
				mspResignDate,
				pictureName,
				cancelStatus,
				cancelDate,
				createdDate,
				createdBy,
				graduateYear,
				graduateDate,
				councilDate,
				updateGradDate,
				updateGradBy,
				admissionId,
				modifyDate,
				modifyBy,
				modifyIp,
				updateWhat,
				updateReason,
				quotaCode,	
				courseYear,		
				logDatabase,
				logTable,
				logAction,
				logActionDate,
				logActionBy,
				logIp
			)
			SELECT	[id],
					[uId],
					[personId],
					[studentCode],
					[tempCode],
					[facultyId],
					[programId],
					[degree],
					[programYear],
					[admissionDate],
					[admissionType],
					[acaYear],
					[yearEntry],
					[status],
					[class],
					[regisExtra],
					[distinction],
					[mspJoin],
					[mspStartSemester],
					[mspStartYear],
					[mspEndSemester],
					[mspEndYear],
					[mspResignDate],
					[pictureName],
					[cancelStatus],
					[cancelDate],
					[createdDate],
					[createdBy],
					[graduateYear],
					[graduateDate],
					[councilDate],
					[updateGradDate],
					[updateGradBy],
					[admissionId],
					[modifyDate],
					[modifyBy],
					[modifyIp],
					[updateWhat],
					[updateReason],
					[quotaCode],
					[courseYear],
					db_name(),
					@table,
					@action,
					getdate(),
					system_user,
					dbo.fnc_perGetIP()
			from	deleted			
		end		
end

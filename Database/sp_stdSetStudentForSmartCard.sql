USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_stdSetStudentForSmartCard]    Script Date: 22/6/2564 0:15:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๒๒/๐๖/๒๕๖๔>
-- Description	: <>
-- =============================================
/*
declare @xmlData xml = '
<row>
<perPersonId>2564000321</perPersonId>
<issueDate>01-06-2564</issueDate>
<expiryDate>31-07-2568</expiryDate>
<exportBy>yutthaphoom.taw</exportBy>
<exportIP>10.90.40.162</exportIP>
</row>
'
exec sp_stdSetStudentForSmartCard @xmlData
*/
  
ALTER procedure [dbo].[sp_stdSetStudentForSmartCard]
(	
	@xmlData xml
)
as
begin	
	set concat_null_yields_null off

	begin try
		begin tran
			declare @xmlNewData xml = (select @xmlData for xml path('table'))
			declare @docHandle int
			declare @ID uniqueidentifier = null
			declare @errorCode int = null
			
			exec sp_xml_preparedocument @docHandle output, @xmlNewData

			select	*
			into	#tblStudentForSmartCard
			from	openxml(@docHandle, '/table/row', 2)
			with (	
				perPersonId	varchar(10),
				issueDate varchar(10),
				expiryDate	varchar(10),
				exportBy varchar(50),
				exportIP varchar(50)
			)
			
			set @ID = newid()

			insert into InfinityLog..stdStudentForSmartCard
			(
				ID,
				perPersonId,
				issueDate,
				expiryDate,
				exportDate,
				exportBy,				
				exportIP
			)				
			select	dbo.fnc_utilStringCompare(isnull(@ID, ''), '', @ID, null),
					dbo.fnc_utilStringCompare(isnull(perPersonId, ''), '', perPersonId, null),
					dbo.fnc_utilStringCompare(isnull(issueDate, ''), '', issueDate, null),
					dbo.fnc_utilStringCompare(isnull(expiryDate, ''), '', expiryDate, null),
					getdate(),
					dbo.fnc_utilStringCompare(isnull(exportBy, ''), '', exportBy, null),
					dbo.fnc_utilStringCompare(isnull(exportIP, ''), '', exportIP, null)
			from	#tblStudentForSmartCard

			set @errorCode = 0 -- สำเร็จ

		commit tran
	end try
	begin catch
		set @errorCode = 1

		rollback tran
		insert into InfinityLog..sysError
		(
			systemName,
			errorNumber,
			errorMessage,
			hint,
			url,
			logDate
		)
		values
		(			
			'stdStudentForSmartCard',
			error_number(),
			error_message(),
			(error_procedure() + ' --> ' + convert(nvarchar(max), @xmlData)),
			null,
			getdate()
		)			
	end catch

	select	convert(nvarchar(max), @xmlData) as xmlData,
			@errorCode as errorCode
end
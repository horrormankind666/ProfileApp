USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_perSetEvent]    Script Date: 16/6/2564 20:53:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๖/๐๖/๒๕๖๔>
-- Description	: <>
-- =============================================
/*
declare @xmlData xml = '
<row>
<url>http://localhost:52920/Module/Operation/eProfile/ePFDownloadFile.aspx?f=SCBAccountOpeningForm</url>
<parameters>{"transProjectID":"TPROJECTID00001"}</parameters>
<headers>{"Authorization":"Bearer"}</headers>
<cookie>ADFS,MjQvMDUvMjU2NCAwMTowODo1MQ==</cookie>
<deviceInfo>{"userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:87.0) Gecko/20100101 Firefox/87.0"}</deviceInfo>
<remark>download SCB account opening form</remark>
<actionBy>2564000278</actionBy>
<actionIP>10.90.40.25</actionIP>
</row>
'
exec sp_perSetEvent @xmlData
*/
  
ALTER procedure [dbo].[sp_perSetEvent]
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
			into	#tblPerEvent
			from	openxml(@docHandle, '/table/row', 2)
			with (	
				url	varchar(255),
				parameters varchar(255),
				headers	nvarchar(max),
				cookie	nvarchar(max),
				deviceInfo varchar(1000),
				remark varchar(255),
				actionBy varchar(50),
				actionIP varchar(50)
			)

			set @ID = newid()
				
			insert into InfinityLog..perEvent
			(
				ID,
				url,
				parameters,
				headers,
				cookie,
				deviceInfo,
				remark,
				actionDate,
				actionBy,
				actionIP
			)				
			select	dbo.fnc_utilStringCompare(isnull(@ID, ''), '', @ID, null),
					dbo.fnc_utilStringCompare(isnull(url, ''), '', url, null),
					dbo.fnc_utilStringCompare(isnull(parameters, ''), '', parameters, null),
					dbo.fnc_utilStringCompare(isnull(headers, ''), '', headers, null),
					dbo.fnc_utilStringCompare(isnull(cookie, ''), '', cookie, null),
					dbo.fnc_utilStringCompare(isnull(deviceInfo, ''), '', deviceInfo, null),
					dbo.fnc_utilStringCompare(isnull(remark, ''), '', remark, null),
					getdate(),
					dbo.fnc_utilStringCompare(isnull(actionBy, ''), '', actionBy, 'anonymous'),					
					dbo.fnc_utilStringCompare(isnull(actionIP, ''), '', actionIP, null)
			from	#tblPerEvent

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
			'perEvent',
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
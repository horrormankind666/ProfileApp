USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_sysGetDateEvent]    Script Date: 05/12/2015 10:54:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Thanakrit.tae>
-- Create date: <2014-10-30>
-- Description:	<รายการ วันที่ เปิด/ปิด ระบบ >
-- Page:	<RegNormalRegisterDb.cs>
-- =============================================
-- [sp_sysGetDateEvent] 'BILLPAYMENT','INVOICE_QUOTAS'
ALTER PROCEDURE [dbo].[sp_sysGetDateEvent]
	@sysName varchar(50)
	,@sysEvent varchar(50)
AS
BEGIN
	SET LANGUAGE thai

	Select Top 1 *
		,id
		,startDate
		,endDate
		,(CASE WHEN (startDate IS NOT NULL) THEN CONVERT(VARCHAR, startDate, 103) ELSE NULL END) AS enStartDate
		,(CASE WHEN (endDate IS NOT NULL) THEN CONVERT(VARCHAR, endDate, 103) ELSE NULL END) AS enEndDate
		,CONVERT(varchar(7),startDate,113) + ' ' + Cast(Year(startDate)+543 as varchar(4)) cStartDate
		,CONVERT(varchar(7),endDate,113) + ' ' + Cast(Year(endDate)+543 as varchar(4)) cEndDate
		,CONVERT(varchar(8),startDate,108) cStartTime
		,CONVERT(varchar(8),endDate,108) cEndTime
		,yearEntry
		,entranceType
		,facultyprogram
		,cancelStatus
	From sysDateEvent
	Where [sysName]=@sysName
		and sysEvent=@sysEvent
		and cancelStatus is Null
	Order By createdDate desc
	
	SET LANGUAGE english
END

--select * from finFeeProgram
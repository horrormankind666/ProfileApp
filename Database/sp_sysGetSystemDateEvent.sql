USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_sysGetDateEvent]    Script Date: 07/15/2015 12:01:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๒/๐๖/๒๕๕๘>
-- Description	: <สำหรับเรียกดูข้อมูลการเข้าใช้งานระบบ>
-- Parameter
--  1. sysName	เป็น VARCHAR	รับค่าชื่อระบบ
--  2. sysEvent	เป็น VARCHAR	รับค่าชื่อระบบ
-- =============================================
ALTER PROCEDURE [dbo].[sp_sysGetSystemDateEvent]
	@sysName VARCHAR(MAX) = NULL,
	@sysEvent VARCHAR(MAX) = NULL
AS
BEGIN
	SET LANGUAGE thai

	SELECT	 Top 1 *,
			 id,
			 startDate,
			 endDate,
			 (CASE WHEN (startDate IS NOT NULL) THEN CONVERT(VARCHAR, startDate, 103) ELSE NULL END) AS enStartDate,
			 (CASE WHEN (endDate IS NOT NULL) THEN CONVERT(VARCHAR, endDate, 103) ELSE NULL END) AS enEndDate,
			 CONVERT(varchar(7),startDate,113) + ' ' + Cast(Year(startDate)+543 as varchar(4)) cStartDate,
			 CONVERT(varchar(7),endDate,113) + ' ' + Cast(Year(endDate)+543 as varchar(4)) cEndDate,
			 CONVERT(varchar(8),startDate,108) cStartTime,
			 CONVERT(varchar(8),endDate,108) cEndTime,
			 yearEntry,
			 entranceType,
			 facultyprogram,
			 cancelStatus
	FROM	 sysDateEvent
	WHERE	 (sysName = @sysName) AND
			 (sysEvent = @sysEvent)
	ORDER BY createdDate DESC
	
	SET LANGUAGE english
END
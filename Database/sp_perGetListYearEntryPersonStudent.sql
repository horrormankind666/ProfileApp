USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_perGetListYearEntryPersonStudent]    Script Date: 22-07-2016 12:51:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๒๐/๐๕/๒๕๕๘>
-- Description	: <สำหรับแสดงข้อมูลปีที่เข้าศึกษา>
-- =============================================
ALTER PROCEDURE [dbo].[sp_perGetListYearEntryPersonStudent]
AS
BEGIN
	SET NOCOUNT ON

	SELECT	 yearEntry
	FROM	 stdStudent
	GROUP BY yearEntry
	HAVING	 yearEntry IS NOT NULL
	ORDER BY yearEntry DESC
END
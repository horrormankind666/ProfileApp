USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_stdGetListDegreeLevel]    Script Date: 04-08-2016 16:27:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๑/๐๙/๒๕๕๘>
-- Description	: <สำหรับแสดงข้อมูลวุฒืการศึกษา>
-- =============================================
ALTER PROCEDURE [dbo].[sp_stdGetListDegreeLevel]
AS
BEGIN
	SET NOCOUNT ON
	
	SELECT	 id,
			 priorityDegreeLevel,
			 thDegreeLevelName AS degreeLevelNameTH,
			 enDegreeLevelName AS degreeLevelNameEN,
			 createDate,
			 createBy,
			 createIp,
			 modifyDate,
			 modifyBy,
			 modifyIp
	FROM	 stdDegreeLevel
	ORDER BY priorityDegreeLevel
END
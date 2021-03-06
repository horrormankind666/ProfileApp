USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_perGetListEducation]    Script Date: 05/15/2015 12:43:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๕/๐๑/๒๕๕๗>
-- Description	: <สำหรับแสดงข้อมูลการศึกษาของบุคคล>
--  1. personId	เป็น VARCHAR รับค่ารหัสบุคคล
-- =============================================
ALTER PROCEDURE [dbo].[sp_perGetListEducation]
(
	@personId VARCHAR(MAX) = NULL
)
AS
BEGIN
	SET NOCOUNT ON;

	SET @personId = LTRIM(RTRIM(@personId))

	SELECT * FROM fnc_perGetListEducation(@personId, '', '')
END
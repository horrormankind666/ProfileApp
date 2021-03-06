USE [Infinity]
GO
/****** Object:  UserDefinedFunction [dbo].[fnc_quoGetVerifyCode]    Script Date: 11/09/2015 10:53:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๐๙/๑๑/๒๕๕๘>
-- Description	: <สำหรับสร้างรหัสสำหรับการยืนยันตัวตน>
-- =============================================
ALTER FUNCTION [dbo].[fnc_quoGetVerifyCode]
(
	@length INT = NULL
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @verifiedCode NVARCHAR(MAX) = ''
	DECLARE @exit VARCHAR(1) = 'F'
	DECLARE @recordCount INT = 0

	WHILE (@exit = 'F')
	BEGIN
		SET @verifiedCode = dbo.fnc_perGetRandomString(@length)
		SET @recordCount = (SELECT COUNT(verifiedCode) FROM quoVerifyIdentity WHERE verifiedCode = @verifiedCode)
		IF (@recordCount = 0) SET @exit = 'T'
	END	
	
	RETURN @verifiedCode
END
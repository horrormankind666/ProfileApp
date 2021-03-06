USE [Infinity]
GO
/****** Object:  UserDefinedFunction [dbo].[fnc_perGetIP]    Script Date: 05/14/2015 10:06:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<ยุทธภูมิ ตวันนา>
-- Create date: <๒๗/๑๑/๒๕๕๖>
-- Description:	<สำหรับแสดงหมายเลข IP Address>
-- =============================================
ALTER FUNCTION [dbo].[fnc_perGetIP]
(
)
RETURNS VARCHAR(255)
AS
BEGIN
    DECLARE @ipAddress VARCHAR(255) = NULL;
 
    SELECT	@ipAddress = client_net_address
	FROM    sys.sysprocesses AS sp INNER JOIN
			sys.dm_exec_connections AS decc ON sp.spid = decc.session_id
	WHERE   sp.spid = @@SPID
    
    --SELECT @ipAddress = client_net_address FROM sys.dm_exec_connections WHERE Session_id = @@SPID;
 
    Return @ipAddress
END
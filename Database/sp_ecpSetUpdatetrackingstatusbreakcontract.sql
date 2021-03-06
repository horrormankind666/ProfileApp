USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_ecpSetUpdatetrackingstatusbreakcontract]    Script Date: 26/1/2559 12:33:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Anussara Wanwang>
-- Create date: <19-03-2015>
-- Description:	<UPDATE updatetrackingstatusbreakcontract>
-- =============================================
ALTER PROCEDURE [dbo].[sp_ecpSetUpdatetrackingstatusbreakcontract] 
	 @send varchar(1)
	,@edit varchar(1)
	,@cancel varchar(1)
	,@id int
AS
BEGIN
	UPDATE ecpTransBreakContract SET
	 StatusSend = @send
	,DateTimeSend = GETDATE()
	,StatusEdit = @edit
	,StatusCancel = @cancel
	,DateTimeCancel = GETDATE()
	WHERE ID = @id
END

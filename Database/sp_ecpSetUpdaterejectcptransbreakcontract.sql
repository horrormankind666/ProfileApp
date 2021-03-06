USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_ecpSetUpdaterejectcptransbreakcontract]    Script Date: 26/1/2559 12:33:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Anussara Wanwang>
-- Create date: <19-03-2015>
-- Description:	<UPDATE rejectcptransbreakcontract>
-- =============================================
ALTER PROCEDURE [dbo].[sp_ecpSetUpdaterejectcptransbreakcontract]
	@StatusEdit varchar(1)
	,@StatusCancel varchar(1)
	,@id int
	,@actioncomment varchar(1)
	,@comment ntext
	
AS
BEGIN
	UPDATE ecpTransBreakContract SET
	 StatusEdit = @StatusEdit
	,StatusCancel = @StatusCancel
	,DateTimeCancel = Getdate()
	WHERE ID = @id

	INSERT INTO ecpTransReject(BCID, Action, Comment, DateTimeReject)
	SELECT @id,@actioncomment,@comment,Getdate();
END

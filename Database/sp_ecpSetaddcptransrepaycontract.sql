USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_ecpSetaddcptransrepaycontract]    Script Date: 26/1/2559 12:28:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Anussara Wanwang>
-- Create date: <19-03-2015>
-- Description:	<UPDATE INSERT addcptransrepaycontract>
-- =============================================
ALTER PROCEDURE [dbo].[sp_ecpSetaddcptransrepaycontract]
	@Statusrepay int
	,@id int
	,@repaydate varchar(10)
AS
BEGIN
	UPDATE ecpTransRequireContract SET
	StatusRepay = @Statusrepay
	WHERE ID = @id

	INSERT INTO ecpTransRepayContract (RCID, StatusRepay, StatusReply, RepayDate)
	SELECT @id,@Statusrepay,'1',@repaydate
END

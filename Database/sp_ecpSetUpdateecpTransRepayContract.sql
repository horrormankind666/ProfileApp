USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_ecpSetUpdateecpTransRepayContract]    Script Date: 26/1/2559 12:33:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Anussara Wanwang>
-- Create date: <19-03-2015>
-- Description:	<UPDATE ecpTransRepayContract>
-- =============================================
ALTER PROCEDURE [dbo].[sp_ecpSetUpdateecpTransRepayContract]
	@replydate varchar(10)
	,@replyresult int
	,@id int
	,@statusrepay int
	,@repaydate varchar(10)
AS
BEGIN
	IF @replydate IS NOT NULL AND @replyresult IS NOT NULL
	BEGIN
		UPDATE ecpTransRepayContract SET 
		StatusReply = 2
		,ReplyResult = @replyresult
		,ReplyDate = @replydate
		,RepayDate = @repaydate
		WHERE RCID = @id AND StatusRepay = @statusrepay
	END
	ELSE
	 BEGIN
	  	UPDATE ecpTransRepayContract SET 
		RepayDate = @repaydate
		WHERE RCID = @id AND StatusRepay = @statusrepay
	 END
END

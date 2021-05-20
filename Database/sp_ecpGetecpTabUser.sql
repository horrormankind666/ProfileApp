USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_ecpGetecpTabUser]    Script Date: 26/1/2559 12:27:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Anussara Wanwang>
-- Create date: <19-03-2015>
-- Description:	<SELECT ecpTabUser>
-- =============================================
ALTER PROCEDURE [dbo].[sp_ecpGetecpTabUser] 
	@username varchar(50)
	,@password varchar(50)
AS
BEGIN
	SELECT * FROM ecpTabUser WHERE (Username = @username) AND (Password = @password)
END

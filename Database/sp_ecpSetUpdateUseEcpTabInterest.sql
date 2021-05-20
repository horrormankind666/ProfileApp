USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_ecpSetUpdateUseEcpTabInterest]    Script Date: 26/1/2559 12:34:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Anussara Wanwang>
-- Create date: <19-03-2015>
-- Description:	<Update user ecpTabInterest>
-- =============================================
ALTER PROCEDURE [dbo].[sp_ecpSetUpdateUseEcpTabInterest]
		@UseContractInterest int
		,@id int
AS
BEGIN
UPDATE ecpTabInterest SET UseContractInterest = 0
UPDATE ecpTabInterest SET UseContractInterest = @UseContractInterest WHERE ID = @id
END

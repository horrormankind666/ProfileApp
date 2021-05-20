USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_hcsGetHospital]    Script Date: 12/02/2015 09:56:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <�ط����� ��ѹ��>
-- Create date	: <��/��/����>
-- Description	: <����Ѻ���¡�٢�����Ẻ�������ԡ���آ�Ҿ>
-- Parameter
--  1. id	�� NVARCHAR	�Ѻ�������Ẻ�������ԡ���آ�Ҿ
-- =============================================
CREATE PROCEDURE [dbo].[sp_hcsGetRegistrationForm]
(
	@id NVARCHAR(50) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	
	SET @id = LTRIM(RTRIM(@id))
	
	SELECT	hcsfrm.id,
			hcsfrm.thFormName AS formNameTH,
			hcsfrm.enFormName AS formNameEN,
			hcsfrm.forPublicServant,
			hcsfrm.orderForm,
			hcsfrm.cancel AS cancelledStatus
	FROM	hcsForm AS hcsfrm
	WHERE	(hcsfrm.id = @id)
END
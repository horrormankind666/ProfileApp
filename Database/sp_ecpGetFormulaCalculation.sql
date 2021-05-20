SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <�ط����� ��ѹ��>
-- Create date	: <��/��/����>
-- Description	: <����Ѻ�ʴ��������ٵäӹǳ�Թ�������ѭ��>
--  1. id	�� VARCHAR	�Ѻ��������ٵäӹǳ�Թ�������ѭ��
-- =============================================
CREATE PROCEDURE [dbo].[sp_ecpGetFormulaCalculation]
(
	@id VARCHAR(2) = NULL
)
AS
BEGIN
	SET NOCOUNT ON

	SET @id = LTRIM(RTRIM(@id))		

	SELECT	ecpfcc.id,
			ecpfcc.formula AS formulaCalculation,
			('�ٵ÷�� ' + ecpfcc.formula) AS formulaCalculationNameTH,
			('Formula ' + ecpfcc.formula) AS formulaCalculationNameEN,
			ecpfcc.cancelledStatus
	FROM	Infinity..ecpFormulaCalculation AS ecpfcc
	WHERE	(ecpfcc.id = @id)
END
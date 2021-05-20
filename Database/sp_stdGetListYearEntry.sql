SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <�ط����� ��ѹ��>
-- Create date	: <��/��/����>
-- Description	: <����Ѻ�ʴ������Żշ������֡��>
-- =============================================
CREATE PROCEDURE sp_stdGetListYearEntry
AS
BEGIN
	SET NOCOUNT ON

	SELECT	 yearEntry
	FROM	 stdStudent
	GROUP BY yearEntry
	HAVING	 yearEntry IS NOT NULL
	ORDER BY yearEntry DESC
END
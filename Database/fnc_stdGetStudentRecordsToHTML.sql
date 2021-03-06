USE [Infinity]
GO
/****** Object:  UserDefinedFunction [dbo].[fnc_stdGetStudentRecordsToHTML]    Script Date: 30-12-2016 08:19:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<ยุทธภูมิ ตวันนา>
-- Create date: <๑๖/๐๓/๒๕๕๘>
-- Description:	<สำหรับแสดงข้อมูลนักศึกษาแล้วสร้างเป็น HTML>
--  1. section		เป็น VARCHAR	รับค่าตำแหน่งที่ให้แสดง HTML
--  2. thTitle		เป็น VARCHAR	รับค่าชื่อหัวเรื่องภาษาไทย
--  3. enTitle		เป็น VARCHAR	รับค่าชื่อหัวเรื่องภาษาอังกฤษ
--  4. thSubject	เป็น VARCHAR	รับค่าชื่อหัวข้อภาษาไทย
--  5. enSubject	เป็น VARCHAR	รับค่าชื่อหัวข้อภาษาอังกฤษ
--  6. thContent	เป็น VARCHAR	รับค่าเนื้อหาภาษาไทย
--  7. enContent	เป็น VARCHAR	รับค่าเนื้อหาภาษาอังกฤษ
-- =============================================
ALTER FUNCTION  [dbo].[fnc_stdGetStudentRecordsToHTML]
(
	@section VARCHAR(MAX) = NULL,
	@thTitle VARCHAR(MAX) = NULL,
	@enTitle VARCHAR(MAX) = NULL,
	@idSubject VARCHAR(MAX) = NULL,
	@thSubject VARCHAR(MAX) = NULL,
	@enSubject VARCHAR(MAX) = NULL,
	@thContent NVARCHAR(MAX) = NULL,
	@enContent NVARCHAR(MAX) = NULL
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @html NVARCHAR(MAX) = ''
	DECLARE	@strBlank VARCHAR(100) = '----------**********.........0.0000000000000000000??????????'
	
	IF (@section = 'style')
	BEGIN
		SET @html = '<style>
						@import url(https://fonts.googleapis.com/css?family=Pridi:200,300,400&subset=thai);
						body
						{
							background-color:#FFFFFF;
							margin:0px;
							padding:0px;
							overflow-x:hidden;
							overflow-y:scroll;
							cursor:default;   
							min-width:0px;
						}		

						.clear {clear:both;}
						#mainbody, #headbody, #footerbody {min-width:0px;}		
						#bodyfooter {margin-top:0px;height:auto;}
						#footerbody #footerbody-content {padding: 5px;}
						.form-studentcv .avatar-cv {background: url(http://www.student.mahidol.ac.th/Infinity/Profile/Content/Image/eProfileStaff/Label.png);background-position: 0px -155px;margin: 0 auto;border-radius: 50%;position: relative;overflow: hidden;}
						.form-studentcv .avatar-cv.profilepicture-cv {width: 130px;height: 130px;border: 6px solid #CCCCCC;}
						.form-studentcv .avatar-cv .watermark-cv {width: inherit; height: inherit;background: url(http://www.student.mahidol.ac.th/Infinity/Profile/Content/Image/eProfileStaff/BGWaterMark.png) repeat;opacity: 0.6;filter: Alpha(Opacity=60);position: absolute;z-index: 1;border-radius: 50%;}
						.form-studentcv .avatar-cv .img-cv {width: 100%;height: 100%;display: block;border-radius: 50%;}						
						.form-studentcv .th-label-cv {font:300 16px "Pridi", serif;color:#000000;}
						.form-studentcv .en-label-cv {font:300 16px "Pridi", serif;color:#666666;}
						.form-studentcv .form-layout-cv {width:100%;min-width:0px;}
						.form-studentcv .form-content-cv {width:auto;text-align:left;}
						.form-studentcv .form-content-cv .sticky-cv:after {padding-top:79px;}
						.form-studentcv .form-content-cv .form-menu-cv {width:20px;position:fixed;left:10px;top:68px;z-index:2000;}
						.form-studentcv .form-content-cv .form-menu-cv .icon-menu-cv {width:inherit;cursor:pointer}
						.form-studentcv .form-content-cv .form-menu-cv .icon-menu-cv div {display:block;width:inherit;height:3px;background:#000000;}
						.form-studentcv .form-content-cv .form-menu-cv .icon-menu-cv .split-cv {background:transparent;}
						.form-studentcv .form-content-cv .form-menu-cv:hover .icon-menu-cv div {background:#FF0000;}
						.form-studentcv .form-content-cv .form-menu-cv:hover .icon-menu-cv .split-cv {background:transparent;}
						.form-studentcv .form-content-cv .form-menu-cv .link-menu-cv {background:#40DB7F;width:870px;position:absolute;}
						.form-studentcv .form-content-cv .form-menu-cv .link-menu-cv ul {margin:0px;padding:0px;list-style-type:none;}
						.form-studentcv .form-content-cv .form-menu-cv .link-menu-cv ul li {float:left;display:inline;text-align:left;}
						.form-studentcv .form-content-cv .form-menu-cv .link-menu-cv ul li a {display:block;width:270px;text-decoration:none;color:#000000;padding:7px 10px 7px 10px;}
						.form-studentcv .form-content-cv .form-menu-cv .link-menu-cv ul li a .th-label-cv {font-size:14px;line-height:24px;height:22px;}
						.form-studentcv .form-content-cv .form-menu-cv .link-menu-cv ul li a .en-label-cv {font-size:13px;color:#333333;}
						.form-studentcv .form-content-cv .form-menu-cv .link-menu-cv ul li:hover {background:#1DBC60;}																		
						.form-studentcv .form-content-cv .form-head-cv {width:auto;min-height:58px;background:#F1C40F;padding:0px 10px 0px 10px;text-align:center;}
						.form-studentcv .form-content-cv .form-head-cv div:first-child {padding-top:7px;}
						.form-studentcv .form-content-cv .form-head-cv div:last-child {padding-bottom:7px;}
						.form-studentcv .form-content-cv .form-head-cv div {line-height:22px;}
						.form-studentcv .form-content-cv .form-head-cv .th-label-cv {font-size:16px;}        
						.form-studentcv .form-content-cv .form-subject-cv {width:inherit;min-height:58px;background:#2C3E50;padding:0px 10px 0px 10px;text-align:left;}        
						.form-studentcv .form-content-cv .form-subject-cv div:first-child {padding-top:7px;}
						.form-studentcv .form-content-cv .form-subject-cv div:last-child {padding-bottom:7px;}
						.form-studentcv .form-content-cv .form-subject-cv div {line-height:22px;color:#FFFFFF;}
						.form-studentcv .form-content-cv .form-subject-cv .en-label-cv {font-size:13px;}
						.form-studentcv .form-content-cv .form-row-cv {width:inherit;padding:0px 10px 4px 10px;}
						.form-studentcv .form-content-cv .form-row-cv.nocol-cv {padding-top:10px;padding-bottom:10px;}
						.form-studentcv .form-content-cv .form-labelcol-cv, 
						.form-studentcv .form-content-cv .form-inputcol-cv {float:left;word-wrap:break-word;}
						.form-studentcv .form-content-cv .form-labelcol-cv {width:50%;padding:7px 0px 0px 0px;text-align:right;}
						.form-studentcv .form-content-cv .form-labelcol-cv .th-label-cv,
						.form-studentcv .form-content-cv .form-labelcol-cv .en-label-cv {line-height:22px;} 
						.form-studentcv .form-content-cv .form-labelcol-cv .en-label-cv {margin-top:1px;}
						.form-studentcv .form-content-cv .form-inputcol-cv .th-label-cv,
						.form-studentcv .form-content-cv .form-inputcol-cv .en-label-cv {line-height:22px;font-weight:200;}        
						.form-studentcv .form-content-cv .form-inputcol-cv .en-label-cv {margin-top:2px;}
						.form-studentcv .form-content-cv .form-labelcol-cv .en-label-cv, 
						.form-studentcv .form-content-cv .form-inputcol-cv .en-label-cv {font-size:14px;}
						.form-studentcv .form-content-cv .form-inputcol-cv {width:44%;padding:6px 0px 0px 0px;margin-left:10px;}
					 </style>
					 
					 <script>
						function SwapMenu()
						{
							var _this = document.getElementById("link-menu-studentrecords-cv");

							if (_this.style.display == "none")
								_this.style.display = "";
							else
								_this.style.display = "none";
						}
					 </script>'
	END
	
	IF (@section = 'open')
	BEGIN
		SET @html = '<div class="form-studentcv">
						<div class="form-layout-cv">
							<div class="form-content-cv">'							
	END
	
	IF (@section = 'head')
	BEGIN
		SET @html = '			<div class="form-menu-cv">
									<!--
									<div class="icon-menu-cv" onclick="SwapMenu()">
										<div></div>
										<div class="split-cv"></div>
										<div></div>
										<div class="split-cv"></div>
										<div></div>
										<div class="split-cv"></div>
									</div>
									<div class="link-menu-cv" id="link-menu-studentrecords-cv" style="display:none;">
										<ul>
											<li><a href="#studentrecords-subject01"><div class="th-label-cv">ข้อมูลส่วนตัว</div><div class="en-label-cv">Student''s Personal Data</div></a></li>
											<li><a href="#studentrecords-subject02"><div class="th-label-cv">ข้อมูลที่อยู่ตามทะเบียนบ้าน</div><div class="en-label-cv">Permanent Address Information</div></a></li>
											<li><a href="#studentrecords-subject03"><div class="th-label-cv">ข้อมูลที่อยู่ปัจจุบันที่ติดต่อได้</div><div class="en-label-cv">Current Address Information</div></a></li>
											<li><a href="#studentrecords-subject04"><div class="th-label-cv">ข้อมูลการศึกษาระดับประถม</div><div class="en-label-cv">Primary Educational Information</div></a></li>
											<li><a href="#studentrecords-subject05"><div class="th-label-cv">ข้อมูลการศึกษาระดับมัธยมต้น</div><div class="en-label-cv">Junior Educational Information</div></a></li>
											<li><a href="#studentrecords-subject06"><div class="th-label-cv">ข้อมูลการศึกษาระดับมัธยมปลาย</div><div class="en-label-cv">High School Educational Information</div></a></li>
											<li><a href="#studentrecords-subject07"><div class="th-label-cv">ข้อมูลการศึกษาก่อนที่เข้า ม.มหิดล</div><div class="en-label-cv">Prior to Entering MU Information</div></a></li>
											<li><a href="#studentrecords-subject08"><div class="th-label-cv">ข้อมูลการศึกษาคะแนนสอบ</div><div class="en-label-cv">Admission Scores Information</div></a></li>
											<li><a href="#studentrecords-subject09"><div class="th-label-cv">ข้อมูลความสามารถพิเศษ</div><div class="en-label-cv">Talent Information</div></a></li>
											<li><a href="#studentrecords-subject10"><div class="th-label-cv">ข้อมูลสุขภาพ</div><div class="en-label-cv">Health Information</div></a></li>
											<li><a href="#studentrecords-subject11"><div class="th-label-cv">ข้อมูลการทำงาน</div><div class="en-label-cv">Worker Information</div></a></li>
											<li><a href="#studentrecords-subject12"><div class="th-label-cv">ข้อมูลการเงิน</div><div class="en-label-cv">Finance Information</div></a></li>
											<li><a href="#studentrecords-subject13"><div class="th-label-cv">ข้อมูลส่วนตัวของบิดา</div><div class="en-label-cv">Personal Data of Father</div></a></li>
											<li><a href="#studentrecords-subject14"><div class="th-label-cv">ข้อมูลที่อยู่ตามทะเบียนบ้านของบิดา</div><div class="en-label-cv">Permanent Address Information of Father</div></a></li>
											<li><a href="#studentrecords-subject15"><div class="th-label-cv">ข้อมูลที่อยู่ปัจจุบันที่ติดต่อได้ของบิดา</div><div class="en-label-cv">Current Address Information of Father</div></a></li>
											<li><a href="#studentrecords-subject16"><div class="th-label-cv">ข้อมูลการทำงานของบิดา</div><div class="en-label-cv">Worker Information of Father</div></a></li>
											<li><a href="#studentrecords-subject17"><div class="th-label-cv">ข้อมูลส่วนตัวของมารดา</div><div class="en-label-cv">Personal Data of Mother</div></a></li>
											<li><a href="#studentrecords-subject18"><div class="th-label-cv">ข้อมูลที่อยู่ตามทะเบียนบ้านของมารดา</div><div class="en-label-cv">Permanent Address Information of Mother</div></a></li>
											<li><a href="#studentrecords-subject19"><div class="th-label-cv">ข้อมูลที่อยู่ปัจจุบันที่ติดต่อได้ของมารดา</div><div class="en-label-cv">Current Address Information of Mother</div></a></li>
											<li><a href="#studentrecords-subject20"><div class="th-label-cv">ข้อมูลการทำงานของมารดา</div><div class="en-label-cv">Worker Information of Mother</div></a></li>
											<li><a href="#studentrecords-subject21"><div class="th-label-cv">ข้อมูลส่วนตัวของผู้ปกครอง</div><div class="en-label-cv">Personal Data of Parent</div></a></li>
											<li><a href="#studentrecords-subject22"><div class="th-label-cv">ข้อมูลที่อยู่ตามทะเบียนบ้านของผู้ปกครอง</div><div class="en-label-cv">Permanent Address Information of Parent</div></a></li>
											<li><a href="#studentrecords-subject23"><div class="th-label-cv">ข้อมูลที่อยู่ปัจจุบันที่ติดต่อได้ของผู้ปกครอง</div><div class="en-label-cv">Current Address Information of Parent</div></a></li>
											<li><a href="#studentrecords-subject24"><div class="th-label-cv">ข้อมูลการทำงานของผู้ปกครอง</div><div class="en-label-cv">Worker Information of Parent</div></a></li>
										</ul>
									</div>
									-->
								</div>'
		
		IF ((@thTitle IS NOT NULL AND LEN(@thTitle) > 0) OR (@enTitle IS NOT NULL AND LEN(@enTitle) > 0))
		BEGIN
			SET @html = @html +
						'		<div class="form-head-cv">
									<div class="th-label-cv">' + @thTitle + '</div>
									<div class="en-label-cv">' + @enTitle + '</div>
								</div>'
		END													 	
	END		
	
	IF (@section = 'subject')
	BEGIN
		IF ((@thSubject IS NOT NULL AND LEN(@thSubject) > 0) OR (@enSubject IS NOT NULL AND LEN(@enSubject) > 0))
		BEGIN
			SET @html = '		<div class="form-subject-cv"' + (CASE WHEN (@idSubject IS NOT NULL AND LEN(@idSubject) > 0) THEN (' id="studentrecords-subject' + @idSubject + '"') ELSE '' END) + '>
									<div class="th-label-cv">' + @thSubject + '</div>
									<div class="en-label-cv">' + @enSubject + '</div>
								</div>'
		END								
	END
	
	IF (@section = 'content')
	BEGIN
		SET @html = '			<div class="form-row-cv">
									<div>									
										<div class="form-labelcol-cv">
											<div class="th-label-cv">' + @thSubject + '</div>
											<div class="en-label-cv">' + @enSubject + '</div>
										</div>
										<div class="form-inputcol-cv">
											<div class="th-label-cv">' + (CASE WHEN (CHARINDEX(@thContent, @strBlank) = 0) THEN @thContent ELSE '' END) + '</div>
											<div class="en-label-cv">' + (CASE WHEN (CHARINDEX(@enContent, @strBlank) = 0) THEN @enContent ELSE '' END) + '</div>
										</div>
									</div>
									<div class="clear"></div>
								</div>'
	END
	
	IF (@section = 'contentnocol')
	BEGIN
		SET @html = '			<div class="form-row-cv nocol-cv">' + (CASE WHEN (CHARINDEX(@thContent, @strBlank) = 0) THEN @thContent ELSE '' END) + '</div>'
	END
	
	IF (@section = 'close')
	BEGIN
		SET @html = '		</div>
						</div>
					 </div>'
	END	
	
	RETURN @html
END

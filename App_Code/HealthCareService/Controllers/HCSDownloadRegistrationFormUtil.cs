/*
=============================================
Author      : <ยุทธภูมิ ตวันนา>
Create date : <๒๘/๑๒/๒๕๕๙>
Modify date : <๐๙/๐๑/๒๕๖๑>
Description : <คลาสใช้งานเกี่ยวกับการใช้งานฟังก์ชั่นทั่วไปในส่วนของการดาว์นโหลดแบบฟอร์มประกันสุขภาพของนักศึกษา>
=============================================
*/

using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Reflection;
using System.Web;
using NUtil;
using NFinServiceLogin;
using NExportToPDF;

public class HCSDownloadRegistrationFormUtil
{
    public class StudentRecordsUtil
    {
        public static Dictionary<string, object> SetValueDataRecorded(Dictionary<string, object> _dataRecorded, DataSet _ds)
        {
            string _studentPicture = String.Empty;
            DataRow _dr = null;

            if (_ds != null)
            {
                if (_ds.Tables[0].Rows.Count > 0)
                    _dr = _ds.Tables[0].Rows[0];

                _studentPicture = (_dr != null && !String.IsNullOrEmpty(_dr["profilePictureName"].ToString()) ? (HCSUtil._myURLPictureStudent + "/" + _dr["profilePictureName"].ToString()) : String.Empty);
                _studentPicture = (!String.IsNullOrEmpty(_studentPicture) && Util.FileSiteExist(_studentPicture) ? (HCSUtil._myHandlerPath + "?action=image2stream&f=" + Util.EncodeToBase64(_studentPicture)) : String.Empty);

                _dataRecorded.Add("PersonId", (_dr != null && !String.IsNullOrEmpty(_dr["id"].ToString()) ? _dr["id"] : String.Empty));
                _dataRecorded.Add("StudentId", (_dr != null && !String.IsNullOrEmpty(_dr["studentId"].ToString()) ? _dr["studentId"] : String.Empty));
                _dataRecorded.Add("StudentCode", (_dr != null && !String.IsNullOrEmpty(_dr["studentCode"].ToString()) ? _dr["studentCode"] : "XXXXXXX"));
                _dataRecorded.Add("StudentPicture", (!String.IsNullOrEmpty(_studentPicture) ? _studentPicture : String.Empty));
                _dataRecorded.Add("IdCard", (_dr != null && !String.IsNullOrEmpty(_dr["idCard"].ToString()) ? _dr["idCard"].ToString() : String.Empty));
                _dataRecorded.Add("TitleInitialsTH", (_dr != null && !String.IsNullOrEmpty(_dr["titlePrefixInitialsTH"].ToString()) ? _dr["titlePrefixInitialsTH"].ToString() : String.Empty));
                _dataRecorded.Add("TitleInitialsEN", (_dr != null && !String.IsNullOrEmpty(_dr["titlePrefixInitialsEN"].ToString()) ? _dr["titlePrefixInitialsEN"].ToString() : String.Empty));
                _dataRecorded.Add("TitleFullNameTH", (_dr != null && !String.IsNullOrEmpty(_dr["titlePrefixFullNameTH"].ToString()) ? _dr["titlePrefixFullNameTH"].ToString() : String.Empty));
                _dataRecorded.Add("TitleFullNameEN", (_dr != null && !String.IsNullOrEmpty(_dr["titlePrefixFullNameEN"].ToString()) ? _dr["titlePrefixFullNameEN"].ToString() : String.Empty));
                _dataRecorded.Add("FirstName", (_dr != null && !String.IsNullOrEmpty(_dr["firstName"].ToString()) ? _dr["firstName"].ToString() : String.Empty));
                _dataRecorded.Add("MiddleName", (_dr != null && !String.IsNullOrEmpty(_dr["middleName"].ToString()) ? _dr["middleName"].ToString() : String.Empty));
                _dataRecorded.Add("LastName", (_dr != null && !String.IsNullOrEmpty(_dr["lastName"].ToString()) ? _dr["lastName"].ToString() : String.Empty));
                _dataRecorded.Add("FirstNameEN", (_dr != null && !String.IsNullOrEmpty(_dr["firstNameEN"].ToString()) ? _dr["firstNameEN"].ToString() : String.Empty));
                _dataRecorded.Add("MiddleNameEN", (_dr != null && !String.IsNullOrEmpty(_dr["middleNameEN"].ToString()) ? _dr["middleNameEN"].ToString() : String.Empty));
                _dataRecorded.Add("LastNameEN", (_dr != null && !String.IsNullOrEmpty(_dr["lastNameEN"].ToString()) ? _dr["lastNameEN"].ToString() : String.Empty));
                _dataRecorded.Add("GenderFullNameTH", (_dr != null && !String.IsNullOrEmpty(_dr["genderFullNameTH"].ToString()) ? _dr["genderFullNameTH"].ToString() : String.Empty));
                _dataRecorded.Add("GenderFullNameEN", (_dr != null && !String.IsNullOrEmpty(_dr["genderFullNameEN"].ToString()) ? _dr["genderFullNameEN"].ToString() : String.Empty));
                _dataRecorded.Add("GenderInitialsTH", (_dr != null && !String.IsNullOrEmpty(_dr["genderInitialsTH"].ToString()) ? _dr["genderInitialsTH"].ToString() : String.Empty));
                _dataRecorded.Add("GenderInitialsEN", (_dr != null && !String.IsNullOrEmpty(_dr["genderInitialsEN"].ToString()) ? _dr["genderInitialsEN"].ToString() : String.Empty));
                _dataRecorded.Add("BirthDateOfDay", (_dr != null && !String.IsNullOrEmpty(_dr["birthDateOfDay"].ToString()) ? _dr["birthDateOfDay"].ToString() : String.Empty));
                _dataRecorded.Add("BirthDateOfMonth", (_dr != null && !String.IsNullOrEmpty(_dr["birthDateOfMonth"].ToString()) ? _dr["birthDateOfMonth"].ToString() : String.Empty));
                _dataRecorded.Add("BirthDateOfYear", (_dr != null && !String.IsNullOrEmpty(_dr["birthDateOfYear"].ToString()) ? _dr["birthDateOfYear"].ToString() : String.Empty));
                _dataRecorded.Add("BirthDateTH", (_dr != null && !String.IsNullOrEmpty(_dr["birthDateTH"].ToString()) ? _dr["birthDateTH"].ToString() : String.Empty));
                _dataRecorded.Add("BirthDateEN", (_dr != null && !String.IsNullOrEmpty(_dr["birthDateEN"].ToString()) ? _dr["birthDateEN"].ToString() : String.Empty));
                _dataRecorded.Add("Age", (_dr != null && !String.IsNullOrEmpty(_dr["age"].ToString()) ? _dr["age"].ToString() : String.Empty));
                _dataRecorded.Add("DegreeLevelNameTH", (_dr != null && !String.IsNullOrEmpty(_dr["degreeLevelNameTH"].ToString()) ? _dr["degreeLevelNameTH"].ToString() : String.Empty));
                _dataRecorded.Add("DegreeLevelNameEN", (_dr != null && !String.IsNullOrEmpty(_dr["degreeLevelNameEN"].ToString()) ? _dr["degreeLevelNameEN"].ToString() : String.Empty));
                _dataRecorded.Add("FacultyCode", (_dr != null && !String.IsNullOrEmpty(_dr["facultyCode"].ToString()) ? _dr["facultyCode"].ToString() : String.Empty));
                _dataRecorded.Add("FacultyNameTH", (_dr != null && !String.IsNullOrEmpty(_dr["facultyNameTH"].ToString()) ? _dr["facultyNameTH"].ToString() : String.Empty));
                _dataRecorded.Add("FacultyNameEN", (_dr != null && !String.IsNullOrEmpty(_dr["facultyNameEN"].ToString()) ? _dr["facultyNameEN"].ToString() : String.Empty));
                _dataRecorded.Add("ProgramCode", (_dr != null && !String.IsNullOrEmpty(_dr["programCode"].ToString()) ? _dr["programCode"].ToString() : String.Empty));
                _dataRecorded.Add("ProgramNameTH", (_dr != null && !String.IsNullOrEmpty(_dr["programNameTH"].ToString()) ? _dr["programNameTH"].ToString() : String.Empty));
                _dataRecorded.Add("ProgramNameEN", (_dr != null && !String.IsNullOrEmpty(_dr["programNameEN"].ToString()) ? _dr["programNameEN"].ToString() : String.Empty));
                _dataRecorded.Add("YearEntry", (_dr != null && !String.IsNullOrEmpty(_dr["yearEntry"].ToString()) ? _dr["yearEntry"].ToString() : String.Empty));
                _dataRecorded.Add("Class", (_dr != null && !String.IsNullOrEmpty(_dr["class"].ToString()) ? _dr["class"].ToString() : String.Empty));
                _dataRecorded.Add("ProgramAddress", (_dr != null && !String.IsNullOrEmpty(_dr["programAddress"].ToString()) ? _dr["programAddress"].ToString() : String.Empty));
                _dataRecorded.Add("ProgramTelephone", (_dr != null && !String.IsNullOrEmpty(_dr["programTelephone"].ToString()) ? _dr["programTelephone"].ToString() : String.Empty));
                _dataRecorded.Add("Hospital", (_dr != null && !String.IsNullOrEmpty(_dr["hcsHospitalId"].ToString()) ? _dr["hcsHospitalId"].ToString() : String.Empty));
                _dataRecorded.Add("HospitalNameTH", (_dr != null && !String.IsNullOrEmpty(_dr["hospitalNameTH"].ToString()) ? _dr["hospitalNameTH"].ToString() : String.Empty));
                _dataRecorded.Add("HospitalNameEN", (_dr != null && !String.IsNullOrEmpty(_dr["hospitalNameEN"].ToString()) ? _dr["hospitalNameEN"].ToString() : String.Empty));
                _dataRecorded.Add("NationalityNameTH", (_dr != null && !String.IsNullOrEmpty(_dr["nationalityNameTH"].ToString()) ? _dr["nationalityNameTH"].ToString() : String.Empty));
                _dataRecorded.Add("NationalityNameEN", (_dr != null && !String.IsNullOrEmpty(_dr["nationalityNameEN"].ToString()) ? _dr["nationalityNameEN"].ToString() : String.Empty));            
                _dataRecorded.Add("OriginNameTH", (_dr != null && !String.IsNullOrEmpty(_dr["originNameTH"].ToString()) ? _dr["originNameTH"].ToString() : String.Empty));            
                _dataRecorded.Add("OriginNameEN", (_dr != null && !String.IsNullOrEmpty(_dr["originNameEN"].ToString()) ? _dr["originNameEN"].ToString() : String.Empty));            
                _dataRecorded.Add("ReligionNameTH", (_dr != null && !String.IsNullOrEmpty(_dr["religionNameTH"].ToString()) ? _dr["religionNameTH"].ToString() : String.Empty));
                _dataRecorded.Add("ReligionNameEN", (_dr != null && !String.IsNullOrEmpty(_dr["religionNameEN"].ToString()) ? _dr["religionNameEN"].ToString() : String.Empty));
                _dataRecorded.Add("BloodTypeNameTH", (_dr != null && !String.IsNullOrEmpty(_dr["bloodTypeNameTH"].ToString()) ? _dr["bloodTypeNameTH"].ToString() : String.Empty));
                _dataRecorded.Add("BloodTypeNameEN", (_dr != null && !String.IsNullOrEmpty(_dr["bloodTypeNameEN"].ToString()) ? _dr["bloodTypeNameEN"].ToString() : String.Empty));
                _dataRecorded.Add("MaritalStatusNameTH", (_dr != null && !String.IsNullOrEmpty(_dr["maritalStatusNameTH"].ToString()) ? _dr["maritalStatusNameTH"].ToString() : String.Empty));
                _dataRecorded.Add("MaritalStatusNameEN", (_dr != null && !String.IsNullOrEmpty(_dr["maritalStatusNameEN"].ToString()) ? _dr["maritalStatusNameEN"].ToString() : String.Empty));
                _dataRecorded.Add("EducationalBackgroundNameTH", (_dr != null && !String.IsNullOrEmpty(_dr["educationalBackgroundNameTH"].ToString()) ? _dr["educationalBackgroundNameTH"].ToString() : String.Empty));
                _dataRecorded.Add("EducationalBackgroundNameEN", (_dr != null && !String.IsNullOrEmpty(_dr["educationalBackgroundNameEN"].ToString()) ? _dr["educationalBackgroundNameEN"].ToString() : String.Empty));
                _dataRecorded.Add("Email", (_dr != null && !String.IsNullOrEmpty(_dr["email"].ToString()) ? _dr["email"].ToString() : String.Empty));
                _dataRecorded.Add("CountryNameTHPermanentAddress", (_dr != null && !String.IsNullOrEmpty(_dr["countryNameTHPermanent"].ToString()) ? _dr["countryNameTHPermanent"].ToString() : String.Empty));
                _dataRecorded.Add("CountryNameENPermanentAddress", (_dr != null && !String.IsNullOrEmpty(_dr["countryNameENPermanent"].ToString()) ? _dr["countryNameENPermanent"].ToString() : String.Empty));
                _dataRecorded.Add("ProvinceNameTHPermanentAddress", (_dr != null && !String.IsNullOrEmpty(_dr["provinceNameTHPermanent"].ToString()) ? _dr["provinceNameTHPermanent"].ToString() : String.Empty));
                _dataRecorded.Add("ProvinceNameENPermanentAddress", (_dr != null && !String.IsNullOrEmpty(_dr["provinceNameENPermanent"].ToString()) ? _dr["provinceNameENPermanent"].ToString() : String.Empty));
                _dataRecorded.Add("DistrictNameTHPermanentAddress", (_dr != null && !String.IsNullOrEmpty(_dr["districtNameTHPermanent"].ToString()) ? _dr["districtNameTHPermanent"].ToString() : String.Empty));
                _dataRecorded.Add("DistrictNameENPermanentAddress", (_dr != null && !String.IsNullOrEmpty(_dr["districtNameENPermanent"].ToString()) ? _dr["districtNameENPermanent"].ToString() : String.Empty));
                _dataRecorded.Add("SubDistrictNameTHPermanentAddress", (_dr != null && !String.IsNullOrEmpty(_dr["subdistrictNameTHPermanent"].ToString()) ? _dr["subdistrictNameTHPermanent"].ToString() : String.Empty));
                _dataRecorded.Add("SubDistrictNameENPermanentAddress", (_dr != null && !String.IsNullOrEmpty(_dr["subdistrictNameENPermanent"].ToString()) ? _dr["subdistrictNameENPermanent"].ToString() : String.Empty));
                _dataRecorded.Add("PostalCodePermanentAddress", (_dr != null && !String.IsNullOrEmpty(_dr["zipCodePermanent"].ToString()) ? _dr["zipCodePermanent"].ToString() : String.Empty));
                _dataRecorded.Add("VillagePermanentAddress", (_dr != null && !String.IsNullOrEmpty(_dr["villagePermanent"].ToString()) ? _dr["villagePermanent"].ToString() : String.Empty));
                _dataRecorded.Add("HouseNoPermanentAddress", (_dr != null && !String.IsNullOrEmpty(_dr["noPermanent"].ToString()) ? _dr["noPermanent"].ToString() : String.Empty));
                _dataRecorded.Add("VillageNoPermanentAddress", (_dr != null && !String.IsNullOrEmpty(_dr["mooPermanent"].ToString()) ? _dr["mooPermanent"].ToString() : String.Empty));
                _dataRecorded.Add("LaneAlleyPermanentAddress", (_dr != null && !String.IsNullOrEmpty(_dr["soiPermanent"].ToString()) ? _dr["soiPermanent"].ToString() : String.Empty));
                _dataRecorded.Add("RoadPermanentAddress", (_dr != null && !String.IsNullOrEmpty(_dr["roadPermanent"].ToString()) ? _dr["roadPermanent"].ToString() : String.Empty));
                _dataRecorded.Add("PhoneNumberPermanentAddress", (_dr != null && !String.IsNullOrEmpty(_dr["phoneNumberPermanent"].ToString()) ? _dr["phoneNumberPermanent"].ToString() : String.Empty));
                _dataRecorded.Add("MobileNumberPermanentAddress", (_dr != null && !String.IsNullOrEmpty(_dr["mobileNumberPermanent"].ToString()) ? _dr["mobileNumberPermanent"].ToString() : String.Empty));
                _dataRecorded.Add("FaxNumberPermanentAddress", (_dr != null && !String.IsNullOrEmpty(_dr["faxNumberPermanent"].ToString()) ? _dr["faxNumberPermanent"].ToString() : String.Empty));
                _dataRecorded.Add("CountryNameTHCurrentAddress", (_dr != null && !String.IsNullOrEmpty(_dr["countryNameTHCurrent"].ToString()) ? _dr["countryNameTHCurrent"].ToString() : String.Empty));
                _dataRecorded.Add("CountryNameENCurrentAddress", (_dr != null && !String.IsNullOrEmpty(_dr["countryNameENCurrent"].ToString()) ? _dr["countryNameENCurrent"].ToString() : String.Empty));
                _dataRecorded.Add("ProvinceNameTHCurrentAddress", (_dr != null && !String.IsNullOrEmpty(_dr["provinceNameTHCurrent"].ToString()) ? _dr["provinceNameTHCurrent"].ToString() : String.Empty));
                _dataRecorded.Add("ProvinceNameENCurrentAddress", (_dr != null && !String.IsNullOrEmpty(_dr["provinceNameENCurrent"].ToString()) ? _dr["provinceNameENCurrent"].ToString() : String.Empty));
                _dataRecorded.Add("DistrictNameTHCurrentAddress", (_dr != null && !String.IsNullOrEmpty(_dr["districtNameTHCurrent"].ToString()) ? _dr["districtNameTHCurrent"].ToString() : String.Empty));
                _dataRecorded.Add("DistrictNameENCurrentAddress", (_dr != null && !String.IsNullOrEmpty(_dr["districtNameENCurrent"].ToString()) ? _dr["districtNameENCurrent"].ToString() : String.Empty));
                _dataRecorded.Add("SubDistrictNameTHCurrentAddress", (_dr != null && !String.IsNullOrEmpty(_dr["subdistrictNameTHCurrent"].ToString()) ? _dr["subdistrictNameTHCurrent"].ToString() : String.Empty));
                _dataRecorded.Add("SubDistrictNameENCurrentAddress", (_dr != null && !String.IsNullOrEmpty(_dr["subdistrictNameENCurrent"].ToString()) ? _dr["subdistrictNameENCurrent"].ToString() : String.Empty));
                _dataRecorded.Add("PostalCodeCurrentAddress", (_dr != null && !String.IsNullOrEmpty(_dr["zipCodeCurrent"].ToString()) ? _dr["zipCodeCurrent"].ToString() : String.Empty));
                _dataRecorded.Add("VillageCurrentAddress", (_dr != null && !String.IsNullOrEmpty(_dr["villageCurrent"].ToString()) ? _dr["villageCurrent"].ToString() : String.Empty));
                _dataRecorded.Add("HouseNoCurrentAddress", (_dr != null && !String.IsNullOrEmpty(_dr["noCurrent"].ToString()) ? _dr["noCurrent"].ToString() : String.Empty));
                _dataRecorded.Add("VillageNoCurrentAddress", (_dr != null && !String.IsNullOrEmpty(_dr["mooCurrent"].ToString()) ? _dr["mooCurrent"].ToString() : String.Empty));
                _dataRecorded.Add("LaneAlleyCurrentAddress", (_dr != null && !String.IsNullOrEmpty(_dr["soiCurrent"].ToString()) ? _dr["soiCurrent"].ToString() : String.Empty));
                _dataRecorded.Add("RoadCurrentAddress", (_dr != null && !String.IsNullOrEmpty(_dr["roadCurrent"].ToString()) ? _dr["roadCurrent"].ToString() : String.Empty));
                _dataRecorded.Add("PhoneNumberCurrentAddress", (_dr != null && !String.IsNullOrEmpty(_dr["phoneNumberCurrent"].ToString()) ? _dr["phoneNumberCurrent"].ToString() : String.Empty));
                _dataRecorded.Add("MobileNumberCurrentAddress", (_dr != null && !String.IsNullOrEmpty(_dr["mobileNumberCurrent"].ToString()) ? _dr["mobileNumberCurrent"].ToString() : String.Empty));
                _dataRecorded.Add("FaxNumberCurrentAddress", (_dr != null && !String.IsNullOrEmpty(_dr["faxNumberCurrent"].ToString()) ? _dr["faxNumberCurrent"].ToString() : String.Empty));
                _dataRecorded.Add("BodyMassDetail", (_dr != null && !String.IsNullOrEmpty(_dr["bodyMassDetail"].ToString()) ? _dr["bodyMassDetail"].ToString() : String.Empty));
                _dataRecorded.Add("IntoleranceStatus", (_dr != null && !String.IsNullOrEmpty(_dr["intolerance"].ToString()) ? _dr["intolerance"].ToString() : String.Empty));
                _dataRecorded.Add("IntoleranceDetail", (_dr != null && !String.IsNullOrEmpty(_dr["intoleranceDetail"].ToString()) ? _dr["intoleranceDetail"].ToString() : String.Empty));
                _dataRecorded.Add("DiseasesStatus", (_dr != null && !String.IsNullOrEmpty(_dr["diseases"].ToString()) ? _dr["diseases"].ToString() : String.Empty));
                _dataRecorded.Add("DiseasesDetail", (_dr != null && !String.IsNullOrEmpty(_dr["diseasesDetail"].ToString()) ? _dr["diseasesDetail"].ToString() : String.Empty));
                _dataRecorded.Add("AilHistoryFamilyStatus", (_dr != null && !String.IsNullOrEmpty(_dr["ailHistoryFamily"].ToString()) ? _dr["ailHistoryFamily"].ToString() : String.Empty));
                _dataRecorded.Add("AilHistoryFamilyDetail", (_dr != null && !String.IsNullOrEmpty(_dr["ailHistoryFamilyDetail"].ToString()) ? _dr["ailHistoryFamilyDetail"].ToString() : String.Empty));
                _dataRecorded.Add("TravelAbroadStatus", (_dr != null && !String.IsNullOrEmpty(_dr["travelAbroad"].ToString()) ? _dr["travelAbroad"].ToString() : String.Empty));
                _dataRecorded.Add("TravelAbroadDetail", (_dr != null && !String.IsNullOrEmpty(_dr["travelAbroadDetail"].ToString()) ? _dr["travelAbroadDetail"].ToString() : String.Empty));
                _dataRecorded.Add("ImpairmentsStatus", (_dr != null && !String.IsNullOrEmpty(_dr["impairments"].ToString()) ? _dr["impairments"].ToString() : String.Empty));
                _dataRecorded.Add("ImpairmentsDetail", (_dr != null && !String.IsNullOrEmpty(_dr["perImpairmentsId"].ToString()) ? _dr["perImpairmentsId"].ToString() : String.Empty));
                _dataRecorded.Add("ImpairmentsNameTH", (_dr != null && !String.IsNullOrEmpty(_dr["impairmentsNameTH"].ToString()) ? _dr["impairmentsNameTH"].ToString() : String.Empty));
                _dataRecorded.Add("ImpairmentsNameEN", (_dr != null && !String.IsNullOrEmpty(_dr["impairmentsNameEN"].ToString()) ? _dr["impairmentsNameEN"].ToString() : String.Empty));
                _dataRecorded.Add("ImpairmentsEquipment", (_dr != null && !String.IsNullOrEmpty(_dr["impairmentsEquipment"].ToString()) ? _dr["impairmentsEquipment"].ToString() : String.Empty));
                _dataRecorded.Add("WorkedStatus", (_dr != null && !String.IsNullOrEmpty(_dr["workedStatus"].ToString()) ? _dr["workedStatus"].ToString() : "N"));
                _dataRecorded.Add("WorkedStatusNameTH", (_dr != null && !String.IsNullOrEmpty(_dr["workedStatusNameTH"].ToString()) ? _dr["workedStatusNameTH"].ToString() : "ไม่ทำ"));
                _dataRecorded.Add("WorkedStatusNameEN", (_dr != null && !String.IsNullOrEmpty(_dr["workedStatusNameEN"].ToString()) ? _dr["workedStatusNameEN"].ToString() : "Not Work"));
                _dataRecorded.Add("TitleInitialsTHFather", (_dr != null && !String.IsNullOrEmpty(_dr["titlePrefixInitialsTHFather"].ToString()) ? _dr["titlePrefixInitialsTHFather"].ToString() : String.Empty));
                _dataRecorded.Add("TitleInitialsENFather", (_dr != null && !String.IsNullOrEmpty(_dr["titlePrefixInitialsENFather"].ToString()) ? _dr["titlePrefixInitialsENFather"].ToString() : String.Empty));
                _dataRecorded.Add("TitleFullNameTHFather", (_dr != null && !String.IsNullOrEmpty(_dr["titlePrefixFullNameTHFather"].ToString()) ? _dr["titlePrefixFullNameTHFather"].ToString() : String.Empty));
                _dataRecorded.Add("TitleFullNameENFather", (_dr != null && !String.IsNullOrEmpty(_dr["titlePrefixFullNameENFather"].ToString()) ? _dr["titlePrefixFullNameENFather"].ToString() : String.Empty));
                _dataRecorded.Add("FirstNameFather", (_dr != null && !String.IsNullOrEmpty(_dr["firstNameFather"].ToString()) ? _dr["firstNameFather"].ToString() : String.Empty));
                _dataRecorded.Add("MiddleNameFather", (_dr != null && !String.IsNullOrEmpty(_dr["middleNameFather"].ToString()) ? _dr["middleNameFather"].ToString() : String.Empty));
                _dataRecorded.Add("LastNameFather", (_dr != null && !String.IsNullOrEmpty(_dr["lastNameFather"].ToString()) ? _dr["lastNameFather"].ToString() : String.Empty));
                _dataRecorded.Add("FirstNameENFather", (_dr != null && !String.IsNullOrEmpty(_dr["firstNameENFather"].ToString()) ? _dr["firstNameENFather"].ToString() : String.Empty));
                _dataRecorded.Add("MiddleNameENFather", (_dr != null && !String.IsNullOrEmpty(_dr["middleNameENFather"].ToString()) ? _dr["middleNameENFather"].ToString() : String.Empty));
                _dataRecorded.Add("LastNameENFather", (_dr != null && !String.IsNullOrEmpty(_dr["lastNameENFather"].ToString()) ? _dr["lastNameENFather"].ToString() : String.Empty));
                _dataRecorded.Add("AliveFather", (_dr != null && !String.IsNullOrEmpty(_dr["aliveFather"].ToString()) ? _dr["aliveFather"].ToString() : String.Empty));
                _dataRecorded.Add("EmailFather", (_dr != null && !String.IsNullOrEmpty(_dr["emailFather"].ToString()) ? _dr["emailFather"].ToString() : String.Empty));
                _dataRecorded.Add("MobileNumberCurrentAddressFather", (_dr != null && !String.IsNullOrEmpty(_dr["mobileNumberCurrentFather"].ToString()) ? _dr["mobileNumberCurrentFather"].ToString() : String.Empty));
                _dataRecorded.Add("TitleInitialsTHMother", (_dr != null && !String.IsNullOrEmpty(_dr["titlePrefixInitialsTHMother"].ToString()) ? _dr["titlePrefixInitialsTHMother"].ToString() : String.Empty));
                _dataRecorded.Add("TitleInitialsENMother", (_dr != null && !String.IsNullOrEmpty(_dr["titlePrefixInitialsENMother"].ToString()) ? _dr["titlePrefixInitialsENMother"].ToString() : String.Empty));
                _dataRecorded.Add("TitleFullNameTHMother", (_dr != null && !String.IsNullOrEmpty(_dr["titlePrefixFullNameTHMother"].ToString()) ? _dr["titlePrefixFullNameTHMother"].ToString() : String.Empty));
                _dataRecorded.Add("TitleFullNameENMother", (_dr != null && !String.IsNullOrEmpty(_dr["titlePrefixFullNameENMother"].ToString()) ? _dr["titlePrefixFullNameENMother"].ToString() : String.Empty));
                _dataRecorded.Add("FirstNameMother", (_dr != null && !String.IsNullOrEmpty(_dr["firstNameMother"].ToString()) ? _dr["firstNameMother"].ToString() : String.Empty));
                _dataRecorded.Add("MiddleNameMother", (_dr != null && !String.IsNullOrEmpty(_dr["middleNameMother"].ToString()) ? _dr["middleNameMother"].ToString() : String.Empty));
                _dataRecorded.Add("LastNameMother", (_dr != null && !String.IsNullOrEmpty(_dr["lastNameMother"].ToString()) ? _dr["lastNameMother"].ToString() : String.Empty));
                _dataRecorded.Add("FirstNameENMother", (_dr != null && !String.IsNullOrEmpty(_dr["firstNameENMother"].ToString()) ? _dr["firstNameENMother"].ToString() : String.Empty));
                _dataRecorded.Add("MiddleNameENMother", (_dr != null && !String.IsNullOrEmpty(_dr["middleNameENMother"].ToString()) ? _dr["middleNameENMother"].ToString() : String.Empty));
                _dataRecorded.Add("LastNameENMother", (_dr != null && !String.IsNullOrEmpty(_dr["lastNameENMother"].ToString()) ? _dr["lastNameENMother"].ToString() : String.Empty));
                _dataRecorded.Add("AliveMother", (_dr != null && !String.IsNullOrEmpty(_dr["aliveMother"].ToString()) ? _dr["aliveMother"].ToString() : String.Empty));
                _dataRecorded.Add("EmailMother", (_dr != null && !String.IsNullOrEmpty(_dr["emailMother"].ToString()) ? _dr["emailMother"].ToString() : String.Empty));
                _dataRecorded.Add("MobileNumberCurrentAddressMother", (_dr != null && !String.IsNullOrEmpty(_dr["mobileNumberCurrentMother"].ToString()) ? _dr["mobileNumberCurrentMother"].ToString() : String.Empty));
                _dataRecorded.Add("RelationshipNameTH", (_dr != null && !String.IsNullOrEmpty(_dr["relationshipNameTH"].ToString()) ? _dr["relationshipNameTH"].ToString() : String.Empty));
                _dataRecorded.Add("RelationshipNameEN", (_dr != null && !String.IsNullOrEmpty(_dr["relationshipNameEN"].ToString()) ? _dr["relationshipNameEN"].ToString() : String.Empty));            
                _dataRecorded.Add("TitleInitialsTHParent", (_dr != null && !String.IsNullOrEmpty(_dr["titlePrefixInitialsTHParent"].ToString()) ? _dr["titlePrefixInitialsTHParent"].ToString() : String.Empty));
                _dataRecorded.Add("TitleInitialsENParent", (_dr != null && !String.IsNullOrEmpty(_dr["titlePrefixInitialsENParent"].ToString()) ? _dr["titlePrefixInitialsENParent"].ToString() : String.Empty));
                _dataRecorded.Add("TitleFullNameTHParent", (_dr != null && !String.IsNullOrEmpty(_dr["titlePrefixFullNameTHParent"].ToString()) ? _dr["titlePrefixFullNameTHParent"].ToString() : String.Empty));
                _dataRecorded.Add("TitleFullNameENParent", (_dr != null && !String.IsNullOrEmpty(_dr["titlePrefixFullNameENParent"].ToString()) ? _dr["titlePrefixFullNameENParent"].ToString() : String.Empty));
                _dataRecorded.Add("FirstNameParent", (_dr != null && !String.IsNullOrEmpty(_dr["firstNameParent"].ToString()) ? _dr["firstNameParent"].ToString() : String.Empty));
                _dataRecorded.Add("MiddleNameParent", (_dr != null && !String.IsNullOrEmpty(_dr["middleNameParent"].ToString()) ? _dr["middleNameParent"].ToString() : String.Empty));
                _dataRecorded.Add("LastNameParent", (_dr != null && !String.IsNullOrEmpty(_dr["lastNameParent"].ToString()) ? _dr["lastNameParent"].ToString() : String.Empty));
                _dataRecorded.Add("FirstNameENParent", (_dr != null && !String.IsNullOrEmpty(_dr["firstNameENParent"].ToString()) ? _dr["firstNameENParent"].ToString() : String.Empty));
                _dataRecorded.Add("MiddleNameENParent", (_dr != null && !String.IsNullOrEmpty(_dr["middleNameENParent"].ToString()) ? _dr["middleNameENParent"].ToString() : String.Empty));
                _dataRecorded.Add("LastNameENParent", (_dr != null && !String.IsNullOrEmpty(_dr["lastNameENParent"].ToString()) ? _dr["lastNameENParent"].ToString() : String.Empty));
                _dataRecorded.Add("EmailParent", (_dr != null && !String.IsNullOrEmpty(_dr["emailParent"].ToString()) ? _dr["emailParent"].ToString() : String.Empty));
                _dataRecorded.Add("CountryNameTHCurrentAddressParent", (_dr != null && !String.IsNullOrEmpty(_dr["countryNameTHCurrentParent"].ToString()) ? _dr["countryNameTHCurrentParent"].ToString() : String.Empty));
                _dataRecorded.Add("CountryNameENCurrentAddressParent", (_dr != null && !String.IsNullOrEmpty(_dr["countryNameENCurrentParent"].ToString()) ? _dr["countryNameENCurrentParent"].ToString() : String.Empty));
                _dataRecorded.Add("ProvinceNameTHCurrentAddressParent", (_dr != null && !String.IsNullOrEmpty(_dr["provinceNameTHCurrentParent"].ToString()) ? _dr["provinceNameTHCurrentParent"].ToString() : String.Empty));
                _dataRecorded.Add("ProvinceNameENCurrentAddressParent", (_dr != null && !String.IsNullOrEmpty(_dr["provinceNameENCurrentParent"].ToString()) ? _dr["provinceNameENCurrentParent"].ToString() : String.Empty));
                _dataRecorded.Add("DistrictNameTHCurrentAddressParent", (_dr != null && !String.IsNullOrEmpty(_dr["districtNameTHCurrentParent"].ToString()) ? _dr["districtNameTHCurrentParent"].ToString() : String.Empty));
                _dataRecorded.Add("DistrictNameENCurrentAddressParent", (_dr != null && !String.IsNullOrEmpty(_dr["districtNameENCurrentParent"].ToString()) ? _dr["districtNameENCurrentParent"].ToString() : String.Empty));
                _dataRecorded.Add("SubDistrictNameTHCurrentAddressParent", (_dr != null && !String.IsNullOrEmpty(_dr["subdistrictNameTHCurrentParent"].ToString()) ? _dr["subdistrictNameTHCurrentParent"].ToString() : String.Empty));
                _dataRecorded.Add("SubDistrictNameENCurrentAddressParent", (_dr != null && !String.IsNullOrEmpty(_dr["subdistrictNameENCurrentParent"].ToString()) ? _dr["subdistrictNameENCurrentParent"].ToString() : String.Empty));
                _dataRecorded.Add("PostalCodeCurrentAddressParent", (_dr != null && !String.IsNullOrEmpty(_dr["zipCodeCurrentParent"].ToString()) ? _dr["zipCodeCurrentParent"].ToString() : String.Empty));
                _dataRecorded.Add("VillageCurrentAddressParent", (_dr != null && !String.IsNullOrEmpty(_dr["villageCurrentParent"].ToString()) ? _dr["villageCurrentParent"].ToString() : String.Empty));
                _dataRecorded.Add("HouseNoCurrentAddressParent", (_dr != null && !String.IsNullOrEmpty(_dr["noCurrentParent"].ToString()) ? _dr["noCurrentParent"].ToString() : String.Empty));
                _dataRecorded.Add("VillageNoCurrentAddressParent", (_dr != null && !String.IsNullOrEmpty(_dr["mooCurrentParent"].ToString()) ? _dr["mooCurrentParent"].ToString() : String.Empty));
                _dataRecorded.Add("LaneAlleyCurrentAddressParent", (_dr != null && !String.IsNullOrEmpty(_dr["soiCurrentParent"].ToString()) ? _dr["soiCurrentParent"].ToString() : String.Empty));
                _dataRecorded.Add("RoadCurrentAddressParent", (_dr != null && !String.IsNullOrEmpty(_dr["roadCurrentParent"].ToString()) ? _dr["roadCurrentParent"].ToString() : String.Empty));
                _dataRecorded.Add("PhoneNumberCurrentAddressParent", (_dr != null && !String.IsNullOrEmpty(_dr["phoneNumberCurrentParent"].ToString()) ? _dr["phoneNumberCurrentParent"].ToString() : String.Empty));
                _dataRecorded.Add("MobileNumberCurrentAddressParent", (_dr != null && !String.IsNullOrEmpty(_dr["mobileNumberCurrentParent"].ToString()) ? _dr["mobileNumberCurrentParent"].ToString() : String.Empty));
                _dataRecorded.Add("FaxNumberCurrentAddressParent", (_dr != null && !String.IsNullOrEmpty(_dr["faxNumberCurrentParent"].ToString()) ? _dr["faxNumberCurrentParent"].ToString() : String.Empty));
                _dataRecorded.Add("OccupationFather", (_dr != null && !String.IsNullOrEmpty(_dr["occupationFather"].ToString()) ? _dr["occupationFather"].ToString() : String.Empty));
                _dataRecorded.Add("OccupationNameTHFather", (_dr != null && !String.IsNullOrEmpty(_dr["occupationNameTHFather"].ToString()) ? _dr["occupationNameTHFather"].ToString() : String.Empty));
                _dataRecorded.Add("OccupationNameENFather", (_dr != null && !String.IsNullOrEmpty(_dr["occupationNameENFather"].ToString()) ? _dr["occupationNameENFather"].ToString() : String.Empty));
                _dataRecorded.Add("OccupationMother", (_dr != null && !String.IsNullOrEmpty(_dr["occupationMother"].ToString()) ? _dr["occupationMother"].ToString() : String.Empty));
                _dataRecorded.Add("OccupationNameTHMother", (_dr != null && !String.IsNullOrEmpty(_dr["occupationNameTHMother"].ToString()) ? _dr["occupationNameTHMother"].ToString() : String.Empty));
                _dataRecorded.Add("OccupationNameENMother", (_dr != null && !String.IsNullOrEmpty(_dr["occupationNameENMother"].ToString()) ? _dr["occupationNameENMother"].ToString() : String.Empty));            
                _dataRecorded.Add("OccupationParent", (_dr != null && !String.IsNullOrEmpty(_dr["occupationParent"].ToString()) ? _dr["occupationParent"].ToString() : String.Empty));
                _dataRecorded.Add("OccupationNameTHParent", (_dr != null && !String.IsNullOrEmpty(_dr["occupationNameTHParent"].ToString()) ? _dr["occupationNameTHParent"].ToString() : String.Empty));
                _dataRecorded.Add("OccupationNameENParent", (_dr != null && !String.IsNullOrEmpty(_dr["occupationNameENParent"].ToString()) ? _dr["occupationNameENParent"].ToString() : String.Empty));
                _dataRecorded.Add("StudentRecordsPersonalStatus", (_dr != null && !String.IsNullOrEmpty(_dr["studentRecordsPersonalStatus"].ToString()) ? _dr["studentRecordsPersonalStatus"].ToString() : String.Empty));
                _dataRecorded.Add("StudentRecordsAddressPermanentStatus", (_dr != null && !String.IsNullOrEmpty(_dr["studentRecordsAddressPermanentStatus"].ToString()) ? _dr["studentRecordsAddressPermanentStatus"].ToString() : String.Empty));
                _dataRecorded.Add("StudentRecordsAddressCurrentStatus", (_dr != null && !String.IsNullOrEmpty(_dr["studentRecordsAddressCurrentStatus"].ToString()) ? _dr["studentRecordsAddressCurrentStatus"].ToString() : String.Empty));
                _dataRecorded.Add("StudentRecordsEducationPrimarySchoolStatus", (_dr != null && !String.IsNullOrEmpty(_dr["studentRecordsEducationPrimarySchoolStatus"].ToString()) ? _dr["studentRecordsEducationPrimarySchoolStatus"].ToString() : String.Empty));
                _dataRecorded.Add("StudentRecordsEducationJuniorHighSchoolStatus", (_dr != null && !String.IsNullOrEmpty(_dr["studentRecordsEducationJuniorHighSchoolStatus"].ToString()) ? _dr["studentRecordsEducationJuniorHighSchoolStatus"].ToString() : String.Empty));
                _dataRecorded.Add("StudentRecordsEducationHighSchoolStatus", (_dr != null && !String.IsNullOrEmpty(_dr["studentRecordsEducationHighSchoolStatus"].ToString()) ? _dr["studentRecordsEducationHighSchoolStatus"].ToString() : String.Empty));
                _dataRecorded.Add("StudentRecordsEducationUniversityStatus", (_dr != null && !String.IsNullOrEmpty(_dr["studentRecordsEducationUniversityStatus"].ToString()) ? _dr["studentRecordsEducationUniversityStatus"].ToString() : String.Empty));
                _dataRecorded.Add("StudentRecordsEducationAdmissionScoresStatus", (_dr != null && !String.IsNullOrEmpty(_dr["studentRecordsEducationAdmissionScoresStatus"].ToString()) ? _dr["studentRecordsEducationAdmissionScoresStatus"].ToString() : String.Empty));
                _dataRecorded.Add("StudentRecordsTalentStatus", (_dr != null && !String.IsNullOrEmpty(_dr["studentRecordsTalentStatus"].ToString()) ? _dr["studentRecordsTalentStatus"].ToString() : String.Empty));
                _dataRecorded.Add("StudentRecordsHealthyStatus", (_dr != null && !String.IsNullOrEmpty(_dr["studentRecordsHealthyStatus"].ToString()) ? _dr["studentRecordsHealthyStatus"].ToString() : String.Empty));
                _dataRecorded.Add("StudentRecordsWorkStatus", (_dr != null && !String.IsNullOrEmpty(_dr["studentRecordsWorkStatus"].ToString()) ? _dr["studentRecordsWorkStatus"].ToString() : String.Empty));
                _dataRecorded.Add("StudentRecordsFinancialStatus", (_dr != null && !String.IsNullOrEmpty(_dr["studentRecordsFinancialStatus"].ToString()) ? _dr["studentRecordsFinancialStatus"].ToString() : String.Empty));
                _dataRecorded.Add("StudentRecordsFamilyFatherPersonalStatus", (_dr != null && !String.IsNullOrEmpty(_dr["studentRecordsFamilyFatherPersonalStatus"].ToString()) ? _dr["studentRecordsFamilyFatherPersonalStatus"].ToString() : String.Empty));
                _dataRecorded.Add("StudentRecordsFamilyMotherPersonalStatus", (_dr != null && !String.IsNullOrEmpty(_dr["studentRecordsFamilyMotherPersonalStatus"].ToString()) ? _dr["studentRecordsFamilyMotherPersonalStatus"].ToString() : String.Empty));
                _dataRecorded.Add("StudentRecordsFamilyParentPersonalStatus", (_dr != null && !String.IsNullOrEmpty(_dr["studentRecordsFamilyParentPersonalStatus"].ToString()) ? _dr["studentRecordsFamilyParentPersonalStatus"].ToString() : String.Empty));
                _dataRecorded.Add("StudentRecordsFamilyFatherAddressPermanentStatus", (_dr != null && !String.IsNullOrEmpty(_dr["studentRecordsFamilyFatherAddressPermanentStatus"].ToString()) ? _dr["studentRecordsFamilyFatherAddressPermanentStatus"].ToString() : String.Empty));
                _dataRecorded.Add("StudentRecordsFamilyMotherAddressPermanentStatus", (_dr != null && !String.IsNullOrEmpty(_dr["studentRecordsFamilyMotherAddressPermanentStatus"].ToString()) ? _dr["studentRecordsFamilyMotherAddressPermanentStatus"].ToString() : String.Empty));
                _dataRecorded.Add("StudentRecordsFamilyParentAddressPermanentStatus", (_dr != null && !String.IsNullOrEmpty(_dr["studentRecordsFamilyParentAddressPermanentStatus"].ToString()) ? _dr["studentRecordsFamilyParentAddressPermanentStatus"].ToString() : String.Empty));
                _dataRecorded.Add("StudentRecordsFamilyFatherAddressCurrentStatus", (_dr != null && !String.IsNullOrEmpty(_dr["studentRecordsFamilyFatherAddressCurrentStatus"].ToString()) ? _dr["studentRecordsFamilyFatherAddressCurrentStatus"].ToString() : String.Empty));
                _dataRecorded.Add("StudentRecordsFamilyMotherAddressCurrentStatus", (_dr != null && !String.IsNullOrEmpty(_dr["studentRecordsFamilyMotherAddressCurrentStatus"].ToString()) ? _dr["studentRecordsFamilyMotherAddressCurrentStatus"].ToString() : String.Empty));
                _dataRecorded.Add("StudentRecordsFamilyParentAddressCurrentStatus", (_dr != null && !String.IsNullOrEmpty(_dr["studentRecordsFamilyParentAddressCurrentStatus"].ToString()) ? _dr["studentRecordsFamilyParentAddressCurrentStatus"].ToString() : String.Empty));
                _dataRecorded.Add("StudentRecordsFamilyFatherWorkStatus", (_dr != null && !String.IsNullOrEmpty(_dr["studentRecordsFamilyFatherWorkStatus"].ToString()) ? _dr["studentRecordsFamilyFatherWorkStatus"].ToString() : String.Empty));
                _dataRecorded.Add("StudentRecordsFamilyMotherWorkStatus", (_dr != null && !String.IsNullOrEmpty(_dr["studentRecordsFamilyMotherWorkStatus"].ToString()) ? _dr["studentRecordsFamilyMotherWorkStatus"].ToString() : String.Empty));
                _dataRecorded.Add("StudentRecordsFamilyParentWorkStatus", (_dr != null && !String.IsNullOrEmpty(_dr["studentRecordsFamilyParentWorkStatus"].ToString()) ? _dr["studentRecordsFamilyParentWorkStatus"].ToString() : String.Empty));
                _dataRecorded.Add("Welfare", (_dr != null && !String.IsNullOrEmpty(_dr["hcsWelfareId"].ToString()) ? _dr["hcsWelfareId"].ToString() : String.Empty));
                _dataRecorded.Add("WelfareNameTH", (_dr != null && !String.IsNullOrEmpty(_dr["welfareNameTH"].ToString()) ? _dr["welfareNameTH"].ToString() : String.Empty));
                _dataRecorded.Add("WelfareNameEN", (_dr != null && !String.IsNullOrEmpty(_dr["welfareNameEN"].ToString()) ? _dr["welfareNameEN"].ToString() : String.Empty));
                _dataRecorded.Add("WelfareForPublicServant", (_dr != null && !String.IsNullOrEmpty(_dr["welfareForPublicServant"].ToString()) ? _dr["welfareForPublicServant"].ToString() : String.Empty));
            }            

            return _dataRecorded;
        }
    }
    
    public static Dictionary<string, object> GetDownload(HttpContext _c, Dictionary<string, object> _infoLogin)
    {
        Dictionary<string, object> _downloadResult = new Dictionary<string, object>();
        Dictionary<string, object> _paramSave = new Dictionary<string, object>();
        Dictionary<string, object> _dataRecorded = new Dictionary<string, object>();
        DataSet _ds = new DataSet();
        DataRow _dr;
        string _personId = _infoLogin["PersonId"].ToString();
        string _action = String.Empty;
        string _registrationForm = String.Empty;
        string _filePath = HttpContext.Current.Server.MapPath(HCSUtil._myFileDownloadPath + "\\");
        string _fileName = ((DateTime.Now).ToString("dd-MM-yyyy@HH-mm-ss", new CultureInfo("en-US")));        
        int _recordCount = 0;
        int _saveError = 0;        
        bool _download1 = false;
        bool _download2 = false;

        /*
        if (_c.Request["hospital"].Equals("RA"))
            _registrationForm = "RARegisForm";

        if (_c.Request["hospital"].Equals("SI"))
            _registrationForm = "SIRegisForm";

        _ds = HCSDB.GetRegistrationForm(_registrationForm);
        */

        _registrationForm = "NHSORegisForm";

        _ds = HCSDB.GetRegistrationForm(_registrationForm);

        if (_ds.Tables[0].Rows.Count > 0)
        {
            _dr = _ds.Tables[0].Rows[0];
            _download1 = (_dr["cancelledStatus"].Equals("N") ? true : false);
        }        

        _ds.Dispose();

        _ds = HCSDB.GetRegistrationForm("KN003Form");

        if (_ds.Tables[0].Rows.Count > 0)
        {
            _dr = _ds.Tables[0].Rows[0];
            _download2 = (_dr["cancelledStatus"].Equals("N") ? true : false);
        }
        
        _ds.Dispose();

        _paramSave.Clear();
        _paramSave.Add("PersonId", _personId);
        _paramSave.Add("RegistrationForm", "");
        _paramSave.Add("By", Util.UppercaseFirst(FinServiceLogin.USERTYPE_STUDENT));

        if (_saveError.Equals(0) && _download1.Equals(true))
        {                           
            _paramSave["RegistrationForm"] = _registrationForm;
            _saveError = HCSDB.InsertDownloadLog(_paramSave);
        }

        if (_saveError.Equals(0) && _download2.Equals(true))
        {
            _paramSave["RegistrationForm"] = "KN003Form";
            _saveError = HCSDB.InsertDownloadLog(_paramSave);
        }

        if (_saveError.Equals(0))
        {
            _ds = HCSDB.GetWelfareLog(_personId);
            _recordCount = _ds.Tables[0].Rows.Count;
            _action = (_recordCount.Equals(0) ? "INSERT" : "UPDATE");
            _ds.Dispose();
            
            _ds = Util.DBUtil.ExecuteCommandStoredProcedure("sp_hcsSetWelfareLog",
                new SqlParameter("@action", _action),
                new SqlParameter("@personId", _personId),
                new SqlParameter("@welfare", _c.Request["welfare"]),
                new SqlParameter("@by", _personId),
                new SqlParameter("@ip", Util.GetIP())
            );
            
            _dr = _ds.Tables[0].Rows[0];
            _saveError = (int.Parse(_dr[0].ToString()).Equals(1) ? 0 : 1);

            _ds.Dispose();
        }

        if (_saveError.Equals(0))
        {
            _fileName = (_registrationForm + _fileName + ".pdf");

            ExportToPDF _e = new ExportToPDF();
            _e.ExportToPDFConnectWithSaveFile(_filePath + _fileName);
            _e.PDFConnectTemplate(HCSUtil._myPDFFormTemplate, "pdfwithsavefile");

            _dataRecorded.Clear();
            _dataRecorded = HCSDownloadRegistrationFormUtil.StudentRecordsUtil.SetValueDataRecorded(_dataRecorded, HCSDB.GetStudentRecords(_personId));

            HCSDownloadRegistrationFormUtil.GenerateRegistrationFormUtil _g = new HCSDownloadRegistrationFormUtil.GenerateRegistrationFormUtil();
            
            if (_download1.Equals(true))
                _g.GetRegistrationForm(_registrationForm, _dataRecorded, _e);

            if (_download2.Equals(true))
                _g.GetRegistrationForm("KN003Form", _dataRecorded, _e);

            _e.ExportToPdfDisconnectWithSaveFile();
        }

        _downloadResult.Clear();
        _downloadResult.Add("SaveError", _saveError);
        _downloadResult.Add("DownloadPath", HCSUtil._myFileDownloadPath);
        _downloadResult.Add("DownloadFile", _fileName);

        return _downloadResult;
    }

    public class GenerateRegistrationFormUtil
    {
        public void GetRegistrationForm(string _registrationForm, Dictionary<string, object> _dataRecorded, ExportToPDF _e)
        {
            Type _thisType = this.GetType();
            MethodInfo _theMethod = _thisType.GetMethod("Get" + _registrationForm);
            _theMethod.Invoke(this, new object[]
            {
                _dataRecorded,
                _e
            });
        }

        public void GetNHSORegisForm(Dictionary<string, object> _dataRecorded, ExportToPDF _e)
        {
            _e.PDFAddTemplate("pdf", 1, 1);
            _e.PDFAddTemplate("pdf", 2, 1);
            _e.FillForm(HCSUtil._myPDFFontBold, 13, 0, Util.GetBlank(_dataRecorded["FacultyNameTH"].ToString(), ""), 335, 700, 203, 20);
            _e.FillForm(HCSUtil._myPDFFontBold, 13, 0, Util.GetBlank(_dataRecorded["ProgramNameTH"].ToString(), ""), 125, 680, 159, 20);
            _e.FillForm(HCSUtil._myPDFFontBold, 13, 0, Util.GetBlank(_dataRecorded["Class"].ToString(), ""), 322, 673, 52, 0);
            _e.FillForm(HCSUtil._myPDFFontBold, 13, 0, Util.GetBlank(_dataRecorded["StudentCode"].ToString(), ""), 440, 673, 98, 0);
            _e.FillForm(HCSUtil._myPDFFontBold, 13, 0, Util.GetFullName(Util.GetBlank(_dataRecorded["TitleInitialsTH"].ToString(), ""), Util.GetBlank(_dataRecorded["TitleFullNameTH"].ToString(), ""), Util.GetBlank(_dataRecorded["FirstName"].ToString(), ""), Util.GetBlank(_dataRecorded["MiddleName"].ToString(), ""), Util.GetBlank(_dataRecorded["LastName"].ToString(), "")), 104, 653, 196, 0);
            _e.FillForm(HCSUtil._myPDFFontBold, 13, 0, Util.GetBlank(_dataRecorded["IdCard"].ToString(), ""), 418, 653, 120, 0);
            _e.FillForm(HCSUtil._myPDFFontBold, 13, 0, Util.GetBlank(_dataRecorded["BirthDateTH"].ToString(), ""), 158, 634, 65, 0);
            _e.FillForm(HCSUtil._myPDFFontBold, 13, 0, Util.GetBlank(_dataRecorded["Age"].ToString(), ""), 317, 634, 28, 0);
            _e.FillForm(HCSUtil._myPDFFontBold, 13, 0, Util.GetBlank(_dataRecorded["HouseNoPermanentAddress"].ToString(), ""), 149, 614, 45, 0);
            _e.FillForm(HCSUtil._myPDFFontBold, 13, 0, Util.GetBlank(_dataRecorded["VillageNoPermanentAddress"].ToString(), ""), 220, 614, 40, 0);
            _e.FillForm(HCSUtil._myPDFFontBold, 13, 0, Util.GetBlank(_dataRecorded["LaneAlleyPermanentAddress"].ToString(), ""), 308, 614, 100, 0);
            _e.FillForm(HCSUtil._myPDFFontBold, 13, 0, Util.GetBlank(_dataRecorded["RoadPermanentAddress"].ToString(), ""), 435, 614, 95, 0);
            _e.FillForm(HCSUtil._myPDFFontBold, 13, 0, Util.GetBlank(_dataRecorded["SubDistrictNameTHPermanentAddress"].ToString(), ""), 140, 595, 112, 0);
            _e.FillForm(HCSUtil._myPDFFontBold, 13, 0, Util.GetBlank(_dataRecorded["DistrictNameTHPermanentAddress"].ToString(), ""), 305, 595, 117, 0);
            _e.FillForm(HCSUtil._myPDFFontBold, 13, 0, Util.GetBlank(_dataRecorded["ProvinceNameTHPermanentAddress"].ToString(), ""), 457, 595, 74, 0);
            _e.FillForm(HCSUtil._myPDFFontBold, 13, 0, Util.GetBlank(_dataRecorded["PostalCodePermanentAddress"].ToString(), ""), 144, 575, 72, 0);
            _e.FillForm(HCSUtil._myPDFFontBold, 13, 0, Util.GetBlank(_dataRecorded["PhoneNumberPermanentAddress"].ToString(), ""), 245, 575, 89, 0);
            _e.FillForm(HCSUtil._myPDFFontBold, 13, 0, Util.GetBlank(_dataRecorded["MobileNumberPermanentAddress"].ToString(), ""), 380, 575, 91, 0);

            if (_dataRecorded["Hospital"].Equals("SI"))
                _e.FillForm(HCSUtil._myPDFFontBold, 15, 0, "X", 331, 524, 10, 0);

            if (_dataRecorded["Hospital"].Equals("RA"))
                _e.FillForm(HCSUtil._myPDFFontBold, 15, 0, "X", 441, 524, 10, 0);

            _e.FillForm(HCSUtil._myPDFFontBold, 15, 0, "X", 220, 446, 10, 0);
            _e.FillForm(HCSUtil._myPDFFontBold, 12, 1, Util.GetFullName(Util.GetBlank(_dataRecorded["TitleInitialsTH"].ToString(), ""), Util.GetBlank(_dataRecorded["TitleFullNameTH"].ToString(), ""), Util.GetBlank(_dataRecorded["FirstName"].ToString(), ""), Util.GetBlank(_dataRecorded["MiddleName"].ToString(), ""), Util.GetBlank(_dataRecorded["LastName"].ToString(), "")), 111, 276, 174, 0);
            _e.FillForm(HCSUtil._myPDFFontBold, 12, 1, Util.CurrentDate("dd"), 139, 237, 23, 0);
            _e.FillForm(HCSUtil._myPDFFontBold, 12, 1, Util._longMonth[int.Parse(Util.CurrentDate("MM")) - 1, 1], 185, 237, 49, 0);
            _e.FillForm(HCSUtil._myPDFFontBold, 12, 1, (int.Parse(Util.CurrentDate("yyyy")) + 543).ToString(), 242, 237, 33, 0);

            if (_dataRecorded["WelfareForPublicServant"].Equals("Y"))
                _e.FillForm(HCSUtil._myPDFFontBold, 14, 0, "รอเปลี่ยนสิทธิอายุ 20 ปี", 83, 75, 200, 0);

            if (!String.IsNullOrEmpty(Util.GetBlank(_dataRecorded["IdCard"].ToString(), "")))
                _e.FillForm(HCSUtil._myPDFFontBarcode, 24, 2, "*" + _dataRecorded["IdCard"] + "*", 295, 40, 245, 0);
        }

        public void GetRARegisForm(Dictionary<string, object> _dataRecorded, ExportToPDF _e)
        {
            _e.PDFAddTemplate("pdf", 1, 1);
            _e.PDFAddTemplate("pdf", 3, 2);
            GetRegisForm(_dataRecorded, _e);
        }

        public void GetSIRegisForm(Dictionary<string, object> _dataRecorded, ExportToPDF _e)
        {
            _e.PDFAddTemplate("pdf", 1, 1);
            _e.PDFAddTemplate("pdf", 4, 2);
            GetRegisForm(_dataRecorded, _e);
        }

        public static void GetRegisForm(Dictionary<string, object> _dataRecorded, ExportToPDF _e)
        {
            _e.FillForm(HCSUtil._myPDFFontNormal, 11, 2, ("วันที่พิมพ์ " + Util.ConvertDateTH(Util.CurrentDate("yyyy/MM/dd"))), 722, 581, 100, 0);
            _e.FillForm(HCSUtil._myPDFFontBold, 16, 0, (!_dataRecorded["StudentCode"].ToString().Equals("XXXXXXX") ? Util.GetBlank(_dataRecorded["StudentCode"].ToString(), "") : ""), 217, 565, 58, 0);
            _e.FillForm(HCSUtil._myPDFFontBold, 10, 0, Util.GetBlank(_dataRecorded["ProgramNameTH"].ToString(), ""), 204, 554, 71, 20);
            _e.FillForm(HCSUtil._myPDFFontBold, 10, 0, Util.GetBlank(_dataRecorded["FacultyNameTH"].ToString(), ""), 192, 539, 83, 20);
            _e.FillForm(HCSUtil._myPDFFontBold, 15, 0, Util.GetFullName(Util.GetBlank(_dataRecorded["TitleInitialsTH"].ToString(), ""), Util.GetBlank(_dataRecorded["TitleFullNameTH"].ToString(), ""), Util.GetBlank(_dataRecorded["FirstName"].ToString(), ""), Util.GetBlank(_dataRecorded["MiddleName"].ToString(), ""), Util.GetBlank(_dataRecorded["LastName"].ToString(), "")), 20, 488, 255, 0);
            _e.FillForm(HCSUtil._myPDFFontBold, 16, 1, (Util.GetBlank(_dataRecorded["IdCard"].ToString(), "").Length >= 1 ? _dataRecorded["IdCard"].ToString().Substring(0, 1) : ""), 92, 470, 11, 0);
            _e.FillForm(HCSUtil._myPDFFontBold, 16, 1, (Util.GetBlank(_dataRecorded["IdCard"].ToString(), "").Length >= 2 ? _dataRecorded["IdCard"].ToString().Substring(1, 1) : ""), 110, 470, 11, 0);
            _e.FillForm(HCSUtil._myPDFFontBold, 16, 1, (Util.GetBlank(_dataRecorded["IdCard"].ToString(), "").Length >= 3 ? _dataRecorded["IdCard"].ToString().Substring(2, 1) : ""), 123, 470, 11, 0);
            _e.FillForm(HCSUtil._myPDFFontBold, 16, 1, (Util.GetBlank(_dataRecorded["IdCard"].ToString(), "").Length >= 4 ? _dataRecorded["IdCard"].ToString().Substring(3, 1) : ""), 135, 470, 11, 0);
            _e.FillForm(HCSUtil._myPDFFontBold, 16, 1, (Util.GetBlank(_dataRecorded["IdCard"].ToString(), "").Length >= 5 ? _dataRecorded["IdCard"].ToString().Substring(4, 1) : ""), 147, 470, 11, 0);
            _e.FillForm(HCSUtil._myPDFFontBold, 16, 1, (Util.GetBlank(_dataRecorded["IdCard"].ToString(), "").Length >= 6 ? _dataRecorded["IdCard"].ToString().Substring(5, 1) : ""), 165, 470, 11, 0);
            _e.FillForm(HCSUtil._myPDFFontBold, 16, 1, (Util.GetBlank(_dataRecorded["IdCard"].ToString(), "").Length >= 7 ? _dataRecorded["IdCard"].ToString().Substring(6, 1) : ""), 177, 470, 11, 0);
            _e.FillForm(HCSUtil._myPDFFontBold, 16, 1, (Util.GetBlank(_dataRecorded["IdCard"].ToString(), "").Length >= 8 ? _dataRecorded["IdCard"].ToString().Substring(7, 1) : ""), 190, 470, 11, 0);
            _e.FillForm(HCSUtil._myPDFFontBold, 16, 1, (Util.GetBlank(_dataRecorded["IdCard"].ToString(), "").Length >= 9 ? _dataRecorded["IdCard"].ToString().Substring(8, 1) : ""), 202, 470, 11, 0);
            _e.FillForm(HCSUtil._myPDFFontBold, 16, 1, (Util.GetBlank(_dataRecorded["IdCard"].ToString(), "").Length >= 10 ? _dataRecorded["IdCard"].ToString().Substring(9, 1) : ""), 214, 470, 11, 0);
            _e.FillForm(HCSUtil._myPDFFontBold, 16, 1, (Util.GetBlank(_dataRecorded["IdCard"].ToString(), "").Length >= 11 ? _dataRecorded["IdCard"].ToString().Substring(10, 1) : ""), 233, 470, 11, 0);
            _e.FillForm(HCSUtil._myPDFFontBold, 16, 1, (Util.GetBlank(_dataRecorded["IdCard"].ToString(), "").Length >= 12 ? _dataRecorded["IdCard"].ToString().Substring(11, 1) : ""), 245, 470, 11, 0);
            _e.FillForm(HCSUtil._myPDFFontBold, 16, 1, (Util.GetBlank(_dataRecorded["IdCard"].ToString(), "").Length >= 13 ? _dataRecorded["IdCard"].ToString().Substring(12, 1) : ""), 264, 470, 11, 0);
            _e.FillForm(HCSUtil._myPDFFontBold, 12, 0, Util.GetBlank(_dataRecorded["BirthDateTH"].ToString(), ""), 75, 447, 65, 0);
            _e.FillForm(HCSUtil._myPDFFontBold, 11, 0, Util.GetBlank(_dataRecorded["HouseNoPermanentAddress"].ToString(), ""), 61, 424, 39, 20);
            _e.FillForm(HCSUtil._myPDFFontBold, 11, 0, Util.GetBlank(_dataRecorded["VillageNoPermanentAddress"].ToString(), ""), 121, 424, 21, 20);
            _e.FillForm(HCSUtil._myPDFFontBold, 11, 0, Util.GetBlank(_dataRecorded["LaneAlleyPermanentAddress"].ToString(), ""), 185, 424, 90, 20);
            _e.FillForm(HCSUtil._myPDFFontBold, 11, 0, Util.GetBlank(_dataRecorded["RoadPermanentAddress"].ToString(), ""), 36, 409, 90, 20);
            _e.FillForm(HCSUtil._myPDFFontBold, 11, 0, Util.GetBlank(_dataRecorded["SubDistrictNameTHPermanentAddress"].ToString(), ""), 170, 409, 105, 20);
            _e.FillForm(HCSUtil._myPDFFontBold, 11, 0, Util.GetBlank(_dataRecorded["DistrictNameTHPermanentAddress"].ToString(), ""), 61, 394, 106, 20);
            _e.FillForm(HCSUtil._myPDFFontBold, 11, 0, Util.GetBlank(_dataRecorded["ProvinceNameTHPermanentAddress"].ToString(), ""), 195, 394, 80, 20);
            _e.FillForm(HCSUtil._myPDFFontBold, 11, 0, Util.GetBlank(_dataRecorded["PostalCodePermanentAddress"].ToString(), ""), 63, 380, 42, 20);
            _e.FillForm(HCSUtil._myPDFFontBold, 11, 0, Util.GetBlank(_dataRecorded["PhoneNumberPermanentAddress"].ToString(), ""), 122, 380, 53, 20);
            _e.FillForm(HCSUtil._myPDFFontBold, 11, 0, Util.GetBlank(_dataRecorded["MobileNumberPermanentAddress"].ToString(), ""), 209, 380, 66, 20);

            if (_dataRecorded["WorkedStatus"].Equals("Y"))
            {
                if (_dataRecorded["WelfareForPublicServant"].Equals("Y"))
                {
                    _e.FillForm(HCSUtil._myPDFFontBold, 16, 1, "X", 18, 299, 10, 0);
                    _e.FillForm(HCSUtil._myPDFFontBold, 12, 0, "ไม่เปลี่ยนสิทธิการรักษาพยาบาล", 65, 297, 184, 0);
                }

                if (_dataRecorded["WelfareForPublicServant"].Equals("N"))
                {
                    _e.FillForm(HCSUtil._myPDFFontBold, 16, 1, "X", 18, 328, 10, 0);
                    _e.FillForm(HCSUtil._myPDFFontBold, 12, 0, "ประกันสังคม", 91, 327, 184, 0);
                }
            }

            if (_dataRecorded["WorkedStatus"].Equals("N"))
            {
                if (_dataRecorded["WelfareForPublicServant"].Equals("Y"))
                {
                    _e.FillForm(HCSUtil._myPDFFontBold, 16, 1, "X", 18, 328, 10, 0);
                    _e.FillForm(HCSUtil._myPDFFontBold, 12, 0, "ข้าราชการ / รัฐวิสาหกิจ", 91, 327, 184, 0);
                }

                if (_dataRecorded["WelfareForPublicServant"].Equals("N"))
                    _e.FillForm(HCSUtil._myPDFFontBold, 16, 1, "X", 18, 314, 10, 0);
            }

            if (_dataRecorded["WelfareForPublicServant"].Equals("Y"))
                _e.FillForm(HCSUtil._myPDFFontBold, 14, 0, "รอเปลี่ยนสิทธิอายุ 20 ปี", 90, 31, 200, 0);
            
            if (!String.IsNullOrEmpty(Util.GetBlank(_dataRecorded["IdCard"].ToString(), "")))
                _e.FillForm(HCSUtil._myPDFFontBarcode, 24, 2, "*" + _dataRecorded["IdCard"] + "*", 579, 38, 245, 0);
        }

        public void GetKN003Form(Dictionary<string, object> _dataRecorded, ExportToPDF _e)
        {
            _e.PDFAddTemplate("pdf", 11, 2);
            _e.FillForm(HCSUtil._myPDFFontBold, 15, 0, Util.GetFullName(Util.GetBlank(_dataRecorded["TitleInitialsTH"].ToString(), ""), Util.GetBlank(_dataRecorded["TitleFullNameTH"].ToString(), ""), Util.GetBlank(_dataRecorded["FirstName"].ToString(), ""), Util.GetBlank(_dataRecorded["MiddleName"].ToString(), ""), Util.GetBlank(_dataRecorded["LastName"].ToString(), "")), 79, 490, 279, 0);
            _e.FillForm(HCSUtil._myPDFFontBold, 15, 0,
                ((!String.IsNullOrEmpty(Util.GetBlank(_dataRecorded["HouseNoCurrentAddress"].ToString(), "")) ? _dataRecorded["HouseNoCurrentAddress"].ToString() : "") +
                 (!String.IsNullOrEmpty(Util.GetBlank(_dataRecorded["VillageNoCurrentAddress"].ToString(), "")) ? (" หมู่ " + _dataRecorded["VillageNoCurrentAddress"].ToString()) : "") +
                 (!String.IsNullOrEmpty(Util.GetBlank(_dataRecorded["LaneAlleyCurrentAddress"].ToString(), "")) ? (" ซ." + _dataRecorded["LaneAlleyCurrentAddress"].ToString()) : "") +
                 (!String.IsNullOrEmpty(Util.GetBlank(_dataRecorded["RoadCurrentAddress"].ToString(), "")) ? (" ถ." + _dataRecorded["RoadCurrentAddress"].ToString()) : "")), 89, 469, 400, 0);
            _e.FillForm(HCSUtil._myPDFFontBold, 15, 0, (!String.IsNullOrEmpty(Util.GetBlank(_dataRecorded["SubDistrictNameTHCurrentAddress"].ToString(), "")) ? (" ต." + _dataRecorded["SubDistrictNameTHCurrentAddress"].ToString()) : ""), 99, 449, 259, 0);
            _e.FillForm(HCSUtil._myPDFFontBold, 15, 0, (!String.IsNullOrEmpty(Util.GetBlank(_dataRecorded["DistrictNameTHCurrentAddress"].ToString(), "")) ? (" อ." + _dataRecorded["DistrictNameTHCurrentAddress"].ToString()) : ""), 109, 429, 249, 0);
            _e.FillForm(HCSUtil._myPDFFontBold, 15, 0, (!String.IsNullOrEmpty(Util.GetBlank(_dataRecorded["ProvinceNameTHCurrentAddress"].ToString(), "")) ? (" จ." + _dataRecorded["ProvinceNameTHCurrentAddress"].ToString()) : ""), 119, 408, 239, 0);
            _e.FillForm(HCSUtil._myPDFFontBold, 20, 1, (Util.GetBlank(_dataRecorded["PostalCodeCurrentAddress"].ToString(), "").Length >= 1 ? _dataRecorded["PostalCodeCurrentAddress"].ToString().Substring(0, 1) : ""), 180, 386, 13, 0);
            _e.FillForm(HCSUtil._myPDFFontBold, 20, 1, (Util.GetBlank(_dataRecorded["PostalCodeCurrentAddress"].ToString(), "").Length >= 2 ? _dataRecorded["PostalCodeCurrentAddress"].ToString().Substring(1, 1) : ""), 197, 386, 13, 0);
            _e.FillForm(HCSUtil._myPDFFontBold, 20, 1, (Util.GetBlank(_dataRecorded["PostalCodeCurrentAddress"].ToString(), "").Length >= 3 ? _dataRecorded["PostalCodeCurrentAddress"].ToString().Substring(2, 1) : ""), 214, 386, 13, 0);
            _e.FillForm(HCSUtil._myPDFFontBold, 20, 1, (Util.GetBlank(_dataRecorded["PostalCodeCurrentAddress"].ToString(), "").Length >= 4 ? _dataRecorded["PostalCodeCurrentAddress"].ToString().Substring(3, 1) : ""), 230, 386, 13, 0);
            _e.FillForm(HCSUtil._myPDFFontBold, 20, 0, (Util.GetBlank(_dataRecorded["PostalCodeCurrentAddress"].ToString(), "").Length >= 5 ? _dataRecorded["PostalCodeCurrentAddress"].ToString().Substring(4, 1) : ""), 248, 386, 13, 0);

            if (!String.IsNullOrEmpty(Util.GetBlank(_dataRecorded["ProgramAddress"].ToString(), "")))
            {
                string[] _programAddressArray = _dataRecorded["ProgramAddress"].ToString().Split('&');
                int _col = 380;
                int _row = 225;

                for (int _i = 0; _i < _programAddressArray.GetLength(0); _i++)
                {
                    _e.FillForm(HCSUtil._myPDFFontBold, 16, 0, _programAddressArray[_i], _col, _row, 363, 0);
                    _col = _col + 10;
                    _row = _row - 22;
                }
            }
        }
    }
}
// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appTitle => 'Shift Calendar Engine';

  @override
  String get dashboard => 'ภาพรวม';

  @override
  String get roster => 'ตารางเวร';

  @override
  String get employees => 'บุคลากร';

  @override
  String get exchange => 'แลกเวร';

  @override
  String get reports => 'รายงาน';

  @override
  String get settings => 'ตั้งค่า';

  @override
  String get today => 'วันนี้';

  @override
  String get tomorrow => 'พรุ่งนี้';

  @override
  String get nextShift => 'เวรถัดไป';

  @override
  String get monthlyAssignments => 'จำนวนเวรเดือนนี้';

  @override
  String get estimatedIncome => 'รายได้โดยประมาณ';

  @override
  String get pendingRequests => 'คำขอที่รอดำเนินการ';

  @override
  String get calendarStatus => 'สถานะปฏิทิน';

  @override
  String get notConnected => 'ยังไม่เชื่อมต่อ';

  @override
  String get noSchedule => 'ยังไม่มีข้อมูลตารางเวร';

  @override
  String get noScheduleDescription => 'นำเข้าหรือสร้างตารางเวรเพื่อเริ่มใช้งาน';

  @override
  String get createRoster => 'สร้างตารางเวร';

  @override
  String get importRoster => 'นำเข้าตารางเวร';

  @override
  String get previousMonth => 'เดือนก่อนหน้า';

  @override
  String get nextMonth => 'เดือนถัดไป';

  @override
  String get monthOverview => 'ภาพรวมรายเดือน';

  @override
  String get employeeDirectory => 'รายชื่อบุคลากร';

  @override
  String get employeeDirectoryDescription => 'จัดการบุคลากรที่ใช้ในตารางเวร';

  @override
  String get noEmployees => 'ยังไม่มีบุคลากร';

  @override
  String get exchangeRequests => 'คำขอแลกเวร';

  @override
  String get exchangeDescription =>
      'คำขอ การอนุมัติ และประวัติจะอ้างอิงตารางเวรหลัก';

  @override
  String get noRequests => 'ยังไม่มีคำขอแลกเวร';

  @override
  String get reportCenter => 'ศูนย์รายงาน';

  @override
  String get reportDescription => 'รายงานตารางเวรสำหรับพิมพ์และส่งออก';

  @override
  String get noReports => 'ยังไม่มีข้อมูลรายงาน';

  @override
  String get workspaceSettings => 'การตั้งค่า Workspace';

  @override
  String get language => 'ภาษา';

  @override
  String get followSystem => 'ตามระบบ';

  @override
  String get english => 'อังกฤษ';

  @override
  String get thai => 'ไทย';

  @override
  String get theme => 'ธีม';

  @override
  String get systemTheme => 'ตามระบบ';

  @override
  String get lightTheme => 'สว่าง';

  @override
  String get darkTheme => 'มืด';

  @override
  String get demoMode => 'โหมดสาธิต';

  @override
  String get demoModeDescription =>
      'ใช้ข้อมูลตัวอย่างที่แน่นอนโดยไม่เชื่อมต่อบัญชีภายนอก';

  @override
  String get logicMode => 'รูปแบบตรรกะ';

  @override
  String get logicModeDescription =>
      'เลือกใช้กฎมาตรฐานหรือกำหนดรูปแบบการทำงานเองสำหรับแต่ละฟีเจอร์';

  @override
  String get standardLogic => 'มาตรฐาน';

  @override
  String get freestyleLogic => 'ฟรีสไตล์';

  @override
  String get phaseStatus => 'รากฐาน SCE 3.0';

  @override
  String get phaseStatusDescription =>
      'เปิดใช้ตารางเวรหลัก การประกอบ dependency แบบชัดเจน navigation responsive ระบบภาษา และการทดสอบแล้ว';

  @override
  String get addEmployee => 'เพิ่มบุคลากร';

  @override
  String get editEmployee => 'แก้ไขบุคลากร';

  @override
  String get deactivateEmployee => 'ยืนยันการปิดใช้งานบุคลากร';

  @override
  String get deactivate => 'ปิดใช้งาน';

  @override
  String get employeeCode => 'รหัสพนักงาน';

  @override
  String get firstName => 'ชื่อ';

  @override
  String get lastName => 'นามสกุล';

  @override
  String get nickname => 'ชื่อเล่น';

  @override
  String get position => 'ตำแหน่ง';

  @override
  String get departmentCode => 'รหัสหน่วยงาน';

  @override
  String get departmentName => 'ชื่อหน่วยงาน';

  @override
  String get search => 'ค้นหา';

  @override
  String get save => 'บันทึก';

  @override
  String get cancel => 'ยกเลิก';

  @override
  String get confirm => 'ยืนยัน';

  @override
  String get delete => 'ลบ';

  @override
  String get requiredField => 'จำเป็นต้องกรอกข้อมูลนี้';

  @override
  String get shiftTemplates => 'แม่แบบเวร';

  @override
  String get shiftTemplatesDescription =>
      'กำหนดรหัส เวลา สี ชั่วโมงทำงาน และอัตราของเวรที่นำกลับมาใช้ได้';

  @override
  String get addShiftTemplate => 'เพิ่มแม่แบบเวร';

  @override
  String get editShiftTemplate => 'แก้ไขแม่แบบเวร';

  @override
  String get deactivateShiftTemplate => 'ยืนยันการปิดใช้งานแม่แบบเวร';

  @override
  String get shiftCode => 'รหัสเวร';

  @override
  String get shiftName => 'ชื่อเวร';

  @override
  String get startTime => 'เวลาเริ่ม';

  @override
  String get endTime => 'เวลาสิ้นสุด';

  @override
  String get workingHours => 'ชั่วโมงทำงาน';

  @override
  String get rate => 'อัตรา';

  @override
  String get shiftColor => 'สีของเวร';

  @override
  String get manualRosterEditor => 'จัดตารางเวรด้วยตนเอง';

  @override
  String get addAssignment => 'เพิ่มรายการเวร';

  @override
  String get editAssignment => 'แก้ไขรายการเวร';

  @override
  String get selectDate => 'เลือกวันที่';

  @override
  String get employee => 'บุคลากร';

  @override
  String get shift => 'เวร';

  @override
  String get location => 'สถานที่';

  @override
  String get remark => 'หมายเหตุ';

  @override
  String get shiftCoverComment => 'ยกเวร';

  @override
  String get shiftSwapComment => 'แลกเวร';

  @override
  String get previewChanges => 'ตรวจสอบการเปลี่ยนแปลง';

  @override
  String get catalogRequired => 'เพิ่มบุคลากรและแม่แบบเวรที่เปิดใช้งานก่อน';

  @override
  String get scheduleSaved => 'บันทึกตารางเวรแล้ว';

  @override
  String get storageError => 'ไม่สามารถดำเนินการกับพื้นที่จัดเก็บได้';

  @override
  String get reportMonth => 'เดือนของรายงาน';

  @override
  String get reportLanguage => 'ภาษาของรายงาน';

  @override
  String get allDepartments => 'ทุกหน่วยงาน';

  @override
  String get previewReport => 'ดูตัวอย่างรายงาน';

  @override
  String get previewReportDescription =>
      'เลือกตัวเลือกรายงานแล้วสร้างตัวอย่าง A4';

  @override
  String get printReport => 'พิมพ์';

  @override
  String get sharePdf => 'แชร์ PDF';

  @override
  String get reportGenerationError => 'ไม่สามารถสร้างรายงาน PDF ได้';

  @override
  String get googleDrive => 'Google Drive';

  @override
  String get googleOAuthSettings => 'การเชื่อมต่อ Google';

  @override
  String get googleOAuthSettingsDescription =>
      'ใส่ Web OAuth Client ID แล้วโหลดหน้าเว็บใหม่เพื่อเปิดปุ่มลงชื่อเข้าใช้ Google';

  @override
  String get googleWebClientId => 'Web OAuth Client ID';

  @override
  String get invalidGoogleWebClientId =>
      'รูปแบบ Web OAuth Client ID ไม่ถูกต้อง';

  @override
  String get googleOAuthSaved =>
      'บันทึก Google OAuth แล้ว กรุณาโหลดหน้าเว็บใหม่';

  @override
  String get signInWithGoogle => 'ลงชื่อเข้าใช้ด้วย Google';

  @override
  String get signOutGoogle => 'ออกจากระบบ Google';

  @override
  String get googleDriveDescription =>
      'เลือกไฟล์ต้นทางของตารางเวรจาก Google Drive';

  @override
  String get openGoogleDrive => 'Google Drive';

  @override
  String get recentlyModified => 'แก้ไขล่าสุด';

  @override
  String get lastImported => 'นำเข้าล่าสุด';

  @override
  String get loadCurrentSource => 'โหลดไฟล์ต้นทางปัจจุบัน';

  @override
  String get noDriveRosterFiles => 'ยังไม่ได้โหลดไฟล์ตารางเวรจาก Google Drive';

  @override
  String get noLastImportedSource => 'ยังไม่เคยนำเข้าไฟล์ต้นทาง';

  @override
  String get googleDriveNotConfigured =>
      'ยังไม่ได้ตั้งค่า Google Drive โปรดเพิ่มการเชื่อมต่อ Drive แบบ OAuth ก่อนเชื่อมบัญชี';

  @override
  String get googleDriveLoadFailed =>
      'ไม่สามารถโหลดไฟล์ต้นทางจาก Google Drive ได้';

  @override
  String get driveSourceLoaded => 'โหลดไฟล์ต้นทางปัจจุบันแล้ว';

  @override
  String get sheetReadMode => 'รูปแบบการอ่านชีต';

  @override
  String get configuredSheetRead => 'กำหนดเฉพาะ';

  @override
  String get standardSheetRead => 'อ่านธรรมดา';

  @override
  String get configuredSheetReadDescription =>
      'อ่านตามการกำหนดคอลัมน์และแม่แบบเวร รวมชั่วโมงทำงาน สี และค่าตอบแทน';

  @override
  String get standardSheetReadDescription =>
      'อ่านข้อมูลตารางเวรตามรูปแบบมาตรฐานโดยไม่ใช้การกำหนดเฉพาะ';

  @override
  String get newExchangeRequest => 'สร้างคำขอ';

  @override
  String get coverShift => 'ยกเวร';

  @override
  String get swapShift => 'แลกเวร';

  @override
  String get originalShift => 'เวรเดิม';

  @override
  String get offeredShift => 'เวรที่นำมาแลก';

  @override
  String get receivingEmployee => 'ผู้รับเวร';

  @override
  String get reason => 'เหตุผล';

  @override
  String get submitRequest => 'ส่งคำขอ';

  @override
  String get acceptExchange => 'ตอบรับ';

  @override
  String get approveExchange => 'อนุมัติการแลกเวร';

  @override
  String get previewAndApprove => 'ตรวจสอบและอนุมัติ';

  @override
  String get rejectExchange => 'ปฏิเสธ';

  @override
  String get cancelRequest => 'ยกเลิกคำขอ';

  @override
  String get exchangePreview => 'ตรวจสอบก่อนอนุมัติ';

  @override
  String get noExchangeConflicts => 'ไม่พบความขัดแย้งที่ห้ามอนุมัติ';

  @override
  String get waitingForAcceptance => 'รอการตอบรับ';

  @override
  String get waitingForApproval => 'รออนุมัติ';

  @override
  String get approvedExchange => 'อนุมัติแล้ว';

  @override
  String get rejectedExchange => 'ปฏิเสธแล้ว';

  @override
  String get cancelledExchange => 'ยกเลิกแล้ว';

  @override
  String get rejectionReason => 'เหตุผลที่ปฏิเสธ';

  @override
  String get exchangeSaved => 'บันทึกคำขอแลกเวรแล้ว';

  @override
  String get retry => 'ลองใหม่';

  @override
  String get loadFirstTimeline => 'ดึงไทม์ไลน์แรก';

  @override
  String get timelineLoaded =>
      'โหลดเวลาเริ่มต้นของไฟล์และข้อมูลชีตปัจจุบันแล้ว';

  @override
  String get timelineLoadFailed => 'ไม่สามารถโหลดไทม์ไลน์ของไฟล์ที่เลือกได้';

  @override
  String get firstFileTimeline => 'ไทม์ไลน์ของไฟล์ที่เลือก';

  @override
  String get fileCreatedTime => 'สร้างไฟล์ครั้งแรก';

  @override
  String get unknownCreatedTime => 'ไม่มีข้อมูลเวลาสร้างไฟล์';

  @override
  String get firstWorksheet => 'แท็บแรก';

  @override
  String get fileOwners => 'เจ้าของไฟล์';

  @override
  String get headerRow => 'แถวหัวตาราง';

  @override
  String rowNumber(int number) {
    return 'แถวที่ $number';
  }

  @override
  String get notMapped => 'ไม่กำหนด';

  @override
  String get exchangeDataPreview => 'ตัวอย่างข้อมูลสำหรับแลกเวร';

  @override
  String get noTimelineRows => 'ไม่พบแถวข้อมูลตามคอลัมน์ที่เลือก';

  @override
  String get row => 'แถว';

  @override
  String get date => 'วันที่';

  @override
  String get exchangeGiver => 'ผู้ยกเวร/ผู้ขอแลก';

  @override
  String get exchangeReceiver => 'ผู้รับเวร';

  @override
  String get exchangeType => 'รูปแบบการแลก';

  @override
  String get currentSheetValuesNotice =>
      'เวลาสร้างครั้งแรกมาจาก Google Drive ส่วนรายชื่อและข้อมูลเวรอ่านจากแท็บแรกฉบับปัจจุบัน ไม่ใช่ข้อมูลเซลล์ใน revision แรก';

  @override
  String get createCoverRequests => 'สร้างคำขอยกเวร/รับเวร';

  @override
  String timelineImportResult(int created, int skipped) {
    return 'สร้างคำขอ $created รายการ ข้าม $skipped แถว';
  }

  @override
  String get attachOriginalFile => 'แนบไฟล์ต้นฉบับ';

  @override
  String get originalFileAttached => 'แนบไฟล์ต้นฉบับแล้ว';

  @override
  String get fileSize => 'ขนาด';

  @override
  String get rows => 'จำนวนแถว';

  @override
  String get removeAttachment => 'นำไฟล์แนบออก';

  @override
  String get loadTimelineToCompare =>
      'ดึงไทม์ไลน์ของชีตที่เลือกเพื่อเปรียบเทียบข้อมูล';

  @override
  String get sourcesMatch => 'ข้อมูลที่เปรียบเทียบตรงกัน';

  @override
  String get sourcesDifferent => 'ข้อมูลที่เปรียบเทียบมีความแตกต่าง';

  @override
  String get matchingCells => 'เซลล์ที่ตรงกัน';

  @override
  String get differentCells => 'เซลล์ที่ต่างกัน';

  @override
  String get localOnlyRows => 'แถวเฉพาะไฟล์ในเครื่อง';

  @override
  String get remoteOnlyRows => 'แถวเฉพาะ Google Sheets';

  @override
  String get rosterRules => 'กฎและนโยบายตารางเวร';

  @override
  String get rosterRulesDescription =>
      'กำหนดขีดจำกัดที่ใช้ร่วมกันตอนบันทึกเวร อนุมัติแลกเวร นำเข้า และคำนวณค่าตอบแทน';

  @override
  String get minimumRestHours => 'ชั่วโมงพักขั้นต่ำ';

  @override
  String get maximumContinuousHours => 'ชั่วโมงทำงานต่อเนื่องสูงสุด';

  @override
  String get maximumShiftsPerDay => 'จำนวนเวรสูงสุดต่อวัน';

  @override
  String get maximumShiftsPerWeek => 'จำนวนเวรสูงสุดต่อสัปดาห์';

  @override
  String get maximumShiftsPerMonth => 'จำนวนเวรสูงสุดต่อเดือน';

  @override
  String get blockOverlappingShifts => 'ห้ามเวรเวลาทับซ้อน';

  @override
  String get requireExchangeApproval => 'การแลกเวรต้องได้รับอนุมัติ';

  @override
  String get estimatedOvertime => 'OT โดยประมาณ';

  @override
  String get googleCalendarSync => 'ซิงค์ Google Calendar';

  @override
  String get googleCalendarSyncDescription =>
      'ตรวจตัวอย่างก่อน แล้วซิงค์เฉพาะเวรที่อนุมัติของบุคลากรที่เลือกลงปฏิทินหลักโดยไม่สร้างรายการซ้ำ';

  @override
  String get calendarEmployee => 'บุคลากร';

  @override
  String get previewCalendarSync => 'ดูตัวอย่างการซิงค์';

  @override
  String get syncCalendar => 'ซิงค์ปฏิทิน';

  @override
  String get calendarCreate => 'สร้าง';

  @override
  String get calendarUpdate => 'อัปเดต';

  @override
  String get calendarDelete => 'ลบ';

  @override
  String get calendarUnchanged => 'ไม่เปลี่ยนแปลง';
}

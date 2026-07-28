# Shift Calendar Engine 3.0

[![Validate Flutter](https://github.com/phakphoum38-stack/shift-calendar-engine-3-rebuilt/actions/workflows/validate.yml/badge.svg?branch=main)](https://github.com/phakphoum38-stack/shift-calendar-engine-3-rebuilt/actions/workflows/validate.yml)
[![Security](https://github.com/phakphoum38-stack/shift-calendar-engine-3-rebuilt/actions/workflows/security.yml/badge.svg?branch=main)](https://github.com/phakphoum38-stack/shift-calendar-engine-3-rebuilt/actions/workflows/security.yml)
[![Deploy Flutter Web](https://github.com/phakphoum38-stack/shift-calendar-engine-3-rebuilt/actions/workflows/deploy-pages.yml/badge.svg?branch=main)](https://github.com/phakphoum38-stack/shift-calendar-engine-3-rebuilt/actions/workflows/deploy-pages.yml)

ระบบจัดตารางเวรบุคลากรแบบข้ามแพลตฟอร์ม พัฒนาด้วย Flutter รองรับ Web,
Android, iOS, Windows, macOS และ Linux พร้อม UI ภาษาไทยและอังกฤษ

## สารบัญ

- [เปิดใช้งาน Web UI](#เปิดใช้งาน-web-ui)
- [ความสามารถของระบบ](#ฟีเจอร์ที่พร้อมใช้งาน)
- [ติดตั้งสำหรับผู้ใช้งาน](#ติดตั้งสำหรับผู้ใช้งาน)
- [ติดตั้งสำหรับนักพัฒนา](#ติดตั้งสำหรับนักพัฒนา)
- [ตั้งค่า Google Sign-In, Drive, Sheets และ Calendar](#ตั้งค่า-google-sign-in-google-drive-google-sheets-และ-google-calendar)
- [คู่มือการใช้งาน](#คู่มือการใช้งาน)
- [ข้อมูล การบันทึก และความปลอดภัย](#ข้อมูล-การบันทึก-และความปลอดภัย)
- [การทดสอบและสร้างไฟล์ Release](#การทดสอบและสร้างไฟล์-release)
- [การแก้ปัญหา](#การแก้ปัญหา)
- [GitHub Actions](#github-actions)

## เปิดใช้งาน Web UI

- [เปิด Web UI บน GitHub Pages](https://phakphoum38-stack.github.io/shift-calendar-engine-3-rebuilt/)
- [ดู Source code บน GitHub](https://github.com/phakphoum38-stack/shift-calendar-engine-3-rebuilt)

Web UI ไม่ต้องติดตั้งโปรแกรม เปิดผ่าน Chrome, Edge, Firefox หรือ Safari
รุ่นปัจจุบันได้ทันที ข้อมูลที่บันทึกจะอยู่ในพื้นที่จัดเก็บของเบราว์เซอร์
เครื่องและโปรไฟล์ที่กำลังใช้งาน ข้อมูลจะไม่ตามไปยังเครื่องหรือเบราว์เซอร์อื่น
โดยอัตโนมัติ

## ฟีเจอร์ที่พร้อมใช้งาน

- Dashboard สรุปเวรวันนี้ พรุ่งนี้ เวรรายเดือน รายได้ และ OT โดยประมาณ
- จัดการพนักงาน: ค้นหา เพิ่ม แก้ไข และปิดใช้งาน
- ป้องกันรหัสพนักงานซ้ำ
- จัดการรูปแบบเวร: รหัส ชื่อ เวลาเริ่ม/สิ้นสุด ชั่วโมงทำงาน สี และค่าตอบแทน
- เพิ่ม แก้ไข และลบเวรรายวัน พร้อม Preview และปุ่มบันทึกที่ชัดเจน
- บันทึกตารางเวรแบบ versioned/atomic เพื่อเก็บข้อมูลสมบูรณ์ชุดล่าสุด
- ตารางเวรรายเดือนและ Demo mode
- รายงาน PDF A4 ภาษาไทย/อังกฤษ พร้อม Preview, Print และ Share
- Google Sign-In และการเลือกไฟล์ Google Sheets จาก Google Drive
- ดึงเวลาสร้างไฟล์ครั้งแรกและข้อมูลจากแท็บแรกของชีต พร้อมกำหนดคอลัมน์
  ผู้ยกเวร ผู้รับเวร วันที่ เวร ประเภท เหตุผล และหมายเหตุ
- สร้างคำขอยกเวร/รับเวรจากแถวในชีตที่จับคู่กับบุคลากรและตารางหลักได้
- แนบไฟล์ต้นฉบับ CSV/TSV/XLSX จากเครื่องและเปรียบเทียบกับ Google Sheets
  ที่เลือกด้วย SHA-256 จำนวนแถว และผลต่างระดับเซลล์
- ระบบยกเวร/แลกเวร พร้อมตอบรับ อนุมัติ ปฏิเสธ ยกเลิก และ Preview
  ตรวจเวลาทับซ้อนกับเวลาพักขั้นต่ำก่อนอนุมัติ
- กฎเวรส่วนกลาง: เวรซ้ำ เวลาทับซ้อน ชั่วโมงพัก ชั่วโมงต่อเนื่อง
  และจำนวนเวรสูงสุดต่อวัน/สัปดาห์/เดือน โดยกำหนดค่าได้ใน Settings
- คำนวณค่าตอบแทนพื้นฐาน OT และวันหยุดจากเวรที่อนุมัติ
- Google Calendar Preview/Sync รายบุคคล รองรับ Create/Update/Delete
  และใช้รหัสกำกับรายการเพื่อซิงค์ซ้ำโดยไม่สร้างเวรซ้ำ
- ธีม System/Light/Dark และ UI แบบ responsive

การจัดเวรอัตโนมัติ สิทธิ์ผู้อนุมัติ/การแจ้งเตือน การส่งออก Payroll
การนำเข้า Excel เป็นตารางเวรเต็มรูปแบบ และประวัติ/Retry ของ Calendar
ยังอยู่ในแผนพัฒนาระยะถัดไป ดูรายละเอียดใน [Roadmap](docs/ROADMAP.md)

## ติดตั้งสำหรับผู้ใช้งาน

### ใช้งานผ่านเว็บ

1. เปิด [Web UI](https://phakphoum38-stack.github.io/shift-calendar-engine-3-rebuilt/)
2. รอให้แอปโหลดจนเห็นหน้า Dashboard
3. ไปที่ **Settings** เพื่อเลือกภาษา ธีม และกฎเวร
4. หากต้องการทดสอบก่อนกรอกข้อมูลจริง ให้เปิด **Demo mode**
5. หากต้องการใช้ Drive, Sheets หรือ Calendar ให้ทำตามหัวข้อการตั้งค่า
   Google ด้านล่าง

หากติดตั้งเว็บเป็นแอปจากเมนู **Install app** หรือ **Add to Home Screen**
ข้อมูลยังคงผูกกับพื้นที่จัดเก็บของเบราว์เซอร์เดิม การถอนแอปหรือล้าง Site data
อาจลบข้อมูลได้

### Android APK จาก GitHub Actions

โปรเจกต์ยังไม่มีแพ็กเกจบน Play Store แต่สามารถดาวน์โหลด APK ที่ workflow
สร้างไว้ได้:

1. เปิดหน้า [GitHub Actions](https://github.com/phakphoum38-stack/shift-calendar-engine-3-rebuilt/actions)
2. เลือก workflow **Release Artifacts**
3. เปิด run ที่สำเร็จ หรือกด **Run workflow** หากมีสิทธิ์
4. ดาวน์โหลด Android APK จากหัวข้อ **Artifacts**
5. แตกไฟล์ ZIP แล้วติดตั้ง APK
6. Android อาจถามสิทธิ์ติดตั้งจากแหล่งภายนอก ให้ยืนยันเฉพาะไฟล์ที่ดาวน์โหลด
   จาก repository นี้

APK จาก workflow เป็นชุดทดสอบและยังไม่ได้ใช้ production signing สำหรับ
เผยแพร่ผ่าน Play Store

### Windows, macOS, Linux และ iOS

ยังไม่มี installer ที่ลงนามเผยแพร่โดยตรง ผู้ใช้หรือนักพัฒนาต้อง build
จาก Source code บนระบบปฏิบัติการที่รองรับ หรือดาวน์โหลด artifact ที่ workflow
สร้างสำเร็จ ทั้งนี้ iOS ต้องใช้ macOS, Xcode และบัญชี Apple Developer
สำหรับการติดตั้งบนอุปกรณ์จริง

## ติดตั้งสำหรับนักพัฒนา

### สิ่งที่ต้องมี

- Git
- Flutter stable ที่รองรับ Dart 3.12.2 ขึ้นไป
- Chrome สำหรับ Web
- Toolchain ของแพลตฟอร์มที่ต้องการตามผล `flutter doctor -v`

ข้อกำหนดเพิ่มเติม:

| เป้าหมาย | เครื่องมือ |
|---|---|
| Android | Android Studio, Android SDK, emulator หรืออุปกรณ์ และ JDK ที่ Flutter รองรับ |
| iOS/macOS | เครื่อง macOS, Xcode และ CocoaPods |
| Windows | Windows และ Visual Studio พร้อม Desktop development with C++ |
| Linux | Clang, CMake, Ninja, pkg-config และ GTK 3 development libraries |
| Web | Chrome หรือเบราว์เซอร์ที่ Flutter รองรับ |

### Clone และเตรียมโปรเจกต์

```bash
git clone https://github.com/phakphoum38-stack/shift-calendar-engine-3-rebuilt.git
cd shift-calendar-engine-3-rebuilt
flutter doctor -v
flutter pub get
flutter gen-l10n
```

ตรวจว่าโปรเจกต์พร้อมทำงาน:

```bash
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
```

### รันบนเครื่อง

ดูอุปกรณ์ที่ Flutter ตรวจพบ:

```bash
flutter devices
```

ตัวอย่างคำสั่ง:

```bash
flutter run -d chrome
flutter run -d android
flutter run -d windows
flutter run -d macos
flutter run -d linux
```

สำหรับทดสอบ Google Sign-In บน Web ให้ใช้พอร์ตคงที่และเพิ่ม origin นี้ใน
Google Cloud ก่อน:

```bash
flutter run -d chrome --web-hostname localhost --web-port 7357
```

Authorized JavaScript origins สำหรับการพัฒนาบนเครื่อง:

```text
http://localhost
http://localhost:7357
```

## ตั้งค่า Google Sign-In, Google Drive, Google Sheets และ Google Calendar

Web UI ใช้ OAuth Client ID ต่อไปนี้เป็นค่าเริ่มต้น:

```text
667656026445-pffm0rtkaiunhfujgfv52dlfb6pbtnm2.apps.googleusercontent.com
```

OAuth Client ID เป็นตัวระบุสาธารณะที่ฝังในเว็บได้ แต่โปรเจกต์จะไม่เก็บ
Client Secret, access token หรือ refresh token ไว้ใน Source code

การตั้งค่า Google Cloud สำหรับ Client ID นี้:

1. เปิด [Google Cloud Console](https://console.cloud.google.com/)
2. เลือกโปรเจกต์ที่เป็นเจ้าของ Client ID
3. เปิด **APIs & Services > Library**
4. เปิดใช้งาน **Google Drive API**, **Google Sheets API** และ
   **Google Calendar API**
5. เปิด **Google Auth Platform** หรือ **OAuth consent screen**
6. กำหนดชื่อแอป อีเมลผู้ดูแล และข้อมูลที่ Google กำหนด
7. เลือก Audience ให้ตรงกับการใช้งาน หากอยู่ในโหมด Testing ให้เพิ่มบัญชี
   Google ที่จะใช้ใน **Test users**
8. เปิด **APIs & Services > Credentials**
9. เปิด Client ID ด้านบนและตรวจว่า Application type เป็น
   **Web application**
10. เพิ่มค่า **Authorized JavaScript origins**:

    ```text
    https://phakphoum38-stack.github.io
    ```

11. ไม่ต้องใส่ path `/shift-calendar-engine-3-rebuilt/` ต่อท้าย origin
12. กด Save และรอให้การตั้งค่าเผยแพร่
13. เปิด Web UI ไปที่ **Roster** แล้วเลื่อนลงไปที่ **Google Drive**
14. กด **Sign in with Google** และเลือกบัญชี
15. อนุญาตสิทธิ์ Drive metadata, Sheets read และ Calendar events ตามที่แอปขอ

ค่า Client ID สามารถตรวจหรือเปลี่ยนเฉพาะอุปกรณ์ได้ที่
**Settings > Web OAuth Client ID** จากนั้นกด Save และโหลดหน้าเว็บใหม่
Client ID ที่เปลี่ยนใน Settings จะถูกบันทึกเฉพาะอุปกรณ์นั้น

เมื่อเพิ่มสิทธิ์ Calendar เป็นครั้งแรก ผู้ใช้เดิมต้องออกจากระบบแล้ว
ลงชื่อเข้าใช้อีกครั้งเพื่อยืนยันสิทธิ์ใหม่

### สิทธิ์ Google ที่แอปใช้

| บริการ | วัตถุประสงค์ |
|---|---|
| Google Sign-In | ระบุบัญชี Google ที่ผู้ใช้เลือก |
| Drive metadata read-only | ค้นหาไฟล์และอ่านชื่อ เวลาแก้ไข/เวลาสร้าง และเจ้าของไฟล์ |
| Sheets read-only | อ่านข้อมูลจากแท็บแรกของ Google Sheets ที่เลือก |
| Calendar events | Preview และสร้าง/แก้ไข/ลบเฉพาะรายการที่แอปกำกับไว้ |

ระบบ Calendar ใช้ private extended properties เพื่อผูก Schedule, Employee
และ Assignment กับ event การซิงค์ซ้ำจึงไม่ควรสร้างรายการเดิมซ้ำ และระบบจะ
ไม่ลบ event ทั่วไปที่ไม่ได้สร้างโดยแอปนี้

## คู่มือการใช้งาน

### 1. ตั้งค่าภาษา ธีม และโหมดตรรกะ

เปิด **Settings**:

1. เลือกภาษา **System**, **ไทย** หรือ **English**
2. เลือกธีม **System**, **Light** หรือ **Dark**
3. เลือกตรรกะ **Standard** หรือ **Freestyle**
4. เปิด Demo mode หากต้องการข้อมูลตัวอย่าง

ภาษาและธีมมีผลทันที ส่วนการตั้งค่า OAuth บางรายการต้องโหลดหน้าเว็บใหม่

### 2. ตั้งค่ากฎเวร

ใน **Settings > Roster rules and policy** กำหนด:

- ชั่วโมงพักขั้นต่ำระหว่างเวร
- ชั่วโมงทำงานต่อเนื่องสูงสุด
- จำนวนเวรสูงสุดต่อวัน ต่อสัปดาห์ และต่อเดือน
- การห้ามเวรเวลาทับซ้อน
- การบังคับให้คำขอแลกเวรต้องผ่านการอนุมัติ

กฎชุดเดียวกันถูกใช้ตอนบันทึกตารางเวร ตรวจคำขอแลกเวร และคำนวณผลกระทบ
หากพบข้อผิดพลาดระดับบล็อก ระบบจะไม่บันทึกตารางใหม่ทับข้อมูลที่สมบูรณ์เดิม

### 3. จัดการพนักงาน

เปิด **Employees**:

1. ใช้ช่องค้นหาเพื่อค้นหาชื่อหรือรหัสพนักงาน
2. กดเพิ่มพนักงาน
3. กรอกรหัส ชื่อ นามสกุล แผนก และตำแหน่ง
4. กด Save
5. เลือกรายการเดิมเพื่อแก้ไข
6. ปิด Active เมื่อต้องการปิดใช้งาน โดยไม่ลบประวัติเวรเดิม

รหัสพนักงานต้องไม่ซ้ำ หากใช้รหัสเดิมระบบจะปฏิเสธการบันทึก

### 4. จัดการรูปแบบเวร

เปิด **Settings > Shift templates** แล้วเพิ่มหรือแก้ไข:

- รหัสและชื่อเวร
- เวลาเริ่มและเวลาสิ้นสุด
- ชั่วโมงทำงาน
- สีประจำเวร
- ค่าตอบแทน
- สถานะ Active

เวรข้ามเที่ยงคืนคำนวณวันสิ้นสุดเป็นวันถัดไป รหัสเวรต้องไม่ซ้ำ และควร
ปิดใช้งานแทนการลบรูปแบบที่เคยถูกใช้ในตาราง

### 5. เพิ่ม แก้ไข และลบเวรรายวัน

เปิด **Roster > Manual roster editor**:

1. เลือกวันที่
2. เลือกพนักงาน
3. เลือกรูปแบบเวร
4. ใส่สถานที่และหมายเหตุถ้าต้องการ
5. กด Preview เพื่อตรวจผล
6. ตรวจคำเตือนเรื่องเวรซ้ำ เวรทับ ชั่วโมงพัก และจำนวนเวรสูงสุด
7. ยืนยันการเพิ่มหรือแก้ไข
8. กด **Save** เพื่อบันทึกลงเครื่องอย่างชัดเจน

การลบเวรต้อง Preview และยืนยันเช่นกัน หากการเขียนข้อมูลล้มเหลว ระบบจะ
รักษาข้อมูลชุดล่าสุดที่บันทึกสมบูรณ์ไว้

### 6. ดู Dashboard

หน้า **Dashboard** แสดง:

- จำนวนเวรวันนี้และวันพรุ่งนี้
- จำนวนเวรในเดือน
- รายได้โดยประมาณจากค่าตอบแทนของเวรที่อนุมัติ
- OT โดยประมาณตาม threshold และ multiplier ใน policy

ตัวเลขเป็นค่าประมาณจากรูปแบบเวร ไม่ใช่ใบเงินเดือนทางบัญชี และยังไม่รวม
รายการหัก ภาษี หรือสวัสดิการ

### 7. ยกเวร รับเวร และแลกเวร

เปิด **Exchange** เพื่อ:

1. สร้างคำขอจากเวรต้นทาง
2. เลือกผู้รับหรือคู่แลกเวร
3. ระบุเหตุผลและหมายเหตุ
4. ให้ผู้รับตอบรับ
5. Preview กฎเวรก่อนอนุมัติ
6. อนุมัติ ปฏิเสธ หรือยกเลิกคำขอ

ตารางหลักจะเปลี่ยนเจ้าของเวรหลังอนุมัติสำเร็จเท่านั้น หากเกิดข้อผิดพลาด
ระหว่างบันทึก ระบบจะย้อนกลับไปยัง Schedule ก่อนหน้า

### 8. เลือกไฟล์ Google Sheets

เปิด **Roster** แล้วเลื่อนไปที่แผง **Google Drive**:

1. ลงชื่อเข้าใช้ Google
2. กดเปิด/รีเฟรช Google Drive
3. ระบบจัดกลุ่มไฟล์ตามเดือนและเลือกไฟล์ที่แก้ไขเก่าที่สุดเมื่อเดือนเดียวกัน
   มีหลายไฟล์
4. เลือกโหมดอ่าน **Configured** หรือ **Standard**
5. เลือกไฟล์ที่ต้องการ
6. กดโหลดข้อมูลปัจจุบัน หรือดึง Timeline/แท็บแรก
7. กำหนดแถวหัวตารางและจับคู่คอลัมน์ ผู้ยกเวร ผู้รับ วันที่ เวร ประเภท
   เหตุผล และหมายเหตุ
8. ตรวจ Preview ก่อนสร้างคำขอยกเวร/รับเวร

เวลาสร้างครั้งแรกอ่านจาก Drive metadata ส่วนค่าของเซลล์อ่านจากแท็บแรก
ฉบับปัจจุบัน ไม่ใช่ข้อมูลเซลล์ใน revision แรก

### 9. แนบไฟล์ต้นฉบับเพื่อเปรียบเทียบ

ในแผง Google Drive:

1. กด **Attach original file**
2. เลือก CSV, TSV หรือ XLSX จากเครื่อง
3. โหลด Timeline ของ Sheet ที่เลือก
4. ตรวจ SHA-256 จำนวนแถว เซลล์ที่ตรง/ต่าง และแถวที่มีเฉพาะแต่ละแหล่ง
5. นำผลเปรียบเทียบไปประกอบการตัดสินใจก่อนสร้างคำขอหรือซิงค์

ไฟล์แนบใช้เพื่อเปรียบเทียบในหน่วยความจำ ไม่ควร commit ไฟล์ตารางจริงเข้า
repository

### 10. ซิงค์ Google Calendar

1. ลงชื่อเข้าใช้ Google ในแผง Drive ก่อน
2. ไปที่แผง **Google Calendar sync**
3. เลือกพนักงาน
4. กด **Preview sync**
5. ตรวจรายการ Create, Update, Delete และ No change
6. กด **Sync calendar** เมื่อผล Preview ถูกต้อง

ระบบซิงค์เฉพาะเวรที่อนุมัติลงปฏิทินหลักของบัญชีที่ลงชื่อเข้าใช้ การกดซิงค์
ซ้ำจะอัปเดตรายการที่ผูกไว้แทนการสร้างรายการซ้ำ

### 11. สร้าง PDF, Preview, Print และ Share

เปิด **Reports**:

1. เลือกเดือน
2. เลือกแผนกหากต้องการกรอง
3. เลือกภาษาไทยหรืออังกฤษ
4. กด Preview
5. ตรวจตาราง A4 แนวนอน สัญลักษณ์เวร สถิติ และหมายเหตุ
6. กด Print หรือ Share PDF

ภาษาไทยแสดงปี พ.ศ. ส่วนภาษาอังกฤษแสดง ค.ศ. ภายในระบบยังเก็บวันที่เป็น
Gregorian เพื่อให้การคำนวณและการซิงค์ถูกต้อง

## ข้อมูล การบันทึก และความปลอดภัย

- Schedule เป็นแหล่งข้อมูลตารางเวรหลักเพียงชุดเดียว
- ข้อมูลถูกเก็บใน SharedPreferences/พื้นที่ local ของแอปหรือเบราว์เซอร์
- การบันทึก Schedule ใช้ข้อมูลแบบ versioned และ staged/atomic
- หากเขียนชุดใหม่ไม่สำเร็จ ระบบจะรักษาชุดล่าสุดที่สมบูรณ์
- การซิงค์ Schedule เดิมซ้ำใช้รหัสคงที่เพื่อลดรายการซ้ำ
- การล้าง Site data, ล้างข้อมูลแอป หรือถอนการติดตั้งอาจลบข้อมูล
- Backup/Restore ข้ามเครื่องแบบเต็มรูปแบบยังอยู่ใน Roadmap
- ห้าม commit Client Secret, token, service-account key, ตารางเวรจริง
  หรือข้อมูลส่วนบุคคล

ก่อนใช้ข้อมูลจริงควรทดสอบ workflow ด้วยข้อมูลตัวอย่างและเก็บสำเนาต้นฉบับ
นอกแอปไว้เสมอ

## การแก้ปัญหา

### ปุ่ม Google ไม่แสดง

1. ตรวจว่า Authorized JavaScript origin เป็น
   `https://phakphoum38-stack.github.io` เท่านั้น ไม่ใส่ path
   `/shift-calendar-engine-3-rebuilt/`
2. หลังแก้ Google Cloud ให้กด Save และรอการตั้งค่าเผยแพร่ประมาณ 5 นาที
3. เปิด [Web UI](https://phakphoum38-stack.github.io/shift-calendar-engine-3-rebuilt/)
   ใหม่ หรือรีเฟรชแบบไม่ใช้ cache
4. ไปที่ **Settings** และตรวจว่า Web OAuth Client ID ตรงกับค่าด้านบน
5. กลับไปที่ **Roster** แล้วเลื่อนลงไปยังแผง **Google Drive**
6. หากมีข้อความ `origin_mismatch` ให้ตรวจ Authorized JavaScript origin
   อีกครั้ง หากมี `access_denied` ให้ตรวจ Test users และสถานะ consent screen

### ลงชื่อเข้าใช้แล้วแต่ Drive หรือ Calendar ใช้งานไม่ได้

- ตรวจว่าเปิด Drive API, Sheets API และ Calendar API ในโปรเจกต์เดียวกับ
  Client ID
- ออกจากระบบแล้วลงชื่อเข้าใช้อีกครั้งเพื่อขอ scope ใหม่
- ตรวจว่าไฟล์ Sheet อยู่ในบัญชีที่ลงชื่อเข้าใช้หรือแชร์ให้บัญชีนั้น
- หาก token หมดอายุ ให้ลงชื่อเข้าใช้อีกครั้ง
- ตรวจข้อความผิดพลาดในแผง Google ก่อนแก้การตั้งค่า

### แอปยังเป็นเวอร์ชันเก่า

- เปิด URL ใหม่โดยเติม query เช่น `?v=latest`
- กดรีเฟรชแบบไม่ใช้ cache
- ปิดแท็บเดิมแล้วเปิด Web UI ใหม่
- ตรวจ workflow **Deploy Flutter Web** ว่าสำเร็จ

### ข้อมูลไม่แสดงหรือหาย

- ตรวจว่าใช้เครื่อง เบราว์เซอร์ และ browser profile เดิม
- อย่าล้าง Site data ก่อนสำรองข้อมูลต้นฉบับ
- Demo mode เป็นข้อมูลตัวอย่างและไม่ควรใช้แทนข้อมูลจริง
- หากการบันทึกแจ้งข้อผิดพลาด ให้คงหน้าไว้และตรวจข้อขัดแย้งก่อนลองใหม่

### Build หรือ test ไม่ผ่าน

```bash
flutter doctor -v
flutter pub get
flutter gen-l10n
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
```

หาก generated files ไม่ตรงให้รัน `flutter gen-l10n` ก่อน หาก dependency
มีปัญหาให้ตรวจ `flutter pub outdated` แต่ไม่ควรอัปเกรด major version
โดยไม่ทดสอบทุกแพลตฟอร์ม

## OpenAI API

ไฟล์ Web บน GitHub Pages จะไม่เรียก OpenAI API ด้วยคีย์โดยตรง เพราะผู้ใช้
สามารถอ่านคีย์ที่ฝังใน JavaScript ได้ คีย์ใน `.env.local` ใช้เฉพาะการพัฒนา
บนเครื่องและถูกกันออกจาก Git แล้ว การเปิดใช้คำสั่ง AI ใน production
ต้องวาง backend proxy ที่เก็บ `OPENAI_API_KEY` เป็น secret ก่อน

ห้าม commit Client Secret, service-account key, token, ข้อมูลตารางเวรจริง
หรือข้อมูลส่วนบุคคลลง repository

## การทดสอบและสร้างไฟล์ Release

```bash
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
```

สร้างไฟล์ตามแพลตฟอร์มที่ host รองรับ:

```bash
flutter build web --release \
  --base-href "/shift-calendar-engine-3-rebuilt/"
flutter build apk --release
flutter build appbundle --release
flutter build windows --release
flutter build macos --release
flutter build linux --release
flutter build ios --release --no-codesign
```

Windows ต้อง build บน Windows, macOS/iOS ต้อง build บน macOS และ Linux
ต้อง build บน Linux การเผยแพร่จริงต้องตั้งค่า signing ของแต่ละแพลตฟอร์มเอง

GitHub Actions จะ build และ deploy GitHub Pages อัตโนมัติเมื่อมีการ push
เข้า branch `main`

## GitHub Actions

โปรเจกต์มี workflow ดังนี้:

- **Validate Flutter** — ตรวจ format, analyze และ test เมื่อ push หรือเปิด PR
- **Security** — ตรวจ dependency และ secret พร้อมรันตามตารางทุกสัปดาห์
- **Build Platforms** — build Web, Android, Linux, Windows, macOS และ iOS
  เมื่อ push เข้า `main`
- **Deploy Flutter Web** — build และ deploy Web UI ไปยัง GitHub Pages
- **Release Artifacts** — build Web และ Android APK สำหรับดาวน์โหลด
  โดยกด **Run workflow** หรือ push tag ที่ขึ้นต้นด้วย `v`

ดาวน์โหลดไฟล์จากหน้า
[GitHub Actions](https://github.com/phakphoum38-stack/shift-calendar-engine-3-rebuilt/actions):

1. เปิด workflow **Release Artifacts**
2. กด **Run workflow** และเลือก branch `main`
3. รอ job สำเร็จ
4. เปิดผลการรัน แล้วดาวน์โหลด Web หรือ Android APK จากหัวข้อ **Artifacts**

ไฟล์ artifact เก็บไว้ 14 วัน Android APK จาก workflow นี้เป็นแพ็กเกจทดสอบ
ที่ยังไม่ได้ลงนามด้วย production signing key สำหรับเผยแพร่ผ่าน Play Store

## โครงสร้างระบบ

```text
Presentation
    ↓
Application controllers and services
    ↓
Domain entities and repository contracts
    ↑
Infrastructure repository implementations
```

`Schedule` เป็นแหล่งข้อมูลตารางเวรหลักเพียงชุดเดียว และ
`AppDependencies` ทำหน้าที่ประกอบ dependency ของแอป

เอกสารเพิ่มเติม:

- [Architecture](docs/ARCHITECTURE.md)
- [Installation](docs/INSTALLATION.md)
- [User guide](docs/USER_GUIDE.md)
- [Testing](docs/TESTING.md)
- [Contributing](CONTRIBUTING.md)
- [Security](SECURITY.md)

## License

ยังไม่ได้เลือก License สำหรับการนำ Source code ไปใช้ต่อ
การที่ repository เปิดให้อ่านได้ไม่ได้หมายความว่าอนุญาตให้นำไปใช้
ดัดแปลง หรือเผยแพร่โดยอัตโนมัติ

# Shift Calendar Engine 3.0

[![Validate Flutter](https://github.com/phakphoum38-stack/shift-calendar-engine-3-rebuilt/actions/workflows/validate.yml/badge.svg?branch=main)](https://github.com/phakphoum38-stack/shift-calendar-engine-3-rebuilt/actions/workflows/validate.yml)
[![Security](https://github.com/phakphoum38-stack/shift-calendar-engine-3-rebuilt/actions/workflows/security.yml/badge.svg?branch=main)](https://github.com/phakphoum38-stack/shift-calendar-engine-3-rebuilt/actions/workflows/security.yml)
[![Deploy Flutter Web](https://github.com/phakphoum38-stack/shift-calendar-engine-3-rebuilt/actions/workflows/deploy-pages.yml/badge.svg?branch=main)](https://github.com/phakphoum38-stack/shift-calendar-engine-3-rebuilt/actions/workflows/deploy-pages.yml)

ระบบจัดตารางเวรบุคลากรแบบข้ามแพลตฟอร์ม พัฒนาด้วย Flutter รองรับ Web,
Android, iOS, Windows, macOS และ Linux พร้อม UI ภาษาไทยและอังกฤษ

## เปิดใช้งาน

- [เปิด Web UI บน GitHub Pages](https://phakphoum38-stack.github.io/shift-calendar-engine-3-rebuilt/)
- [ดู Source code บน GitHub](https://github.com/phakphoum38-stack/shift-calendar-engine-3-rebuilt)

ข้อมูลที่บันทึกใน Web UI จะอยู่ในพื้นที่จัดเก็บของเบราว์เซอร์เครื่องนั้น
การล้างข้อมูลเว็บไซต์หรือถอนการติดตั้งแอปอาจทำให้ข้อมูลสูญหาย

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

## ตั้งค่า Google Sign-In และ Google Drive

Web UI ใช้ OAuth Client ID ต่อไปนี้เป็นค่าเริ่มต้น:

```text
667656026445-pffm0rtkaiunhfujgfv52dlfb6pbtnm2.apps.googleusercontent.com
```

OAuth Client ID เป็นตัวระบุสาธารณะที่ฝังในเว็บได้ แต่โปรเจกต์จะไม่เก็บ
Client Secret, access token หรือ refresh token ไว้ใน Source code

การตั้งค่า Google Cloud สำหรับ Client ID นี้:

1. เปิดโปรเจกต์ที่เป็นเจ้าของ Client ID ใน Google Cloud Console
2. ตั้งค่า OAuth consent screen
3. เปิดใช้งาน **Google Drive API**, **Google Sheets API** และ
   **Google Calendar API**
4. ตรวจว่า OAuth Client ID เป็นชนิด **Web application**
5. เพิ่มค่า **Authorized JavaScript origins** ต่อไปนี้:
   `https://phakphoum38-stack.github.io`
6. หาก OAuth consent screen อยู่ในโหมด Testing ให้เพิ่มบัญชีที่จะใช้ใน
   **Test users**
7. เปิด Web UI แล้วไปหน้า **Roster > Google Drive**
8. กดปุ่ม **Sign in with Google**

เมื่อเพิ่มสิทธิ์ Calendar เป็นครั้งแรก ผู้ใช้เดิมต้องออกจากระบบแล้ว
ลงชื่อเข้าใช้อีกครั้งเพื่อยืนยันสิทธิ์ใหม่

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

## OpenAI API

ไฟล์ Web บน GitHub Pages จะไม่เรียก OpenAI API ด้วยคีย์โดยตรง เพราะผู้ใช้
สามารถอ่านคีย์ที่ฝังใน JavaScript ได้ คีย์ใน `.env.local` ใช้เฉพาะการพัฒนา
บนเครื่องและถูกกันออกจาก Git แล้ว การเปิดใช้คำสั่ง AI ใน production
ต้องวาง backend proxy ที่เก็บ `OPENAI_API_KEY` เป็น secret ก่อน

ห้าม commit Client Secret, service-account key, token, ข้อมูลตารางเวรจริง
หรือข้อมูลส่วนบุคคลลง repository

## รันบนเครื่อง

ต้องมี Flutter stable ที่รองรับ Dart 3.12 ขึ้นไป และ toolchain
ของแพลตฟอร์มที่ต้องการรัน

```bash
git clone https://github.com/phakphoum38-stack/shift-calendar-engine-3-rebuilt.git
cd shift-calendar-engine-3-rebuilt
flutter pub get
flutter gen-l10n
flutter run -d chrome
```

ตรวจสอบคุณภาพโค้ด:

```bash
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
```

สร้าง Web release สำหรับ GitHub Pages:

```bash
flutter build web --release \
  --base-href "/shift-calendar-engine-3-rebuilt/"
```

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

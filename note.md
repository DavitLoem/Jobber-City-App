1. ដំណាក់កាលទី ១៖ ការបញ្ជូនទិន្នន័យពី Mobile App
   - សកម្មភាពអ្នកប្រើប្រាស់៖ បេក្ខជនជ្រើសរើសឯកសារ PDF ពីទូរស័ព្ទដៃរបស់ពួកគេ។
   - UI/UX៖ អេក្រង់នឹងបង្ហាញផ្ទាំង Loading (មានព្រិលផ្ទៃខាងក្រោយ) ជាមួយប៊ូតុង "Cancel" ក្នុងករណីដែលពួកគេចង់បោះបង់។
   - ដំណើរការ៖ Flutter ប្រើប្រាស់ Dio ដើម្បីបញ្ជូនឯកសារជាទម្រង់ FormData ទៅកាន់ API POST /seeker/profile/upload-cv។

2. ដំណាក់កាលទី ២៖ ការត្រួតពិនិត្យ និងវិភាគដោយ AI (Backend)
   - ការត្រួតពិនិត្យបឋម៖ FastAPI ទទួលយកឯកសារ ឆែកមើលថាវាជា PDF ពិតប្រាកដ និងមានទំហំមិនលើសពី 5MB។
   - ទាញយកអត្ថបទ៖ ប្រព័ន្ធប្រើប្រាស់ pdf_extractor ដើម្បីបំប្លែងឯកសារ PDF ទៅជាអត្ថបទឆៅ (Raw Text)។
   - វិភាគដោយ Gemini AI: អត្ថបទឆៅត្រូវបានបញ្ជូនទៅ Google Gemini ដើម្បីធ្វើការវិភាគ។
   - លទ្ធផលពី AI៖ Gemini នឹងវាយតម្លៃថាវាជា CV ពិតប្រាកដឬអត់ (is_cv) និងទាញយកទិន្នន័យរៀបចំជាទម្រង់ JSON ដែលមានបែងចែកជា៖
     personal_info, experiences, educations, និង skills។

3. ដំណាក់កាលទី ៣៖ ការរក្សាទុកឯកសារ និងអាប់ដេត Profile គោល
   - ការរក្សាទុកឯកសារ៖ ប្រសិនបើវាជា CV ពិតមែន Backend នឹង Upload ឯកសារនោះទៅកាន់ Cloudinary (ក្នុងទម្រង់ raw ដើម្បីកុំឱ្យមានបញ្ហា)។ ប្រសិនបើគាត់ធ្លាប់មាន CV ចាស់ ប្រព័ន្ធនឹងលុប CV ចាស់ចេញពី Cloudinary ជាមុនសិន។
   - អាប់ដេត Database: ធ្វើការ Update resume_url, resume_filename, និង resume_public_id ចូលទៅក្នុង seeker_profiles_collection ព្រមទាំងគណនាភាគរយ Profile (Completion Percentage) សាជាថ្មី។
   - ចំណុចពិសេស៖ ប្រព័ន្ធនឹង មិនទាន់ រក្សាទុកទិន្នន័យបទពិសោធន៍ ឬការសិក្សាដែល AI ទាញយកបានទៅក្នុង Database ភ្លាមៗនោះទេ ដើម្បីទុកសិទ្ធិឱ្យបេក្ខជនត្រួតពិនិត្យ (Review) សិន។

4. ដំណាក់កាលទី ៤៖ ការបង្ហាញ និងត្រួតពិនិត្យទិន្នន័យ (Review Data)
   - បញ្ជូនទិន្នន័យត្រឡប់៖ Backend បោះទិន្នន័យ JSON ដែលបានរៀបចំរួចនោះ ត្រឡប់ទៅឱ្យ Frontend វិញ។
   - UI/UX ទទួលលទ្ធផល៖ Flutter ទទួលទិន្នន័យ និងបង្ហាញផ្ទាំង BottomSheet ("Scan Complete!") ប្រាប់ពីចំនួនបទពិសោធន៍ និងការសិក្សាដែលរកឃើញ។ - ប៊ូតុង Review Data: នៅពេលបេក្ខជនចុចប៊ូតុង "Review Data" ពួកគេនឹងត្រូវបញ្ជូនទៅកាន់អេក្រង់ថ្មីមួយ ដើម្បីមើល កែសម្រួល ឬលុបចោលនូវព័ត៌មានដែល AI អាចទាញយកខុស មុននឹងសម្រេចចិត្តចុច "Save & Update Profile"។

---

1. ផ្នែក Data Model (សម្រាប់ចាប់យក និងគ្រប់គ្រងទិន្នន័យ)
   យើងត្រូវការឯកសារសម្រាប់បំប្លែងទិន្នន័យ JSON ដែលបានមកពី AI ទៅជា Object ដែល Flutter អាចយល់ និងកែប្រែបាន។

- cv_parsed_data_model.dart
  - តួនាទី៖ មានផ្ទុក Classes ដូចជា ParsedDataModel, ExperienceModel, EducationModel, និង PersonalInfoModel។
  - មុខងារ៖ មាន fromJson ដើម្បីទទួលទិន្នន័យពី AI និង toJson ដើម្បីបំប្លែងទិន្នន័យដែលបេក្ខជនបានកែសម្រួលរួច ត្រឡប់ទៅជា JSON វិញពេលចុច Save។

2. ផ្នែក State Management (Controller & Binding)
   ផ្នែកនេះដើរតួជាខួរក្បាលកណ្តាលសម្រាប់គ្រប់គ្រងទិន្នន័យនៅលើអេក្រង់ និងការចុចប៊ូតុងផ្សេងៗ។

- cv_review_controller.dart
  - តួនាទី៖ ទទួលទិន្នន័យបន្តពី CvExtractionViewController នៅពេលបេក្ខជនចុចប៊ូតុង "Review Data"។ មុខងារ៖
    - បង្កើតមុខងារ Add, Edit, Delete សម្រាប់ Experience និង Education (ឧ. ពេលបេក្ខជនចង់លុបបទពិសោធន៍ណាដែល AI ទាញយកមកខុស)។
    - បង្កើតមុខងារគ្រប់គ្រងបញ្ជីជំនាញ (Skills) ដូចជាការថែម ឬលុប Skill ចេញ។
    - មានមុខងារ saveProfile() ដើម្បីបញ្ជូនទិន្នន័យចុងក្រោយទៅកាន់ Backend។

- cv_review_binding.dart
  - តួនាទី៖ សម្រាប់ធ្វើ Dependency Injection (ភ្ជាប់ Controller ទៅកាន់ View នៅពេល Route ត្រូវបានបើក)។

3. ផ្នែក UI / View (អេក្រង់ និងផ្ទាំងបង្ហាញ)
   ដើម្បីកុំឱ្យឯកសារ View គោលមានកូដវែងរាប់ពាន់បន្ទាត់ យើងត្រូវបំបែកវាជា Widget តូចៗដូចដែលយើងបានធ្វើមុននេះ។

- cv_review_view.dart (ឯកសារគោល)
  - តួនាទី៖ ជាអេក្រង់មេដែលមាន Scrollable List បង្ហាញផ្នែកនីមួយៗបន្តបន្ទាប់គ្នា (Personal Info ➔ Experience ➔ Education ➔ Skills) និងមានប៊ូតុង "Save & Update Profile" នៅខាងក្រោមគេ។
  - ថត widgets/ (សម្រាប់ផ្ទុក UI ផ្នែកតូចៗ)
  - personal_info_form.dart: ផ្ទាំងមានប្រអប់ TextFields សម្រាប់កែឈ្មោះ លេខទូរស័ព្ទ និងអ៊ីមែល។
  - experience_section.dart: ផ្ទាំងបង្ហាញបញ្ជីកាតបទពិសោធន៍ការងារ និងមានប៊ូតុង "+ Add New"។
  - education_section.dart: ផ្ទាំងបង្ហាញបញ្ជីកាតប្រវត្តិសិក្សា។
  - skill_chips_section.dart: ផ្ទាំងបង្ហាញជំនាញជាទម្រង់ Chips ដែលអាចចុចខ្វែង (x) ដើម្បីលុប និងមានកន្លែងវាយបញ្ចូលថ្មី។
  - experience_bottom_sheet.dart / education_bottom_sheet.dart: ផ្ទាំងលោតឡើងមកលើ (Modal) សម្រាប់ឱ្យបេក្ខជនបំពេញ ឬកែប្រែព័ត៌មានលម្អិតនៃបទពិសោធន៍ ឬការសិក្សាមួយ។

4. ផ្នែក API Service (សម្រាប់ទំនាក់ទំនងជាមួយ Backend)

- cv_review_service.dart (ឬអាចប្រើ profile_service.dart ដែលមានស្រាប់)
  - តួនាទី៖ មានអនុគមន៍សម្រាប់បាញ់ Request (PUT/POST) យកទិន្នន័យដែលបេក្ខជនបាន Review និងកែសម្រួលរួច ទៅ Save ចូលក្នុង Database។

---

ក្រុមទី ១៖ ទិន្នន័យទោល និងសាមញ្ញ (Simple Data)
ក្រុមនេះមិនត្រូវការទំព័រ (Screen) ថ្មីស្មុគស្មាញទេ យើងអាចប្រើត្រឹម BottomSheet ឬ Dialog ដើម្បីកែសម្រួល រួច Save យកតែម្តង។

Biography: គ្រាន់តែជា Text មួយដុំ។ ពេលចុចលើវា លោត BottomSheet មកមាន TextField (maxLines: 5) សម្រាប់វាយបញ្ចូល និងប៊ូតុង Save។

Skills: ជាបញ្ជីនៃពាក្យ (List of Strings)។ ពេលចុចចូល លោតអេក្រង់ ឬ BottomSheet ដែលអាចវាយបញ្ចូលពាក្យ រួច Enter ឱ្យក្លាយជា Chip (ដូច Tag) និងអាចចុចសញ្ញា (x) ដើម្បីលុបវិញ។

ក្រុមទី ២៖ ទិន្នន័យជាបញ្ជីរចនាសម្ព័ន្ធ (List of Objects)
ក្រុមនេះរួមមាន Work Experience, Education Background, Trainings, និង Language។ ដោយសារវាមានព័ត៌មានច្រើន (ឧ. សាលា ជំនាញ ថ្ងៃខែ) យើងត្រូវរៀបចំលំហូរ (Flow) ជា ២ ដំណាក់កាល៖

List Screen (Read & Delete): ពេលចុចពីអេក្រង់ Profile មេ វានឹងចូលមកទំព័រមួយបង្ហាញបញ្ជីកាត (Cards) នៃបទពិសោធន៍ ឬការសិក្សាដែលមានស្រាប់។ ក្នុងកាតនីមួយៗមានប៊ូតុង Edit និងសញ្ញាធុងសំរាម (Delete)។ ខាងក្រោម ឬខាងលើគេ មានប៊ូតុងធំមួយដាក់ថា "+ Add New" (Create)។

Form Screen / BottomSheet (Create & Update): ពេលចុច Add New ឬ Edit វានឹងបើកទម្រង់ (Form) ឱ្យបំពេញព័ត៌មានលម្អិត រួចចុច Save។

ផែនការអនុវត្តជាក់ស្តែងក្នុង Flutter (GetX Pattern)
ដើម្បីរៀបចំរឿងនេះឱ្យមានសណ្តាប់ធ្នាប់ យើងនឹងត្រូវការឯកសារ (Files) ដូចខាងក្រោម៖

១. ផ្នែក Data Model (profile_models.dart)

បង្កើត Model រួមមួយដែលក្តោបយកទិន្នន័យទាំងអស់ពី Backend API (/api/seeker/profile/)។

ក្នុងនោះមាន Sub-models ដូចជា Experience, Education, Training, និង Language។

២. ផ្នែក Service និង Controller (profile_controller.dart)

Read: ទាញយកទិន្នន័យទាំងអស់មកបង្ហាញលើអេក្រង់ Profile មេ។

Create/Update: បង្កើតមុខងារបាញ់ API ទៅ Backend ដើម្បី Save ទិន្នន័យតាមផ្នែកនីមួយៗ (ឧ. updateExperience(), updateBiography())។

Delete: មុខងារបាញ់ API លុបទិន្នន័យតាម ID របស់វា។

៣. ផ្នែក UI (Reusable Widgets)
ដើម្បីសន្សំសំចៃពេល យើងគួរបង្កើត Widget រួមមួយចំនួនដូចជា៖

EmptyStateWidget: សម្រាប់បង្ហាញពេលចូលទៅអត់មានទិន្នន័យ (ឧ. គំនូរព្រាង + អក្សរ "No data added yet")។

InfoCardWidget: កាតស្តង់ដារសម្រាប់បង្ហាញបទពិសោធន៍ ឬការសិក្សា ដែលមានប៊ូតុង Edit/Delete ស្រាប់។

CustomDatePicker: សម្រាប់រើសថ្ងៃខែចូលរៀន ឬធ្វើការ (Start Date - End Date)។

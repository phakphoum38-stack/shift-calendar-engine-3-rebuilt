import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_th.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('th'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Shift Calendar Engine'**
  String get appTitle;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @roster.
  ///
  /// In en, this message translates to:
  /// **'Roster'**
  String get roster;

  /// No description provided for @employees.
  ///
  /// In en, this message translates to:
  /// **'Employees'**
  String get employees;

  /// No description provided for @exchange.
  ///
  /// In en, this message translates to:
  /// **'Exchange'**
  String get exchange;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// No description provided for @nextShift.
  ///
  /// In en, this message translates to:
  /// **'Next shift'**
  String get nextShift;

  /// No description provided for @monthlyAssignments.
  ///
  /// In en, this message translates to:
  /// **'Assignments this month'**
  String get monthlyAssignments;

  /// No description provided for @estimatedIncome.
  ///
  /// In en, this message translates to:
  /// **'Estimated income'**
  String get estimatedIncome;

  /// No description provided for @pendingRequests.
  ///
  /// In en, this message translates to:
  /// **'Pending requests'**
  String get pendingRequests;

  /// No description provided for @calendarStatus.
  ///
  /// In en, this message translates to:
  /// **'Calendar status'**
  String get calendarStatus;

  /// No description provided for @notConnected.
  ///
  /// In en, this message translates to:
  /// **'Not connected'**
  String get notConnected;

  /// No description provided for @noSchedule.
  ///
  /// In en, this message translates to:
  /// **'No schedule data'**
  String get noSchedule;

  /// No description provided for @noScheduleDescription.
  ///
  /// In en, this message translates to:
  /// **'Import or create a roster to begin.'**
  String get noScheduleDescription;

  /// No description provided for @createRoster.
  ///
  /// In en, this message translates to:
  /// **'Create roster'**
  String get createRoster;

  /// No description provided for @importRoster.
  ///
  /// In en, this message translates to:
  /// **'Import roster'**
  String get importRoster;

  /// No description provided for @previousMonth.
  ///
  /// In en, this message translates to:
  /// **'Previous month'**
  String get previousMonth;

  /// No description provided for @nextMonth.
  ///
  /// In en, this message translates to:
  /// **'Next month'**
  String get nextMonth;

  /// No description provided for @monthOverview.
  ///
  /// In en, this message translates to:
  /// **'Month overview'**
  String get monthOverview;

  /// No description provided for @employeeDirectory.
  ///
  /// In en, this message translates to:
  /// **'Employee directory'**
  String get employeeDirectory;

  /// No description provided for @employeeDirectoryDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage people used by roster assignments.'**
  String get employeeDirectoryDescription;

  /// No description provided for @noEmployees.
  ///
  /// In en, this message translates to:
  /// **'No employees yet'**
  String get noEmployees;

  /// No description provided for @exchangeRequests.
  ///
  /// In en, this message translates to:
  /// **'Shift exchange requests'**
  String get exchangeRequests;

  /// No description provided for @exchangeDescription.
  ///
  /// In en, this message translates to:
  /// **'Requests, approvals, and history will use the canonical roster.'**
  String get exchangeDescription;

  /// No description provided for @noRequests.
  ///
  /// In en, this message translates to:
  /// **'No exchange requests'**
  String get noRequests;

  /// No description provided for @reportCenter.
  ///
  /// In en, this message translates to:
  /// **'Report center'**
  String get reportCenter;

  /// No description provided for @reportDescription.
  ///
  /// In en, this message translates to:
  /// **'Printable and exportable schedule reports.'**
  String get reportDescription;

  /// No description provided for @noReports.
  ///
  /// In en, this message translates to:
  /// **'No report data'**
  String get noReports;

  /// No description provided for @workspaceSettings.
  ///
  /// In en, this message translates to:
  /// **'Workspace settings'**
  String get workspaceSettings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @followSystem.
  ///
  /// In en, this message translates to:
  /// **'Follow system'**
  String get followSystem;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @thai.
  ///
  /// In en, this message translates to:
  /// **'Thai'**
  String get thai;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @systemTheme.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get systemTheme;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkTheme;

  /// No description provided for @demoMode.
  ///
  /// In en, this message translates to:
  /// **'Demo mode'**
  String get demoMode;

  /// No description provided for @demoModeDescription.
  ///
  /// In en, this message translates to:
  /// **'Use deterministic sample data without external accounts.'**
  String get demoModeDescription;

  /// No description provided for @logicMode.
  ///
  /// In en, this message translates to:
  /// **'Logic mode'**
  String get logicMode;

  /// No description provided for @logicModeDescription.
  ///
  /// In en, this message translates to:
  /// **'Use built-in rules or user-defined behavior for each feature.'**
  String get logicModeDescription;

  /// No description provided for @standardLogic.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get standardLogic;

  /// No description provided for @freestyleLogic.
  ///
  /// In en, this message translates to:
  /// **'Freestyle'**
  String get freestyleLogic;

  /// No description provided for @phaseStatus.
  ///
  /// In en, this message translates to:
  /// **'SCE 3.0 foundation'**
  String get phaseStatus;

  /// No description provided for @phaseStatusDescription.
  ///
  /// In en, this message translates to:
  /// **'Canonical roster, explicit dependencies, responsive navigation, localization, and tests are active.'**
  String get phaseStatusDescription;

  /// No description provided for @addEmployee.
  ///
  /// In en, this message translates to:
  /// **'Add employee'**
  String get addEmployee;

  /// No description provided for @editEmployee.
  ///
  /// In en, this message translates to:
  /// **'Edit employee'**
  String get editEmployee;

  /// No description provided for @deactivateEmployee.
  ///
  /// In en, this message translates to:
  /// **'Confirm employee deactivation'**
  String get deactivateEmployee;

  /// No description provided for @deactivate.
  ///
  /// In en, this message translates to:
  /// **'Deactivate'**
  String get deactivate;

  /// No description provided for @employeeCode.
  ///
  /// In en, this message translates to:
  /// **'Employee code'**
  String get employeeCode;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get lastName;

  /// No description provided for @nickname.
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get nickname;

  /// No description provided for @position.
  ///
  /// In en, this message translates to:
  /// **'Position'**
  String get position;

  /// No description provided for @departmentCode.
  ///
  /// In en, this message translates to:
  /// **'Department code'**
  String get departmentCode;

  /// No description provided for @departmentName.
  ///
  /// In en, this message translates to:
  /// **'Department name'**
  String get departmentName;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'This field is required.'**
  String get requiredField;

  /// No description provided for @shiftTemplates.
  ///
  /// In en, this message translates to:
  /// **'Shift templates'**
  String get shiftTemplates;

  /// No description provided for @shiftTemplatesDescription.
  ///
  /// In en, this message translates to:
  /// **'Configure reusable shift codes, times, colors, hours, and rates.'**
  String get shiftTemplatesDescription;

  /// No description provided for @addShiftTemplate.
  ///
  /// In en, this message translates to:
  /// **'Add shift template'**
  String get addShiftTemplate;

  /// No description provided for @editShiftTemplate.
  ///
  /// In en, this message translates to:
  /// **'Edit shift template'**
  String get editShiftTemplate;

  /// No description provided for @deactivateShiftTemplate.
  ///
  /// In en, this message translates to:
  /// **'Confirm shift-template deactivation'**
  String get deactivateShiftTemplate;

  /// No description provided for @shiftCode.
  ///
  /// In en, this message translates to:
  /// **'Shift code'**
  String get shiftCode;

  /// No description provided for @shiftName.
  ///
  /// In en, this message translates to:
  /// **'Shift name'**
  String get shiftName;

  /// No description provided for @startTime.
  ///
  /// In en, this message translates to:
  /// **'Start time'**
  String get startTime;

  /// No description provided for @endTime.
  ///
  /// In en, this message translates to:
  /// **'End time'**
  String get endTime;

  /// No description provided for @workingHours.
  ///
  /// In en, this message translates to:
  /// **'Working hours'**
  String get workingHours;

  /// No description provided for @rate.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get rate;

  /// No description provided for @shiftColor.
  ///
  /// In en, this message translates to:
  /// **'Shift color'**
  String get shiftColor;

  /// No description provided for @manualRosterEditor.
  ///
  /// In en, this message translates to:
  /// **'Manual roster editor'**
  String get manualRosterEditor;

  /// No description provided for @addAssignment.
  ///
  /// In en, this message translates to:
  /// **'Add assignment'**
  String get addAssignment;

  /// No description provided for @editAssignment.
  ///
  /// In en, this message translates to:
  /// **'Edit assignment'**
  String get editAssignment;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get selectDate;

  /// No description provided for @employee.
  ///
  /// In en, this message translates to:
  /// **'Employee'**
  String get employee;

  /// No description provided for @shift.
  ///
  /// In en, this message translates to:
  /// **'Shift'**
  String get shift;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @remark.
  ///
  /// In en, this message translates to:
  /// **'Remark'**
  String get remark;

  /// No description provided for @shiftCoverComment.
  ///
  /// In en, this message translates to:
  /// **'Shift cover'**
  String get shiftCoverComment;

  /// No description provided for @shiftSwapComment.
  ///
  /// In en, this message translates to:
  /// **'Shift swap'**
  String get shiftSwapComment;

  /// No description provided for @previewChanges.
  ///
  /// In en, this message translates to:
  /// **'Preview changes'**
  String get previewChanges;

  /// No description provided for @catalogRequired.
  ///
  /// In en, this message translates to:
  /// **'Add active employees and shift templates first.'**
  String get catalogRequired;

  /// No description provided for @scheduleSaved.
  ///
  /// In en, this message translates to:
  /// **'Schedule saved.'**
  String get scheduleSaved;

  /// No description provided for @storageError.
  ///
  /// In en, this message translates to:
  /// **'Could not complete the storage operation.'**
  String get storageError;

  /// No description provided for @reportMonth.
  ///
  /// In en, this message translates to:
  /// **'Report month'**
  String get reportMonth;

  /// No description provided for @reportLanguage.
  ///
  /// In en, this message translates to:
  /// **'Report language'**
  String get reportLanguage;

  /// No description provided for @allDepartments.
  ///
  /// In en, this message translates to:
  /// **'All departments'**
  String get allDepartments;

  /// No description provided for @previewReport.
  ///
  /// In en, this message translates to:
  /// **'Preview report'**
  String get previewReport;

  /// No description provided for @previewReportDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose report options, then generate an A4 preview.'**
  String get previewReportDescription;

  /// No description provided for @printReport.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get printReport;

  /// No description provided for @sharePdf.
  ///
  /// In en, this message translates to:
  /// **'Share PDF'**
  String get sharePdf;

  /// No description provided for @reportGenerationError.
  ///
  /// In en, this message translates to:
  /// **'The PDF report could not be generated.'**
  String get reportGenerationError;

  /// No description provided for @googleDrive.
  ///
  /// In en, this message translates to:
  /// **'Google Drive'**
  String get googleDrive;

  /// No description provided for @googleOAuthSettings.
  ///
  /// In en, this message translates to:
  /// **'Google connection'**
  String get googleOAuthSettings;

  /// No description provided for @googleOAuthSettingsDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter a Web OAuth Client ID, then reload the page to enable Google sign-in.'**
  String get googleOAuthSettingsDescription;

  /// No description provided for @googleWebClientId.
  ///
  /// In en, this message translates to:
  /// **'Web OAuth Client ID'**
  String get googleWebClientId;

  /// No description provided for @invalidGoogleWebClientId.
  ///
  /// In en, this message translates to:
  /// **'The Web OAuth Client ID format is invalid.'**
  String get invalidGoogleWebClientId;

  /// No description provided for @googleOAuthSaved.
  ///
  /// In en, this message translates to:
  /// **'Google OAuth was saved. Reload the page.'**
  String get googleOAuthSaved;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// No description provided for @signOutGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign out of Google'**
  String get signOutGoogle;

  /// No description provided for @googleDriveDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose the roster source to load from Google Drive.'**
  String get googleDriveDescription;

  /// No description provided for @openGoogleDrive.
  ///
  /// In en, this message translates to:
  /// **'Google Drive'**
  String get openGoogleDrive;

  /// No description provided for @recentlyModified.
  ///
  /// In en, this message translates to:
  /// **'Recently Modified'**
  String get recentlyModified;

  /// No description provided for @lastImported.
  ///
  /// In en, this message translates to:
  /// **'Last Imported'**
  String get lastImported;

  /// No description provided for @loadCurrentSource.
  ///
  /// In en, this message translates to:
  /// **'Load Current Source'**
  String get loadCurrentSource;

  /// No description provided for @noDriveRosterFiles.
  ///
  /// In en, this message translates to:
  /// **'No roster files have been loaded from Google Drive.'**
  String get noDriveRosterFiles;

  /// No description provided for @noLastImportedSource.
  ///
  /// In en, this message translates to:
  /// **'No source has been imported yet.'**
  String get noLastImportedSource;

  /// No description provided for @googleDriveNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Google Drive is not configured. Add an OAuth-backed Drive gateway to connect an account.'**
  String get googleDriveNotConfigured;

  /// No description provided for @googleDriveLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load the Google Drive source.'**
  String get googleDriveLoadFailed;

  /// No description provided for @driveSourceLoaded.
  ///
  /// In en, this message translates to:
  /// **'The current source was loaded.'**
  String get driveSourceLoaded;

  /// No description provided for @sheetReadMode.
  ///
  /// In en, this message translates to:
  /// **'Sheet reading mode'**
  String get sheetReadMode;

  /// No description provided for @configuredSheetRead.
  ///
  /// In en, this message translates to:
  /// **'Configured'**
  String get configuredSheetRead;

  /// No description provided for @standardSheetRead.
  ///
  /// In en, this message translates to:
  /// **'Standard read'**
  String get standardSheetRead;

  /// No description provided for @configuredSheetReadDescription.
  ///
  /// In en, this message translates to:
  /// **'Use configured columns and shift templates, including working hours, color, and rate.'**
  String get configuredSheetReadDescription;

  /// No description provided for @standardSheetReadDescription.
  ///
  /// In en, this message translates to:
  /// **'Read the roster using the standard layout without custom configuration.'**
  String get standardSheetReadDescription;

  /// No description provided for @newExchangeRequest.
  ///
  /// In en, this message translates to:
  /// **'New request'**
  String get newExchangeRequest;

  /// No description provided for @coverShift.
  ///
  /// In en, this message translates to:
  /// **'Shift cover'**
  String get coverShift;

  /// No description provided for @swapShift.
  ///
  /// In en, this message translates to:
  /// **'Shift swap'**
  String get swapShift;

  /// No description provided for @originalShift.
  ///
  /// In en, this message translates to:
  /// **'Original shift'**
  String get originalShift;

  /// No description provided for @offeredShift.
  ///
  /// In en, this message translates to:
  /// **'Offered shift'**
  String get offeredShift;

  /// No description provided for @receivingEmployee.
  ///
  /// In en, this message translates to:
  /// **'Receiving employee'**
  String get receivingEmployee;

  /// No description provided for @reason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get reason;

  /// No description provided for @submitRequest.
  ///
  /// In en, this message translates to:
  /// **'Submit request'**
  String get submitRequest;

  /// No description provided for @acceptExchange.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get acceptExchange;

  /// No description provided for @approveExchange.
  ///
  /// In en, this message translates to:
  /// **'Approve exchange'**
  String get approveExchange;

  /// No description provided for @previewAndApprove.
  ///
  /// In en, this message translates to:
  /// **'Preview and approve'**
  String get previewAndApprove;

  /// No description provided for @rejectExchange.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get rejectExchange;

  /// No description provided for @cancelRequest.
  ///
  /// In en, this message translates to:
  /// **'Cancel request'**
  String get cancelRequest;

  /// No description provided for @exchangePreview.
  ///
  /// In en, this message translates to:
  /// **'Exchange preview'**
  String get exchangePreview;

  /// No description provided for @noExchangeConflicts.
  ///
  /// In en, this message translates to:
  /// **'No blocking roster conflicts were found.'**
  String get noExchangeConflicts;

  /// No description provided for @waitingForAcceptance.
  ///
  /// In en, this message translates to:
  /// **'Waiting for acceptance'**
  String get waitingForAcceptance;

  /// No description provided for @waitingForApproval.
  ///
  /// In en, this message translates to:
  /// **'Waiting for approval'**
  String get waitingForApproval;

  /// No description provided for @approvedExchange.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approvedExchange;

  /// No description provided for @rejectedExchange.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejectedExchange;

  /// No description provided for @cancelledExchange.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelledExchange;

  /// No description provided for @rejectionReason.
  ///
  /// In en, this message translates to:
  /// **'Rejection reason'**
  String get rejectionReason;

  /// No description provided for @exchangeSaved.
  ///
  /// In en, this message translates to:
  /// **'Exchange request saved.'**
  String get exchangeSaved;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @loadFirstTimeline.
  ///
  /// In en, this message translates to:
  /// **'Load first timeline'**
  String get loadFirstTimeline;

  /// No description provided for @timelineLoaded.
  ///
  /// In en, this message translates to:
  /// **'The file timeline and current sheet rows were loaded.'**
  String get timelineLoaded;

  /// No description provided for @timelineLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load the selected file timeline.'**
  String get timelineLoadFailed;

  /// No description provided for @firstFileTimeline.
  ///
  /// In en, this message translates to:
  /// **'Selected file timeline'**
  String get firstFileTimeline;

  /// No description provided for @fileCreatedTime.
  ///
  /// In en, this message translates to:
  /// **'First created'**
  String get fileCreatedTime;

  /// No description provided for @unknownCreatedTime.
  ///
  /// In en, this message translates to:
  /// **'Creation time unavailable'**
  String get unknownCreatedTime;

  /// No description provided for @firstWorksheet.
  ///
  /// In en, this message translates to:
  /// **'First worksheet'**
  String get firstWorksheet;

  /// No description provided for @fileOwners.
  ///
  /// In en, this message translates to:
  /// **'File owners'**
  String get fileOwners;

  /// No description provided for @headerRow.
  ///
  /// In en, this message translates to:
  /// **'Header row'**
  String get headerRow;

  /// No description provided for @rowNumber.
  ///
  /// In en, this message translates to:
  /// **'Row {number}'**
  String rowNumber(int number);

  /// No description provided for @notMapped.
  ///
  /// In en, this message translates to:
  /// **'Not mapped'**
  String get notMapped;

  /// No description provided for @exchangeDataPreview.
  ///
  /// In en, this message translates to:
  /// **'Exchange data preview'**
  String get exchangeDataPreview;

  /// No description provided for @noTimelineRows.
  ///
  /// In en, this message translates to:
  /// **'No mapped data rows were found.'**
  String get noTimelineRows;

  /// No description provided for @row.
  ///
  /// In en, this message translates to:
  /// **'Row'**
  String get row;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @exchangeGiver.
  ///
  /// In en, this message translates to:
  /// **'Shift giver / requester'**
  String get exchangeGiver;

  /// No description provided for @exchangeReceiver.
  ///
  /// In en, this message translates to:
  /// **'Shift receiver'**
  String get exchangeReceiver;

  /// No description provided for @exchangeType.
  ///
  /// In en, this message translates to:
  /// **'Exchange type'**
  String get exchangeType;

  /// No description provided for @currentSheetValuesNotice.
  ///
  /// In en, this message translates to:
  /// **'The creation time comes from Google Drive. Names and roster values come from the current first worksheet, not its historical first revision.'**
  String get currentSheetValuesNotice;

  /// No description provided for @createCoverRequests.
  ///
  /// In en, this message translates to:
  /// **'Create cover requests'**
  String get createCoverRequests;

  /// No description provided for @timelineImportResult.
  ///
  /// In en, this message translates to:
  /// **'Created {created} requests; skipped {skipped} rows.'**
  String timelineImportResult(int created, int skipped);

  /// No description provided for @attachOriginalFile.
  ///
  /// In en, this message translates to:
  /// **'Attach original file'**
  String get attachOriginalFile;

  /// No description provided for @originalFileAttached.
  ///
  /// In en, this message translates to:
  /// **'The original file was attached.'**
  String get originalFileAttached;

  /// No description provided for @fileSize.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get fileSize;

  /// No description provided for @rows.
  ///
  /// In en, this message translates to:
  /// **'Rows'**
  String get rows;

  /// No description provided for @removeAttachment.
  ///
  /// In en, this message translates to:
  /// **'Remove attachment'**
  String get removeAttachment;

  /// No description provided for @loadTimelineToCompare.
  ///
  /// In en, this message translates to:
  /// **'Load the selected Sheet timeline to compare these sources.'**
  String get loadTimelineToCompare;

  /// No description provided for @sourcesMatch.
  ///
  /// In en, this message translates to:
  /// **'The compared values match.'**
  String get sourcesMatch;

  /// No description provided for @sourcesDifferent.
  ///
  /// In en, this message translates to:
  /// **'The compared values are different.'**
  String get sourcesDifferent;

  /// No description provided for @matchingCells.
  ///
  /// In en, this message translates to:
  /// **'Matching cells'**
  String get matchingCells;

  /// No description provided for @differentCells.
  ///
  /// In en, this message translates to:
  /// **'Different cells'**
  String get differentCells;

  /// No description provided for @localOnlyRows.
  ///
  /// In en, this message translates to:
  /// **'Local-only rows'**
  String get localOnlyRows;

  /// No description provided for @remoteOnlyRows.
  ///
  /// In en, this message translates to:
  /// **'Sheet-only rows'**
  String get remoteOnlyRows;

  /// No description provided for @rosterRules.
  ///
  /// In en, this message translates to:
  /// **'Roster rules and policy'**
  String get rosterRules;

  /// No description provided for @rosterRulesDescription.
  ///
  /// In en, this message translates to:
  /// **'Configure validation limits used by roster saves, exchange approval, imports, and payroll.'**
  String get rosterRulesDescription;

  /// No description provided for @minimumRestHours.
  ///
  /// In en, this message translates to:
  /// **'Minimum rest hours'**
  String get minimumRestHours;

  /// No description provided for @maximumContinuousHours.
  ///
  /// In en, this message translates to:
  /// **'Maximum continuous hours'**
  String get maximumContinuousHours;

  /// No description provided for @maximumShiftsPerDay.
  ///
  /// In en, this message translates to:
  /// **'Maximum shifts per day'**
  String get maximumShiftsPerDay;

  /// No description provided for @maximumShiftsPerWeek.
  ///
  /// In en, this message translates to:
  /// **'Maximum shifts per week'**
  String get maximumShiftsPerWeek;

  /// No description provided for @maximumShiftsPerMonth.
  ///
  /// In en, this message translates to:
  /// **'Maximum shifts per month'**
  String get maximumShiftsPerMonth;

  /// No description provided for @blockOverlappingShifts.
  ///
  /// In en, this message translates to:
  /// **'Block overlapping shifts'**
  String get blockOverlappingShifts;

  /// No description provided for @requireExchangeApproval.
  ///
  /// In en, this message translates to:
  /// **'Require exchange approval'**
  String get requireExchangeApproval;

  /// No description provided for @estimatedOvertime.
  ///
  /// In en, this message translates to:
  /// **'Estimated OT'**
  String get estimatedOvertime;

  /// No description provided for @googleCalendarSync.
  ///
  /// In en, this message translates to:
  /// **'Google Calendar sync'**
  String get googleCalendarSync;

  /// No description provided for @googleCalendarSyncDescription.
  ///
  /// In en, this message translates to:
  /// **'Preview changes for the selected employee, then sync approved shifts to the primary calendar without creating duplicates.'**
  String get googleCalendarSyncDescription;

  /// No description provided for @calendarEmployee.
  ///
  /// In en, this message translates to:
  /// **'Employee'**
  String get calendarEmployee;

  /// No description provided for @previewCalendarSync.
  ///
  /// In en, this message translates to:
  /// **'Preview sync'**
  String get previewCalendarSync;

  /// No description provided for @syncCalendar.
  ///
  /// In en, this message translates to:
  /// **'Sync calendar'**
  String get syncCalendar;

  /// No description provided for @calendarCreate.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get calendarCreate;

  /// No description provided for @calendarUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get calendarUpdate;

  /// No description provided for @calendarDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get calendarDelete;

  /// No description provided for @calendarUnchanged.
  ///
  /// In en, this message translates to:
  /// **'No change'**
  String get calendarUnchanged;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'th'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'th':
      return AppLocalizationsTh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Shift Calendar Engine';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get roster => 'Roster';

  @override
  String get employees => 'Employees';

  @override
  String get exchange => 'Exchange';

  @override
  String get reports => 'Reports';

  @override
  String get settings => 'Settings';

  @override
  String get today => 'Today';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String get nextShift => 'Next shift';

  @override
  String get monthlyAssignments => 'Assignments this month';

  @override
  String get estimatedIncome => 'Estimated income';

  @override
  String get pendingRequests => 'Pending requests';

  @override
  String get calendarStatus => 'Calendar status';

  @override
  String get notConnected => 'Not connected';

  @override
  String get noSchedule => 'No schedule data';

  @override
  String get noScheduleDescription => 'Import or create a roster to begin.';

  @override
  String get createRoster => 'Create roster';

  @override
  String get importRoster => 'Import roster';

  @override
  String get previousMonth => 'Previous month';

  @override
  String get nextMonth => 'Next month';

  @override
  String get monthOverview => 'Month overview';

  @override
  String get employeeDirectory => 'Employee directory';

  @override
  String get employeeDirectoryDescription =>
      'Manage people used by roster assignments.';

  @override
  String get noEmployees => 'No employees yet';

  @override
  String get exchangeRequests => 'Shift exchange requests';

  @override
  String get exchangeDescription =>
      'Requests, approvals, and history will use the canonical roster.';

  @override
  String get noRequests => 'No exchange requests';

  @override
  String get reportCenter => 'Report center';

  @override
  String get reportDescription => 'Printable and exportable schedule reports.';

  @override
  String get noReports => 'No report data';

  @override
  String get workspaceSettings => 'Workspace settings';

  @override
  String get language => 'Language';

  @override
  String get followSystem => 'Follow system';

  @override
  String get english => 'English';

  @override
  String get thai => 'Thai';

  @override
  String get theme => 'Theme';

  @override
  String get systemTheme => 'System';

  @override
  String get lightTheme => 'Light';

  @override
  String get darkTheme => 'Dark';

  @override
  String get demoMode => 'Demo mode';

  @override
  String get demoModeDescription =>
      'Use deterministic sample data without external accounts.';

  @override
  String get logicMode => 'Logic mode';

  @override
  String get logicModeDescription =>
      'Use built-in rules or user-defined behavior for each feature.';

  @override
  String get standardLogic => 'Standard';

  @override
  String get freestyleLogic => 'Freestyle';

  @override
  String get phaseStatus => 'SCE 3.0 foundation';

  @override
  String get phaseStatusDescription =>
      'Canonical roster, explicit dependencies, responsive navigation, localization, and tests are active.';

  @override
  String get addEmployee => 'Add employee';

  @override
  String get editEmployee => 'Edit employee';

  @override
  String get deactivateEmployee => 'Confirm employee deactivation';

  @override
  String get deactivate => 'Deactivate';

  @override
  String get employeeCode => 'Employee code';

  @override
  String get firstName => 'First name';

  @override
  String get lastName => 'Last name';

  @override
  String get nickname => 'Nickname';

  @override
  String get position => 'Position';

  @override
  String get departmentCode => 'Department code';

  @override
  String get departmentName => 'Department name';

  @override
  String get search => 'Search';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get delete => 'Delete';

  @override
  String get requiredField => 'This field is required.';

  @override
  String get shiftTemplates => 'Shift templates';

  @override
  String get shiftTemplatesDescription =>
      'Configure reusable shift codes, times, colors, hours, and rates.';

  @override
  String get addShiftTemplate => 'Add shift template';

  @override
  String get editShiftTemplate => 'Edit shift template';

  @override
  String get deactivateShiftTemplate => 'Confirm shift-template deactivation';

  @override
  String get shiftCode => 'Shift code';

  @override
  String get shiftName => 'Shift name';

  @override
  String get startTime => 'Start time';

  @override
  String get endTime => 'End time';

  @override
  String get workingHours => 'Working hours';

  @override
  String get rate => 'Rate';

  @override
  String get shiftColor => 'Shift color';

  @override
  String get manualRosterEditor => 'Manual roster editor';

  @override
  String get addAssignment => 'Add assignment';

  @override
  String get editAssignment => 'Edit assignment';

  @override
  String get selectDate => 'Select date';

  @override
  String get employee => 'Employee';

  @override
  String get shift => 'Shift';

  @override
  String get location => 'Location';

  @override
  String get remark => 'Remark';

  @override
  String get shiftCoverComment => 'Shift cover';

  @override
  String get shiftSwapComment => 'Shift swap';

  @override
  String get previewChanges => 'Preview changes';

  @override
  String get catalogRequired =>
      'Add active employees and shift templates first.';

  @override
  String get scheduleSaved => 'Schedule saved.';

  @override
  String get storageError => 'Could not complete the storage operation.';

  @override
  String get reportMonth => 'Report month';

  @override
  String get reportLanguage => 'Report language';

  @override
  String get allDepartments => 'All departments';

  @override
  String get previewReport => 'Preview report';

  @override
  String get previewReportDescription =>
      'Choose report options, then generate an A4 preview.';

  @override
  String get printReport => 'Print';

  @override
  String get sharePdf => 'Share PDF';

  @override
  String get reportGenerationError => 'The PDF report could not be generated.';

  @override
  String get googleDrive => 'Google Drive';

  @override
  String get googleOAuthSettings => 'Google connection';

  @override
  String get googleOAuthSettingsDescription =>
      'Enter a Web OAuth Client ID, then reload the page to enable Google sign-in.';

  @override
  String get googleWebClientId => 'Web OAuth Client ID';

  @override
  String get invalidGoogleWebClientId =>
      'The Web OAuth Client ID format is invalid.';

  @override
  String get googleOAuthSaved => 'Google OAuth was saved. Reload the page.';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get signOutGoogle => 'Sign out of Google';

  @override
  String get googleDriveDescription =>
      'Choose the roster source to load from Google Drive.';

  @override
  String get openGoogleDrive => 'Google Drive';

  @override
  String get recentlyModified => 'Recently Modified';

  @override
  String get lastImported => 'Last Imported';

  @override
  String get loadCurrentSource => 'Load Current Source';

  @override
  String get noDriveRosterFiles =>
      'No roster files have been loaded from Google Drive.';

  @override
  String get noLastImportedSource => 'No source has been imported yet.';

  @override
  String get googleDriveNotConfigured =>
      'Google Drive is not configured. Add an OAuth-backed Drive gateway to connect an account.';

  @override
  String get googleDriveLoadFailed => 'Could not load the Google Drive source.';

  @override
  String get driveSourceLoaded => 'The current source was loaded.';

  @override
  String get sheetReadMode => 'Sheet reading mode';

  @override
  String get configuredSheetRead => 'Configured';

  @override
  String get standardSheetRead => 'Standard read';

  @override
  String get configuredSheetReadDescription =>
      'Use configured columns and shift templates, including working hours, color, and rate.';

  @override
  String get standardSheetReadDescription =>
      'Read the roster using the standard layout without custom configuration.';

  @override
  String get newExchangeRequest => 'New request';

  @override
  String get coverShift => 'Shift cover';

  @override
  String get swapShift => 'Shift swap';

  @override
  String get originalShift => 'Original shift';

  @override
  String get offeredShift => 'Offered shift';

  @override
  String get receivingEmployee => 'Receiving employee';

  @override
  String get reason => 'Reason';

  @override
  String get submitRequest => 'Submit request';

  @override
  String get acceptExchange => 'Accept';

  @override
  String get approveExchange => 'Approve exchange';

  @override
  String get previewAndApprove => 'Preview and approve';

  @override
  String get rejectExchange => 'Reject';

  @override
  String get cancelRequest => 'Cancel request';

  @override
  String get exchangePreview => 'Exchange preview';

  @override
  String get noExchangeConflicts => 'No blocking roster conflicts were found.';

  @override
  String get waitingForAcceptance => 'Waiting for acceptance';

  @override
  String get waitingForApproval => 'Waiting for approval';

  @override
  String get approvedExchange => 'Approved';

  @override
  String get rejectedExchange => 'Rejected';

  @override
  String get cancelledExchange => 'Cancelled';

  @override
  String get rejectionReason => 'Rejection reason';

  @override
  String get exchangeSaved => 'Exchange request saved.';

  @override
  String get retry => 'Retry';

  @override
  String get loadFirstTimeline => 'Load first timeline';

  @override
  String get timelineLoaded =>
      'The file timeline and current sheet rows were loaded.';

  @override
  String get timelineLoadFailed => 'Could not load the selected file timeline.';

  @override
  String get firstFileTimeline => 'Selected file timeline';

  @override
  String get fileCreatedTime => 'First created';

  @override
  String get unknownCreatedTime => 'Creation time unavailable';

  @override
  String get firstWorksheet => 'First worksheet';

  @override
  String get fileOwners => 'File owners';

  @override
  String get headerRow => 'Header row';

  @override
  String rowNumber(int number) {
    return 'Row $number';
  }

  @override
  String get notMapped => 'Not mapped';

  @override
  String get exchangeDataPreview => 'Exchange data preview';

  @override
  String get noTimelineRows => 'No mapped data rows were found.';

  @override
  String get row => 'Row';

  @override
  String get date => 'Date';

  @override
  String get exchangeGiver => 'Shift giver / requester';

  @override
  String get exchangeReceiver => 'Shift receiver';

  @override
  String get exchangeType => 'Exchange type';

  @override
  String get currentSheetValuesNotice =>
      'The creation time comes from Google Drive. Names and roster values come from the current first worksheet, not its historical first revision.';

  @override
  String get createCoverRequests => 'Create cover requests';

  @override
  String timelineImportResult(int created, int skipped) {
    return 'Created $created requests; skipped $skipped rows.';
  }

  @override
  String get attachOriginalFile => 'Attach original file';

  @override
  String get originalFileAttached => 'The original file was attached.';

  @override
  String get fileSize => 'Size';

  @override
  String get rows => 'Rows';

  @override
  String get removeAttachment => 'Remove attachment';

  @override
  String get loadTimelineToCompare =>
      'Load the selected Sheet timeline to compare these sources.';

  @override
  String get sourcesMatch => 'The compared values match.';

  @override
  String get sourcesDifferent => 'The compared values are different.';

  @override
  String get matchingCells => 'Matching cells';

  @override
  String get differentCells => 'Different cells';

  @override
  String get localOnlyRows => 'Local-only rows';

  @override
  String get remoteOnlyRows => 'Sheet-only rows';
}

# Merge Google Sheets import page

This branch adds a dedicated Google Sheets-only import screen:

```text
lib/features/roster/presentation/google_sheet_import_page.dart
```

The screen reads spreadsheets selected from Google Drive and does not attach, upload, or commit personal local files.

## Merge through GitHub

1. Open the pull request from `feature/merge-latest-sheet` into `main`.
2. Review **Files changed** and confirm only source code and documentation are included.
3. Wait for required checks to pass.
4. Select **Squash and merge**.
5. Confirm the merge and optionally delete the feature branch.

## Merge with Git commands

```powershell
git fetch origin
git switch main
git pull origin main
git merge --no-ff origin/feature/merge-latest-sheet
git push origin main
```

Before pushing, verify that no personal spreadsheet files are tracked:

```powershell
git status
git diff --name-only origin/main...HEAD
```

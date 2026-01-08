#!/bin/bash

echo "========================================"
echo "L10n Conversion Verification"
echo "========================================"
echo

# Check for any remaining AppLocalizations.of(context)! usage
echo "Checking for remaining AppLocalizations.of(context)! usage..."
remaining_app_local=$(grep -r "AppLocalizations\.of(context)!" lib/feature/auth lib/feature/settings lib/feature/messages lib/feature/passenger/car_booking lib/utils lib/widgets 2>/dev/null | wc -l)
echo "Found: $remaining_app_local occurrences"

# Check for remaining old import
echo
echo "Checking for old app_localizations imports..."
old_imports=$(grep -r "package:ride_sharing/l10n/app_localizations.dart" lib/feature/auth lib/feature/settings lib/feature/messages lib/feature/passenger/car_booking lib/utils lib/widgets 2>/dev/null | wc -l)
echo "Found: $old_imports occurrences"

# Check for remaining l10n variable declarations
echo
echo "Checking for remaining 'final l10n = AppLocalizations.of(context)!' declarations..."
l10n_declarations=$(grep -r "final l10n = AppLocalizations\.of(context)!" lib/feature/auth lib/feature/settings lib/feature/messages lib/feature/passenger/car_booking lib/utils lib/widgets 2>/dev/null | wc -l)
echo "Found: $l10n_declarations occurrences"

# Count L10n.tr usage
echo
echo "Counting L10n.tr usage..."
l10n_tr_usage=$(grep -r "L10n\.tr\." lib/feature/auth lib/feature/settings lib/feature/messages lib/feature/passenger/car_booking lib/utils lib/widgets 2>/dev/null | wc -l)
echo "Found: $l10n_tr_usage occurrences"

# Count files with l10n_helper import
echo
echo "Counting files with l10n_helper import..."
helper_imports=$(grep -r "package:ride_sharing/l10n/l10n_helper.dart" lib/feature/auth lib/feature/settings lib/feature/messages lib/feature/passenger/car_booking lib/utils lib/widgets 2>/dev/null | wc -l)
echo "Found: $helper_imports files"

echo
echo "========================================"
echo "Summary:"
echo "========================================"
if [ $remaining_app_local -eq 0 ] && [ $old_imports -eq 0 ] && [ $l10n_declarations -eq 0 ]; then
    echo "✓ Conversion successful!"
    echo "✓ All old patterns removed"
    echo "✓ $l10n_tr_usage instances of L10n.tr usage"
    echo "✓ $helper_imports files with l10n_helper import"
else
    echo "⚠ Conversion may have issues:"
    [ $remaining_app_local -gt 0 ] && echo "  - Still has $remaining_app_local AppLocalizations.of(context)! usage"
    [ $old_imports -gt 0 ] && echo "  - Still has $old_imports old imports"
    [ $l10n_declarations -gt 0 ] && echo "  - Still has $l10n_declarations l10n declarations"
fi
echo "========================================"

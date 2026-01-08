#!/bin/bash

# Fix duplicate imports and remove old app_localizations imports
echo "Fixing duplicate imports..."

# Find all dart files in the specified directories
find lib/feature/auth/driver -name "*.dart" -o \
  -path "lib/feature/auth/passenger/*.dart" -o \
  -path "lib/feature/auth/log_out_dialog.dart" -o \
  -path "lib/feature/settings/view/*.dart" -o \
  -path "lib/feature/messages/view/*.dart" -o \
  -path "lib/feature/passenger/car_booking" -name "*.dart" -o \
  -path "lib/utils" -name "*.dart" -o \
  -path "lib/widgets" -name "*.dart" | while read file; do
    
    if [ -f "$file" ]; then
        # Remove duplicate l10n_helper imports
        awk '!seen[$0]++ || !/package:ride_sharing\/l10n\/l10n_helper.dart/' "$file" > "$file.tmp" && mv "$file.tmp" "$file"
        
        # Remove old app_localizations import if l10n_helper is present
        if grep -q "package:ride_sharing/l10n/l10n_helper.dart" "$file"; then
            sed -i "/import.*package:ride_sharing\/l10n\/app_localizations.dart/d" "$file"
        fi
        
        echo "Fixed: $file"
    fi
done

echo "Done!"

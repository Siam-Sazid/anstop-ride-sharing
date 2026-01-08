#!/bin/bash

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}L10n Helper Conversion Script${NC}"
echo -e "${BLUE}========================================${NC}\n"

# Counter for changes
total_files=0
modified_files=0

# Function to convert a single file
convert_file() {
    local file="$1"
    local changed=0
    
    echo -e "${YELLOW}Processing: $file${NC}"
    
    # Create a backup
    cp "$file" "$file.bak"
    
    # Check if file uses AppLocalizations
    if ! grep -q "AppLocalizations\|l10n\." "$file"; then
        echo -e "${YELLOW}  ⊘ No AppLocalizations usage found - skipping${NC}\n"
        rm "$file.bak"
        return 0
    fi
    
    # 1. Add l10n_helper import if not present and remove app_localizations import
    if grep -q "package:ride_sharing/l10n/app_localizations.dart" "$file"; then
        sed -i "s|import 'package:ride_sharing/l10n/app_localizations.dart';|import 'package:ride_sharing/l10n/l10n_helper.dart';|g" "$file"
        echo -e "${GREEN}  ✓ Replaced app_localizations import with l10n_helper import${NC}"
        changed=1
    elif ! grep -q "package:ride_sharing/l10n/l10n_helper.dart" "$file" && grep -q "l10n\." "$file"; then
        # Add import after last import line
        sed -i "/^import /a import 'package:ride_sharing/l10n/l10n_helper.dart';" "$file" 
        echo -e "${GREEN}  ✓ Added l10n_helper import${NC}"
        changed=1
    fi
    
    # 2. Remove final l10n = AppLocalizations.of(context)! declarations
    if grep -q "final l10n = AppLocalizations.of(context)!" "$file"; then
        local count=$(grep -c "final l10n = AppLocalizations.of(context)!" "$file")
        sed -i "/final l10n = AppLocalizations.of(context)!;/d" "$file"
        echo -e "${GREEN}  ✓ Removed $count l10n declaration(s)${NC}"
        changed=1
    fi
    
    # 3. Replace l10n. with L10n.tr.
    if grep -q "\bl10n\." "$file"; then
        local count=$(grep -o "\bl10n\." "$file" | wc -l)
        sed -i "s/\bl10n\./L10n.tr./g" "$file"
        echo -e "${GREEN}  ✓ Replaced $count occurrence(s) of 'l10n.' with 'L10n.tr.'${NC}"
        changed=1
    fi
    
    # 4. Replace AppLocalizations.of(context)! with L10n.tr
    if grep -q "AppLocalizations\.of(context)!" "$file"; then
        local count=$(grep -o "AppLocalizations\.of(context)!" "$file" | wc -l)
        sed -i "s/AppLocalizations\.of(context)!/L10n.tr/g" "$file"
        echo -e "${GREEN}  ✓ Replaced $count occurrence(s) of 'AppLocalizations.of(context)!' with 'L10n.tr'${NC}"
        changed=1
    fi
    
    if [ $changed -eq 1 ]; then
        echo -e "${GREEN}  ✅ File modified successfully${NC}\n"
        modified_files=$((modified_files + 1))
        rm "$file.bak"
    else
        echo -e "${YELLOW}  ⊘ No changes needed${NC}\n"
        mv "$file.bak" "$file"
    fi
    
    total_files=$((total_files + 1))
}

# Process specific files
echo -e "${BLUE}Processing specific files...${NC}\n"
convert_file "lib/feature/auth/driver/registration.dart"
convert_file "lib/feature/auth/passenger/registration.dart"
convert_file "lib/feature/auth/passenger/terms_of_services.dart"
convert_file "lib/feature/auth/log_out_dialog.dart"

# Process directories
echo -e "${BLUE}Processing settings views...${NC}\n"
for file in lib/feature/settings/view/*.dart; do
    if [ -f "$file" ]; then
        convert_file "$file"
    fi
done

echo -e "${BLUE}Processing message views...${NC}\n"
for file in lib/feature/messages/view/*.dart; do
    if [ -f "$file" ]; then
        convert_file "$file"
    fi
done

echo -e "${BLUE}Processing passenger car booking files...${NC}\n"
find lib/feature/passenger/car_booking -name "*.dart" -type f | while read file; do
    convert_file "$file"
done

echo -e "${BLUE}Processing utils files...${NC}\n"
find lib/utils -name "*.dart" -type f | while read file; do
    convert_file "$file"
done

echo -e "${BLUE}Processing widget files...${NC}\n"
find lib/widgets -name "*.dart" -type f | while read file; do
    convert_file "$file"
done

# Summary
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Conversion Summary${NC}"
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}Total files processed: $total_files${NC}"
echo -e "${GREEN}Files modified: $modified_files${NC}"
echo -e "${YELLOW}Files unchanged: $((total_files - modified_files))${NC}"
echo -e "${BLUE}========================================${NC}"

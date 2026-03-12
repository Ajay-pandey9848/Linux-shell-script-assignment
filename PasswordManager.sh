#!/bin/bash

# Simple Password Validator
# Version: 1.0

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Password rules
MIN_LENGTH=8
WEAK_PASSWORDS="password 123456 qwerty abc123 letmein admin root 12345678 1234 toor"

# Function to check password
check_password() {
    local password=$1
    local errors=()
    
    # Check length
    if [ ${#password} -lt $MIN_LENGTH ]; then
        errors+=("Password must be at least $MIN_LENGTH characters")
    fi
    
    # Check for uppercase
    if ! [[ "$password" =~ [A-Z] ]]; then
        errors+=("Password must contain at least 1 uppercase letter")
    fi
    
    # Check for lowercase
    if ! [[ "$password" =~ [a-z] ]]; then
        errors+=("Password must contain at least 1 lowercase letter")
    fi
    
    # Check for number
    if ! [[ "$password" =~ [0-9] ]]; then
        errors+=("Password must contain at least 1 number")
    fi
    
    # Check for special character - FIXED VERSION
    if ! [[ "$password" =~ ['!@#$%^&*()'] ]]; then
        errors+=("Password must contain at least 1 special character (!@#$%^&*)")
    fi
    
    # Check against weak passwords
    for weak in $WEAK_PASSWORDS; do
        if [ "$password" = "$weak" ]; then
            errors+=("Password is too common - choose a stronger one")
            break
        fi
    done
    
    # Display results
    if [ ${#errors[@]} -eq 0 ]; then
        echo -e "${GREEN}✓ PASSWORD ACCEPTED - Strong password${NC}"
        
        # Show strength meter
        echo -n "Strength: "
        if [ ${#password} -ge 12 ]; then
            echo -e "${GREEN}Excellent${NC}"
        elif [ ${#password} -ge 10 ]; then
            echo -e "${GREEN}Good${NC}"
        else
            echo -e "${YELLOW}Fair${NC}"
        fi
        return 0
    else
        echo -e "${RED}✗ PASSWORD REJECTED:${NC}"
        for err in "${errors[@]}"; do
            echo -e "${RED}  • $err${NC}"
        done
        return 1
    fi
}

# Main script
clear
echo "==================================="
echo "  PASSWORD VALIDATION TOOL"
echo "==================================="
echo "Password must have:"
echo "• At least $MIN_LENGTH characters"
echo "• 1 uppercase letter"
echo "• 1 lowercase letter"
echo "• 1 number"
echo "• 1 special character (!@#$%^&*)"
echo "• Not be a common password"
echo "==================================="

attempts=0
max_attempts=3

while [ $attempts -lt $max_attempts ]; do
    echo ""
    read -s -p "Enter password: " password
    echo ""
    read -s -p "Confirm password: " confirm
    echo ""
    
    # Check if passwords match
    if [ "$password" != "$confirm" ]; then
        echo -e "${RED}Error: Passwords don't match${NC}"
        ((attempts++))
        echo "Attempts left: $((max_attempts - attempts))"
        continue
    fi
    
    # Validate password
    if check_password "$password"; then
        echo ""
        echo "Password validated successfully!"
        exit 0
    else
        ((attempts++))
        echo ""
        echo "Attempts left: $((max_attempts - attempts))"
    fi
done

echo -e "\n${RED}Too many failed attempts. Exiting.${NC}"
exit 1
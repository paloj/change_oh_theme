#!/bin/bash

# Path to the .profile file
PROFILE_PATH="$HOME/.profile"

# Check if there are any theme lines in the .profile file
if ! grep -q 'eval.*oh-my-posh.*omp.json' "$PROFILE_PATH"; then
    echo "No Oh My Posh theme lines found in .profile. Please add them and try again."
    exit 1
fi

# Read the current active theme from the .profile file
CURRENT_THEME_LINE=$(grep '^eval.*oh-my-posh.*omp.json' "$PROFILE_PATH")
CURRENT_THEME_NAME=$(echo "$CURRENT_THEME_LINE" | sed 's/.*\/\(.*\)\.omp.json.*/\1/')

# Get a list of all themes (only file names), removing duplicates
THEMES=($(grep 'eval.*oh-my-posh.*omp.json' "$PROFILE_PATH" | sed 's/.*\/\(.*\)\.omp.json.*/\1/' | uniq))

# Find the index of the current active theme
CURRENT_INDEX=-1
for i in "${!THEMES[@]}"; do
    if [[ "${THEMES[$i]}" == "$CURRENT_THEME_NAME" ]]; then
        CURRENT_INDEX=$i
        break
    fi
done

# Determine the next or previous theme index
if [ "$1" == "-back" ]; then
    # Calculate previous theme index
    PREV_INDEX=$((CURRENT_INDEX - 1))
    if [ $PREV_INDEX -lt 0 ]; then
        PREV_INDEX=$((${#THEMES[@]} - 1))
    fi
    TARGET_THEME=${THEMES[$PREV_INDEX]}
else
    # Calculate next theme index
    NEXT_INDEX=$((CURRENT_INDEX + 1))
    if [ $NEXT_INDEX -ge ${#THEMES[@]} ]; then
        NEXT_INDEX=0
    fi
    TARGET_THEME=${THEMES[$NEXT_INDEX]}
fi

# Comment out the current theme and uncomment the target theme
sed -i "s|^eval.*oh-my-posh.*omp.json|#&|" "$PROFILE_PATH"
sed -i "s|#eval.*${TARGET_THEME}\.omp.json.*|eval \"\$(oh-my-posh --init --shell bash --config ~/.poshthemes/${TARGET_THEME}.omp.json)\"|" "$PROFILE_PATH"

echo "Theme changed to: ${TARGET_THEME}"

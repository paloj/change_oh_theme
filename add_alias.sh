#!/bin/bash

# Path to the .bashrc file
BASHRC_PATH="$HOME/.bashrc"

# Function and alias name
ALIAS_NAME="1"
FUNCTION_NAME="change_theme_and_reload"

# Check if the alias already exists
if grep -q "alias $ALIAS_NAME=" "$BASHRC_PATH"; then
    echo "Alias '$ALIAS_NAME' already exists in .bashrc"
    exit 1
fi

# Adding the function and alias to .bashrc
echo "
# Function to change Oh My Posh theme and reload .bashrc
$FUNCTION_NAME() {
    ~/./change_oh_theme/change_theme.sh
    source ~/.profile
}

# Alias for the function
alias $ALIAS_NAME='$FUNCTION_NAME'
" >> "$BASHRC_PATH"

echo "Alias '$ALIAS_NAME' added to .bashrc. Please reload your shell or source .bashrc to use it."

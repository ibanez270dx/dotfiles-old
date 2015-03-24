#!/bin/bash
# Most *nix systems load .bash_profile on login and .bashrc on reload.
# The exception is Mac OSX, which loads .bash_profile for both.
# http://www.joshstaiger.org/archives/2005/07/bash_profile_vs.html

# Environment Variables
export DOTFILES=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $DOTFILES/bash/variables
source $DOTFILES/bash/secrets

# Custom Prompt and Helpers
source $DOTFILES/bash/prompt
source $DOTFILES/bash/colors
source $DOTFILES/bash/aliases
source $DOTFILES/bash/functions

# Load Extensions
for extension in $DOTFILES/extensions/*/; do
  source "${extension}initialize"
done

# Initialize
source $DOTFILES/bash/initialize

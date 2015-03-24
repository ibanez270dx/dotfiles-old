#!/bin/bash
# Most *nix systems load .bash_profile on login and .bashrc on reload.
# The exception is Mac OSX, which loads .bash_profile for both.
# http://www.joshstaiger.org/archives/2005/07/bash_profile_vs.html

# Environment Variables
export DOTFILES=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $DOTFILES/bash/variables
source $DOTFILES/bash/secrets

# Bash Configuration
source $DOTFILES/bash/prompt
source $DOTFILES/bash/colors
source $DOTFILES/bash/aliases
source $DOTFILES/bash/functions

# Load Extensions
for extension in $DOTFILES/extensions/*/; do
  source "${extension}initialize"
done

####################################
# Misc
####################################

# Initialize Ruby Environment
eval "$(rbenv init -)"

# Bash Completion
if [ -f `brew --prefix`/etc/bash_completion ]; then
  . `brew --prefix`/etc/bash_completion
  complete -o default -F _git g
fi

# End Message
printf "${RED}reloaded bash${NO_COLOR}\n";

# Quote of the Moment
random-quote

#!/bin/bash
# Executed from the bash shell when you log in.

# Environment Variables
export DOTFILES=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $DOTFILES/bash/variables

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

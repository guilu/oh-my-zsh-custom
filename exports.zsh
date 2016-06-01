#PYTHON(powerline)
export PATH=$PATH:/Users/diegobarrioh/Library/Python/2.7/bin

#php
export PATH="$(brew --prefix homebrew/php/php56)/bin:$PATH"
#and sbin before bin
export PATH="/usr/local/sbin:$PATH"
#composer require --global
export PATH="/Users/diegobarrioh/.composer/vendor/bin:$PATH"

#GIT ACHIEVEMENTS LOG FILES
export ACTIONLOGFILE="$HOME/code/git-achievements/.git-achievements-action.log"
export ACHIEVEMENTSLOGFILE="$HOME/code/git-achievements/.git-achievements.log"

#git-achievements
export PATH=$PATH:/Users/diegobarrioh/code/git-achievements

#java home puesto a 1.7
export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
export JBOSS_HOME=/usr/local/Cellar/jboss/jboss-eap-6.2
export PATH=$JAVA_HOME/bin:$PATH

#gnu core utils
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"


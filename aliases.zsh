export EDITOR='nvim'
export VEDITOR='nvim'

# Easier navigation: .., ..., ...., ....., ~ and -
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ~="cd ~" # `cd` is probably faster to type though
alias -- -="cd -"
alias cd..="cd .."

alias ls='gls --color=auto'

alias lt="ls -ltr"
alias ll='ls -l'
alias la='ls -a'

alias l='ls -alh'
alias ld='lsd'

# Shortcuts
alias c="cd ~/code"
alias dl="cd ~/Downloads"
alias dt="cd ~/Desktop"
alias h="history"
alias j="java -jar"
alias v="nvim"
alias m="mvn"
alias s="subl ."
alias o="open"
alias oo="open ."
alias g='git' #git-achievements: https://github.com/guilu/git-achievements
alias sf='symfony'
alias tree='tree -C'
alias gl="gulp"
alias dc="docker-compose"
alias bdd="vendor/bin/behat"
alias di="docker images"
alias py="python3"
alias vim="nvim"


# EDITAR CONFIGURACIONES....
alias zshconfig="$EDITOR ~/.zshrc"
alias ohmyzsh="$EDITOR ~/.oh-my-zsh"
alias vimrc="$EDITOR ~/.vimrc"
alias hosts='sudo $EDITOR /etc/hosts'   # yes I occasionally 127.0.0.1 twitter.com ;)
alias vhosts='sudo $EDITOR /etc/apache2/extra/httpd-vhosts.conf'
alias httpdconf='sudo $EDITOR /usr/local/etc/apache2/2.4/httpd.conf'
alias phpini='sudo $EDITOR /usr/local/etc/php/7.0/php.ini'
alias aliases='$EDITOR ~/.oh-my-zsh/custom/aliases.zsh'

#UPDATES
alias composer='php -n -d memory_limit=-1 /usr/local/bin/composer'
alias csu='composer self-update'
alias sfu='symfony self-update'

# Enable aliases to be sudo’ed
alias sudo='sudo '

# Gzip-enabled `curl`
alias gurl="curl --compressed"

alias cat='/opt/homebrew/bin/bat'
alias catn='/bin/cat'
alias catnl='/opt/homebrew/bin/bat --paging=never'
# Get OS X Software Updates, and update installed Ruby gems, Homebrew, npm, and their installed packages
alias update='sudo softwareupdate -i -a; brew update; brew upgrade; brew cleanup; npm update npm -g; npm update -g; sudo gem update -n /usr/local/bin'

# IP addresses
#alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
#alias localip="ipconfig getifaddr en1"
#alias ips="ifconfig -a | grep -o 'inet6\? \(\([0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+\)\|[a-fA-F0-9:]\+\)' | sed -e 's/inet6* //'"

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="(\
	(echo 'wired   ' && \
		([ ! -z $(ipconfig getifaddr en1) ] && echo '•' && ipconfig getifaddr en1 && echo '') || \
		echo '• -' \
	) | tr '\n' ' '\
) && echo '' && (\
	(echo 'wireless' && \
		([ ! -z $(ipconfig getifaddr en0) ] && echo '•' && ipconfig getifaddr en0 && echo '') || \
		echo '• -' \
	) | tr '\n' ' '\
) && echo ''"
alias ips="ifconfig -a | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1'"

# Flush Directory Service cache
alias flush="dscacheutil -flushcache && killall -HUP mDNSResponder"

# Clean up LaunchServices to remove duplicates in the “Open With” menu
alias lscleanup="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"

# View HTTP traffic
alias sniff="sudo ngrep -d 'en0' -t '^(GET|POST) ' 'tcp and port 80'"
alias httpdump="sudo tcpdump -i en0 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""

# Canonical hex dump; some systems have this symlinked
command -v hd > /dev/null || alias hd="hexdump -C"

# OS X has no `md5sum`, so use `md5` as a fallback
command -v md5sum > /dev/null || alias md5sum="md5"

# OS X has no `sha1sum`, so use `shasum` as a fallback
command -v sha1sum > /dev/null || alias sha1sum="shasum"

# Trim new lines and copy to clipboard
alias pyg='pygmentize -O style=monokai -f console256 -g'

# Recursively delete `.DS_Store` files
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"

# ROT13-encode text. Works for decoding, too! ;)
alias rot13='tr a-zA-Z n-za-mN-ZA-M'

# Empty the Trash on all mounted volumes and the main HDD
# Also, clear Apple’s System Logs to improve shell startup speed
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl"

# Show/hide hidden files in Finder
alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

# Hide/show all desktop icons (useful when presenting)
alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"

# URL-encode strings
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);"'

# Merge PDF files
# Usage: `mergepdf -o output.pdf input{1,2,3}.pdf`
alias mergepdf='/System/Library/Automator/Combine\ PDF\ Pages.action/Contents/Resources/join.py'

# Disable Spotlight
alias spotoff="sudo mdutil -a -i off"
# Enable Spotlight
alias spoton="sudo mdutil -a -i on"

# PlistBuddy alias, because sometimes `defaults` just doesn’t cut it
alias plistbuddy="/usr/libexec/PlistBuddy"

# Ring the terminal bell, and put a badge on Terminal.app’s Dock icon
# (useful when executing time-consuming commands)
alias badge="tput bel"

# Intuitive map function
# For example, to list all directories that contain a certain file:
# find . -name .gitattributes | map dirname
alias map="xargs -n1"

# One of @janmoesen’s ProTip™s
for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
    alias "$method"="lwp-request -m '$method'"
done

# Stuff I never really use but cannot delete either because of http://xkcd.com/530/
alias stfu="osascript -e 'set volume output muted true'"
alias pumpitup="osascript -e 'set volume 7'"
alias hax="growlnotify -a 'Activity Monitor' 'System error' -m 'WTF R U DOIN'"


alias jboss='/usr/local/opt/jboss/bin/standalone.sh'

#safety first
alias rm='rm -i'

# Lock the screen (when going AFK)
alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"

# Kill all the tabs in Chrome to free up memory
# [C] explained: http://www.commandlinefu.com/commands/view/402/exclude-grep-from-your-grepped-output-of-ps-alias-included-in-description
alias chromekill="ps ux | grep '[C]hrome Helper --type=renderer' | grep -v extension-process | tr -s ' ' | cut -d ' ' -f2 | xargs kill"


#quick cd into common folders
alias www='cd /Users/diegobarrioh/www'

#quick access to VisualStudioCode on terminal
alias vs='/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code'
alias idea='/Applications/Intellij\ IDEA.app/Contents/MacOS/idea'
alias grd='./gradlew'


alias npmi='npm i'
alias nrs='npm run start'
alias ngp='ng serve --proxy-config proxy.conf.json'

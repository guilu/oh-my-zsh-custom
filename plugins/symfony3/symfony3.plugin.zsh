# Symfony3 basic command completion

_symfony_console () {
  echo "php $(find . -maxdepth 2 -mindepth 1 -name 'console' -type f | head -n 1)"
}

_symfony3_get_command_list () {
   `_symfony_console` --no-ansi | sed "1,/Available commands/d" | awk '/^  ?[a-z]+/ { print $1 }'
}

_symfony3 () {
   compadd `_symfony3_get_command_list`
}

compdef _symfony3 '`_symfony_console`'
compdef _symfony3 'bin/console'
compdef _symfony3 sf3

#Alias
alias sf3='`_symfony_console`'
alias sf3cl='sf3 cache:clear'
alias sf3sr='sf3 server:run -vvv'
alias sf3cw='sf3 cache:warmup'
alias sf3route='sf3 router:debug'
alias sf3container='sf3 container:debug'
alias sf3gb='sf3 generate:bundle'

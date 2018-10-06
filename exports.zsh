export LC_ALL=es_ES.UTF-8
export LANG=es_ES.UTF-8

#PYTHON(powerline)
export PATH=$PATH:/Users/diegobarrioh/Library/Python/2.7/bin

#sbin before bin
export PATH="/usr/local/sbin:$PATH"

#global composer en el path
export PATH="/Users/diegobarrioh/.composer/vendor/bin:$PATH"

#Apple has deprecated use of OpenSSL in favor of its own TLS and crypto libraries
export PATH="/usr/local/opt/openssl/bin:$PATH"

#version de java 1.7/1.8...
export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
export PATH=$JAVA_HOME/bin:$PATH
#export JBOSS_HOME=/usr/local/Cellar/jboss/jboss-eap-6.2

#gnu core utils

#export el PROXY CUANDO ES DE SABADELL
export SABADELL_PROXY="false"
function enable_sabadell_proxy() {
    export HTTP_PROXY="http://$1:$2@172.31.13.40:8080"
    export http_proxy=$HTTP_PROXY
    export HTTPS_PROXY="https://$1:$1@172.31.13.40:8080"
    export https_proxy=$HTTPS_PROXY
    export HTTP_PROXY_REQUEST_FULLURI=false
    export HTTPS_PROXY_REQUEST_FULLURI=false
    export SABADELL_PROXY="true"
}
function disable_sabadell_proxy {
    unset HTTP_PROXY
    unset http_proxy
    unset HTTPS_PROXY
    unset https_proxy
    export SABADELL_PROXY="false"
}
function is_sabadell {
    if  [[ `ipconfig getpacket en4 | grep adgbs.com` = *adgbs.com* ]]; then
        read "?Please, enter your proxy username: `echo $'\n> '`" username
        read -s "?Please, enter your proxy password: `echo $'\n> '`" pass
        enable_sabadell_proxy $username $pass
        clear
    else
        disable_sabadell_proxy
    fi
}
#invoke is_sabadell
is_sabadell
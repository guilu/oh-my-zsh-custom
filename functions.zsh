# Create a new directory and enter it
function mkd() {
  mkdir -p "$@" && cd "$_";
}

# find shorthand
function f() {
    find . -iname "*$1*" ${@:2}
}

# grep shorthand
function gr() {
	grep "$1" ${@:2} -R .
}

# cd into whatever is the forefront Finder window.
cdf() {  # short for cdfinder
  cd "`osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)'`"
}


# lets toss an image onto my server and pbcopy that bitch.
function scpp() {
    scp "$1" root@diegobarrioh.synology.me:/volume1/web/i/;
    echo "http://diegobarrioh.synology.me/i/$1" | pbcopy;
    echo "Copied to clipboard: http://diegobarrioh.synology.me/i/$1"
}

# Start an HTTP server from a directory, optionally specifying the port
function server() {
	local port="${1:-8000}"
	open "http://localhost:${port}/"
	# Set the default Content-Type to `text/plain` instead of `application/octet-stream`
	# And serve everything as UTF-8 (although not technically correct, this doesn’t break anything for binary files)
	python -c $'import SimpleHTTPServer;\nmap = SimpleHTTPServer.SimpleHTTPRequestHandler.extensions_map;\nmap[""] = "text/plain";\nfor key, value in map.items():\n\tmap[key] = value + ";charset=UTF-8";\nSimpleHTTPServer.test();' "$port"
}

# Copy w/ progress
cp_p () {
  rsync -WavP --human-readable --progress $1 $2
}


# Test if HTTP compression (RFC 2616 + SDCH) is enabled for a given URL.
# Send a fake UA string for sites that sniff it instead of using the Accept-Encoding header. (Looking at you, ajax.googleapis.com!)
function httpcompression() {
	encoding="$(curl -LIs -H 'User-Agent: Mozilla/5 Gecko' -H 'Accept-Encoding: gzip,deflate,compress,sdch' "$1" | grep '^Content-Encoding:')" && echo "$1 is encoded using ${encoding#* }" || echo "$1 is not using any encoding"
}

# Syntax-highlight JSON strings or files
function json() {
	if [ -p /dev/stdin ]; then
		# piping, e.g. `echo '{"foo":42}' | json`
		python -mjson.tool | pygmentize -l javascript
	else
		# e.g. `json '{"foo":42}'`
		python -mjson.tool <<< "$*" | pygmentize -l javascript
	fi
}


# take this repo and copy it to somewhere else minus the .git stuff.
function gitexport(){
	mkdir -p "$1"
	git archive master | tar -x -C "$1"
}



# get gzipped size
function gz() {
	echo "orig size    (bytes): "
	cat "$1" | wc -c
	echo "gzipped size (bytes): "
	gzip -c "$1" | wc -c
}

# All the dig info
function digga() {
	dig +nocmd "$1" any +multiline +noall +answer
}

# Escape UTF-8 characters into their 3-byte format
function escape() {
	printf "\\\x%s" $(printf "$@" | xxd -p -c1 -u)
	echo # newline
}

# Decode \x{ABCD}-style Unicode escape sequences
function unidecode() {
	perl -e "binmode(STDOUT, ':utf8'); print \"$@\""
	echo # newline
}

# Extract archives - use: extract <file>
# Based on http://dotfiles.org/~pseup/.bashrc
function extract() {
	if [ -f "$1" ] ; then
		local filename=$(basename "$1")
		local foldername="${filename%%.*}"
		local fullpath=`perl -e 'use Cwd "abs_path";print abs_path(shift)' "$1"`
		local didfolderexist=false
		if [ -d "$foldername" ]; then
			didfolderexist=true
			read -p "$foldername already exists, do you want to overwrite it? (y/n) " -n 1
			echo
			if [[ $REPLY =~ ^[Nn]$ ]]; then
				return
			fi
		fi
		mkdir -p "$foldername" && cd "$foldername"
		case $1 in
			*.tar.bz2) tar xjf "$fullpath" ;;
			*.tar.gz) tar xzf "$fullpath" ;;
			*.tar.xz) tar Jxvf "$fullpath" ;;
			*.tar.Z) tar xzf "$fullpath" ;;
			*.tar) tar xf "$fullpath" ;;
			*.taz) tar xzf "$fullpath" ;;
			*.tb2) tar xjf "$fullpath" ;;
			*.tbz) tar xjf "$fullpath" ;;
			*.tbz2) tar xjf "$fullpath" ;;
			*.tgz) tar xzf "$fullpath" ;;
			*.txz) tar Jxvf "$fullpath" ;;
			*.zip) unzip "$fullpath" ;;
			*) echo "'$1' cannot be extracted via extract()" && cd .. && ! $didfolderexist && rm -r "$foldername" ;;
		esac
	else
		echo "'$1' is not a valid file"
	fi
}


# animated gifs from any video
# from alex sexton   gist.github.com/SlexAxton/4989674
gifify() {
  if [[ -n "$1" ]]; then
    if [[ $2 == '--good' ]]; then
      ffmpeg -i $1 -r 10 -vcodec png out-static-%05d.png
      time convert -verbose +dither -layers Optimize -resize 600x600\> out-static*.png  GIF:- | gifsicle --colors 128 --delay=5 --loop --optimize=3 --multifile - > $1.gif
      rm out-static*.png
    else
      ffmpeg -i $1 -s 600x400 -pix_fmt rgb24 -r 10 -f gif - | gifsicle --optimize=3 --delay=3 > $1.gif
    fi
  else
    echo "proper usage: gifify <input_movie.mov>. You DO need to include extension."
  fi
}


function git_stats {
 #!/bin/bash
LOGOPTS=
END_AND_BEGIN=
#argument parsing
while [ -n "$1" ]; do
    case "$1" in
     "-s")
        shift
        END_AND_BEGIN="$END_AND_BEGIN --after=$1"
    ;;
    "-e")
        shift
        END_AND_BEGIN="$END_AND_BEGIN --before=$1"
    ;;
    "-w")
        LOGOPTS="$LOGOPTS -w"
    ;;
    "-C")
        LOGOPTS="$LOGOPTS -C --find-copies-harder"
    ;;
    "-M")
        LOGOPTS="$LOGOPTS -M"
    ;;
    esac
    shift
done

#test if the directory is a git
git branch &> /dev/null || exit 3
echo "Number of commits per author:"
git --no-pager shortlog $END_AND_BEGIN  -sn --all
AUTHORS=$(git shortlog $END_AND_BEGIN  -sn --all | cut -f2 | cut -f1 -d' ')

for a in $AUTHORS
do
    echo '-------------------'
    echo "Statistics for: $a"
    echo -n "Number of files changed: "
    git log $LOGOPTS $END_AND_BEGIN --all --numstat --format="%n" --author=$a | grep -v -e "^$" | cut -f3 | sort -iu | wc -l
    echo -n "Number of lines added: "
    git log $LOGOPTS $END_AND_BEGIN --all --numstat --format="%n" --author=$a | cut -f1 | awk '{s+=$1} END {print s}'
    echo -n "Number of lines deleted: "
    git log $LOGOPTS $END_AND_BEGIN --all --numstat --format="%n" --author=$a | cut -f2 | awk '{s+=$1} END {print s}'
    echo -n "Number of merges: "
    git log $LOGOPTS $END_AND_BEGIN --all --merges --author=$a | grep -c '^commit'

done
}


#cargar y descargar el servidor jenkins
#modificar el puerto por defecto
function jenkins
{

case "$1" in
  "load")
    #load
    sudo launchctl $1 /Library/LaunchDaemons/org.jenkins-ci.plist 2>&1
  ;;
  "unload")
    #unload
    sudo launchctl $1 /Library/LaunchDaemons/org.jenkins-ci.plist 2>&1
  ;;
  "port")
    #cambia el puerto por defecto
    if [[ "$2" =~ ^[0-9]+$ ]]; then
      sudo defaults write /Library/Preferences/org.jenkins-ci httpPort $2
    else
      echo "Tienes que pasar un número de puerto." >&2
    fi
  ;;
  *)
    echo "Usa: {load|unload}" >&2
  ;;
esac
}


delete_DS(){
	find . -name '*.DS_Store' -type f -delete
}

sf2_permissions(){
    rm -rf app/cache/*
    rm -rf app/logs/*
    APACHEUSER=`ps aux | grep -E '[a]pache|[h]ttpd' | grep -v root | head -1 | cut -d\  -f1`
    sudo /bin/chmod +a "$APACHEUSER allow delete,write,append,file_inherit,directory_inherit" app/cache app/logs
    sudo /bin/chmod +a "`whoami` allow delete,write,append,file_inherit,directory_inherit" app/cache app/logs
}

function apache_permissions
{
    APACHEUSER=`ps aux | grep -E '[a]pache|[h]ttpd|[_]www|[w]ww-data' | grep -v root | head -1 | cut -d\  -f1`
    #tiene que ser el de /bin/chmod si estamos usando coreutils gnubin ... este chmod no va....
    sudo /bin/chmod -R +a "$APACHEUSER allow delete,write,append,file_inherit,directory_inherit" $1
    sudo /bin/chmod -R +a "`whoami` allow delete,write,append,file_inherit,directory_inherit" $1
}


#renombrar el usuario de todos los commits de un proyecto
function git_change_author_name
{
    if [[ -n "$2" ]]; then
        #necesita  #change name: git change-commits GIT_AUTHOR_EMAIL "old@email.com" "new@email.com" -- -10
        git change-commits  GIT_AUTHOR_NAME "$1" "$2" -- --all
    else
        echo "proper usage: git_change_user old_user new_user"
    fi
}

#borrar un fichero de la historia de git
function git_purge_one_file
{
  git filter-branch --force --index-filter \
'git rm --cached --ignore-unmatch $1' \
--prune-empty --tag-name-filter cat -- --all
}

#tamaño de una carpeta
tam(){
    du -sh $1
}

delete_maven_unfinished_downloads(){
    find ~/.m2  -name "*.lastUpdated" -exec grep -q "Could not transfer" {} \; -print -exec rm {} \;
}

clean_caches(){
    rm -rf ~/Library/Caches/*
    rm -rf /Library/Caches/*
}

sf2_project(){
  if [[ -n "$2" ]]; then
    composer create-project symfony/framework-standard-edition $1 $2
    echo "dos parametros"
  else
     echo $'Usa: sf2_project <nombre_proyecto> <symfony_version>\n\tpor ejemplo: sf2_project miweb 2.5.*' >&2
  fi

}


#FUNCION DE BACKUP DE UN DIERCTORIO (full & incremental)
function incbackup() {
  if [ -f $1 ]; then
    #extraer en un directorio y volver a comprimir
    echo "Updating Backup File: $1"
    tar uf $1 $2
  else
    echo "No hay fichero previo para incrementar"
  fi
}

function fullbackup() {
  tar cpf $1 $2
}

function backup(){
  #source dir without ending / 
  SOURCEDIR=${1%/}
  OUTPUTFILE=${1%/}-$(date +%Y%m%d%H%M).tar
  USERFILE="${1%/}-*.tar"

  if [[ $2 = f ]] || [[ $2 = i ]]; then
    if [ $2 = f ]; then
      echo "Running Full Backup..."
      fullbackup "./"$OUTPUTFILE $SOURCEDIR
    fi
    if [ $2 = i ]; then
      echo "Running Incremental Backup..."
        incbackup $USERFILE $SOURCEDIR
      fi
  else

    echo "usage backup [username] [f for full or i for incremental]"
  fi
}

function speedtest(){
  #prueba la velocidad de descarga. 3 tamaños:
  #http://speedtest.wdc01.softlayer.com/downloads/test10.zip -> 10M
  #http://speedtest.wdc01.softlayer.com/downloads/test100.zip -> 100M
  #http://speedtest.wdc01.softlayer.com/downloads/test1000.zip --> 1G
  if [[ -n "$1" ]]; then
    case "$1" in
      "10")
        wget -O /dev/null http://speedtest.wdc01.softlayer.com/downloads/test10.zip
        ;;
      "100")
        wget -O /dev/null http://speedtest.wdc01.softlayer.com/downloads/test100.zip
        ;;
      "1000")
        wget -O /dev/null http://speedtest.wdc01.softlayer.com/downloads/test1000.zip
        ;;
      *)
        echo "Los tamaños permitidos son 10,100 o 1000" >&2
        ;;
    esac
  else
       echo $'Indica el tamaño del fichero de prueba: speedtest <tam> \n\tDonde tam es 10,100,1000.' >&2
  fi
  
}


function  camerausedby() {
    echo "Checking to see who is using the iSight camera… 📷"
    usedby=$(lsof | grep -w "AppleCamera\|VDC\|iSight" | awk '{printf $2"\n"}' | xargs ps)
    echo -e "Recent camera uses:\n$usedby"
}

function varnish(){
  case "$1" in
  "start")
    #load
    sudo /usr/local/bin/varnishd -n /usr/local/var/varnish -f /usr/local/etc/varnish/default.vcl -s malloc,1G  -a 0.0.0.0:80  
  ;;
  "stop")
    #unload
    sudo pkill varnishd
  ;;
  *)
    echo "Usa: {start|stop}" >&2
  ;;
esac
}


function getip() { (traceroute $1 2>&1 | head -n 1 | cut -d\( -f 2 | cut -d\) -f 1) }

function dockercli() {
    /Applications/Docker/Docker\ Quickstart\ Terminal.app/Contents/Resources/Scripts/start.sh
}

function docker_mysql_local() {
  if [[ -n "$4" ]]; then
  MYSQL_ROOT_PASSWORD=$1
  MYSQL_DATABASE=$2
  MYSQL_USER=$3
  MYSQL_PASSWORD=$4
  container_id=$(docker run -it -d --name mysql -v /Users/diegobarrioh/data/mysql:/var/lib/mysql -p 3306:3306 mysql)
  else
    echo $'usa: docker_mysql_local MYSQL_ROOT_PASSWORD MYSQL_DATABASE MYSQL_USER MYSQL_PASSWORD' >&2
  fi
}

function docker_pgsql_local() {
  if [[ -n "$3" ]]; then
  POSTGRES_PASSWORD=$1
  POSTGRES_DB=$2
  POSTGRES_USER=$3
  container_id=$(docker run -it -d --name pgsql -v /Users/diegobarrioh/data/pgsql:/var/lib/postgresql/data -p 5432:5432 postgres)
  else
    echo $'usa: docker_pgsql_local PGSQL_ROOT_PASSWORD PGSQL_DATABASE PGSQL_USER' >&2
  fi
}

function delete_all_stopped_containers(){
  docker ps -aq | xargs docker rm
}

function colors(){
  for x in {0..1}; do 
    for i in {30..37}; do 
        for a in {40..47}; do 
            echo -ne "\e[$x;$i;$a""m \\\e[$x;$i;$a""m \e[0;37;40m "
        done
        echo
    done
    echo
done
}
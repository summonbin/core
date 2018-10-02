#!/bin/sh
BASE_URL="https://raw.githubusercontent.com/summonbin"
INSTALL_PATH="summon"
SCHEME_ROOT="executable"
DEFAULT_SCHEME="$SCHEME_ROOT/debug"
DEFAULT_CACHE_PATH="\$HOME/.summon"

mkdir -p "$INSTALL_PATH"
mkdir -p "$DEFAULT_SCHEME"


#########################
#### Add init script ####
#########################

if [ ! -f "$SCHEME_ROOT/init" ]
then
  echo "curl -L $BASE_URL/core/0.1.0/scripts/init.sh | sh" >> "$SCHEME_ROOT/init"
  chmod +x "$SCHEME_ROOT/init"
fi


###################################
#### Add bin on default scheme ####
###################################

touch "$DEFAULT_SCHEME/bin"


##########################
#### Build summon/bin ####
##########################

curl -L "$BASE_URL/core/0.1.0/scripts/bin.sh" -o "$INSTALL_PATH/bin"
chmod +x "$INSTALL_PATH/bin"


##################################
#### Add summon to .gitignore ####
##################################

if [ -z $(grep "^summon""$" ".gitignore") ]
then
  echo "summon" >> .gitignore
fi


##############################
#### Install core drivers ####
##############################

curl -L "$BASE_URL/binary/0.1.0/scripts/init.sh" | sh -s "$INSTALL_PATH" "$DEFAULT_SCHEME" "$DEFAULT_CACHE_PATH"
curl -L "$BASE_URL/swift/0.1.0/scripts/init.sh" | sh -s "$INSTALL_PATH" "$DEFAULT_SCHEME" "$DEFAULT_CACHE_PATH"
curl -L "$BASE_URL/ruby/0.1.0/scripts/init.sh" | sh -s "$INSTALL_PATH" "$DEFAULT_SCHEME" "$DEFAULT_CACHE_PATH"
curl -L "$BASE_URL/node/0.1.0/scripts/init.sh" | sh -s "$INSTALL_PATH" "$DEFAULT_SCHEME" "$DEFAULT_CACHE_PATH"

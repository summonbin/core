#!/bin/sh
#######################
#### Configuration ####
#######################

CONFIG_DIR=executable


#########################
#### Parse arguments ####
#########################

BASE_DIR=$(dirname "$0")
BIN_ARGS=()

for i
do
  BIN_ARGS+=(\"${i}\")
done

if [ -d "$CONFIG_DIR/$1" ]
then
  SCHEME="$CONFIG_DIR/$1"
  BIN_NAME_TO_EXECUTE=$2
  unset BIN_ARGS[0]
  unset BIN_ARGS[1]
  BIN_ARGS=${BIN_ARGS[@]}
else
  SCHEME="$CONFIG_DIR/debug"
  BIN_NAME_TO_EXECUTE=$1
  unset BIN_ARGS[0]
  BIN_ARGS=${BIN_ARGS[@]}
fi


####################
#### Source env ####
####################

if [ -f "$SCHEME/env" ]
then
  source "$SCHEME/env"
fi


##################
#### Read bin ####
##################

while read LINE
do
  BIN_CONFIGS=($LINE)
  if [ ! "${BIN_CONFIGS[0]}" = "$BIN_NAME_TO_EXECUTE" ]
  then
    continue
  fi
  if [ -d "$BASE_DIR/$BIN_NAME_TO_EXECUTE" ]
  then
    DRIVER="$BIN_NAME_TO_EXECUTE"
    sh "$BASE_DIR/$DRIVER/$DRIVER.sh" "$SCHEME/$DRIVER" ${BIN_CONFIGS[1]} $BIN_ARGS
  else
    DRIVER=${BIN_CONFIGS[1]}
    unset BIN_CONFIGS[1]
    sh "$BASE_DIR/$DRIVER/run.sh" "$SCHEME/$DRIVER" ${BIN_CONFIGS[@]} $BIN_ARGS
  fi
done < $SCHEME/bin

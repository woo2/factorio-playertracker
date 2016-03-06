#!/bin/bash
PATHTOLOG="/dev/null"

OLDPLAYERCOUNT=0
PLAYERCOUNT=0
NUMBEROFLINESOLD=0

while :; do
  #get the current nuber of log entries
  NUMBEROFLINES=$(wc -l $PATHTOLOG | grep -o " [0-9]\+ " | grep -o "[0-9]\+")
  
  ABSOLUTELINES=$(($NUMBEROFLINES-$NUMBEROFLINESOLD))
  #only look at new lines
  TAILEDLOG=$(tail -$ABSOLUTELINES $PATHTOLOG)

  #grab Joins PlayerJoinGame
  JOINS=$(echo "$TAILEDLOG" | grep "Received" | wc -l | grep -o "[0-9]\+")
  JOINSGAME=$(echo "$TAILEDLOG" | grep "PlayerJoinGame" | wc -l | grep -o "[0-9]\+")
  #grab peer leaving
  QUITS=$(echo "$TAILEDLOG" | grep "PlayerLeaveGame" | wc -l | grep -o "[0-9]\+")
  #grab peer timeout
  DROPOUTS=$(echo "$TAILEDLOG" | grep "is not responding, dropping" | wc -l | grep -o "[0-9]\+")

  QUITS=$(($QUITS+$DROPOUTS))
  JOINS=$(($JOINS+$JOINSGAME))

  PLAYERCOUNT=$(($PLAYERCOUNT+$JOINS))
  PLAYERCOUNT=$(($PLAYERCOUNT-$QUITS))

  if [ $PLAYERCOUNT -eq 1 -a $OLDPLAYERCOUNT -eq 0 ]
  then
    WID=`xdotool search "Factorio" | head -1` #These commands should be in a function.
    xdotool windowactivate --sync $WID
    xdotool key ctrl+space
  fi

  if [ $PLAYERCOUNT -eq 0 -a $OLDPLAYERCOUNT -eq 1 ]
  then
    WID=`xdotool search "Factorio" | head -1`
    xdotool windowactivate --sync $WID
    xdotool key ctrl+space
  fi

  if [ $PLAYERCOUNT -eq 2 -a $OLDPLAYERCOUNT -eq 1 ]
  then
    WID=`xdotool search "Factorio" | head -1`
    xdotool windowactivate --sync $WID
    xdotool key ctrl+space
  fi

  if [ $PLAYERCOUNT -eq 1 -a $OLDPLAYERCOUNT -eq 2 ]
  then
    WID=`xdotool search "Factorio" | head -1`
    xdotool windowactivate --sync $WID
    xdotool key ctrl+space
  fi

  #REMOVE the following line if you don't want to see current players.
  echo $PLAYERCOUNT

  OLDPLAYERCOUNT=$PLAYERCOUNT
  NUMBEROFLINESOLD=$NUMBEROFLINES
  #change to number of seconds between player count update [default: 1 sec]
  sleep 1
done

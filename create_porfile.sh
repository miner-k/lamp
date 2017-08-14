#!/bin/bash

PROFILE_DIR=/etc/profile.d

set_path(){
	echo "export PATH=\$PATH:$PREFIX/$1/bin" > $PROFILE_DIR/$1.sh
	source $PROFILE_DIR/$1.sh
}

set_path apache
set_path mysql

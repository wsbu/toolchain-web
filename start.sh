#!/bin/bash


with_default () {
	if [[ "${!1}" == "" ]]; then
		eval "$1=\"$2\""
	fi
}

with_default GIT_BRANCH "dev"
with_default GIT_EMAIL_ADDRESS "Paul.Dorn@gmail.com"
with_default GIT_EMAIL_NAME "Paul Dorn"
with_default GIT_WORKDIR ""
with_default GIT_REPO "/repo"
with_default GIT_CLONE 0
with_default GIT_CHECKOUT 0
with_default NPM_INSTALL 0
with_default BOWER_DIRS ""

do_clone () {
	git clone "$GIT_REPO" "$GIT_WORKDIR"
	git config --global user.email "$GIT_EMAIL_ADDRESS"
	git config --global user.name "$GIT_EMAIL_NAME"
	cd "$GIT_WORKDIR"
}
npm config set registry https://registry.npmjs.org/ 2>&1 | grep -v WARN

if (( GIT_CLONE != 0 )); then
	if [[ "$GIT_REPO" =~ ^git ]]; then
		if [ -e "/ssh" ]; then
			USER_SSH_DIR=~/.ssh
			mkdir $USER_SSH_DIR
			sudo cp /ssh/* $USER_SSH_DIR
			sudo chown -R 1000:1000 $USER_SSH_DIR
			do_clone
		else
			echo "No SSH identity files were found in /ssh."
			exit
		fi
	else
		do_clone
	fi
    else
	if [[ "$GIT_WORKDIR" != "" ]]; then
	    cd "$GIT_WORKDIR"
	fi
fi

if (( GIT_CHECKOUT != 0 )); then
	git checkout $GIT_BRANCH
fi

if (( NPM_INSTALL != 0 )); then
	echo "Running npm install"
	npm install 2>&1 | grep -v WARN
fi

for element in ${BOWER_DIRS[@]}; do
	cd $PWD/$element
	bower install --config.interactive=false
	cd - > /dev/null
done

if (( RESET != 0 )); then
	touch conf/config.json && rm conf/config.json
fi

if (( $# == 0 )); then
	/bin/bash
elif [[ -z "${RUN_AS_SUDO}" || "0" == "${RUN_AS_SUDO}" ]]; then
    exec "${@}"
else
	sudo "${@}"
fi

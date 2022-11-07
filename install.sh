#!/bin/bash

bootstrap_env() {
    HELPERS_DIRECTORY=$PWD
    ENV_FILE_LOCATION=$HELPERS_DIRECTORY/.env

    if [[ -f $ENV_FILE_LOCATION ]]; then
        echo "[INFO] Skipping creation of $ENV_FILE_LOCATION, because it already exists"
        return
    fi

    echo "[INFO] Creating .env file"
    cat >> $ENV_FILE_LOCATION <<EOF
export HELPERS_DIRECTORY=$HELPERS_DIRECTORY
EOF

source $ENV_FILE_LOCATION
}

bootstrap_path() {
    bash -c "scripts/blh_add_scripts $HELPERS_DIRECTORY/scripts"
}

modify_rc() {
    RC_FILE=""

    case "$SHELL" in
        "/bin/bash")
            RC_FILE=".bashrc"
            ;;
        "/bin/zsh")
            RC_FILE=".zshrc"
            ;;
        *)
            echo "[ERROR] Unsupported shell"
            exit 1
            ;;
    esac

    RC_FILE_LOCATION="$HOME/$RC_FILE"
    RC_COMMENT="# BASHS LITTLE HELPER SCRIPTS"

    if grep -qxF "$RC_COMMENT" $RC_FILE_LOCATION ; then
        echo "[INFO] Skipping modification of $RC_FILE_LOCATION, because it already exists"
        return
    fi

    echo "[INFO] Modifying $RC_FILE_LOCATION..."
    cat >> $RC_FILE_LOCATION <<EOF

$RC_COMMENT
[ -f $PWD/.env ] && source $PWD/.env
[ -f $PWD/bashrc.sh ] && source $PWD/bashrc.sh

EOF

source bashrc.sh
}

bootstrap_env
bootstrap_path
modify_rc

echo "[DONE]"

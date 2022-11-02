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
}

bootstrap_path() {
    HELPERS_DIRECTORY=$PWD
    PATH_FILE_LOCATION=$HELPERS_DIRECTORY/.path

    if [[ -f $PATH_FILE_LOCATION ]]; then
        echo "[INFO] Skipping creation of $PATH_FILE_LOCATION, because it already exists"
        return
    fi

    echo "[INFO] Creating .path file"
    cat >> $PATH_FILE_LOCATION <<EOF
export PATH="$HELPERS_DIRECTORY/scripts:\$PATH"
EOF
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
[ -f $PWD/.path ] && source $PWD/.path

EOF
}

bootstrap_env
bootstrap_path
modify_rc

echo "[DONE] Reload your shell for changes to be effective"

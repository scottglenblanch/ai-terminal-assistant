#!/usr/bin/env bash

GITHUB_REPO=""
INSTALL_DIR=""

does_command_exists() {
    command_to_check="$@"
    
    if type "$command_to_check" &> /dev/null; then
        echo "true"
    else
        echo "false"
    fi
}

init_variables() {
    echo "Initializing variables"
    
    GITHUB_REPO="https://github.com/scottglenblanch/ai-terminal-assistant.git"
    INSTALL_DIR="$(pwd)/ai-terminal-assistant"    
}

download_tgpt() {
    BIN_DIRECTORY="$([ -e "/usr/local/bin" ] && echo "/usr/local/bin" || echo "~/usr/local/bin")" 

    if [ "$(does_command_exists "tgpt")" == "true" ]; then
        echo "tgpt exists. No need to download tgpt"
    else
        echo "tgpt DOES NOT exist. Downloading tgpt to "${BIN_DIRECTORY}"..."
        curl -sSL https://raw.githubusercontent.com/aandrew-me/tgpt/main/install | bash -s "${BIN_DIRECTORY}"
    fi
}

download_repo() {

    if git -C "$(pwd)" rev-parse --git-dir &> /dev/null; then
        git submodule add "${GITHUB_REPO}"
    else
        git clone "${GITHUB_REPO}" "${INSTALL_DIR}"
    fi    
}

update_path_variable() {
    USER_SHELL=$(basename "${SHELL}")

    RC_FILE=""
    # Update the PATH variable in the corresponding rc file
    case ${USER_SHELL} in
        "bash")
            RC_FILE="${HOME}/.bashrc"
            ;;
        "zsh")
            RC_FILE="${HOME}/.zshrc"
            ;;
        # Add more cases for other shells if needed
        *)
            echo "Unsupported shell: ${USER_SHELL}"
            exit 1
            ;;
    esac

    # Export PATH update to rc file
    echo "export PATH=\$PATH:${INSTALL_DIR}/src" >> "${RC_FILE}"
}

run() {
    init_variables
    download_tgpt
    download_repo
    update_path_variable
}

run

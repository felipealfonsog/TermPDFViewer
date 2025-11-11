#!/bin/bash

: '
▀▀█▀▀ █▀▀ █▀▀█ █▀▄▀█ ▒█▀▀█ ▒█▀▀▄ ▒█▀▀▀ 　 ▒█░░▒█ ░▀░ █▀▀ █░░░█ █▀▀ █▀▀█ 
░▒█░░ █▀▀ █▄▄▀ █░▀░█ ▒█▄▄█ ▒█░▒█ ▒█▀▀▀ 　 ░▒█▒█░ ▀█▀ █▀▀ █▄█▄█ █▀▀ █▄▄▀ 
░▒█░░ ▀▀▀ ▀░▀▀ ▀░░░▀ ▒█░░░ ▒█▄▄▀ ▒█░░░ 　 ░░▀▄▀░ ▀▀▀ ▀▀▀ ░▀░▀░ ▀▀▀ ▀░▀▀

*************************************************
TermPDF Viewer - view and navigate PDF files within the terminal.
*************************************************
*  Simple: TermPDF Viewer is a Python program that enables users to 
view and navigate PDF files directly within the terminal.
*************************************************
* Developed and engineered by:
* Felipe Alfonso Gonzalez <f.alfonso@res-ear.ch>
* Computer Science Engineer
* Chile
*************************************************
* Prerequisites:
* Python 3.x: The program is written in Python and requires a Python 3.x interpreter to run.
* PyMuPDF: A Python binding for the MuPDF library, used to handle PDF file rendering and interaction.
*   You can install it using pip: pip install PyMuPDF
*   Make sure to include the appropriate model or adapt it for your needs.
*************************************************
'

welcome_message() {
    echo
    echo "▀▀█▀▀ █▀▀ █▀▀█ █▀▄▀█ ▒█▀▀█ ▒█▀▀▄ ▒█▀▀▀ 　 ▒█░░▒█ ░▀░ █▀▀ █░░░█ █▀▀ █▀▀█"
    echo "░▒█░░ █▀▀ █▄▄▀ █░▀░█ ▒█▄▄█ ▒█░▒█ ▒█▀▀▀ 　 ░▒█▒█░ ▀█▀ █▀▀ █▄█▄█ █▀▀ █▄▄▀"
    echo "░▒█░░ ▀▀▀ ▀░▀▀ ▀░░░▀ ▒█░░░ ▒█▄▄▀ ▒█░░░ 　 ░░▀▄▀░ ▀▀▀ ▀▀▀ ░▀░▀░ ▀▀▀ ▀░▀▀"
    echo "-------------------------------------------------------------------------"
    echo "TermPDF Viewer - view and navigate PDF files within the terminal."
    echo "-------------------------------------------------------------------------"
    echo "*  Simple: TermPDF Viewer is a Python program that enables users to "
    echo "*  view and navigate PDF files directly within the terminal."
    echo "-------------------------------------------------------------------------"
    echo
    echo "╭────────────-----────── TERMS OF USE ──────────----------───╮"
    echo "│  This software is licensed under the MIT License.          │"
    echo "│  By Felipe Alfonso González - github.com/felipealfonsog    │"
    echo "│  Computer Science Engineer - Email: f.alfonso@res-ear.ch   │"
    echo "╰───────────────────────────────────────────────---------────╯"
    echo
    echo "Welcome to the TermPDF Viewer Installer!"
    echo "This script will install the TermPDF Viewer program on your system."
    echo "Please make sure you have the necessary permissions to perform the installation."
    echo "Press Enter to continue or Ctrl+C to exit."
    read
}

fix_externally_managed() {
    echo "Checking for EXTERNALLY-MANAGED restriction files..."
    
    local search_paths=(
        "/opt/homebrew/Cellar/python@*/*/Frameworks/Python.framework/Versions/*/lib/python*/EXTERNALLY-MANAGED"
        "/usr/local/Cellar/python@*/*/Frameworks/Python.framework/Versions/*/lib/python*/EXTERNALLY-MANAGED"
        "/usr/lib/python*/EXTERNALLY-MANAGED"
        "/usr/local/lib/python*/EXTERNALLY-MANAGED"
    )
    
    local found_any=false
    
    for path in "${search_paths[@]}"; do
        for file in $(find $(dirname "$path" 2>/dev/null) -name EXTERNALLY-MANAGED 2>/dev/null); do
            echo "Found: $file"
            sudo mv "$file" "${file}_"
            echo "Renamed to: ${file}_"
            found_any=true
        done
    done

    if [ "$found_any" = true ]; then
        echo "EXTERNALLY-MANAGED files renamed. Pip installations should work now."
    else
        echo "No EXTERNALLY-MANAGED files found."
    fi
}

install_dependencies() {
    if ! command -v python3 &>/dev/null; then
        echo "Python not found. Installing Python..."
        if [[ "$(uname -s)" == "Darwin" ]]; then
            brew install python
        else
            sudo apt install -y python3 python3-pip
        fi
    else
        echo "Python is already installed"
    fi

    if ! command -v pip3 &>/dev/null; then
        echo "Pip not found. Installing pip..."
        if [[ "$(uname -s)" == "Darwin" ]]; then
            brew install python
        else
            sudo apt install -y python3-pip
        fi
    else
        echo "Pip is already installed"
    fi

    if ! pip3 show PyMuPDF &>/dev/null; then
        echo "PyMuPDF not found. Installing PyMuPDF..."
        pip3 install PyMuPDF
    else
        echo "PyMuPDF is already installed"
    fi

    if ! pip3 show termcolor &>/dev/null; then
        echo "Termcolor library not found. Installing Termcolor..."
        pip3 install termcolor
    else
        echo "Termcolor is already installed"
    fi
}

download_wrp() {
    local os=$(uname -s)
    local installer_url="https://github.com/felipealfonsog/TermPDFViewer/raw/main/src/term-pdf-wrp.c"

    if [[ "$os" == "Darwin" || "$os" == "Linux" ]]; then
        echo "Downloading the term-pdf-wrp (Wrapper)..."
        curl -o term-pdf-wrp.c -L "$installer_url"
    else
        echo "Unsupported platform."
        exit 1
    fi
}

download_termpdf() {
    local os=$(uname -s)
    local installer_url="https://github.com/felipealfonsog/TermPDFViewer/raw/main/src/termpdf.py"

    if [[ "$os" == "Darwin" || "$os" == "Linux" ]]; then
        echo "Downloading the termpdf..."
        curl -o termpdf.py -L "$installer_url"
    else
        echo "Unsupported platform."
        exit 1
    fi
}

compile_term_pdf_wrapper() {
    echo "Compiling term-pdf-wrapper..."
    gcc -o term-pdf-wrapper term-pdf-wrp.c || { 
        echo "Error: Compilation failed." 
        exit 1
    }
    sudo chmod +x term-pdf-wrapper
    echo "Compilation successful."
}

move_to_bin_directory() {
    echo "Moving compiled binary to bin directory..."
    sudo mv termpdf.py "/usr/local/bin"
    sudo mv term-pdf-wrapper "/usr/local/bin/term-pdf"
    sudo chmod +x "/usr/local/bin/termpdf.py"
    sudo chmod +x "/usr/local/bin/term-pdf"
    echo "Binary moved to '/usr/local/bin' and permissions set."
}

remove_compiled_file() {
    echo "Removing unnecessary files..."
    rm -rf *.c
    rm -rf *.py 
    rm installer.sh
    echo "Cleanup complete."
}

welcome_message
fix_externally_managed
install_dependencies
download_wrp
download_termpdf
compile_term_pdf_wrapper
move_to_bin_directory
remove_compiled_file

echo "TermPDF Viewer has been successfully installed as 'term-pdf' command!"

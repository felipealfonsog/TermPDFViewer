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
* How to run the TermPDF Viewer:

* Clone the TermPDF Viewer repository from GitHub.
* Navigate to the project directory:

* cd TermPDF-Viewer

* Install PyMuPDF library (if not already installed):
  pip install PyMuPDF

* Run the TermPDF Viewer:
* python termpdf.py

* The TermPDF Viewer will start, allowing you to:
* Scan for PDF files in the current directory.
* Select a PDF file to view by entering its number.
* View the PDF with options to move back, forward, or return to the main menu.
* Quit and return to the main menu.
* To exit the TermPDF Viewer, use 'q' in the main menu.
*
*************************************************
* Important Notes:
* - The application has been tested on Linux and macOS.
* - For Windows, additional configurations may be required.
* - Make sure to fulfill the prerequisites before running the application.
* - For more information, please refer to the project documentation.
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

install_homebrew() {
    if ! command -v brew &>/dev/null; then
        echo "Homebrew not found. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
}


install_dependencies() {
    if ! command -v python &>/dev/null; then
        echo "Python not found. Installing Python..."
        brew install python
    else
        echo "Python is already installed"
    fi

    if ! command -v pip &>/dev/null; then
        echo "Pip not found. Installing pip..."
        brew install python
    else
        echo "Pip is already installed"
    fi

    if ! pip show pymupdf &>/dev/null; then
        echo "PyMuPDF not found. Installing PyMuPDF..."
        pip install PyMuPDF
    else
        echo "PyMuPDF is already installed"
    fi
}



download_binary() {
    local os=$(uname -s)
    local binary_url=""
    local binary_name=""

    if [[ "$os" == "Darwin" ]]; then
        binary_url="https://github.com/felipealfonsog/TermPDFViewer/raw/main/dist/macos/termpdf-macos"
        binary_name="termpdf-macos"
    elif [[ "$os" == "Linux" ]]; then
        binary_url="https://github.com/felipealfonsog/TermPDFViewer/raw/main/dist/linux/termpdf-linux"
        binary_name="termpdf-linux"
    else
        echo "Unsupported platform."
        exit 1
    fi

    curl -o "$binary_name" -L "$binary_url" #Changed for curl 
}

move_to_bin_directory() {
    local os=$(uname -s)
    local binary_name=""
    local dest_dir=""

    if [[ "$os" == "Darwin" ]]; then
        dest_dir="/usr/local/bin"
        binary_name="termpdf-macos"
    elif [[ "$os" == "Linux" ]]; then
        dest_dir="/usr/bin"
        binary_name="termpdf-linux"
    else
        echo "Unsupported platform."
        exit 1
    fi

    sudo mv "$binary_name" "$dest_dir/term-pdf"
}


remove_compiled_file() {
    local os=$(uname -s)
    local script_name="$0"

    if [[ "$os" == "Darwin" ]]; then
        # On macOS, remove the downloaded binary instead
        rm "$script_name"
    elif [[ "$os" == "Linux" ]]; then
        # On Linux, remove the downloaded binary instead
        rm "$script_name"
    else
        echo "Unsupported platform."
        exit 1
    fi
}

set_permissions() {
    local os=$(uname -s)
    local binary_name=""

    if [[ "$os" == "Darwin" ]]; then
        binary_name="termpdf-macos"
        sudo chmod +x "/usr/local/bin/term-pdf"
    elif [[ "$os" == "Linux" ]]; then
        binary_name="termpdf-linux"
        sudo chmod +x "/usr/bin/term-pdf"
    else
        echo "Unsupported platform."
        exit 1
    fi
}


welcome_message
install_homebrew
install_dependencies
download_binary
move_to_bin_directory
remove_compiled_file
set_permissions

echo "TermPDF Viewer has been successfully installed as 'term-pdf' command!"

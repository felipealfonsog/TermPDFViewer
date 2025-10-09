
'''


▀▀█▀▀ █▀▀ █▀▀█ █▀▄▀█ ▒█▀▀█ ▒█▀▀▄ ▒█▀▀▀ 　 ▒█░░▒█ ░▀░ █▀▀ █░░░█ █▀▀ █▀▀█ 
░▒█░░ █▀▀ █▄▄▀ █░▀░█ ▒█▄▄█ ▒█░▒█ ▒█▀▀▀ 　 ░▒█▒█░ ▀█▀ █▀▀ █▄█▄█ █▀▀ █▄▄▀ 
░▒█░░ ▀▀▀ ▀░▀▀ ▀░░░▀ ▒█░░░ ▒█▄▄▀ ▒█░░░ 　 ░░▀▄▀░ ▀▀▀ ▀▀▀ ░▀░▀░ ▀▀▀ ▀░▀▀

*************************************************
TermPDF Viewer - view and navigate PDF files within the terminal.
.................................................
 This software is licensed under the MIT License. 
 Released on: 2019-07-31
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
* ----------------------------------------------------------------- -----------------------
* If you have any issue with pip, fix the pip lock using the following script:
*   https://gist.github.com/felipealfonsog/d3bf4d70504f52c03094d2c0d79992b0
*-----------------------------------------------------------------  ------------------------
*   Make sure to include the appropriate model or adapt it for your needs.
*************************************************

* Install PyMuPDF library (if not already installed):
  pip install PyMuPDF
  pip install termcolor

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
'''


import os
import fitz
import re
from termcolor import colored

def scan_pdf_files():
    pdf_files = [file for file in os.listdir('.') if file.lower().endswith('.pdf')]
    return pdf_files

def display_current_page(doc, current_page, total_pages, keyword=None):
    if not (0 <= current_page < total_pages):
        print("Invalid page number.")
        return

    page = doc[current_page]
    print(f'Page {current_page + 1} / {total_pages}')
    text = page.get_text()

    if keyword:
        # Highlight occurrences of the keyword using regular expressions
        highlighted_text = re.sub(rf'(?i)\b{re.escape(keyword)}\b', lambda match: colored(match.group(), 'red', attrs=['bold']), text)
        print(highlighted_text)
    else:
        print(text)
        

def search_keyword(doc, total_pages, keyword):
    found_pages = []

    for page_num in range(total_pages):
        text = doc[page_num].get_text().lower()
        if keyword in text:
            found_pages.append(page_num)

    if not found_pages:
        print(f"No matches found for '{keyword}'.")
        return found_pages

    if keyword.lower() == 'q':
        return start_page

    print(f"Found {len(found_pages)} matches for '{keyword}'.")
    print("Pages found:")
    for page_num in found_pages:
        print(f"- Page {page_num + 1}")
    print("Enter 'enter' to continue the search or 'q' to exit the search.")
    choice = input("Enter your choice: ")
    if choice == 'q':
        return start_page
    elif choice == 'enter':
        return found_pages       

    return found_pages

def display_search_results(doc, total_pages, keyword, start_page):
    found_pages = search_keyword(doc, total_pages, keyword)

    if not found_pages:
        print(f"No more matches found for '{keyword}'.")
        return start_page

    for page_num in found_pages:
        display_current_page(doc, page_num, total_pages, keyword)
        choice = input("Press 'c' to continue searching, 'q' to exit, 'o' to open the page, 'r' to return to the start page: ")

        if choice == 'q':
            break
        elif choice == 'o':
            print(f"Opening page {page_num + 1}...")
            # Placeholder for opening the page; implement logic here
        elif choice == 'r':
            return start_page
            # Testing option
            # display_current_page(doc, page_num, total_pages, keyword)

    return found_pages[-1]  # Return the last found page

def display_pdf(pdf_filename):
    try:
        doc = fitz.open(pdf_filename)
        total_pages = doc.page_count
        current_page = 0

        while True:
            if not (0 <= current_page < total_pages):
                print("Invalid page number.")
                break

            page = doc[current_page]
            display_current_page(doc, current_page, total_pages)

            choice = input("Enter 'b' to go back, 'f' to go forward, 's' to search, 'q' to quit: ")
            if choice == 'b':
                current_page = max(current_page - 1, 0)
            elif choice == 'f':
                current_page = min(current_page + 1, total_pages - 1)
            elif choice == 'q':
                break
            elif choice.lower() == 's':
                keyword = input("Enter the keyword to search: ").lower()
                current_page = display_search_results(doc, total_pages, keyword, current_page)
    except Exception as e:
        print(f"Error: {e}")
    finally:
        if 'doc' in locals():
            doc.close()

def display_about():
    print("------------------------------------------------------------------")
    print("TermPDF Viewer - Credits & License.")
    print("------------------------------------------------------------------")
    print("*  Simple: TermPDF Viewer is a Python program that enables users to ")
    print("*  view and navigate PDF files directly within the terminal.")
    print("------------------------------------------------")
    print("* Developed and engineered by:")
    print("* Felipe Alfonso Gonzalez <f.alfonso@res-ear.ch>")
    print("* Computer Science Engineer")
    print("* Chile")
    print("------------------------------------------------")
    print("* Find me on GitHub: github.com/felipealfonsog")
    print("* License: MIT & BSD v3 - Restrictive by author")
    print("------------------------------------------------")

def display_faq():
    print("* ------------------------------------------------- \n"
          "* The TermPDF FAQ & Usage:\n"
          "* The TermPDF Viewer will start, allowing you to:\n"
          "* -------------------------------------------------\n"
          "* Scan for PDF files in the current directory.\n"
          "* Select a PDF file to view by entering its number.\n"
          "* View the PDF with options to move back, forward, search, or return to the main menu.\n"
          "* Quit and return to the main menu.\n"
          "* To exit the TermPDF Viewer, use 'q' in the main menu.\n"
          "* To search within the PDF, use 's' during viewing and enter the keyword to search.\n"
          "* \n"
          "*   Searching in PDF:\n"
          "* \n"
          "*   Press 's' to initiate a search.\n"
          "*   Enter the keyword you want to search for when prompted.\n"
          "* The matching words in the PDF will be highlighted in red and bold.\n"
          "* Options:\n"
          "* Press 'b' to go back to the previous page.\n"
          "* Press 'f' to go forward to the next page.\n"
          "* Press 'q' to exit the search and return to the page where the search began.\n"
          "* Press 'enter' to continue the search.\n"
          "* Exiting Search:\n"
          "* \n"
          "* If there are no more matches and you decide to exit the search ('q'), \n"
          "* you will return to the page where the search began.\n"
          "* You can choose to:\n"
          "* Press 'enter' to continue the search.\n"
          "* Press 'q' to exit the search and return to the page where the search began.\n"
          "* Main Menu:\n"
          "* \n"
          "* Press '1' to scan for PDF files in the current directory.\n"
          "* Press '2' to view scanned PDF files.\n"
          "* Press '3' to check the FAQ and Usage.\n"
          "* Press '4' to check the LICENCE and CREDITS.\n"
          "* Press '5' to quit the TermPDF Viewer.\n"
          "* \n"
          "-------------------------------------------------------------------------\n"
          "* Important Notes:\n"
          "* - The application has been tested on Linux and macOS.\n"
          "* - For Windows, additional configurations may be required.\n"
          "* - Make sure to fulfill the prerequisites before running the application.\n"
          "* - For more information, please refer to the project documentation.\n"
          "-------------------------------------------------------------------------\n")



def main():
    print("\n"
      "▀▀█▀▀ █▀▀ █▀▀█ █▀▄▀█ ▒█▀▀█ ▒█▀▀▄ ▒█▀▀▀ 　 ▒█░░▒█ ░▀░ █▀▀ █░░░█ █▀▀ █▀▀█\n"
      "░▒█░░ █▀▀ █▄▄▀ █░▀░█ ▒█▄▄█ ▒█░▒█ ▒█▀▀▀ 　 ░▒█▒█░ ▀█▀ █▀▀ █▄█▄█ █▀▀ █▄▄▀\n"
      "░▒█░░ ▀▀▀ ▀░▀▀ ▀░░░▀ ▒█░░░ ▒█▄▄▀ ▒█░░░ 　 ░░▀▄▀░ ▀▀▀ ▀▀▀ ░▀░▀░ ▀▀▀ ▀░▀▀\n"
      "-------------------------------------------------------------------------\n"
      "TermPDF Viewer - view and navigate PDF files within the terminal.\n"
      "-------------------------------------------------------------------------\n"
      "*  Simple: TermPDF Viewer is a Python program that enables users to \n"
      "*  view and navigate PDF files directly within the terminal.\n"
      "-------------------------------------------------------------------------\n"
      "╭────────────-----────── TERMS OF USE ──────────----------───╮\n"
      "│  This software is licensed under the MIT License.          │\n"
      "│  By Felipe Alfonso González - github.com/felipealfonsog    │\n"
      "│  Computer Science Engineer - Email: f.alfonso@res-ear.ch   │\n"
      "╰───────────────────────────────────────────────---------────╯\n"
      "-------------------------------------------------------------------------\n"
      "* Prerequisites:\n"
      "* Python 3.x: The program is written in Python and requires a Python 3.x interpreter to run.\n"
      "* PyMuPDF: A Python binding for the MuPDF library, used to handle PDF file rendering and interaction.\n"
      "*   You can install it using pip: pip install PyMuPDF\n"
      "** ----------------------------------------------------------------- -----------------------\n"
      "* If you have any issue with pip, fix the pip lock using the following script:\n"
      "*   https://gist.github.com/felipealfonsog/d3bf4d70504f52c03094d2c0d79992b0\n"
      "*-----------------------------------------------------------------  ------------------------\n"
      "*   Make sure to include the appropriate model or adapt it for your needs.\n"
      "-------------------------------------------------------------------------\n"
      "* Important Notes:\n"
      "\n"
      "* Install PyMuPDF library (if not already installed):\n"
      "  pip install PyMuPDF\n"
      "  pip install termcolor\n"
      "*   If you have any issue with pip, fix the pip lock using the following script:\n"
      "*   https://gist.github.com/felipealfonsog/d3bf4d70504f52c03094d2c0d79992b0\n"
      "\n"
    )

    print("Welcome to the TermPDF Viewer!")



    while True:
        print("\nMain Menu:")
        print("\n----------------------")
        print("1. Scan for PDF files")
        print("2. View scanned PDF files")
        print("3. FAQ - Usage")
        print("4. About - Licence and credits")
        print("5. Quit")

        choice = input("Enter the number of your choice: ")

        if choice == '1':
            pdf_files = scan_pdf_files()
            if not pdf_files:
                print("No PDF files found in the current directory.")
                print("Please place PDF files in the current directory and try again.")
            else:
                print("Scanned PDF files:")
                for i, pdf_file in enumerate(pdf_files, start=1):
                    print(f"{i}. {pdf_file}")

        elif choice == '2':
            pdf_files = scan_pdf_files()
            if not pdf_files:
                print("No PDF files found in the current directory or scanned already.")
                print("Please place PDF files in the current directory and try again.")
            else:
                print("Scanned PDF files:")
                for i, pdf_file in enumerate(pdf_files, start=1):
                    print(f"{i}. {pdf_file}")

                file_choice = input("Enter the number of the PDF file to view (or 'q' to go back): ")
                if file_choice == 'q':
                    continue
                try:
                    file_choice = int(file_choice) - 1
                    if 0 <= file_choice < len(pdf_files):
                        display_pdf(pdf_files[file_choice])
                    else:
                        print("Invalid choice.")
                except ValueError:
                    print("Invalid input. Please enter a valid number.")

        elif choice == '3':
            display_faq()
        elif choice == '4':
            display_about()
        elif choice == '5':
            print("Goodbye!")
            break
        else:
            print("Invalid choice. Please enter a valid number.")

if __name__ == '__main__':
    main()
    

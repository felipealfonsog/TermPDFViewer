#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <curl/curl.h>

void show_page(const char *filename, int page_number) {
    FILE *file = fopen(filename, "r");
    if (!file) {
        printf("Error: Cannot open PDF file.\n");
        return;
    }

    int current_page = 0;
    char line[256];

    while (fgets(line, sizeof(line), file)) {
        if (line[0] == '\f') {
            current_page++;
            if (current_page > page_number) {
                break;
            }
        }

        if (current_page == page_number) {
            printf("%s", line);
        }
    }

    fclose(file);
}

size_t write_callback(void *ptr, size_t size, size_t nmemb, FILE *stream) {
    return fwrite(ptr, size, nmemb, stream);
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Usage: %s <URL or filename.pdf>\n", argv[0]);
        return 1;
    }

    int page_count = 0;
    int current_page = 0;
    char input;

    printf("PDF Viewer: %s\n", argv[1]);

    CURL *curl = curl_easy_init();
    if (!curl) {
        printf("Error: Cannot initialize libcurl.\n");
        return 1;
    }

    FILE *file = fopen("temp.pdf", "wb");
    if (!file) {
        printf("Error: Cannot create temporary file.\n");
        curl_easy_cleanup(curl);
        return 1;
    }

    curl_easy_setopt(curl, CURLOPT_URL, argv[1]);
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, write_callback);
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, file);
    CURLcode res = curl_easy_perform(curl);

    if (res != CURLE_OK) {
        printf("Error: Failed to download the PDF file.\n");
        fclose(file);
        curl_easy_cleanup(curl);
        return 1;
    }

    fclose(file);
    curl_easy_cleanup(curl);

    file = fopen("temp.pdf", "r");
    if (!file) {
        printf("Error: Cannot open downloaded PDF file.\n");
        return 1;
    }

    char line[256];
    while (fgets(line, sizeof(line), file)) {
        if (strstr(line, "\f"))
            page_count++;
    }

    fclose(file);

    while (1) {
        show_page("temp.pdf", current_page);

        printf("\nPage %d of %d - (N)ext, (P)revious, (Q)uit: ", current_page + 1, page_count);
        scanf(" %c", &input);

        if (input == 'n' || input == 'N') {
            current_page++;
            if (current_page >= page_count) {
                current_page = 0;
            }
        } else if (input == 'p' || input == 'P') {
            current_page--;
            if (current_page < 0) {
                current_page = page_count - 1;
            }
        } else if (input == 'q' || input == 'Q') {
            break;
        }
    }

    remove("temp.pdf");
    return 0;
}

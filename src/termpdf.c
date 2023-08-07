#include <stdio.h>
#include <poppler/glib/poppler.h>

void show_page(const char *filename, int page_number) {
    GError *error = NULL;
    PopplerDocument *doc;
    PopplerPage *page;

    doc = poppler_document_new_from_file(filename, NULL, &error);
    if (error != NULL) {
        g_error("Error opening PDF file: %s\n", error->message);
    }

    if (!poppler_document_get_n_pages(doc)) {
        printf("No pages found in the PDF.\n");
        poppler_document_free(doc);
        return;
    }

    page = poppler_document_get_page(doc, page_number);
    if (!page) {
        printf("Page number out of range.\n");
        poppler_document_free(doc);
        return;
    }

    gchar *text = poppler_page_get_text(page);
    printf("%s", text);
    g_free(text);

    g_object_unref(page);
    poppler_document_free(doc);
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Usage: %s <filename.pdf>\n", argv[0]);
        return 1;
    }

    int page_count = 0;
    int current_page = 0;
    char input;

    printf("PDF Viewer: %s\n", argv[1]);

    GError *error = NULL;
    PopplerDocument *doc;

    doc = poppler_document_new_from_file(argv[1], NULL, &error);
    if (error != NULL) {
        g_error("Error opening PDF file: %s\n", error->message);
    }

    if (!poppler_document_get_n_pages(doc)) {
        printf("No pages found in the PDF.\n");
        poppler_document_free(doc);
        return 1;
    }

    page_count = poppler_document_get_n_pages(doc);

    while (1) {
        show_page(argv[1], current_page);

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

    poppler_document_free(doc);

    return 0;
}

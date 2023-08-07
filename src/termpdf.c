#include <stdio.h>
#include <mupdf/fitz.h>

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Usage: %s <filename.pdf>\n", argv[0]);
        return 1;
    }

    fz_context *ctx = fz_new_context(NULL, NULL, FZ_STORE_UNLIMITED);
    if (!ctx) {
        printf("Error creating MuPDF context.\n");
        return 1;
    }

    fz_register_document_handlers(ctx);

    fz_document *doc = fz_open_document(ctx, argv[1]);
    if (!doc) {
        printf("Error opening the PDF file: %s\n", argv[1]);
        fz_free_context(ctx);
        return 1;
    }

    int page_count = fz_count_pages(doc);
    int current_page = 0;
    char input;

    printf("PDF Viewer: %s\n", argv[1]);

    while (1) {
        if (current_page < 0) {
            current_page = 0;
        } else if (current_page >= page_count) {
            current_page = page_count - 1;
        }

        fz_page *page = fz_load_page(ctx, doc, current_page);
        if (!page) {
            printf("Failed to load the page.\n");
            fz_close_document(doc);
            fz_free_context(ctx);
            return 1;
        }

        fz_rect bounds;
        fz_bound_page(ctx, page, &bounds);
        fz_matrix transform = fz_identity;

        fz_device *dev = fz_new_device(ctx, &bounds);
        fz_run_page(ctx, page, dev, &transform, NULL);
        fz_free_device(dev);
        fz_drop_page(ctx, page);

        printf("\nPage %d (%g x %g) - (N)ext, (P)revious, (Q)uit: ", current_page + 1, bounds.x1 - bounds.x0, bounds.y1 - bounds.y0);
        scanf(" %c", &input);

        if (input == 'n' || input == 'N') {
            current_page++;
        } else if (input == 'p' || input == 'P') {
            current_page--;
        } else if (input == 'q' || input == 'Q') {
            break;
        }
    }

    fz_close_document(doc);
    fz_free_context(ctx);

    return 0;
}

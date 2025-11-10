#include <iostream>
#include <mupdf/fitz.h>

int main(int argc, char* argv[]) {
    if (argc != 2) {
        std::cerr << "Usage: " << argv[0] << " <input.pdf>" << std::endl;
        return 1;
    }

    const char* pdfPath = argv[1];

    fz_context* ctx = fz_new_context(NULL, NULL, FZ_STORE_DEFAULT);
    if (!ctx) {
        std::cerr << "Failed to create MuPDF context." << std::endl;
        return 1;
    }

    fz_document* doc = fz_open_document(ctx, pdfPath);
    if (!doc) {
        std::cerr << "Failed to open PDF document." << std::endl;
        fz_free_context(ctx);
        return 1;
    }

    int numPages = fz_count_pages(ctx, doc);
    std::cout << "Number of pages: " << numPages << std::endl;

    for (int pageNum = 0; pageNum < numPages; ++pageNum) {
        fz_page* page = fz_load_page(ctx, doc, pageNum);
        if (!page) {
            std::cerr << "Failed to load page " << pageNum + 1 << std::endl;
            continue;
        }

        fz_text_page* textPage = fz_new_text_page(ctx, page, NULL);
        if (!textPage) {
            std::cerr << "Failed to create text page for page " << pageNum + 1 << std::endl;
            fz_drop_page(ctx, page);
            continue;
        }

        fz_stext_page* stextPage = fz_new_stext_page_from_text_page(ctx, textPage, NULL);
        if (!stextPage) {
            std::cerr << "Failed to create structured text page for page " << pageNum + 1 << std::endl;
            fz_drop_page(ctx, page);
            fz_drop_text_page(ctx, textPage);
            continue;
        }

        fz_rect bbox;
        fz_bound_page(ctx, page, &bbox);

        for (int blockNum = 0; blockNum < fz_stext_page_block_count(stextPage); ++blockNum) {
            fz_stext_block* block = fz_stext_page_get_block(ctx, stextPage, blockNum);
            for (int lineNum = 0; lineNum < fz_stext_block_line_count(block); ++lineNum) {
                fz_stext_line* line = fz_stext_block_get_line(ctx, block, lineNum);
                for (int wordNum = 0; wordNum < fz_stext_line_word_count(line); ++wordNum) {
                    fz_stext_word* word = fz_stext_line_get_word(ctx, line, wordNum);
                    fz_rect word_bbox;
                    fz_stext_word_bbox(ctx, word, &word_bbox);
                    if (fz_intersect_rect(&bbox, &word_bbox)) {
                        std::cout << fz_stext_word_text(ctx, word) << " ";
                    }
                }
                std::cout << std::endl;
            }
        }

        fz_drop_stext_page(ctx, stextPage);
        fz_drop_page(ctx, page);
    }

    fz_close_document(doc);
    fz_free_context(ctx);
    return 0;
}

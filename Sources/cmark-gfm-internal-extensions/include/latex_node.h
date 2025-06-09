#ifndef CMARK_GFM_STRIKETHROUGH_H
#define CMARK_GFM_STRIKETHROUGH_H

#include "cmark-gfm-extension_api.h"

extern cmark_node_type CMARK_NODE_LATEX;
cmark_syntax_extension *create_latex_extension(void);

void ensure_latex_extension_registered(void);

#endif

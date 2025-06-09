#include <stdbool.h>

#include "latex_node.h"
#include "mutex.h"
#include <parser.h>
#include <render.h>

cmark_node_type CMARK_NODE_LATEX; // Global for our new node type

static cmark_node *match(cmark_syntax_extension *self, cmark_parser *parser,
                         cmark_node *parent, unsigned char character,
                         cmark_inline_parser *inline_parser) {
  int initial_offset = cmark_inline_parser_get_offset(inline_parser);

  if (character != '\\' && character != '$') {
    return NULL;
  }

  cmark_inline_parser_advance_offset(inline_parser);

  unsigned char terminator = '$';
  bool double_dollar_terminator = false;
  if (character == '\\') {
    if (cmark_inline_parser_peek_char(inline_parser) == '(') {
      terminator = ')';
    } else if (cmark_inline_parser_peek_char(inline_parser) == '[') {
      terminator = ']';
    } else {
      cmark_inline_parser_set_offset(inline_parser, initial_offset);
      return NULL;
    }
  } else if (cmark_inline_parser_peek_char(inline_parser) == '$') {
    double_dollar_terminator = true;
    cmark_inline_parser_advance_offset(inline_parser);
  }

  // Consume '('
  cmark_inline_parser_advance_offset(inline_parser);

  cmark_strbuf content_buffer;
  cmark_strbuf_init(parser->mem, &content_buffer, 32);

#define RESTORE_PARSER_AND_ABORT() \
  cmark_strbuf_free(&content_buffer); \
  cmark_inline_parser_set_offset(inline_parser, initial_offset); \
  return NULL;

  bool last_character_was_space = 0;
  while (true) {
    unsigned char c = cmark_inline_parser_peek_char(inline_parser);

    if (cmark_inline_parser_is_eof(inline_parser)) {
      RESTORE_PARSER_AND_ABORT();
    }

    if (c == '\n') { // EOF or newline means unclosed
      RESTORE_PARSER_AND_ABORT();
    }

    cmark_inline_parser_advance_offset(inline_parser);
    if (character == '\\' && c == '\\' && cmark_inline_parser_peek_char(inline_parser) == terminator) {
      cmark_inline_parser_advance_offset(inline_parser); // Consume terminator
      break;
    } else if (terminator == '$' && c == '$') {
      if (double_dollar_terminator) {
        unsigned char next = cmark_inline_parser_peek_char(inline_parser);
        cmark_inline_parser_advance_offset(inline_parser);
        if (next == '$') {
          break;
        } else {
          cmark_strbuf_putc(&content_buffer, c);
          cmark_strbuf_putc(&content_buffer, next);
          continue;
        }
      } else { // single dollar terminator
        // don't treat just any two $ in text as inline LaTeX
        // closing $ should be on the right of the text, not on the left or inside text
        unsigned char next = cmark_inline_parser_peek_char(inline_parser);
        if (last_character_was_space || cmark_isalnum(next)) {
          RESTORE_PARSER_AND_ABORT();
        }
        break; // Found closing $
      }
    } else {
      cmark_strbuf_putc(&content_buffer, c);
      if (c == '\\') {
        cmark_strbuf_putc(&content_buffer, cmark_inline_parser_peek_char(inline_parser));
        cmark_inline_parser_advance_offset(inline_parser);
      }
    }

    last_character_was_space = cmark_isspace(c);
  }

  cmark_node *node = cmark_node_new_with_mem(CMARK_NODE_LATEX, parser->mem);
  cmark_node_set_string_content(node, cmark_strbuf_detach(&content_buffer));

  cmark_node_set_syntax_extension(node, self);

  return node;
}

//static delimiter *insert(cmark_syntax_extension *self, cmark_parser *parser,
//                         cmark_inline_parser *inline_parser, delimiter *opener,
//                         delimiter *closer) {
//  cmark_node *strikethrough;
//  cmark_node *tmp, *next;
//  delimiter *delim, *tmp_delim;
//  delimiter *res = closer->next;
//
//  strikethrough = opener->inl_text;
//
//  if (opener->inl_text->as.literal.len != closer->inl_text->as.literal.len)
//    goto done;
//
//  if (!cmark_node_set_type(strikethrough, CMARK_NODE_STRIKETHROUGH))
//    goto done;
//
//  cmark_node_set_syntax_extension(strikethrough, self);
//
//  tmp = cmark_node_next(opener->inl_text);
//
//  while (tmp) {
//    if (tmp == closer->inl_text)
//      break;
//    next = cmark_node_next(tmp);
//    cmark_node_append_child(strikethrough, tmp);
//    tmp = next;
//  }
//
//  strikethrough->end_column = closer->inl_text->start_column + closer->inl_text->as.literal.len - 1;
//  cmark_node_free(closer->inl_text);
//
//done:
//  delim = closer;
//  while (delim != NULL && delim != opener) {
//    tmp_delim = delim->previous;
//    cmark_inline_parser_remove_delimiter(inline_parser, delim);
//    delim = tmp_delim;
//  }
//
//  cmark_inline_parser_remove_delimiter(inline_parser, opener);
//
//  return res;
//}

static const char *get_type_string(cmark_syntax_extension *extension,
                                   cmark_node *node) {
  return node->type == CMARK_NODE_LATEX ? "latex" : "<unknown>";
}

static int can_contain(cmark_syntax_extension *extension, cmark_node *node,
                       cmark_node_type child_type) {
  return false;
}

// static void commonmark_render(cmark_syntax_extension *extension,
//                               cmark_renderer *renderer, cmark_node *node,
//                               cmark_event_type ev_type, int options) {
//   renderer->out(renderer, node, "\\(", false, LITERAL);
// }

// static void latex_render(cmark_syntax_extension *extension,
//                          cmark_renderer *renderer, cmark_node *node,
//                          cmark_event_type ev_type, int options) {
//   // requires \usepackage{ulem}
//   bool entering = (ev_type == CMARK_EVENT_ENTER);
//   if (entering) {
//     renderer->out(renderer, node, "\\(", false, LITERAL);
//   } else {
//     renderer->out(renderer, node, ")", false, LITERAL);
//   }
// }

// static void man_render(cmark_syntax_extension *extension,
//                        cmark_renderer *renderer, cmark_node *node,
//                        cmark_event_type ev_type, int options) {
//   bool entering = (ev_type == CMARK_EVENT_ENTER);
//   if (entering) {
//     renderer->cr(renderer);
//     renderer->out(renderer, node, ".ST \"", false, LITERAL);
//   } else {
//     renderer->out(renderer, node, "\"", false, LITERAL);
//     renderer->cr(renderer);
//   }
// }

// static void html_render(cmark_syntax_extension *extension,
//                         cmark_html_renderer *renderer, cmark_node *node,
//                         cmark_event_type ev_type, int options) {
//   bool entering = (ev_type == CMARK_EVENT_ENTER);
//   if (entering) {
//     cmark_strbuf_puts(renderer->html, "<del>");
//   } else {
//     cmark_strbuf_puts(renderer->html, "</del>");
//   }
// }

// static void plaintext_render(cmark_syntax_extension *extension,
//                              cmark_renderer *renderer, cmark_node *node,
//                              cmark_event_type ev_type, int options) {
//   renderer->out(renderer, node, "~", false, LITERAL);
// }

cmark_syntax_extension *create_latex_extension(void) {
  cmark_syntax_extension *ext = cmark_syntax_extension_new("latex");
  cmark_llist *special_chars = NULL;

  cmark_syntax_extension_set_get_type_string_func(ext, get_type_string);
  cmark_syntax_extension_set_can_contain_func(ext, can_contain);
  // cmark_syntax_extension_set_commonmark_render_func(ext, commonmark_render);
  // cmark_syntax_extension_set_latex_render_func(ext, latex_render);
  // cmark_syntax_extension_set_man_render_func(ext, man_render);
  // cmark_syntax_extension_set_html_render_func(ext, html_render);
  // cmark_syntax_extension_set_plaintext_render_func(ext, plaintext_render);
  CMARK_NODE_LATEX = cmark_syntax_extension_add_node(1);

  cmark_syntax_extension_set_match_inline_func(ext, match);
  // cmark_syntax_extension_set_inline_from_delim_func(ext, insert);

  cmark_mem *mem = cmark_get_default_mem_allocator();
  special_chars = cmark_llist_append(mem, special_chars, (void *)'~');
  cmark_syntax_extension_set_special_inline_chars(ext, special_chars);

  cmark_syntax_extension_set_emphasis(ext, 1);

  return ext;
}


static int latex_extensions_registration(cmark_plugin *plugin) {
  cmark_plugin_register_syntax_extension(plugin, create_latex_extension());
  return 1;
}

CMARK_DEFINE_ONCE(registered);

static void register_plugins(void) {
  cmark_register_plugin(latex_extensions_registration);
}

void ensure_latex_extension_registered(void) {
  CMARK_RUN_ONCE(registered, register_plugins);
}

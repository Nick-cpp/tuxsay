class CTuxSay {
  U8 *message;
  I64 max_line_length;
};

U0 StrCat(U8 *dst, U8 *src) {
  while (*dst != 0) {
    dst++;
  }
  while (*src != 0) {
    *dst = *src;
    dst++;
    src++;
  }
  *dst = 0;
}

U8 *FindChar(U8 *str, U8 ch) {
  while (*str != 0) {
    if (*str == ch) return str;
    str++;
  }
  return NULL;
}

U0 FreeStringArray(U8 **lines, I64 count) {
  I64 i;
  for (i = 0; i < count; i++) {
    Free(lines[i]);
  }
  Free(lines);
}

U8 **WrapText(U8 *text, I64 width, I64 *_line_count) {
  I64 max_lines = 100;
  U8 **lines = MAlloc(sizeof(U8 *) * max_lines);
  I64 line_count = 0;
  
  U8 current_line[1024];
  current_line[0] = 0;
  
  U8 *text_copy = StrNew(text);
  U8 *word = text_copy;
  U8 *next_space;

  while (word != NULL && *word != 0) {
    while (*word == ' ') word++;
    if (*word == 0) break;

    next_space = FindChar(word, ' ');
    if (next_space != NULL) {
      *next_space = 0;
    }

    I64 word_len = StrLen(word);
    I64 current_len = StrLen(current_line);

    I64 pad = 0;
    if (current_len > 0) {
      pad = 1;
    }

    if (current_len + word_len + pad > width) {
      if (current_len > 0) {
        lines[line_count++] = StrNew(current_line);
        current_line[0] = 0;
      }
    }

    if (StrLen(current_line) > 0) {
      StrCat(current_line, " ");
    }
    StrCat(current_line, word);

    if (next_space != NULL) {
      word = next_space + 1;
    } else {
      break;
    }
  }

  if (StrLen(current_line) > 0) {
    lines[line_count++] = StrNew(current_line);
  }

  Free(text_copy);
  *_line_count = line_count;
  return lines;
}

CTuxSay *TuxSayInit(U8 *msg, I64 max_len) {
  CTuxSay *tux = MAlloc(sizeof(CTuxSay));
  tux->message = StrNew(msg);
  tux->max_line_length = max_len;
  return tux;
}

U0 TuxSayFree(CTuxSay *tux) {
  if (tux != NULL) {
    Free(tux->message);
    Free(tux);
  }
}

U0 TuxSayRender(CTuxSay *tux) {
  if (tux->message == NULL || StrLen(tux->message) == 0) {
    "Usage: tuxsay \"your message here\"\n";
    return;
  }

  I64 line_count = 0;
  U8 **lines = WrapText(tux->message, tux->max_line_length, &line_count);

  I64 bubble_width = 0;
  I64 i, j;

  for (i = 0; i < line_count; i++) {
    I64 len = StrLen(lines[i]);
    if (len > bubble_width) {
      bubble_width = len;
    }
  }

  " ";
  for (i = 0; i < bubble_width + 2; i++) {
    "_";
  }
  "\n";

  if (line_count == 1) {
    "< %s", lines[0];
    for (i = StrLen(lines[0]); i < bubble_width; i++) " ";
    " >\n";
  } else {
    "/ %s", lines[0];
    for (i = StrLen(lines[0]); i < bubble_width; i++) " ";
    " \\\n";

    for (i = 1; i < line_count - 1; i++) {
      "| %s", lines[i];
      for (j = StrLen(lines[i]); j < bubble_width; j++) " ";
      " |\n";
    }

    "\\ %s", lines[line_count - 1];
    for (i = StrLen(lines[line_count - 1]); i < bubble_width; i++) " ";
    " /\n";
  }

  " ";
  for (i = 0; i < bubble_width + 2; i++) {
    "-";
  }
  "\n";

  "    \\\n";
  "     \\\n";
  "    .--.\n";
  "   |o_o |\n";
  "   |:_/ |\n";
  "  //   \\ \\\n";
  " (|     | )\n";
  "/'\\_   _/`\\\n";
  "\\___)=(___/\n";

  FreeStringArray(lines, line_count);
}

I64 Main(I64 argc, U8 **argv) {
  U8 message[2048];
  message[0] = 0;

  if (argc > 1) {
    I64 i;
    for (i = 1; i < argc; i++) {
      if (i > 1) {
        StrCat(message, " ");
      }
      StrCat(message, argv[i]);
    }
  }

  CTuxSay *tux = TuxSayInit(message, 40);
  TuxSayRender(tux);
  TuxSayFree(tux);

  return 0;
}

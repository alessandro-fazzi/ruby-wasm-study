# 🍑🎄

A simple web-based Ruby code interpreter powered by Ruby WASM. Write and execute
Ruby code directly in your browser!

This thing could easily be more REPL-ish, but here the game was to bind code
written in the text-area and buttons in the UI to the custom `Pesca` module.

If you wanna play with a ruby REPL in the browser head to https://try.ruby-lang.org/

▶️ https://alessandro-fazzi.github.io/ruby-wasm-study/

## Features

- Run Ruby code in the browser using WebAssembly
- Pre-loaded `Pesca` module with utility functions
- Real-time output display
- Keyboard shortcut support (Ctrl+Enter or Cmd+Enter to execute)

## Setup

1. Install dependencies:
```bash
npm install
```

2. Start the development server:
```bash
npm run dev
```

3. Open your browser and navigate to the URL shown (usually `http://localhost:5173`)

## Usage

1. Write your Ruby code in the editor
2. Click the "Execute" button or press Ctrl+Enter (Cmd+Enter on Mac)
3. View the output in the output panel below

## The Pesca Module

The `Pesca` module is automatically loaded and available in all code executions.


## Build for Production

```bash
npm run build
```

The built files will be in the `dist/` directory.

## Preview Production Build

```bash
npm run preview
```

## Deploy on GH pages

```bash
npm run deploy
```

## Technologies

- Ruby 3.4 (via ruby.wasm)
- Vite (build tool and dev server)
- @ruby/wasm-wasi (Ruby WebAssembly runtime)

## License

The Unlicense

```
This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <https://unlicense.org/>
```

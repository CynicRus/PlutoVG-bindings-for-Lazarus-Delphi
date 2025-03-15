# PlutoVG-bindings-for-Lazarus-Delphi

[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

A complete Delphi/FreePascal interface for the [PlutoVG](https://github.com/sammycage/plutovg) 2D vector graphics library.

![image info](./images/LazDemo.png)

## Overview

PlutoVG is a standalone 2D vector graphics library written in C. These bindings provide a full Delphi/FreePascal interface to all PlutoVG functionality, allowing you to:

- Create, modify, and render vector paths
- Work with different fill and stroke styles
- Apply transformations (translate, scale, rotate, etc.)
- Use linear and radial gradients
- Load and render text with TrueType fonts
- Save rendered content to PNG or JPG

## Features

- Complete type-safe Pascal interface to all PlutoVG functions
- Cross-platform support (Windows, Linux)
- Compatible with both Delphi (7/12 tested) and FreePascal >= 3.2.0
- Pre-built binaries included in the `prebuilt` directory

## Installation

1. Add the `plutovg_api.pas` unit to your project
2. Ensure the appropriate PlutoVG binary is available in your application's path :
   - Windows: `libplutovg.dll`
   - Linux: `libplutovg.so`

Pre-built binaries for windows are available in the `prebuilt` directory.

## Basic Usage Example

```pascal
uses
  plutovg_api;

var
  surface: plutovg_surface_t;
  canvas: plutovg_canvas_t;
begin
  // Create a 400x300 surface
  surface := plutovg_surface_create(400, 300);
  
  // Create a canvas for drawing
  canvas := plutovg_canvas_create(surface);
  
  // Clear the surface with white
  plutovg_surface_clear(surface, PLUTOVG_WHITE_COLOR);
  
  // Draw a red circle
  plutovg_canvas_set_color(canvas, PLUTOVG_RED_COLOR);
  plutovg_canvas_circle(canvas, 200, 150, 100);
  plutovg_canvas_fill(canvas);
  
  // Save to a PNG file
  plutovg_surface_write_to_png(surface, 'output.png');
  
  // Clean up
  plutovg_canvas_destroy(canvas);
  plutovg_surface_destroy(surface);
end;
```

## API Structure

# The binding follows the same structure as the original C library:

   - Matrix transformations - Functions for creating and manipulating transformation matrices
   - Path creation and manipulation - Functions for building vector paths
   - Text and fonts - Functions for working with TrueType fonts and text
   - Surface handling - Functions for creating and manipulating drawing surfaces
   - Canvas operations - Functions for actual drawing operations


#License

This binding is licensed under the MIT License, the same as the original PlutoVG library.
Acknowledgements

[Copyright of PlutoVG - (c) 2020-2025 Samuel Ugochukwu <sammycageagle@gmail.com] (https://github.com/sammycage/plutovg)

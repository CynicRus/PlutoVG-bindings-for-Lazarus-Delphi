{*
 * Copyright (c) 2025 Aleksandr Vorobev aka CynicRus <cynicrus@gmail.com>
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
*}

unit plutovg_api;

interface

{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}

{$DEFINE DELPHI7}

{$IFDEF VER150}
  {$DEFINE DELPHI7}
{$ELSE}
{$UNDEF DELPHI7}
{$ENDIF}

uses
  {$IFNDEF FPC}
     Classes, SysUtils {$IFDEF MSWINDOWS}, Windows{$ENDIF};
  {$ENDIF}
  {$IFDEF FPC}
      Classes,Sysutils,LCLIntf,dynlibs;
  {$ENDIF}

const
    // Определяем имя библиотеки в зависимости от платформы
  {$IFDEF MSWINDOWS}
  PLUTOVG_LIB = 'libplutovg.dll';
  {$ENDIF}
  {$IFDEF UNIX}
    {$IFDEF DARWIN}  // macOS
      PLUTOVG_LIB = 'libplutovg.dylib';
    {$ELSE}          // Linux и другие UNIX-системы
      PLUTOVG_LIB = 'libplutovg.so';
    {$ENDIF}
  {$ENDIF}
type
  // Точка в 2D-пространстве
  pplutovg_point_t = ^plutovg_point_t;

  plutovg_point_t = record
    x: single;
    y: single;
  end;

  // Прямоугольник в 2D-пространстве
  plutovg_rect_t = record
    x: single;
    y: single;
    w: single;
    h: single;
  end;

  // Матрица преобразования 2D
  plutovg_matrix_t = record
    a: single;
    b: single;
    c: single;
    d: single;
    e: single;
    f: single;
  end;

  // Команды пути
  plutovg_path_command_t = (
    PLUTOVG_PATH_COMMAND_MOVE_TO,
    PLUTOVG_PATH_COMMAND_LINE_TO,
    PLUTOVG_PATH_COMMAND_CUBIC_TO,
    PLUTOVG_PATH_COMMAND_CLOSE
    );

  // Элемент пути (вариантная запись для union)
  plutovg_path_element_t = record
    case integer of
      0: (header: record
          command: plutovg_path_command_t;
          length: integer;
          end);
      1: (point: plutovg_point_t);
  end;
  Pplutovg_path_element_t = ^plutovg_path_element_t;

  // Итератор пути
  plutovg_path_iterator_t = record
    elements: Pplutovg_path_element_t;
    size: integer;
    index: integer;
  end;

  // Непрозрачный тип пути
  plutovg_path_t = ^plutovg_path;
  plutovg_path = record
  end;

  // Кодировки текста
  plutovg_text_encoding_t = (
    PLUTOVG_TEXT_ENCODING_LATIN1,
    PLUTOVG_TEXT_ENCODING_UTF8,
    PLUTOVG_TEXT_ENCODING_UTF16,
    PLUTOVG_TEXT_ENCODING_UTF32
    );

  // Итератор текста
  plutovg_text_iterator_t = record
    Text: Pointer;
    length: integer;
    encoding: plutovg_text_encoding_t;
    index: integer;
  end;

  // Кодовая точка Unicode
  plutovg_codepoint_t = cardinal;

  // Непрозрачный тип шрифта
  plutovg_font_face_t = ^plutovg_font_face;
  plutovg_font_face = record
  end;

  // Цвет
  {$ALIGN 4}
  pplutovg_color_t = ^plutovg_color_t;
  plutovg_color_t = packed record
    r: single;
    g: single;
    b: single;
    a: single;
  end;

const

  // Версионные константы
  PLUTOVG_VERSION_MAJOR = 1;
  PLUTOVG_VERSION_MINOR = 0;
  PLUTOVG_VERSION_MICRO = 0;
  CPLUTOVG_VERSION = (PLUTOVG_VERSION_MAJOR * 10000) +
    (PLUTOVG_VERSION_MINOR * 100) + (PLUTOVG_VERSION_MICRO * 1);
  CPLUTOVG_VERSION_STRING = '1.0.0';

  // Математические константы
  PLUTOVG_PI: single = 3.14159265358979323846;
  PLUTOVG_TWO_PI: single = 6.28318530717958647693;
  PLUTOVG_HALF_PI: single = 1.57079632679489661923;
  PLUTOVG_SQRT2: single = 1.41421356237309504880;
  PLUTOVG_KAPPA: single = 0.55228474983079339840;

  // Предопределенные цвета
  PLUTOVG_BLACK_COLOR: plutovg_color_t = (r: 0; g: 0; b: 0; a: 1);
  PLUTOVG_WHITE_COLOR: plutovg_color_t = (r: 1; g: 1; b: 1; a: 1);
  PLUTOVG_RED_COLOR: plutovg_color_t = (r: 1; g: 0; b: 0; a: 1);
  PLUTOVG_GREEN_COLOR: plutovg_color_t = (r: 0; g: 1; b: 0; a: 1);
  PLUTOVG_BLUE_COLOR: plutovg_color_t = (r: 0; g: 0; b: 1; a: 1);
  PLUTOVG_YELLOW_COLOR: plutovg_color_t = (r: 1; g: 1; b: 0; a: 1);
  PLUTOVG_CYAN_COLOR: plutovg_color_t = (r: 0; g: 1; b: 1; a: 1);
  PLUTOVG_MAGENTA_COLOR: plutovg_color_t = (r: 1; g: 0; b: 1; a: 1);

  // Пустые значения для структур
  PLUTOVG_EMPTY_POINT: plutovg_point_t = (x: 0; y: 0);
  PLUTOVG_EMPTY_RECT: plutovg_rect_t = (x: 0; y: 0; w: 0; h: 0);
  PLUTOVG_IDENTITY_MATRIX: plutovg_matrix_t = (a: 1; b: 0; c: 0; d: 1; e: 0; f: 0);

type
  // Определение указателей
  pansichar = ^ansichar;
  PSingle = ^single;
  PUnsignedChar = ^byte;

  // Непрозрачный тип поверхности
  plutovg_surface_t = ^plutovg_surface;
  plutovg_surface = record
  end;

  // Типы текстур
  plutovg_texture_type_t = (
    PLUTOVG_TEXTURE_TYPE_PLAIN,
    PLUTOVG_TEXTURE_TYPE_TILED
    );

  // Методы распространения градиента
  plutovg_spread_method_t = (
    PLUTOVG_SPREAD_METHOD_PAD,
    PLUTOVG_SPREAD_METHOD_REFLECT,
    PLUTOVG_SPREAD_METHOD_REPEAT
    );

  // Остановка градиента
  plutovg_gradient_stop_t = record
    offset: single;
    color: plutovg_color_t;
  end;
  Pplutovg_gradient_stop_t = ^plutovg_gradient_stop_t;

  // Непрозрачный тип краски
  plutovg_paint_t = ^plutovg_paint;
  plutovg_paint = record
  end;

  // Правила заполнения
  plutovg_fill_rule_t = (
    PLUTOVG_FILL_RULE_NON_ZERO,
    PLUTOVG_FILL_RULE_EVEN_ODD
    );

  // Операторы компоновки
  plutovg_operator_t = (
    PLUTOVG_OPERATOR_CLEAR,
    PLUTOVG_OPERATOR_SRC,
    PLUTOVG_OPERATOR_DST,
    PLUTOVG_OPERATOR_SRC_OVER,
    PLUTOVG_OPERATOR_DST_OVER,
    PLUTOVG_OPERATOR_SRC_IN,
    PLUTOVG_OPERATOR_DST_IN,
    PLUTOVG_OPERATOR_SRC_OUT,
    PLUTOVG_OPERATOR_DST_OUT,
    PLUTOVG_OPERATOR_SRC_ATOP,
    PLUTOVG_OPERATOR_DST_ATOP,
    PLUTOVG_OPERATOR_XOR
    );

  // Стили концов линий
  plutovg_line_cap_t = (
    PLUTOVG_LINE_CAP_BUTT,
    PLUTOVG_LINE_CAP_ROUND,
    PLUTOVG_LINE_CAP_SQUARE
    );

  // Стили соединения линий
  plutovg_line_join_t = (
    PLUTOVG_LINE_JOIN_MITER,
    PLUTOVG_LINE_JOIN_ROUND,
    PLUTOVG_LINE_JOIN_BEVEL
    );

  // Непрозрачный тип канваса
  plutovg_canvas_t = ^plutovg_canvas;
  plutovg_canvas = record
  end;

  // Типы функций обратного вызова
  plutovg_destroy_func_t = procedure(closure: Pointer); cdecl;
  plutovg_write_func_t = procedure(closure: Pointer; Data: Pointer;
    size: integer); cdecl;
  plutovg_path_traverse_func_t = procedure(closure: Pointer;
    command: plutovg_path_command_t; points: Pplutovg_point_t; npoints: integer); cdecl;

// Функции преобразования градусов и радиан
function PLUTOVG_DEG2RAD(x: single): single; {$IFNDEF DELPHI7}inline;{$ENDIF}
function PLUTOVG_RAD2DEG(x: single): single; {$IFNDEF DELPHI7}inline;{$ENDIF}

// Функции создания структур
function PLUTOVG_MAKE_POINT(x, y: single): plutovg_point_t;
  {$IFNDEF DELPHI7}inline;{$ENDIF}
function PLUTOVG_MAKE_RECT(x, y, w, h: single): plutovg_rect_t;
  {$IFNDEF DELPHI7}inline;{$ENDIF}
function PLUTOVG_MAKE_MATRIX(a, b, c, d, e, f: single): plutovg_matrix_t;
  {$IFNDEF DELPHI7}inline;{$ENDIF}
function PLUTOVG_MAKE_SCALE(x, y: single): plutovg_matrix_t;
  {$IFNDEF DELPHI7}inline;{$ENDIF}
function PLUTOVG_MAKE_TRANSLATE(x, y: single): plutovg_matrix_t;
  {$IFNDEF DELPHI7}inline;{$ENDIF}
function PLUTOVG_MAKE_COLOR(r, g, b, a: single): plutovg_color_t;
  {$IFNDEF DELPHI7}inline;{$ENDIF}
{$IFDEF MSWINDOWS}
// Функции и процедуры библиотеки
function plutovg_version: integer; cdecl; external PLUTOVG_LIB;
function plutovg_version_string: pansichar; cdecl; external PLUTOVG_LIB;

// Матричные функции
procedure plutovg_matrix_init(var matrix: plutovg_matrix_t; a, b, c, d, e, f: single);
  cdecl; external PLUTOVG_LIB;
procedure plutovg_matrix_init_identity(var matrix: plutovg_matrix_t);
  cdecl; external PLUTOVG_LIB;
procedure plutovg_matrix_init_translate(var matrix: plutovg_matrix_t; tx, ty: single);
  cdecl; external PLUTOVG_LIB;
procedure plutovg_matrix_init_scale(var matrix: plutovg_matrix_t; sx, sy: single);
  cdecl; external PLUTOVG_LIB;
procedure plutovg_matrix_init_rotate(var matrix: plutovg_matrix_t; angle: single);
  cdecl; external PLUTOVG_LIB;
procedure plutovg_matrix_init_shear(var matrix: plutovg_matrix_t; shx, shy: single);
  cdecl; external PLUTOVG_LIB;
procedure plutovg_matrix_translate(var matrix: plutovg_matrix_t; tx, ty: single);
  cdecl; external PLUTOVG_LIB;
procedure plutovg_matrix_scale(var matrix: plutovg_matrix_t; sx, sy: single);
  cdecl; external PLUTOVG_LIB;
procedure plutovg_matrix_rotate(var matrix: plutovg_matrix_t; angle: single);
  cdecl; external PLUTOVG_LIB;
procedure plutovg_matrix_shear(var matrix: plutovg_matrix_t; shx, shy: single);
  cdecl; external PLUTOVG_LIB;
procedure plutovg_matrix_multiply(var matrix: plutovg_matrix_t;
  const left, right: plutovg_matrix_t); cdecl; external PLUTOVG_LIB;
function plutovg_matrix_invert(const matrix: plutovg_matrix_t;
  var inverse: plutovg_matrix_t): boolean; cdecl; external PLUTOVG_LIB;
procedure plutovg_matrix_map(const matrix: plutovg_matrix_t; x, y: single;
  var xx, yy: single); cdecl; external PLUTOVG_LIB;
procedure plutovg_matrix_map_point(const matrix: plutovg_matrix_t;
  const src: plutovg_point_t; var dst: plutovg_point_t); cdecl; external PLUTOVG_LIB;
procedure plutovg_matrix_map_points(const matrix: plutovg_matrix_t;
  const src: Pplutovg_point_t; dst: Pplutovg_point_t; Count: integer);
  cdecl; external PLUTOVG_LIB;
procedure plutovg_matrix_map_rect(const matrix: plutovg_matrix_t;
  const src: plutovg_rect_t; var dst: plutovg_rect_t); cdecl; external PLUTOVG_LIB;
function plutovg_matrix_parse(var matrix: plutovg_matrix_t; Data: pansichar;
  length: integer): boolean; cdecl; external PLUTOVG_LIB;

// Функции пути
function plutovg_path_create: plutovg_path_t; cdecl; external PLUTOVG_LIB;
function plutovg_path_reference(path: plutovg_path_t): plutovg_path_t;
  cdecl; external PLUTOVG_LIB;
procedure plutovg_path_destroy(path: plutovg_path_t); cdecl; external PLUTOVG_LIB;
function plutovg_path_get_reference_count(path: plutovg_path_t): integer;
  cdecl; external PLUTOVG_LIB;
function plutovg_path_get_elements(path: plutovg_path_t;
  var elements: Pplutovg_path_element_t): integer; cdecl; external PLUTOVG_LIB;
procedure plutovg_path_move_to(path: plutovg_path_t; x, y: single);
  cdecl; external PLUTOVG_LIB;
procedure plutovg_path_line_to(path: plutovg_path_t; x, y: single);
  cdecl; external PLUTOVG_LIB;
procedure plutovg_path_quad_to(path: plutovg_path_t; x1, y1, x2, y2: single);
  cdecl; external PLUTOVG_LIB;
procedure plutovg_path_cubic_to(path: plutovg_path_t; x1, y1, x2, y2, x3, y3: single);
  cdecl; external PLUTOVG_LIB;
procedure plutovg_path_arc_to(path: plutovg_path_t; rx, ry, angle: single;
  large_arc_flag, sweep_flag: boolean; x, y: single); cdecl; external PLUTOVG_LIB;
procedure plutovg_path_close(path: plutovg_path_t); cdecl; external PLUTOVG_LIB;
procedure plutovg_path_get_current_point(path: plutovg_path_t; var x, y: single);
  cdecl; external PLUTOVG_LIB;
procedure plutovg_path_reserve(path: plutovg_path_t; Count: integer);
  cdecl; external PLUTOVG_LIB;
procedure plutovg_path_reset(path: plutovg_path_t); cdecl; external PLUTOVG_LIB;
procedure plutovg_path_add_rect(path: plutovg_path_t; x, y, w, h: single);
  cdecl; external PLUTOVG_LIB;
procedure plutovg_path_add_round_rect(path: plutovg_path_t; x, y, w, h, rx, ry: single);
  cdecl; external PLUTOVG_LIB;
procedure plutovg_path_add_ellipse(path: plutovg_path_t; cx, cy, rx, ry: single);
  cdecl; external PLUTOVG_LIB;
procedure plutovg_path_add_circle(path: plutovg_path_t; cx, cy, r: single);
  cdecl; external PLUTOVG_LIB;
procedure plutovg_path_add_arc(path: plutovg_path_t; cx, cy, r, a0, a1: single;
  ccw: boolean); cdecl; external PLUTOVG_LIB;
procedure plutovg_path_add_path(path: plutovg_path_t; const Source: plutovg_path_t;
  const matrix: plutovg_matrix_t); cdecl; external PLUTOVG_LIB;
procedure plutovg_path_transform(path: plutovg_path_t; const matrix: plutovg_matrix_t);
  cdecl; external PLUTOVG_LIB;
procedure plutovg_path_traverse(path: plutovg_path_t;
  traverse_func: plutovg_path_traverse_func_t; closure: Pointer);
  cdecl; external PLUTOVG_LIB;
procedure plutovg_path_traverse_flatten(path: plutovg_path_t;
  traverse_func: plutovg_path_traverse_func_t; closure: Pointer);
  cdecl; external PLUTOVG_LIB;
procedure plutovg_path_traverse_dashed(path: plutovg_path_t; offset: single;
  dashes: PSingle; ndashes: integer; traverse_func: plutovg_path_traverse_func_t;
  closure: Pointer); cdecl; external PLUTOVG_LIB;
function plutovg_path_clone(path: plutovg_path_t): plutovg_path_t;
  cdecl; external PLUTOVG_LIB;
function plutovg_path_clone_flatten(path: plutovg_path_t): plutovg_path_t;
  cdecl; external PLUTOVG_LIB;
function plutovg_path_clone_dashed(path: plutovg_path_t; offset: single;
  dashes: PSingle; ndashes: integer): plutovg_path_t; cdecl; external PLUTOVG_LIB;
function plutovg_path_extents(path: plutovg_path_t; var extents: plutovg_rect_t;
  tight: boolean): single; cdecl; external PLUTOVG_LIB;
function plutovg_path_length(path: plutovg_path_t): single; cdecl; external PLUTOVG_LIB;
function plutovg_path_parse(path: plutovg_path_t; Data: pansichar;
  length: integer): boolean; cdecl; external PLUTOVG_LIB;

// Функции итератора пути
procedure plutovg_path_iterator_init(var it: plutovg_path_iterator_t;
  path: plutovg_path_t); cdecl; external PLUTOVG_LIB;
function plutovg_path_iterator_has_next(const it: plutovg_path_iterator_t): boolean;
  cdecl; external PLUTOVG_LIB;
// Массив из 3 точек для следующей команды пути
type
  Tplutovg_point_array3 = array[0..2] of plutovg_point_t;

function plutovg_path_iterator_next(var it: plutovg_path_iterator_t;
  var points: Tplutovg_point_array3): plutovg_path_command_t; cdecl; external PLUTOVG_LIB;

// Функции итератора текста
procedure plutovg_text_iterator_init(var it: plutovg_text_iterator_t;
  Text: Pointer; length: integer; encoding: plutovg_text_encoding_t);
  cdecl; external PLUTOVG_LIB;
function plutovg_text_iterator_has_next(const it: plutovg_text_iterator_t): boolean;
  cdecl; external PLUTOVG_LIB;
function plutovg_text_iterator_next(
  var it: plutovg_text_iterator_t): plutovg_codepoint_t;
  cdecl; external PLUTOVG_LIB;

// Функции шрифта
function plutovg_font_face_load_from_file(filename: pansichar;
  ttcindex: integer): plutovg_font_face_t; cdecl; external PLUTOVG_LIB;
function plutovg_font_face_load_from_data(Data: Pointer; length: cardinal;
  ttcindex: integer; destroy_func: plutovg_destroy_func_t;
  closure: Pointer): plutovg_font_face_t; cdecl; external PLUTOVG_LIB;
function plutovg_font_face_reference(face: plutovg_font_face_t): plutovg_font_face_t;
  cdecl; external PLUTOVG_LIB;
procedure plutovg_font_face_destroy(face: plutovg_font_face_t); cdecl;
  external PLUTOVG_LIB;
function plutovg_font_face_get_reference_count(face: plutovg_font_face_t): integer;
  cdecl; external PLUTOVG_LIB;
procedure plutovg_font_face_get_metrics(face: plutovg_font_face_t;
  size: single; var ascent, descent, line_gap: single; var extents: plutovg_rect_t);
  cdecl; external PLUTOVG_LIB;
procedure plutovg_font_face_get_glyph_metrics(face: plutovg_font_face_t;
  size: single; codepoint: plutovg_codepoint_t;
  var advance_width, left_side_bearing: single; var extents: plutovg_rect_t);
  cdecl; external PLUTOVG_LIB;
function plutovg_font_face_get_glyph_path(face: plutovg_font_face_t;
  size, x, y: single; codepoint: plutovg_codepoint_t; path: plutovg_path_t): single;
  cdecl; external PLUTOVG_LIB;
function plutovg_font_face_traverse_glyph_path(face: plutovg_font_face_t;
  size, x, y: single; codepoint: plutovg_codepoint_t;
  traverse_func: plutovg_path_traverse_func_t; closure: Pointer): single;
  cdecl; external PLUTOVG_LIB;
function plutovg_font_face_text_extents(face: plutovg_font_face_t;
  size: single; Text: Pointer; length: integer; encoding: plutovg_text_encoding_t;
  var extents: plutovg_rect_t): single; cdecl; external PLUTOVG_LIB;

// Функции цвета
procedure plutovg_color_init_rgb(var color: plutovg_color_t; r, g, b: single);
  cdecl; external PLUTOVG_LIB;
procedure plutovg_color_init_rgba(var color: plutovg_color_t; r, g, b, a: single);
  cdecl; external PLUTOVG_LIB;
procedure plutovg_color_init_rgb8(var color: plutovg_color_t; r, g, b: integer);
  cdecl; external PLUTOVG_LIB;
procedure plutovg_color_init_rgba8(var color: plutovg_color_t; r, g, b, a: integer);
  cdecl; external PLUTOVG_LIB;
procedure plutovg_color_init_rgba32(var color: plutovg_color_t; Value: cardinal);
  cdecl; external PLUTOVG_LIB;
procedure plutovg_color_init_argb32(var color: plutovg_color_t; Value: cardinal);
  cdecl; external PLUTOVG_LIB;
procedure plutovg_color_init_hsl(var color: plutovg_color_t; h, s, l: single);
  cdecl; external PLUTOVG_LIB;
procedure plutovg_color_init_hsla(var color: plutovg_color_t; h, s, l, a: single);
  cdecl; external PLUTOVG_LIB;
function plutovg_color_to_rgba32(const color: plutovg_color_t): cardinal;
  cdecl; external PLUTOVG_LIB;
function plutovg_color_to_argb32(const color: plutovg_color_t): cardinal;
  cdecl; external PLUTOVG_LIB;
function plutovg_color_parse(var color: plutovg_color_t; Data: pansichar;
  length: integer): integer; cdecl; external PLUTOVG_LIB;

// Функции поверхности
function plutovg_surface_create(Width, Height: integer): plutovg_surface_t;
  cdecl; external PLUTOVG_LIB;
function plutovg_surface_create_for_data(Data: PUnsignedChar;
  Width, Height, stride: integer): plutovg_surface_t; cdecl; external PLUTOVG_LIB;
function plutovg_surface_load_from_image_file(filename: pansichar): plutovg_surface_t;
  cdecl; external PLUTOVG_LIB;
function plutovg_surface_load_from_image_data(Data: Pointer;
  length: integer): plutovg_surface_t; cdecl; external PLUTOVG_LIB;
function plutovg_surface_load_from_image_base64(Data: pansichar;
  length: integer): plutovg_surface_t; cdecl; external PLUTOVG_LIB;
function plutovg_surface_reference(surface: plutovg_surface_t): plutovg_surface_t;
  cdecl; external PLUTOVG_LIB;
procedure plutovg_surface_destroy(surface: plutovg_surface_t); cdecl;
  external PLUTOVG_LIB;
function plutovg_surface_get_reference_count(surface: plutovg_surface_t): integer;
  cdecl; external PLUTOVG_LIB;
function plutovg_surface_get_data(surface: plutovg_surface_t): PUnsignedChar;
  cdecl; external PLUTOVG_LIB;
function plutovg_surface_get_width(surface: plutovg_surface_t): integer;
  cdecl; external PLUTOVG_LIB;
function plutovg_surface_get_height(surface: plutovg_surface_t): integer;
  cdecl; external PLUTOVG_LIB;
function plutovg_surface_get_stride(surface: plutovg_surface_t): integer;
  cdecl; external PLUTOVG_LIB;
procedure plutovg_surface_clear(surface: plutovg_surface_t;
  const color: plutovg_color_t); cdecl; external PLUTOVG_LIB;
function plutovg_surface_write_to_png(surface: plutovg_surface_t;
  filename: pansichar): boolean; cdecl; external PLUTOVG_LIB;
function plutovg_surface_write_to_jpg(surface: plutovg_surface_t;
  filename: pansichar; quality: integer): boolean; cdecl; external PLUTOVG_LIB;
function plutovg_surface_write_to_png_stream(surface: plutovg_surface_t;
  write_func: plutovg_write_func_t; closure: Pointer): boolean;
  cdecl; external PLUTOVG_LIB;
function plutovg_surface_write_to_jpg_stream(surface: plutovg_surface_t;
  write_func: plutovg_write_func_t; closure: Pointer; quality: integer): boolean;
  cdecl; external PLUTOVG_LIB;
procedure plutovg_convert_argb_to_rgba(dst: PUnsignedChar;
  const src: PUnsignedChar; Width, Height, stride: integer); cdecl; external PLUTOVG_LIB;
procedure plutovg_convert_rgba_to_argb(dst: PUnsignedChar;
  const src: PUnsignedChar; Width, Height, stride: integer); cdecl; external PLUTOVG_LIB;

// Функции краски
function plutovg_paint_create_rgb(r, g, b: single): plutovg_paint_t;
  cdecl; external PLUTOVG_LIB;
function plutovg_paint_create_rgba(r, g, b, a: single): plutovg_paint_t;
  cdecl; external PLUTOVG_LIB;
function plutovg_paint_create_color(const color: plutovg_color_t): plutovg_paint_t;
  cdecl; external PLUTOVG_LIB;
function plutovg_paint_create_linear_gradient(x1, y1, x2, y2: single;
  spread: plutovg_spread_method_t; stops: Pplutovg_gradient_stop_t;
  nstops: integer; const matrix: plutovg_matrix_t): plutovg_paint_t;
  cdecl; external PLUTOVG_LIB;
function plutovg_paint_create_radial_gradient(cx, cy, cr, fx, fy, fr: single;
  spread: plutovg_spread_method_t; stops: Pplutovg_gradient_stop_t;
  nstops: integer; const matrix: plutovg_matrix_t): plutovg_paint_t;
  cdecl; external PLUTOVG_LIB;
function plutovg_paint_create_texture(surface: plutovg_surface_t;
  type_: plutovg_texture_type_t; opacity: single;
  const matrix: plutovg_matrix_t): plutovg_paint_t; cdecl; external PLUTOVG_LIB;
function plutovg_paint_reference(paint: plutovg_paint_t): plutovg_paint_t;
  cdecl; external PLUTOVG_LIB;
procedure plutovg_paint_destroy(paint: plutovg_paint_t); cdecl; external PLUTOVG_LIB;
function plutovg_paint_get_reference_count(paint: plutovg_paint_t): integer;
  cdecl; external PLUTOVG_LIB;

// Функции канваса
function plutovg_canvas_create(surface: plutovg_surface_t): plutovg_canvas_t;
  cdecl; external PLUTOVG_LIB;
function plutovg_canvas_reference(canvas: plutovg_canvas_t): plutovg_canvas_t;
  cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_destroy(canvas: plutovg_canvas_t); cdecl; external PLUTOVG_LIB;
function plutovg_canvas_get_reference_count(canvas: plutovg_canvas_t): integer;
  cdecl; external PLUTOVG_LIB;
function plutovg_canvas_get_surface(canvas: plutovg_canvas_t): plutovg_surface_t;
  cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_save(canvas: plutovg_canvas_t); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_restore(canvas: plutovg_canvas_t); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_set_rgb(canvas: plutovg_canvas_t; r, g, b: single);
  cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_set_rgba(canvas: plutovg_canvas_t; r, g, b, a: single);
  cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_set_color(canvas: plutovg_canvas_t;
  const color: plutovg_color_t); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_set_linear_gradient(canvas: plutovg_canvas_t;
  x1, y1, x2, y2: single; spread: plutovg_spread_method_t;
  stops: Pplutovg_gradient_stop_t; nstops: integer; const matrix: plutovg_matrix_t);
  cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_set_radial_gradient(canvas: plutovg_canvas_t;
  cx, cy, cr, fx, fy, fr: single; spread: plutovg_spread_method_t;
  stops: Pplutovg_gradient_stop_t; nstops: integer; const matrix: plutovg_matrix_t);
  cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_set_texture(canvas: plutovg_canvas_t;
  surface: plutovg_surface_t; type_: plutovg_texture_type_t; opacity: single;
  const matrix: plutovg_matrix_t); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_set_paint(canvas: plutovg_canvas_t; paint: plutovg_paint_t);
  cdecl; external PLUTOVG_LIB;
function plutovg_canvas_get_paint(canvas: plutovg_canvas_t;
  var color: plutovg_color_t): plutovg_paint_t; cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_set_font(canvas: plutovg_canvas_t;
  face: plutovg_font_face_t; size: single); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_set_font_face(canvas: plutovg_canvas_t;
  face: plutovg_font_face_t); cdecl; external PLUTOVG_LIB;
function plutovg_canvas_get_font_face(canvas: plutovg_canvas_t): plutovg_font_face_t;
  cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_set_font_size(canvas: plutovg_canvas_t; size: single);
  cdecl; external PLUTOVG_LIB;
function plutovg_canvas_get_font_size(canvas: plutovg_canvas_t): single;
  cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_set_fill_rule(canvas: plutovg_canvas_t;
  winding: plutovg_fill_rule_t); cdecl; external PLUTOVG_LIB;
function plutovg_canvas_get_fill_rule(canvas: plutovg_canvas_t): plutovg_fill_rule_t;
  cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_set_operator(canvas: plutovg_canvas_t; op: plutovg_operator_t);
  cdecl; external PLUTOVG_LIB;
function plutovg_canvas_get_operator(canvas: plutovg_canvas_t): plutovg_operator_t;
  cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_set_opacity(canvas: plutovg_canvas_t; opacity: single);
  cdecl; external PLUTOVG_LIB;
function plutovg_canvas_get_opacity(canvas: plutovg_canvas_t): single;
  cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_set_line_width(canvas: plutovg_canvas_t; line_width: single);
  cdecl; external PLUTOVG_LIB;
function plutovg_canvas_get_line_width(canvas: plutovg_canvas_t): single;
  cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_set_line_cap(canvas: plutovg_canvas_t;
  line_cap: plutovg_line_cap_t); cdecl; external PLUTOVG_LIB;
function plutovg_canvas_get_line_cap(canvas: plutovg_canvas_t): plutovg_line_cap_t;
  cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_set_line_join(canvas: plutovg_canvas_t;
  line_join: plutovg_line_join_t); cdecl; external PLUTOVG_LIB;
function plutovg_canvas_get_line_join(canvas: plutovg_canvas_t): plutovg_line_join_t;
  cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_set_miter_limit(canvas: plutovg_canvas_t; miter_limit: single);
  cdecl; external PLUTOVG_LIB;
function plutovg_canvas_get_miter_limit(canvas: plutovg_canvas_t): single;
  cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_set_dash(canvas: plutovg_canvas_t; offset: single;
  dashes: PSingle; ndashes: integer); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_set_dash_offset(canvas: plutovg_canvas_t; offset: single);
  cdecl; external PLUTOVG_LIB;
function plutovg_canvas_get_dash_offset(canvas: plutovg_canvas_t): single;
  cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_set_dash_array(canvas: plutovg_canvas_t;
  dashes: PSingle; ndashes: integer); cdecl; external PLUTOVG_LIB;
function plutovg_canvas_get_dash_array(canvas: plutovg_canvas_t;
  var dashes: PSingle): integer; cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_translate(canvas: plutovg_canvas_t; tx, ty: single);
  cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_scale(canvas: plutovg_canvas_t; sx, sy: single);
  cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_shear(canvas: plutovg_canvas_t; shx, shy: single);
  cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_rotate(canvas: plutovg_canvas_t; angle: single);
  cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_transform(canvas: plutovg_canvas_t;
  const matrix: plutovg_matrix_t); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_reset_matrix(canvas: plutovg_canvas_t);
  cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_set_matrix(canvas: plutovg_canvas_t;
  const matrix: plutovg_matrix_t); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_get_matrix(canvas: plutovg_canvas_t;
  var matrix: plutovg_matrix_t); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_map(canvas: plutovg_canvas_t; x, y: single; var xx, yy: single);
  cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_map_point(canvas: plutovg_canvas_t;
  const src: plutovg_point_t; var dst: plutovg_point_t); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_map_rect(canvas: plutovg_canvas_t;
  const src: plutovg_rect_t; var dst: plutovg_rect_t); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_move_to(canvas: plutovg_canvas_t; x, y: single);
  cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_line_to(canvas: plutovg_canvas_t; x, y: single);
  cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_quad_to(canvas: plutovg_canvas_t; x1, y1, x2, y2: single);
  cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_cubic_to(canvas: plutovg_canvas_t;
  x1, y1, x2, y2, x3, y3: single); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_arc_to(canvas: plutovg_canvas_t; rx, ry, angle: single;
  large_arc_flag, sweep_flag: boolean; x, y: single); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_rect(canvas: plutovg_canvas_t; x, y, w, h: single);
  cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_round_rect(canvas: plutovg_canvas_t;
  x, y, w, h, rx, ry: single); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_ellipse(canvas: plutovg_canvas_t; cx, cy, rx, ry: single);
  cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_circle(canvas: plutovg_canvas_t; cx, cy, r: single);
  cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_arc(canvas: plutovg_canvas_t; cx, cy, r, a0, a1: single;
  ccw: boolean); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_add_path(canvas: plutovg_canvas_t; path: plutovg_path_t);
  cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_new_path(canvas: plutovg_canvas_t); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_close_path(canvas: plutovg_canvas_t); cdecl;
  external PLUTOVG_LIB;
procedure plutovg_canvas_get_current_point(canvas: plutovg_canvas_t; var x, y: single);
  cdecl; external PLUTOVG_LIB;
function plutovg_canvas_get_path(canvas: plutovg_canvas_t): plutovg_path_t;
  cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_fill_extents(canvas: plutovg_canvas_t;
  var extents: plutovg_rect_t); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_stroke_extents(canvas: plutovg_canvas_t;
  var extents: plutovg_rect_t); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_clip_extents(canvas: plutovg_canvas_t;
  var extents: plutovg_rect_t); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_fill(canvas: plutovg_canvas_t); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_stroke(canvas: plutovg_canvas_t); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_clip(canvas: plutovg_canvas_t); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_paint(canvas: plutovg_canvas_t); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_fill_preserve(canvas: plutovg_canvas_t);
  cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_stroke_preserve(canvas: plutovg_canvas_t);
  cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_clip_preserve(canvas: plutovg_canvas_t);
  cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_fill_rect(canvas: plutovg_canvas_t; x, y, w, h: single);
  cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_fill_path(canvas: plutovg_canvas_t; path: plutovg_path_t);
  cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_stroke_rect(canvas: plutovg_canvas_t; x, y, w, h: single);
  cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_stroke_path(canvas: plutovg_canvas_t; path: plutovg_path_t);
  cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_clip_rect(canvas: plutovg_canvas_t; x, y, w, h: single);
  cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_clip_path(canvas: plutovg_canvas_t; path: plutovg_path_t);
  cdecl; external PLUTOVG_LIB;
function plutovg_canvas_add_glyph(canvas: plutovg_canvas_t;
  codepoint: plutovg_codepoint_t; x, y: single): single; cdecl; external PLUTOVG_LIB;
function plutovg_canvas_add_text(canvas: plutovg_canvas_t; Text: Pointer;
  length: integer; encoding: plutovg_text_encoding_t; x, y: single): single;
  cdecl; external PLUTOVG_LIB;
function plutovg_canvas_fill_text(canvas: plutovg_canvas_t; Text: Pointer;
  length: integer; encoding: plutovg_text_encoding_t; x, y: single): single;
  cdecl; external PLUTOVG_LIB;
function plutovg_canvas_stroke_text(canvas: plutovg_canvas_t;
  Text: Pointer; length: integer; encoding: plutovg_text_encoding_t;
  x, y: single): single;
  cdecl; external PLUTOVG_LIB;
function plutovg_canvas_clip_text(canvas: plutovg_canvas_t; Text: Pointer;
  length: integer; encoding: plutovg_text_encoding_t; x, y: single): single;
  cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_font_metrics(canvas: plutovg_canvas_t;
  var ascent, descent, line_gap: single; var extents: plutovg_rect_t);
  cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_glyph_metrics(canvas: plutovg_canvas_t;
  codepoint: plutovg_codepoint_t; var advance_width, left_side_bearing: single;
  var extents: plutovg_rect_t); cdecl; external PLUTOVG_LIB;
function plutovg_canvas_text_extents(canvas: plutovg_canvas_t;
  Text: Pointer; length: integer; encoding: plutovg_text_encoding_t;
  var extents: plutovg_rect_t): single; cdecl; external PLUTOVG_LIB;
{$ELSE}
type
  // Базовые функции
  Tplutovg_version = function: Integer; cdecl;
  Tplutovg_version_string = function: PAnsiChar; cdecl;

  // Матричные функции
  Tplutovg_matrix_init = procedure(var matrix: plutovg_matrix_t; a, b, c, d, e, f: Single); cdecl;
  Tplutovg_matrix_init_identity = procedure(var matrix: plutovg_matrix_t); cdecl;
  Tplutovg_matrix_init_translate = procedure(var matrix: plutovg_matrix_t; tx, ty: Single); cdecl;
  Tplutovg_matrix_init_scale = procedure(var matrix: plutovg_matrix_t; sx, sy: Single); cdecl;
  Tplutovg_matrix_init_rotate = procedure(var matrix: plutovg_matrix_t; angle: Single); cdecl;
  Tplutovg_matrix_init_shear = procedure(var matrix: plutovg_matrix_t; shx, shy: Single); cdecl;
  Tplutovg_matrix_translate = procedure(var matrix: plutovg_matrix_t; tx, ty: Single); cdecl;
  Tplutovg_matrix_scale = procedure(var matrix: plutovg_matrix_t; sx, sy: Single); cdecl;
  Tplutovg_matrix_rotate = procedure(var matrix: plutovg_matrix_t; angle: Single); cdecl;
  Tplutovg_matrix_shear = procedure(var matrix: plutovg_matrix_t; shx, shy: Single); cdecl;
  Tplutovg_matrix_multiply = procedure(var matrix: plutovg_matrix_t; const left, right: plutovg_matrix_t); cdecl;
  Tplutovg_matrix_invert = function(const matrix: plutovg_matrix_t; var inverse: plutovg_matrix_t): Boolean; cdecl;
  Tplutovg_matrix_map = procedure(const matrix: plutovg_matrix_t; x, y: Single; var xx, yy: Single); cdecl;
  Tplutovg_matrix_map_point = procedure(const matrix: plutovg_matrix_t; const src: plutovg_point_t; var dst: plutovg_point_t); cdecl;
  Tplutovg_matrix_map_points = procedure(const matrix: plutovg_matrix_t; const src: Pplutovg_point_t; dst: Pplutovg_point_t; count: Integer); cdecl;
  Tplutovg_matrix_map_rect = procedure(const matrix: plutovg_matrix_t; const src: plutovg_rect_t; var dst: plutovg_rect_t); cdecl;
  Tplutovg_matrix_parse = function(var matrix: plutovg_matrix_t; data: PAnsiChar; length: Integer): Boolean; cdecl;

  // Функции пути
  Tplutovg_path_create = function: plutovg_path_t; cdecl;
  Tplutovg_path_reference = function(path: plutovg_path_t): plutovg_path_t; cdecl;
  Tplutovg_path_destroy = procedure(path: plutovg_path_t); cdecl;
  Tplutovg_path_get_reference_count = function(path: plutovg_path_t): Integer; cdecl;
  Tplutovg_path_get_elements = function(path: plutovg_path_t; var elements: Pplutovg_path_element_t): Integer; cdecl;
  Tplutovg_path_move_to = procedure(path: plutovg_path_t; x, y: Single); cdecl;
  Tplutovg_path_line_to = procedure(path: plutovg_path_t; x, y: Single); cdecl;
  Tplutovg_path_quad_to = procedure(path: plutovg_path_t; x1, y1, x2, y2: Single); cdecl;
  Tplutovg_path_cubic_to = procedure(path: plutovg_path_t; x1, y1, x2, y2, x3, y3: Single); cdecl;
  Tplutovg_path_arc_to = procedure(path: plutovg_path_t; rx, ry, angle: Single; large_arc_flag, sweep_flag: Boolean; x, y: Single); cdecl;
  Tplutovg_path_close = procedure(path: plutovg_path_t); cdecl;
  Tplutovg_path_get_current_point = procedure(path: plutovg_path_t; var x, y: Single); cdecl;
  Tplutovg_path_reserve = procedure(path: plutovg_path_t; count: Integer); cdecl;
  Tplutovg_path_reset = procedure(path: plutovg_path_t); cdecl;
  Tplutovg_path_add_rect = procedure(path: plutovg_path_t; x, y, w, h: Single); cdecl;
  Tplutovg_path_add_round_rect = procedure(path: plutovg_path_t; x, y, w, h, rx, ry: Single); cdecl;
  Tplutovg_path_add_ellipse = procedure(path: plutovg_path_t; cx, cy, rx, ry: Single); cdecl;
  Tplutovg_path_add_circle = procedure(path: plutovg_path_t; cx, cy, r: Single); cdecl;
  Tplutovg_path_add_arc = procedure(path: plutovg_path_t; cx, cy, r, a0, a1: Single; ccw: Boolean); cdecl;
  Tplutovg_path_add_path = procedure(path: plutovg_path_t; const source: plutovg_path_t; const matrix: plutovg_matrix_t); cdecl;
  Tplutovg_path_transform = procedure(path: plutovg_path_t; const matrix: plutovg_matrix_t); cdecl;
  Tplutovg_path_traverse = procedure(path: plutovg_path_t; traverse_func: plutovg_path_traverse_func_t; closure: Pointer); cdecl;
  Tplutovg_path_traverse_flatten = procedure(path: plutovg_path_t; traverse_func: plutovg_path_traverse_func_t; closure: Pointer); cdecl;
  Tplutovg_path_traverse_dashed = procedure(path: plutovg_path_t; offset: Single; dashes: PSingle; ndashes: Integer; traverse_func: plutovg_path_traverse_func_t; closure: Pointer); cdecl;
  Tplutovg_path_clone = function(path: plutovg_path_t): plutovg_path_t; cdecl;
  Tplutovg_path_clone_flatten = function(path: plutovg_path_t): plutovg_path_t; cdecl;
  Tplutovg_path_clone_dashed = function(path: plutovg_path_t; offset: Single; dashes: PSingle; ndashes: Integer): plutovg_path_t; cdecl;
  Tplutovg_path_extents = function(path: plutovg_path_t; var extents: plutovg_rect_t; tight: Boolean): Single; cdecl;
  Tplutovg_path_length = function(path: plutovg_path_t): Single; cdecl;
  Tplutovg_path_parse = function(path: plutovg_path_t; data: PAnsiChar; length: Integer): Boolean; cdecl;

  // Функции итератора пути
  Tplutovg_path_iterator_init = procedure(var it: plutovg_path_iterator_t; path: plutovg_path_t); cdecl;
  Tplutovg_path_iterator_has_next = function(const it: plutovg_path_iterator_t): Boolean; cdecl;
  Tplutovg_point_array3 = array[0..2] of plutovg_point_t; // Определение массива точек
  Tplutovg_path_iterator_next = function(var it: plutovg_path_iterator_t; var points: Tplutovg_point_array3): plutovg_path_command_t; cdecl;

  // Функции итератора текста
  Tplutovg_text_iterator_init = procedure(var it: plutovg_text_iterator_t; text: Pointer; length: Integer; encoding: plutovg_text_encoding_t); cdecl;
  Tplutovg_text_iterator_has_next = function(const it: plutovg_text_iterator_t): Boolean; cdecl;
  Tplutovg_text_iterator_next = function(var it: plutovg_text_iterator_t): plutovg_codepoint_t; cdecl;

  // Функции шрифта
  Tplutovg_font_face_load_from_file = function(filename: PAnsiChar; ttcindex: Integer): plutovg_font_face_t; cdecl;
  Tplutovg_font_face_load_from_data = function(data: Pointer; length: Cardinal; ttcindex: Integer; destroy_func: plutovg_destroy_func_t; closure: Pointer): plutovg_font_face_t; cdecl;
  Tplutovg_font_face_reference = function(face: plutovg_font_face_t): plutovg_font_face_t; cdecl;
  Tplutovg_font_face_destroy = procedure(face: plutovg_font_face_t); cdecl;
  Tplutovg_font_face_get_reference_count = function(face: plutovg_font_face_t): Integer; cdecl;
  Tplutovg_font_face_get_metrics = procedure(face: plutovg_font_face_t; size: Single; var ascent, descent, line_gap: Single; var extents: plutovg_rect_t); cdecl;
  Tplutovg_font_face_get_glyph_metrics = procedure(face: plutovg_font_face_t; size: Single; codepoint: plutovg_codepoint_t; var advance_width, left_side_bearing: Single; var extents: plutovg_rect_t); cdecl;
  Tplutovg_font_face_get_glyph_path = function(face: plutovg_font_face_t; size, x, y: Single; codepoint: plutovg_codepoint_t; path: plutovg_path_t): Single; cdecl;
  Tplutovg_font_face_traverse_glyph_path = function(face: plutovg_font_face_t; size, x, y: Single; codepoint: plutovg_codepoint_t; traverse_func: plutovg_path_traverse_func_t; closure: Pointer): Single; cdecl;
  Tplutovg_font_face_text_extents = function(face: plutovg_font_face_t; size: Single; text: Pointer; length: Integer; encoding: plutovg_text_encoding_t; var extents: plutovg_rect_t): Single; cdecl;

  // Функции цвета
  Tplutovg_color_init_rgb = procedure(var color: pplutovg_color_t; r, g, b: Single); cdecl;
  Tplutovg_color_init_rgba = procedure(var color: pplutovg_color_t; r, g, b, a: Single); cdecl;
  Tplutovg_color_init_rgb8 = procedure(var color: pplutovg_color_t; r, g, b: Integer); cdecl;
  Tplutovg_color_init_rgba8 = procedure(var color: pplutovg_color_t; r, g, b, a: Integer); cdecl;
  Tplutovg_color_init_rgba32 = procedure(var color: pplutovg_color_t; value: Cardinal); cdecl;
  Tplutovg_color_init_argb32 = procedure(var color: pplutovg_color_t; value: Cardinal); cdecl;
  Tplutovg_color_init_hsl = procedure(var color: pplutovg_color_t; h, s, l: Single); cdecl;
  Tplutovg_color_init_hsla = procedure(var color: pplutovg_color_t; h, s, l, a: Single); cdecl;
  Tplutovg_color_to_rgba32 = function(const color: pplutovg_color_t): Cardinal; cdecl;
  Tplutovg_color_to_argb32 = function(const color: pplutovg_color_t): Cardinal; cdecl;
  Tplutovg_color_parse = function(var color: pplutovg_color_t; data: PAnsiChar; length: Integer): Integer; cdecl;

  // Функции поверхности
  Tplutovg_surface_create = function(width, height: Integer): plutovg_surface_t; cdecl;
  Tplutovg_surface_create_for_data = function(data: PUnsignedChar; width, height, stride: Integer): plutovg_surface_t; cdecl;
  Tplutovg_surface_load_from_image_file = function(filename: PAnsiChar): plutovg_surface_t; cdecl;
  Tplutovg_surface_load_from_image_data = function(data: Pointer; length: Integer): plutovg_surface_t; cdecl;
  Tplutovg_surface_load_from_image_base64 = function(data: PAnsiChar; length: Integer): plutovg_surface_t; cdecl;
  Tplutovg_surface_reference = function(surface: plutovg_surface_t): plutovg_surface_t; cdecl;
  Tplutovg_surface_destroy = procedure(surface: plutovg_surface_t); cdecl;
  Tplutovg_surface_get_reference_count = function(surface: plutovg_surface_t): Integer; cdecl;
  Tplutovg_surface_get_data = function(surface: plutovg_surface_t): PUnsignedChar; cdecl;
  Tplutovg_surface_get_width = function(surface: plutovg_surface_t): Integer; cdecl;
  Tplutovg_surface_get_height = function(surface: plutovg_surface_t): Integer; cdecl;
  Tplutovg_surface_get_stride = function(surface: plutovg_surface_t): Integer; cdecl;
  Tplutovg_surface_clear = procedure(surface: plutovg_surface_t; const color: pplutovg_color_t); cdecl;
  Tplutovg_surface_write_to_png = function(surface: plutovg_surface_t; filename: PAnsiChar): Boolean; cdecl;
  Tplutovg_surface_write_to_jpg = function(surface: plutovg_surface_t; filename: PAnsiChar; quality: Integer): Boolean; cdecl;
  Tplutovg_surface_write_to_png_stream = function(surface: plutovg_surface_t; write_func: plutovg_write_func_t; closure: Pointer): Boolean; cdecl;
  Tplutovg_surface_write_to_jpg_stream = function(surface: plutovg_surface_t; write_func: plutovg_write_func_t; closure: Pointer; quality: Integer): Boolean; cdecl;
  Tplutovg_convert_argb_to_rgba = procedure(dst: PUnsignedChar; const src: PUnsignedChar; width, height, stride: Integer); cdecl;
  Tplutovg_convert_rgba_to_argb = procedure(dst: PUnsignedChar; const src: PUnsignedChar; width, height, stride: Integer); cdecl;

  // Функции краски
  Tplutovg_paint_create_rgb = function(r, g, b: Single): plutovg_paint_t; cdecl;
  Tplutovg_paint_create_rgba = function(r, g, b, a: Single): plutovg_paint_t; cdecl;
  Tplutovg_paint_create_color = function(const color: plutovg_color_t): plutovg_paint_t; cdecl;
  Tplutovg_paint_create_linear_gradient = function(x1, y1, x2, y2: Single; spread: plutovg_spread_method_t; stops: Pplutovg_gradient_stop_t; nstops: Integer; const matrix: plutovg_matrix_t): plutovg_paint_t; cdecl;
  Tplutovg_paint_create_radial_gradient = function(cx, cy, cr, fx, fy, fr: Single; spread: plutovg_spread_method_t; stops: Pplutovg_gradient_stop_t; nstops: Integer; const matrix: plutovg_matrix_t): plutovg_paint_t; cdecl;
  Tplutovg_paint_create_texture = function(surface: plutovg_surface_t; type_: plutovg_texture_type_t; opacity: Single; const matrix: plutovg_matrix_t): plutovg_paint_t; cdecl;
  Tplutovg_paint_reference = function(paint: plutovg_paint_t): plutovg_paint_t; cdecl;
  Tplutovg_paint_destroy = procedure(paint: plutovg_paint_t); cdecl;
  Tplutovg_paint_get_reference_count = function(paint: plutovg_paint_t): Integer; cdecl;

  // Функции канваса
  Tplutovg_canvas_create = function(surface: plutovg_surface_t): plutovg_canvas_t; cdecl;
  Tplutovg_canvas_reference = function(canvas: plutovg_canvas_t): plutovg_canvas_t; cdecl;
  Tplutovg_canvas_destroy = procedure(canvas: plutovg_canvas_t); cdecl;
  Tplutovg_canvas_get_reference_count = function(canvas: plutovg_canvas_t): Integer; cdecl;
  Tplutovg_canvas_get_surface = function(canvas: plutovg_canvas_t): plutovg_surface_t; cdecl;
  Tplutovg_canvas_save = procedure(canvas: plutovg_canvas_t); cdecl;
  Tplutovg_canvas_restore = procedure(canvas: plutovg_canvas_t); cdecl;
  Tplutovg_canvas_set_rgb = procedure(canvas: plutovg_canvas_t; r, g, b: Single); cdecl;
  Tplutovg_canvas_set_rgba = procedure(canvas: plutovg_canvas_t; r, g, b, a: Single); cdecl;
  Tplutovg_canvas_set_color = procedure(canvas: plutovg_canvas_t; const color: pplutovg_color_t); cdecl;
  Tplutovg_canvas_set_linear_gradient = procedure(canvas: plutovg_canvas_t; x1, y1, x2, y2: Single; spread: plutovg_spread_method_t; stops: Pplutovg_gradient_stop_t; nstops: Integer; const matrix: plutovg_matrix_t); cdecl;
  Tplutovg_canvas_set_radial_gradient = procedure(canvas: plutovg_canvas_t; cx, cy, cr, fx, fy, fr: Single; spread: plutovg_spread_method_t; stops: Pplutovg_gradient_stop_t; nstops: Integer; const matrix: plutovg_matrix_t); cdecl;
  Tplutovg_canvas_set_texture = procedure(canvas: plutovg_canvas_t; surface: plutovg_surface_t; type_: plutovg_texture_type_t; opacity: Single; const matrix: plutovg_matrix_t); cdecl;
  Tplutovg_canvas_set_paint = procedure(canvas: plutovg_canvas_t; paint: plutovg_paint_t); cdecl;
  Tplutovg_canvas_get_paint = function(canvas: plutovg_canvas_t; var color: pplutovg_color_t): plutovg_paint_t; cdecl;
  Tplutovg_canvas_set_font = procedure(canvas: plutovg_canvas_t; face: plutovg_font_face_t; size: Single); cdecl;
  Tplutovg_canvas_set_font_face = procedure(canvas: plutovg_canvas_t; face: plutovg_font_face_t); cdecl;
  Tplutovg_canvas_get_font_face = function(canvas: plutovg_canvas_t): plutovg_font_face_t; cdecl;
  Tplutovg_canvas_set_font_size = procedure(canvas: plutovg_canvas_t; size: Single); cdecl;
  Tplutovg_canvas_get_font_size = function(canvas: plutovg_canvas_t): Single; cdecl;
  Tplutovg_canvas_set_fill_rule = procedure(canvas: plutovg_canvas_t; winding: plutovg_fill_rule_t); cdecl;
  Tplutovg_canvas_get_fill_rule = function(canvas: plutovg_canvas_t): plutovg_fill_rule_t; cdecl;
  Tplutovg_canvas_set_operator = procedure(canvas: plutovg_canvas_t; op: plutovg_operator_t); cdecl;
  Tplutovg_canvas_get_operator = function(canvas: plutovg_canvas_t): plutovg_operator_t; cdecl;
  Tplutovg_canvas_set_opacity = procedure(canvas: plutovg_canvas_t; opacity: Single); cdecl;
  Tplutovg_canvas_get_opacity = function(canvas: plutovg_canvas_t): Single; cdecl;
  Tplutovg_canvas_set_line_width = procedure(canvas: plutovg_canvas_t; line_width: Single); cdecl;
  Tplutovg_canvas_get_line_width = function(canvas: plutovg_canvas_t): Single; cdecl;
  Tplutovg_canvas_set_line_cap = procedure(canvas: plutovg_canvas_t; line_cap: plutovg_line_cap_t); cdecl;
  Tplutovg_canvas_get_line_cap = function(canvas: plutovg_canvas_t): plutovg_line_cap_t; cdecl;
  Tplutovg_canvas_set_line_join = procedure(canvas: plutovg_canvas_t; line_join: plutovg_line_join_t); cdecl;
  Tplutovg_canvas_get_line_join = function(canvas: plutovg_canvas_t): plutovg_line_join_t; cdecl;
  Tplutovg_canvas_set_miter_limit = procedure(canvas: plutovg_canvas_t; miter_limit: Single); cdecl;
  Tplutovg_canvas_get_miter_limit = function(canvas: plutovg_canvas_t): Single; cdecl;
  Tplutovg_canvas_set_dash = procedure(canvas: plutovg_canvas_t; offset: Single; dashes: PSingle; ndashes: Integer); cdecl;
  Tplutovg_canvas_set_dash_offset = procedure(canvas: plutovg_canvas_t; offset: Single); cdecl;
  Tplutovg_canvas_get_dash_offset = function(canvas: plutovg_canvas_t): Single; cdecl;
  Tplutovg_canvas_set_dash_array = procedure(canvas: plutovg_canvas_t; dashes: PSingle; ndashes: Integer); cdecl;
  Tplutovg_canvas_get_dash_array = function(canvas: plutovg_canvas_t; var dashes: PSingle): Integer; cdecl;
  Tplutovg_canvas_translate = procedure(canvas: plutovg_canvas_t; tx, ty: Single); cdecl;
  Tplutovg_canvas_scale = procedure(canvas: plutovg_canvas_t; sx, sy: Single); cdecl;
  Tplutovg_canvas_shear = procedure(canvas: plutovg_canvas_t; shx, shy: Single); cdecl;
  Tplutovg_canvas_rotate = procedure(canvas: plutovg_canvas_t; angle: Single); cdecl;
  Tplutovg_canvas_transform = procedure(canvas: plutovg_canvas_t; const matrix: plutovg_matrix_t); cdecl;
  Tplutovg_canvas_reset_matrix = procedure(canvas: plutovg_canvas_t); cdecl;
  Tplutovg_canvas_set_matrix = procedure(canvas: plutovg_canvas_t; const matrix: plutovg_matrix_t); cdecl;
  Tplutovg_canvas_get_matrix = procedure(canvas: plutovg_canvas_t; var matrix: plutovg_matrix_t); cdecl;
  Tplutovg_canvas_map = procedure(canvas: plutovg_canvas_t; x, y: Single; var xx, yy: Single); cdecl;
  Tplutovg_canvas_map_point = procedure(canvas: plutovg_canvas_t; const src: plutovg_point_t; var dst: plutovg_point_t); cdecl;
  Tplutovg_canvas_map_rect = procedure(canvas: plutovg_canvas_t; const src: plutovg_rect_t; var dst: plutovg_rect_t); cdecl;
  Tplutovg_canvas_move_to = procedure(canvas: plutovg_canvas_t; x, y: Single); cdecl;
  Tplutovg_canvas_line_to = procedure(canvas: plutovg_canvas_t; x, y: Single); cdecl;
  Tplutovg_canvas_quad_to = procedure(canvas: plutovg_canvas_t; x1, y1, x2, y2: Single); cdecl;
  Tplutovg_canvas_cubic_to = procedure(canvas: plutovg_canvas_t; x1, y1, x2, y2, x3, y3: Single); cdecl;
  Tplutovg_canvas_arc_to = procedure(canvas: plutovg_canvas_t; rx, ry, angle: Single; large_arc_flag, sweep_flag: Boolean; x, y: Single); cdecl;
  Tplutovg_canvas_rect = procedure(canvas: plutovg_canvas_t; x, y, w, h: Single); cdecl;
  Tplutovg_canvas_round_rect = procedure(canvas: plutovg_canvas_t; x, y, w, h, rx, ry: Single); cdecl;
  Tplutovg_canvas_ellipse = procedure(canvas: plutovg_canvas_t; cx, cy, rx, ry: Single); cdecl;
  Tplutovg_canvas_circle = procedure(canvas: plutovg_canvas_t; cx, cy, r: Single); cdecl;
  Tplutovg_canvas_arc = procedure(canvas: plutovg_canvas_t; cx, cy, r, a0, a1: Single; ccw: Boolean); cdecl;
  Tplutovg_canvas_add_path = procedure(canvas: plutovg_canvas_t; path: plutovg_path_t); cdecl;
  Tplutovg_canvas_new_path = procedure(canvas: plutovg_canvas_t); cdecl;
  Tplutovg_canvas_close_path = procedure(canvas: plutovg_canvas_t); cdecl;
  Tplutovg_canvas_get_current_point = procedure(canvas: plutovg_canvas_t; var x, y: Single); cdecl;
  Tplutovg_canvas_get_path = function(canvas: plutovg_canvas_t): plutovg_path_t; cdecl;
  Tplutovg_canvas_fill_extents = procedure(canvas: plutovg_canvas_t; var extents: plutovg_rect_t); cdecl;
  Tplutovg_canvas_stroke_extents = procedure(canvas: plutovg_canvas_t; var extents: plutovg_rect_t); cdecl;
  Tplutovg_canvas_clip_extents = procedure(canvas: plutovg_canvas_t; var extents: plutovg_rect_t); cdecl;
  Tplutovg_canvas_fill = procedure(canvas: plutovg_canvas_t); cdecl;
  Tplutovg_canvas_stroke = procedure(canvas: plutovg_canvas_t); cdecl;
  Tplutovg_canvas_clip = procedure(canvas: plutovg_canvas_t); cdecl;
  Tplutovg_canvas_paint = procedure(canvas: plutovg_canvas_t); cdecl;
  Tplutovg_canvas_fill_preserve = procedure(canvas: plutovg_canvas_t); cdecl;
  Tplutovg_canvas_stroke_preserve = procedure(canvas: plutovg_canvas_t); cdecl;
  Tplutovg_canvas_clip_preserve = procedure(canvas: plutovg_canvas_t); cdecl;
  Tplutovg_canvas_fill_rect = procedure(canvas: plutovg_canvas_t; x, y, w, h: Single); cdecl;
  Tplutovg_canvas_fill_path = procedure(canvas: plutovg_canvas_t; path: plutovg_path_t); cdecl;
  Tplutovg_canvas_stroke_rect = procedure(canvas: plutovg_canvas_t; x, y, w, h: Single); cdecl;
  Tplutovg_canvas_stroke_path = procedure(canvas: plutovg_canvas_t; path: plutovg_path_t); cdecl;
  Tplutovg_canvas_clip_rect = procedure(canvas: plutovg_canvas_t; x, y, w, h: Single); cdecl;
  Tplutovg_canvas_clip_path = procedure(canvas: plutovg_canvas_t; path: plutovg_path_t); cdecl;
  Tplutovg_canvas_add_glyph = function(canvas: plutovg_canvas_t; codepoint: plutovg_codepoint_t; x, y: Single): Single; cdecl;
  Tplutovg_canvas_add_text = function(canvas: plutovg_canvas_t; text: Pointer; length: Integer; encoding: plutovg_text_encoding_t; x, y: Single): Single; cdecl;
  Tplutovg_canvas_fill_text = function(canvas: plutovg_canvas_t; text: Pointer; length: Integer; encoding: plutovg_text_encoding_t; x, y: Single): Single; cdecl;
  Tplutovg_canvas_stroke_text = function(canvas: plutovg_canvas_t; text: Pointer; length: Integer; encoding: plutovg_text_encoding_t; x, y: Single): Single; cdecl;
  Tplutovg_canvas_clip_text = function(canvas: plutovg_canvas_t; text: Pointer; length: Integer; encoding: plutovg_text_encoding_t; x, y: Single): Single; cdecl;
  Tplutovg_canvas_font_metrics = procedure(canvas: plutovg_canvas_t; var ascent, descent, line_gap: Single; var extents: plutovg_rect_t); cdecl;
  Tplutovg_canvas_glyph_metrics = procedure(canvas: plutovg_canvas_t; codepoint: plutovg_codepoint_t; var advance_width, left_side_bearing: Single; var extents: plutovg_rect_t); cdecl;
  Tplutovg_canvas_text_extents = function(canvas: plutovg_canvas_t; text: Pointer; length: Integer; encoding: plutovg_text_encoding_t; var extents: plutovg_rect_t): Single; cdecl;

var
  LibPlutovgHandle: {$IFDEF MSWINDOWS}THandle{$ELSE}TLibHandle = NilHandle{$ENDIF};
  // Базовые функции
  plutovg_version: Tplutovg_version;
  plutovg_version_string: Tplutovg_version_string;

  // Матричные функции
  plutovg_matrix_init: Tplutovg_matrix_init;
  plutovg_matrix_init_identity: Tplutovg_matrix_init_identity;
  plutovg_matrix_init_translate: Tplutovg_matrix_init_translate;
  plutovg_matrix_init_scale: Tplutovg_matrix_init_scale;
  plutovg_matrix_init_rotate: Tplutovg_matrix_init_rotate;
  plutovg_matrix_init_shear: Tplutovg_matrix_init_shear;
  plutovg_matrix_translate: Tplutovg_matrix_translate;
  plutovg_matrix_scale: Tplutovg_matrix_scale;
  plutovg_matrix_rotate: Tplutovg_matrix_rotate;
  plutovg_matrix_shear: Tplutovg_matrix_shear;
  plutovg_matrix_multiply: Tplutovg_matrix_multiply;
  plutovg_matrix_invert: Tplutovg_matrix_invert;
  plutovg_matrix_map: Tplutovg_matrix_map;
  plutovg_matrix_map_point: Tplutovg_matrix_map_point;
  plutovg_matrix_map_points: Tplutovg_matrix_map_points;
  plutovg_matrix_map_rect: Tplutovg_matrix_map_rect;
  plutovg_matrix_parse: Tplutovg_matrix_parse;

  // Функции пути
  plutovg_path_create: Tplutovg_path_create;
  plutovg_path_reference: Tplutovg_path_reference;
  plutovg_path_destroy: Tplutovg_path_destroy;
  plutovg_path_get_reference_count: Tplutovg_path_get_reference_count;
  plutovg_path_get_elements: Tplutovg_path_get_elements;
  plutovg_path_move_to: Tplutovg_path_move_to;
  plutovg_path_line_to: Tplutovg_path_line_to;
  plutovg_path_quad_to: Tplutovg_path_quad_to;
  plutovg_path_cubic_to: Tplutovg_path_cubic_to;
  plutovg_path_arc_to: Tplutovg_path_arc_to;
  plutovg_path_close: Tplutovg_path_close;
  plutovg_path_get_current_point: Tplutovg_path_get_current_point;
  plutovg_path_reserve: Tplutovg_path_reserve;
  plutovg_path_reset: Tplutovg_path_reset;
  plutovg_path_add_rect: Tplutovg_path_add_rect;
  plutovg_path_add_round_rect: Tplutovg_path_add_round_rect;
  plutovg_path_add_ellipse: Tplutovg_path_add_ellipse;
  plutovg_path_add_circle: Tplutovg_path_add_circle;
  plutovg_path_add_arc: Tplutovg_path_add_arc;
  plutovg_path_add_path: Tplutovg_path_add_path;
  plutovg_path_transform: Tplutovg_path_transform;
  plutovg_path_traverse: Tplutovg_path_traverse;
  plutovg_path_traverse_flatten: Tplutovg_path_traverse_flatten;
  plutovg_path_traverse_dashed: Tplutovg_path_traverse_dashed;
  plutovg_path_clone: Tplutovg_path_clone;
  plutovg_path_clone_flatten: Tplutovg_path_clone_flatten;
  plutovg_path_clone_dashed: Tplutovg_path_clone_dashed;
  plutovg_path_extents: Tplutovg_path_extents;
  plutovg_path_length: Tplutovg_path_length;
  plutovg_path_parse: Tplutovg_path_parse;

  // Функции итератора пути
  plutovg_path_iterator_init: Tplutovg_path_iterator_init;
  plutovg_path_iterator_has_next: Tplutovg_path_iterator_has_next;
  plutovg_path_iterator_next: Tplutovg_path_iterator_next;

  // Функции итератора текста
  plutovg_text_iterator_init: Tplutovg_text_iterator_init;
  plutovg_text_iterator_has_next: Tplutovg_text_iterator_has_next;
  plutovg_text_iterator_next: Tplutovg_text_iterator_next;

  // Функции шрифта
  plutovg_font_face_load_from_file: Tplutovg_font_face_load_from_file;
  plutovg_font_face_load_from_data: Tplutovg_font_face_load_from_data;
  plutovg_font_face_reference: Tplutovg_font_face_reference;
  plutovg_font_face_destroy: Tplutovg_font_face_destroy;
  plutovg_font_face_get_reference_count: Tplutovg_font_face_get_reference_count;
  plutovg_font_face_get_metrics: Tplutovg_font_face_get_metrics;
  plutovg_font_face_get_glyph_metrics: Tplutovg_font_face_get_glyph_metrics;
  plutovg_font_face_get_glyph_path: Tplutovg_font_face_get_glyph_path;
  plutovg_font_face_traverse_glyph_path: Tplutovg_font_face_traverse_glyph_path;
  plutovg_font_face_text_extents: Tplutovg_font_face_text_extents;

  // Функции цвета
  plutovg_color_init_rgb: Tplutovg_color_init_rgb;
  plutovg_color_init_rgba: Tplutovg_color_init_rgba;
  plutovg_color_init_rgb8: Tplutovg_color_init_rgb8;
  plutovg_color_init_rgba8: Tplutovg_color_init_rgba8;
  plutovg_color_init_rgba32: Tplutovg_color_init_rgba32;
  plutovg_color_init_argb32: Tplutovg_color_init_argb32;
  plutovg_color_init_hsl: Tplutovg_color_init_hsl;
  plutovg_color_init_hsla: Tplutovg_color_init_hsla;
  plutovg_color_to_rgba32: Tplutovg_color_to_rgba32;
  plutovg_color_to_argb32: Tplutovg_color_to_argb32;
  plutovg_color_parse: Tplutovg_color_parse;

  // Функции поверхности
  plutovg_surface_create: Tplutovg_surface_create;
  plutovg_surface_create_for_data: Tplutovg_surface_create_for_data;
  plutovg_surface_load_from_image_file: Tplutovg_surface_load_from_image_file;
  plutovg_surface_load_from_image_data: Tplutovg_surface_load_from_image_data;
  plutovg_surface_load_from_image_base64: Tplutovg_surface_load_from_image_base64;
  plutovg_surface_reference: Tplutovg_surface_reference;
  plutovg_surface_destroy: Tplutovg_surface_destroy;
  plutovg_surface_get_reference_count: Tplutovg_surface_get_reference_count;
  plutovg_surface_get_data: Tplutovg_surface_get_data;
  plutovg_surface_get_width: Tplutovg_surface_get_width;
  plutovg_surface_get_height: Tplutovg_surface_get_height;
  plutovg_surface_get_stride: Tplutovg_surface_get_stride;
  plutovg_surface_clear: Tplutovg_surface_clear;
  plutovg_surface_write_to_png: Tplutovg_surface_write_to_png;
  plutovg_surface_write_to_jpg: Tplutovg_surface_write_to_jpg;
  plutovg_surface_write_to_png_stream: Tplutovg_surface_write_to_png_stream;
  plutovg_surface_write_to_jpg_stream: Tplutovg_surface_write_to_jpg_stream;
  plutovg_convert_argb_to_rgba: Tplutovg_convert_argb_to_rgba;
  plutovg_convert_rgba_to_argb: Tplutovg_convert_rgba_to_argb;

  // Функции краски
  plutovg_paint_create_rgb: Tplutovg_paint_create_rgb;
  plutovg_paint_create_rgba: Tplutovg_paint_create_rgba;
  plutovg_paint_create_color: Tplutovg_paint_create_color;
  plutovg_paint_create_linear_gradient: Tplutovg_paint_create_linear_gradient;
  plutovg_paint_create_radial_gradient: Tplutovg_paint_create_radial_gradient;
  plutovg_paint_create_texture: Tplutovg_paint_create_texture;
  plutovg_paint_reference: Tplutovg_paint_reference;
  plutovg_paint_destroy: Tplutovg_paint_destroy;
  plutovg_paint_get_reference_count: Tplutovg_paint_get_reference_count;

  // Функции канваса
  plutovg_canvas_create: Tplutovg_canvas_create;
  plutovg_canvas_reference: Tplutovg_canvas_reference;
  plutovg_canvas_destroy: Tplutovg_canvas_destroy;
  plutovg_canvas_get_reference_count: Tplutovg_canvas_get_reference_count;
  plutovg_canvas_get_surface: Tplutovg_canvas_get_surface;
  plutovg_canvas_save: Tplutovg_canvas_save;
  plutovg_canvas_restore: Tplutovg_canvas_restore;
  plutovg_canvas_set_rgb: Tplutovg_canvas_set_rgb;
  plutovg_canvas_set_rgba: Tplutovg_canvas_set_rgba;
  plutovg_canvas_set_color: Tplutovg_canvas_set_color;
  plutovg_canvas_set_linear_gradient: Tplutovg_canvas_set_linear_gradient;
  plutovg_canvas_set_radial_gradient: Tplutovg_canvas_set_radial_gradient;
  plutovg_canvas_set_texture: Tplutovg_canvas_set_texture;
  plutovg_canvas_set_paint: Tplutovg_canvas_set_paint;
  plutovg_canvas_get_paint: Tplutovg_canvas_get_paint;
  plutovg_canvas_set_font: Tplutovg_canvas_set_font;
  plutovg_canvas_set_font_face: Tplutovg_canvas_set_font_face;
  plutovg_canvas_get_font_face: Tplutovg_canvas_get_font_face;
  plutovg_canvas_set_font_size: Tplutovg_canvas_set_font_size;
  plutovg_canvas_get_font_size: Tplutovg_canvas_get_font_size;
  plutovg_canvas_set_fill_rule: Tplutovg_canvas_set_fill_rule;
  plutovg_canvas_get_fill_rule: Tplutovg_canvas_get_fill_rule;
  plutovg_canvas_set_operator: Tplutovg_canvas_set_operator;
  plutovg_canvas_get_operator: Tplutovg_canvas_get_operator;
  plutovg_canvas_set_opacity: Tplutovg_canvas_set_opacity;
  plutovg_canvas_get_opacity: Tplutovg_canvas_get_opacity;
  plutovg_canvas_set_line_width: Tplutovg_canvas_set_line_width;
  plutovg_canvas_get_line_width: Tplutovg_canvas_get_line_width;
  plutovg_canvas_set_line_cap: Tplutovg_canvas_set_line_cap;
  plutovg_canvas_get_line_cap: Tplutovg_canvas_get_line_cap;
  plutovg_canvas_set_line_join: Tplutovg_canvas_set_line_join;
  plutovg_canvas_get_line_join: Tplutovg_canvas_get_line_join;
  plutovg_canvas_set_miter_limit: Tplutovg_canvas_set_miter_limit;
  plutovg_canvas_get_miter_limit: Tplutovg_canvas_get_miter_limit;
  plutovg_canvas_set_dash: Tplutovg_canvas_set_dash;
  plutovg_canvas_set_dash_offset: Tplutovg_canvas_set_dash_offset;
  plutovg_canvas_get_dash_offset: Tplutovg_canvas_get_dash_offset;
  plutovg_canvas_set_dash_array: Tplutovg_canvas_set_dash_array;
  plutovg_canvas_get_dash_array: Tplutovg_canvas_get_dash_array;
  plutovg_canvas_translate: Tplutovg_canvas_translate;
  plutovg_canvas_scale: Tplutovg_canvas_scale;
  plutovg_canvas_shear: Tplutovg_canvas_shear;
  plutovg_canvas_rotate: Tplutovg_canvas_rotate;
  plutovg_canvas_transform: Tplutovg_canvas_transform;
  plutovg_canvas_reset_matrix: Tplutovg_canvas_reset_matrix;
  plutovg_canvas_set_matrix: Tplutovg_canvas_set_matrix;
  plutovg_canvas_get_matrix: Tplutovg_canvas_get_matrix;
  plutovg_canvas_map: Tplutovg_canvas_map;
  plutovg_canvas_map_point: Tplutovg_canvas_map_point;
  plutovg_canvas_map_rect: Tplutovg_canvas_map_rect;
  plutovg_canvas_move_to: Tplutovg_canvas_move_to;
  plutovg_canvas_line_to: Tplutovg_canvas_line_to;
  plutovg_canvas_quad_to: Tplutovg_canvas_quad_to;
  plutovg_canvas_cubic_to: Tplutovg_canvas_cubic_to;
  plutovg_canvas_arc_to: Tplutovg_canvas_arc_to;
  plutovg_canvas_rect: Tplutovg_canvas_rect;
  plutovg_canvas_round_rect: Tplutovg_canvas_round_rect;
  plutovg_canvas_ellipse: Tplutovg_canvas_ellipse;
  plutovg_canvas_circle: Tplutovg_canvas_circle;
  plutovg_canvas_arc: Tplutovg_canvas_arc;
  plutovg_canvas_add_path: Tplutovg_canvas_add_path;
  plutovg_canvas_new_path: Tplutovg_canvas_new_path;
  plutovg_canvas_close_path: Tplutovg_canvas_close_path;
  plutovg_canvas_get_current_point: Tplutovg_canvas_get_current_point;
  plutovg_canvas_get_path: Tplutovg_canvas_get_path;
  plutovg_canvas_fill_extents: Tplutovg_canvas_fill_extents;
  plutovg_canvas_stroke_extents: Tplutovg_canvas_stroke_extents;
  plutovg_canvas_clip_extents: Tplutovg_canvas_clip_extents;
  plutovg_canvas_fill: Tplutovg_canvas_fill;
  plutovg_canvas_stroke: Tplutovg_canvas_stroke;
  plutovg_canvas_clip: Tplutovg_canvas_clip;
  plutovg_canvas_paint: Tplutovg_canvas_paint;
  plutovg_canvas_fill_preserve: Tplutovg_canvas_fill_preserve;
  plutovg_canvas_stroke_preserve: Tplutovg_canvas_stroke_preserve;
  plutovg_canvas_clip_preserve: Tplutovg_canvas_clip_preserve;
  plutovg_canvas_fill_rect: Tplutovg_canvas_fill_rect;
  plutovg_canvas_fill_path: Tplutovg_canvas_fill_path;
  plutovg_canvas_stroke_rect: Tplutovg_canvas_stroke_rect;
  plutovg_canvas_stroke_path: Tplutovg_canvas_stroke_path;
  plutovg_canvas_clip_rect: Tplutovg_canvas_clip_rect;
  plutovg_canvas_clip_path: Tplutovg_canvas_clip_path;
  plutovg_canvas_add_glyph: Tplutovg_canvas_add_glyph;
  plutovg_canvas_add_text: Tplutovg_canvas_add_text;
  plutovg_canvas_fill_text: Tplutovg_canvas_fill_text;
  plutovg_canvas_stroke_text: Tplutovg_canvas_stroke_text;
  plutovg_canvas_clip_text: Tplutovg_canvas_clip_text;
  plutovg_canvas_font_metrics: Tplutovg_canvas_font_metrics;
  plutovg_canvas_glyph_metrics: Tplutovg_canvas_glyph_metrics;
  plutovg_canvas_text_extents: Tplutovg_canvas_text_extents;

procedure InitPlutovg(libplutovg: string = 'plutovg');
procedure FreePlutovg();

{$ENDIF}

implementation

{$IFNDEF WINDOWS}
procedure InitPlutovg(libplutovg: string = 'plutovg');
begin
  LibPlutovgHandle :=
    {$IFNDEF FPC}
    SafeLoadLibrary
    {$ELSE}
dynlibs.SafeLoadLibrary
    {$ENDIF}
    (libplutovg);
  if (LibPlutovgHandle <>
    {$IFDEF MSWINDOWS}
    0
    {$ELSE}
NilHandle
    {$ENDIF}
    ) then
  begin
    // Базовые функции
    @plutovg_version := GetProcAddress(LibPlutovgHandle, 'plutovg_version');
    @plutovg_version_string := GetProcAddress(LibPlutovgHandle, 'plutovg_version_string');

    // Матричные функции
    @plutovg_matrix_init := GetProcAddress(LibPlutovgHandle, 'plutovg_matrix_init');
    @plutovg_matrix_init_identity :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_matrix_init_identity');
    @plutovg_matrix_init_translate :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_matrix_init_translate');
    @plutovg_matrix_init_scale :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_matrix_init_scale');
    @plutovg_matrix_init_rotate :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_matrix_init_rotate');
    @plutovg_matrix_init_shear :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_matrix_init_shear');
    @plutovg_matrix_translate := GetProcAddress(LibPlutovgHandle,
      'plutovg_matrix_translate');
    @plutovg_matrix_scale := GetProcAddress(LibPlutovgHandle, 'plutovg_matrix_scale');
    @plutovg_matrix_rotate := GetProcAddress(LibPlutovgHandle, 'plutovg_matrix_rotate');
    @plutovg_matrix_shear := GetProcAddress(LibPlutovgHandle, 'plutovg_matrix_shear');
    @plutovg_matrix_multiply := GetProcAddress(LibPlutovgHandle, 'plutovg_matrix_multiply');
    @plutovg_matrix_invert := GetProcAddress(LibPlutovgHandle, 'plutovg_matrix_invert');
    @plutovg_matrix_map := GetProcAddress(LibPlutovgHandle, 'plutovg_matrix_map');
    @plutovg_matrix_map_point := GetProcAddress(LibPlutovgHandle,
      'plutovg_matrix_map_point');
    @plutovg_matrix_map_points :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_matrix_map_points');
    @plutovg_matrix_map_rect := GetProcAddress(LibPlutovgHandle, 'plutovg_matrix_map_rect');
    @plutovg_matrix_parse := GetProcAddress(LibPlutovgHandle, 'plutovg_matrix_parse');

    // Функции пути
    @plutovg_path_create := GetProcAddress(LibPlutovgHandle, 'plutovg_path_create');
    @plutovg_path_reference := GetProcAddress(LibPlutovgHandle, 'plutovg_path_reference');
    @plutovg_path_destroy := GetProcAddress(LibPlutovgHandle, 'plutovg_path_destroy');
    @plutovg_path_get_reference_count :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_path_get_reference_count');
    @plutovg_path_get_elements :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_path_get_elements');
    @plutovg_path_move_to := GetProcAddress(LibPlutovgHandle, 'plutovg_path_move_to');
    @plutovg_path_line_to := GetProcAddress(LibPlutovgHandle, 'plutovg_path_line_to');
    @plutovg_path_quad_to := GetProcAddress(LibPlutovgHandle, 'plutovg_path_quad_to');
    @plutovg_path_cubic_to := GetProcAddress(LibPlutovgHandle, 'plutovg_path_cubic_to');
    @plutovg_path_arc_to := GetProcAddress(LibPlutovgHandle, 'plutovg_path_arc_to');
    @plutovg_path_close := GetProcAddress(LibPlutovgHandle, 'plutovg_path_close');
    @plutovg_path_get_current_point :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_path_get_current_point');
    @plutovg_path_reserve := GetProcAddress(LibPlutovgHandle, 'plutovg_path_reserve');
    @plutovg_path_reset := GetProcAddress(LibPlutovgHandle, 'plutovg_path_reset');
    @plutovg_path_add_rect := GetProcAddress(LibPlutovgHandle, 'plutovg_path_add_rect');
    @plutovg_path_add_round_rect :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_path_add_round_rect');
    @plutovg_path_add_ellipse := GetProcAddress(LibPlutovgHandle,
      'plutovg_path_add_ellipse');
    @plutovg_path_add_circle := GetProcAddress(LibPlutovgHandle, 'plutovg_path_add_circle');
    @plutovg_path_add_arc := GetProcAddress(LibPlutovgHandle, 'plutovg_path_add_arc');
    @plutovg_path_add_path := GetProcAddress(LibPlutovgHandle, 'plutovg_path_add_path');
    @plutovg_path_transform := GetProcAddress(LibPlutovgHandle, 'plutovg_path_transform');
    @plutovg_path_traverse := GetProcAddress(LibPlutovgHandle, 'plutovg_path_traverse');
    @plutovg_path_traverse_flatten :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_path_traverse_flatten');
    @plutovg_path_traverse_dashed :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_path_traverse_dashed');
    @plutovg_path_clone := GetProcAddress(LibPlutovgHandle, 'plutovg_path_clone');
    @plutovg_path_clone_flatten :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_path_clone_flatten');
    @plutovg_path_clone_dashed :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_path_clone_dashed');
    @plutovg_path_extents := GetProcAddress(LibPlutovgHandle, 'plutovg_path_extents');
    @plutovg_path_length := GetProcAddress(LibPlutovgHandle, 'plutovg_path_length');
    @plutovg_path_parse := GetProcAddress(LibPlutovgHandle, 'plutovg_path_parse');

    // Функции итератора пути
    @plutovg_path_iterator_init :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_path_iterator_init');
    @plutovg_path_iterator_has_next :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_path_iterator_has_next');
    @plutovg_path_iterator_next :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_path_iterator_next');

    // Функции итератора текста
    @plutovg_text_iterator_init :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_text_iterator_init');
    @plutovg_text_iterator_has_next :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_text_iterator_has_next');
    @plutovg_text_iterator_next :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_text_iterator_next');

    // Функции шрифта
    @plutovg_font_face_load_from_file :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_font_face_load_from_file');
    @plutovg_font_face_load_from_data :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_font_face_load_from_data');
    @plutovg_font_face_reference :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_font_face_reference');
    @plutovg_font_face_destroy :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_font_face_destroy');
    @plutovg_font_face_get_reference_count :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_font_face_get_reference_count');
    @plutovg_font_face_get_metrics :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_font_face_get_metrics');
    @plutovg_font_face_get_glyph_metrics :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_font_face_get_glyph_metrics');
    @plutovg_font_face_get_glyph_path :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_font_face_get_glyph_path');
    @plutovg_font_face_traverse_glyph_path :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_font_face_traverse_glyph_path');
    @plutovg_font_face_text_extents :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_font_face_text_extents');

    // Функции цвета
    @plutovg_color_init_rgb :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_color_init_rgb');
    @plutovg_color_init_rgba := GetProcAddress(LibPlutovgHandle, 'plutovg_color_init_rgba');
    @plutovg_color_init_rgb8 := GetProcAddress(LibPlutovgHandle, 'plutovg_color_init_rgb8');
    @plutovg_color_init_rgba8 := GetProcAddress(LibPlutovgHandle,
      'plutovg_color_init_rgba8');
    @plutovg_color_init_rgba32 :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_color_init_rgba32');
    @plutovg_color_init_argb32 :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_color_init_argb32');
    @plutovg_color_init_hsl := GetProcAddress(LibPlutovgHandle, 'plutovg_color_init_hsl');
    @plutovg_color_init_hsla := GetProcAddress(LibPlutovgHandle, 'plutovg_color_init_hsla');
    @plutovg_color_to_rgba32 := GetProcAddress(LibPlutovgHandle, 'plutovg_color_to_rgba32');
    @plutovg_color_to_argb32 := GetProcAddress(LibPlutovgHandle, 'plutovg_color_to_argb32');
    @plutovg_color_parse := GetProcAddress(LibPlutovgHandle, 'plutovg_color_parse');

    // Функции поверхности
    @plutovg_surface_create :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_surface_create');
    @plutovg_surface_create_for_data :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_surface_create_for_data');
    @plutovg_surface_load_from_image_file :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_surface_load_from_image_file');
    @plutovg_surface_load_from_image_data :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_surface_load_from_image_data');
    @plutovg_surface_load_from_image_base64 :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_surface_load_from_image_base64');
    @plutovg_surface_reference :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_surface_reference');
    @plutovg_surface_destroy := GetProcAddress(LibPlutovgHandle, 'plutovg_surface_destroy');
    @plutovg_surface_get_reference_count :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_surface_get_reference_count');
    @plutovg_surface_get_data := GetProcAddress(LibPlutovgHandle,
      'plutovg_surface_get_data');
    @plutovg_surface_get_width :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_surface_get_width');
    @plutovg_surface_get_height :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_surface_get_height');
    @plutovg_surface_get_stride :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_surface_get_stride');
    @plutovg_surface_clear := GetProcAddress(LibPlutovgHandle, 'plutovg_surface_clear');
    @plutovg_surface_write_to_png :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_surface_write_to_png');
    @plutovg_surface_write_to_jpg :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_surface_write_to_jpg');
    @plutovg_surface_write_to_png_stream :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_surface_write_to_png_stream');
    @plutovg_surface_write_to_jpg_stream :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_surface_write_to_jpg_stream');
    @plutovg_convert_argb_to_rgba :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_convert_argb_to_rgba');
    @plutovg_convert_rgba_to_argb :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_convert_rgba_to_argb');

    // Функции краски
    @plutovg_paint_create_rgb :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_paint_create_rgb');
    @plutovg_paint_create_rgba :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_paint_create_rgba');
    @plutovg_paint_create_color :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_paint_create_color');
    @plutovg_paint_create_linear_gradient :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_paint_create_linear_gradient');
    @plutovg_paint_create_radial_gradient :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_paint_create_radial_gradient');
    @plutovg_paint_create_texture :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_paint_create_texture');
    @plutovg_paint_reference := GetProcAddress(LibPlutovgHandle, 'plutovg_paint_reference');
    @plutovg_paint_destroy := GetProcAddress(LibPlutovgHandle, 'plutovg_paint_destroy');
    @plutovg_paint_get_reference_count :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_paint_get_reference_count');

    // Функции канваса
    @plutovg_canvas_create := GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_create');
    @plutovg_canvas_reference := GetProcAddress(LibPlutovgHandle,
      'plutovg_canvas_reference');
    @plutovg_canvas_destroy := GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_destroy');
    @plutovg_canvas_get_reference_count :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_get_reference_count');
    @plutovg_canvas_get_surface :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_get_surface');
    @plutovg_canvas_save := GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_save');
    @plutovg_canvas_restore := GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_restore');
    @plutovg_canvas_set_rgb := GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_set_rgb');
    @plutovg_canvas_set_rgba := GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_set_rgba');
    @plutovg_canvas_set_color := GetProcAddress(LibPlutovgHandle,
      'plutovg_canvas_set_color');
    @plutovg_canvas_set_linear_gradient :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_set_linear_gradient');
    @plutovg_canvas_set_radial_gradient :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_set_radial_gradient');
    @plutovg_canvas_set_texture :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_set_texture');
    @plutovg_canvas_set_paint := GetProcAddress(LibPlutovgHandle,
      'plutovg_canvas_set_paint');
    @plutovg_canvas_get_paint := GetProcAddress(LibPlutovgHandle,
      'plutovg_canvas_get_paint');
    @plutovg_canvas_set_font := GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_set_font');
    @plutovg_canvas_set_font_face :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_set_font_face');
    @plutovg_canvas_get_font_face :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_get_font_face');
    @plutovg_canvas_set_font_size :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_set_font_size');
    @plutovg_canvas_get_font_size :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_get_font_size');
    @plutovg_canvas_set_fill_rule :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_set_fill_rule');
    @plutovg_canvas_get_fill_rule :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_get_fill_rule');
    @plutovg_canvas_set_operator :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_set_operator');
    @plutovg_canvas_get_operator :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_get_operator');
    @plutovg_canvas_set_opacity :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_set_opacity');
    @plutovg_canvas_get_opacity :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_get_opacity');
    @plutovg_canvas_set_line_width :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_set_line_width');
    @plutovg_canvas_get_line_width :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_get_line_width');
    @plutovg_canvas_set_line_cap :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_set_line_cap');
    @plutovg_canvas_get_line_cap :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_get_line_cap');
    @plutovg_canvas_set_line_join :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_set_line_join');
    @plutovg_canvas_get_line_join :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_get_line_join');
    @plutovg_canvas_set_miter_limit :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_set_miter_limit');
    @plutovg_canvas_get_miter_limit :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_get_miter_limit');
    @plutovg_canvas_set_dash := GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_set_dash');
    @plutovg_canvas_set_dash_offset :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_set_dash_offset');
    @plutovg_canvas_get_dash_offset :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_get_dash_offset');
    @plutovg_canvas_set_dash_array :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_set_dash_array');
    @plutovg_canvas_get_dash_array :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_get_dash_array');
    @plutovg_canvas_translate := GetProcAddress(LibPlutovgHandle,
      'plutovg_canvas_translate');
    @plutovg_canvas_scale := GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_scale');
    @plutovg_canvas_shear := GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_shear');
    @plutovg_canvas_rotate := GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_rotate');
    @plutovg_canvas_transform := GetProcAddress(LibPlutovgHandle,
      'plutovg_canvas_transform');
    @plutovg_canvas_reset_matrix :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_reset_matrix');
    @plutovg_canvas_set_matrix :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_set_matrix');
    @plutovg_canvas_get_matrix :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_get_matrix');
    @plutovg_canvas_map := GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_map');
    @plutovg_canvas_map_point := GetProcAddress(LibPlutovgHandle,
      'plutovg_canvas_map_point');
    @plutovg_canvas_map_rect := GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_map_rect');
    @plutovg_canvas_move_to := GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_move_to');
    @plutovg_canvas_line_to := GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_line_to');
    @plutovg_canvas_quad_to := GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_quad_to');
    @plutovg_canvas_cubic_to := GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_cubic_to');
    @plutovg_canvas_arc_to := GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_arc_to');
    @plutovg_canvas_rect := GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_rect');
    @plutovg_canvas_round_rect :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_round_rect');
    @plutovg_canvas_ellipse := GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_ellipse');
    @plutovg_canvas_circle := GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_circle');
    @plutovg_canvas_arc := GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_arc');
    @plutovg_canvas_add_path := GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_add_path');
    @plutovg_canvas_new_path := GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_new_path');
    @plutovg_canvas_close_path :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_close_path');
    @plutovg_canvas_get_current_point :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_get_current_point');
    @plutovg_canvas_get_path := GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_get_path');
    @plutovg_canvas_fill_extents :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_fill_extents');
    @plutovg_canvas_stroke_extents :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_stroke_extents');
    @plutovg_canvas_clip_extents :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_clip_extents');
    @plutovg_canvas_fill := GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_fill');
    @plutovg_canvas_stroke := GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_stroke');
    @plutovg_canvas_clip := GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_clip');
    @plutovg_canvas_paint := GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_paint');
    @plutovg_canvas_fill_preserve :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_fill_preserve');
    @plutovg_canvas_stroke_preserve :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_stroke_preserve');
    @plutovg_canvas_clip_preserve :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_clip_preserve');
    @plutovg_canvas_fill_rect := GetProcAddress(LibPlutovgHandle,
      'plutovg_canvas_fill_rect');
    @plutovg_canvas_fill_path := GetProcAddress(LibPlutovgHandle,
      'plutovg_canvas_fill_path');
    @plutovg_canvas_stroke_rect :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_stroke_rect');
    @plutovg_canvas_stroke_path :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_stroke_path');
    @plutovg_canvas_clip_rect := GetProcAddress(LibPlutovgHandle,
      'plutovg_canvas_clip_rect');
    @plutovg_canvas_clip_path := GetProcAddress(LibPlutovgHandle,
      'plutovg_canvas_clip_path');
    @plutovg_canvas_add_glyph := GetProcAddress(LibPlutovgHandle,
      'plutovg_canvas_add_glyph');
    @plutovg_canvas_add_text := GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_add_text');
    @plutovg_canvas_fill_text := GetProcAddress(LibPlutovgHandle,
      'plutovg_canvas_fill_text');
    @plutovg_canvas_stroke_text :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_stroke_text');
    @plutovg_canvas_clip_text := GetProcAddress(LibPlutovgHandle,
      'plutovg_canvas_clip_text');
    @plutovg_canvas_font_metrics :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_font_metrics');
    @plutovg_canvas_glyph_metrics :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_glyph_metrics');
    @plutovg_canvas_text_extents :=
      GetProcAddress(LibPlutovgHandle, 'plutovg_canvas_text_extents');
  end;
end;

procedure FreePlutovg();
begin
  if LibPlutovgHandle > 0 then
    FreeLibrary(LibPlutovgHandle);
end;
{$ENDIF}

function PLUTOVG_DEG2RAD(x: single): single; {$IFNDEF DELPHI7}inline;
  {$ENDIF}
begin
  Result := x * (PLUTOVG_PI / 180.0);
end;

function PLUTOVG_RAD2DEG(x: single): single; {$IFNDEF DELPHI7}inline;
  {$ENDIF}
begin
  Result := x * (180.0 / PLUTOVG_PI);
end;

function PLUTOVG_MAKE_POINT(x, y: single): plutovg_point_t; {$IFNDEF DELPHI7}inline;
  {$ENDIF}
begin
  Result.x := x;
  Result.y := y;
end;

function PLUTOVG_MAKE_RECT(x, y, w, h: single): plutovg_rect_t; {$IFNDEF DELPHI7}inline;
  {$ENDIF}
begin
  Result.x := x;
  Result.y := y;
  Result.w := w;
  Result.h := h;
end;

function PLUTOVG_MAKE_MATRIX(a, b, c, d, e, f: single): plutovg_matrix_t;
  {$IFNDEF DELPHI7}inline;
  {$ENDIF}
begin
  Result.a := a;
  Result.b := b;
  Result.c := c;
  Result.d := d;
  Result.e := e;
  Result.f := f;
end;

function PLUTOVG_MAKE_SCALE(x, y: single): plutovg_matrix_t; {$IFNDEF DELPHI7}inline;
  {$ENDIF}
begin
  Result := PLUTOVG_MAKE_MATRIX(x, 0, 0, y, 0, 0);
end;

function PLUTOVG_MAKE_TRANSLATE(x, y: single): plutovg_matrix_t; {$IFNDEF DELPHI7}inline;
  {$ENDIF}
begin
  Result := PLUTOVG_MAKE_MATRIX(1, 0, 0, 1, x, y);
end;

function PLUTOVG_MAKE_COLOR(r, g, b, a: single): plutovg_color_t;
  {$IFNDEF DELPHI7}inline;
  {$ENDIF}
begin
  Result.r := r;
  Result.g := g;
  Result.b := b;
  Result.a := a;
end;
{$IFNDEF MSWINDOWS}
initialization
InitPlutovg(PLUTOVG_LIB);

finalization
FreePlutovg;
{$ENDIF}

end.

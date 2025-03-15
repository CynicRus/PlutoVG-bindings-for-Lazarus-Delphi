unit plutovg_api;

interface

{$IFDEF FPC}
  {$MODE DELPHI} // Устанавливаем режим совместимости с Delphi в Free Pascal
{$ENDIF}

{$DEFINE DELPHI7}

{$IFDEF VER150}
  {$DEFINE DELPHI7}
{$ELSE}
  {$UNDEF DELPHI7}
{$ENDIF}

uses
  SysUtils;

type
 // Точка в 2D-пространстве
  pplutovg_point_t = ^plutovg_point_t;
  plutovg_point_t = record
    x: Single;
    y: Single;
  end;

  // Прямоугольник в 2D-пространстве
  plutovg_rect_t = record
    x: Single;
    y: Single;
    w: Single;
    h: Single;
  end;

  // Матрица преобразования 2D
  plutovg_matrix_t = record
    a: Single;
    b: Single;
    c: Single;
    d: Single;
    e: Single;
    f: Single;
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
    case Integer of
      0: (header: record
            command: plutovg_path_command_t;
            length: Integer;
          end);
      1: (point: plutovg_point_t);
  end;
  Pplutovg_path_element_t = ^plutovg_path_element_t;

  // Итератор пути
  plutovg_path_iterator_t = record
    elements: Pplutovg_path_element_t;
    size: Integer;
    index: Integer;
  end;

  // Непрозрачный тип пути
  plutovg_path_t = ^plutovg_path;
  plutovg_path = record end;

  // Кодировки текста
  plutovg_text_encoding_t = (
    PLUTOVG_TEXT_ENCODING_LATIN1,
    PLUTOVG_TEXT_ENCODING_UTF8,
    PLUTOVG_TEXT_ENCODING_UTF16,
    PLUTOVG_TEXT_ENCODING_UTF32
  );

  // Итератор текста
  plutovg_text_iterator_t = record
    text: Pointer;
    length: Integer;
    encoding: plutovg_text_encoding_t;
    index: Integer;
  end;

  // Кодовая точка Unicode
  plutovg_codepoint_t = Cardinal;

  // Непрозрачный тип шрифта
  plutovg_font_face_t = ^plutovg_font_face;
  plutovg_font_face = record end;

  // Цвет
  plutovg_color_t = record
    r: Single;
    g: Single;
    b: Single;
    a: Single;
  end;

const
  // Определяем имя библиотеки в зависимости от платформы
  {$IFDEF MSWINDOWS}
    PLUTOVG_LIB = 'libplutovg.dll';
  {$ELSE}
    PLUTOVG_LIB = 'libplutovg.so';
  {$ENDIF}

  // Версионные константы
  PLUTOVG_VERSION_MAJOR = 1;
  PLUTOVG_VERSION_MINOR = 0;
  PLUTOVG_VERSION_MICRO = 0;
  CPLUTOVG_VERSION = (PLUTOVG_VERSION_MAJOR * 10000) + (PLUTOVG_VERSION_MINOR * 100) + (PLUTOVG_VERSION_MICRO * 1);
  CPLUTOVG_VERSION_STRING = '1.0.0';

  // Математические константы
  PLUTOVG_PI: Single = 3.14159265358979323846;
  PLUTOVG_TWO_PI: Single = 6.28318530717958647693;
  PLUTOVG_HALF_PI: Single = 1.57079632679489661923;
  PLUTOVG_SQRT2: Single = 1.41421356237309504880;
  PLUTOVG_KAPPA: Single = 0.55228474983079339840;

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
  PAnsiChar = ^AnsiChar;
  PSingle = ^Single;
  PUnsignedChar = ^Byte;

  // Непрозрачный тип поверхности
  plutovg_surface_t = ^plutovg_surface;
  plutovg_surface = record end;

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
    offset: Single;
    color: plutovg_color_t;
  end;
  Pplutovg_gradient_stop_t = ^plutovg_gradient_stop_t;

  // Непрозрачный тип краски
  plutovg_paint_t = ^plutovg_paint;
  plutovg_paint = record end;

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
  plutovg_canvas = record end;

  // Типы функций обратного вызова
  plutovg_destroy_func_t = procedure(closure: Pointer); cdecl;
  plutovg_write_func_t = procedure(closure: Pointer; data: Pointer; size: Integer); cdecl;
  plutovg_path_traverse_func_t = procedure(closure: Pointer; command: plutovg_path_command_t; points: Pplutovg_point_t; npoints: Integer); cdecl;

// Функции и процедуры библиотеки
function plutovg_version: Integer; cdecl; external PLUTOVG_LIB;
function plutovg_version_string: PAnsiChar; cdecl; external PLUTOVG_LIB;

// Функции преобразования градусов и радиан
function PLUTOVG_DEG2RAD(x: Single): Single; {$IFNDEF DELPHI7}inline;{$ENDIF}
function PLUTOVG_RAD2DEG(x: Single): Single; {$IFNDEF DELPHI7}inline;{$ENDIF}

// Функции создания структур
function PLUTOVG_MAKE_POINT(x, y: Single): plutovg_point_t; {$IFNDEF DELPHI7}inline;{$ENDIF}
function PLUTOVG_MAKE_RECT(x, y, w, h: Single): plutovg_rect_t; {$IFNDEF DELPHI7}inline;{$ENDIF}
function PLUTOVG_MAKE_MATRIX(a, b, c, d, e, f: Single): plutovg_matrix_t; {$IFNDEF DELPHI7}inline;{$ENDIF}
function PLUTOVG_MAKE_SCALE(x, y: Single): plutovg_matrix_t; {$IFNDEF DELPHI7}inline;{$ENDIF}
function PLUTOVG_MAKE_TRANSLATE(x, y: Single): plutovg_matrix_t; {$IFNDEF DELPHI7}inline;{$ENDIF}
function PLUTOVG_MAKE_COLOR(r, g, b, a: Single): plutovg_color_t; {$IFNDEF DELPHI7}inline;{$ENDIF}

// Матричные функции
procedure plutovg_matrix_init(var matrix: plutovg_matrix_t; a, b, c, d, e, f: Single); cdecl; external PLUTOVG_LIB;
procedure plutovg_matrix_init_identity(var matrix: plutovg_matrix_t); cdecl; external PLUTOVG_LIB;
procedure plutovg_matrix_init_translate(var matrix: plutovg_matrix_t; tx, ty: Single); cdecl; external PLUTOVG_LIB;
procedure plutovg_matrix_init_scale(var matrix: plutovg_matrix_t; sx, sy: Single); cdecl; external PLUTOVG_LIB;
procedure plutovg_matrix_init_rotate(var matrix: plutovg_matrix_t; angle: Single); cdecl; external PLUTOVG_LIB;
procedure plutovg_matrix_init_shear(var matrix: plutovg_matrix_t; shx, shy: Single); cdecl; external PLUTOVG_LIB;
procedure plutovg_matrix_translate(var matrix: plutovg_matrix_t; tx, ty: Single); cdecl; external PLUTOVG_LIB;
procedure plutovg_matrix_scale(var matrix: plutovg_matrix_t; sx, sy: Single); cdecl; external PLUTOVG_LIB;
procedure plutovg_matrix_rotate(var matrix: plutovg_matrix_t; angle: Single); cdecl; external PLUTOVG_LIB;
procedure plutovg_matrix_shear(var matrix: plutovg_matrix_t; shx, shy: Single); cdecl; external PLUTOVG_LIB;
procedure plutovg_matrix_multiply(var matrix: plutovg_matrix_t; const left, right: plutovg_matrix_t); cdecl; external PLUTOVG_LIB;
function plutovg_matrix_invert(const matrix: plutovg_matrix_t; var inverse: plutovg_matrix_t): Boolean; cdecl; external PLUTOVG_LIB;
procedure plutovg_matrix_map(const matrix: plutovg_matrix_t; x, y: Single; var xx, yy: Single); cdecl; external PLUTOVG_LIB;
procedure plutovg_matrix_map_point(const matrix: plutovg_matrix_t; const src: plutovg_point_t; var dst: plutovg_point_t); cdecl; external PLUTOVG_LIB;
procedure plutovg_matrix_map_points(const matrix: plutovg_matrix_t; const src: Pplutovg_point_t; dst: Pplutovg_point_t; count: Integer); cdecl; external PLUTOVG_LIB;
procedure plutovg_matrix_map_rect(const matrix: plutovg_matrix_t; const src: plutovg_rect_t; var dst: plutovg_rect_t); cdecl; external PLUTOVG_LIB;
function plutovg_matrix_parse(var matrix: plutovg_matrix_t; data: PAnsiChar; length: Integer): Boolean; cdecl; external PLUTOVG_LIB;

// Функции пути
function plutovg_path_create: plutovg_path_t; cdecl; external PLUTOVG_LIB;
function plutovg_path_reference(path: plutovg_path_t): plutovg_path_t; cdecl; external PLUTOVG_LIB;
procedure plutovg_path_destroy(path: plutovg_path_t); cdecl; external PLUTOVG_LIB;
function plutovg_path_get_reference_count(path: plutovg_path_t): Integer; cdecl; external PLUTOVG_LIB;
function plutovg_path_get_elements(path: plutovg_path_t; var elements: Pplutovg_path_element_t): Integer; cdecl; external PLUTOVG_LIB;
procedure plutovg_path_move_to(path: plutovg_path_t; x, y: Single); cdecl; external PLUTOVG_LIB;
procedure plutovg_path_line_to(path: plutovg_path_t; x, y: Single); cdecl; external PLUTOVG_LIB;
procedure plutovg_path_quad_to(path: plutovg_path_t; x1, y1, x2, y2: Single); cdecl; external PLUTOVG_LIB;
procedure plutovg_path_cubic_to(path: plutovg_path_t; x1, y1, x2, y2, x3, y3: Single); cdecl; external PLUTOVG_LIB;
procedure plutovg_path_arc_to(path: plutovg_path_t; rx, ry, angle: Single; large_arc_flag, sweep_flag: Boolean; x, y: Single); cdecl; external PLUTOVG_LIB;
procedure plutovg_path_close(path: plutovg_path_t); cdecl; external PLUTOVG_LIB;
procedure plutovg_path_get_current_point(path: plutovg_path_t; var x, y: Single); cdecl; external PLUTOVG_LIB;
procedure plutovg_path_reserve(path: plutovg_path_t; count: Integer); cdecl; external PLUTOVG_LIB;
procedure plutovg_path_reset(path: plutovg_path_t); cdecl; external PLUTOVG_LIB;
procedure plutovg_path_add_rect(path: plutovg_path_t; x, y, w, h: Single); cdecl; external PLUTOVG_LIB;
procedure plutovg_path_add_round_rect(path: plutovg_path_t; x, y, w, h, rx, ry: Single); cdecl; external PLUTOVG_LIB;
procedure plutovg_path_add_ellipse(path: plutovg_path_t; cx, cy, rx, ry: Single); cdecl; external PLUTOVG_LIB;
procedure plutovg_path_add_circle(path: plutovg_path_t; cx, cy, r: Single); cdecl; external PLUTOVG_LIB;
procedure plutovg_path_add_arc(path: plutovg_path_t; cx, cy, r, a0, a1: Single; ccw: Boolean); cdecl; external PLUTOVG_LIB;
procedure plutovg_path_add_path(path: plutovg_path_t; const source: plutovg_path_t; const matrix: plutovg_matrix_t); cdecl; external PLUTOVG_LIB;
procedure plutovg_path_transform(path: plutovg_path_t; const matrix: plutovg_matrix_t); cdecl; external PLUTOVG_LIB;
procedure plutovg_path_traverse(path: plutovg_path_t; traverse_func: plutovg_path_traverse_func_t; closure: Pointer); cdecl; external PLUTOVG_LIB;
procedure plutovg_path_traverse_flatten(path: plutovg_path_t; traverse_func: plutovg_path_traverse_func_t; closure: Pointer); cdecl; external PLUTOVG_LIB;
procedure plutovg_path_traverse_dashed(path: plutovg_path_t; offset: Single; dashes: PSingle; ndashes: Integer; traverse_func: plutovg_path_traverse_func_t; closure: Pointer); cdecl; external PLUTOVG_LIB;
function plutovg_path_clone(path: plutovg_path_t): plutovg_path_t; cdecl; external PLUTOVG_LIB;
function plutovg_path_clone_flatten(path: plutovg_path_t): plutovg_path_t; cdecl; external PLUTOVG_LIB;
function plutovg_path_clone_dashed(path: plutovg_path_t; offset: Single; dashes: PSingle; ndashes: Integer): plutovg_path_t; cdecl; external PLUTOVG_LIB;
function plutovg_path_extents(path: plutovg_path_t; var extents: plutovg_rect_t; tight: Boolean): Single; cdecl; external PLUTOVG_LIB;
function plutovg_path_length(path: plutovg_path_t): Single; cdecl; external PLUTOVG_LIB;
function plutovg_path_parse(path: plutovg_path_t; data: PAnsiChar; length: Integer): Boolean; cdecl; external PLUTOVG_LIB;

// Функции итератора пути
procedure plutovg_path_iterator_init(var it: plutovg_path_iterator_t; path: plutovg_path_t); cdecl; external PLUTOVG_LIB;
function plutovg_path_iterator_has_next(const it: plutovg_path_iterator_t): Boolean; cdecl; external PLUTOVG_LIB;
// Массив из 3 точек для следующей команды пути
type
  Tplutovg_point_array3 = array[0..2] of plutovg_point_t;
function plutovg_path_iterator_next(var it: plutovg_path_iterator_t; var points: Tplutovg_point_array3): plutovg_path_command_t; cdecl; external PLUTOVG_LIB;

// Функции итератора текста
procedure plutovg_text_iterator_init(var it: plutovg_text_iterator_t; text: Pointer; length: Integer; encoding: plutovg_text_encoding_t); cdecl; external PLUTOVG_LIB;
function plutovg_text_iterator_has_next(const it: plutovg_text_iterator_t): Boolean; cdecl; external PLUTOVG_LIB;
function plutovg_text_iterator_next(var it: plutovg_text_iterator_t): plutovg_codepoint_t; cdecl; external PLUTOVG_LIB;

// Функции шрифта
function plutovg_font_face_load_from_file(filename: PAnsiChar; ttcindex: Integer): plutovg_font_face_t; cdecl; external PLUTOVG_LIB;
function plutovg_font_face_load_from_data(data: Pointer; length: Cardinal; ttcindex: Integer; destroy_func: plutovg_destroy_func_t; closure: Pointer): plutovg_font_face_t; cdecl; external PLUTOVG_LIB;
function plutovg_font_face_reference(face: plutovg_font_face_t): plutovg_font_face_t; cdecl; external PLUTOVG_LIB;
procedure plutovg_font_face_destroy(face: plutovg_font_face_t); cdecl; external PLUTOVG_LIB;
function plutovg_font_face_get_reference_count(face: plutovg_font_face_t): Integer; cdecl; external PLUTOVG_LIB;
procedure plutovg_font_face_get_metrics(face: plutovg_font_face_t; size: Single; var ascent, descent, line_gap: Single; var extents: plutovg_rect_t); cdecl; external PLUTOVG_LIB;
procedure plutovg_font_face_get_glyph_metrics(face: plutovg_font_face_t; size: Single; codepoint: plutovg_codepoint_t; var advance_width, left_side_bearing: Single; var extents: plutovg_rect_t); cdecl; external PLUTOVG_LIB;
function plutovg_font_face_get_glyph_path(face: plutovg_font_face_t; size, x, y: Single; codepoint: plutovg_codepoint_t; path: plutovg_path_t): Single; cdecl; external PLUTOVG_LIB;
function plutovg_font_face_traverse_glyph_path(face: plutovg_font_face_t; size, x, y: Single; codepoint: plutovg_codepoint_t; traverse_func: plutovg_path_traverse_func_t; closure: Pointer): Single; cdecl; external PLUTOVG_LIB;
function plutovg_font_face_text_extents(face: plutovg_font_face_t; size: Single; text: Pointer; length: Integer; encoding: plutovg_text_encoding_t; var extents: plutovg_rect_t): Single; cdecl; external PLUTOVG_LIB;

// Функции цвета
procedure plutovg_color_init_rgb(var color: plutovg_color_t; r, g, b: Single); cdecl; external PLUTOVG_LIB;
procedure plutovg_color_init_rgba(var color: plutovg_color_t; r, g, b, a: Single); cdecl; external PLUTOVG_LIB;
procedure plutovg_color_init_rgb8(var color: plutovg_color_t; r, g, b: Integer); cdecl; external PLUTOVG_LIB;
procedure plutovg_color_init_rgba8(var color: plutovg_color_t; r, g, b, a: Integer); cdecl; external PLUTOVG_LIB;
procedure plutovg_color_init_rgba32(var color: plutovg_color_t; value: Cardinal); cdecl; external PLUTOVG_LIB;
procedure plutovg_color_init_argb32(var color: plutovg_color_t; value: Cardinal); cdecl; external PLUTOVG_LIB;
procedure plutovg_color_init_hsl(var color: plutovg_color_t; h, s, l: Single); cdecl; external PLUTOVG_LIB;
procedure plutovg_color_init_hsla(var color: plutovg_color_t; h, s, l, a: Single); cdecl; external PLUTOVG_LIB;
function plutovg_color_to_rgba32(const color: plutovg_color_t): Cardinal; cdecl; external PLUTOVG_LIB;
function plutovg_color_to_argb32(const color: plutovg_color_t): Cardinal; cdecl; external PLUTOVG_LIB;
function plutovg_color_parse(var color: plutovg_color_t; data: PAnsiChar; length: Integer): Integer; cdecl; external PLUTOVG_LIB;

// Функции поверхности
function plutovg_surface_create(width, height: Integer): plutovg_surface_t; cdecl; external PLUTOVG_LIB;
function plutovg_surface_create_for_data(data: PUnsignedChar; width, height, stride: Integer): plutovg_surface_t; cdecl; external PLUTOVG_LIB;
function plutovg_surface_load_from_image_file(filename: PAnsiChar): plutovg_surface_t; cdecl; external PLUTOVG_LIB;
function plutovg_surface_load_from_image_data(data: Pointer; length: Integer): plutovg_surface_t; cdecl; external PLUTOVG_LIB;
function plutovg_surface_load_from_image_base64(data: PAnsiChar; length: Integer): plutovg_surface_t; cdecl; external PLUTOVG_LIB;
function plutovg_surface_reference(surface: plutovg_surface_t): plutovg_surface_t; cdecl; external PLUTOVG_LIB;
procedure plutovg_surface_destroy(surface: plutovg_surface_t); cdecl; external PLUTOVG_LIB;
function plutovg_surface_get_reference_count(surface: plutovg_surface_t): Integer; cdecl; external PLUTOVG_LIB;
function plutovg_surface_get_data(surface: plutovg_surface_t): PUnsignedChar; cdecl; external PLUTOVG_LIB;
function plutovg_surface_get_width(surface: plutovg_surface_t): Integer; cdecl; external PLUTOVG_LIB;
function plutovg_surface_get_height(surface: plutovg_surface_t): Integer; cdecl; external PLUTOVG_LIB;
function plutovg_surface_get_stride(surface: plutovg_surface_t): Integer; cdecl; external PLUTOVG_LIB;
procedure plutovg_surface_clear(surface: plutovg_surface_t; const color: plutovg_color_t); cdecl; external PLUTOVG_LIB;
function plutovg_surface_write_to_png(surface: plutovg_surface_t; filename: PAnsiChar): Boolean; cdecl; external PLUTOVG_LIB;
function plutovg_surface_write_to_jpg(surface: plutovg_surface_t; filename: PAnsiChar; quality: Integer): Boolean; cdecl; external PLUTOVG_LIB;
function plutovg_surface_write_to_png_stream(surface: plutovg_surface_t; write_func: plutovg_write_func_t; closure: Pointer): Boolean; cdecl; external PLUTOVG_LIB;
function plutovg_surface_write_to_jpg_stream(surface: plutovg_surface_t; write_func: plutovg_write_func_t; closure: Pointer; quality: Integer): Boolean; cdecl; external PLUTOVG_LIB;
procedure plutovg_convert_argb_to_rgba(dst: PUnsignedChar; const src: PUnsignedChar; width, height, stride: Integer); cdecl; external PLUTOVG_LIB;
procedure plutovg_convert_rgba_to_argb(dst: PUnsignedChar; const src: PUnsignedChar; width, height, stride: Integer); cdecl; external PLUTOVG_LIB;

// Функции краски
function plutovg_paint_create_rgb(r, g, b: Single): plutovg_paint_t; cdecl; external PLUTOVG_LIB;
function plutovg_paint_create_rgba(r, g, b, a: Single): plutovg_paint_t; cdecl; external PLUTOVG_LIB;
function plutovg_paint_create_color(const color: plutovg_color_t): plutovg_paint_t; cdecl; external PLUTOVG_LIB;
function plutovg_paint_create_linear_gradient(x1, y1, x2, y2: Single; spread: plutovg_spread_method_t; stops: Pplutovg_gradient_stop_t; nstops: Integer; const matrix: plutovg_matrix_t): plutovg_paint_t; cdecl; external PLUTOVG_LIB;
function plutovg_paint_create_radial_gradient(cx, cy, cr, fx, fy, fr: Single; spread: plutovg_spread_method_t; stops: Pplutovg_gradient_stop_t; nstops: Integer; const matrix: plutovg_matrix_t): plutovg_paint_t; cdecl; external PLUTOVG_LIB;
function plutovg_paint_create_texture(surface: plutovg_surface_t; type_: plutovg_texture_type_t; opacity: Single; const matrix: plutovg_matrix_t): plutovg_paint_t; cdecl; external PLUTOVG_LIB;
function plutovg_paint_reference(paint: plutovg_paint_t): plutovg_paint_t; cdecl; external PLUTOVG_LIB;
procedure plutovg_paint_destroy(paint: plutovg_paint_t); cdecl; external PLUTOVG_LIB;
function plutovg_paint_get_reference_count(paint: plutovg_paint_t): Integer; cdecl; external PLUTOVG_LIB;

// Функции канваса
function plutovg_canvas_create(surface: plutovg_surface_t): plutovg_canvas_t; cdecl; external PLUTOVG_LIB;
function plutovg_canvas_reference(canvas: plutovg_canvas_t): plutovg_canvas_t; cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_destroy(canvas: plutovg_canvas_t); cdecl; external PLUTOVG_LIB;
function plutovg_canvas_get_reference_count(canvas: plutovg_canvas_t): Integer; cdecl; external PLUTOVG_LIB;
function plutovg_canvas_get_surface(canvas: plutovg_canvas_t): plutovg_surface_t; cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_save(canvas: plutovg_canvas_t); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_restore(canvas: plutovg_canvas_t); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_set_rgb(canvas: plutovg_canvas_t; r, g, b: Single); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_set_rgba(canvas: plutovg_canvas_t; r, g, b, a: Single); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_set_color(canvas: plutovg_canvas_t; const color: plutovg_color_t); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_set_linear_gradient(canvas: plutovg_canvas_t; x1, y1, x2, y2: Single; spread: plutovg_spread_method_t; stops: Pplutovg_gradient_stop_t; nstops: Integer; const matrix: plutovg_matrix_t); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_set_radial_gradient(canvas: plutovg_canvas_t; cx, cy, cr, fx, fy, fr: Single; spread: plutovg_spread_method_t; stops: Pplutovg_gradient_stop_t; nstops: Integer; const matrix: plutovg_matrix_t); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_set_texture(canvas: plutovg_canvas_t; surface: plutovg_surface_t; type_: plutovg_texture_type_t; opacity: Single; const matrix: plutovg_matrix_t); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_set_paint(canvas: plutovg_canvas_t; paint: plutovg_paint_t); cdecl; external PLUTOVG_LIB;
function plutovg_canvas_get_paint(canvas: plutovg_canvas_t; var color: plutovg_color_t): plutovg_paint_t; cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_set_font(canvas: plutovg_canvas_t; face: plutovg_font_face_t; size: Single); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_set_font_face(canvas: plutovg_canvas_t; face: plutovg_font_face_t); cdecl; external PLUTOVG_LIB;
function plutovg_canvas_get_font_face(canvas: plutovg_canvas_t): plutovg_font_face_t; cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_set_font_size(canvas: plutovg_canvas_t; size: Single); cdecl; external PLUTOVG_LIB;
function plutovg_canvas_get_font_size(canvas: plutovg_canvas_t): Single; cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_set_fill_rule(canvas: plutovg_canvas_t; winding: plutovg_fill_rule_t); cdecl; external PLUTOVG_LIB;
function plutovg_canvas_get_fill_rule(canvas: plutovg_canvas_t): plutovg_fill_rule_t; cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_set_operator(canvas: plutovg_canvas_t; op: plutovg_operator_t); cdecl; external PLUTOVG_LIB;
function plutovg_canvas_get_operator(canvas: plutovg_canvas_t): plutovg_operator_t; cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_set_opacity(canvas: plutovg_canvas_t; opacity: Single); cdecl; external PLUTOVG_LIB;
function plutovg_canvas_get_opacity(canvas: plutovg_canvas_t): Single; cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_set_line_width(canvas: plutovg_canvas_t; line_width: Single); cdecl; external PLUTOVG_LIB;
function plutovg_canvas_get_line_width(canvas: plutovg_canvas_t): Single; cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_set_line_cap(canvas: plutovg_canvas_t; line_cap: plutovg_line_cap_t); cdecl; external PLUTOVG_LIB;
function plutovg_canvas_get_line_cap(canvas: plutovg_canvas_t): plutovg_line_cap_t; cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_set_line_join(canvas: plutovg_canvas_t; line_join: plutovg_line_join_t); cdecl; external PLUTOVG_LIB;
function plutovg_canvas_get_line_join(canvas: plutovg_canvas_t): plutovg_line_join_t; cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_set_miter_limit(canvas: plutovg_canvas_t; miter_limit: Single); cdecl; external PLUTOVG_LIB;
function plutovg_canvas_get_miter_limit(canvas: plutovg_canvas_t): Single; cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_set_dash(canvas: plutovg_canvas_t; offset: Single; dashes: PSingle; ndashes: Integer); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_set_dash_offset(canvas: plutovg_canvas_t; offset: Single); cdecl; external PLUTOVG_LIB;
function plutovg_canvas_get_dash_offset(canvas: plutovg_canvas_t): Single; cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_set_dash_array(canvas: plutovg_canvas_t; dashes: PSingle; ndashes: Integer); cdecl; external PLUTOVG_LIB;
function plutovg_canvas_get_dash_array(canvas: plutovg_canvas_t; var dashes: PSingle): Integer; cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_translate(canvas: plutovg_canvas_t; tx, ty: Single); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_scale(canvas: plutovg_canvas_t; sx, sy: Single); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_shear(canvas: plutovg_canvas_t; shx, shy: Single); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_rotate(canvas: plutovg_canvas_t; angle: Single); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_transform(canvas: plutovg_canvas_t; const matrix: plutovg_matrix_t); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_reset_matrix(canvas: plutovg_canvas_t); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_set_matrix(canvas: plutovg_canvas_t; const matrix: plutovg_matrix_t); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_get_matrix(canvas: plutovg_canvas_t; var matrix: plutovg_matrix_t); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_map(canvas: plutovg_canvas_t; x, y: Single; var xx, yy: Single); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_map_point(canvas: plutovg_canvas_t; const src: plutovg_point_t; var dst: plutovg_point_t); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_map_rect(canvas: plutovg_canvas_t; const src: plutovg_rect_t; var dst: plutovg_rect_t); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_move_to(canvas: plutovg_canvas_t; x, y: Single); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_line_to(canvas: plutovg_canvas_t; x, y: Single); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_quad_to(canvas: plutovg_canvas_t; x1, y1, x2, y2: Single); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_cubic_to(canvas: plutovg_canvas_t; x1, y1, x2, y2, x3, y3: Single); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_arc_to(canvas: plutovg_canvas_t; rx, ry, angle: Single; large_arc_flag, sweep_flag: Boolean; x, y: Single); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_rect(canvas: plutovg_canvas_t; x, y, w, h: Single); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_round_rect(canvas: plutovg_canvas_t; x, y, w, h, rx, ry: Single); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_ellipse(canvas: plutovg_canvas_t; cx, cy, rx, ry: Single); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_circle(canvas: plutovg_canvas_t; cx, cy, r: Single); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_arc(canvas: plutovg_canvas_t; cx, cy, r, a0, a1: Single; ccw: Boolean); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_add_path(canvas: plutovg_canvas_t; path: plutovg_path_t); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_new_path(canvas: plutovg_canvas_t); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_close_path(canvas: plutovg_canvas_t); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_get_current_point(canvas: plutovg_canvas_t; var x, y: Single); cdecl; external PLUTOVG_LIB;
function plutovg_canvas_get_path(canvas: plutovg_canvas_t): plutovg_path_t; cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_fill_extents(canvas: plutovg_canvas_t; var extents: plutovg_rect_t); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_stroke_extents(canvas: plutovg_canvas_t; var extents: plutovg_rect_t); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_clip_extents(canvas: plutovg_canvas_t; var extents: plutovg_rect_t); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_fill(canvas: plutovg_canvas_t); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_stroke(canvas: plutovg_canvas_t); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_clip(canvas: plutovg_canvas_t); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_paint(canvas: plutovg_canvas_t); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_fill_preserve(canvas: plutovg_canvas_t); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_stroke_preserve(canvas: plutovg_canvas_t); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_clip_preserve(canvas: plutovg_canvas_t); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_fill_rect(canvas: plutovg_canvas_t; x, y, w, h: Single); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_fill_path(canvas: plutovg_canvas_t; path: plutovg_path_t); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_stroke_rect(canvas: plutovg_canvas_t; x, y, w, h: Single); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_stroke_path(canvas: plutovg_canvas_t; path: plutovg_path_t); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_clip_rect(canvas: plutovg_canvas_t; x, y, w, h: Single); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_clip_path(canvas: plutovg_canvas_t; path: plutovg_path_t); cdecl; external PLUTOVG_LIB;
function plutovg_canvas_add_glyph(canvas: plutovg_canvas_t; codepoint: plutovg_codepoint_t; x, y: Single): Single; cdecl; external PLUTOVG_LIB;
function plutovg_canvas_add_text(canvas: plutovg_canvas_t; text: Pointer; length: Integer; encoding: plutovg_text_encoding_t; x, y: Single): Single; cdecl; external PLUTOVG_LIB;
function plutovg_canvas_fill_text(canvas: plutovg_canvas_t; text: Pointer; length: Integer; encoding: plutovg_text_encoding_t; x, y: Single): Single; cdecl; external PLUTOVG_LIB;
function plutovg_canvas_stroke_text(canvas: plutovg_canvas_t; text: Pointer; length: Integer; encoding: plutovg_text_encoding_t; x, y: Single): Single; cdecl; external PLUTOVG_LIB;
function plutovg_canvas_clip_text(canvas: plutovg_canvas_t; text: Pointer; length: Integer; encoding: plutovg_text_encoding_t; x, y: Single): Single; cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_font_metrics(canvas: plutovg_canvas_t; var ascent, descent, line_gap: Single; var extents: plutovg_rect_t); cdecl; external PLUTOVG_LIB;
procedure plutovg_canvas_glyph_metrics(canvas: plutovg_canvas_t; codepoint: plutovg_codepoint_t; var advance_width, left_side_bearing: Single; var extents: plutovg_rect_t); cdecl; external PLUTOVG_LIB;
function plutovg_canvas_text_extents(canvas: plutovg_canvas_t; text: Pointer; length: Integer; encoding: plutovg_text_encoding_t; var extents: plutovg_rect_t): Single; cdecl; external PLUTOVG_LIB;

implementation

function PLUTOVG_DEG2RAD(x: Single): Single; {$IFNDEF DELPHI7}inline;{$ENDIF}
begin
  Result := x * (PLUTOVG_PI / 180.0);
end;

function PLUTOVG_RAD2DEG(x: Single): Single; {$IFNDEF DELPHI7}inline;{$ENDIF}
begin
  Result := x * (180.0 / PLUTOVG_PI);
end;

function PLUTOVG_MAKE_POINT(x, y: Single): plutovg_point_t; {$IFNDEF DELPHI7}inline;{$ENDIF}
begin
  Result.x := x;
  Result.y := y;
end;

function PLUTOVG_MAKE_RECT(x, y, w, h: Single): plutovg_rect_t; {$IFNDEF DELPHI7}inline;{$ENDIF}
begin
  Result.x := x;
  Result.y := y;
  Result.w := w;
  Result.h := h;
end;

function PLUTOVG_MAKE_MATRIX(a, b, c, d, e, f: Single): plutovg_matrix_t; {$IFNDEF DELPHI7}inline;{$ENDIF}
begin
  Result.a := a;
  Result.b := b;
  Result.c := c;
  Result.d := d;
  Result.e := e;
  Result.f := f;
end;

function PLUTOVG_MAKE_SCALE(x, y: Single): plutovg_matrix_t; {$IFNDEF DELPHI7}inline;{$ENDIF}
begin
  Result := PLUTOVG_MAKE_MATRIX(x, 0, 0, y, 0, 0);
end;

function PLUTOVG_MAKE_TRANSLATE(x, y: Single): plutovg_matrix_t; {$IFNDEF DELPHI7}inline;{$ENDIF}
begin
  Result := PLUTOVG_MAKE_MATRIX(1, 0, 0, 1, x, y);
end;

function PLUTOVG_MAKE_COLOR(r, g, b, a: Single): plutovg_color_t; {$IFNDEF DELPHI7}inline;{$ENDIF}
begin
  result.r:=r;
  result.g:=g;
  result.b:=b;
  result.a:=a;
end;

end.


unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, plutovg_api;

type
  TForm1 = class(TForm)
    PaintBox1: TPaintBox;
    procedure FormCreate(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
     FFont: plutovg_font_face_t;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

procedure SurfaceToImage(Surface: plutovg_surface_t; Image: TBitmap);
var
  Data: PByte;
  Width, Height, Stride: Integer;
  Row: Integer;
begin
  Width := plutovg_surface_get_width(Surface);
  Height := plutovg_surface_get_height(Surface);
  Stride := plutovg_surface_get_stride(Surface);
  Data := PByte(plutovg_surface_get_data(Surface));

  //Image.SetSize(Width, Height);
  Image.Width := Width;
  Image.Height := Height;
  Image.PixelFormat := pf32bit;

  for Row := 0 to Height - 1 do
  begin
    Move(Data^, Image.ScanLine[Row]^, Width * 4);
    Inc(Data, Stride);
  end;
end;

{$R *.dfm}



procedure TForm1.FormCreate(Sender: TObject);
var
 FontName: string;
begin
  Caption := 'PlutoVG Demo';
  ClientWidth := 800;
  ClientHeight := 600;
  Position := poScreenCenter;

  PaintBox1 := TPaintBox.Create(Self);
  PaintBox1.Parent := Self;
  PaintBox1.Align := alClient;
  PaintBox1.OnPaint := PaintBox1Paint;
  FontName := 'Bubble Sans.ttf';
  try
    FFont := plutovg_font_face_load_from_file(@FontName[1], 0);
    if FFont = nil then
      ShowMessage('Не удалось загрузить шрифт. Текст не будет отображаться.');
  except
    on E: Exception do
      ShowMessage('Ошибка загрузки шрифта: ' + E.Message);
  end;
end;

procedure TForm1.PaintBox1Paint(Sender: TObject);
const
  dashes: array[0..1] of Single = (10, 5);
var
  Surface: plutovg_surface_t;
  Canvas: plutovg_canvas_t;
  TempBitmap: TBitmap;
  Stops: array[0..1] of plutovg_gradient_stop_t;
  Matrix: plutovg_matrix_t;
  str1, str2: string;
begin
  // Создаем поверхность PlutoVG
  Surface := plutovg_surface_create(PaintBox1.Width, PaintBox1.Height);
  if Surface = nil then
  begin
    ShowMessage('Не удалось создать поверхность PlutoVG');
    Exit;
  end;

  // Создаем канвас
  Canvas := plutovg_canvas_create(Surface);
  if Canvas = nil then
  begin
    plutovg_surface_destroy(Surface);
    ShowMessage('Не удалось создать канвас PlutoVG');
    Exit;
  end;

  try
    // Заливаем фон белым цветом
    plutovg_surface_clear(Surface, PLUTOVG_WHITE_COLOR);

    // 1. Рисуем прямоугольник с заливкой красным цветом
    plutovg_canvas_save(Canvas);
    plutovg_canvas_set_color(Canvas, PLUTOVG_RED_COLOR);
    plutovg_canvas_fill_rect(Canvas, 50, 50, 100, 80);
    plutovg_canvas_restore(Canvas);

    // 2. Рисуем прямоугольник без заливки (только контур) синим цветом
    plutovg_canvas_save(Canvas);
    plutovg_canvas_set_color(Canvas, PLUTOVG_BLUE_COLOR);
    plutovg_canvas_set_line_width(Canvas, 2);
    plutovg_canvas_rect(Canvas, 200, 50, 100, 80);
    plutovg_canvas_stroke(Canvas);
    plutovg_canvas_restore(Canvas);

    // 3. Рисуем круг с зеленой заливкой
    plutovg_canvas_save(Canvas);
    plutovg_canvas_set_color(Canvas, PLUTOVG_GREEN_COLOR);
    plutovg_canvas_circle(Canvas, 100, 200, 40);
    plutovg_canvas_fill(Canvas);
    plutovg_canvas_restore(Canvas);

    // 4. Рисуем эллипс с контуром и без заливки
    plutovg_canvas_save(Canvas);
    plutovg_canvas_set_color(Canvas, PLUTOVG_MAKE_COLOR(0.5, 0, 0.5, 1)); // Фиолетовый
    plutovg_canvas_set_line_width(Canvas, 3);
    plutovg_canvas_ellipse(Canvas, 250, 200, 60, 40);
    plutovg_canvas_stroke(Canvas);
    plutovg_canvas_restore(Canvas);

    // 5. Создаем и рисуем путь произвольной формы (пятиугольник)
    plutovg_canvas_save(Canvas);
    plutovg_canvas_set_color(Canvas, PLUTOVG_MAKE_COLOR(1, 0.5, 0, 1)); // Оранжевый
    plutovg_canvas_move_to(Canvas, 400, 100);
    plutovg_canvas_line_to(Canvas, 450, 50);
    plutovg_canvas_line_to(Canvas, 500, 100);
    plutovg_canvas_line_to(Canvas, 480, 150);
    plutovg_canvas_line_to(Canvas, 420, 150);
    plutovg_canvas_close_path(Canvas);
    plutovg_canvas_fill(Canvas);
    plutovg_canvas_restore(Canvas);

    // 6. Рисуем скругленный прямоугольник с градиентной заливкой
    plutovg_canvas_save(Canvas);
    // Создаем линейный градиент
    Stops[0].offset := 0;
    Stops[0].color := PLUTOVG_MAKE_COLOR(0, 0, 1, 1); // Синий
    Stops[1].offset := 1;
    Stops[1].color := PLUTOVG_MAKE_COLOR(0, 1, 1, 1); // Голубой
    matrix := PLUTOVG_IDENTITY_MATRIX;
    plutovg_canvas_set_linear_gradient(Canvas, 350, 200, 550, 280,
                                      PLUTOVG_SPREAD_METHOD_PAD, @Stops[0], 2, matrix);
    plutovg_canvas_round_rect(Canvas, 350, 200, 200, 80, 15, 15);
    plutovg_canvas_fill(Canvas);
    plutovg_canvas_restore(Canvas);

    // 7. Рисуем дугу с контуром
    plutovg_canvas_save(Canvas);
    plutovg_canvas_set_color(Canvas, PLUTOVG_MAKE_COLOR(0.7, 0, 0, 1)); // Темно-красный
    plutovg_canvas_set_line_width(Canvas, 4);
    plutovg_canvas_arc(Canvas, 100, 350, 50, 0, PLUTOVG_PI, False);
    plutovg_canvas_stroke(Canvas);
    plutovg_canvas_restore(Canvas);

    // 8. Рисуем линию с пунктирным контуром
    plutovg_canvas_save(Canvas);
    plutovg_canvas_set_color(Canvas, PLUTOVG_BLACK_COLOR);
    plutovg_canvas_set_line_width(Canvas, 2);
    plutovg_canvas_set_dash(Canvas, 0, @dashes[0], 2);
    plutovg_canvas_move_to(Canvas, 200, 350);
    plutovg_canvas_line_to(Canvas, 350, 350);
    plutovg_canvas_stroke(Canvas);
    plutovg_canvas_restore(Canvas);

    // 9. Рисуем кривую Безье
    plutovg_canvas_save(Canvas);
    plutovg_canvas_set_color(Canvas, PLUTOVG_MAKE_COLOR(0, 0.5, 0, 1)); // Темно-зеленый
    plutovg_canvas_set_line_width(Canvas, 2);
    plutovg_canvas_move_to(Canvas, 400, 350);
    plutovg_canvas_cubic_to(Canvas, 450, 300, 500, 400, 550, 350);
    plutovg_canvas_stroke(Canvas);
    plutovg_canvas_restore(Canvas);

    // 10. Выводим текст, если шрифт загружен
    if FFont <> nil then
    begin
      plutovg_canvas_save(Canvas);
      plutovg_canvas_set_font(Canvas, FFont, 24);
      plutovg_canvas_set_color(Canvas, PLUTOVG_BLACK_COLOR);
      str1 := 'PlutoVG Demo';
      plutovg_canvas_fill_text(Canvas, @str1[1], -1, PLUTOVG_TEXT_ENCODING_UTF8, 50, 500);

      // Второй текст с другим цветом и размером
      plutovg_canvas_set_font_size(Canvas, 18);
      plutovg_canvas_set_color(Canvas, PLUTOVG_MAKE_COLOR(0.5, 0, 0.5, 1)); // Фиолетовый
      str2 := 'Graphics primitives';
      plutovg_canvas_fill_text(Canvas, @str2[1], -1, PLUTOVG_TEXT_ENCODING_UTF8, 50, 530);
      plutovg_canvas_restore(Canvas);
    end;

    // Отрисовываем результат на PaintBox
    TempBitmap := TBitmap.Create;
    try
      SurfaceToImage(Surface, TempBitmap);
      PaintBox1.Canvas.Draw(0, 0, TempBitmap);
    finally
      TempBitmap.Free;
    end;

  finally
    plutovg_canvas_destroy(Canvas);
    plutovg_surface_destroy(Surface);
  end;

end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  if FFont <> nil then
    plutovg_font_face_destroy(FFont); 
end;

end.

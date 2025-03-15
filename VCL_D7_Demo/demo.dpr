program demo;

uses
  Forms,
  main in 'main.pas' {Form1},
  plutovg_api in '..\src\plutovg_api.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

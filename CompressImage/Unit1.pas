unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    Image1: TImage;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Image2: TImage;
    OpenDialog1: TOpenDialog;
    Memo1: TMemo;
    Label1: TLabel;
    Memo2: TMemo;
    Label2: TLabel;
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Memo2Change(Sender: TObject);
    procedure Image2Click(Sender: TObject);
  private
    { Private declarations }
    compress: Boolean;
    function StreamToBase64(Value: TMemoryStream): string;
    function Base64ToStream(Value: String): TBytesStream;
    function CompactStream(Value: TMemoryStream): TMemoryStream;
    function UnpackStram(Value: TMemoryStream): TMemoryStream;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  System.ZLib, Vcl.AxCtrls, IdCoderMIME;

{$R *.dfm}

function TForm1.Base64ToStream(Value: String): TBytesStream;
var
  dm: TIdDecoderMIME;
begin
  Result := TBytesStream.Create;
  dm := TIdDecoderMIME.Create(nil);
  try
    dm.DecodeBegin(Result);
    dm.Decode(Value);
    dm.DecodeEnd;
    Result.Position := 0;
  finally
    dm.Free;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  ms: TMemoryStream;
  og: TOleGraphic;
begin
  if OpenDialog1.Execute then
  begin
    ms := TMemoryStream.Create;
    try
      og := TOleGraphic.Create;
      try
        ms.LoadFromFile(OpenDialog1.FileName);
        ms.Position := 0;
        og.LoadFromStream(ms);
        Image1.Picture.Assign(og);
      finally
        og.Free;
      end;
    finally
      ms.Free;
    end;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  ms: TMemoryStream;
begin
  compress := False;
  if Image1.Picture.Graphic <> nil then
  begin
    ms := TMemoryStream.Create;
    try
      Image1.Picture.Graphic.SaveToStream(ms);
      ms.Position := 0;
      Memo1.Text := StreamToBase64(ms);
    finally
      ms.Free;
    end;
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  ms1, ms2: TMemoryStream;
begin
  compress := True;
  if Image1.Picture.Graphic <> nil then
  begin
    ms1 := TMemoryStream.Create;
    try
      Image1.Picture.Graphic.SaveToStream(ms1);
      ms1.Position := 0;
      ms2 := CompactStream(ms1);
      try
        Memo2.Text := StreamToBase64(ms2);
      finally
        ms2.Free;
      end;
    finally
      ms1.Free;
    end;
  end;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  bs: TBytesStream;
  dm: TIdDecoderMIME;
  og: TOleGraphic;

  LInput, LOutput: TMemoryStream;
  LUnZip: TZDecompressionStream;
begin
  if not compress then
  begin
    og := TOleGraphic.Create;
    try
      bs := Base64ToStream(Memo1.Text);
      try
        bs.Position := 0;
        og.LoadFromStream(bs);
        Image2.Picture.Assign(og);
      finally
        bs.Free;
      end;
    finally
      og.Free;
    end;
  end
  else
  begin
    bs := Base64ToStream(Memo2.Text);
    try
      bs.Position := 0;
      LOutput := UnpackStram(bs);
      try
        og := TOleGraphic.Create;
        try
          og.LoadFromStream(LOutput);
          Image2.Picture.Assign(og);
        finally
          og.Free;
        end;
      finally
        LOutput.Free;
      end;
    finally
      bs.Free;
    end;
  end;
end;

function TForm1.CompactStream(Value: TMemoryStream): TMemoryStream;
var
  LZip: TZCompressionStream;
begin
  Result := TMemoryStream.Create;
  LZip := TZCompressionStream.Create(Result, zcMax, 15);
  try
    Value.Position := 0;
    { Compress data. }
    LZip.CopyFrom(Value, Value.Size);
  finally
    LZip.Free;
  end;
  Result.Position := 0;
end;

procedure TForm1.Image2Click(Sender: TObject);
begin
  Image2.Picture.Graphic := nil;
end;

procedure TForm1.Memo1Change(Sender: TObject);
begin
  Label1.Caption := 'Tamanho: ' + IntToStr(Length(Memo1.Text));
end;

procedure TForm1.Memo2Change(Sender: TObject);
begin
  Label2.Caption := 'Tamanho: ' + IntToStr(Length(Memo2.Text));
end;

function TForm1.StreamToBase64(Value: TMemoryStream): string;
begin
  Result := '';
  if Value <> nil then
    Result := TIdEncoderMIME.EncodeStream(Value, Value.Size);
end;

function TForm1.UnpackStram(Value: TMemoryStream): TMemoryStream;
var
  LUnZip: TZDecompressionStream;
begin
  Value.Position := 0;
  Result := TMemoryStream.Create;
  LUnZip := TZDecompressionStream.Create(Value);
  try
    { Decompress data. }
    Result.CopyFrom(LUnZip, 0);
    Result.Position := 0;
  finally
    LUnZip.Free;
  end;
end;

end.

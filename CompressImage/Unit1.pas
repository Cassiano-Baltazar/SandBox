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
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
    compress: Boolean;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  System.ZLib, Vcl.AxCtrls, IdCoderMIME;

{$R *.dfm}

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
      Memo1.Text := TIdEncoderMIME.EncodeStream(ms, ms.Size);
    finally
      ms.Free;
    end;
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  LInput: TMemoryStream;
  LOutput: TMemoryStream;
  LOutput2: TFileStream;
  LZip: TZCompressionStream;
begin
  compress := True;
  if Image1.Picture.Graphic <> nil then
  begin
    { Create the Input, Output, and Compressed streams. }
    LInput := TMemoryStream.Create;
    try
      Image1.Picture.Graphic.SaveToStream(LInput);
      LInput.Position := 0;
      LOutput := TMemoryStream.Create;
      try
        LOutput2 := TFileStream.Create('C:\Dype\text.zip', fmCreate);
        try
          LZip := TZCompressionStream.Create(clMax, LOutput2);
          try
            { Compress data. }
            LZip.CopyFrom(LInput, LInput.Size);
          finally
            LZip.Free;
          end;
        finally
          LOutput2.Free;
        end;
        LOutput.LoadFromFile('C:\Dype\text.zip');
        Memo1.Text := TIdEncoderMIME.EncodeStream(LOutput, LOutput.Size);
        DeleteFile('C:\Dype\text.zip');
      finally
        LOutput.Free;
      end;
    finally
      LInput.Free;
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
      bs := TBytesStream.Create;
      try
        dm := TIdDecoderMIME.Create(nil);
        try
          dm.DecodeBegin(bs);
          dm.Decode(Memo1.Text);
          dm.DecodeEnd;
          bs.Position := 0;
          og.LoadFromStream(bs);
          Image2.Picture.Assign(og);
        finally
          dm.Free;
        end;
      finally
        bs.Free;
      end;
    finally
      og.Free;
    end;
  end
  else
  begin
    bs := TBytesStream.Create;
    try
      dm := TIdDecoderMIME.Create(nil);
      try
        dm.DecodeBegin(bs);
        dm.Decode(Memo1.Text);
        dm.DecodeEnd;
        bs.Position := 0;
        LOutput := TMemoryStream.Create;
        try
          LUnZip := TZDecompressionStream.Create(bs);
          try
            { Decompress data. }
            LOutput.CopyFrom(LUnZip, 0);
            LOutput.Position := 0;
            og := TOleGraphic.Create;
            try
              og.LoadFromStream(LOutput);
              Image2.Picture.Assign(og);
            finally
              og.Free;
            end;
          finally
            LUnZip.Free;
          end;
        finally
          LOutput.Free;
        end;
      finally
        dm.Free;
      end;
    finally
      bs.Free;
    end;
  end;
end;

procedure TForm1.Memo1Change(Sender: TObject);
begin
  Label1.Caption := 'Tamanho: ' + IntToStr(Length(Memo1.Text));
end;

end.

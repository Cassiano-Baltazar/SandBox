object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 525
  ClientWidth = 381
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 8
    Top = 8
    Width = 125
    Height = 150
  end
  object Image2: TImage
    Left = 251
    Top = 8
    Width = 125
    Height = 150
    OnClick = Image2Click
  end
  object Label1: TLabel
    Left = 139
    Top = 148
    Width = 51
    Height = 13
    Caption = 'Tamanho: '
  end
  object Label2: TLabel
    Left = 8
    Top = 343
    Width = 51
    Height = 13
    Caption = 'Tamanho: '
  end
  object Button1: TButton
    Left = 139
    Top = 8
    Width = 106
    Height = 25
    Caption = 'Load'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 139
    Top = 39
    Width = 106
    Height = 25
    Caption = 'Convert to base64'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 139
    Top = 70
    Width = 106
    Height = 25
    Caption = 'Compress'
    TabOrder = 2
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 139
    Top = 101
    Width = 106
    Height = 25
    Caption = 'Open to image'
    TabOrder = 3
    OnClick = Button4Click
  end
  object Memo1: TMemo
    Left = 8
    Top = 164
    Width = 368
    Height = 173
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssBoth
    TabOrder = 4
    OnChange = Memo1Change
  end
  object Memo2: TMemo
    Left = 8
    Top = 359
    Width = 365
    Height = 158
    Lines.Strings = (
      'Memo2')
    TabOrder = 5
    OnChange = Memo2Change
  end
  object OpenDialog1: TOpenDialog
    Filter = 'jpg|*.jpg;*.gif'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 56
    Top = 36
  end
end

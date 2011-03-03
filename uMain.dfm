object fMain: TfMain
  Left = 0
  Top = 0
  Caption = 'YAJL Test'
  ClientHeight = 328
  ClientWidth = 430
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  DesignSize = (
    430
    328)
  PixelsPerInch = 96
  TextHeight = 13
  object btnLoad: TButton
    Left = 336
    Top = 8
    Width = 88
    Height = 25
    Caption = 'Load'
    TabOrder = 0
    OnClick = btnLoadClick
  end
  object mOutput: TMemo
    Left = 8
    Top = 39
    Width = 322
    Height = 282
    Anchors = [akLeft, akTop, akBottom]
    TabOrder = 9
  end
  object btnAlloc: TButton
    Left = 336
    Top = 56
    Width = 88
    Height = 25
    Caption = 'AllocParser'
    TabOrder = 1
    OnClick = btnAllocClick
  end
  object btnFreeParser: TButton
    Left = 336
    Top = 149
    Width = 88
    Height = 25
    Caption = 'FreeParser'
    TabOrder = 4
    OnClick = btnFreeParserClick
  end
  object btnParse: TButton
    Left = 336
    Top = 87
    Width = 88
    Height = 25
    Caption = 'Parse'
    TabOrder = 2
    OnClick = btnParseClick
  end
  object eInput: TEdit
    Left = 8
    Top = 8
    Width = 322
    Height = 21
    TabOrder = 10
    Text = '{"Name" : "Nas","Rep" : "QB","Age" : 35}'
  end
  object btnFinParse: TButton
    Left = 336
    Top = 118
    Width = 88
    Height = 25
    Caption = 'Finished Parse'
    TabOrder = 3
    OnClick = btnFinParseClick
  end
  object btnAllocGen: TButton
    Left = 336
    Top = 200
    Width = 86
    Height = 25
    Caption = 'AllocGen'
    TabOrder = 5
    OnClick = btnAllocGenClick
  end
  object btnBuildObj: TButton
    Left = 336
    Top = 231
    Width = 86
    Height = 25
    Caption = 'Build Obj'
    TabOrder = 6
    OnClick = btnBuildObjClick
  end
  object btnGetBuf: TButton
    Left = 336
    Top = 262
    Width = 86
    Height = 25
    Caption = 'GetBuf'
    TabOrder = 7
    OnClick = btnGetBufClick
  end
  object btnFreeGen: TButton
    Left = 336
    Top = 293
    Width = 86
    Height = 25
    Caption = 'Free Gen'
    TabOrder = 8
    OnClick = btnFreeGenClick
  end
end

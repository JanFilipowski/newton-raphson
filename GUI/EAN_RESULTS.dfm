object frmEANResults: TfrmEANResults
  Left = 100
  Top = 100
  BorderStyle = bsDialog
  Caption = 'Wyniki'
  ClientHeight = 125
  ClientWidth = 625
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 13
  object lbl1: TLabel
    Left = 15
    Top = 37
    Width = 105
    Height = 13
    Caption = 'Pierwiastek r'#243'wnania:'
  end
  object lbl2: TLabel
    Left = 15
    Top = 64
    Width = 78
    Height = 13
    Caption = 'Warto'#347#263' funkcji:'
  end
  object lbl3: TLabel
    Left = 15
    Top = 91
    Width = 104
    Height = 13
    Caption = 'Szeroko'#347#263' przedzia'#322'u:'
  end
  object static_lbstatus: TLabel
    Left = 15
    Top = 14
    Width = 38
    Height = 13
    Caption = 'Status: '
  end
  object lbst: TLabel
    Left = 60
    Top = 14
    Width = 12
    Height = 13
    Caption = '-1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object static_lbit: TLabel
    Left = 121
    Top = 14
    Width = 71
    Height = 13
    Caption = 'Liczba iteracji: '
  end
  object lbit: TLabel
    Left = 198
    Top = 14
    Width = 12
    Height = 13
    Caption = '-1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object edt1: TEdit
    Left = 137
    Top = 34
    Width = 396
    Height = 21
    ReadOnly = True
    TabOrder = 0
  end
  object btn1: TButton
    Left = 539
    Top = 34
    Width = 75
    Height = 21
    Caption = 'Kopiuj'
    TabOrder = 1
    OnClick = btn1Click
  end
  object edt2: TEdit
    Left = 137
    Top = 61
    Width = 396
    Height = 21
    ReadOnly = True
    TabOrder = 2
  end
  object btn2: TButton
    Left = 539
    Top = 61
    Width = 75
    Height = 21
    Caption = 'Kopiuj'
    TabOrder = 3
    OnClick = btn2Click
  end
  object edt3: TEdit
    Left = 137
    Top = 88
    Width = 396
    Height = 21
    ReadOnly = True
    TabOrder = 4
  end
  object btn3: TButton
    Left = 539
    Top = 88
    Width = 75
    Height = 21
    Caption = 'Kopiuj'
    TabOrder = 5
    OnClick = btn3Click
  end
end

object DataModule1: TDataModule1
  OldCreateOrder = False
  Left = 192
  Top = 152
  Height = 150
  Width = 215
  object ZConnection: TZConnection
    ControlsCodePage = cGET_ACP
    AutoEncodeStrings = False
    HostName = 'localhost'
    Port = 3306
    Database = 'penjualan'
    User = 'root'
    Protocol = 'mysql'
    LibraryLocation = 
      'D:\Kuliah\SEMESTER IV\VISUAL\TUGAS UAS VISUAL\M.Haldi 2210010283' +
      '_Tugas UAS\libmysql.dll'
    Left = 16
    Top = 40
  end
  object Zkustomer: TZQuery
    Connection = ZConnection
    SQL.Strings = (
      'select * from kustomer')
    Params = <>
    Left = 80
    Top = 40
  end
  object dskustomer: TDataSource
    DataSet = Zkustomer
    Left = 136
    Top = 40
  end
end

unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, DB;

type
  TForm2 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    ComboBox1: TComboBox;
    Edit6: TEdit;
    DBGrid1: TDBGrid;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure Edit6Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure posisiawal;
    procedure bersih;
    procedure DisableComboBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;
  a: string;

implementation

uses
  Unit1, Unit3;

{$R *.dfm}

procedure TForm2.FormCreate(Sender: TObject);
begin
  // Mengatur lebar kolom secara manual
  DBGrid1.Columns[0].Width := 25;  // Kolom id
  DBGrid1.Columns[1].Width := 70;  // Kolom NIK
  DBGrid1.Columns[2].Width := 82; // Kolom Nama
  DBGrid1.Columns[3].Width := 150; // Kolom Telp
  DBGrid1.Columns[4].Width := 100; // Kolom Email
  DBGrid1.Columns[5].Width := 100; // Kolom Alamat
  DBGrid1.Columns[6].Width := 40;  // Kolom Member

  // Koneksi ke database
  try
    DataModule1.ZConnection.Connect;
  except
    on E: Exception do
      ShowMessage('Gagal terhubung ke database: ' + E.Message);
  end;

  // Aktifkan ZQuery
  DataModule1.Zkustomer.Active := True;
  DBGrid1.DataSource := DataModule1.dskustomer; // Hubungkan DBGrid1 dengan DataSource

  posisiawal;
  Edit6.Enabled := True; // Aktifkan Edit6
end;

procedure TForm2.posisiawal;
begin
  bersih;
  Button1.Enabled := True;
  Button2.Enabled := False;
  Button3.Enabled := False;
  Button4.Enabled := False;
  Button5.Enabled := False;
  Edit1.Enabled := False;
  Edit2.Enabled := False;
  Edit3.Enabled := False;
  Edit4.Enabled := False;
  Edit5.Enabled := False;
  DisableComboBox;
  Edit6.Enabled := True; // Pastikan Edit6 selalu aktif
end;

procedure TForm2.bersih;
begin
  Edit1.Clear;
  Edit2.Clear;
  Edit3.Clear;
  Edit4.Clear;
  Edit5.Clear;
  DisableComboBox;
end;

procedure TForm2.DisableComboBox;
begin
  ComboBox1.ItemIndex := -1; // Reset ComboBox
  ComboBox1.Text := 'PILIH--'; // Reset text ComboBox
  ComboBox1.Enabled := False;
  Label9.Caption := 'TERISI OTOMATIS'; // Reset Label9 caption
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
  Edit1.Enabled := True;
  Edit2.Enabled := True;
  Edit3.Enabled := True;
  Edit4.Enabled := True;
  Edit5.Enabled := True;
  ComboBox1.Enabled := True;
  Button2.Enabled := True;
  Button5.Enabled := True;
  Button1.Enabled := False;
  Edit1.SetFocus; // Pindahkan fokus ke Edit1
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
  if Edit1.Text = '' then
  begin
    ShowMessage('NIK Tidak Boleh Kosong!');
  end
  else if DataModule1.Zkustomer.Locate('nik', Edit1.Text, []) then
  begin
    ShowMessage('NIK ' + Edit1.Text + ' Sudah Ada Didalam Sistem');
  end
  else
  begin
    try
      with DataModule1.Zkustomer do
      begin
        SQL.Clear;
        SQL.Add('INSERT INTO kustomer (nik, nama, telp, email, alamat, member) VALUES (:nik, :nama, :telp, :email, :alamat, :member)');
        ParamByName('nik').AsString := Edit1.Text;
        ParamByName('nama').AsString := Edit2.Text;
        ParamByName('telp').AsString := Edit3.Text;
        ParamByName('email').AsString := Edit4.Text;
        ParamByName('alamat').AsString := Edit5.Text;
        ParamByName('member').AsString := ComboBox1.Text;
        ExecSQL;
        SQL.Clear;
        SQL.Add('SELECT * FROM kustomer');
        Open;
      end;
      ShowMessage('Data Berhasil Disimpan!');
      // Refresh DBGrid untuk menampilkan data yang baru
      DataModule1.Zkustomer.Refresh;
      posisiawal;
    except
      on E: Exception do
        ShowMessage('Gagal menyimpan data: ' + E.Message);
    end;
  end;
end;

procedure TForm2.Button3Click(Sender: TObject);
begin
  if Edit1.Text = '' then
  begin
    ShowMessage('NIK Tidak Boleh Kosong!');
  end
  else
  begin
    try
      with DataModule1.Zkustomer do
      begin
        SQL.Clear;
        SQL.Add('UPDATE kustomer SET nik=:nik, nama=:nama, telp=:telp, email=:email, alamat=:alamat, member=:member WHERE id=:id');
        ParamByName('nik').AsString := Edit1.Text;
        ParamByName('nama').AsString := Edit2.Text;
        ParamByName('telp').AsString := Edit3.Text;
        ParamByName('email').AsString := Edit4.Text;
        ParamByName('alamat').AsString := Edit5.Text;
        ParamByName('member').AsString := ComboBox1.Text;
        ParamByName('id').AsString := a;
        ExecSQL;
        SQL.Clear;
        SQL.Add('SELECT * FROM kustomer');
        Open;
      end;
      ShowMessage('Data Berhasil Diupdate!');
      posisiawal;
    except
      on E: Exception do
        ShowMessage('Gagal mengupdate data: ' + E.Message);
    end;
  end;
end;

procedure TForm2.Button4Click(Sender: TObject);
begin
  if MessageDlg('Apakah Anda Yakin Menghapus Data ini', mtWarning, [mbYes, mbNo], 0) = mrYes then
  begin
    try
      with DataModule1.Zkustomer do
      begin
        SQL.Clear;
        SQL.Add('DELETE FROM kustomer WHERE id=:id');
        ParamByName('id').AsString := a;
        ExecSQL;
        SQL.Clear;
        SQL.Add('SELECT * FROM kustomer');
        Open;
      end;
      ShowMessage('Data Berhasil Dihapus!');
      posisiawal;
    except
      on E: Exception do
        ShowMessage('Gagal menghapus data: ' + E.Message);
    end;
  end
  else
  begin
    ShowMessage('Data Batal Dihapus!');
  end;
end;

procedure TForm2.Button5Click(Sender: TObject);
begin
  posisiawal;
end;

procedure TForm2.Button6Click(Sender: TObject);
begin
    Form3.frxReport.ShowReport();
end;

procedure TForm2.DBGrid1CellClick(Column: TColumn);
begin
  Edit1.Text := DataModule1.Zkustomer.FieldByName('nik').AsString;
  Edit2.Text := DataModule1.Zkustomer.FieldByName('nama').AsString;
  Edit3.Text := DataModule1.Zkustomer.FieldByName('telp').AsString;
  Edit4.Text := DataModule1.Zkustomer.FieldByName('email').AsString;
  Edit5.Text := DataModule1.Zkustomer.FieldByName('alamat').AsString;
  ComboBox1.Text := DataModule1.Zkustomer.FieldByName('member').AsString;
  a := DataModule1.Zkustomer.FieldByName('id').AsString;

  Edit1.Enabled := True;
  Edit2.Enabled := True;
  Edit3.Enabled := True;
  Edit4.Enabled := True;
  Edit5.Enabled := True;
  ComboBox1.Enabled := True;
  Button3.Enabled := True;
  Button4.Enabled := True;
  Button5.Enabled := True;
  Button1.Enabled := False;
  Button2.Enabled := False;
end;

procedure TForm2.Edit6Change(Sender: TObject);
begin
  with DataModule1.Zkustomer do
  begin
    SQL.Clear;
    SQL.Add('SELECT * FROM kustomer WHERE nama LIKE "%' + Edit6.Text + '%"');
    Open;
  end;
end;

procedure TForm2.ComboBox1Change(Sender: TObject);
begin
  if ComboBox1.Text = 'YES' then
  begin
    Label9.Caption := '10%';
  end
  else if ComboBox1.Text = 'NO' then
  begin
    Label9.Caption := '5%';
  end
  else
  begin
    Label9.Caption := ''; // Kosongkan jika nilai bukan "YES" atau "NO"
  end;
end;

end.


unit uModel.Principal;

interface

uses
  System.SysUtils, System.Classes, System.IniFiles, Vcl.Forms,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.VCLUI.Wait,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteDef, FireDAC.Phys.SQLite,
  FireDAC.Comp.UI, Data.DB, FireDAC.Comp.Client;

type
  TdmPrincipal = class(TDataModule)
    cnnConexao: TFDConnection;
    FDGUIxWaitCursor: TFDGUIxWaitCursor;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
  private

    { Private declarations }
  public
    { Public declarations }

    class function Log(txt: String): Boolean; static;
    class function LogPlacas(txt: String): Boolean; static;

  end;


Var
  dmPrincipal   : TdmPrincipal;
  fbase         : string;

implementation


{$R *.dfm}

//Lanca Log em txt lancamentos das Placas
{$region 'Arquivo de Log em txt'}
class function TdmPrincipal.Log(txt:String):Boolean;
var
  f   : TextFile;
  Arq : string;
begin
  Arq := ExtractFilePath(ParamStr(0)) + 'log.txt'; //txt na raiz do .exe

  AssignFile(f, Arq);
  Append(f);
  Writeln(f, txt);
  Flush(f);
  CloseFile(f);
end;
{$endregion}

//Lanca Log em txt Confronto em tabelas Veiculos (api antiga) vs Placas (api atual)
{$region 'Arquivo de Log em txt'}
class function TdmPrincipal.LogPlacas(txt:String):Boolean;
var
  f   : TextFile;
  Arq : string;
begin
  Arq := ExtractFilePath(ParamStr(0)) + 'logplacas.txt';  //txt na raiz do .exe

  AssignFile(f, Arq);
  Append(f);
  Writeln(f, txt);
  Flush(f);
  CloseFile(f);
end;
{$endregion}

end.

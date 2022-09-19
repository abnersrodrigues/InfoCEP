unit uService.Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.SvcMgr,
  Vcl.Dialogs, System.JSON

  //Uses Aplicação
  , uController.Rotas, uController.Provider

  // Componentes
  , Horse, Horse.Jhonson, Horse.Compression, Horse.HandleException, Horse.BasicAuthentication
  , Horse.Query, DataSet.Serialize, Horse.Logger, Horse.Logger.Provider.Console


  ;

type
  TInfoCepAPI = class(TService)

    procedure ServiceDestroy(Sender: TObject);
    procedure ServiceCreate(Sender: TObject);
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
  private
    { Private declarations }
  public
    Provider : TControllerProvider;
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;

var
  InfoCepAPI: TInfoCepAPI;

implementation

{$R *.dfm}

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  InfoCepAPI.Controller(CtrlCode);
end;

procedure TInfoCepAPI.ServiceDestroy(Sender: TObject);
begin
  Provider.free;
end;

procedure TInfoCepAPI.ServiceCreate(Sender: TObject);
begin
  Provider := TControllerProvider.Create;
  Provider.Inicializar;
end;

function TInfoCepAPI.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TInfoCepAPI.ServiceStart(Sender: TService; var Started: Boolean);
begin
  //THorse.Listen(9009);
  Started := True;
end;

procedure TInfoCepAPI.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
  THorse.StopListen;
  Stopped := True;
end;

end.

unit uController.Rotas;

interface

uses
  System.SysUtils, System.Classes, System.JSON, System.Generics.Collections

  // Componentes
  , Horse, Horse.Jhonson, Horse.Compression, Horse.HandleException, Horse.BasicAuthentication
  , DataSet.Serialize, RESTRequest4D, uInterfaces.Principal;

type
  TControllerRotas = class(TInterfacedObject, iRotas)

    private

    public

      constructor Create;
      destructor Destroy; override;
      class function New: iRotas;

      function Registry: iRotas;

  end;

implementation

uses
  uController.Gets;

{ TControllerRotas }


{$region 'Rota API'}
constructor TControllerRotas.Create;
begin

end;

destructor TControllerRotas.Destroy;
begin

  inherited;
end;

class function TControllerRotas.New: iRotas;
begin
  Result := Self.Create;
end;

function TControllerRotas.Registry: iRotas;
begin
  THorse.Get('/get/datetime', TControllerGets.GetDate);
  THorse.Get('/get/:cep', TControllerGets.GetAPIExterna);
  THorse.Get('/get/all', TControllerGets.GetAll);
end;
{$endregion}

end.

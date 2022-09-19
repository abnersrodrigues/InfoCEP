unit uController.Provider;

interface

Uses
  System.SysUtils, System.Classes, System.JSON, System.Generics.Collections

  //Uses Aplicação
  , uController.Rotas

  // Componentes
  , Horse, Horse.Jhonson, Horse.Compression, Horse.HandleException, Horse.BasicAuthentication
  , Horse.Query, DataSet.Serialize, Horse.Logger, Horse.Logger.Provider.Console

  ;

type
  TControllerProvider = class

    private

    Public

      class procedure Inicializar; static;

  End;

implementation

class procedure TControllerProvider.Inicializar;
Begin
  THorse
    .Use(Compression())
    .Use(Jhonson)
    .Use(Query)
    .Use(HorseBasicAuthentication(
     function(const AUsername, APassword: string): Boolean
     begin
       Result := AUsername.Equals('infocep') and APassword.Equals('info@2022');
     end));

  TControllerRotas.New.Registry;

  THorse.Listen(7000);
End;

end.

unit uGUID;

interface

  function getNewOne(): string;
  function getLastOne(): string;

implementation

uses
  System.SysUtils, System.SyncObjs;

var
  criticalSection: TCriticalSection;
  lastGUID: string;

{ TGRVGUID }

function getLastOne(): string;
begin
  criticalSection.Enter();
  try
    result := lastGUID;
  finally
    criticalSection.Leave();
  end;
end;

function getNewOne(): string;
const
   cstChaveGuid : string = '0123456789ABCDEFGHIJKLMNOPQRSTUVXZ';
var
   xNumero  : Int64;
   xPosicao : integer;
   xAux     : string;
begin
  criticalSection.Enter();
  try
    Result := EmptyStr;
    xNumero := Trunc(((Now - 41000) * 1000000000));
    while xNumero > 34 do
    begin
      xPosicao := xNumero mod 34;
      xNumero  := Trunc(xNumero/34);
      xAux     := cstChaveGuid[xPosicao+1];
      Result   := xAux + Result;
    end;
    xPosicao := xNumero;
    xAux     := cstChaveGuid[xPosicao+1];
    Result   := xAux + Result;
    //Sempre adiciono o random pois ao se usar várias threads
    //exporadicamente acontece erro de chave primária
    while (Length(Result) < 15) do
    begin
      Result := Result + cstChaveGuid[Random(34)+1];
    end;
    //Evita que se repita o guid gerado
    //##TODO Evita mesmo???
    if Result.Equals(lastGUID) then
    begin
      Result := lastGUID;
    end;
    lastGUID := Result;
  finally
    criticalSection.Leave();
  end;
end;

initialization
  criticalSection := TCriticalSection.Create();

finalization
  criticalSection.Free();

end.


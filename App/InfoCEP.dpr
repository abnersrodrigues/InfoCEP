program InfoCEP;

uses
  System.StartUpCopy,
  FMX.Forms,
  ufrmPrincipal in 'src\ufrmPrincipal.pas' {frmPrincipal},
  uLoading in 'src\uLoading.pas',
  uFancyDialog in 'src\uFancyDialog.pas',
  uFormat in 'src\uFormat.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.

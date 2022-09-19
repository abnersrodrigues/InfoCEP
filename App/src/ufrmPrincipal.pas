unit ufrmPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts, FMX.Edit,
  FMX.ListBox, FMX.TabControl, RESTRequest4D, System.Actions, FMX.ActnList,
  System.JSON, REST.Json, uLoading,
  uFancyDialog, Winapi.Windows, FMX.Memo.Types, FMX.ScrollBox, FMX.Memo,
  FMX.DialogService, FireDAC.Stan.StorageBin, uFormat;

type
  TfrmPrincipal = class(TForm)
    lay_header: TLayout;
    lay_body: TLayout;
    lay_foother: TLayout;
    Rectangle1: TRectangle;
    Label1: TLabel;
    Rectangle2: TRectangle;
    Label2: TLabel;
    lay_pesquisa: TLayout;
    lay_list: TLayout;
    edt_pesquisa: TEdit;
    btn_buscar: TSearchEditButton;
    list: TListBox;
    StyleBook: TStyleBook;
    Rectangle3: TRectangle;
    btn_robozinho: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure btn_buscarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure listItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure edt_pesquisaKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure edt_pesquisaTyping(Sender: TObject);
  private

    function Mask(Mascara, Str: string): string;

    { Private declarations }
  public
    { Public declarations }

    ListBoxItem   : TListBoxItem;
    fancy         : TFancyDialog;
    Process       : Boolean;

    function BuscarCEP: Boolean;

  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.fmx}


procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  fancy := TFancyDialog.Create(Self);
end;

procedure TfrmPrincipal.listItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
  TDialogService.ShowMessage('CEP Selecionado: '+#13+Item.TagString);
end;

function TfrmPrincipal.BuscarCEP:Boolean;
begin
  TLoading.Show(frmPrincipal, 'Consultando CEP');
  TThread.CreateAnonymousThread(procedure
  var
    Resp          : IResponse;
    json, sCEP    : string;
    jsonObj       : TJSONObject;
  Begin
    Sleep(500);

    if Process = true then exit;

    sCEP := edt_pesquisa.Text;
    sCEP := StringReplace(sCEP, '-', '', [rfReplaceAll]);
    sCEP := StringReplace(sCEP, '.', '', [rfReplaceAll]);

    Process := true;
    Resp := TRequest.New.BaseURL('http://localhost:7000/get/'+ trim(sCEP))
            .BasicAuthentication('infocep', 'info@2022')
            .Accept('application/json')
            .Get;

    json      := Resp.Content;
    jsonObj   := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json), 0) as TJSONObject;

    TThread.Synchronize(nil, procedure
    Begin
      if Resp.StatusCode = 200 then
        Begin
          if Resp.Content.IndexOf('erro') = 400 then
            Begin
              ShowMessage('CEP Inv�lido');
              exit;
            End
          else
          if Resp.Content.IndexOf('erro') = 404 then
            Begin
              ShowMessage('CEP N�o Encontrado');
              exit;
            End;

          list.Items.Clear;
          list.BeginUpdate;

          ListBoxItem := TListBoxItem.Create(List);
          ListBoxItem.Parent := List;
          ListBoxItem.StyleLookup := 'StyleItem';
          ListBoxItem.Height := 95;

          ListBoxItem.TagString                   := jsonObj.GetValue('cep').Value;

          ListBoxItem.StylesData['lbl_cep']       := Mask('##.###-###', jsonObj.GetValue('cep').Value);
          ListBoxItem.StylesData['lbl_tipo']      := 'Tipo: '+ jsonObj.GetValue('addressType').Value;
          ListBoxItem.StylesData['lbl_endereco']  := 'Endere�o: '+ jsonObj.GetValue('addressName').Value;
          ListBoxItem.StylesData['lbl_bairro']    := 'Bairro: '+ jsonObj.GetValue('district').Value;
          ListBoxItem.StylesData['lbl_cidade']    := 'Cidade: '+ jsonObj.GetValue('city').Value;
          ListBoxItem.StylesData['lbl_uf']        := 'UF: '+ jsonObj.GetValue('state').Value;

          List.AddObject(ListBoxItem);

          list.EndUpdate;
        End;


      TLoading.Hide;
      Process := false;
    End);
  end).Start;
End;

procedure TfrmPrincipal.edt_pesquisaKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if Key = VK_RETURN then btn_buscarClick(Self);
end;

function TfrmPrincipal.Mask(Mascara, Str : string) : string;
var
    x, p : integer;
begin
    p := 0;
    Result := '';

    if Str.IsEmpty then
        exit;

    for x := 0 to Length(Mascara) - 1 do
    begin
        if Mascara.Chars[x] = '#' then
        begin
            Result := Result + Str.Chars[p];
            inc(p);
        end
        else
            Result := Result + Mascara.Chars[x];

        if p = Length(Str) then
            break;
    end;
end;

procedure TfrmPrincipal.edt_pesquisaTyping(Sender: TObject);
begin
  Formatar(edt_pesquisa, TFormato.CEP);
end;

procedure TfrmPrincipal.btn_buscarClick(Sender: TObject);
begin
  list.Items.Clear;

  if edt_pesquisa.text = '' then
    Begin
      ShowMessage('Digite um CEP');
      Exit;
    End;

  BuscarCEP;
end;

procedure TfrmPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  fancy.DisposeOf;

  Action := TCloseAction.caFree;
  frmPrincipal := nil;
end;

end.

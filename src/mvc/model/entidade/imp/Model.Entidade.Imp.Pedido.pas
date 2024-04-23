{*******************************************************}
{                    API PDV - JSON                     }
{                      Be More Web                      }
{          In�cio do projeto 22/04/2024 12:08           }
{                 www.bemoreweb.com.br                  }
{                     (17)98169-5336                    }
{                        2003/2024                      }
{         Analista desenvolvedor (Eleandro Silva)       }
{*******************************************************}
unit Model.Entidade.Imp.Pedido;

interface

uses
  Model.Entidade.Pedido.Interfaces,
  Model.Entidade.Pessoa.Interfaces;

type
  TEntidadePedido <T : iInterface> = class(TInterfacedObject, iEntidadePedido<T>)
    private
      [weak]
      FParent              : T;
      FId                  : Integer;
      FIdEmpresa           : Integer;
      FIdPessoa            : Integer;
      FIdPagamento         : Integer;
      FIdUsuario           : Integer;
      FValorProduto        : Currency;
      FValorDesconto       : Currency;
      FValorReceber        : Currency;
      FDataHoraEmissao     : TDateTime;
      FStatus              : Integer;

      FPessoa  : iEntidadePessoa<iEntidadePedido<T>>;
    public
      constructor Create(Parent : T);
      destructor Destroy; override;
      class function New(Parent : T) : iEntidadePedido<T>;

      function Id             (Value : Integer)   : iEntidadePedido<T>; overload;
      function Id                                 : Integer;            overload;
      function IdEmpresa      (Value : Integer)   : iEntidadePedido<T>; overload;
      function IdEmpresa                          : Integer;            overload;
      function IdPessoa       (Value : Integer)   : iEntidadePedido<T>; overload;
      function IdPessoa                           : Integer;            overload;
      function IdPagamento    (Value : Integer)   : iEntidadePedido<T>; overload;
      function IdPagamento                        : Integer;            overload;
      function IdUsuario      (Value : Integer)   : iEntidadePedido<T>; overload;
      function IdUsuario                          : Integer;            overload;
      function ValorProduto   (Value : Currency)  : iEntidadePedido<T>; overload;
      function ValorProduto                       : Currency;           overload;
      function ValorDesconto  (Value : Currency)  : iEntidadePedido<T>; overload;
      function ValorDesconto                      : Currency;           overload;
      function ValorReceber   (Value : Currency)  : iEntidadePedido<T>; overload;
      function ValorReceber                       : Currency;           overload;
      function DataHoraEmissao(Value : TDateTime) : iEntidadePedido<T>; overload;
      function DataHoraEmissao                    : TDateTime;          overload;
      function Status         (Value : Integer)   : iEntidadePedido<T>; overload;
      function Status                             : Integer;            overload;

      //Inje��o de depend�ncia
      function Pessoa  : iEntidadePessoa<iEntidadePedido<T>>;

      function &End : T;
  end;

implementation

uses
  Model.Entidade.Imp.Pessoa;

{ TEntidadePedido<T> }

constructor TEntidadePedido<T>.Create(Parent: T);
begin
  FParent  := Parent;
  FPessoa := TEntidadePessoa<iEntidadePedido<T>>.New(Self);
end;

destructor TEntidadePedido<T>.Destroy;
begin
  inherited;
end;

class function TEntidadePedido<T>.New(Parent: T): iEntidadePedido<T>;
begin
  Result := Self.Create(Parent);
end;

function TEntidadePedido<T>.Pessoa: iEntidadePessoa<iEntidadePedido<T>>;
begin
  Result := FPessoa;
end;

function TEntidadePedido<T>.Id(Value: Integer): iEntidadePedido<T>;
begin
  Result := Self;
  FId    := Value;
end;

function TEntidadePedido<T>.Id: Integer;
begin
  Result := FId;
end;

function TEntidadePedido<T>.IdEmpresa(Value: Integer): iEntidadePedido<T>;
begin
  Result := Self;
  FIdEmpresa := Value;
end;

function TEntidadePedido<T>.IdEmpresa: Integer;
begin
  Result := FIdEmpresa;
end;

function TEntidadePedido<T>.IdPessoa(Value: Integer): iEntidadePedido<T>;
begin
  Result := Self;
  FIdPessoa := Value;
end;

function TEntidadePedido<T>.IdPessoa: Integer;
begin
  Result := FIdPessoa;
end;

function TEntidadePedido<T>.IdPagamento(Value: Integer): iEntidadePedido<T>;
begin
  Result := Self;
  FIdPagamento := Value;
end;

function TEntidadePedido<T>.IdPagamento: Integer;
begin
  Result := FIdPagamento;
end;

function TEntidadePedido<T>.IdUsuario(Value: Integer): iEntidadePedido<T>;
begin
  Result := Self;
  FIdUsuario := Value;
end;

function TEntidadePedido<T>.IdUsuario: Integer;
begin
  Result := FIdUsuario;
end;

function TEntidadePedido<T>.ValorProduto(Value: Currency): iEntidadePedido<T>;
begin
  Result := Self;
  FValorProduto := Value;
end;

function TEntidadePedido<T>.ValorProduto: Currency;
begin
  Result := FValorProduto;
end;

function TEntidadePedido<T>.ValorDesconto(Value: Currency): iEntidadePedido<T>;
begin
  Result := Self;
  FValorDesconto := Value;
end;

function TEntidadePedido<T>.ValorDesconto: Currency;
begin
  Result := FValorDesconto;
end;

function TEntidadePedido<T>.ValorReceber(Value: Currency): iEntidadePedido<T>;
begin
  Result := Self;
  FValorReceber := Value;
end;

function TEntidadePedido<T>.ValorReceber: Currency;
begin
  Result := FValorReceber;
end;

function TEntidadePedido<T>.DataHoraEmissao(Value: TDateTime): iEntidadePedido<T>;
begin
  Result := Self;
  FDataHoraEmissao := Value;
end;

function TEntidadePedido<T>.DataHoraEmissao: TDateTime;
begin
  Result := FDataHoraEmissao;
end;

function TEntidadePedido<T>.Status(Value: Integer): iEntidadePedido<T>;
begin
  Result := Self;
  FStatus := Value;
end;

function TEntidadePedido<T>.Status: Integer;
begin
  Result := FStatus;
end;

function TEntidadePedido<T>.&End: T;
begin
  Result := FParent;
end;


end.

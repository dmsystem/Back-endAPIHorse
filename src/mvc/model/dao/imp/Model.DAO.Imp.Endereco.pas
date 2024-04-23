unit Model.DAO.Imp.Endereco;

interface

uses
  System.SysUtils,
  System.JSON,
  Data.DB,

  Uteis,
  Uteis.Interfaces,
  Uteis.Tratar.Mensagens,

  Model.DAO.Endereco.Interfaces,
  Model.Entidade.Endereco.Interfaces,
  Model.Conexao.Firedac.Interfaces,
  Model.Conexao.Query.Interfaces;

type
  TDAOEndereco = class(TInterfacedObject, iDAOEndereco)
    private
      FEndereco : iEntidadeEndereco<iDAOEndereco>;
      FConexao  : iConexao;
      FQuery    : iQuery;
      FUteis    : iUteis;
      FMSG      : TMensagens;
      FDataSet  : TDataSet;

      FKey     : String;
      FValue   : String;
    const
      FSQL=('select '+
            'ed.id, '+
            'ed.cep, '+
            'ed.tipologradouro, '+
            'ed.logradouro, '+
            'n.numeroendereco, '+
            'ed.Bairro, '+
            'ed.ibge, '+
            'm.municipio, '+
            'ed.gia, '+
            'ed.ddd '+
            'from endereco ed '+
            'inner join numero    n on n.idendereco = ed.id '+
            'inner join municipio m on m.ibge       = m.ibge '
            );

      procedure FiltroKey;
      function  FiltroValue(Value : String) : String;
      function LoopRegistro (Value : Integer): Integer;
    public
      constructor Create;
      destructor Destroy; override;
      class function New : iDAOEndereco;

      function DataSet(DataSource : TDataSource) : iDAOEndereco; overload;
      function DataSet                           : TDataSet;     overload;
      function GetAll                            : iDAOEndereco;
      function GetbyId(Id : Variant)             : iDAOEndereco;
      function GetbyParams                       : iDAOEndereco; overload;
      function GetbyParams(aCep : String)        : iDAOEndereco; overload;
      function Post                              : iDAOEndereco;
      function Put                               : iDAOEndereco;
      function Delete                            : iDAOEndereco;
      function QuantidadeRegistro                : Integer;

      function This : iEntidadeEndereco<iDAOEndereco>;
  end;

implementation

uses
  Model.Entidade.Imp.Endereco,
  Model.Conexao.Firedac.MySQL.Imp,
  Model.Conexao.Query.Imp;

{ TDAOEndereco }

constructor TDAOEndereco.Create;
begin
  FEndereco := TEntidadeEndereco<iDAOEndereco>.New(Self);
  FConexao  := TModelConexaoFiredacMySQL.New;
  FQuery    := TQuery.New;
  FUteis    := TUteis.New;
  FMSG      := TMensagens.Create;
end;

destructor TDAOEndereco.Destroy;
begin
  FreeAndNil(FMSG);
  inherited;
end;

procedure TDAOEndereco.FiltroKey;
begin
  if FEndereco.Cep                 <>'' then FKey := 'cep';
  if FEndereco.Logradouro          <>'' then FKey := 'logradouro';
  if FEndereco.Municipio.Municipio <>'' then FKey := 'municipio';
  if FEndereco.UF                  <>'' then FKey := 'uf';

  FValue := FiltroValue(FKey);
end;

function TDAOEndereco.FiltroValue(Value: String): String;
begin
  Result := '';
  if Value ='cep' then
    result := FEndereco.Cep else result := FEndereco.Logradouro;
end;

class function TDAOEndereco.New: iDAOEndereco;
begin
  Result := Self.Create;
end;

function TDAOEndereco.DataSet(DataSource: TDataSource): iDAOEndereco;
begin
  Result := Self;
  if not Assigned(FDataset) then
    DataSource.DataSet := FQuery.DataSet
  else
    DataSource.DataSet := FDataSet;
end;

function TDAOEndereco.DataSet: TDataSet;
begin
  Result := FDataSet;
end;

function TDAOEndereco.GetAll: iDAOEndereco;
begin
  Result := Self;
  try
    try
      FDataSet := FQuery
                    .SQL(FSQL)
                    .Open
                  .DataSet;

    except
      on E: Exception do
      begin
        FConexao.Rollback;
        raise Exception.Create(FMSG.MSGerroGet+E.Message);
      end;
    end;
  finally
    if not FDataSet.IsEmpty then
    begin
      FEndereco.Id(FDataSet.FieldByName('id').AsInteger);
      QuantidadeRegistro;
    end
    else
      FEndereco.Id(0);
  end;
end;

function TDAOEndereco.GetbyId(Id: Variant): iDAOEndereco;
begin
  Result := Self;
  try
    try
      FDataSet := FQuery
                    .SQL(FSQL)
                    .Add('where ed.id=:id')
                    .Params('id', Id)
                    .Open
                  .DataSet;
    except
      on E: Exception do
      begin
        FConexao.Rollback;
        raise Exception.Create(FMSG.MSGerroGet+E.Message);
      end;
    end;
  finally
    if not FDataSet.IsEmpty then
      FEndereco.Id(FDataSet.FieldByName('id').AsInteger)
    else
      FEndereco.Id(0);
  end;
end;

function TDAOEndereco.GetbyParams(aCep: String): iDAOEndereco;
begin
  Result := Self;
  aCep := FUteis.PegarApenasNumero(aCep);
  try
   try
     FDataSet := FQuery
                   .SQL(FSQL)
                   .Add('where ed.cep=cep')
                   .Params('cep', aCep)
                   .Open
                 .DataSet;
   except
      on E: Exception do
      begin
        FConexao.Rollback;
        raise Exception.Create(FMSG.MSGerroGet+E.Message);
      end;
    end;
  finally
    if not FDataSet.IsEmpty then
    begin
      FEndereco.Id(FDataSet.FieldByName('id').AsInteger);
      QuantidadeRegistro;
    end
    else
      FEndereco.Id(0);
  end;
end;

function TDAOEndereco.GetbyParams: iDAOEndereco;
begin
  Result := Self;
  FiltroKey;
  try
   try
     FDataSet := FQuery
                   .SQL(FSQL+' where ' + FUteis.Pesquisar(FKey, ';' + FValue))
                   .Open
                 .DataSet;
   except
      on E: Exception do
      begin
        FConexao.Rollback;
        raise Exception.Create(FMSG.MSGerroGet+E.Message);
      end;
    end;
  finally
    if not FDataSet.IsEmpty then
    begin
      FEndereco.Id(FDataSet.FieldByName('id').AsInteger);
      QuantidadeRegistro;
    end
    else
      FEndereco.Id(0);
  end;
end;

function TDAOEndereco.Post: iDAOEndereco;
const
  LSQL=('insert into endereco( '+
                              'cep, '+
                              'tipologradouro, '+
                              'logradouro, '+
                              'bairro, '+
                              'ibge, '+
                              'uf, '+
                              'gia, '+
                              'ddd '+
                            ')'+
                              ' values '+
                            '('+
                              ':cep, '+
                              ':tipologradouro, '+
                              ':logradouro, '+
                              ':bairro, ' +
                              ':ibge, '+
                              ':uf, '+
                              ':gia, '+
                              ':ddd '+
                             ') '
       );
begin
  Result := Self;

  FConexao.StartTransaction;
  try
    try
      FQuery
        .SQL(LSQL)
          .Params('cep'            , FEndereco.Cep)
          .Params('tipologradouro' , FEndereco.TipoLogradouro)
          .Params('logradouro'     , FEndereco.Logradouro)
          .Params('bairro'         , FEndereco.Bairro)
          .Params('ibge'           , FEndereco.IBGE)
          .Params('uf'             , FEndereco.UF)
          .Params('gia'            , FEndereco.GIA)
          .Params('ddd'            , FEndereco.DDD)
        .ExecSQL;

    except
      on E: Exception do
      begin
        FConexao.Rollback;
        raise Exception.Create(FMSG.MSGerroPost+E.Message);
      end;
    end;
  finally
    FConexao.Commit;
    FDataSet := FQuery
                    .SQL('select LAST_INSERT_ID () as id ')
                    .Open
                    .DataSet;
    FEndereco.Id(FDataSet.FieldByName('id').AsInteger);
  end;
end;

function TDAOEndereco.Put: iDAOEndereco;
const
  LSQL=('update endereco set '+
                        'id            =:id, '+
                        'cep           =:cep, '+
                        'gia           =:gia, '+
                        'ddd           =:ddd, '+
                        'tipologradouro=:tipologradouro, '+
                        'logradouro    =:logradouro, '+
                        'bairro        =:bairro, '+
                        'ibge          =:ibge, '+
                        'uf            =:uf, '+
                        'gia           =:gia, '+
                        'ddd           =:ddd '+
                        'where id      =:id '
       );
begin
  Result := Self;

  FConexao.StartTransaction;
  try
    try
      FQuery
        .SQL(LSQL)
          .Params('id'             , FEndereco.Id)
          .Params('cep'            , FEndereco.Cep)
          .Params('tipologradouro' , FEndereco.TipoLogradouro)
          .Params('logradouro'     , FEndereco.Logradouro)
          .Params('bairro'         , FEndereco.Bairro)
          .Params('ibge'           , FEndereco.IBGE)
          .Params('uf'             , FEndereco.UF)
          .Params('gia'            , FEndereco.GIA)
          .Params('ddd'            , FEndereco.DDD)
        .ExecSQL;
    except
      on E: Exception do
      begin
        FConexao.Rollback;
        raise Exception.Create(FMSG.MSGerroPut+E.Message);
      end;
    end;
  finally
    FConexao.Commit;
  end;
end;

function TDAOEndereco.Delete: iDAOEndereco;
const
  LSQL=('delete from endereco where id=:id ');
begin
  Result := self;
  FConexao.StartTransaction;
  try
    try
      FQuery.SQL(LSQL)
               .Params('id', FEndereco.Id)
            .ExecSQL;
    except
      on E: Exception do
      begin
        FConexao.Rollback;
        raise Exception.Create(FMSG.MSGerroDelete+E.Message);
      end;
    end;
  finally
    FConexao.Commit;
  end;
end;

function TDAOEndereco.LoopRegistro(Value : Integer): Integer;
begin
  FDataSet.First;
  try
    while not FDataSet.Eof do
    begin
      Value := Value + 1;
      FDataSet.Next;
    end;
  finally
    Result := Value;
  end;
end;

function TDAOEndereco.QuantidadeRegistro : Integer;
begin
  Result := LoopRegistro(0);
end;

function TDAOEndereco.This: iEntidadeEndereco<iDAOEndereco>;
begin
  Result := FEndereco;
end;

end.


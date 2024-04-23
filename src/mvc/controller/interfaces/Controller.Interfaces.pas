{*******************************************************}
{                    API PDV - JSON                     }
{                      Be More Web                      }
{          In�cio do projeto 13/03/2024 10:26           }
{                 www.bemoreweb.com.br                  }
{                     (17)98169-5336                    }
{                        2003/2024                      }
{         Analista desenvolvedor (Eleandro Silva)       }
{*******************************************************}


unit Controller.Interfaces;

interface

uses
  Model.Factory.Entidade.Interfaces;

type
  iController = interface
    ['{611C46ED-61F0-4331-A949-B58E8B473AF0}']
    function FactoryEntidade : iFactoryEntidade;
  end;

implementation

end.

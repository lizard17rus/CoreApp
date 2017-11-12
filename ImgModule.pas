unit ImgModule;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ImgList;

type
  TImgLib = class(TForm)
    imgButtonedEdit: TImageList;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ImgLib: TImgLib;

implementation

{$R *.dfm}

end.

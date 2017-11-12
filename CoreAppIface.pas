unit CoreAppIface;

interface

{***************************** Экспортные функции *****************************}

//function _CreateGUIParam: IGUIParam; stdcall;
//external 'CoreApp.dll' name '_CreateGUIParam';
//
//function _CreateGUI(GUIParam: IGUIParam; Color: string): IGUI; stdcall;
//external 'CoreApp.dll' name '_CreateGUI';

{******************************************************************************}

{***** Сетка компонентов (TypeControl: Integer) *****}
{  IParam._Form._Side._Control._TypeControl          }
{                                                    }
{  10 - ComboBox                                     }
{  20 - Edit                                         }
{  21 - Edit ReadOnly                                }
{  22 - Edit Disable                                 }
{  23 - Edit Password                                }
{  24 - Edit Hide                                    }
{  30 - ButtonedEdit                                 }
{  31 - ButtonedEdit BrowseDir                       }
{  40 - MaskEdit Date                                }
{                                                    }
{****************************************************}

uses
  System.Classes, Vcl.Forms, Vcl.ExtCtrls;

type
  IGUIBasicParam = interface(IInterface)
    function _Name: string;
    function _Caption(Caption: string=''; Write: Boolean=False): string;
  end;

type
  IGUIComboParam = interface(IInterface)
    function _ComboList(ComboList: TStrings=nil; Write: Boolean=False): TStrings;
  end;

type
  IGUIActionParam = interface(IGUIBasicParam)
    procedure _SetNotifyEvent(NotifyEvent: TNotifyEvent);
    function _GetNotifyEvent: TNotifyEvent;
    property PNotifyEvent: TNotifyEvent read _GetNotifyEvent write _SetNotifyEvent;
  end;

type
  IGUIActionButtonParam = interface(IGUIActionParam)
    function _ShortCut(ShortCut: string=''; Write: Boolean=False): string;
  end;

type
  IGUIActionMainParam = interface(IGUIActionButtonParam)
    function _Category(Category: string=''; Write: Boolean=False): string;
  end;

type
  IGUIControlParam = interface(IGUIBasicParam)
    function _TypeControl(TypeControl: Integer=0; Write: Boolean=False): Integer;
    function _Length(Length: Integer=0; Write: Boolean=False): Integer;
    function _Value(Value: Variant; Write: Boolean=False): Variant;
    function _ActionParam(Name: string=''; Create: Boolean=False): IGUIActionParam;
    function _ComboParam(Create: Boolean=False): IGUIComboParam;
    function _GetHighPopupActionsParam: Integer;
    function _PopupActionParam(Index: Integer=0; Name: string=''; New: Boolean=False): IGUIActionButtonParam;
  end;

type
  IGUISideParam = interface(IGUIBasicParam)
    function _GetHighControlsParam: Integer;
    function _ControlParam(Index: Integer=0; Name: string=''; New: Boolean=False): IGUIControlParam;
  end;

type
  IGUIFormParam = interface(IGUIBasicParam)
    function _Style(Style: TFormBorderStyle=bsSizeable; Write: Boolean = False): TFormBorderStyle;
    function _Height(Height: Integer=0; Write: Boolean = False): Integer;
    function _Width(Width: Integer=0; Write: Boolean = False): Integer;
    function _Position(Position: TPosition=poDesigned; Write: Boolean = False): TPosition;
    function _GetHighMainActionsParam: Integer;
    function _MainActionParam(Index: Integer=0; Name: string=''; New: Boolean=False): IGUIActionMainParam;
    function _GetHighButtonActionsParam: Integer;
    function _ButtonActionParam(Index: Integer=0; Name: string=''; New: Boolean=False): IGUIActionButtonParam;
    function _GetHighSidesParam: Integer;
    function _SideParam(Index: Integer=0; Name: string=''; New: Boolean=False): IGUISideParam;
  end;

type
  IGUIParam = interface(IInterface)
    function _GetHighFormsParam: Integer;
    function _FormParam(Index: Integer=0; Name: string=''; New: Boolean=False): IGUIFormParam;
  end;

type
  IGUIForm = interface(IInterface)
    procedure _ShowModal;
    procedure _Close;
  end;

type
  IGUI = interface(IInterface)
    function _GUIForm(Index: Integer=0; Name: string=''; New: Boolean=False): IGUIForm;
  end;

implementation

end.

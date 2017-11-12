unit GUIParamModule;

interface

uses
  Vcl.Forms, System.SysUtils, System.Classes,
  CoreAppIface;

type
  TGUIBasicParam = class(TInterfacedObject, IGUIBasicParam)
    FName: string;
    FCaption: string;
    function _Name: string;
    function _Caption(Caption: string=''; Write: Boolean=False): string;
  end;

type
  TGUIComboParam = class(TInterfacedObject, IGUIComboParam)
    FComboList: TStrings;
    function _ComboList(ComboList: TStrings=nil; Write: Boolean=False): TStrings;
  end;

type
  TGUIActionParam = class(TGUIBasicParam, IGUIActionParam)
    FNotifyEvent: TNotifyEvent;
    procedure _SetNotifyEvent(NotifyEvent: TNotifyEvent);
    function _GetNotifyEvent: TNotifyEvent;
    property PNotifyEvent: TNotifyEvent read _GetNotifyEvent write _SetNotifyEvent;
  end;

type
  TGUIActionButtonParam = class(TGUIActionParam, IGUIActionButtonParam)
    FShortCut: string;
    function _ShortCut(ShortCut: string=''; Write: Boolean=False): string;
  end;

type
  TGUIActionMainParam = class(TGUIActionButtonParam, IGUIActionMainParam)
    FCategory: string;
    function _Category(Category: string=''; Write: Boolean=False): string;
  end;

type
  TGUIControlParam = class(TGUIBasicParam, IGUIControlParam)
    FTypeControl: Integer;
    FLength: Integer;
    FValue: Variant;
    FActionParam: TGUIActionParam;
    FComboParam: TGUIComboParam;
    FPopupActionsParam: array of TGUIActionButtonParam;
    function _TypeControl(TypeControl: Integer=0; Write: Boolean=False): Integer;
    function _Length(Length: Integer=0; Write: Boolean=False): Integer;
    function _Value(Value: Variant; Write: Boolean=False): Variant;
    function _ActionParam(Name: string=''; Create: Boolean=False): IGUIActionParam;
    function _ComboParam(Create: Boolean=False): IGUIComboParam;
    function _GetHighPopupActionsParam: Integer;
    function _PopupActionParam(Index: Integer=0; Name: string=''; New: Boolean=False): IGUIActionButtonParam;
  end;

type
  TGUISideParam = class(TGUIBasicParam, IGUISideParam)
    FControlsParam: array of TGUIControlParam;
    function _GetHighControlsParam: Integer;
    function _ControlParam(Index: Integer=0; Name: string=''; New: Boolean=False): IGUIControlParam;
  end;

type
  TGUIFormParam = class(TGUIBasicParam, IGUIFormParam)
    FStyle: TFormBorderStyle;
    FHeight: Integer;
    FWidth: Integer;
    FPosition: TPosition;
    FMainActionsParam: array of TGUIActionMainParam;
    FButtonActionsParam: array of TGUIActionButtonParam;
    FSidesParam: array of TGUISideParam;
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
  TGUIParam = class(TInterfacedObject, IGUIParam)
    FFormsParam: array of TGUIFormParam;
    function _GetHighFormsParam: Integer;
    function _FormParam(Index: Integer=0; Name: string=''; New: Boolean=False): IGUIFormParam;
  end;

function _CreateGUIParam: IGUIParam; stdcall;

implementation

// методы TGUIBasicParam
function TGUIBasicParam._Name: string;
begin
  Result := FName;
end;

function TGUIBasicParam._Caption(Caption: string=''; Write: Boolean=False): string;
begin
  if Write then
    FCaption := Caption;
  Result := FCaption;
end;

// методы TGUIComboParam
function TGUIComboParam._ComboList(ComboList: TStrings=nil; Write: Boolean=False): TStrings;
begin
  if Write then
    FComboList := ComboList;
  Result := FComboList;
end;

// методы TGUIActionParam
procedure TGUIActionParam._SetNotifyEvent(NotifyEvent: TNotifyEvent);
begin
  FNotifyEvent := NotifyEvent;
end;

function TGUIActionParam._GetNotifyEvent: TNotifyEvent;
begin
  Result := FNotifyEvent;
end;

// методы TGUIActionButtonParam
function TGUIActionButtonParam._ShortCut(ShortCut: string=''; Write: Boolean=False): string;
begin
  if Write then
    FShortCut := ShortCut;
  Result := FShortCut;
end;

// методы TGUIActionMainParam
function TGUIActionMainParam._Category(Category: string=''; Write: Boolean=False): string;
begin
  if Write then
    FCategory := Category;
  Result := FCategory;
end;

// методы TGUIControlParam
function TGUIControlParam._TypeControl(TypeControl: Integer=0; Write: Boolean=False): Integer;
begin
  if Write then
    FTypeControl := TypeControl;
  Result := FTypeControl;
end;

function TGUIControlParam._Length(Length: Integer=0; Write: Boolean=False): Integer;
begin
  if Write then
    FLength := Length;
  Result := FLength;
end;

function TGUIControlParam._Value(Value: Variant; Write: Boolean=False): Variant;
begin
  if Write then
    FValue := Value;
  Result := FValue;
end;

function TGUIControlParam._ActionParam(Name: string=''; Create: Boolean=False): IGUIActionParam;
begin
  if (Create) and (Name <> '') then
  begin
    FActionParam := TGUIActionParam.Create;
    FActionParam.FName := Name;
  end;
  Result := FActionParam;
end;

function TGUIControlParam._ComboParam(Create: Boolean=False): IGUIComboParam;
begin
  if Create then
    FComboParam := TGUIComboParam.Create;
  Result := FComboParam;
end;

function TGUIControlParam._GetHighPopupActionsParam: Integer;
begin
  Result := High(FPopupActionsParam);
end;

function TGUIControlParam._PopupActionParam(Index: Integer=0; Name: string=''; New: Boolean=False): IGUIActionButtonParam;
var
  i: Integer;
begin
  if (New) and (Name <> '') then
  begin
    i := High(FPopupActionsParam)+1;
    SetLength(FPopupActionsParam, i+1);
    FPopupActionsParam[i] := TGUIActionButtonParam.Create;
    FPopupActionsParam[i].FName := Name;
    Result := FPopupActionsParam[i];
  end
  else
    if Name <> '' then
    begin
      for i := 0 to High(FPopupActionsParam) do
        if FPopupActionsParam[i].FName = Name then
        begin
          Result := FPopupActionsParam[i];
          Break;
        end;
    end
    else
      Result := FPopupActionsParam[Index];
end;

// методы TGUISideParam
function TGUISideParam._GetHighControlsParam: Integer;
begin
  Result := High(FControlsParam);
end;

function TGUISideParam._ControlParam(Index: Integer=0; Name: string=''; New: Boolean=False): IGUIControlParam;
var
  i: Integer;
begin
  if (New) and (Name <> '') then
  begin
    i := High(FControlsParam)+1;
    SetLength(FControlsParam, i+1);
    FControlsParam[i] := TGUIControlParam.Create;
    FControlsParam[i].FName := Name;
    Result := FControlsParam[i];
  end
  else
    if Name <> '' then
    begin
      for i := 0 to High(FControlsParam) do
        if FControlsParam[i].FName = Name then
        begin
          Result := FControlsParam[i];
          Break;
        end;
    end
    else
      Result := FControlsParam[Index];
end;

// методы TGUIFormParam
function TGUIFormParam._Style(Style: TFormBorderStyle=bsSizeable; Write: Boolean = False): TFormBorderStyle;
begin
  if Write then
    FStyle := Style;
  Result := FStyle;
end;

function TGUIFormParam._Height(Height: Integer=0; Write: Boolean = False): Integer;
begin
  if Write then
    FHeight := Height;
  Result := FHeight;
end;

function TGUIFormParam._Width(Width: Integer=0; Write: Boolean = False): Integer;
begin
  if Write then
    FWidth := Width;
  Result := FWidth;
end;

function TGUIFormParam._Position(Position: TPosition=poDesigned; Write: Boolean = False): TPosition;
begin
  if Write then
    FPosition := Position;
  Result := FPosition;
end;

function TGUIFormParam._GetHighMainActionsParam: Integer;
begin
  Result := High(FMainActionsParam);
end;

function TGUIFormParam._MainActionParam(Index: Integer=0; Name: string=''; New: Boolean=False): IGUIActionMainParam;
var
  i: Integer;
begin
  if (New) and (Name <> '') then
  begin
    i := High(FMainActionsParam)+1;
    SetLength(FMainActionsParam, i+1);
    FMainActionsParam[i] := TGUIActionMainParam.Create;
    FMainActionsParam[i].FName := Name;
    Result := FMainActionsParam[i];
  end
  else
    if Name <> '' then
    begin
      for i := 0 to High(FMainActionsParam) do
        if FMainActionsParam[i].FName = Name then
        begin
          Result := FMainActionsParam[i];
          Break;
        end;
    end
    else
      Result := FMainActionsParam[Index];
end;

function TGUIFormParam._GetHighButtonActionsParam: Integer;
begin
  Result := High(FButtonActionsParam);
end;

function TGUIFormParam._ButtonActionParam(Index: Integer=0; Name: string=''; New: Boolean=False): IGUIActionButtonParam;
var
  i: Integer;
begin
  if (New) and (Name <> '') then
  begin
    i := High(FButtonActionsParam)+1;
    SetLength(FButtonActionsParam, i+1);
    FButtonActionsParam[i] := TGUIActionButtonParam.Create;
    FButtonActionsParam[i].FName := Name;
    Result := FButtonActionsParam[i];
  end
  else
    if Name <> '' then
    begin
      for i := 0 to High(FButtonActionsParam) do
        if FButtonActionsParam[i].FName = Name then
        begin
          Result := FButtonActionsParam[i];
          Break;
        end;
    end
    else
      Result := FButtonActionsParam[Index];
end;

function TGUIFormParam._GetHighSidesParam: Integer;
begin
  Result := High(FSidesParam);
end;

function TGUIFormParam._SideParam(Index: Integer=0; Name: string=''; New: Boolean=False): IGUISideParam;
var
  i: Integer;
begin
  if (New) and (Name <> '') then
  begin
    i := High(FSidesParam)+1;
    SetLength(FSidesParam, i+1);
    FSidesParam[i] := TGUISideParam.Create;
    FSidesParam[i].FName := Name;
    Result := FSidesParam[i];
  end
  else
    if Name <> '' then
    begin
      for i := 0 to High(FSidesParam) do
        if FSidesParam[i].FName = Name then
        begin
          Result := FSidesParam[i];
          Break;
        end;
    end
    else
      Result := FSidesParam[Index];
end;

// методы TGUIParam
function TGUIParam._GetHighFormsParam: Integer;
begin
  Result := High(FFormsParam);
end;

function TGUIParam._FormParam(Index: Integer=0; Name: string=''; New: Boolean=False): IGUIFormParam;
var
  i: Integer;
begin
  if (New) and (Name <> '') then
  begin
    i := High(FFormsParam)+1;
    SetLength(FFormsParam, i+1);
    FFormsParam[i] := TGUIFormParam.Create;
    FFormsParam[i].FName := Name;
    Result := FFormsParam[i];
  end
  else
    if Name <> '' then
    begin
      for i := 0 to High(FFormsParam) do
        if FFormsParam[i].FName = Name then
        begin
          Result := FFormsParam[i];
          Break;
        end;
    end
    else
      Result := FFormsParam[Index];
end;

// экспортные функции создания объектов
function _CreateGUIParam: IGUIParam; stdcall;
begin
  Result := TGUIParam.Create;
end;

end.

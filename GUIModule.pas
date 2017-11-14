unit GUIModule;

interface

uses
  Vcl.Dialogs,
  System.UITypes, System.Variants, System.Classes, System.SysUtils,
  Vcl.Forms, Vcl.ActnList, Vcl.ActnMan, Vcl.ActnMenus, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Controls, Vcl.Graphics, Vcl.Mask, Vcl.FileCtrl,
  Vcl.ActnPopup, Vcl.Menus,
  CoreAppIface, Components;

type
  TEvent = class
    procedure _FormActivate(Sender: TObject);
    procedure _SideActivate(Sender: TObject);
    procedure _SaveValues(Controls: TPanel; SideParam: IGUISideParam);
    procedure _ShowActiveSide(Side: TPanel);
    procedure _CreateControls(Controls: TPanel; SideParam: IGUISideParam);
    procedure _AlignControls(Controls: TPanel);
    procedure _ButtonedEdit_BrowseDir(Sender: TObject);
  end;

type
  TGUIForm = class(TForm, IGUIForm)
    FFormParam: IGUIFormParam;
    FButtons: TPanel;
    FSides: TPanel;
    FControls: TPanel;
    FActiveSide: TPanel;
    procedure _ShowModal;
    procedure _Close;
  end;

type
  TGUI = class(TInterfacedObject, IGUI)
    FGUIForms: array of TGUIForm;
    function _GUIForm(Index: Integer=0; Name: string=''; New: Boolean=False): IGUIForm;
  end;

procedure _SetGlobalColors(Color: TGUIColors);
procedure _SetColors(Sender: TObject; Active: Boolean=False);
function _CreateGUI(GUIParam: IGUIParam): IGUI; stdcall;

var
  MainColor: TColor;
  ActivePanelColor: TColor;
  ActivePanelFontColor: TColor;
  Event: TEvent;
  ActiveGUIForm: TGUIForm;

implementation

// методы TEvent
procedure TEvent._FormActivate(Sender: TObject);
begin
  ActiveGUIForm := Sender as TGUIForm;
end;

procedure TEvent._SideActivate(Sender: TObject);
begin
  if ActiveGUIForm.FActiveSide <> (Sender as TAction).ActionComponent as TPanel then
  begin
    if ActiveGUIForm.FActiveSide <> nil then
      _SaveValues(ActiveGUIForm.FControls, ActiveGUIForm.FFormParam._SideParam(0, ActiveGUIForm.FActiveSide.Name));
    ActiveGUIForm.FActiveSide := (Sender as TAction).ActionComponent as TPanel;
    _ShowActiveSide(ActiveGUIForm.FActiveSide);
    _CreateControls(ActiveGUIForm.FControls, ActiveGUIForm.FFormParam._SideParam(0, ActiveGUIForm.FActiveSide.Name));
  end;
end;

procedure TEvent._SaveValues(Controls: TPanel; SideParam: IGUISideParam);
var
  i: Integer;
begin
  for i := 0 to Controls.ComponentCount-1 do
  begin
    if (Controls.Components[i] is TComboBox) then
      SideParam._ControlParam(0, (Controls.Components[i] as TWinControl).Name)._Value((Controls.Components[i] as TComboBox).ItemIndex, True);
    if (Controls.Components[i] is TEdit) then
      SideParam._ControlParam(0, (Controls.Components[i] as TWinControl).Name)._Value((Controls.Components[i] as TEdit).Text, True);
    if (Controls.Components[i] is TButtonedEdit) then
      SideParam._ControlParam(0, (Controls.Components[i] as TWinControl).Name)._Value((Controls.Components[i] as TButtonedEdit).Text, True);
    if (Controls.Components[i] is TMaskEdit) then
      SideParam._ControlParam(0, (Controls.Components[i] as TWinControl).Name)._Value((Controls.Components[i] as TMaskEdit).Text, True);
  end;
end;

procedure TEvent._ShowActiveSide(Side: TPanel);
var
  i: Integer;
begin
  for i := 0 to Side.Owner.ComponentCount-1 do
    if (Side.Owner.Components[i] is TPanel) then
      _SetColors(Side.Owner.Components[i]);
  _SetColors(Side, True);
end;

procedure TEvent._CreateControls(Controls: TPanel; SideParam: IGUISideParam);
var
  i, j: Integer;
  lbl: TLabel;
  cmb: TComboBox;
  edt: TEdit;
  bedt: TButtonedEdit;
  medt: TMaskEdit;
  amr: TActionManager;
  pop: TPopupActionBar;
  act: TAction;
  popi: TMenuItem;
begin
  for i := Controls.ComponentCount-1 downto 0 do
    Controls.Components[i].Free;
  for i := 0 to SideParam._GetHighControlsParam do
    with SideParam._ControlParam(i) do
    begin
      if _GetHighPopupActionsParam <> -1 then
      begin
        CreateActionManager(amr, Controls);
        CreatePopupMenuBar(pop, Controls);
        for j := 0 to _GetHighPopupActionsParam do
          with _PopupActionParam(j) do
          begin
            CreateAction(act, amr, _Name, _Caption, '', _ShortCut, PNotifyEvent);
            CreatePopupMenuItem(popi, pop, act);
            popi := nil;
            act := nil;
          end;
      end;
      case _TypeControl div 10 of
        1:
          begin
            CreateLabelTitle(lbl, Controls, _Caption);
            CreateComboBox(cmb, Controls, _Name, 250);
            cmb.Style := csDropDownList;
            if _ActionParam <> nil then
              cmb.OnChange := _ActionParam.PNotifyEvent;
            if _ComboParam <> nil then
              cmb.Items.AddStrings(_ComboParam._ListParam);
            if _LookupParam <> nil then
              cmb.Items.AddStrings(_LookupParam._ListParam);
            cmb.ItemIndex := _Value(Null);
            cmb.PopupMenu := pop;
            cmb := nil;
            lbl := nil;
          end;
        2:
          begin
            CreateLabelTitle(lbl, Controls, _Caption);
            CreateEdit(edt, Controls, _Name, 250);
            edt.Text := _Value(Null);
            if _Length <> 0 then
              edt.MaxLength := _Length;
            with edt do
              case _TypeControl mod 10 of
                1:
                  begin
                    ReadOnly := True;
                  end;
                2:
                  begin
                    Enabled := False;
                  end;
                3:
                  begin
                    PasswordChar := '*';
                  end;
                4:
                  begin
                    ReadOnly := True;
                    BorderStyle := bsNone;
                    ParentColor := True;
                  end;
              end;
            edt.PopupMenu := pop;
            edt := nil;
            lbl := nil;
          end;
        3:
          begin
            CreateLabelTitle(lbl, Controls, _Caption);
            CreateLibMedia;
            CreateButtonedEdit(bedt, Controls, _Name, 250);
            bedt.Text := _Value(Null);
            case _TypeControl mod 10 of
              1:
                begin
                  bedt.OnRightButtonClick := Event._ButtonedEdit_BrowseDir;
                end;
            end;
            bedt.PopupMenu := pop;
            bedt := nil;
            lbl := nil;
          end;
        4:
          begin
            CreateLabelTitle(lbl, Controls, _Caption);
            CreateMaskEdit(medt, Controls, _Name, 250);
            medt.EditMask := '00/00/0000;1; ';
            medt.Text := _Value(Null);
            if _Length <> 0 then
              medt.MaxLength := _Length;
            medt.PopupMenu := pop;
            medt := nil;
            lbl := nil;
          end;
      end;
      pop := nil;
      amr := nil;
    end;
  _AlignControls(Controls);
end;

procedure TEvent._AlignControls(Controls: TPanel);
var
  i, C1, C2: Integer;
begin
  C1 := 0;
  C2 := 0;
  with Controls do
    for i := 0 to ComponentCount-1 do
    begin
      if Components[i] is TLabel then
      begin
        (Components[i] as TLabel).Left := 48;
        (Components[i] as TLabel).Top := 24+(32*C1)+3;
        Inc(C1);
      end;
      if (Components[i] is TComboBox) or
        (Components[i] is TEdit) or
        (Components[i] is TButtonedEdit) or
        (Components[i] is TMaskEdit) then
      begin
        (Components[i] as TWinControl).Left := 48+120;
        (Components[i] as TWinControl).Top := 24+(32*C2);
        Inc(C2);
      end;
    end;
end;

procedure TEvent._ButtonedEdit_BrowseDir(Sender: TObject);
var
  ChosenDirectory: string;
begin
  if SelectDirectory('Выбор папки', (Sender as TButtonedEdit).Text, ChosenDirectory) then
    (Sender as TButtonedEdit).Text := ChosenDirectory;
end;

// методы TGUIForm
procedure TGUIForm._ShowModal;
begin
  ShowModal;
end;

procedure TGUIForm._Close;
begin
  Close;
end;

// методы TGUI
function TGUI._GUIForm(Index: Integer=0; Name: string=''; New: Boolean=False): IGUIForm;
var
  i: Integer;
begin
  if (New) and (Name <> '') then
  begin
    i := High(FGUIForms)+1;
    SetLength(FGUIForms, i+1);
    FGUIForms[i] := TGUIForm.CreateNew(nil);
    FGUIForms[i].Name := Name;
    Result := FGUIForms[i];
  end
  else
    if Name <> '' then
    begin
      for i := 0 to High(FGUIForms) do
        if FGUIForms[i].Name = Name  then
        begin
          Result := FGUIForms[i];
          Break;
        end;
    end
    else
      Result := FGUIForms[Index];
end;

// процедуры управления глобальными переменными
procedure _SetGlobalColors(Color: TGUIColors);
begin
  case Color of
    Green:
      begin
        MainColor := clMoneyGreen;
        ActivePanelColor := clLime;
        ActivePanelFontColor := clWindowText;
      end;
    Blue:
      begin
        MainColor := clSkyBlue;
        ActivePanelColor := clAqua;
        ActivePanelFontColor := clWindowText;
      end;
    Gray:
      begin
        MainColor := clSilver;
        ActivePanelColor := clMedGray;
        ActivePanelFontColor := clWindowText;
      end;
  end;
end;

procedure _SetColors(Sender: TObject; Active: Boolean=False);
begin
  if Sender is TForm then
    (Sender as TForm).Color := MainColor;
  if Sender is TPanel then
    if Active then
    begin
      (Sender as TPanel).Color := ActivePanelColor;
      (Sender as TPanel).ParentFont := False;
      (Sender as TPanel).Font.Color := ActivePanelFontColor;
      (Sender as TPanel).Font.Style := (Sender as TPanel).Font.Style + [fsBold];
    end
    else
    begin
      (Sender as TPanel).ParentColor := True;
      (Sender as TPanel).ParentFont := True;
    end;
end;

// экспортные функции создания объектов
function _CreateGUI(GUIParam: IGUIParam): IGUI; stdcall;
var
  i, j: Integer;
  FormParam: IGUIFormParam;
  act: TAction;
  amm: TActionMainMenuBar;
  amr: TActionManager;
  abi: TActionBarItem;
  btn: TButton;
  pnl: TPanel;
begin
  Result := nil;
  if GUIParam = nil then
    Exit
  else
    if GUIParam._GetHighFormsParam = -1 then
      Exit;
  _SetGlobalColors(GUIParam._ColorScheme);
  Result := TGUI.Create; //создаем объект интерфейса
  //формы
  for i := 0 to GUIParam._GetHighFormsParam do
  begin
    FormParam := GUIParam._FormParam(i); //получаем описание очередной формы
    ActiveGUIForm := (Result._GUIForm(0, FormParam._Name, True) as TGUIForm); //создаем очередную форму
    with ActiveGUIForm do //устанавливаем свойства формы
    begin
      FFormParam := FormParam;
      Caption := FormParam._Caption;
      BorderStyle := FormParam._Style;
      Height := FormParam._Height;
      Width := FormParam._Width;
      Position := FormParam._Position;
      OnActivate := Event._FormActivate;
      _SetColors(ActiveGUIForm);
    end;
    //главное меню формы
    if FormParam._GetHighMainActionsParam <> -1 then
    begin
      CreateActionMainMenuBar(amm, ActiveGUIForm); //создаем главное меню формы
      CreateActionManager(amr, ActiveGUIForm); //создаем список действий главного меню
      for j := 0 to FormParam._GetHighMainActionsParam do //заполняем список действий и отображаем его в главном меню
        with FormParam._MainActionParam(j) do
        begin
          CreateAction(act, amr, _Name, _Caption, _Category, _ShortCut, PNotifyEvent);
          CreateActionMenuItem(amm, abi, amr, act, True);
          act := nil;
          abi := nil;
        end;
      amr := nil;
      amm := nil;
    end;
    //панель контролов
    CreatePanel(ActiveGUIForm.FControls, ActiveGUIForm); //создаем панель контролов
    with ActiveGUIForm.FControls do //устанавливаем свойства панели
    begin
      Align := alClient;
    end;
    //панель кнопок
    if FormParam._GetHighButtonActionsParam <> -1 then
    begin
      CreatePanel(ActiveGUIForm.FButtons, ActiveGUIForm); //создаем панель кнопок
      with ActiveGUIForm.FButtons do //устанавливаем свойства панели
      begin
        Align := alBottom;
        Height := 42;
        Padding.Bottom := 6;
        Padding.Left := 6;
        Padding.Right := 6;
        Padding.Top := 6;
      end;
      CreateActionManager(amr, ActiveGUIForm); //создаем список действий панели кнопок
      for j := 0 to FormParam._GetHighButtonActionsParam do //заполняем список действий и отображаем его на кнопки
        with FormParam._ButtonActionParam(j) do
        begin
          CreateAction(act, amr, _Name, _Caption, '', _ShortCut, PNotifyEvent);
          CreateButton(btn, ActiveGUIForm.FButtons, 150);
          with btn do
          begin
            Align := alRight;
            Action := act;
          end;
          btn := nil;
          act := nil;
        end;
      amr := nil;
    end;
    //панель переходов
    if FormParam._GetHighSidesParam <> -1 then
    begin
      CreatePanel(ActiveGUIForm.FSides, ActiveGUIForm); //создаем панель переходов
      with ActiveGUIForm.FSides do //устанавливаем свойства панели
      begin
        Align := alLeft;
        Width := 160;
      end;
      CreateActionManager(amr, ActiveGUIForm); //создаем список действий панели переходов
      for j := 0 to FormParam._GetHighSidesParam do //заполняем список действий отображаем его на элементы переходов
        with FormParam._SideParam(j) do
        begin
          CreateAction(act, amr, _Name, _Caption, '', '', Event._SideActivate);
          CreatePanel(pnl, ActiveGUIForm.FSides);
          with pnl do
          begin
            Name := _Name;
            Align := alTop;
            Height := 40;
            BevelOuter := bvNone;
            Action := act;
          end;
          if j=0 then //активируем первый элемент перехода
          begin
            ActiveGUIForm.FActiveSide := pnl;
            Event._ShowActiveSide(pnl);
            Event._CreateControls(ActiveGUIForm.FControls, FormParam._SideParam(j));
          end;
          pnl := nil;
          act := nil;
        end;
      amr := nil;
      if FormParam._GetHighSidesParam = 0 then //если только один элемент перехода
        ActiveGUIForm.FSides.Visible := False; //то прячем панель переходов
    end;
    FormParam := nil;
    ActiveGUIForm := nil;
  end;
end;

end.

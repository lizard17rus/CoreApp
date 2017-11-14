unit Components;

interface

uses
  Vcl.Forms, Vcl.Controls, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ActnPopup,
  Vcl.Graphics, System.SysUtils, Vcl.Mask, System.Classes, System.UITypes,
  Vcl.Dialogs, System.Actions, Vcl.ActnMan, Vcl.ActnList, Vcl.ActnMenus,
  Vcl.Menus, StdStyleActnCtrls,
  FireDAC.Comp.Client, FireDAC.Stan.Def, FireDAC.Phys.MySQL, FireDAC.DApt,
  FireDAC.Stan.Async, FireDAC.UI.Intf, FireDAC.VCLUI.Wait, FireDAC.Stan.Intf,
  FireDAC.Comp.UI,
  LibMediaModule;

procedure CreateForm(var Component: TForm; Owner: TComponent);
procedure CreateConnectionDB(var Component: TFDConnection; Owner: TWinControl; Params: TStream);
procedure CreateQueryDB(var Component: TFDQuery; Owner: TWinControl; FDConnection: TFDConnection);
procedure CreateActionMainMenuBar(var Component: TActionMainMenuBar; Owner: TWinControl);
procedure CreatePopupMenuBar(var Component: TPopupActionBar; Owner: TWinControl);
procedure CreatePopupMenuItem(var Component: TMenuItem; Owner: TPopupActionBar; Action: TAction);
procedure CreateActionManager(var Component: TActionManager; Owner: TWinControl);
procedure CreateAction(var Component: TAction; Owner: TCustomActionList; Name, Caption, Category, ShortCut: string; Action: TNotifyEvent);
function CreateActionMenuItem(CustomActionBar: TCustomActionBar; var ActionBarItem: TActionBarItem; ActionManager: TActionManager; Action: TAction; ToCategory: Boolean): Boolean;
procedure CreatePanel(var Component: TPanel; Owner: TWinControl);
procedure CreateLabelTitle(var Component: TLabel; Owner: TWinControl; Caption: string);
procedure CreateLabelHead1(var Component: TLabel; Owner: TWinControl; Caption: string);
procedure CreateLabelHead2(var Component: TLabel; Owner: TWinControl; Caption: string);
procedure CreateButton(var Component: TButton; Owner: TWinControl; Width: Integer);
procedure CreateComboBox(var Component: TComboBox; Owner: TWinControl; Name: string; Width: Integer);
procedure CreateEdit(var Component: TEdit; Owner: TWinControl; Name: string; Width: Integer);
procedure CreateMaskEdit(var Component: TMaskEdit; Owner: TWinControl; Name: string; Width: Integer);
procedure CreateLibMedia;
procedure CreateButtonedEdit(var Component: TButtonedEdit; Owner: TWinControl; Name: string; Width: Integer);
procedure CreateOpenDialog (var Component: TOpenDialog; Owner: TWinControl; Filter: string);

implementation

procedure CreateForm(var Component: TForm; Owner: TComponent);
begin
  //----------------------------------------------------------------------------
  Component := TForm.CreateNew(Owner);
end;

procedure CreateConnectionDB(var Component: TFDConnection; Owner: TWinControl; Params: TStream);
begin
  //----------------------------------------------------------------------------
  Component := TFDConnection.Create(Owner);
  Component.LoginPrompt := False;
  Params.Position := 0;
  Component.Params.LoadFromStream(Params);
end;

procedure CreateQueryDB(var Component: TFDQuery; Owner: TWinControl; FDConnection: TFDConnection);
begin
  //----------------------------------------------------------------------------
  Component := TFDQuery.Create(Owner);
  Component.Connection := FDConnection;
end;

procedure CreateActionMainMenuBar(var Component: TActionMainMenuBar; Owner: TWinControl);
begin
  //----------------------------------------------------------------------------
  Component := TActionMainMenuBar.Create(Owner);
  Component.Parent := Owner;
end;

procedure CreatePopupMenuBar(var Component: TPopupActionBar; Owner: TWinControl);
begin
  //----------------------------------------------------------------------------
  Component := TPopupActionBar.Create(Owner);
end;

procedure CreatePopupMenuItem(var Component: TMenuItem; Owner: TPopupActionBar; Action: TAction);
begin
  //----------------------------------------------------------------------------
  Component := TMenuItem.Create(Owner);
  Component.Action := Action;
  Owner.Items.Add(Component);
end;

procedure CreateActionManager(var Component: TActionManager; Owner: TWinControl);
begin
  //----------------------------------------------------------------------------
  Component := TActionManager.Create(Owner);
end;

procedure CreateAction(var Component: TAction; Owner: TCustomActionList; Name, Caption, Category, ShortCut: string; Action: TNotifyEvent);
begin
  //----------------------------------------------------------------------------
  Component := TAction.Create(Owner);
  Component.Name := Name;
  Component.Caption := Caption;
  Component.Category := Category;
  Component.ShortCut := TextToShortCut(ShortCut);
  Component.OnExecute := Action;
  Component.ActionList := Owner;
end;

function CreateActionMenuItem(CustomActionBar: TCustomActionBar; var ActionBarItem: TActionBarItem; ActionManager: TActionManager; Action: TAction; ToCategory: Boolean): Boolean;
var
  ActionClientItem: TActionClientItem;
  i: Integer;
begin
  //----------------------------------------------------------------------------
  Result := False;
  //----------------------------------------------------------------------------
  if ActionBarItem = nil then
  begin
    ActionBarItem := ActionManager.ActionBars.Add;
    ActionBarItem.ActionBar := CustomActionBar;
  end;
  if ToCategory then
  begin
    for i := 0 to ActionBarItem.Items.Count-1 do
      if ActionBarItem.Items[i].Caption = Action.Category then
      begin
        Result := True;
        Break;
      end;
    if Result then
    begin
      ActionClientItem := ActionBarItem.Items[i];
      ActionClientItem := ActionClientItem.Items.Add;
      ActionClientItem.Action := Action;
    end
    else
    begin
      ActionClientItem := ActionBarItem.Items.Add;
      ActionClientItem.Action := Action;
      ActionClientItem.Caption := Action.Category;
      CreateActionMenuItem(CustomActionBar, ActionBarItem, ActionManager, Action, True);
    end;
  end
  else
  begin
    ActionClientItem := ActionBarItem.Items.Add;
    ActionClientItem.Action := Action;
  end;
end;

procedure CreatePanel(var Component: TPanel; Owner: TWinControl);
begin
  //----------------------------------------------------------------------------
  Component := TPanel.Create(Owner);
  Component.ParentBackground := False;
  Component.ParentColor := True;
  Component.Parent := Owner;
end;

procedure CreateLabelTitle(var Component: TLabel; Owner: TWinControl; Caption: string);
begin
  //----------------------------------------------------------------------------
  Component := TLabel.Create(Owner);
  Component.Caption := Caption;
  Component.Parent := Owner;
end;

procedure CreateLabelHead1(var Component: TLabel; Owner: TWinControl; Caption: string);
begin
  //----------------------------------------------------------------------------
  CreateLabelTitle(Component, Owner, Caption);
  with Component do
    begin
      Align := alTop;
      Alignment := taCenter;
      Layout := tlBottom;
      Font.Size := 12;
      Font.Color := clBlue;
      Font.Style := Font.Style+[fsBold];
      Height := 50;
    end;
end;

procedure CreateLabelHead2(var Component: TLabel; Owner: TWinControl; Caption: string);
begin
  //----------------------------------------------------------------------------
  CreateLabelTitle(Component, Owner, Caption);
  with Component do
    begin
      Align := alTop;
      Alignment := taCenter;
    end;
end;

procedure CreateButton(var Component: TButton; Owner: TWinControl; Width: Integer);
begin
  //----------------------------------------------------------------------------
  Component := TButton.Create(Owner);
  Component.Width := Width;
  Component.Parent := Owner;
end;

procedure CreateComboBox(var Component: TComboBox; Owner: TWinControl; Name: string; Width: Integer);
begin
  //----------------------------------------------------------------------------
  Component := TComboBox.Create(Owner);
  Component.Name := Name;
  Component.Text := '';
  Component.Width := Width;
  Component.Parent := Owner;
end;

procedure CreateEdit(var Component: TEdit; Owner: TWinControl; Name: string; Width: Integer);
begin
  //----------------------------------------------------------------------------
  Component := TEdit.Create(Owner);
  Component.Name := Name;
  Component.Text := '';
  Component.Width := Width;
  Component.Parent := Owner;
end;

procedure CreateMaskEdit(var Component: TMaskEdit; Owner: TWinControl; Name: string; Width: Integer);
begin
  //----------------------------------------------------------------------------
  Component := TMaskEdit.Create(Owner);
  Component.Name := Name;
  Component.Text := '';
  Component.Width := Width;
  Component.Parent := Owner;
end;

procedure CreateLibMedia;
begin
  //----------------------------------------------------------------------------
  LibMedia := TLibMedia.Create(nil);
end;

procedure CreateButtonedEdit(var Component: TButtonedEdit; Owner: TWinControl; Name: string; Width: Integer);
begin
  //----------------------------------------------------------------------------
  Component := TButtonedEdit.Create(Owner);
  Component.Name := Name;
  Component.Text := '';
  Component.Width := Width;
  Component.Images := LibMedia.imgButtonedEdit;
  Component.RightButton.ImageIndex := 0;
  Component.RightButton.HotImageIndex := 1;
  Component.RightButton.PressedImageIndex := 2;
  Component.RightButton.DisabledImageIndex := 3;
  Component.RightButton.Visible := True;
  Component.Parent := Owner;
end;

procedure CreateOpenDialog (var Component: TOpenDialog; Owner: TWinControl; Filter: string);
begin
  Component := TOpenDialog.Create(Owner);
  Component.Filter := Filter;
end;

end.

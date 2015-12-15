unit VirtualListviewFMXOverview;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Mustangpeak.FMX.VirtualListview, FMX.Controls.Presentation, System.UIConsts,
  Mustangpeak.FMX.AniScroller, System.ImageList, FMX.ImgList, FMX.Edit, FMX.TextLayout;

const
  ID_CHECK_IMAGE     = 0;
  ID_MAIN_IMAGE      = 1;
  ID_MAIN_TEXT       = 2;
  ID_ACCESSORY_IMAGE = 3;

type
  THeaderFooterForm = class(TForm)
    Header: TToolBar;
    Footer: TToolBar;
    HeaderLabel: TLabel;
    SpeedButton1: TSpeedButton;
    VirtualListviewFMX1: TVirtualListviewFMX;
    ImageList1: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure VirtualListviewFMX1GetItemText(Sender: TObject; Item: TVirtualListItem; ID: Integer; TextLayout: TTextLayout; var DetailLines: Integer);
    procedure VirtualListviewFMX1GetItemDetailText(Sender: TObject; Item: TVirtualListItem; ID: Integer; TextLayout: TTextLayout);
    procedure VirtualListviewFMX1GetItemImage(Sender: TObject; Item: TVirtualListItem; ID: Integer; ImageLayout: TVirtualImageLayout);
    procedure VirtualListviewFMX1GetItemLayout(Sender: TObject; Item: TVirtualListItem; var Layout: TVirtualItemLayoutArray);
    procedure VirtualListviewFMX1ItemDrawBackground(Sender: TObject; Item: TVirtualListItem; WindowRect: TRectF; ItemCanvas: TCanvas; var Handled: Boolean);
    procedure SpeedButton1Click(Sender: TObject);
    procedure VirtualListviewFMX1ItemLayoutElementClick(Sender: TObject;
      Item: TVirtualListItem; Button: TMouseButton; Shift: TShiftState;
      ID: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  HeaderFooterForm: THeaderFooterForm;

implementation

{$R *.fmx}

procedure THeaderFooterForm.FormCreate(Sender: TObject);
var
  i: Integer;
  Item: TVirtualListItem;
begin

Exit;

  VirtualListviewFMX1.Items.Clear;
  for i := 0 to 3 do
  begin
    Item := VirtualListviewFMX1.Items.Add;
 {  if i mod 2 = 0 then
      Item.Color := claCornsilk
    else
      Item.Color := claSpringgreen       }
  end;
end;


procedure THeaderFooterForm.SpeedButton1Click(Sender: TObject);
begin
  VirtualListviewFMX1.InvalidateRect(VirtualListviewFMX1.LocalRect);
end;

procedure THeaderFooterForm.VirtualListviewFMX1GetItemDetailText(Sender: TObject; Item: TVirtualListItem; ID: Integer; TextLayout: TTextLayout);
begin
  case ID of
    0 : begin
          TextLayout.Text := 'Detail 1';
        end;
    1 : begin
          TextLayout.Text := 'Detail 2';
        end;
  end;
end;

procedure THeaderFooterForm.VirtualListviewFMX1GetItemImage(Sender: TObject; Item: TVirtualListItem; ID: Integer; ImageLayout: TVirtualImageLayout);
begin
  case ID  of
    ID_CHECK_IMAGE :
        begin
          ImageLayout.Images := ImageList1;
          ImageLayout.Opacity := 1.0;
          if Item.Checked then
            ImageLayout.ImageIndex := 2
          else
            ImageLayout.ImageIndex := 1;
        end;
    ID_MAIN_IMAGE : begin
          ImageLayout.Images := ImageList1;
          ImageLayout.ImageIndex := 0;
          ImageLayout.Opacity := 1.0
        end;
    ID_ACCESSORY_IMAGE : begin
          ImageLayout.Images := ImageList1;
          ImageLayout.ImageIndex := 3;
          ImageLayout.Opacity := 1.0;
          ImageLayout.Padding.Right := 8;
        end;
  end;
end;

procedure THeaderFooterForm.VirtualListviewFMX1GetItemLayout(Sender: TObject; Item: TVirtualListItem; var Layout: TVirtualItemLayoutArray);
begin
  if SpeedButton1.IsPressed then
  begin
    SetLength(Layout, 4);
    Layout[0] := TVirtualLayout.Create(ID_CHECK_IMAGE, TVirtualLayoutKind.Image, 24 + VirtualListviewFMX1.ImageLayout.Padding.Left + VirtualListviewFMX1.ImageLayout.Padding.Right, TVirtualLayoutWidth.Fixed);
    Layout[1] := TVirtualLayout.Create(ID_MAIN_IMAGE, TVirtualLayoutKind.Image, 48 + VirtualListviewFMX1.ImageLayout.Padding.Left + VirtualListviewFMX1.ImageLayout.Padding.Right, TVirtualLayoutWidth.Fixed);
    Layout[2] := TVirtualLayout.Create(ID_MAIN_TEXT, TVirtualLayoutKind.Text, 0, TVirtualLayoutWidth.Variable);
    Layout[3] := TVirtualLayout.Create(ID_ACCESSORY_IMAGE, TVirtualLayoutKind.Image, 24 + 8 + VirtualListviewFMX1.ImageLayout.Padding.Right, TVirtualLayoutWidth.Fixed);
  end else
  begin
    SetLength(Layout, 3);
    Layout[0] := TVirtualLayout.Create(ID_MAIN_IMAGE, TVirtualLayoutKind.Image, 48 + VirtualListviewFMX1.ImageLayout.Padding.Left + VirtualListviewFMX1.ImageLayout.Padding.Right, TVirtualLayoutWidth.Fixed);
    Layout[1] := TVirtualLayout.Create(ID_MAIN_TEXT, TVirtualLayoutKind.Text, 0, TVirtualLayoutWidth.Variable);
    Layout[2] := TVirtualLayout.Create(ID_ACCESSORY_IMAGE, TVirtualLayoutKind.Image, 24 + 8 + VirtualListviewFMX1.ImageLayout.Padding.Right, TVirtualLayoutWidth.Fixed);
  end;
end;

procedure THeaderFooterForm.VirtualListviewFMX1GetItemText(Sender: TObject; Item: TVirtualListItem; ID: Integer; TextLayout: TTextLayout; var DetailLines: Integer);
begin
  case ID of
    ID_MAIN_TEXT : TextLayout.Text := 'Item number: ' + IntToStr(Item.Index);
  else
    TextLayout.Text := 'Unknown ID';
  end;
end;

procedure THeaderFooterForm.VirtualListviewFMX1ItemDrawBackground(Sender: TObject; Item: TVirtualListItem; WindowRect: TRectF; ItemCanvas: TCanvas; var Handled: Boolean);
begin
  Handled := True;
  WindowRect.Inflate(-2, -2);
  ItemCanvas.Stroke.Thickness := 1.0;
  ItemCanvas.Stroke.Color := claBlue;
  ItemCanvas.Fill.Color := claBurlywood;
  ItemCanvas.FillRect(WindowRect, 10.0, 10.0, [TCorner.TopLeft,TCorner.TopRight, TCorner.BottomLeft, TCorner.BottomRight], 1.0, TCornerType.Round);
  ItemCanvas.DrawRect(WindowRect, 10.0, 10.0, [TCorner.TopLeft,TCorner.TopRight, TCorner.BottomLeft, TCorner.BottomRight], 1.0, TCornerType.Round);
end;

procedure THeaderFooterForm.VirtualListviewFMX1ItemLayoutElementClick(
  Sender: TObject; Item: TVirtualListItem; Button: TMouseButton;
  Shift: TShiftState; ID: Integer);
begin
  case ID of
    ID_CHECK_IMAGE     : ShowMessage('Checkbox Image clicked');
    ID_MAIN_IMAGE      : ShowMessage('Main Image clicked');
    ID_MAIN_TEXT       : ShowMessage('Text area clicked');
    ID_ACCESSORY_IMAGE : ShowMessage('Accessory Image clicked');
  end;
end;

end.

(*******************************************************************)
(*                                                                 *)
(*                            wxOCaml                              *)
(*                                                                 *)
(*                       Fabrice LE FESSANT                        *)
(*                                                                 *)
(*                 Copyright 2013, INRIA/OCamlPro.                 *)
(*            Licence LGPL v3.0 with linking exception.            *)
(*                                                                 *)
(*******************************************************************)

open WxClasses
open WxDefs
open WxMisc

let wxT s = s
let wxEmptyString = ""

let rec version_of_string version =
  try
    let pos = String.index version '.' in
    let len = String.length version in
    let before = String.sub version 0 pos in
    let after = String.sub version (pos+1) (len-pos-1) in
    int_of_string before :: (version_of_string after)
  with Not_found -> [ int_of_string version ]


let string_of_version wx_version =
  String.concat "." (List.map string_of_int wx_version)

let wx_version = version_of_string WxVersion.wx_version
let wx_config version = wx_version >= version

let wx_check_config version =
  if not (wx_config version) then begin
    Printf.eprintf "This example only works with WxWidgets version %s\n%!"
      (string_of_version version);
    exit 2
  end

let wx_2_9 = wx_config [2;9]
let wx_2_8 = wx_config [2;8] && not wx_2_9

(* TODO: creating all these handlers is bad, as it forces to link everything.
  We should probably only keep the external, maybe even generate it
  in WxClasses
*)
let wxID = WxID.create
let wxFrame = WxFrame.create
let wxFrameAll = WxFrame.createAll
let wxPanel = WxPanel.create
let wxMenuBar = WxMenuBar.create
let wxMenu = WxMenu.create
let wxBoxSizer = WxBoxSizer.create
let wxButton = WxButton.create
let wxStaticText = WxStaticText.create
let wxCalendarCtrl = WxCalendarCtrl.create
let wxSplitterWindow = WxSplitterWindow.create
let wxTextCtrl = WxTextCtrl.create
let wxLogTextCtrl = WxLogTextCtrl.create
let wxDialog = WxDialog.create
let wxDatePickerCtrl = WxDatePickerCtrl.create
let wxTimePickerCtrl = WxTimePickerCtrl.create
let wxWrapSizer = WxWrapSizer.create
let wxFlexGridSizer = WxFlexGridSizer.create
let wxStdDialogButtonSizer = WxStdDialogButtonSizer.create
let wxCalendarDateAttr = WxCalendarDateAttr.create
let wxCalendarDateAttrBorder = WxCalendarDateAttr.createBorder
let wxToolBar = WxToolBar.create
let wxStaticBoxSizer = WxStaticBoxSizer.create
let wxStaticBoxSizerEx = WxStaticBoxSizer.createEx
let wxCheckBox = WxCheckBox.create
let wxListBox = WxListBox.create
let wxScrolledWindow = WxScrolledWindow.create
let wxBitmap = WxBitmap.create
let wxBitmapImage = WxBitmap.createImage
let wxBitmapDefault = WxBitmap.createDefault
let wxBitmapLoad = WxBitmap.createLoad
let wxBitmapEmpty = WxBitmap.createEmpty
let wxColourDialog = WxColourDialog.create
let wxColourData = WxColourData.create
let wxDate = WxDateTime.createDate
let wxDateTime = WxDateTime.create
let wxBrush = WxBrush.create
let wxBrushBitmap = WxBrush.createBitmap
let wxBrushDefault = WxBrush.createDefault
let wxPNGHandler = WxPNGHandler.create
let wxOverlay = WxOverlay.create
let wxMaskColour = WxMask.createColour
let wxClientDC = WxClientDC.create
let wxPaintDC = WxPaintDC.create
let wxGCDC = WxGCDC.create
let wxGCDCEmpty = WxGCDC.createEmpty
let wxColour = WxColour.createName
let wxColours = WxColour.create
let wxRegion = WxRegion.create
let wxFont = WxFont.create
let wxFontAll = WxFont.createAll
let wxMemoryDC = WxMemoryDC.create
let wxMemoryDCBitmap = WxMemoryDC.createBitmap
let wxImage = WxImage.create
let wxFileDialog = WxFileDialog.create
let wxFileDialogAll = WxFileDialog.createAll
let wxWindow = WxWindow.create
let wxWizard = WxWizard.create
let wxWizardAll = WxWizard.createAll
let wxWizardPageSimple = WxWizardPageSimple.create
let wxWizardPageSimpleAll = WxWizardPageSimple.createAll


(* We MUST call the destructor of WxDCOverlay at the end ! *)
let wxDCOverlay win dc x y dx dy f =
  let o = WxDCOverlay.create win dc x y dx dy in
  try
    let res = f o in
    WxDCOverlay.delete o;
    res
  with e ->
    WxDCOverlay.delete o;
    raise e

let wxDCOverlayDefault win dc f =
  let o = WxDCOverlay.createDefault win dc in
  try
    let res = f o in
    WxDCOverlay.delete o;
    res
  with e ->
    WxDCOverlay.delete o;
    raise e

let wxPen = WxPen.create
let wxPenColour = WxPen.createColour

let wxRectPoints (x,y) (xx,yy) =
  let (x0,x1,true) | (x1, x0, false) = (x, xx, x < yy) in
  let (y0,y1,true) | (y1, y0, false) = (y,yy, y < yy) in
  (x0,y0, x1-x0, y1-y0)

let ignore_int (_ : int) = ()
let ignore_bool (_ : bool) = ()
let ignore_option (_ : 'a option) = ()

let ignore_wxStatusBar (_ : wxStatusBar) = ()
let ignore_wxColour (_ : wxColour) = ()
let ignore_wxFrame (_ : wxFrame) = ()
let ignore_wxDialog (_ : wxDialog) = ()

let wxDefaultPosition = (-1,-1)
let wxDefaultSize = (-1,-1)
let wxDefaultDateTime = WxDateTime.createEmpty ()


module WxOCP = struct
  let wxButton win id =
    wxButton win id ""

  let wxGetSingleChoiceIndex msg caption choices =
    let array = WxArrayString.create () in
    Array.iter (fun s -> ignore_int (WxArrayString.add array s)) choices;
    wxGetSingleChoiceIndex msg caption array None
      wxDefaultCoord wxDefaultCoord true wxCHOICE_WIDTH wxCHOICE_HEIGHT
      0

end

external wxOCamlInit_c : unit -> unit = "wxOCaml_init_ml"
let _ = wxOCamlInit_c ()

let wxMain onInit =
  WxApp.wxEntry onInit Sys.argv


type wxSizerFlags =
  | Proportion of int
  | Expand
  | Align of int
  | Center | Centre
  | Top
  | Left
  | Right
  | Bottom
  | Border
  | BorderDir of int
  | BorderSize of int
  | BorderDirSize of int * int
  | DoubleBorder
  | TripleBorder
  | HorzBorder
  | DoubleHorzBorder
  | Shaped
  | FixedMinSize
  | ReserveSpaceEvenIfHidden
  | Flag of int

module WxSizerFlags = struct

  let defaultBorder = WxSizer.getDefaultBorder()

  let wxSizerFlags f (flags : wxSizerFlags list) =
    let m_flags = ref 0 in
    let m_borderInPixels = ref 0 in
    let m_proportion = ref 0 in

    let flag flag = m_flags := !m_flags lor flag in
    let unflag flag = m_flags := !m_flags land (lnot flag) in
    let align alignment = unflag wxALIGN_MASK; flag alignment in
    let border dir border =
      m_borderInPixels := border;
      unflag wxALL; flag dir
    in
    List.iter (function
      | Proportion n -> m_proportion := n
      | Expand -> flag wxEXPAND
      | Align alignment -> align alignment
      | Flag f -> flag f
      | Centre | Center -> align  wxALIGN_CENTRE
      | Top -> unflag (wxALIGN_BOTTOM lor wxALIGN_CENTRE_VERTICAL)
      | Left -> unflag (wxALIGN_RIGHT lor wxALIGN_CENTRE_HORIZONTAL);
      | Right -> unflag wxALIGN_CENTRE_HORIZONTAL; flag wxALIGN_RIGHT
      | Bottom -> unflag wxALIGN_CENTRE_VERTICAL; flag wxALIGN_BOTTOM
      | Border -> border wxALL defaultBorder
      | BorderDir dir -> border dir defaultBorder
      | BorderSize size -> border wxALL size
      | BorderDirSize (dir, size) -> border dir size
      | DoubleBorder -> border wxALL (2 * defaultBorder)
      | TripleBorder -> border wxALL (3 * defaultBorder)
      | HorzBorder -> border (wxLEFT lor wxRIGHT) defaultBorder
      | DoubleHorzBorder -> border (wxLEFT lor wxRIGHT) (2*defaultBorder)
      | Shaped -> flag wxSHAPED
      | FixedMinSize -> flag wxFIXED_MINSIZE
      | ReserveSpaceEvenIfHidden -> flag wxRESERVE_SPACE_EVEN_IF_HIDDEN

    ) flags;

    f !m_proportion !m_flags !m_borderInPixels None

  let addSizer sizer sizer_arg flags =
    wxSizerFlags (WxSizer.addSizer sizer sizer_arg) flags

  let addWindow sizer win_arg flags =
    wxSizerFlags (WxSizer.addWindow sizer win_arg) flags

  let add sizer x y flags =
    wxSizerFlags (WxSizer.add sizer x y) flags

end

module MENU_BAR = struct
  type menu_item =
    | Append of int * string
    | Append2 of int * string * string
    | AppendSeparator of unit
    | AppendCheckItem of int * string
    | AppendCheckItem2 of int * string * string
    | Check of int * bool
    | Enable of int * bool
    | AppendSub of int * string * menu_item list
    | AppendSubHelp of int * string * menu_item list * string

  let rec make_wxMenu items =
    let menu = wxMenu "" 0 in
    List.iter (fun option ->
      match option with
        Append (id, txt) ->
        WxMenu.append menu id txt "" wxITEM_NORMAL
      | Append2 (id, t1, t2) ->
        WxMenu.append menu id t1 t2 wxITEM_NORMAL
      | AppendSeparator _ ->
        WxMenu.appendSeparator menu
      | AppendCheckItem (id, t1) ->
        WxMenu.appendCheckItem menu id t1 ""
      | AppendCheckItem2 (id, t1, t2) ->
        WxMenu.appendCheckItem menu id t1 t2
      | Check (id, bool) ->
        WxMenu.check menu id bool
      | Enable (id, bool) ->
        WxMenu.enable menu id bool
      | AppendSub (id, name, items) ->
        WxMenu.appendSub menu id name (make_wxMenu items) ""
      | AppendSubHelp (id, name, items, help) ->
        WxMenu.appendSub menu id name (make_wxMenu items) help
    ) items;
    menu

  let wxFrame frame menus =
    (* now append the freshly created menu to the menu bar... *)
    let menuBar = wxMenuBar 0 in
    List.iter (fun (name, menu) ->
      ignore_bool (WxMenuBar.append menuBar (make_wxMenu menu) name)
    ) menus;
    WxFrame.setMenuBar frame menuBar
end


module MakeSIZER(S : sig
      val dir : int
    end) = struct

  type sizer = (wxSizer * sizer_content list)
  and sizer_content =
    | AddWindow of  wxSizerFlags list * wxWindow
    | Add2 of int * int
    | Add3 of int * int * int
    | Add4 of int * int * int * int
    | Add5 of int * int * int * int * int
    | Add of int * int * int * int * int * wxObject option
    | AddSpacer of int
    | AddSizer of  wxSizerFlags list * wxSizer * sizer_content list
    | AddWrapSizer of  wxSizerFlags list * wxWrapSizer * sizer_content list
    | AddBoxSizer of  wxSizerFlags list * wxBoxSizer * sizer_content list
    | AddStaticBoxSizer of
        wxSizerFlags list * wxStaticBoxSizer * sizer_content list

    | Vertical of wxSizerFlags list * sizer_content list
    | Horizontal of wxSizerFlags list * sizer_content list
    | Text of wxSizerFlags list * string * WxStaticText.property list

  let wxBoxSizer v = WxBoxSizer.wxSizer (wxBoxSizer v)
  let wxStaticBoxSizer x y = WxStaticBoxSizer.wxSizer (wxStaticBoxSizer x y)
  let wxStaticBoxSizerEx x y z = WxStaticBoxSizer.wxSizer (wxStaticBoxSizerEx x y z)
  let wxWrapSizer x y = WxWrapSizer.wxSizer (wxWrapSizer x y)

  let wxWindow m_panel fit items =
    let sizer = WxBoxSizer.create S.dir in
    let sizer = WxBoxSizer.wxSizer sizer in
    let rec add_items sizer items =
      match items with
      [] -> ()
      | item :: items ->
        add_item sizer item;
        add_items sizer items

    and add_item sizer item =
          match item with
          | AddWindow (flags, window) ->
            WxSizerFlags.addWindow sizer window flags
          | AddSpacer space ->
            WxSizer.addSpacer sizer space
          | Add2 (a,b) ->
            WxSizer.add sizer a b 0 0 0 None
          | Add3 (a,b,c) ->
            WxSizer.add sizer a b c 0 0 None
          | Add4 (a,b,c,d) ->
            WxSizer.add sizer a b c d 0 None
          | Add5 (a,b,c,d,e) ->
            WxSizer.add sizer a b c d e None
          | Add (a,b,c,d,e,f) ->
            WxSizer.add sizer a b c d e f
          | AddSizer (flags, sizer_in, items_in) ->
            add_items sizer_in items_in;
            WxSizerFlags.addSizer sizer sizer_in flags
          | AddWrapSizer (flags, sizer_in, items_in) ->
            let sizer_in = WxWrapSizer.wxSizer sizer_in in
            add_items sizer_in items_in;
            WxSizerFlags.addSizer sizer sizer_in flags
          | AddBoxSizer (flags, sizer_in, items_in) ->
            let sizer_in = WxBoxSizer.wxSizer sizer_in in
            add_items sizer_in items_in;
            WxSizerFlags.addSizer sizer sizer_in flags
          | AddStaticBoxSizer (flags, sizer_in, items_in) ->
            let sizer_in = WxStaticBoxSizer.wxSizer sizer_in in
            add_items sizer_in items_in;
            WxSizerFlags.addSizer sizer sizer_in flags
          | Text (flags, text, properties) ->
            WxSizerFlags.addWindow sizer
              (WxStaticText.wxWindow (
                 (WxStaticText.set
                    (WxStaticText.create m_panel wxID_ANY text)
                    properties))) flags
          | Vertical (flags, items_in) ->
            let sizer_in = WxBoxSizer.create wxVERTICAL in
            let sizer_in = WxBoxSizer.wxSizer sizer_in in
            add_items sizer_in items_in;
            WxSizerFlags.addSizer sizer sizer_in flags
          | Horizontal (flags, items_in) ->
            let sizer_in = WxBoxSizer.create wxHORIZONTAL in
            let sizer_in = WxBoxSizer.wxSizer sizer_in in
            add_items sizer_in items_in;
            WxSizerFlags.addSizer sizer sizer_in flags
    in
    add_items sizer items;
    if fit then
      WxWindow.setSizerAndFit m_panel sizer true
    else
      WxWindow.setSizer m_panel sizer

  let wxDialog m_panel fit sizers =
    wxWindow (WxDialog.wxWindow m_panel) fit sizers
  let wxPanel m_panel fit sizers =
    wxWindow (WxPanel.wxWindow m_panel) fit sizers
  let wxFrame m_panel fit sizers =
    wxWindow (WxFrame.wxWindow m_panel) fit sizers
end

module HSIZER = MakeSIZER(struct let dir = wxHORIZONTAL end)
module VSIZER = MakeSIZER(struct let dir = wxVERTICAL end)

let wxSWISS_FONT () = WxStockGDI.getFont wxStockGDI_FONT_SWISS

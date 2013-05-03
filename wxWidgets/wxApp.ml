open WxClasses

external main : 
   ('a -> unit) -> (string array) -> 
      unit = "wxApp_Main_c"


external setTopWindow : 
   wxWindow -> 
      unit = "wxApp_SetTopWindow_c"


(* Methods inherited from parents, if any *)

external connect : wxApp ->
   int -> ('a WxEVT.t) -> ('a -> unit) -> 
      unit = "wxEvtHandler_Connect_c"


external disconnect : wxApp ->
   int -> int -> int -> wxObject option -> 
      int = "wxEvtHandler_Disconnect_c"


external setEvtHandlerEnabled : wxApp ->
   bool  -> 
      unit = "wxEvtHandler_SetEvtHandlerEnabled_c"


external getEvtHandlerEnabled : wxApp ->
   bool  = "wxEvtHandler_GetEvtHandlerEnabled_c"


external processEvent : wxApp ->
   wxEvent -> 
      bool  = "wxEvtHandler_ProcessEvent_c"


external addPendingEvent : wxApp ->
   wxEvent -> 
      unit = "wxEvtHandler_AddPendingEvent_c"


external processPendingEvents : wxApp ->
   unit = "wxEvtHandler_ProcessPendingEvents_c"


(* Cast functions to parents *)

external wxAppConsole : wxApp -> wxAppConsole = "%identity"

external wxEvtHandler : wxApp -> wxEvtHandler = "%identity"

external wxObject : wxApp -> wxObject = "%identity"

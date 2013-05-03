open WxClasses

(* Methods inherited from parents, if any *)

external getEventObject : wxIdleEvent ->
   wxObject option = "wxEvent_GetEventObject_c"


external getEventType : wxIdleEvent ->
   int = "wxEvent_GetEventType_c"


external getEventCategory : wxIdleEvent ->
   int = "wxEvent_GetEventCategory_c"


external getId : wxIdleEvent ->
   int = "wxEvent_GetId_c"


external getSkipped : wxIdleEvent ->
   bool  = "wxEvent_GetSkipped_c"


external getTimestamp : wxIdleEvent ->
   int = "wxEvent_GetTimestamp_c"


(* Cast functions to parents *)

external wxEvent : wxIdleEvent -> wxEvent = "%identity"

external wxObject : wxIdleEvent -> wxObject = "%identity"

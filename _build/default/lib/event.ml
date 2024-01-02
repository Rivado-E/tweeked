module Event = struct
  type t = {
    event_id: int;
    calendar_id:string;
    title:string;
    description:string;
    start_time: string;
    end_time: string;
    recurrence_info:string;
    reminder_settings:string;
  }

  let yojson_of_t t = `Assoc [ "event_id", `Int t.event_id; "calendar_id", `String t.calendar_id; "title", `String t.title; "description", `String t.description; "start_time", `String t.start_time; "end_time", `String t.end_time; "recurrence_info", `String t.recurrence_info; "reminder_settings", `String t.reminder_settings]

  let t_of_yojson yojson =
    match yojson with
    | `Assoc [ "event_id", `Int event_id; "calendar_id", `String calendar_id; "title", `String title; "description", `String description; "start_time", `String start_time; "end_time", `String end_time; "recurrence_info", `String recurrence_info; "reminder_settings", `String reminder_settings] -> {event_id; calendar_id; title; description; start_time; end_time; recurrence_info; reminder_settings};
    | _ -> failwith "invalid event json";
  ;;
end

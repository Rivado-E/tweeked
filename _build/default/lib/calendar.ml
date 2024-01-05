module Calendar = struct
  type t = {
    calendar_id: int;
    user_id: int;
    name:string;
    color:string;
  }

  let yojson_of_t t = 
    `Assoc [ 
      "calendar_id", `Int t.calendar_id; 
      "user_id", `Int t.user_id;
      "name", `String t.name;
      "color", `string t.color
    ]

  let t_of_yojson yojson =
    match yojson with
    |`Assoc [ 
        "calendar_id", `Int calendar_id; 
        "user_id", `Int user_id;
        "name", `String name;
        "color", `String color] -> {calendar_id; user_id; name; color};
    | _ -> failwith "invalid calendar json";
end

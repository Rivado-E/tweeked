open Sqlite3
let db_name = "calendar_app.db"

module User = struct
  type t = {
    (* id: int; *)
    username:string;
    email:string;
    password_hash:string;
  }

  let yojson_of_t t = `Assoc [
                        (* "id", `Int t.id;  *)
                        "username", `String t.username;
                        "email", `String t.email;
                        "password_hash", `String t.password_hash
                      ]

  let t_of_yojson yojson =
    match yojson with
    |  `Assoc [
          (* ("id", `Int id); *)
          ("username", `String username); 
          ("email", `String email); 
          ("password_hash", `String password_hash)
        ] -> {username; email; password_hash};
    | _ -> failwith "invalid user json";
  ;;
end
let add_user username email password_hash =
  let module U = User in
  let db = db_open db_name in
  let query =
    Printf.sprintf "INSERT INTO users (username, email, password_hash) VALUES ('%s', '%s', '%s');"
      username email password_hash
  in
  let res = exec db query in
  match res with
  |Rc.OK -> db_close db, true
  |_-> db_close db, false
;;

let get_user_by_username username =
  let db = db_open db_name in
  let query = Printf.sprintf "SELECT * FROM users WHERE username = '%s';" username in
  let stmt = prepare db query in

  match step stmt with
  | Rc.ROW ->
    (* let id = column_int stmt 0 in *)
    let username = column_text stmt 1 in
    let email = column_text stmt 2 in
    let password_hash = column_text stmt 3 in
    db_close db, Some {User.username; email; password_hash } 
  | _ -> db_close db, None

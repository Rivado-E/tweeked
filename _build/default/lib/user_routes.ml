open Opium
open User


let user_create req = 
  let open Lwt.Syntax in
  let open Lwt.Infix in
  let%lwt body = Request.to_json_exn req in
  let user = User.t_of_yojson json in 
  Logs.info (fun m -> m "Received user: %s" user.username);
  let _, res = add_user user.username user.email user.password_hash in 
  if res then Response.of_json (`Assoc ["message", `String "User saved"])
  else Response.of_plain_text ("Failed to save the user :-(")
;;

let retrive_user req = 
  let open Lwt.Syntax in 
  let+ json  = Request.to_json_exn req in 
  let user = User.t_of_yojson json in 
  Logs.info (fun m -> m "Received request for user: %s" user.username);
  let db_res = get_user_by_username user.username  in 
  match db_res with
  |_, Some (u) -> Lwt.return (Response.of_json (User.yojson_of_t u));
  |_, None -> Lwt.return (Response.of_plain_text "User not found");
;;

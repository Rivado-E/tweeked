open Opium
open Tweeked
open Logs
let hello _req =  Response.of_plain_text "Hello world" |> Lwt.return;; 

let () = 
  set_level (Some Info);
  set_reporter (format_reporter ());
  Logs.info (fun m -> m "Logger configured");
  App.empty
  |> App.port 3141
  |> App.middleware Middleware.logger
  |> App.post "/user/create" User_routes.user_create
  |> App.get "/" hello
  |> App.run_command
  |> ignore

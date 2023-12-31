[@@@ocaml.warning "-32-27-33"]
open Sqlite3
open Printf

let create_connection () = 
  let db = db_open "mydatabase.db" in
  db;;

let handle_exception res = 
  if Rc.is_success res  then "Done!" else Rc.to_string res;

(*
let main () =
  let db = create_connection () in

  (* Execute a simple SQL command to create_connectionte a table *)
  let res = exec db "CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY, name TEXT NOT NULL)" in print_endline handle_exception res; 

  (* Insert data into the table *)
  let res = db "INSERT INTO users (name) VALUES ('John Doe')" in print_endline handle_exception res;
  (* Query the data *)
  let select_stmt = db_prepare db "SELECT * FROM users" in
  while db_step select_stmt = ROW do
    Printf.printf "User ID: %d, Name: %s\n"
      (db_column_int select_stmt 0)
      (db_column_text select_stmt 1)
  done;

  (* Close the database connection *)
  db_close db

(* Run the main function *)
let () = main ()
*)

(*this is an expection that I declared*)
exception Dummy

let create_one_table sql i db =
  try
    printf "%d %s\n%!" i sql;
    match exec db sql ~cb:(fun _ _ -> print_endline "???") with
    | Rc.OK -> ()
    | _ -> assert false
  with xcp -> print_endline (Printexc.to_string xcp);;

let rec create_n_tables db tmpl i n = if i < n then
  let scrpt = sprintf tmpl i
  in
  (create_one_table scrpt i db);
  create_n_tables db tmpl (i+1) n else ();;

let () =
  let db = db_open "this.db" in
  create_n_tables db  "CREATE TABLE TBL%d (a varchar(1), b INTEGER, c FLOAT)" 0 10;
  for i = 0 to 3 do
    let sql = sprintf "SYNTACTICALLY INCORRECT SQL STATEMENT" in
    printf "%d %s\n%!" i sql;
    try
      match exec db sql ~cb:(fun _ _ -> print_endline "???") with
      | Rc.ERROR -> printf "Identified error: %s\n" (errmsg db)
      | _ -> assert false
    with xcp -> print_endline (Printexc.to_string xcp)
  done;
  for i = 0 to 3 do
    let sql = sprintf "INSERT INTO tbl%d VALUES ('a', 3, 3.14)" i in
    printf "%d %s\n%!" i sql;
    try
      match exec db sql ~cb:(fun _ _ -> print_endline "???") with
      | Rc.OK -> printf "Inserted %d rows\n%!" (changes db)
      | _ -> assert false
    with xcp -> print_endline (Printexc.to_string xcp)
  done;
  let sql = sprintf "SELECT * FROM tbl0" in
  for _i = 0 to 3 do
    try
      print_endline "TESTING!";
      match
        exec db sql ~cb:(fun _ _ -> print_endline "FOUND!"; raise Dummy)
      with
      | Rc.OK -> print_endline "OK"
      | _ -> assert false
    with xcp -> print_endline (Printexc.to_string xcp)
  done

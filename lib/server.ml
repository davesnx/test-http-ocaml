module Httpd = Tiny_httpd

let () =
  let server = Httpd.create () in
  let addr = Httpd.addr server in
  let port = Httpd.port server in

  let handler _req = Httpd.Response.make_string (Ok "Hi") in

  Httpd.set_top_handler server handler;

  match
    Httpd.run server ~after_init:(fun () ->
        Printf.printf "Listening on http://%s:%d\n%!" addr port)
  with
  | Ok () -> ()
  | Error e -> raise e

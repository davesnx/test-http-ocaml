module Httpd = Tiny_httpd

let () =
  let server = Httpd.create () in
  let addr = Httpd.addr server in
  let port = Httpd.port server in

  let route = Httpd.Route.(exact "hello" @/ return) in
  let handler _req = Httpd.Response.make_string (Ok "Hi") in

  Httpd.add_route_handler ~meth:`GET server route handler;

  match
    Httpd.run
      ~after_init:(fun () ->
        Printf.printf "Listening on http://%s:%d\n%!" addr port)
      server
  with
  | Ok () -> ()
  | Error e -> raise e

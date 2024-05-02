let fetch host =
  let reply _response () _data = Lwt.return () in
  match%lwt Http_lwt_client.request ~follow_redirect:false host reply () with
  | Ok (_resp, ()) -> Lwt.return ()
  | Error (`Msg msg) ->
      Printf.printf "error %s" msg;
      Lwt.return ()

let _ =
  let server = "http://localhost:55795" in
  let total = ref 0 in
  let batch = 50 in
  let delay = 0. in
  let until = 15_000 in

  let rec fetch_loop () =
    let batch_of_fetchers = List.init batch (fun _index -> fetch server) in
    let usage = Mem_usage.info () in
    let%lwt () = Lwt_unix.sleep delay in
    let%lwt () = Lwt.join batch_of_fetchers in
    total := !total + batch;
    let () =
      Printf.printf "mem usage %s after %d fetch\n%!"
        (Mem_usage.prettify_bytes usage.process_private_memory)
        !total
    in
    let%lwt _ = fetch server in
    if !total >= until then Lwt.return () else fetch_loop ()
  in

  Lwt_main.run (fetch_loop ())

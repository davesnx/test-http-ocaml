open Riot

let ( let* ) = Result.bind

let fetch host =
  let url = Uri.of_string host in
  let* conn = Blink.connect url in
  let req = Http.Request.make "/" in
  let* conn = Blink.request conn req () in
  let* _conn, frames = Blink.stream conn in
  match frames with
  | [ `Status _status; `Headers _headers; _ ] -> Ok ()
  | _ ->
      Printf.printf "error";
      Ok ()

let _ =
  let server = "http://localhost:55795" in
  let total = ref 0 in
  let batch = 50 in

  let make_calls _ =
    let tasks =
      List.init batch (fun _ -> Task.async (fun () -> fetch server))
    in
    Riot.sleep 0. |> ignore;
    let usage = Mem_usage.info () in
    let () =
      Printf.printf "mem usage %s after %d fetch\n%!"
        (Mem_usage.prettify_bytes usage.process_private_memory)
        !total
    in
    List.map Task.await tasks |> ignore
  in

  Riot.run @@ fun () ->
  let _ = List.init 300 make_calls in
  shutdown ()

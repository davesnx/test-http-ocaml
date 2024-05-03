let fetch host =
  let ( let* ) = Result.bind in
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
  if Array.length Sys.argv < 2 then Printf.printf "\nUsage: <server>\n"
  else
    let server = Array.get Sys.argv 1 in
    let total = ref 0 in
    let batch = 10 in
    let until = 100 in
    let rec fetch_loop () =
      let tasks =
        List.init batch (fun _ -> Riot.Task.async (fun () -> fetch server))
      in
      let usage = Mem_usage.info () in
      List.iter (fun t -> Riot.Task.await t |> ignore) tasks;
      total := !total + batch;
      Printf.printf "mem usage %s after %d fetch\n%!"
        (Mem_usage.prettify_bytes usage.process_private_memory)
        !total;
      if !total >= until then Riot.shutdown () else fetch_loop ()
    in

    Riot.run @@ fun () -> fetch_loop ()

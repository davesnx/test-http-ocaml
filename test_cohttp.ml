let fetch ~sw client host () =
  let resp, _body = Cohttp_eio.Client.get ~sw client host in
  if Http.Status.compare resp.status `OK = 0 then ()
  else
    Printf.printf "Error: %s\n%!" (resp.status |> Cohttp.Code.string_of_status);
  ()

let () =
  if Array.length Sys.argv < 2 then Printf.printf "\nUsage: <server>\n"
  else
    let server = Array.get Sys.argv 1 in
    let total = ref 0 in
    let batch = 10 in
    let delay = 1.0 in
    let until = 1000 in

    let rec fetch_loop ~sw env client url =
      let batch_of_fetchers = List.init batch (fun _ -> fetch ~sw client url) in
      let usage = Mem_usage.info () in
      Eio.Time.sleep env#clock delay;
      Eio.Fiber.List.iter (fun f -> f ()) batch_of_fetchers;
      total := !total + batch;
      Printf.printf "mem usage %s after %d fetch\n%!"
        (Mem_usage.prettify_bytes usage.process_private_memory)
        !total;

      if !total >= until then exit 0 else fetch_loop ~sw env client url
    in

    Eio_main.run (fun env ->
        let url = Uri.of_string server in
        let client = Cohttp_eio.Client.make ~https:None env#net in
        Eio.Switch.run (fun sw -> fetch_loop ~sw env client url))

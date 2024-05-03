let fetch ~sw env url () =
  let config = Piaf.Config.default in
  match Piaf.Client.Oneshot.get ~config ~sw env (Uri.of_string url) with
  | Ok _response -> ()
  | Error e -> failwith (Piaf.Error.to_string e)

let () =
  let Env.{ server; batch; until; delay = _ } = Env.setup_env Sys.argv in
  let total = ref 0 in
  let rec fetch_loop env ~sw =
    let batch_of_fetchers = List.init batch (fun _ -> fetch ~sw env server) in
    let usage = Mem_usage.info () in
    Eio.Fiber.List.iter (fun f -> f ()) batch_of_fetchers;
    total := !total + batch;
    Printf.printf "mem usage %s after %d fetch\n%!"
      (Mem_usage.prettify_bytes usage.process_private_memory)
      !total;
    if !total >= until then exit 0 else fetch_loop env ~sw
  in

  Eio_main.run (fun env -> Eio.Switch.run (fun sw -> fetch_loop env ~sw))

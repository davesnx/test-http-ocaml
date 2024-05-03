open Piaf

let fetch ~sw env url () =
  match Client.Oneshot.get ~sw env (Uri.of_string url) with
  | Ok _response -> ()
  | Error e -> failwith (Error.to_string e)

let () =
  if Array.length Sys.argv < 2 then Printf.printf "\nUsage: <server>\n"
  else
    let server = Array.get Sys.argv 1 in
    let total = ref 0 in
    let batch = 10 in
    let until = 1000 in

    let rec fetch_loop env ~sw =
      let batch_of_fetchers = List.init batch (fun _ -> fetch ~sw env server) in
      let usage = Mem_usage.info () in
      Eio.Fiber.List.iter (fun f -> f ()) batch_of_fetchers;
      (* Eio.Time.sleep env#clock delay; *)
      total := !total + batch;
      Printf.printf "mem usage %s after %d fetch\n%!"
        (Mem_usage.prettify_bytes usage.process_private_memory)
        !total;
      if !total >= until then () else fetch_loop env ~sw
    in

    Eio_main.run (fun env -> Eio.Switch.run (fun sw -> fetch_loop env ~sw))

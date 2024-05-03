open Cohttp_eio

let fetch ~sw client host () =
  let url = Uri.of_string host in
  let _resp, _body = Client.get ~sw client url in
  ()

let () =
  if Array.length Sys.argv < 2 then Printf.printf "\nUsage: <server>\n"
  else
    let server = Array.get Sys.argv 1 in
    let total = ref 0 in
    let batch = 50 in
    let until = 15_000 in

    let rec fetch_loop ~sw env client =
      let batch_of_fetchers =
        List.init batch (fun _ -> fetch ~sw client server)
      in
      let usage = Mem_usage.info () in
      Eio.Fiber.List.iter (fun f -> f ()) batch_of_fetchers;
      total := !total + batch;
      Printf.printf "mem usage %s after %d fetch\n%!"
        (Mem_usage.prettify_bytes usage.process_private_memory)
        !total;

      if !total >= until then () else fetch_loop env client ~sw
    in
    Eio_main.run (fun env ->
        let client = Client.make ~https:None env#net in
        Eio.Switch.run (fun sw -> fetch_loop ~sw env client))

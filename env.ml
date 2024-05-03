type _ env = Float : float -> float env | Int : int -> int env

let get_env_default (type a) (name : string) (default : a env) : a =
  match default with
  | Int value -> (
      match Sys.getenv_opt name with Some v -> int_of_string v | None -> value)
  | Float value -> (
      match Sys.getenv_opt name with
      | Some v -> float_of_string v
      | None -> value)

type setup = { server : string; batch : int; delay : float; until : int }

let setup_env argv =
  if Array.length argv < 2 then failwith "\nUsage: <server>\n"
  else
    {
      server = Array.get argv 1;
      batch = get_env_default "BATCH" (Int 10);
      delay = get_env_default "DELAY" (Float 1.0);
      until = get_env_default "TIMES" (Int 1000);
    }

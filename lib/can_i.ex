defmodule CanI do
  require Jason
  
  def load_configs(path) do
    File.read!(path) |> Jason.decode!
  end
  
  defp dotify(object, prefix, results) do
    final_res = for k <- Map.keys(object) do
      new_one = if prefix == "", do: k, else: "#{prefix}.#{k}"
      [new_one] ++ dotify(object[k], new_one, results)
    end
    
    List.flatten final_res
  end
  
  defp is_role?(configs, role) do
    role in dotify(configs["roles"], "", [])
  end
  
  defp is_permission?(configs, permission) do
    permission in configs["permissions"]
  end
  
  defp is_subsystem?(configs, subsystem) do
    subsystem in dotify(configs["subsystems"], "", [])
  end
  
  defp dot_items_matching?(i1, i2) do
    i1 == i2 || String.starts_with?(i1, "#{i2}.") # with a dot after
  end
  
  defp has_ability_to?(configs, role, permission, subsystem) do
    abilities = configs["abilities"]
    
    Enum.find(Map.keys(abilities), fn r -> 
      Enum.find(abilities[r], fn a -> 
        permission in a["permissions"] && dot_items_matching?(role, r) && dot_items_matching?(subsystem, a["subsystem"])
      end)
    end)
  end
  
  def do?(configs, role, permission, subsystem) do
    cond do
      ! is_role?(configs, role) -> {:error, "invalid role"}
      ! is_permission?(configs, permission) -> {:error, "invalid permission"}
      ! is_subsystem?(configs, subsystem) -> {:error, "invalid subsystem"}
      true -> {:ok, has_ability_to?(configs, role, permission, subsystem) != nil}
    end
  end
end

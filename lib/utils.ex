defmodule Abento.Utils do
  def get_hash(s) do
    :crypto.hash(:md5, s) |> Base.encode16() |> String.downcase()
  end
end

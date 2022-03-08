defmodule Hider.Crypt.AES do
  @priv_key :hider |> Application.compile_env!([:aes, :priv_key]) |> Base.decode64!()

  def encrypt(text) do
    iv = :crypto.strong_rand_bytes(1)
    {cypher_text, tag} = :crypto.crypto_one_time_aead(:aes_256_gcm, @priv_key, iv, text, "", true)

    Base.encode64(tag <> iv <> cypher_text)
  end

  def decrypt(text) do
    text = Base.decode64!(text)
    <<tag::binary-size(16), iv::binary-size(1), cypher_text::binary()>> = text
    :crypto.crypto_one_time_aead(:aes_256_gcm, @priv_key, iv, cypher_text, "", tag, false)
  end
end

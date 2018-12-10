defmodule DnsEx.Server do
  @behaviour DNS.Server
  use DNS.Server

  require Logger

  def handle(record, _cl) do
    query = hd(record.qdlist)
    Logger.info(fn -> "#{query.domain}" end)

    # We allow the *client* to tweak the response, by passing values in the query.
    # For example, delay-1000.ttl-5.foobar.com results in a delay of 1000ms,
    # a TTL of 5, and a (default) response of 127.0.0.1

    result =
      case query.type do
        :a -> {127, 0, 0, 1}
      end

    resource = %DNS.Resource{
      domain: query.domain,
      class: query.class,
      type: query.type,
      ttl: 0,
      data: result
    }

    labels = String.split(List.to_string(query.domain), ".")
    resource = List.foldl(labels, resource, &apply_option/2)

    %{record | header: %{record.header | qr: true}, anlist: [resource]}
  end

  defp apply_option(_label = "delay-" <> ms, resource) do
    :timer.sleep(String.to_integer(ms))
    resource
  end

  defp apply_option(_label = "ttl-" <> sec, resource) do
    %{resource | ttl: String.to_integer(sec)}
  end

  defp apply_option(_label, resource) do
    resource
  end
end

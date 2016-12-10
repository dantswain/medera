defmodule Medera.Connector do
  @moduledoc ""
  alias Slack.Bot
  alias Medera.MessageProducer

  use Slack

  def send_message(msg, channel) do
    send(__MODULE__, {:send_message, msg, channel})
  end

  def start_link(token) do
    IO.puts("HI #{inspect token}")
    Bot.start_link(__MODULE__, [], token, %{name: __MODULE__})
  end

  def respond_to({message, slack}) do
    IO.puts("??? #{inspect message}")
    if message.text == "Hi" do
      send_message("Sup?", message.channel, slack)
    end
  end

  def handle_event(message = %{type: "message"}, slack, state) do
    IO.puts("??? #{inspect message}")
    MessageProducer.sync_notify(self(), {message, slack})
    {:ok, state}
  end
  def handle_event(_, _, state), do: {:ok, state}

  def handle_info({:send_message, msg, channel}, slack, state) do
    send_message(msg, channel, slack)
    {:ok, state}
  end
end

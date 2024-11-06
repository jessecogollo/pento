defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view
  # alias Pento.Accounts

  def generate_winner_number() do
    :rand.uniform(10)
  end

  def mount(_params, session, socket) do
    # user = Accounts.get_user_by_session_token(session["user_token"])
    # generate a ramdon number between 1 to 10
    winner_number = generate_winner_number()
		{:ok, assign(
      socket,
      score: 0,
      message: "Make a guess:",
      session_id: session["live_socket_id"],
      # current_user: user,
      winner_number: winner_number,
      user_win: false
    )}
	end

  def handle_params(_params, _uri, socket) do
    winner_number = generate_winner_number()
    {:noreply, assign(
      socket,
      score: 0,
      message: "Make a guess:",
      winner_number: winner_number,
      user_win: false
    )}
  end

  def render(assigns) do
    ~H"""
    <%= if @user_win do %>
      <.link patch={~p"/guess"}>Reset</.link>
    <% end %>
    <br />
    <h1 class="mb-4 text-4xl font-extrabold">your Score: <%= @score %></h1>
    <h2>
      <%= @message %>
      It's time <%= time() %>
      <%= @winner_number %>
    </h2>
    <br />
    <h2>
      <%= for n <- 1..10 do %>
        <.link class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 border border-blue-700 rounded m-1" phx-click="guess" phx-value-number= {n} >
          <%= n %>
        </.link>
      <% end %>
    </h2>
    <br/>
    <pre>
      <%= @current_user.email %>
      <%= @session_id %>
    </pre>
    """
  end

  def time() do
    DateTime.utc_now |> to_string
  end

  def handle_event("guess", %{"number" => guess}, socket) do
    if socket.assigns.winner_number == String.to_integer(guess) do
      message = "you win !!!"
      score = socket.assigns.score + 1
      {
        :noreply,
        assign(
          socket,
          message: message,
          score: score,
          user_win: true
        )
      }
    else
      message = "Your guess: #{guess}. Wrong. Guess again.  "
      score = socket.assigns.score - 1
      {
        :noreply,
        assign(
          socket,
          message: message,
          score: score
        )
      }
    end
  end
end

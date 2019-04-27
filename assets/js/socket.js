// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// To use Phoenix channels, the first step is to import Socket,
// and connect at the socket path in "lib/web/endpoint.ex".
//
// Pass the token on params as below. Or remove it
// from the params if you are not using authentication.
import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})

// When you connect, you'll often need to authenticate the client.
// For example, imagine you have an authentication plug, `MyAuth`,
// which authenticates the session and assigns a `:current_user`.
// If the current user exists you can assign the user's token in
// the connection for use in the layout.
//
// In your "lib/web/router.ex":
//
//     pipeline :browser do
//       ...
//       plug MyAuth
//       plug :put_user_token
//     end
//
//     defp put_user_token(conn, _) do
//       if current_user = conn.assigns[:current_user] do
//         token = Phoenix.Token.sign(conn, "user socket", current_user.id)
//         assign(conn, :user_token, token)
//       else
//         conn
//       end
//     end
//
// Now you need to pass this token to JavaScript. You can do so
// inside a script tag in "lib/web/templates/layout/app.html.eex":
//
//     <script>window.userToken = "<%= assigns[:user_token] %>";</script>
//
// You will need to verify the user token in the "connect/3" function
// in "lib/web/channels/user_socket.ex":
//
//     def connect(%{"token" => token}, socket, _connect_info) do
//       # max_age: 1209600 is equivalent to two weeks in seconds
//       case Phoenix.Token.verify(socket, "user socket", token, max_age: 1209600) do
//         {:ok, user_id} ->
//           {:ok, assign(socket, :user, user_id)}
//         {:error, reason} ->
//           :error
//       end
//     end
//
// Finally, connect to the socket:
socket.connect()

// Now that you are connected, you can join channels with a topic:
let channel = socket.channel("room:public", {})
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

export default socket

let pair = $("#pair")

channel.on("current_pair", payload => {
	$("#scan_count").html(payload.scan_count);
	pair.html(payload.pair);
})

channel.on("new_record", payload => {
	console.log(payload.record.profit);
	$('#record').html(payload.record.profit);
})

channel.on("arbitrage_signal", payload => {
console.log(payload);
let row = $('<tr><td class="pd-l-20"><a href="' + payload.result.buy_link + '" target="_blank"><img src="/img/' + payload.result.buy_from + '.png" class="wd-55" alt="Image"></a></td><td class="pd-l-20"><a href="' + payload.result.sell_link + '" target="_blank"><img src="/img/' + payload.result.sell_to + '.png" class="wd-55" alt="Image"></a></td><td class="valign-middle"><h3>' + payload.result.asset + ' - ' + payload.result.base + '</h3></td><td><a href="" class="tx-inverse tx-14 tx-medium d-block">' + payload.summary + '</a>' 
                        + '<span class="tx-11 d-block"><span class="square-8 bg-success mg-r-5 rounded-circle"></span> ' + payload.result.profit + ' ' + payload.result.base +'</span>'
                      + '</td><td class="valign-middle tx-right">' + payload.result.buy_price + '</td><td class="valign-middle tx-right">' + payload.result.sell_price + '</td>'
                      + '<td class="valign-middle tx-right">' + payload.result.profit + ' ' + payload.result.base + '</td>'                             
                      + '<td class="valign-middle"><span class="tx-success"><i class="icon ion-android-arrow-up mg-r-5"></i>' + payload.result.gain + '%</span></td>'
                      + '<td class="valign-middle tx-center">'+ payload.date +'</td>'
                    + '</tr>').hide();
	$('#arbitrage').prepend($(row));
	$(row).fadeIn("slow");
	var rowCount = $('#arbitrage tr').length;

	if (rowCount > 31 ) {
		$('#arbitrage tr:last').remove();
	}

	// $('#count').html(payload.count);
})

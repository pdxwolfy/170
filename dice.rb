require 'socket'

def parse_request(request_string)
  httpd_method, path_and_query, _ = request_string.split ' ', 3
  path, query_params = path_and_query.split '?', 2
  params = Hash[query_params.split('&').map { |param| param.split '=' }]
  [httpd_method, path, params]
end

def render_html(client, method, path, params, block)
  client.puts 'HTTP/1.0 200 OK'
  client.puts 'Content-Type: text/html'
  client.puts
  client.puts '<!DOCTYPE html>'
  client.puts '<html>'
  client.puts '<body>'
  block.call method, path, params
  client.puts '</body>'
  client.puts '</html>'
end

def process_client(client, request_line, &block)
  httpd_method, path, params = parse_request request_line
  render_html client, httpd_method, path, params, block
  client.close
end

server = TCPServer.new 'localhost', 31_133
loop do
  client = server.accept
  request_line = client.gets or next

  process_client(client, request_line) do |_, _, params|
    roll = params['roll'].to_i
    sides = params['sides'].to_i
    client.puts '<h1>Rolls!</h1>'
    roll.times.map { client.puts "<p>#{1 + rand(sides)}</p>" }
  end
end

